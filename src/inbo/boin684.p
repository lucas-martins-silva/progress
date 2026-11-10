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
{include/i-prgvrs.i BOIN684 2.00.00.046 } /*** "010046" 12/09/2026 21:26:00 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin684 MUT}
&ENDIF

{cdp/cdcfgmat.i}
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */


/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName item-uni-estab
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName item-uni-estab
&GLOBAL-DEFINE TableLabel item-uni-estab
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1             it-codigo
&GLOBAL-DEFINE KeyField2             cod-estabel
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/

{inbo/boin684.i RowObject}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
/* {method/dboqry.i} */

/*--- Definicao da tt-epc ---*/
{include/i-epc200.i BOIN684}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

&if "{&bf_mat_versao_ems}" >= "2.062" &then
{inbo/boin745.i1}
DEFINE VARIABLE h-boin745   AS HANDLE  NO-UNDO.
DEFINE VARIABLE l-comp-uneg AS LOGICAL NO-UNDO.
&endif

def var c-it-codigo-ini   as char no-undo.
def var c-it-codigo-fim   as char no-undo.
def var c-cod-estabel-ini as char no-undo.
def var c-cod-estabel-fim as char no-undo.
def var c-campos-alterados  as char no-undo.

DEF VAR i-index AS INTEGER NO-UNDO.

&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /* Integraá∆o EMS EAI2.0 Mensagem unica */
    DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.
    DEFINE VARIABLE h-cdapi998 AS HANDLE NO-UNDO. 
&ENDIF

