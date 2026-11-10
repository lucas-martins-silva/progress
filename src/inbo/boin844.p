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
{include/i-prgvrs.i BOIN844 2.00.00.005 } /*** "010005" 17/06/2025 16:40:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOIN844 MUT}
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
&GLOBAL-DEFINE DBOName BOIN844
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName doc-orig-duplic-nfe
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
{inbo/boin844.i RowObject}
{inbo/boin092.i tt-dupli-apagar}    


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}  FOR {&TableName}.

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
         HEIGHT             = 16.21
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "nro-duplicata":U THEN ASSIGN pFieldValue = RowObject.nro-duplicata.
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
        WHEN "dt-vencim":U THEN ASSIGN pFieldValue = RowObject.dt-vencim.
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
        WHEN "vl-duplicata":U THEN ASSIGN pFieldValue = RowObject.vl-duplicata.
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
        WHEN "idi-orig-trad":U THEN ASSIGN pFieldValue = RowObject.idi-orig-trad.
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
  Purpose:     Retorna valores dos campos do °ndice unico
  Parameters:  
               retorna valor do campo ch-acesso-comp-nfe
               retorna valor do campo idi-orig-trad
               retorna valor do campo nro-duplicata
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE doc-orig-duplic-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-orig-trad LIKE doc-orig-duplic-nfe.idi-orig-trad NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-duplicata LIKE doc-orig-duplic-nfe.nro-duplicata NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           pidi-orig-trad = RowObject.idi-orig-trad
           pnro-duplicata = RowObject.nro-duplicata.

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
  Purpose:     Reposiciona registro com base no °ndice unico
  Parameters:  
               recebe valor do campo ch-acesso-comp-nfe
               recebe valor do campo idi-orig-trad
               recebe valor do campo nro-duplicata
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE doc-orig-duplic-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad LIKE doc-orig-duplic-nfe.idi-orig-trad NO-UNDO.
    DEFINE INPUT PARAMETER pnro-duplicata LIKE doc-orig-duplic-nfe.nro-duplicata NO-UNDO.

    FIND FIRST bfdoc-orig-duplic-nfe WHERE 
        bfdoc-orig-duplic-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe AND 
        bfdoc-orig-duplic-nfe.idi-orig-trad = pidi-orig-trad AND 
        bfdoc-orig-duplic-nfe.nro-duplicata = pnro-duplicata NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdoc-orig-duplic-nfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdoc-orig-duplic-nfe)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDuplicatasXML DBOProgram 
PROCEDURE geraDuplicatasXML :
/*------------------------------------------------------------------------------
  Purpose: Geraá∆o de duplicatas conforme o XML    
  Parameters:pch-acesso-comp-nfe: Chave de acesso do documento
             pnat-operacao: natureza de operaá∆o do documento
  Notes:     
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao       AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-dupli-apagar.
    
    DEFINE VARIABLE h-boin092       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-parcela       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-tp-despesa    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-empresa       LIKE empresa.ep-codigo               NO-UNDO.
           
    EMPTY TEMP-TABLE tt-dupli-apagar.
    
    FOR FIRST param-re NO-LOCK: END.

    FOR FIRST natur-oper 
        WHERE natur-oper.nat-operacao = pnat-operacao NO-LOCK: END.

    FOR FIRST doc-orig-nfe 
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe 
        AND   doc-orig-nfe.idi-orig-trad = 2 NO-LOCK : END.
     
    FOR FIRST estabelec FIELDS(ep-codigo)
        WHERE estabelec.cod-estabel = doc-orig-nfe.cod-estabel NO-LOCK:
        ASSIGN i-empresa = estabelec.ep-codigo.
    END.
    
    /** GERA DUPLICATAS CONFORME XML **/
    IF  AVAIL doc-orig-nfe AND NOT doc-orig-nfe.log-multi-cfop THEN DO:
        IF  AVAIL natur-oper 
        AND natur-oper.emite-duplic THEN DO:
    
            FOR FIRST emitente FIELDS (tp-desp-padrao)
                WHERE emitente.cod-emitente = doc-orig-nfe.cod-emitente NO-LOCK:
            END.
            IF NOT AVAIL emitente THEN
                RETURN "NOK":U.
    
            ASSIGN i-parcela = 0.
            FOR EACH doc-orig-duplic-nfe 
                WHERE doc-orig-duplic-nfe.ch-acesso-comp-nfe = doc-orig-nfe.ch-acesso-comp-nfe
                  AND doc-orig-duplic-nfe.idi-orig-trad      = 2 NO-LOCK
                BREAK BY doc-orig-duplic-nfe.dt-vencim:
                
                ASSIGN i-parcela = i-parcela + 1.
                
                run retornaTipoDespDupli (output i-tp-despesa).

                CREATE tt-dupli-apagar.
                ASSIGN tt-dupli-apagar.cod-emitente     = doc-orig-nfe.cod-emitente
                       tt-dupli-apagar.dt-emissao       = doc-orig-nfe.dt-emissao
                       tt-dupli-apagar.dt-trans         = doc-orig-nfe.dt-transacao
                       tt-dupli-apagar.dt-vencim        = doc-orig-duplic-nfe.dt-vencim
                       tt-dupli-apagar.ep-codigo        = i-empresa
                       tt-dupli-apagar.esp-movto        = 1
                       tt-dupli-apagar.cod-esp          = param-re.esp-def-dup
                       tt-dupli-apagar.cod-estabel      = doc-orig-nfe.cod-estabel
                       tt-dupli-apagar.parcela          = STRING(i-parcela, "99")
                       tt-dupli-apagar.nr-duplic        = doc-orig-nfe.nro-docto
                       tt-dupli-apagar.nro-docto        = doc-orig-nfe.nro-docto
                       tt-dupli-apagar.mo-codigo        = 0
                       tt-dupli-apagar.nat-operacao     = natur-oper.nat-operacao
                       tt-dupli-apagar.serie-docto      = doc-orig-nfe.serie-docto
                       tt-dupli-apagar.tp-despesa       = i-tp-despesa
                       tt-dupli-apagar.vl-a-pagar       = doc-orig-duplic-nfe.vl-duplicata.
            END.
        END.
    END.
    /** GERA DUPLICATAS CONFORME XML **/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
