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
{include/i-prgvrs.i BOIN859 2.00.00.007 } /*** "010007" 13/11/2023 11:45:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin859 MUT}
&ENDIF


/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOin859
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName movto-pend-nfe
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin859.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-chave-acesso    LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.

def var h_api_cta_ctbl       as handle no-undo.
def var h_api_ccusto         as handle no-undo.

def temp-table tt_log_erro no-undo
         field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Numero" column-label "Numero"
         field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
         field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistencia".

/* Vari·veis conta ctbl */
def var v_cod_cta_ctbl       as char   no-undo.
def var v_titulo_cta_ctbl    as char   no-undo.
def var v_num_tip_cta_ctbl   as int    no-undo.
def var v_num_sit_cta_ctbl   as int    no-undo.
def var v_ind_finalid_cta    as char   no-undo.
/* Vari†veis centro de custo */ 
def var v_cod_ccusto         as char   no-undo.
def var v_titulo_ccusto      as char   no-undo.
def var v_log_utz_ccusto     as log    no-undo.

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
         HEIGHT             = 13.38
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "ch-acesso-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.ch-acesso-comp-nfe.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice unico
  Parameters:  
               retorna valor do campo ch-acesso-comp-nfe
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE movto-pend-nfe.ch-acesso-comp-nfe NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe.

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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
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
  Purpose:     Reposiciona registro com base no °ndice unico
  Parameters:  
               recebe valor do campo ch-acesso-comp-nfe
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE movto-pend-nfe.ch-acesso-comp-nfe NO-UNDO.

    FIND FIRST bfmovto-pend-nfe WHERE 
        bfmovto-pend-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-pend-nfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-pend-nfe)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToMotvo DBOProgram 