/************************************************************************
 * TECNICA DE SEGURANÄA POR ESTABELECIMENTO
 ************************************************************************/
{include/i-estab-security.i}
/************************************************************************
 * TECNICA DE SEGURANÄA POR ESTABELECIMENTO
 ************************************************************************/

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 26.79
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    IF  VALID-HANDLE(h-boin745) THEN DO:
        DELETE PROCEDURE h-boin745.
        ASSIGN h-boin745 = ?.
    END.
    &endif
    
    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
       IF VALID-HANDLE(h-cdapi998) AND
            h-cdapi998:TYPE = "PROCEDURE":U AND
            h-cdapi998:FILE-NAME = "cdp/cdapi998.p":U THEN DO:
            DELETE PROCEDURE h-cdapi998 NO-ERROR.
            ASSIGN h-cdapi998 = ?.
        END.            
   &ENDIF  

    RETURN "OK":U.
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
    
    def var i-situacao  as int  extent 2    no-undo.
    DEF VAR l-cd0140    AS LOGICAL NO-UNDO.
    DEF VAR l-exec-eai2 AS LOGICAL NO-UNDO.
    DEF VAR i-cont      AS INTEGER NO-UNDO.

    DO i-cont = 1 TO 4:
        IF PROGRAM-NAME(i-cont) MATCHES("*cd0140*") THEN DO:
             ASSIGN l-cd0140 =YES
                    l-exec-eai2 =YES.
             LEAVE.
        END.
        IF PROGRAM-NAME(i-cont) MATCHES("*cq0124*") THEN DO:
             ASSIGN l-exec-eai2 =YES.
             LEAVE.
        END.
        IF PROGRAM-NAME(i-cont) MATCHES("*ce0330*") THEN DO:
             ASSIGN l-exec-eai2 =YES.
             LEAVE.
        END.
        IF PROGRAM-NAME(i-cont) MATCHES("*cs0102*") THEN DO:
             ASSIGN l-exec-eai2 =YES.
             LEAVE.
        END.
    END.

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    EMPTY TEMP-TABLE tt-item-un-negoc.
    IF NOT l-cd0140 THEN DO:
        IF l-comp-uneg THEN DO:
            CREATE tt-item-un-negoc. 
            ASSIGN tt-item-un-negoc.it-codigo   = RowObject.it-codigo
                   tt-item-un-negoc.cod-estabel = RowObject.cod-estabel
                   tt-item-un-negoc.cod-depos   = "".
            RUN acertaUnidNegoc IN h-boin745(INPUT TABLE tt-item-un-negoc).
        END. 
    END.
    &endif
    

    &if '{&bf_mat_versao_ems}' >= '2.071' &then
    /* Atualizaá∆o das requisiá‰es (itens da requisiá∆o), que est∆o em aberto
       ou incompletas, com  novo comprador ou grupo de compras definido para
       o item e/ou fam°lia. */
       
        if  lookup("cod-comprado", c-campos-alterados)   <> 0
        or  lookup("cod-grp-compra", c-campos-alterados) <> 0 then do:
    
            assign i-situacao[1] = 1  /* Aberta */
                   i-situacao[2] = 3. /* Incompleta */
            
            do i-index = 1 to 2:
                for each it-requisicao
                    where it-requisicao.it-codigo   = RowObject.it-codigo  
                      and it-requisicao.cod-estabel = RowObject.cod-estabel
                      and it-requisicao.situacao    = i-situacao[i-index]
                      and it-requisicao.tp-requis   > 1 /* Solicitaá∆o Compra/Cotaá∆o */ exclusive-lock:
    
                    if  param-compra.int-2 = 1 then /* por grupo de compras */
                        assign it-requisicao.cod-grp-compra = RowObject.cod-grp-compra
                               it-requisicao.cod-comprado   = "".
                    else /* por comprador */
                        assign it-requisicao.cod-comprado = RowObject.cod-comprado.
                end.
            end.
        end.
    &endif
 

    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
         /** Integraá∆o EAI2 **/
                        
         IF v_log_eai2_ativado AND l-exec-eai2 THEN DO:    
            RUN pi-sendUpsert IN h-cdapi998 (INPUT RowObject.r-rowid, INPUT "Async":U, OUTPUT TABLE RowErrors).              
            IF CAN-FIND(FIRST RowErrors) THEN RETURN "NOK":U.
         END.                                  
     &ENDIF  
                  
    RETURN "OK":U.
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
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    IF  NOT VALID-HANDLE(h-boin745) THEN
        run inbo/boin745.p persistent set h-boin745.
    
    ASSIGN l-comp-uneg = NO.   
    FIND FIRST bf{&TableName} WHERE 
         ROWID(bf{&TableName}) = RowObject.r-rowid NO-LOCK NO-ERROR.
    
    IF AVAIL bf{&TableName} THEN DO:
        IF bf{&TableName}.cod-unid-negoc <> RowObject.cod-unid-negoc THEN
            ASSIGN l-comp-uneg = YES.
    END.
    
    &endif
    
    &if '{&bf_mat_versao_ems}' >= '2.071' &then
        buffer-compare RowObject using cod-comprado cod-grp-compra
            to bf{&TableName} save result in c-campos-alterados.
    &endif    
    
    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN    
        IF NOT VALID-HANDLE(h-cdapi998) OR
           h-cdapi998:TYPE <> "PROCEDURE":U OR
           h-cdapi998:FILE-NAME <> "cdp/cdapi998.p":U THEN DO:
           RUN cdp/cdapi998.p PERSISTENT SET h-cdapi998. 
        END.
        
        /* Carrega a vari†vel global v_log_eai2_ativado */
        RUN cdp/cd0101i.p. 
    &ENDIF
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindFirstMain DBOProgram 
PROCEDURE FindFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST item-uni-estab NO-LOCK NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindFirstRangeEstab DBOProgram 
PROCEDURE FindFirstRangeEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&tableName}
         where {&tableName}.cod-estabel >= c-cod-estabel-ini
           and {&tableName}.cod-estabel <= c-cod-estabel-fim
           no-lock  NO-ERROR.
   
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindFirstRangeItemEstab DBOProgram 
PROCEDURE FindFirstRangeItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   FIND FIRST {&tableName}
        where {&tablename}.it-codigo >= c-it-codigo-ini
        and   {&tablename}.it-codigo <= c-it-codigo-fim
        and   {&tableName}.cod-estabel >= c-cod-estabel-ini
        and   {&tableName}.cod-estabel <= c-cod-estabel-fim
        no-lock NO-ERROR.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindLastMain DBOProgram 
PROCEDURE FindLastMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST item-uni-estab NO-LOCK NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindLastRangeEstab DBOProgram 
PROCEDURE FindLastRangeEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

     FIND LAST {&tableName}
         where {&tableName}.cod-estabel >= c-cod-estabel-ini
           and {&tableName}.cod-estabel <= c-cod-estabel-fim
           no-lock NO-ERROR.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindLastRangeItemEstab DBOProgram 
