&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
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
&GLOBAL-DEFINE DBOName BOIN841
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-fornec-umd
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
{inbo/boin841.i RowObject}
{inbo/boin841.i tt-item-fornec-umd-before}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE cItem     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iEmitente AS INTEGER     NO-UNDO.

DEFINE VARIABLE l-exec-cc0106 AS LOGICAL INITIAL FALSE NO-UNDO.

/*--------------  procedure AtualizaUnidMedItemFornec   -------------------*/
def var l-create        as  log no-undo initial no. /* para distinguir entre create e update.*/
def var de-soma         as  decimal no-undo. /* utilizado na verificacao do percentual de compra */
def var i-x             as integer no-undo. /* contador utilizada na include cc0105.i1 */
def var de-indice       as decimal no-undo.
def var de-prazo        as decimal no-undo. /* utilizada na include cc0105.i1 */
def var de-taxa-per     as decimal no-undo. /* utilizada na include cc0105.i1 */
def var l-alt-med       as logical no-undo.
def var l-preco-bruto   as logical no-undo. /* utilizada na include cc0105.i1  e
                                               na procedure InicializaPrecoIpiQtde*/
def var l-erro-un       as logical.
/*---------------------------------------------------------------------*/

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
         HEIGHT             = 2
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "unid-med-for":U THEN ASSIGN pFieldValue = RowObject.unid-med-for.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
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
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-mul-for":U THEN ASSIGN pFieldValue = RowObject.lote-mul-for.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        WHEN "num-casa-dec":U THEN ASSIGN pFieldValue = RowObject.num-casa-dec.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itemfornumd-id
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-emitente
               retorna valor do campo unid-med-for
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-fornec-umd.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-fornec-umd.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER punid-med-for LIKE item-fornec-umd.unid-med-for NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-emitente = RowObject.cod-emitente
           punid-med-for = RowObject.unid-med-for.

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
        WHEN "log-ativo":U THEN ASSIGN pFieldValue = RowObject.log-ativo.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
        WHEN "log-livre-2":U THEN ASSIGN pFieldValue = RowObject.log-livre-2.
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItemFornec DBOProgram 
PROCEDURE linkToItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Handle do DBO pai.
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter ph-itemFornec as handle no-undo.
    
    RUN GetKey in ph-itemFornec (output cItem,
                                 output iEmitente).

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
    OPEN QUERY {&QueryName} FOR EACH item-fornec-umd NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItemFornec DBOProgram 
PROCEDURE openQueryByItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH item-fornec-umd
                               where item-fornec-umd.it-codigo = cItem
                                 and item-fornec-umd.cod-emitente = iEmitente NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByItemFornec DBOProgram 
