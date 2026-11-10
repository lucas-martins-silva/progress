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
{include/i-prgvrs.i BOIN00892 2.00.00.019 } /*** "010019" 28/11/2025 18:15:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin00892 MUT}
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
&GLOBAL-DEFINE DBOName BOIN00892
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-lote-medic-nfe
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
{inbo/boin00892.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-ch-acesso-comp-nfe LIKE rat-lote-medic-nfe.ch-acesso-comp-nfe NO-UNDO.
DEFINE VARIABLE i-idi-orig-trad      LIKE rat-lote-medic-nfe.idi-orig-trad      NO-UNDO.
DEFINE VARIABLE i-seq-item           LIKE rat-lote-medic-nfe.seq-item           NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-pais-impto-usuario AS INTEGER   NO-UNDO.

DEFINE VARIABLE c-sug-cod-deposito       AS CHAR       NO-UNDO.
DEFINE VARIABLE c-sug-cod-localizacao    AS CHAR       NO-UNDO.
DEFINE VARIABLE l-loc-unica              AS LOG        NO-UNDO.

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
         HEIGHT             = 8.42
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaLoteValid DBOProgram 
PROCEDURE eliminaLoteValid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE rat-lote-medic-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad LIKE rat-lote-medic-nfe.idi-orig-trad NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item LIKE rat-lote-medic-nfe.seq-item NO-UNDO.
    DEFINE INPUT PARAMETER pr-it-nfe AS ROWID NO-UNDO.

    FIND FIRST bfrat-lote-medic-nfe NO-LOCK
         WHERE bfrat-lote-medic-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe 
           AND bfrat-lote-medic-nfe.idi-orig-trad = pidi-orig-trad 
           AND bfrat-lote-medic-nfe.seq-item = pseq-item NO-ERROR.
    IF NOT AVAIL bfrat-lote-medic-nfe THEN DO:

        FIND FIRST item-doc-orig-nfe EXCLUSIVE-LOCK
             WHERE rowid(item-doc-orig-nfe) = pr-it-nfe NO-ERROR.
        IF AVAIL item-doc-orig-nfe THEN
            ASSIGN item-doc-orig-nfe.lote-serie   = {&TableName}.cod-lote-fabrican
                   item-doc-orig-nfe.dt-vali-lote = {&TableName}.dat-valid-lote-fabrican
                   item-doc-orig-nfe.cod-depos    = {&TableName}.cod-depos
                   item-doc-orig-nfe.cod-localiz  = {&TableName}.cod-localiz.

    END.

    RETURN "OK":U.
        


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
        WHEN "ch-acesso-comp-nfe":U THEN ASSIGN pFieldValue = RowObject.ch-acesso-comp-nfe.
        WHEN "cod-barras":U THEN ASSIGN pFieldValue = RowObject.cod-barras.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-lote-fabrican":U THEN ASSIGN pFieldValue = RowObject.cod-lote-fabrican.
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
        WHEN "dat-fabricc-lote":U THEN ASSIGN pFieldValue = RowObject.dat-fabricc-lote.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-valid-lote-fabrican":U THEN ASSIGN pFieldValue = RowObject.dat-valid-lote-fabrican.
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
        WHEN "qtd-lote-fabrican":U THEN ASSIGN pFieldValue = RowObject.qtd-lote-fabrican.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-preco-max-fabrican":U THEN ASSIGN pFieldValue = RowObject.val-preco-max-fabrican.
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
        WHEN "cdn-fabrican":U THEN ASSIGN pFieldValue = RowObject.cdn-fabrican.
        WHEN "idi-orig-trad":U THEN ASSIGN pFieldValue = RowObject.idi-orig-trad.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-rat":U THEN ASSIGN pFieldValue = RowObject.num-seq-rat.
        WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.seq-item.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ratlote-id
  Parameters:  
               retorna valor do campo ch-acesso-comp-nfe
               retorna valor do campo idi-orig-trad
               retorna valor do campo seq-item
               retorna valor do campo num-seq-rat
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE rat-lote-medic-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-orig-trad LIKE rat-lote-medic-nfe.idi-orig-trad NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-item LIKE rat-lote-medic-nfe.seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-rat LIKE rat-lote-medic-nfe.num-seq-rat NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           pidi-orig-trad = RowObject.idi-orig-trad
           pseq-item = RowObject.seq-item
           pnum-seq-rat = RowObject.num-seq-rat.

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
  Purpose:     Reposiciona registro com base no °ndice ratlote-id
  Parameters:  
               recebe valor do campo ch-acesso-comp-nfe
               recebe valor do campo idi-orig-trad
               recebe valor do campo seq-item
               recebe valor do campo num-seq-rat
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE rat-lote-medic-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pidi-orig-trad LIKE rat-lote-medic-nfe.idi-orig-trad NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item LIKE rat-lote-medic-nfe.seq-item NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-rat LIKE rat-lote-medic-nfe.num-seq-rat NO-UNDO.

    FIND FIRST bfrat-lote-medic-nfe WHERE 
        bfrat-lote-medic-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe AND 
        bfrat-lote-medic-nfe.idi-orig-trad = pidi-orig-trad AND 
        bfrat-lote-medic-nfe.seq-item = pseq-item AND 
        bfrat-lote-medic-nfe.num-seq-rat = pnum-seq-rat NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-lote-medic-nfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-lote-medic-nfe)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gravaLoteValid DBOProgram 
PROCEDURE gravaLoteValid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER r-item-nfe AS ROWID NO-UNDO.

    IF AVAIL {&TableName} THEN DO:

        FIND FIRST item-doc-orig-nfe EXCLUSIVE-LOCK
             WHERE rowid(item-doc-orig-nfe) = r-item-nfe NO-ERROR.
        IF AVAIL item-doc-orig-nfe THEN
            ASSIGN item-doc-orig-nfe.lote-serie   = {&TableName}.cod-lote-fabrican
                   item-doc-orig-nfe.dt-vali-lote = {&TableName}.dat-valid-lote-fabrican
                   item-doc-orig-nfe.cod-depos    = {&TableName}.cod-depos
                   item-doc-orig-nfe.cod-localiz  = {&TableName}.cod-localiz.
    END.

    RETURN "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaAbaLoteSerie DBOProgram 
PROCEDURE habilitaAbaLoteSerie :
/*------------------------------------------------------------------------------
 Purpose: Desabilita aba lote/serie para:
           Operaªío de Transferºncia
           Tipo de Operaªío com Terceiros for de Retorno de Beneficiamento ou Devoluªío de Consignaªío
           Devoluªío com nota de origem 

 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM  pc-tipo-operacao AS CHARACTER               NO-UNDO.
    DEFINE OUTPUT PARAM pl-habilita      AS LOGICAL  INITIAL YES    NO-UNDO.

    IF pc-tipo-operacao = "2"  OR
       pc-tipo-operacao = "3"  OR
       pc-tipo-operacao = "5"  OR
       pc-tipo-operacao = "7"  OR
       pc-tipo-operacao = "8"  OR
       pc-tipo-operacao = "9"  OR
       pc-tipo-operacao = "12" OR 
       pc-tipo-operacao = "19" OR  
       pc-tipo-operacao = "21" OR 
       pc-tipo-operacao = "23" THEN
        ASSIGN pl-habilita = NO.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaRateio DBOProgram 
PROCEDURE habilitaRateio :
/*------------------------------------------------------------------------------
 Purpose: Habilita/Desabilita opcao de rateio de estoque na tela HTML:
           Operaªío de Transferºncia
           Tipo de Operaªío com Terceiros for de Retorno de Beneficiamento ou Devoluªío de Consignaªío
           Devoluªío com nota de origem 

 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM  pc-tipo-operacao AS INT                     NO-UNDO.
    DEFINE OUTPUT PARAM pl-habilita      AS LOGICAL  INITIAL YES    NO-UNDO.

    RUN habilitaAbaLoteSerie (INPUT STRING(pc-tipo-operacao), OUTPUT pl-habilita).

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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonitor DBOProgram 
PROCEDURE openQueryMonitor :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
      FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.ch-acesso-comp-nfe = c-ch-acesso-comp-nfe 
           AND {&TableName}.idi-orig-trad      = i-idi-orig-trad     
           AND {&TableName}.seq-item           = i-seq-item 
           INDEXED-REPOSITION.
           
     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMonitor DBOProgram 
PROCEDURE setConstraintMonitor :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pch-acesso-comp-nfe LIKE rat-lote-medic-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM pidi-orig-trad      LIKE rat-lote-medic-nfe.idi-orig-trad      NO-UNDO.
    DEFINE INPUT PARAM pseq-item           LIKE rat-lote-medic-nfe.seq-item           NO-UNDO.
    
    ASSIGN c-ch-acesso-comp-nfe = pch-acesso-comp-nfe
           i-idi-orig-trad      = pidi-orig-trad     
           i-seq-item           = pseq-item .
     
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRastroMedicOF DBOProgram 
PROCEDURE buscaRastroMedicOF:
    DEF INPUT PARAMETER p-rw-it-doc-fisc AS ROWID  NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR RowObject.
    
    FOR FIRST it-doc-fisc NO-LOCK
        WHERE ROWID(it-doc-fisc) = p-rw-it-doc-fisc:

        RUN buscaRastroMedic (INPUT it-doc-fisc.serie        ,
                              INPUT it-doc-fisc.nr-doc-fis   ,
                              INPUT it-doc-fisc.cod-emitente ,
                              INPUT it-doc-fisc.nat-operacao ,
                              INPUT int(substring(it-doc-fisc.cod-livre-1,132,6)), /* Seq item-doc-est na it-doc-fisc */ 
                              OUTPUT TABLE RowObject).

        RETURN RETURN-VALUE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRastroMedic DBOProgram 