PROCEDURE FindLastRangeItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&tableName}
        where {&tablename}.it-codigo >= c-it-codigo-ini
        and   {&tablename}.it-codigo <= c-it-codigo-fim
        and   {&tableName}.cod-estabel >= c-cod-estabel-ini
        and   {&tableName}.cod-estabel <= c-cod-estabel-fim
        no-lock NO-ERROR.
 
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextMain DBOProgram 
PROCEDURE FindNextMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND NEXT item-uni-estab NO-LOCK NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextRangeEstab DBOProgram 
PROCEDURE FindNextRangeEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     FIND NEXT {&tableName}
         where {&tableName}.cod-estabel >= c-cod-estabel-ini
           and {&tableName}.cod-estabel <= c-cod-estabel-fim
           no-lock NO-ERROR.
 
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextRangeItemEstab DBOProgram 
PROCEDURE FindNextRangeItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&tableName}
        where {&tablename}.it-codigo >= c-it-codigo-ini
        and   {&tablename}.it-codigo <= c-it-codigo-fim
        and   {&tableName}.cod-estabel >= c-cod-estabel-ini
        and   {&tableName}.cod-estabel <= c-cod-estabel-fim
        no-lock NO-ERROR.
     
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevMain DBOProgram 
PROCEDURE FindPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FIND PREV item-uni-estab NO-LOCK NO-ERROR.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevRangeEstab DBOProgram 
PROCEDURE FindPrevRangeEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     FIND PREV {&tableName}
         where {&tableName}.cod-estabel >= c-cod-estabel-ini
           and {&tableName}.cod-estabel <= c-cod-estabel-fim
           no-lock NO-ERROR.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevRangeItemEstab DBOProgram 