PROCEDURE setConstraintByItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  pcItem : C¢digo do Item.
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcItem     as char no-undo.
    def input param piEmitente as int no-undo.
    
    assign cItem     = pcItem
           iEmitente = piEmitente.
    
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram  
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice itemfornumd-id
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-emitente
               recebe valor do campo unid-med-for
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-fornec-umd.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-fornec-umd.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER punid-med-for LIKE item-fornec-umd.unid-med-for NO-UNDO.

    FIND FIRST bfitem-fornec-umd WHERE 
        bfitem-fornec-umd.it-codigo = pit-codigo AND 
        bfitem-fornec-umd.cod-emitente = pcod-emitente AND 
        bfitem-fornec-umd.unid-med-for = punid-med-for NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-fornec-umd THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-fornec-umd)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign l-create = yes. /* utilizado na procedure atualizaUnidMedItemFornec para 
                              informar quando Ç create(yes) ou update(no).*/
    run atualizaUnidMedItemFornec.
   
    return "OK":U.
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
    for each tt-item-fornec-umd-before:
        delete tt-item-fornec-umd-before.
    end.
    create tt-item-fornec-umd-before.
    buffer-copy item-fornec-umd to tt-item-fornec-umd-before.
    find first tt-item-fornec-umd-before no-lock no-error.

    return "OK":U.
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

   assign l-create = no. /* utilizado na procedure atualizaUnidMedItemFornec para 
                             informar quando Ç create(yes) ou update(no).*/

   /* sΩ executa a atualizaUnidMedItemFornec caso nío seja executado pelo cc0106 (boin00948) */
   IF NOT l-exec-cc0106 THEN
        run atualizaUnidMedItemFornec. 
    
    return "OK":U.
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
    DEFINE VARIABLE l-existe-cotacao AS LOGICAL     NO-UNDO.
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    FIND FIRST rowObject NO-ERROR. 
    if avail rowObject then do:
   
        if  pType = "Create":U or pType = "Update":U then do:
            IF rowObject.fator-conver = 0 THEN DO:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-fator-de-conversao AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Fator_de_Convers∆o" *}
               ASSIGN c-lbl-liter-fator-de-conversao = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i &ErrorNumber="17340"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-lbl-liter-fator-de-conversao"}
                                                
            END.
            if not can-find(first tab-unidade 
                            where tab-unidade.un = rowObject.unid-med-for) then do:
                {method/svc/errors/inserr.i &ErrorNumber="846"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U}        
            end.
            else do:
                if pType = "Create":U then do:
                  
                    if can-find (first item-fornec-umd 
                                 where item-fornec-umd.it-codigo    = rowObject.it-codigo
                                   and item-fornec-umd.cod-emitente = rowObject.cod-emitente
                                   and item-fornec-umd.unid-med-for = rowObject.unid-med-for) or
                       can-find (first item-fornec 
                                 where item-fornec.it-codigo    = rowObject.it-codigo
                                   and item-fornec.cod-emitente = rowObject.cod-emitente
                                   and item-fornec.unid-med-for = rowObject.unid-med-for) then do:
                        
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-item-x-fornecedor AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Item_X_Fornecedor" *}
                        ASSIGN c-lbl-liter-item-x-fornecedor = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-unidade-de-medida AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Unidade_de_Medida" *}
                        ASSIGN c-lbl-liter-unidade-de-medida = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i &ErrorNumber="32682"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="c-lbl-liter-item-x-fornecedor + '~~~~' + c-lbl-liter-unidade-de-medida"} 
                    end.
                end.
            end.
        end.
    
        if pType = "Update":U then do:
            if  (   RowObject.fator-conver <> {&TableName}.fator-conver 
                or  RowObject.num-casa-dec <> {&TableName}.num-casa-dec) then do:
                
                for each ordem-compra fields(numero-ordem)
                   where ordem-compra.it-codigo    = RowObject.it-codigo
                     and ordem-compra.cod-emitente = RowObject.cod-emitente
                     and ordem-compra.situacao     = 2 no-lock:
                    if can-find(first cotacao-item 
                                where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                                  and cotacao-item.un = RowObject.unid-med-for) then do:
                        assign l-existe-cotacao = yes.
                        leave.
                    end.
                end.
                if l-existe-cotacao then do:
                
                    if can-find (first funcao
                                 where funcao.cd-funcao = "spp-ValidaConvItem":U
                                 and   funcao.ativo) then do:
                        {method/svc/errors/inserr.i &ErrorNumber="34110"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="ERROR":U
                                                    &ErrorParameters="RowObject.it-codigo + '~~~~' + string(RowObject.cod-emitente)"}
                    end.
                    else do:
                        {method/svc/errors/inserr.i &ErrorNumber="34111"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="WARNING":U
                                                    &ErrorParameters="RowObject.it-codigo + '~~~~' + string(RowObject.cod-emitente)"}
                    end.
                end.
            end.
        end.
    
        IF pType = "Delete":U THEN DO:
            /** *************    Validaá∆o da Trigger   ************** **/
            IF  CAN-FIND(FIRST item-contrat
                         WHERE item-contrat.it-codigo    = RowObject.it-codigo
                           AND item-contrat.cod-emitente = RowObject.cod-emitente
                           and item-contrat.un           = RowObject.unid-med-for) THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="6801"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}
            END.    
    
            FOR FIRST ITEM FIELDS(tipo-contr)
                WHERE ITEM.it-codigo = {&tablename}.it-codigo NO-LOCK: END.
            IF CAN-FIND(FIRST cotacao-item 
                        WHERE cotacao-item.cod-emitente = RowObject.cod-emitente 
                          AND cotacao-item.it-codigo    = RowObject.it-codigo 
                          and cotacao-item.un           = RowObject.unid-med-for
                          AND cotacao-item.cot-aprovada ) 
            AND (AVAIL ITEM AND item.tipo-contr <> 4) THEN do:
                    {method/svc/errors/inserr.i &ErrorNumber="6802"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}     
            END.    
            /** Fim das validaá‰es de eliminaá∆o **/
        END.

    end.


    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaUnidMedItemFornec DBOProgram 