PROCEDURE buscaRastroMedic:
    DEF INPUT PARAMETER p-serie-docto  LIKE item-doc-est.serie-docto  NO-UNDO.
    DEF INPUT PARAMETER p-nro-docto    LIKE item-doc-est.nro-docto    NO-UNDO.
    DEF INPUT PARAMETER p-cod-emitente LIKE item-doc-est.cod-emitente NO-UNDO.
    DEF INPUT PARAMETER p-nat-of       LIKE item-doc-est.nat-of       NO-UNDO.
    DEF INPUT PARAMETER p-sequencia    LIKE item-doc-est.sequencia    NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR RowObject.
    
    RUN buscaRastro (INPUT p-serie-docto  ,
                     INPUT p-nro-docto    ,
                     INPUT p-cod-emitente ,
                     INPUT p-nat-of       ,
                     INPUT p-sequencia    ,
                     INPUT YES            , /* Medicamento */
                     INPUT 1              , /* Registro nao traduzido */
                     OUTPUT TABLE RowObject).

    RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaRastro DBOProgram 
PROCEDURE buscaRastro:
    DEF INPUT PARAMETER p-serie-docto   LIKE item-doc-est.serie-docto  NO-UNDO.
    DEF INPUT PARAMETER p-nro-docto     LIKE item-doc-est.nro-docto    NO-UNDO.
    DEF INPUT PARAMETER p-cod-emitente  LIKE item-doc-est.cod-emitente NO-UNDO.
    DEF INPUT PARAMETER p-nat-of        LIKE item-doc-est.nat-of       NO-UNDO.
    DEF INPUT PARAMETER p-sequencia     LIKE item-doc-est.sequencia    NO-UNDO.
    DEF INPUT PARAMETER l-soh-medic     AS LOG                         NO-UNDO.
    DEF INPUT PARAMETER p-idi-orig-trad AS INT                         NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR RowObject.

    EMPTY TEMP-TABLE RowObject.

    FOR FIRST item-doc-est FIELDS () NO-LOCK
        WHERE item-doc-est.serie-docto  = p-serie-docto 
          AND item-doc-est.nro-docto    = p-nro-docto   
          AND item-doc-est.cod-emitente = p-cod-emitente
          AND item-doc-est.nat-of       = p-nat-of      
          AND item-doc-est.sequencia    = p-sequencia, 
        FIRST docum-est FIELDS () NO-LOCK
        WHERE docum-est.serie-docto     = item-doc-est.serie-docto
          AND docum-est.nro-docto       = item-doc-est.nro-docto
          AND docum-est.cod-emitente    = item-doc-est.cod-emitente
          AND docum-est.nat-operacao    = item-doc-est.nat-operacao,
         EACH rat-lote-medic-nfe NO-LOCK
        WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = docum-est.cod-chave-aces-nf-eletro
          AND rat-lote-medic-nfe.seq-item           = INT(SUBSTRING(item-doc-est.char-2,832,5)) /* Seq item conversor NF-e */
          AND rat-lote-medic-nfe.idi-orig-trad      = p-idi-orig-trad:
        
        IF l-soh-medic AND substring(rat-lote-medic-nfe.cod-livre-1,31,20) = "" THEN /* codigo ANVISA */
            NEXT.

        create RowObject.
        buffer-copy rat-lote-medic-nfe to RowObject.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-sugere-dt-estoq DBOProgram 