PROCEDURE FindPrevRangeItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&tableName}
        where {&tablename}.it-codigo >= c-it-codigo-ini
        and   {&tablename}.it-codigo <= c-it-codigo-fim
        and   {&tableName}.cod-estabel >= c-cod-estabel-ini
        and   {&tableName}.cod-estabel <= c-cod-estabel-fim
        no-lock NO-ERROR.
 
    return "OK":U.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-grp-compra":U THEN ASSIGN pFieldValue = RowObject.cod-grp-compra.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "dep-rej-cq":U THEN ASSIGN pFieldValue = RowObject.dep-rej-cq.
        WHEN "deposito-cq":U THEN ASSIGN pFieldValue = RowObject.deposito-cq.
        WHEN "deposito-pad":U THEN ASSIGN pFieldValue = RowObject.deposito-pad.
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        &if "{&bf_mat_versao_ems}" >= "2.062" &then
        WHEN "cod-unid-negoc":U THEN ASSIGN pFieldValue = RowObject.cod-unid-negoc.
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-base":U THEN ASSIGN pFieldValue = RowObject.data-base.
        WHEN "data-pr-fisc":U THEN ASSIGN pFieldValue = RowObject.data-pr-fisc.
        WHEN "data-ult-con":U THEN ASSIGN pFieldValue = RowObject.data-ult-con.
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "data-ult-rep":U THEN ASSIGN pFieldValue = RowObject.data-ult-rep.
        WHEN "data-ult-ressup":U THEN ASSIGN pFieldValue = RowObject.data-ult-ressup.
        WHEN "data-ult-sai":U THEN ASSIGN pFieldValue = RowObject.data-ult-sai.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "consumo-aad":U THEN ASSIGN pFieldValue = RowObject.consumo-aad.
        WHEN "consumo-prev":U THEN ASSIGN pFieldValue = RowObject.consumo-prev.
        WHEN "ind-cons-prv":U THEN ASSIGN pFieldValue = RowObject.ind-cons-prv.
        WHEN "lote-economi":U THEN ASSIGN pFieldValue = RowObject.lote-economi.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "vl-ggf-ant":U THEN ASSIGN pFieldValue = RowObject.vl-ggf-ant.
        WHEN "vl-mat-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mat-ant.
        WHEN "vl-mob-ant":U THEN ASSIGN pFieldValue = RowObject.vl-mob-ant.
        WHEN "vl-var-max":U THEN ASSIGN pFieldValue = RowObject.vl-var-max.
        WHEN "vl-var-min":U THEN ASSIGN pFieldValue = RowObject.vl-var-min.
        WHEN "val-fator-custo-dis":U THEN ASSIGN pFieldValue = RowObject.val-fator-custo-dis.
        WHEN "var-mob-maior":U THEN ASSIGN pFieldValue = RowObject.var-mob-maior.
        WHEN "var-mob-menor":U THEN ASSIGN pFieldValue = RowObject.var-mob-menor.
        WHEN "var-qtd-re":U THEN ASSIGN pFieldValue = RowObject.var-qtd-re.
        WHEN "var-qtd-res-fabr":U THEN ASSIGN pFieldValue = RowObject.var-qtd-res-fabr.
        WHEN "var-rep":U THEN ASSIGN pFieldValue = RowObject.var-rep.
        WHEN "var-transf":U THEN ASSIGN pFieldValue = RowObject.var-transf.
        WHEN "var-val-re-maior":U THEN ASSIGN pFieldValue = RowObject.var-val-re-maior.
        WHEN "var-val-re-menor":U THEN ASSIGN pFieldValue = RowObject.var-val-re-menor.
        WHEN "variac-acum":U THEN ASSIGN pFieldValue = RowObject.variac-acum.
        WHEN "variacao-perm":U THEN ASSIGN pFieldValue = RowObject.variacao-perm.
        WHEN "lim-var-qtd":U THEN ASSIGN pFieldValue = RowObject.lim-var-qtd.
        WHEN "lim-var-valor":U THEN ASSIGN pFieldValue = RowObject.lim-var-valor.
        WHEN "lote-multipl":U THEN ASSIGN pFieldValue = RowObject.lote-multipl.
        WHEN "lote-per-max":U THEN ASSIGN pFieldValue = RowObject.lote-per-max.
        WHEN "ponto-encomenda":U THEN ASSIGN pFieldValue = RowObject.ponto-encomenda.
        WHEN "preco-base":U THEN ASSIGN pFieldValue = RowObject.preco-base.
        WHEN "preco-fiscal":U THEN ASSIGN pFieldValue = RowObject.preco-fiscal.
        WHEN "preco-repos":U THEN ASSIGN pFieldValue = RowObject.preco-repos.
        WHEN "preco-ul-ent":U THEN ASSIGN pFieldValue = RowObject.preco-ul-ent.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "qt-min-res-fabr":U THEN ASSIGN pFieldValue = RowObject.qt-min-res-fabr.
        WHEN "qtd-batch-padrao":U THEN ASSIGN pFieldValue = RowObject.qtd-batch-padrao.
        WHEN "qtd-refer-custo-dis":U THEN ASSIGN pFieldValue = RowObject.qtd-refer-custo-dis.
        WHEN "quant-perda":U THEN ASSIGN pFieldValue = RowObject.quant-perda.
        WHEN "quant-segur":U THEN ASSIGN pFieldValue = RowObject.quant-segur.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-ponder[1]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[1].
        WHEN "fator-ponder[2]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[2].
        WHEN "fator-ponder[3]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[3].
        WHEN "fator-ponder[4]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[4].
        WHEN "fator-ponder[5]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[5].
        WHEN "fator-ponder[6]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[6].
        WHEN "fator-ponder[7]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[7].
        WHEN "fator-ponder[8]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[8].
        WHEN "fator-ponder[9]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[9].
        WHEN "fator-ponder[10]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[10].
        WHEN "fator-ponder[11]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[11].
        WHEN "fator-ponder[12]":U THEN ASSIGN pFieldValue = RowObject.fator-ponder[12].
        WHEN "fator-refugo":U THEN ASSIGN pFieldValue = RowObject.fator-refugo.
        WHEN "cap-est-fabr":U THEN ASSIGN pFieldValue = RowObject.cap-est-fabr.
        WHEN "val-aliq-icms":U THEN ASSIGN pFieldValue = RowObject.val-aliq-icms.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFormula DBOProgram 
PROCEDURE getDescFormula :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-fat-ponder  - recebe o c¢digo do Fator de Ponderaá∆o
              pc-desc-fat-ponder - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-fat-ponder   like fat-ponder.cod-fat-ponder no-undo.
    def output param pc-desc-fat-ponder  like fat-ponder.descricao      no-undo.

    for first fat-ponder fields (descricao)
        where fat-ponder.cod-fat-ponder = pc-cod-fat-ponder no-lock: end.
    
    if avail fat-ponder then
       assign pc-desc-fat-ponder = fat-ponder.descricao.    
    else do:
         assign pc-desc-fat-ponder = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescFrequencia DBOProgram 