PROCEDURE linkToMotvo :
/*------------------------------------------------------------------------------
  Purpose: Fazer o link entre movto-pend-nfe e doc-orig-nfe    
  Parameters: p-dbo-doc-orig-nfe: Handle do DBO doc-orig-nfe
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER p-dbo-doc-orig-nfe AS HANDLE NO-UNDO.
   DEFINE VARIABLE i-idi-orig-trad AS INTEGER NO-UNDO.

   ASSIGN i-idi-orig-trad = 2.

    RUN getKey IN p-dbo-doc-orig-nfe (OUTPUT c-chave-acesso,
                                      OUTPUT i-idi-orig-trad).
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query principal do DBO    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMotvo DBOProgram 
PROCEDURE openQueryMotvo :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query com base na chave de acesso do documento    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.ch-acesso-comp-nfe = c-chave-acesso NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaEmitente DBOProgram 
PROCEDURE retornaEmitente :
/*------------------------------------------------------------------------------
  Purpose: Retorna o emitente do documento     
  Parameters: p-chave-acesso: Chave de acesso do documento 
              p-cod-emitente: C¢digo do emitente
  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER p-chave-acesso AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER p-cod-emitente AS INT  NO-UNDO.
    
    FOR FIRST doc-orig-nfe FIELDS (cod-emitente)
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
          AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
    END.
    IF AVAIL doc-orig-nfe THEN
        ASSIGN p-cod-emitente = doc-orig-nfe.cod-emitente.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereContaApi DBOProgram 
PROCEDURE sugereContaApi :
/*------------------------------------------------------------------------------
  Purpose: Sugest∆o de conta cont†bil   
  Parameters: p-chave-acesso:   Chave de acesso do documento  
              p-ct-codigo: Conta cont†bil
              p-sc-codigo: Subconta
  
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST RowObject NO-LOCK NO-ERROR.
    IF NOT AVAIL RowObject THEN
       RETURN "NOK":U.

    RUN sugereConta (INPUT RowObject.ch-acesso-comp-nfe, OUTPUT RowObject.ct-codigo, OUTPUT RowObject.sc-codigo).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereConta DBOProgram 
PROCEDURE sugereConta :
/*------------------------------------------------------------------------------
  Purpose: Sugest∆o de conta cont†bil    
  Parameters: p-chave-acesso:   Chave de acesso do documento  
              p-ct-codigo: Conta cont†bil
              p-sc-codigo: Subconta
  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER p-chave-acesso   AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER p-ct-codigo      AS CHAR NO-UNDO.
    DEF OUTPUT PARAMETER p-sc-codigo      AS CHAR NO-UNDO.

    FOR FIRST doc-orig-nfe FIELDS (cod-emitente cod-estabel)
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = p-chave-acesso
          AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
    END.
    IF AVAIL doc-orig-nfe THEN
        FOR FIRST estab-mat FIELDS (cod-estabel cod-cta-fornec-unif cod-ccusto-fornec-unif)        
            WHERE estab-mat.cod-estabel = doc-orig-nfe.cod-estabel NO-LOCK:
        END.
        
    ASSIGN p-ct-codigo = IF  AVAIL estab-mat THEN estab-mat.cod-cta-fornec-unif ELSE ""
           p-sc-codigo = IF  AVAIL estab-mat THEN estab-mat.cod-ccusto-fornec-unif ELSE "".                             

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :

   /*Quando o registro for criado pela apirest utilizando o metodo post, se existir registro dever†
   ser eliminado antes de criar um novo relacionamento*/
    FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe  = RowObject.ch-acesso-comp-nfe:
        DELETE bf{&TableName}.
    END.

    FOR FIRST doc-orig-nfe NO-LOCK
        WHERE doc-orig-nfe.cod-emitente = RowObject.cod-emitente
        AND   doc-orig-nfe.nro-docto    = RowObject.nro-docto    
        AND   doc-orig-nfe.serie-docto  = RowObject.serie-docto,

        FIRST item-doc-orig-nfe NO-LOCK                                                            
        WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe     
        AND   item-doc-orig-nfe.idi-orig-trad      = 2           
        AND   item-doc-orig-nfe.int-2 = 5:
        ASSIGN RowObject.nat-operacao = item-doc-orig-nfe.nat-operacao
               RowObject.tipo = 2.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    IF  NOT CAN-FIND(FIRST natur-oper WHERE natur-oper.nat-operacao = RowObject.nat-operacao) THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgind natur-oper 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
    END.
    

    FOR FIRST doc-orig-nfe NO-LOCK
        WHERE doc-orig-nfe.cod-emitente = RowObject.cod-emitente
        AND   doc-orig-nfe.nro-docto    = RowObject.nro-docto    
        AND   doc-orig-nfe.serie-docto  = RowObject.serie-docto:
        IF NOT CAN-FIND (FIRST item-doc-orig-nfe                                                                  
                         WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe     
                         AND   item-doc-orig-nfe.idi-orig-trad      = 2           
                         AND   item-doc-orig-nfe.int-2 = 5) THEN DO:  
              {utp/ut-liter.i retorno_beneficiamento * } 
              {method/svc/errors/inserr.i &ErrorNumber="57143"
                                          &ErrorType="EMS":U
                                          &ErrorSubType="ERROR":U 
                                          &ErrorParameters="RETURN-VALUE"}
              RETURN "NOK":U.
       END.
    END.
    
    /** VALIDAÄ«O CONTA CONTABIL **/

    if not valid-handle(h_api_cta_ctbl) 
    or h_api_cta_ctbl:type      <> "PROCEDURE":U 
    or h_api_cta_ctbl:file-name <> "prgint/utb/utb743za.py":U then
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

    if not valid-handle(h_api_ccusto) 
    or h_api_ccusto:type      <> "PROCEDURE":U 
    or h_api_ccusto:file-name <> "prgint/utb/utb742za.py":U then
        run prgint/utb/utb742za.py persistent set h_api_ccusto.

    /* Busca dados da conta cont†bil */
    ASSIGN v_cod_cta_ctbl = RowObject.ct-codigo.

    run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-ep-codigo-usuario,     /* EMPRESA EMS2 */
                                                   input        "",                      /* PLANO DE CONTAS */
                                                   input-output v_cod_cta_ctbl,          /* CONTA */
                                                   input        today,                   /* DATA TRANSACAO */   
                                                   output       v_titulo_cta_ctbl,       /* DESCRICAO CONTA */
                                                   output       v_num_tip_cta_ctbl,      /* TIPO DA CONTA */
                                                   output       v_num_sit_cta_ctbl,      /* SITUAÄ«O DA CONTA */
                                                   output       v_ind_finalid_cta,       /* FINALIDADES DA CONTA */
                                                   output table tt_log_erro).            /* ERROS */ 
   
    find first tt_log_erro no-lock no-error.
    if avail tt_log_erro then do:
  
         {method/svc/errors/inserr.i &ErrorNumber="17006"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}  
    end.
    ELSE DO:
        FOR FIRST doc-orig-nfe FIELDS (cod-emitente cod-estabel) WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
          AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
        END.
        /* Verifica se a conta utiliza centro de custo */
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,       /* EMPRESA EMS 2 */
                                                           input  doc-orig-nfe.cod-estabel,  /* ESTABELECIMENTO EMS2 */
                                                           input  "",                        /* PLANO CONTAS */
                                                           input  v_cod_cta_ctbl,            /* CONTA */
                                                           input  today,                     /* DT TRANSACAO */
                                                           output v_log_utz_ccusto,          /* UTILIZA CCUSTO ? */
                                                           output table tt_log_erro).        /* ERROS */        
        IF v_log_utz_ccusto THEN DO:
            /* Busca dados do centro de custo */
            ASSIGN v_cod_ccusto = RowObject.sc-codigo.
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-ep-codigo-usuario,     /* EMPRESA EMS2 */
                                                       input  "",                      /* CODIGO DO PLANO CCUSTO */
                                                       input  v_cod_ccusto,            /* CCUSTO */
                                                       input  today,                   /* DATA DE TRANSACAO */
                                                       output v_titulo_ccusto,         /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro).      /* ERROS */
             
            find first tt_log_erro no-lock no-error.
            if avail tt_log_erro then do: 
                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + '~~~~' + tt_log_erro.ttv_des_msg_ajuda"}      
            end. 
        end.
    END.

    IF  VALID-HANDLE(h_api_cta_ctbl)        AND
        h_api_cta_ctbl:TYPE = "PROCEDURE":U AND
        h_api_cta_ctbl:FILE-NAME = "prgint/utb/utb743za.p":U THEN DO:
        DELETE PROCEDURE h_api_cta_ctbl.
        ASSIGN h_api_cta_ctbl = ?.
    END.

    IF  VALID-HANDLE(h_api_ccusto)        AND
        h_api_ccusto:TYPE = "PROCEDURE":U AND
        h_api_ccusto:FILE-NAME = "prgint/utb/utb742za.p":U THEN DO:
        DELETE PROCEDURE h_api_ccusto.
        ASSIGN h_api_ccusto = ?.
    END.

    /** VALIDAÄ«O SERIE **/
    IF  NOT CAN-FIND(FIRST serie WHERE serie.serie = RowObject.serie-docto) THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-table.i mgind serie 1} /* Busca o label da tabela */
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