PROCEDURE pi-sugere-dt-estoq:

    DEF INPUT  PARAM pc-cod-estabel LIKE saldo-estoq.cod-estabel  NO-UNDO.
    DEF INPUT  PARAM pc-it-codigo   LIKE saldo-estoq.it-codigo    NO-UNDO.
    DEF INPUT  PARAM pc-cod-depos   LIKE saldo-estoq.cod-depos    NO-UNDO.
    DEF INPUT  PARAM pc-cod-localiz LIKE saldo-estoq.cod-localiz  NO-UNDO.
    DEF INPUT  PARAM pc-lote        LIKE saldo-estoq.lote         NO-UNDO.
    DEF OUTPUT PARAM p-dt-vali-lote LIKE saldo-estoq.dt-vali-lote NO-UNDO.
    DEF OUTPUT PARAM p-dt-fabr-lote LIKE saldo-estoq.dt-fabric    NO-UNDO.

    FOR FIRST saldo-estoq FIELDS(it-codigo dt-vali-lote dt-fabric) NO-LOCK
         WHERE saldo-estoq.cod-estabel = pc-cod-estabel
           AND saldo-estoq.it-codigo   = pc-it-codigo
           AND saldo-estoq.cod-depos   = pc-cod-depos
           AND saldo-estoq.cod-localiz = pc-cod-localiz
           AND saldo-estoq.lote        = pc-lote:

        ASSIGN p-dt-vali-lote = saldo-estoq.dt-vali-lote.

        FOR FIRST ITEM FIELDS(tipo-con-est) NO-LOCK
            WHERE ITEM.it-codigo = saldo-estoq.it-codigo: 
            IF (ITEM.tipo-con-est = 3 OR ITEM.tipo-con-est = 4) THEN
               ASSIGN p-dt-fabr-lote = saldo-estoq.dt-fabric.
        END.
    END.
  
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaCriacao DBOProgram 
PROCEDURE validaCriacao :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin084               AS HANDLE       NO-UNDO.
    DEFINE VARIABLE h-boin367               AS HANDLE       NO-UNDO.
    DEFINE VARIABLE c-return                AS CHARACTER    NO-UNDO.

    FOR FIRST RowObject NO-LOCK:
    END.
    
    RUN validaAlteracao IN THIS-PROCEDURE.

    FOR FIRST doc-orig-nfe FIELDS (cod-estabel) NO-LOCK
         WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           AND doc-orig-nfe.idi-orig-trad      = 2 /* traduzido */: END.

    IF NOT AVAIL doc-orig-nfe THEN
        RETURN "NOK".

    /* Valida se o dep¢sito for CQ e o item n∆o CQ, n∆o deixa prosseguir  */
    IF RowObject.cod-depos <> "" THEN DO:
        IF  CAN-FIND(FIRST item-uni-estab NO-LOCK
                     WHERE item-uni-estab.it-codigo      = RowObject.it-codigo      AND
                           item-uni-estab.cod-estabel    = doc-orig-nfe.cod-estabel AND  
                           item-uni-estab.contr-qualid   = NO)                      AND
            CAN-FIND(FIRST deposito NO-LOCK
                     WHERE deposito.cod-depos = RowObject.cod-depos AND
                           deposito.ind-dep-cq) THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="57097"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
        END.
    END.

    IF NOT VALID-HANDLE(h-boin084) THEN DO:
        RUN inbo/boin084.p PERSISTENT SET h-boin084.
        RUN openQueryStatic IN h-boin084 (INPUT "Main":U) NO-ERROR.
    END.
    
    run findDeposito in h-boin084 (input RowObject.cod-depos,
                                   output c-return).
    
    if  c-return <> "" then do: /* Nío existe deposito */
       /* Deposito nao encontrado */
       {utp/ut-table.i mgind deposito 1}
       {method/svc/errors/inserr.i &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="RETURN-VALUE"}    
    end.
    DELETE PROCEDURE h-boin084 NO-ERROR.

    RUN inbo/boin367.p PERSISTENT SET h-boin367.
   
    RUN findLocalizacao IN h-boin367 (INPUT doc-orig-nfe.cod-estabel,
                                      INPUT RowObject.cod-localiz,
                                      INPUT RowObject.cod-depos).

    IF RETURN-VALUE <> "OK" THEN DO:
       /* Deposito nao encontrado */
       {utp/ut-liter.i "o_relacionamento_Localizaá∆o_x_Dep¢sito_x_Estabelecimento" *}
       {method/svc/errors/inserr.i &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="RETURN-VALUE"}
    END.
    
    DELETE PROCEDURE h-boin367 NO-ERROR.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAlteracao DBOProgram 