PROCEDURE getDescFrequencia :
/*------------------------------------------------------------------------------
  Parameters: pc-cod-frequencia  - recebe o c¢digo da Frequencia
              pc-desc-frequencia - retorna a descriá∆o
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-cod-frequencia   like frequencia.cd-freq   no-undo.
    def output param pc-desc-frequencia  like frequencia.descricao no-undo.

    for first frequencia fields (descricao)
        where frequencia.cd-freq = pc-cod-frequencia no-lock: end.
    
    if avail frequencia then
       assign pc-desc-frequencia = frequencia.descricao.    
    else do:
         assign pc-desc-frequencia = "".
         return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFirstEstab DBOProgram 
PROCEDURE getFirstEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER p-r-item-estab AS ROWID.
  DEFINE BUFFER b-item-estab FOR item-uni-estab.
  DEFINE VARIABLE c-it-codigo LIKE item-uni-estab.it-codigo NO-UNDO.

  FIND b-item-estab WHERE rowid(b-item-estab) = p-r-item-estab NO-LOCK NO-ERROR.
  IF AVAIL b-item-estab THEN DO:
     ASSIGN c-it-codigo = b-item-estab.it-codigo.
     FIND PREV b-item-estab WHERE b-item-estab.it-codigo <> c-it-codigo NO-LOCK NO-ERROR.
     IF AVAIL b-item-estab THEN 
        ASSIGN p-r-item-estab = ROWID(b-item-estab).
  END.

  RETURN "OK":U.
                   
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ciclo-contag":U THEN ASSIGN pFieldValue = RowObject.ciclo-contag.
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "classif-abc":U THEN ASSIGN pFieldValue = RowObject.classif-abc.
        WHEN "cod-fat-ponder":U THEN ASSIGN pFieldValue = RowObject.cod-fat-ponder.
        WHEN "cod-obsoleto":U THEN ASSIGN pFieldValue = RowObject.cod-obsoleto.
        WHEN "contr-plan":U THEN ASSIGN pFieldValue = RowObject.contr-plan.
        WHEN "crit-cc":U THEN ASSIGN pFieldValue = RowObject.crit-cc.
        WHEN "crit-ce":U THEN ASSIGN pFieldValue = RowObject.crit-ce.
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "res-int-comp":U THEN ASSIGN pFieldValue = RowObject.res-int-comp.
        WHEN "res-min-fabri":U THEN ASSIGN pFieldValue = RowObject.res-min-fabri.
        WHEN "ressup-fabri":U THEN ASSIGN pFieldValue = RowObject.ressup-fabri.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tempo-segur":U THEN ASSIGN pFieldValue = RowObject.tempo-segur.
        WHEN "tipo-est-seg":U THEN ASSIGN pFieldValue = RowObject.tipo-est-seg.
        WHEN "tipo-lote-ec":U THEN ASSIGN pFieldValue = RowObject.tipo-lote-ec.
        WHEN "tipo-requis":U THEN ASSIGN pFieldValue = RowObject.tipo-requis.
        WHEN "tipo-sched":U THEN ASSIGN pFieldValue = RowObject.tipo-sched.
        WHEN "tp-aloc-lote":U THEN ASSIGN pFieldValue = RowObject.tp-aloc-lote.
        WHEN "tp-codigo":U THEN ASSIGN pFieldValue = RowObject.tp-codigo.
        WHEN "tp-ressup":U THEN ASSIGN pFieldValue = RowObject.tp-ressup.
        WHEN "var-tempo-res-fabr":U THEN ASSIGN pFieldValue = RowObject.var-tempo-res-fabr.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "ind-lista-csp":U THEN ASSIGN pFieldValue = RowObject.ind-lista-csp.
        WHEN "ind-lista-mrp":U THEN ASSIGN pFieldValue = RowObject.ind-lista-mrp.
        WHEN "ind-prev-demanda":U THEN ASSIGN pFieldValue = RowObject.ind-prev-demanda.
        WHEN "ind-refugo":U THEN ASSIGN pFieldValue = RowObject.ind-refugo.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "nat-despesa":U THEN ASSIGN pFieldValue = RowObject.nat-despesa.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "periodo-fixo":U THEN ASSIGN pFieldValue = RowObject.periodo-fixo.
        WHEN "perm-saldo-neg":U THEN ASSIGN pFieldValue = RowObject.perm-saldo-neg.
        WHEN "politica":U THEN ASSIGN pFieldValue = RowObject.politica.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "prioridade-aprov":U THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "res-cq-comp":U THEN ASSIGN pFieldValue = RowObject.res-cq-comp.
        WHEN "res-cq-fabri":U THEN ASSIGN pFieldValue = RowObject.res-cq-fabri.
        WHEN "res-for-comp":U THEN ASSIGN pFieldValue = RowObject.res-for-comp.
        WHEN "demanda":U THEN ASSIGN pFieldValue = RowObject.demanda.
        WHEN "div-ordem":U THEN ASSIGN pFieldValue = RowObject.div-ordem.
        WHEN "emissao-ord":U THEN ASSIGN pFieldValue = RowObject.emissao-ord.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-calc-meta":U THEN ASSIGN pFieldValue = RowObject.ind-calc-meta.
        WHEN "cd-freq":U THEN ASSIGN pFieldValue = RowObject.cd-freq.
        WHEN "cdn-sit-tribut":U THEN ASSIGN pFieldValue = RowObject.cdn-sit-tribut.
        WHEN "dias-ocioso":U THEN ASSIGN pFieldValue = RowObject.dias-ocioso.
        WHEN "perc-excesso":U THEN ASSIGN pFieldValue = RowObject.perc-excesso.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice CODIGO
  Parameters:
               retorna valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-uni-estab.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE item-uni-estab.cod-estabel NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pcod-estabel = RowObject.cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLastEstab DBOProgram 
PROCEDURE getLastEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER p-r-item-estab AS ROWID.
  DEFINE BUFFER b-item-estab FOR item-uni-estab.
  DEFINE VARIABLE c-it-codigo LIKE item-uni-estab.it-codigo NO-UNDO.

  FIND b-item-estab WHERE rowid(b-item-estab) = p-r-item-estab NO-LOCK NO-ERROR.
  IF AVAIL b-item-estab THEN DO:
     ASSIGN c-it-codigo = b-item-estab.it-codigo.
     FIND NEXT b-item-estab WHERE b-item-estab.it-codigo <> c-it-codigo NO-LOCK NO-ERROR.
     IF AVAIL b-item-estab THEN 
        ASSIGN p-r-item-estab = ROWID(b-item-estab).
  END.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "contr-qualid":U THEN ASSIGN pFieldValue = RowObject.contr-qualid.
        WHEN "conv-tempo-seg":U THEN ASSIGN pFieldValue = RowObject.conv-tempo-seg.
        WHEN "curva-abc":U THEN ASSIGN pFieldValue = RowObject.curva-abc.
        WHEN "altera-conta":U THEN ASSIGN pFieldValue = RowObject.altera-conta.
        WHEN "loc-unica":U THEN ASSIGN pFieldValue = RowObject.loc-unica.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-ad-consumo":U THEN ASSIGN pFieldValue = RowObject.log-ad-consumo.
        WHEN "log-finaliz-op":U THEN ASSIGN pFieldValue = RowObject.log-finaliz-op.
        WHEN "log-contr-ag-ia":U THEN ASSIGN pFieldValue = RowObject.log-contr-ag-ia.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice CODIGO
  Parameters:
               recebe valor dos campos do °ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-uni-estab.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE item-uni-estab.cod-estabel NO-UNDO.
    
    IF l-estab-security-active THEN DO:
        FIND FIRST bfitem-uni-estab WHERE
            bfitem-uni-estab.it-codigo = pit-codigo AND
            bfitem-uni-estab.cod-estabel = pcod-estabel AND
            CAN-FIND(FIRST {&ESTAB-SEC-TT} WHERE {&ESTAB-SEC-TT-FIELD} = bf{&TableName}.cod-estabel)
            NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        FIND FIRST bfitem-uni-estab WHERE
            bfitem-uni-estab.it-codigo = pit-codigo AND
            bfitem-uni-estab.cod-estabel = pcod-estabel
            NO-LOCK NO-ERROR.
    END.
        
    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-uni-estab THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-uni-estab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /*
    * OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    */
   &Scoped-define KEY-PHRASE TRUE NO-LOCK
   {include/i-estab-openquery.i}
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*
     * OPEN QUERY {&QueryName} FOR EACH item-uni-estab NO-LOCK INDEXED-REPOSITION.
     */
    
    &Scoped-define KEY-PHRASE TRUE NO-LOCK
    {include/i-estab-openquery.i}
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeEstab DBOProgram 
PROCEDURE openQueryRangeEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
     * open query {&queryName} for each {&tableName}
     *      where {&tableName}.cod-estabel >= c-cod-estabel-ini
     *        and {&tableName}.cod-estabel <= c-cod-estabel-fim
     *        no-lock by {&tableName}.cod-estabel indexed-reposition.
     */
    &Scoped-define KEY-PHRASE {&tableName}.cod-estabel >= c-cod-estabel-ini ~
                          and {&tableName}.cod-estabel <= c-cod-estabel-fim ~
                          no-lock by {&tableName}.cod-estabel
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangeItemEstab DBOProgram 
PROCEDURE openQueryRangeItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
     * open query {&queryName} for each {&tableName}
     *      where {&tablename}.it-codigo >= c-it-codigo-ini
     *        and {&tablename}.it-codigo <= c-it-codigo-fim
     *        and {&tableName}.cod-estabel >= c-cod-estabel-ini
     *        and {&tableName}.cod-estabel <= c-cod-estabel-fim
     *        no-lock indexed-reposition.
     */
    
    &Scoped-define KEY-PHRASE {&tablename}.it-codigo >= c-it-codigo-ini     ~
                          and {&tablename}.it-codigo <= c-it-codigo-fim     ~
                          and {&tableName}.cod-estabel >= c-cod-estabel-ini ~
                          and {&tableName}.cod-estabel <= c-cod-estabel-fim ~
                          no-lock
    {include/i-estab-openquery.i}
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangeItemEstab DBOProgram 
PROCEDURE setConstraintRangeItemEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pc-it-codigo-ini   as char no-undo.
    def input param pc-it-codigo-fim   as char no-undo.
    def input param pc-cod-estabel-ini as char no-undo.
    def input param pc-cod-estabel-fim as char no-undo.

    assign c-it-codigo-ini   = pc-it-codigo-ini
           c-it-codigo-fim   = pc-it-codigo-fim
           c-cod-estabel-ini = pc-cod-estabel-ini
           c-cod-estabel-fim = pc-cod-estabel-fim.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    /* Validacoes especificas do CE0330 centralizadas em boin684va.p. */

    IF  pType = "CREATE":U THEN DO: /* Valida se o registro j† existe... */
        IF CAN-FIND (item-uni-estab WHERE
                     item-uni-estab.it-codigo   = RowObject.it-codigo AND 
                     item-uni-estab.cod-estabel = RowObject.cod-estabel) THEN DO:
            {method/svc/errors/inserr.i
                          &ErrorNumber="58351"
                          &ErrorType="EMS"
                          &ErrorSubType="ERROR"
                          &ErrorParameters="''"}
        END.
    END.

    IF pType <> "DELETE":U THEN DO:
       find first param-compra no-lock no-error.
       if avail param-compra then do:
          if substring(param-compra.char-2,97,3) = "YES" then do:
                IF RowObject.cod-estab-gestor <> "":U THEN DO:
                    find first estabelec
                         where estabelec.cod-estabel = rowObject.cod-estab-gestor
                         no-lock no-error.        
                    if not avail estabelec then do:     
                       /* Inicio -- Projeto Internacional */
                       DEFINE VARIABLE c-lbl-liter-estabelecimento-gestor AS CHARACTER NO-UNDO.
                       {utp/ut-liter.i "Estabelecimento_Gestor" *}
                       ASSIGN c-lbl-liter-estabelecimento-gestor = TRIM(RETURN-VALUE).
                       {method/svc/errors/inserr.i &ErrorNumber="2"
                                                   &ErrorType="EMS"
                                                   &ErrorSubType="Error"
                                                   &ErrorParameters="c-lbl-liter-estabelecimento-gestor"}
                    end.
                END.
          end.
       end.   
    END.
    
    /*--- Validacao via EPC - Contratos de Venda Datasul ---*/
    FOR EACH tt-epc:
        DELETE tt-epc.
    END.            
    
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "validaCamposSclg012a":U
           tt-epc.cod-parameter = "":U
           tt-epc.val-parameter = STRING(THIS-PROCEDURE).

    {include/i-epc201.i "validaCamposSclg012a"}
    /*------------------------------------------------------*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