PROCEDURE atualizaUnidMedItemFornec :
/*------------------------------------------------------------------------------
  Purpose:      Verifica se a unidade  de medida/lote foi modificada. Se for,
                converte para a nova un e atualiza os registros relacionados.
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/
    
    IF  NOT AVAIL param-global THEN
        FIND FIRST param-global NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL ITEM 
    OR  (AVAIL ITEM AND ITEM.it-codigo <> RowObject.it-codigo) THEN
        FIND item WHERE item.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.

    assign l-alt-med  = no.

    find first tt-item-fornec-umd-before no-lock no-error.
    if avail tt-item-fornec-umd-before then do:

        if  item.tipo-contr <> 4 OR
           (item.tipo-contr  = 4 and item.it-codigo <> "") then
            if  RowObject.fator-conver <> tt-item-fornec-umd-before.fator-conver
            or  RowObject.num-casa-dec <> tt-item-fornec-umd-before.num-casa-dec
            then
                assign l-alt-med = yes.
    end.

    /* Quando modifica a unidade de um item tem que atualizar o hist¢rico antigo */

    if  l-alt-med then do: /* -- Conversao para nova unidade medida do fornecedor -- */

          assign de-indice = if avail item-fornec-umd then
                             item-fornec-umd.fator-conver / if  item-fornec-umd.num-casa-dec = 0 then 1
                                                        else exp(10, item-fornec-umd.num-casa-dec)
                             else 1.                           
                 l-preco-bruto = if avail param-compra then (param-compra.ipi-sobre-preco = 1) 
                             else no.


          for each cotacao-item where
                   cotacao-item.cod-emitente = item-fornec-umd.cod-emitente and
                   cotacao-item.it-codigo    = item-fornec-umd.it-codigo    and
                   cotacao-item.un           = item-fornec-umd.unid-med-for exclusive-lock:

              for each ordem-compra where
                       ordem-compra.numero-ordem = cotacao-item.numero-ordem and
                       ordem-compra.cod-emitente = cotacao-item.cod-emitente and
                       ordem-compra.it-codigo    = cotacao-item.it-codigo exclusive-lock:

                  assign ordem-compra.pre-unit-for = ordem-compra.preco-unit / de-indice.
                  {ccp/cc0105.i1 "ordem-compra"}   /*Recalcula preco unitario bruto do item atraves do 
                                                     preco unitario calculado*/
                  for each prazo-compra where
                           prazo-compra.numero-ordem = ordem-compra.numero-ordem and
                           prazo-compra.it-codigo   = ordem-compra.it-codigo exclusive-lock:
                      assign prazo-compra.qtd-do-forn  = prazo-compra.quantidade * de-indice
                             prazo-compra.qtd-sal-forn = prazo-compra.quant-saldo * de-indice
                             prazo-compra.qtd-rej-forn = prazo-compra.quant-rejeit * de-indice
                             prazo-compra.qtd-rec-forn = prazo-compra.quant-receb * de-indice.
                  end.
                  for each evento-ped where
                           evento-ped.numero-ordem = ordem-compra.numero-ordem and
                           evento-ped.it-codigo    = ordem-compra.it-codigo exclusive-lock:
                      assign evento-ped.qtd-prevista  = evento-ped.qtd-prevista * de-indice 
                             evento-ped.qtd-realizada = evento-ped.qtd-realizada * de-indice
                             evento-ped.val-antecip   = evento-ped.val-antecip * de-indice
                             evento-ped.val-pago      = evento-ped.val-pago * de-indice
                             evento-ped.val-previsto  = evento-ped.val-previsto * de-indice
                             evento-ped.val-realizado = evento-ped.val-realizado * de-indice.        
                  end.     
                  for each medicao-contrat where
                           medicao-contrat.numero-ordem = ordem-compra.numero-ordem and
                           medicao-contrat.it-codigo    = ordem-compra.it-codigo exclusive-lock:
                      assign medicao-contrat.qtd-medicao     = medicao-contrat.qtd-medicao * de-indice
                             medicao-contrat.qtd-prevista    = medicao-contrat.qtd-prevista * de-indice
                             medicao-contrat.sld-rec-medicao = medicao-contrat.sld-rec-medicao * de-indice
                             medicao-contrat.sld-val-medicao = medicao-contrat.sld-val-medicao * de-indice
                             medicao-contrat.val-previsto    = medicao-contrat.val-previsto * de-indice 
                             medicao-contrat.val-medicao     = medicao-contrat.val-medicao * de-indice
                             medicao-contrat.val-antecip     = medicao-contrat.val-antecip * de-indice. 
                  end.
              end.
          
              assign cotacao-item.pre-unit-for = cotacao-item.preco-unit / de-indice.                
              {ccp/cc0105.i1 "cotacao-item"}    /*Recalcula preco unitario bruto do item atraves do 
                                                 preco unitario calculado*/
          end.
          for each item-contrat where 
                   item-contrat.it-codigo    = item-fornec-umd.it-codigo and
                   item-contrat.cod-emitente = item-fornec-umd.cod-emitente and
                   item-contrat.un           = item-fornec-umd.unid-med-for exclusive-lock:
             assign item-contrat.pre-unit-for      = item-contrat.preco-unit / de-indice
                    item-contrat.sld-val-receb = item-contrat.sld-val-receb * de-indice 
                    item-contrat.sld-val-liber = item-contrat.sld-val-liber * de-indice
                    item-contrat.sld-val       = item-contrat.sld-val * de-indice
                    item-contrat.sld-qtd-receb = item-contrat.sld-qtd-receb * de-indice
                    item-contrat.sld-qtd-liber = item-contrat.sld-qtd-liber * de-indice
                    item-contrat.sld-qtd       = item-contrat.sld-qtd * de-indice
                    item-contrat.val-taxa      = item-contrat.val-taxa * de-indice 
                    item-contrat.valor-descto  = item-contrat.valor-descto * de-indice 
                    item-contrat.val-frete     = item-contrat.val-frete * de-indice.

              assign item-contrat.preco-fornec = item-contrat.pre-unit-for.
              
              if  l-preco-bruto = no then do:
                  if  item-contrat.taxa-financ then do:
                      if  not item-contrat.codigo-ipi then assign
                          item-contrat.preco-fornec = item-contrat.preco-fornec / (1 + (item-contrat.aliquota-ipi / 100)).
                  end.
                  else do:
                      if not item-contrat.codigo-ipi then assign
                         item-contrat.preco-fornec = item-contrat.preco-fornec / (1 + (item-contrat.aliquota-ipi / 100)).
                      if  item-contrat.val-taxa <> 0 then do:
                          find cond-pagto where
                               cond-pagto.cod-cond-pag = item-contrat.cod-cond-pag no-lock no-error.
                          if avail cond-pagto and cond-pagto.prazos[1] <> 0 then do:
                              de-prazo = 0.
                              do i-x = 1 to cond-pagto.num-parcelas:
                                 de-prazo = de-prazo + (cond-pagto.prazos[i-x] *
                                               cond-pagto.per-pg-dup[i-x]).
                              end.
                              assign de-prazo    = de-prazo / 100
                                     de-taxa-per = exp(exp(1 + item-contrat.val-taxa / 100,
                                                         1 / 30),de-prazo)
                                     item-contrat.preco-fornec = item-contrat.preco-fornec / de-taxa-per.
                          end.
                      end.
                  end.
                  if  item-contrat.perc-desconto > 0 then assign
                      item-contrat.preco-fornec = item-contrat.preco-fornec / (1 - (item-contrat.perc-desconto / 100)).
              end.
              else do:
                  if  item-contrat.perc-desconto  > 0 then assign
                      item-contrat.preco-fornec = item-contrat.preco-fornec / (1 - (item-contrat.perc-desconto / 100)).
                  if  item-contrat.codigo-ipi   =  no
                  and item-contrat.aliquota-ipi <> 0 then assign
                      item-contrat.preco-fornec = item-contrat.preco-fornec / (1 + (item-contrat.aliquota-ipi / 100)).
                  if  item-contrat.taxa-financ =  no
                  and item-contrat.val-taxa  <> 0 then do:
                      find cond-pagto where
                           cond-pagto.cod-cond-pag = item-contrat.cod-cond-pag no-lock no-error.
                      if avail cond-pagto and cond-pagto.prazos[1] <> 0 then do:
                          de-prazo = 0.
                          do  i-x = 1 to cond-pagto.num-parcelas:
                              assign de-prazo = de-prazo + (cond-pagto.prazos[i-x] *
                                                cond-pagto.per-pg-dup[i-x]).
                          end.
                          assign de-prazo    = de-prazo / 100
                                 de-taxa-per = exp(exp(1 + item-contrat.val-taxa / 100,
                                                       1 / 30),de-prazo)
                                 item-contrat.preco-fornec = item-contrat.preco-fornec / de-taxa-per.
                      end.
                  end.
              end.
          end.
    
          for each componente where
                   componente.cod-emitente = item-fornec-umd.cod-emitente and
                   componente.it-codigo    = item-fornec-umd.it-codigo exclusive-lock:
              for first item-doc-est fields (numero-ordem)
                  where item-doc-est.serie-docto  = componente.serie-docto 
                    and item-doc-est.nro-docto    = componente.nro-docto   
                    and item-doc-est.cod-emitente = componente.cod-emitente
                    and item-doc-est.nat-operacao = componente.nat-operacao
                    and item-doc-est.sequencia    = componente.sequencia no-lock:
                  if can-find(first cotacao-item
                              where cotacao-item.numero-ordem = item-doc-est.numero-ordem
                                and cotacao-item.cot-aprovada = yes 
                                and cotacao-item.un = item-fornec-umd.unid-med-for) then
                      assign componente.qt-do-forn = componente.quantidade * de-indice.
              end.
          end.
          for each recebimento where
                   recebimento.cod-emitente = item-fornec.cod-emitente and
                   recebimento.it-codigo    = item-fornec.it-codigo exclusive-lock:
              if can-find(first cotacao-item
                          where cotacao-item.numero-ordem = recebimento.numero-ordem
                            and cotacao-item.cot-aprovada = yes 
                            and cotacao-item.un = item-fornec-umd.unid-med-for) then
                  assign recebimento.qtd-rec-forn = recebimento.quant-receb * de-indice
                         recebimento.qtd-rej-forn = recebimento.quant-rejeit * de-indice
                         recebimento.pre-unit-for = recebimento.preco-unit / de-indice.
          end.
          for each item-doc-est where
                   item-doc-est.cod-emitente = item-fornec.cod-emitente and
                   item-doc-est.it-codigo    = item-fornec.it-codigo exclusive-lock:
              if can-find(first cotacao-item
                          where cotacao-item.numero-ordem = item-doc-est.numero-ordem
                            and cotacao-item.cot-aprovada = yes 
                            and cotacao-item.un = item-fornec-umd.unid-med-for) then do:
                  assign item-doc-est.qt-do-forn = item-doc-est.quantidade * de-indice.
                  for each rat-ordem 
                     where rat-ordem.serie-docto = item-doc-est.serie-docto  
                     and   rat-ordem.nro-docto   = item-doc-est.nro-docto    
                     and   rat-ordem.cod-emitente = item-doc-est.cod-emitente 
                     and   rat-ordem.nat-operacao = item-doc-est.nat-operacao 
                     and   rat-ordem.sequencia   = item-doc-est.sequencia exclusive-lock:
                        assign rat-ordem.qtidade-forn = rat-ordem.quantidade * de-indice.
                  end.
                  for each pd-pd-it-nfe 
                     where pd-pd-it-nfe.serie-docto  = item-doc-est.serie-docto  
                     and   pd-pd-it-nfe.nro-docto    = item-doc-est.nro-docto    
                     and   pd-pd-it-nfe.cod-emitente = item-doc-est.cod-emitente 
                     and   pd-pd-it-nfe.nat-operacao = item-doc-est.nat-operacao 
                     and   pd-pd-it-nfe.sequencia    = item-doc-est.sequencia exclusive-lock:
                        assign pd-pd-it-nfe.qt-do-forn = pd-pd-it-nfe.quantidade * de-indice.
                  end.
                  for each pd-cc-it-nfe 
                     where pd-cc-it-nfe.serie-docto  = item-doc-est.serie-docto  
                     and   pd-cc-it-nfe.nro-docto    = item-doc-est.nro-docto    
                     and   pd-cc-it-nfe.cod-emitente = item-doc-est.cod-emitente 
                     and   pd-cc-it-nfe.nat-operacao = item-doc-est.nat-operacao 
                     and   pd-cc-it-nfe.sequencia    = item-doc-est.sequencia exclusive-lock:
                        assign pd-cc-it-nfe.qt-do-forn = pd-cc-it-nfe.quantidade * de-indice.
                  end.
              end.
          end.
    end.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExecCC0106 DBOProgram 
PROCEDURE setExecCC0106 :
/*------------------------------------------------------------------------------
  Purpose:     Esta procedure informa que a execuá∆o est†ˇ sendo feita via cc0106a (boin00948).
               Isso se faz necess†rio para n∆o executar a procedure atualizaUnidMedItemFornec.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-exec-cc0106 = TRUE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