PROCEDURE validaAlteracao :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-tipo-cont-est         AS INTEGER      NO-UNDO.
    DEFINE VARIABLE c-lbl-dt-atual          AS CHARACTER    NO-UNDO.

    FOR FIRST RowObject NO-LOCK:
    END.
    
    FIND FIRST item WHERE item.it-codigo = RowObject.it-codigo NO-LOCK NO-ERROR.
    IF AVAIL item THEN
        ASSIGN i-tipo-cont-est = item.tipo-con-est.

    IF i-tipo-cont-est = 3 /* Lote */  OR
       i-tipo-cont-est = 2 /* Nr SÇrie*/ THEN DO:

       IF RowObject.cod-lote-fabrican = "" OR RowObject.cod-lote-fabrican = ? THEN DO:
           {utp/ut-liter.i Lote/Nr_SÇrie  *}
           {method/svc/errors/inserr.i &ErrorNumber="688"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="RETURN-VALUE"}
       END.

       IF RowObject.dat-valid-lote-fabrican < TODAY THEN DO:
           {utp/ut-liter.i Data_de_Validade *}
           ASSIGN c-lbl-dt-atual = RETURN-VALUE.
           {utp/ut-liter.i data_atual *}
           {method/svc/errors/inserr.i &ErrorNumber="416"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="c-lbl-dt-atual + '~~~~' + RETURN-VALUE"}
       END.
    END.

    IF i-tipo-cont-est > 2 AND RowObject.dat-valid-lote-fabrican = ? THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="19481"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="RowObject.it-codigo"}
    END.

    IF  i-tipo-cont-est > 1 /* Lote, Nr de serie, Referencia */ THEN DO:
        IF RowObject.dat-fabricc-lote = ? THEN DO:
             {utp/ut-liter.i Data_de_Fabricaá∆o *}
             {method/svc/errors/inserr.i &ErrorNumber="688"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="RETURN-VALUE"}
        END.
        
        IF RowObject.dat-fabricc-lote  > TODAY THEN DO:
            {utp/ut-liter.i de_Fabricaá∆o *}
            {method/svc/errors/inserr.i &ErrorNumber="15332"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF i-tipo-cont-est <> 2 /* Nr SÇrie */ THEN DO:
        IF RowObject.qtd-lote-fabrican <= 0 THEN DO:
         {utp/ut-liter.i Quantidade *}
         {method/svc/errors/inserr.i &ErrorNumber="36"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR"
                                     &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF i-tipo-cont-est = 1 THEN DO:
        IF RowObject.cod-lote-fabrican <> "":U AND RowObject.cod-lote-fabrican <> ? THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="27033" /* Item com tipo controle serial. Lote nao deve ser informado. */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.
        IF RowObject.dat-valid-lote-fabrican <> ? THEN DO:
            {utp/ut-liter.i Item_com_tipo_controle_serial._Data_validade_lote *}
            {method/svc/errors/inserr.i &ErrorNumber="7446" /* Item com tipo controle serial. Data de validade do lote nao deve ser informada. */
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF  i-pais-impto-usuario = 1 AND
        CAN-FIND( FIRST funcao
                  WHERE funcao.cd-funcao = "WMS-SAAS"
                    AND funcao.ativo     = YES) AND
        CAN-FIND(FIRST deposito NO-LOCK
                 WHERE deposito.cod-depos = RowObject.cod-depos
                   AND deposito.log-wms-externo) AND
        RowObject.cod-localiz <> "" THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="57560"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"}
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableLote DBOProgram 
PROCEDURE enableLote :
    DEFINE INPUT PARAMETER  c-it-codigo      AS CHAR       NO-UNDO.
    DEFINE OUTPUT PARAMETER l-enable         AS LOG        NO-UNDO.

    ASSIGN l-enable = CAN-FIND(item where item.it-codigo = c-it-codigo and item.tipo-con-est > 1 /* Lote, Nr de serie, Referencia */ ).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableQtdLoteFabrican DBOProgram 
PROCEDURE enableQtdLoteFabrican :
    DEFINE INPUT PARAMETER  c-it-codigo      AS CHAR       NO-UNDO.
    DEFINE OUTPUT PARAMETER l-enable         AS LOG        NO-UNDO.

    ASSIGN l-enable = CAN-FIND(item where item.it-codigo = c-it-codigo and item.tipo-con-est <> 2 /* nr serie */ ).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableCodLocaliz DBOProgram 
PROCEDURE enableCodLocaliz :
    DEFINE INPUT PARAMETER  c-it-codigo      AS CHAR       NO-UNDO.
    DEFINE INPUT PARAMETER  c-cod-estabel    AS CHAR       NO-UNDO.
    DEFINE INPUT PARAMETER  c-cod-depos      AS CHAR       NO-UNDO. /* deposito atual informado a nivel de item */
    DEFINE OUTPUT PARAMETER l-enable         AS LOG        NO-UNDO.

    RUN carregaSugestaoDeposLocalizELocalizUnica (c-it-codigo, c-cod-estabel, c-cod-depos).

    ASSIGN l-enable = NOT l-loc-unica.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaSugestaoDeposLocalizELocalizUnica DBOProgram 
PROCEDURE carregaSugestaoDeposLocalizELocalizUnica :
    DEFINE INPUT PARAMETER c-it-codigo      AS CHAR       NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-estabel    AS CHAR       NO-UNDO.
    DEFINE INPUT PARAMETER c-cod-depos      AS CHAR       NO-UNDO. /* deposito atual informado a nivel de item */

    RUN cep/ceapi014.p (input c-it-codigo,
                        INPUT c-cod-estabel,
                        OUTPUT c-sug-cod-deposito,
                        OUTPUT c-sug-cod-localizacao,
                        OUTPUT l-loc-unica).

    IF CAN-FIND (item-uni-estab WHERE item-uni-estab.it-codigo   = c-it-codigo
                                  AND item-uni-estab.cod-estabel = c-cod-estabel
                                  AND item-uni-estab.contr-qualid) THEN /* Tem controle de qualidade para o item - mantem o mesmo deposito ja informado a nivel de item */
        ASSIGN c-sug-cod-deposito = c-cod-depos.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSugestaoCodLocaliz DBOProgram 
PROCEDURE getSugestaoCodLocaliz :
    /* IMPORTANTE: Rodar antes a procedure carregaSugestaoDeposLocalizELocalizUnica */
    DEFINE OUTPUT PARAMETER c-cod-localiz         AS CHAR        NO-UNDO.

    ASSIGN c-cod-localiz = c-sug-cod-localizacao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSugestaoCodDepos DBOProgram 
PROCEDURE getSugestaoCodDepos :
    /* IMPORTANTE: Rodar antes a procedure carregaSugestaoDeposLocalizELocalizUnica */
    DEFINE OUTPUT PARAMETER c-cod-depos         AS CHAR        NO-UNDO.

    ASSIGN c-cod-depos = c-sug-cod-deposito.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE isLocalizUnica DBOProgram 
PROCEDURE isLocalizUnica :
    /* IMPORTANTE: Rodar antes a procedure carregaSugestaoDeposLocalizELocalizUnica */
    DEFINE OUTPUT PARAMETER l-localiz-unica         AS LOG        NO-UNDO.

    ASSIGN l-localiz-unica = l-loc-unica.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecordRateioLoteTerceiros DBOProgram 
PROCEDURE validateRecordRateioLoteTerceiros :
    DEFINE VARIABLE h-boin084               AS HANDLE       NO-UNDO.
    DEFINE VARIABLE h-boin367               AS HANDLE       NO-UNDO.
    DEFINE VARIABLE c-return                AS CHARACTER    NO-UNDO.

    FOR FIRST RowObject NO-LOCK: END.

    FOR FIRST doc-orig-nfe FIELDS (cod-estabel) NO-LOCK
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
          AND doc-orig-nfe.idi-orig-trad      = 2 /* traduzido */: END.

    IF NOT AVAIL doc-orig-nfe THEN
        RETURN "NOK".

    /* validacao item fracionado */
    IF CAN-FIND(FIRST item WHERE item.it-codigo = RowObject.it-codigo AND item.fraciona = NO) AND
       INTEGER(RowObject.qtd-lote-fabrican) <> RowObject.qtd-lote-fabrican THEN DO:
       {method/svc/errors/inserr.i &ErrorNumber="6381"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"}
    END.

    RUN inbo/boin084.p PERSISTENT SET h-boin084.
    RUN openQueryStatic IN h-boin084 (INPUT "Main":U) NO-ERROR.
    run findDeposito in h-boin084 (input RowObject.cod-depos,
                                   output c-return).
    if  c-return <> "" then do: /* Nao existe deposito */
       /* Deposito nao encontrado */
       {utp/ut-table.i mgind deposito 1}
       {method/svc/errors/inserr.i &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="RETURN-VALUE"}
    end.

    RUN inbo/boin367.p PERSISTENT SET h-boin367.
    RUN findLocalizacao IN h-boin367 (INPUT doc-orig-nfe.cod-estabel,
                                      INPUT RowObject.cod-localiz,
                                      INPUT RowObject.cod-depos).

    IF RETURN-VALUE <> "OK" THEN DO:
       /* Localizacao nao encontrada */
       {utp/ut-liter.i "Relacionamento_Localizaá∆o_x_Dep¢sito_x_Estabelecimento" *}
       {method/svc/errors/inserr.i &ErrorNumber="56"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="RETURN-VALUE"}
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin084 NO-ERROR.
        DELETE PROCEDURE h-boin367 NO-ERROR.
    END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