PROCEDURE retornaTipoDespDupli :
/*------------------------------------------------------------------------------
  Purpose: Retorna o tipo de despesa da duplicata     
  Parameters: pi-tp-despesa: Tipo de despesa da duplicata
  Notes:       
------------------------------------------------------------------------------*/
    
    define output param pi-tp-despesa as int no-undo.
    
    DEFINE BUFFER bfdoc-orig-nfe FOR doc-orig-nfe.

    for first item-doc-orig-nfe fields(num-pedido numero-ordem) no-lock
        where item-doc-orig-nfe.ch-acesso-comp-nfe = doc-orig-duplic-nfe.ch-acesso-comp-nfe
        and   item-doc-orig-nfe.idi-orig-trad = 2
        and   item-doc-orig-nfe.num-pedido > 0:
        
    end.
    IF  AVAIL item-doc-orig-nfe THEN DO:
        FOR FIRST ordem-compra FIELDS (tp-despesa) NO-LOCK
            WHERE ordem-compra.numero-ordem = item-doc-orig-nfe.numero-ordem:
        END.
        IF AVAIL ordem-compra THEN
            ASSIGN pi-tp-despesa = ordem-compra.tp-despesa.
        ELSE DO:
            FOR FIRST emitente FIELDS(tp-desp-padrao) NO-LOCK 
                WHERE emitente.cod-emitente = doc-orig-nfe.cod-emitente:
                ASSIGN pi-tp-despesa = emitente.tp-desp-padrao.                    
            END.            
        END.
    END.
    else do:
        for each bfdoc-orig-nfe no-lock of doc-orig-duplic-nfe, 
            each item-doc-orig-nfe no-lock of bfdoc-orig-nfe:
                      
            for first rat-ordem
                fields ( cod-emitente serie-docto nro-docto nat-operacao numero-ordem )
                where rat-ordem.cod-emitente = bfdoc-orig-nfe.cod-emitente
                and   rat-ordem.serie-docto  = bfdoc-orig-nfe.serie-docto
                and   rat-ordem.nro-docto    = bfdoc-orig-nfe.nro-docto
                and   rat-ordem.nat-operacao = item-doc-orig-nfe.nat-operacao 
                and   rat-ordem.numero-ordem <> 0 no-lock:
            end.
    
            if  avail rat-ordem then do:              
                for first ordem-compra 
                   fields ( tp-despesa )
                    where ordem-compra.numero-ordem = rat-ordem.numero-ordem no-lock:
                end.
                if  avail ordem-compra then             
                    assign pi-tp-despesa = ordem-compra.tp-despesa.
            end.
            else do:
                for first emitente fields(tp-desp-padrao) no-lock
                    where emitente.cod-emitente = bfdoc-orig-nfe.cod-emitente:
                end.
                if  avail emitente then
                    assign pi-tp-despesa = emitente.tp-desp-padrao.
            end.                
        end.
    end.
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



