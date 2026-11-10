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
{include/i-prgvrs.i BOIN741 2.00.00.005} /*** "010005" 07/02/2024 11:19:51  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin741 MUT}
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
&GLOBAL-DEFINE DBOName BOIN741
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName familia-impto
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
{inbo/boin741.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{utp/ut-glob.i}
/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
def var c-codigo-ini like familia-impto.cod-familia-impto no-undo.
def var c-codigo-fim like familia-impto.cod-familia-impto no-undo.
def var c-action                AS CHAR   NO-UNDO.
def var h-acomp                 as handle no-undo.
def var h-tip-familia-impto-aux as handle no-undo.

define workfile w-pedido no-undo
    field nome-abrev like ped-venda.nome-abrev
    field nr-pedcli  like ped-venda.nr-pedcli.

DEFINE TEMP-TABLE tt-tip-familia-impto-aux LIKE tip-familia-impto
    FIELD r-rowid AS ROWID.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  VALID-HANDLE(h-tip-familia-impto-aux) THEN DO:
        RUN pi-salvatip-familia-impto IN THIS-PROCEDURE (INPUT "CREATE").
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.

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
    IF  VALID-HANDLE(h-tip-familia-impto-aux) THEN DO:
        RUN pi-salvatip-familia-impto IN THIS-PROCEDURE (INPUT "UPDATE").
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.

    RETURN "OK":U.

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

    for each tip-familia-impto 
        where tip-familia-impto.cod-familia-impto = RowObject.cod-familia-impto 
        and   tip-familia-impto.idi-tip-impto = 1 exclusive-lock:

        delete tip-familia-impto.

    end.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-familia-impto":U THEN ASSIGN pFieldValue = RowObject.cod-familia-impto.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-familia-impto":U THEN ASSIGN pFieldValue = RowObject.des-familia-impto.
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
  Purpose:     Retorna valores dos campos do °ndice fmlmpt-id
  Parameters:  
               retorna valor do campo cod-familia-impto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-familia-impto LIKE familia-impto.cod-familia-impto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-familia-impto = RowObject.cod-familia-impto.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice fmlmpt-id
  Parameters:  
               recebe valor do campo cod-familia-impto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-familia-impto LIKE familia-impto.cod-familia-impto NO-UNDO.

    FIND FIRST bffamilia-impto WHERE 
        bffamilia-impto.cod-familia-impto = pcod-familia-impto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffamilia-impto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffamilia-impto)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCod DBOProgram 
PROCEDURE openQueryCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
                        WHERE {&tablename}.cod-familia-impto >= c-codigo-ini 
                        and   {&tablename}.cod-familia-impto <= c-codigo-fim 
                           by {&tablename}.cod-familia-impto  INDEXED-REPOSITION.

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
    OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exportaImptoFamilia DBOProgram 
PROCEDURE pi-exportaImptoFamilia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* ParÉmetros: 1- Tipo de exportaá∆o (cd0630a) pode ser: 1 - Exporta para todos os itens*/
    /*                                                       2 - Exporta para os itens que possuam valor anterior*/
    /*                                                       3 - N∆o exporta para os itens*/
    /*              2- Aberto (cd0630a): seleciona itens dos Pedidos de Venda em aberto*/       
    /*              3- Atend Parcial (cd0630a): seleciona itens dos Pedidos de Venda atendido parcialmente*/
    /*              4- Familia de imposto: c¢digo da fam°lia de imposto que foi alterada*/
    /*              5- Aliquota Impto: aliquota anterior a alteraá∆o*/
    /*              6- Valor Impto: valor anterior a alteraá∆o*/

    def input param p-tp-exportacao      as integer no-undo.
    def input param p-aberto             as log     no-undo.
    def input param p-parcial            as log     no-undo.
    def input param p-cod-familia-impto  like item-mat.cod-familia-impto no-undo.
    def input param p-val-aliq-impto-ant like tip-familia-impto.val-aliq-impto no-undo.
    def input param p-val-impto-ant      like tip-familia-impto.val-impto      no-undo.


    if p-tp-exportacao = 1 or p-tp-exportacao = 2 then do transaction:
        for first tip-familia-impto 
        where tip-familia-impto.cod-familia-impto = p-cod-familia-impto no-lock: end.
        
        run utp/ut-acomp.p persistent set h-acomp.
        run pi-inicializar in h-acomp (input "Exportaá∆o Impostos para os itens").

        for each item-mat 
           where item-mat.cod-familia-impto = p-cod-familia-impto no-lock:
                
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Item" *}
            run pi-acompanhar in h-acomp (RETURN-VALUE + ".:" + item-mat.it-codigo).

            for first item where item.it-codigo = item-mat.it-codigo exclusive-lock: end.
                
            if p-tp-exportacao = 1 then do:
                assign item.aliquota-ipi = tip-familia-impto.val-aliq-impto.
                assign item.valor-ipi-beb = tip-familia-impto.val-impto.
            end.
            else if p-tp-exportacao = 2 then do:
                /*se valor ou aliquota igual a anterior*/
                if item.aliquota-ipi = p-val-aliq-impto-ant then
                    assign item.aliquota-ipi = tip-familia-impto.val-aliq-impto.
                if item.valor-ipi-beb = p-val-impto-ant then
                    assign item.valor-ipi-beb = tip-familia-impto.val-impto.
            end.
            /* exporta para os itens do Pedido de Vendas*/
            if p-aberto or p-parcial then 
                run pi-exportaImptoFamiliaPed (input if p-aberto then 1 else if p-parcial then 2 else 0,     
                                               input if p-parcial then 2 else if p-aberto then 1 else 0,
                                               input item.it-codigo,     
                                               input tip-familia-impto.cod-familia-impto,
                                               input tip-familia-impto.log-utiliza-aliq, 
                                               input tip-familia-impto.val-aliq-impto,
                                               input p-tp-exportacao,
                                               input p-val-aliq-impto-ant).    
        end.
        for each w-pedido exclusive-lock:
            find ped-venda where ped-venda.nome-abrev = w-pedido.nome-abrev and
                                 ped-venda.nr-pedcli  = w-pedido.nr-pedcli exclusive-lock no-error.
            
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Recalculando_Pedido" *}
            run pi-acompanhar in h-acomp (RETURN-VALUE + ".:" + ped-venda.nome-abrev + "/":U + ped-venda.nr-pedcli). 
            run cdp/cd4323a.p (input rowid(ped-venda),
                               input yes,
                               input i-pais-impto-usuario).
            delete w-pedido.
        end.
        run pi-finalizar in h-acomp.
    end.
    
    return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-exportaImptoFamiliaPed DBOProgram 
PROCEDURE pi-exportaImptoFamiliaPed :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-sit-ini            as integer no-undo.
    def input param p-sit-fim            as integer no-undo.
    def input param p-it-codigo          like item.it-codigo no-undo.
    def input param p-cod-fam-impto      like item-mat.cod-familia-impto no-undo.
    def input param p-utiliza-aliq       like tip-familia-impto.log-utiliza-aliq no-undo.
    def input param p-val-aliq           like tip-familia-impto.val-aliq-impto no-undo.
    def input param p-tp-exportacao      as integer no-undo.
    def input param p-val-aliq-impto-ant like tip-familia-impto.val-aliq-impto no-undo.
    

    define buffer b-ped-item for ped-item.

    for each b-ped-item fields() where b-ped-item.it-codigo    = item.it-codigo
                                 and   b-ped-item.cod-sit-item >= p-sit-ini
                                 and   b-ped-item.cod-sit-item <= p-sit-fim no-lock:
        if p-tp-exportacao = 2 and p-val-aliq-impto-ant <> b-ped-item.aliquota-ipi then
            next.

        find ped-item where rowid(ped-item) = rowid(b-ped-item) exclusive-lock no-error.
        assign ped-item.aliquota-ipi = p-val-aliq.
        
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Pedido" *}
        run pi-acompanhar in h-acomp (RETURN-VALUE + ":" + ped-item.nr-pedcli).
        
        find first w-pedido where w-pedido.nome-abrev = ped-item.nome-abrev
                            and   w-pedido.nr-pedcli  = ped-item.nr-pedcli no-lock no-error.
        if  not avail w-pedido then do:
           create w-pedido.
           assign w-pedido.nome-abrev = ped-item.nome-abrev
                  w-pedido.nr-pedcli  = ped-item.nr-pedcli.
        end.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-salvatip-familia-impto DBOProgram 
PROCEDURE pi-salvatip-familia-impto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM c-action AS CHAR NO-UNDO.

    FOR FIRST tt-tip-familia-impto-aux:
    END.

    IF VALID-HANDLE(h-tip-familia-impto-aux) AND AVAIL tt-tip-familia-impto-aux THEN DO:
        RUN emptyRowErrors  IN h-tip-familia-impto-aux.
        RUN setRecord       IN h-tip-familia-impto-aux (INPUT TABLE tt-tip-familia-impto-aux).
        IF c-action = "CREATE" THEN
            RUN createRecord    IN h-tip-familia-impto-aux.
        ELSE IF c-action = "UPDATE" THEN
            RUN updateRecord     IN h-tip-familia-impto-aux.    
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN getRowErrors IN h-tip-familia-impto-aux (OUTPUT TABLE RowErrors APPEND).
            RETURN "NOK":U.
        END.
    END.
    ELSE 
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-setConstraintTip-Familia DBOProgram 
PROCEDURE pi-setConstraintTip-Familia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM h-tp-famil-impto  AS HANDLE NO-UNDO.
    DEF INPUT PARAM TABLE FOR tt-tip-familia-impto-aux.

    ASSIGN h-tip-familia-impto-aux = h-tp-famil-impto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCod DBOProgram 
PROCEDURE setConstraintCod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-codigo-ini LIKE familia-impto.cod-familia-impto NO-UNDO.
    DEF INPUT PARAM p-codigo-fim LIKE familia-impto.cod-familia-impto NO-UNDO.
    
    ASSIGN c-codigo-ini = p-codigo-ini
           c-codigo-fim = p-codigo-fim.
    
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
    IF pType = 'CREATE' THEN DO:
        IF CAN-FIND (FIRST familia-impto WHERE 
                    familia-impto.cod-familia-impto = rowObject.cod-familia-impto) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-familia-imposto AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Fam°lia_Imposto" *}
                    ASSIGN c-lbl-liter-familia-imposto = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                   &ErrorNumber="7"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters= "c-lbl-liter-familia-imposto"}
        END.
    END.
    IF pType = "create" OR pType = "update" THEN DO:
        IF RowObject.cod-familia-impto = '' THEN
                    /* Inicio -- Projeto Internacional */
                    DO:
                    DEFINE VARIABLE c-lbl-liter-familia-imposto-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Fam°lia_Imposto" *}
                    ASSIGN c-lbl-liter-familia-imposto-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                   &ErrorNumber="17677"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters= "c-lbl-liter-familia-imposto-2"}
                    END. 
        IF RowObject.des-familia-impto = '' THEN
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-descricao-imposto AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Descriá∆o_Imposto" *}
                        ASSIGN c-lbl-liter-descricao-imposto = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i
                                       &ErrorNumber="17677"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters= "c-lbl-liter-descricao-imposto"}
                        END. 
    END.
    IF pType = "delete" then do:
        for first item-mat 
                    where item-mat.cod-familia-impto = RowObject.cod-familia-impto no-lock: end.
        if avail item-mat then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-familia-imposto-3 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Fam°lia_Imposto" *}
            ASSIGN c-lbl-liter-familia-imposto-3 = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-inserr-familia-imposto-3-rowobj AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-inserr-familia-imposto-3-rowobj = c-lbl-liter-familia-imposto-3 + ' ' + RowObject.cod-familia-impto + '~~~~' + item-mat.it-codigo.
            {method/svc/errors/inserr.i
                           &ErrorNumber="30048"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters= "c-lbl-inserr-familia-imposto-3-rowobj"}
        end.
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

