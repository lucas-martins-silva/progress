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
{include/i-prgvrs.i BOIN858 2.00.00.025 } /*** "010025" 21/10/2026 11:07:10 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin858 MUT}
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
&GLOBAL-DEFINE DBOName BOin858
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-ref-nfe
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
{inbo/boin858.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


DEFINE TEMP-TABLE tt-saldo-aux NO-UNDO LIKE item-ref-nfe
    FIELD l-referenciada AS LOGICAL
    FIELD dt-saldo       AS DATE
    FIELD vl-unit-calc   AS DECIMAL
    FIELD qtd-um-emit    LIKE item-ref-nfe.qtd-alocada
    FIELD qtd-comercial  LIKE item-ref-nfe.qtd-alocada
    FIELD qtd-alocar     LIKE item-ref-nfe.qtd-alocada
    FIELD vl-original    AS DECIMAL
    FIELD vl-unit        AS DECIMAL
    FIELD vl-total       AS DECIMAL
    FIELD vl-tot-item    AS DECIMAL.

DEFINE TEMP-TABLE tt-saldo-terc-aux NO-UNDO LIKE item-ref-nfe
       FIELD l-referenciada AS LOGICAL
       FIELD dt-saldo       AS DATE
       FIELD dt-retorno     AS DATE
       FIELD qtd-comercial  LIKE item-ref-nfe.qtd-alocada
       field qtd-alocar     like item-ref-nfe.qtd-alocada
       FIELD vlr-unit-item  LIKE it-nota-fisc.vl-preuni
       FIELD vlr-tot-item   LIKE it-nota-fisc.vl-tot-item
       FIELD narrativa-item LIKE nar-it-nota.narrativa.

{inbo/boin00892.i tt-rat-lote-medic-terc} /* Rateio de lotes Faturamento consignacao */

DEFINE TEMP-TABLE tt-rat-saldo-terc-dep NO-UNDO LIKE rat-saldo-terc
       field qtd-digitada as dec
       FIELD r-rowid AS ROWID 
       INDEX id IS PRIMARY UNIQUE serie-docto nro-docto cod-emitente nat-operacao it-codigo cod-refer sequencia lote cod-depos cod-localiz.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-chave-acesso             AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE de-qtd-vinc                LIKE item-ref-nfe.qtd-alocada     NO-UNDO.
DEFINE VARIABLE de-qtd-alocada-antes-save  LIKE item-ref-nfe.qtd-alocada     NO-UNDO.

DEFINE VARIABLE c-origem-vinculo       AS CHARACTER    INIT "RE0118f":U        NO-UNDO. 

DEFINE VARIABLE l-create-msg-ret-devol  AS LOGICAL   INITIAL YES              NO-UNDO.

DEFINE VARIABLE l-fatura-fat-antecip  AS LOG NO-UNDO.
DEFINE VARIABLE l-remessa-fat-antecip AS LOG NO-UNDO.
DEFINE VARIABLE l-fatura-ent-futura   AS LOG NO-UNDO.
DEFINE VARIABLE l-remessa-ent-futura  AS LOG NO-UNDO.


def new Global shared var c-seg-usuario as char format "x(12)" no-undo.
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
         HEIGHT             = 16.92
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuscaSaldoVincul DBOProgram 
PROCEDURE BuscaSaldoVincul :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-saldo-aux.

    FOR EACH tt-saldo-aux:
        ASSIGN de-qtd-vinc = 0.

        FOR EACH item-ref-nfe  
           WHERE item-ref-nfe.nro-docto      = tt-saldo-aux.nro-docto
             AND item-ref-nfe.cod-emitente   = tt-saldo-aux.cod-emitente
             AND item-ref-nfe.serie-docto    = tt-saldo-aux.serie-docto
             AND item-ref-nfe.nat-operacao   = tt-saldo-aux.nat-operacao
             AND item-ref-nfe.it-codigo      = tt-saldo-aux.it-codigo
             AND item-ref-nfe.seq-saldo-terc = tt-saldo-aux.seq-saldo-terc NO-LOCK:

            for first doc-orig-nfe no-lock
                where doc-orig-nfe.ch-acesso-comp-nfe  = item-ref-nfe.ch-acesso-comp-nfe
                  and doc-orig-nfe.idi-orig-trad = 2:
            end.
            
            IF doc-orig-nfe.idi-situacao = 1  /* Digitada Receb. Fiscal  */   OR     
               doc-orig-nfe.idi-situacao = 3  /* Atualizada Receb. Fiscal */  OR
               doc-orig-nfe.idi-situacao = 6  /* Digitada Receb. F°sico */    OR
               doc-orig-nfe.idi-situacao = 7  /* Atualizada Receb. F°sico */  OR
               doc-orig-nfe.idi-situacao = 10 /* Gerado via Originaá∆o */     THEN NEXT.
                
            IF item-ref-nfe.qtd-alocada > 0 THEN
                ASSIGN de-qtd-vinc = de-qtd-vinc + item-ref-nfe.qtd-alocada.
        END.
    
        ASSIGN tt-saldo-aux.qtd-comercial = de-qtd-vinc
               tt-saldo-aux.qtd-alocada   = tt-saldo-aux.qtd-alocada - de-qtd-vinc
               tt-saldo-aux.qtd-alocar    = tt-saldo-aux.qtd-alocada.
    END.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaDocumentosReferenciados DBOProgram 
PROCEDURE eliminaDocumentosReferenciados :
/*------------------------------------------------------------------------------
  Purpose: Elimina notas referenciadas para manter integridade no conversor    
  Parameters: c-chave-acesso-nfe: Chave de acesso completa da NFe
              i-seq-item: Sequància do item 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM c-chave-acesso-nfe LIKE item-ref-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAM i-seq-item         LIKE item-ref-nfe.seq-item           NO-UNDO.
  
    for each bf{&TableName} exclusive-lock
        where bf{&TableName}.ch-acesso-comp-nfe = c-chave-acesso-nfe
        and   bf{&TableName}.seq-item           = i-seq-item:
        /* O recebimento j† desalocou o saldo, apenas deleta a referància. */
        delete bf{&TableName}.
    end.

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
        WHEN "ch-acesso-nfe":U THEN ASSIGN pFieldValue = RowObject.ch-acesso-nfe.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
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
        WHEN "qtd-alocada":U THEN ASSIGN pFieldValue = RowObject.qtd-alocada.
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
        WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.seq-item.
        WHEN "seq-saldo-terc":U THEN ASSIGN pFieldValue = RowObject.seq-saldo-terc.
        WHEN "seq-item-xml":U THEN ASSIGN pFieldValue = RowObject.seq-item-xml.
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
               retorna valor do campo seq-item
               retorna valor do campo seq-saldo-terc
               retorna valor do campo nro-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE item-ref-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-item LIKE item-ref-nfe.seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-saldo-terc LIKE item-ref-nfe.seq-saldo-terc NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE item-ref-nfe.nro-docto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           pseq-item = RowObject.seq-item
           pseq-saldo-terc = RowObject.seq-saldo-terc
           pnro-docto = RowObject.nro-docto.

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
               recebe valor do campo seq-item
               recebe valor do campo seq-saldo-terc
               recebe valor do campo nro-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE item-ref-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item LIKE item-ref-nfe.seq-item NO-UNDO.
    DEFINE INPUT PARAMETER pseq-saldo-terc LIKE item-ref-nfe.seq-saldo-terc NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE item-ref-nfe.nro-docto NO-UNDO.

    FIND FIRST bfitem-ref-nfe WHERE 
        bfitem-ref-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe AND 
        bfitem-ref-nfe.seq-item = pseq-item AND 
        bfitem-ref-nfe.seq-saldo-terc = pseq-saldo-terc AND 
        bfitem-ref-nfe.nro-docto = pnro-docto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-ref-nfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-ref-nfe)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMonitor DBOProgram 
PROCEDURE openQueryMonitor :
/*------------------------------------------------------------------------------
  Purpose: Abertura da query a ser utilizada pelo monitor do conversor (com base
           na chave de acesso do documento)    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
        FOR EACH {&TableName}
            WHERE {&TableName}.ch-acesso-comp-nfe = c-chave-acesso NO-LOCK.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMonitor DBOProgram 
PROCEDURE setConstraintMonitor :
/*------------------------------------------------------------------------------
  Purpose: Setar os dados a serem utilizados na query do monitor do conversor    
  Parameters: p-chave-acesso: Chave de acesso do documento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-chave-acesso AS CHAR NO-UNDO.

    ASSIGN c-chave-acesso = p-chave-acesso.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord:

    IF RowObject.seq-item-xml = 0 THEN DO:

       FIND FIRST doc-orig-refer-nfe
            WHERE doc-orig-refer-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
              AND doc-orig-refer-nfe.idi-orig-trad      = 2 NO-LOCK NO-ERROR.
              
       IF AVAIL doc-orig-refer-nfe THEN DO:
           
          FOR FIRST it-nota-fisc NO-LOCK
              WHERE it-nota-fisc.cod-estabel = doc-orig-refer-nfe.cod-estabel
                AND it-nota-fisc.serie       = RowObject.serie-docto
                AND it-nota-fisc.nr-nota-fis = RowObject.nro-docto
                AND it-nota-fisc.nr-seq-fat  = RowObject.seq-saldo-terc
                AND it-nota-fisc.it-codigo   = RowObject.it-codigo:
                
             IF INT(SUBSTRING(it-nota-fisc.char-2,370,5)) > 0 THEN
                ASSIGN RowObject.seq-item-xml = INT(SUBSTRING(it-nota-fisc.char-2,370,5)).
             ELSE DO:
                /*Se a referància foi feita por item o campo doc-orig-refer-nfe.num-seq corresponde a sequància do item no XML da NFD*/
                IF doc-orig-refer-nfe.ref-por-item THEN DO:
                   FIND FIRST doc-orig-refer-nfe
                        WHERE doc-orig-refer-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
                          AND doc-orig-refer-nfe.idi-orig-trad      = 2
                          AND doc-orig-refer-nfe.num-seq            = RowObject.seq-item NO-LOCK NO-ERROR.
                    
                   /*Se a nota fiscal escolhida manualmente Ç igual a referenciada no XML e n∆o achou a sequància do item no XML na it-nota-fisc, 
                     usar a seq-item-xml da doc-orig-refer-nfe*/
                   IF doc-orig-refer-nfe.ch-acesso-nfe <> "" AND 
                      doc-orig-refer-nfe.serie-docto   = RowObject.serie-docto AND 
                      doc-orig-refer-nfe.nro-docto     = RowObject.nro-docto THEN
                      ASSIGN RowObject.seq-item-xml = doc-orig-refer-nfe.seq-item-xml.

                END.
             END.
          END.
       END.
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

    DEFINE VARIABLE h-boin176     AS HANDLE      NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    ASSIGN de-qtd-alocada-antes-save = 0.

    RUN findDocOrigNfe.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    RUN findItemDocOrigNfe.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    /* valida situacoes as quais nao pode ser executada a atualizacao do registro */
    IF CAN-DO("1,3,5,6,7,8,9,10", STRING(doc-orig-nfe.idi-situacao)) THEN DO:
        IF (doc-orig-nfe.idi-situacao = 5 /* Cancelada */ AND CAN-FIND(FIRST param-convrsr-nfe WHERE param-convrsr-nfe.log-bloq-nfe-cancda)) OR 
            doc-orig-nfe.idi-situacao <> 5 THEN DO:
            DEF VAR c-sit-txt AS CHAR NO-UNDO.
            assign c-sit-txt = {ininc/i01in847.i 04 doc-orig-nfe.idi-situacao}. /* Nao eh permitida alteracao de documento em situacoes dif de erro negoc, elimin e cancelada */
            {method/svc/errors/inserr.i &ErrorNumber="57071"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="c-sit-txt"}
            RETURN "NOK":U.
        END.
    end.
    
    RUN inbo/boin176.p PERSISTENT SET h-boin176.
    RUN getFatAntecipEntFutura IN h-boin176(INPUT item-doc-orig-nfe.nat-operacao,
                                            OUTPUT l-fatura-fat-antecip,
                                            OUTPUT l-remessa-fat-antecip,
                                            OUTPUT l-fatura-ent-futura, 
                                            OUTPUT l-remessa-ent-futura).
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF item-doc-orig-nfe.int-2 = 2 THEN DO: /* Tipo operacao Devolucao */
            RUN validaQtdAlocar (INPUT RowObject.ch-acesso-comp-nfe,
                                 INPUT RowObject.seq-item,
                                 INPUT TABLE tt-saldo-aux).

            IF c-origem-vinculo = 'API-REST' THEN DO:
                RUN consideraPrecoUnitDevol (INPUT RowObject.ch-acesso-comp-nfe,
                                             INPUT RowObject.seq-item,
                                             INPUT TABLE tt-saldo-aux).
            END.
        END.
        ELSE DO: /* Terceiros */
            RUN validaSaldoTerc (INPUT RowObject.ch-acesso-comp-nfe,
                                 INPUT RowObject.seq-item,
                                 INPUT TABLE tt-saldo-terc-aux).

            FOR FIRST item-ref-nfe NO-LOCK
                WHERE item-ref-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
                  AND item-ref-nfe.seq-item           = RowObject.seq-item
                  AND item-ref-nfe.nro-docto          = RowObject.nro-docto
                  AND item-ref-nfe.seq-saldo-terc     = RowObject.seq-saldo-terc:
                ASSIGN de-qtd-alocada-antes-save = item-ref-nfe.qtd-alocada.
            END.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

    CATCH eSysError AS Progress.Lang.SysError:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorNumber = 17006
               RowErrors.ErrorDescription = eSysError:getMessage(1)
               RowErrors.ErrorSubType = "ERROR".
    END.
    FINALLY:
        RUN destroy in h-boin176.
        DELETE PROCEDURE h-boin176 NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDocOrigNfe DBOProgram 
PROCEDURE findDocOrigNfe:

    IF NOT AVAIL RowObject THEN RETURN "NOK":U.

    IF NOT AVAIL doc-orig-nfe OR
       doc-orig-nfe.ch-acesso-comp-nfe <> RowObject.ch-acesso-comp-nfe THEN DO:
        FOR FIRST doc-orig-nfe NO-LOCK
            WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
              AND doc-orig-nfe.idi-orig-trad      = 2: END.
        IF NOT AVAIL doc-orig-nfe THEN DO:
            {utp/ut-liter.i Documento_XML_NF-e *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="RETURN-VALUE"}
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemDocOrigNfe DBOProgram 
PROCEDURE findItemDocOrigNfe:

    IF NOT AVAIL RowObject THEN RETURN "NOK":U.

    IF NOT AVAIL item-doc-orig-nfe OR
       item-doc-orig-nfe.ch-acesso-comp-nfe <> RowObject.ch-acesso-comp-nfe OR
       item-doc-orig-nfe.seq-item           <> RowObject.seq-item THEN DO:
        FOR FIRST item-doc-orig-nfe NO-LOCK
            WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
              AND item-doc-orig-nfe.seq-item           = RowObject.seq-item
              AND item-doc-orig-nfe.idi-orig-trad      = 2: END.
        IF NOT AVAIL item-doc-orig-nfe THEN DO:
            {utp/ut-liter.i Item_documento_XML_NF-e *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="RETURN-VALUE"}
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord:

    RUN findItemDocOrigNfe.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    IF item-doc-orig-nfe.int-2 = 2 THEN DO: /* Tipo operacao de devolucao */
        RUN afterSaveRecordDevolucao.
    END.
    ELSE
        RUN afterSaveRecordTerceiros.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord:

    RUN findItemDocOrigNfe.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    IF item-doc-orig-nfe.int-2 = 2 THEN DO: /* Tipo operacao de devolucao */
        RUN afterSaveRecordDevolucao.
    END.
    ELSE DO:
        RUN afterSaveRecordTerceiros.

        /* soh quando for update, remove os saldos anteriores, pois foi adicionado mais saldo do mesmo documento */
        IF item-doc-orig-nfe.int-2 = 7 THEN DO: /* tipo operacao = faturamento de consignaá∆o */
            IF CAN-FIND(FIRST item WHERE item.it-codigo = item-doc-orig-nfe.it-codigo
                                     AND item.tipo-con-est = 3 OR item.tipo-con-est = 4) THEN DO: /* lote ou referencia */
                FOR EACH rat-lote-medic-nfe EXCLUSIVE-LOCK 
                   WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = item-doc-orig-nfe.ch-acesso-comp-nfe
                     AND rat-lote-medic-nfe.seq-item           = RowObject.seq-saldo-terc
                     AND rat-lote-medic-nfe.idi-orig-trad      = 2:

                    /* Char onde eh gravado o numero do documento de saida */
                    IF SUBSTRING(rat-lote-medic-nfe.cod-livre-1,51,16) = RowObject.nro-docto THEN
                        DELETE rat-lote-medic-nfe.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveRecordDevolucao DBOProgram 
PROCEDURE afterSaveRecordDevolucao PRIVATE:

    /* Atualiza natureza de operacao de entrada baseada na complementar cadastrada na natureza de saida */
    DEF VAR cNatComp AS CHAR NO-UNDO.
    IF item-doc-orig-nfe.nat-operacao = "":U THEN DO:
        FIND FIRST natur-oper
             WHERE natur-oper.nat-operacao = RowObject.nat-operacao NO-LOCK NO-ERROR. /* natureza de saida */

        IF AVAIL natur-oper AND natur-oper.nat-comp <> "":U THEN DO:
            ASSIGN cNatComp = natur-oper.nat-comp.

            IF CAN-FIND(FIRST natur-oper WHERE natur-oper.nat-operacao = cNatComp     /* natureza de entrada */
                                           AND natur-oper.tipo-compra  = 3) THEN DO:  /* Devolucao cliente */
                FIND CURRENT item-doc-orig-nfe EXCLUSIVE-LOCK NO-ERROR.
                ASSIGN item-doc-orig-nfe.nat-operacao = cNatComp.
                FIND CURRENT item-doc-orig-nfe NO-LOCK NO-ERROR.
            END.
        END.
    END.

    /* Se o item nao foi traduzido, assume o item do saldo selecionado */
    IF item-doc-orig-nfe.it-codigo = "":U AND RowObject.it-codigo <> "":U THEN DO:
        FIND CURRENT item-doc-orig-nfe EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN item-doc-orig-nfe.it-codigo = RowObject.it-codigo.
        FIND CURRENT item-doc-orig-nfe NO-LOCK NO-ERROR.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveRecordTerceiros DBOProgram 
PROCEDURE afterSaveRecordTerceiros PRIVATE:
    DEFINE VARIABLE h-boin404re     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin857       AS HANDLE      NO-UNDO.

    RUN inbo/boin404re.p PERSISTENT SET h-boin404re.
    RUN inbo/boin857.p PERSISTENT SET h-boin857.

    /* Se o item nao foi traduzido, assume o item do saldo selecionado e 
       seta conta/ccusto/unid negocio para branco para que na geracao pegue esses dados do saldo de terceiros */
    IF item-doc-orig-nfe.it-codigo = "":U AND RowObject.it-codigo <> "":U THEN DO:
        FIND CURRENT item-doc-orig-nfe EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN item-doc-orig-nfe.it-codigo      = RowObject.it-codigo
               item-doc-orig-nfe.ct-codigo      = ""
               item-doc-orig-nfe.sc-codigo      = ""
               item-doc-orig-nfe.cod-unid-negoc = "".
        FIND CURRENT item-doc-orig-nfe NO-LOCK NO-ERROR.
    END.

    FOR FIRST tt-saldo-terc-aux:
        /* Aloca o saldo em poder de terceiros. */
        run alocaSaldoTerc in h-boin404re (input yes,
                                           input (RowObject.qtd-alocada - de-qtd-alocada-antes-save),
                                           input RowObject.seq-saldo-terc,
                                           input RowObject.cod-emitente,
                                           input RowObject.nro-docto,
                                           input RowObject.serie-docto,
                                           input item-doc-orig-nfe.nat-operacao, /* Natureza do item. */
                                           input RowObject.nat-operacao,         /* Natureza do saldo em terceiros. */
                                           input RowObject.it-codigo).
    END.

    /* Sugere lote e data de validade do lote. */
    run retornaValidadeLoteRefer in h-boin857 (input RowObject.serie-docto,
                                               input RowObject.nro-docto,
                                               input RowObject.nat-operacao,
                                               input item-doc-orig-nfe.it-codigo,
                                               input item-doc-orig-nfe.cod-refer,
                                               input item-doc-orig-nfe.ch-acesso-comp-nfe,
                                               input item-doc-orig-nfe.seq-item,
                                               input RowObject.seq-saldo-terc,
                                               input RowObject.cod-emitente).

    if l-remessa-ent-futura then
        run atualizaComprasRemessaEntFut.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin404re NO-ERROR.
        DELETE PROCEDURE h-boin857 NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord:
    DEFINE VARIABLE h-boin404re     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin857       AS HANDLE      NO-UNDO.
    RUN inbo/boin404re.p PERSISTENT SET h-boin404re.
    RUN inbo/boin857.p PERSISTENT SET h-boin857.

    RUN findItemDocOrigNfe.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN RETURN-VALUE.

    IF item-doc-orig-nfe.int-2 <> 2 THEN DO: /* Tipo operacao diferente de devolucao, ou seja, terceiros */
        /* Desaloca o saldo em poder de terceiros da quantidade eliminada */
        run alocaSaldoTerc in h-boin404re (input no,
                                           input RowObject.qtd-alocada,
                                           input RowObject.seq-saldo-terc,
                                           input RowObject.cod-emitente,
                                           input RowObject.nro-docto,
                                           input RowObject.serie-docto,
                                           input item-doc-orig-nfe.nat-operacao, /* Natureza do item. */
                                           input RowObject.nat-operacao,         /* Natureza do saldo em terceiros. */
                                           input RowObject.it-codigo).

        /* Desaloca o saldo da ordem de compra remessa entrega futura */
        IF  l-remessa-ent-futura THEN DO:
            run pi-aloca-ordem-cc in h-boin857(input NO,
                                               input item-doc-orig-nfe.numero-ordem,
                                               input item-doc-orig-nfe.parcela,
                                               input RowObject.qtd-alocada).

            FIND CURRENT item-doc-orig-nfe EXCLUSIVE-LOCK NO-ERROR.
            ASSIGN item-doc-orig-nfe.num-pedido    = 0
                   item-doc-orig-nfe.numero-ordem  = 0
                   item-doc-orig-nfe.parcela       = 0.
            FIND CURRENT item-doc-orig-nfe NO-LOCK NO-ERROR.
        END.

        FOR EACH rat-lote-medic-nfe
           WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
             AND rat-lote-medic-nfe.seq-item           = RowObject.seq-saldo-terc
             AND rat-lote-medic-nfe.idi-orig-trad      = 2 EXCLUSIVE-LOCK:
             IF SUBSTRING(rat-lote-medic-nfe.cod-livre-1,51,16) = RowObject.nro-docto THEN
                DELETE rat-lote-medic-nfe.
        END.
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin404re NO-ERROR.
        DELETE PROCEDURE h-boin857 NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaQtdAlocar DBOProgram 
PROCEDURE validaQtdAlocar :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pch-acesso-comp-nfe LIKE item-doc-orig-nfe.ch-acesso-comp-nfe.
    DEF INPUT PARAM pseq-item           LIKE item-doc-orig-nfe.seq-item.
    DEF INPUT PARAM TABLE FOR tt-saldo-aux.

    FIND FIRST tt-saldo-aux NO-LOCK NO-ERROR.

    FIND FIRST item-doc-orig-nfe
         WHERE item-doc-orig-nfe.ch-acesso-comp-nfe  = pch-acesso-comp-nfe
           AND item-doc-orig-nfe.seq-item            = pseq-item
           AND item-doc-orig-nfe.idi-orig-trad       = 2 NO-LOCK NO-ERROR. 

    IF AVAIL item-doc-orig-nfe AND 
       AVAIL tt-saldo-aux THEN DO:

        IF (item-doc-orig-nfe.qtd-interna = 0 OR tt-saldo-aux.qtd-alocada = 0) AND 
            NOT tt-saldo-aux.qtd-alocar      = 0 THEN DO:
             {utp/ut-liter.i "vincular_ao_Item/Nota" *}
             {method/svc/errors/inserr.i &ErrorNumber="52011"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF tt-saldo-aux.qtd-alocar = 0 AND
           NOT CAN-FIND(FIRST item-ref-nfe 
                        WHERE item-ref-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe
                          AND item-ref-nfe.nro-docto          = tt-saldo-aux.nro-docto
                          AND item-ref-nfe.cod-emitente       = tt-saldo-aux.cod-emitente
                          AND item-ref-nfe.serie-docto        = tt-saldo-aux.serie-docto
                          AND item-ref-nfe.nat-operacao       = tt-saldo-aux.nat-operacao
                          AND item-ref-nfe.seq-saldo-terc     = tt-saldo-aux.seq-saldo-terc
                          AND item-ref-nfe.seq-item           = pseq-item) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="52012"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.

        IF tt-saldo-aux.qtd-alocar > tt-saldo-aux.qtd-alocada THEN DO: // qtd-alocada eh o saldo
             {utp/ut-liter.i "Quantidade_a_alocar" *}
             {method/svc/errors/inserr.i &ErrorNumber="34809"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + STRING(tt-saldo-aux.qtd-alocada)"}
        END.
       
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setOrigemVinculo DBOProgram 
PROCEDURE setOrigemVinculo:
     DEF INPUT  PARAM p-origem-vinculo AS CHAR NO-UNDO.
    ASSIGN c-origem-vinculo = p-origem-vinculo.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createMsgRetDevol DBOProgram 
PROCEDURE createMsgRetDevol:
    DEF INPUT  PARAM p-create-msg-ret-devol AS LOGICAL NO-UNDO.
    ASSIGN l-create-msg-ret-devol = p-create-msg-ret-devol.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE consideraPrecoUnitDevol DBOProgram 
PROCEDURE consideraPrecoUnitDevol :
    DEF INPUT PARAM pch-acesso-comp-nfe LIKE item-doc-orig-nfe.ch-acesso-comp-nfe.
    DEF INPUT PARAM pseq-item           LIKE item-doc-orig-nfe.seq-item.
    DEF INPUT PARAM TABLE FOR tt-saldo-aux.

    DEFINE VARIABLE de-valor-max        AS DECIMAL  FORMAT "->>,>>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-valor-min        AS DECIMAL  FORMAT "->>,>>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-pre-unit-interno AS DECIMAL  FORMAT "->>,>>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-pre-unit-fat     AS DECIMAL  FORMAT "->>,>>>,>>>,>>9.9999":U NO-UNDO.
    DEFINE VARIABLE de-indice           AS DECIMAL                                  NO-UNDO.
    DEFINE VARIABLE de-indice-fat       AS DECIMAL                                  NO-UNDO.
    
    FIND FIRST param-convrsr-nfe NO-LOCK NO-ERROR.
    IF  AVAIL param-convrsr-nfe 
    AND param-convrsr-nfe.log-preco-unit-devol THEN DO:

        FIND FIRST tt-saldo-aux NO-LOCK NO-ERROR.
        IF AVAIL tt-saldo-aux THEN DO:
    
           FOR FIRST item-doc-orig-nfe NO-LOCK
               WHERE item-doc-orig-nfe.ch-acesso-comp-nfe  = pch-acesso-comp-nfe
                 AND item-doc-orig-nfe.seq-item            = pseq-item
                 AND item-doc-orig-nfe.idi-orig-trad       = 2: END.
           
           ASSIGN de-indice = item-doc-orig-nfe.qtd-comercial / item-doc-orig-nfe.qtd-interna
                  de-pre-unit-interno = round(item-doc-orig-nfe.preco-unit * de-indice,4).
           
           ASSIGN  de-valor-max  = de-pre-unit-interno + param-convrsr-nfe.var-valor-preco-unit-devol
                   de-valor-min  = de-pre-unit-interno - param-convrsr-nfe.var-valor-preco-unit-devol.
           
           FOR FIRST doc-orig-nfe NO-LOCK
               WHERE doc-orig-nfe.ch-acesso-comp-nfe  = item-doc-orig-nfe.ch-acesso-comp-nfe
                 AND doc-orig-nfe.idi-orig-trad       = 2:
               
               FOR FIRST it-nota-fisc NO-LOCK 
                   WHERE it-nota-fisc.cod-estabel = doc-orig-nfe.cod-estabel
                     AND it-nota-fisc.serie       = tt-saldo-aux.serie-docto         
                     AND it-nota-fisc.nr-nota-fis = tt-saldo-aux.nro-docto  
                     AND it-nota-fisc.nr-seq-fat  = tt-saldo-aux.seq-saldo-terc  
                     AND it-nota-fisc.it-codigo   = tt-saldo-aux.it-codigo:
                 
                   ASSIGN de-indice-fat = IF   it-nota-fisc.ind-fat-qtfam = NO THEN 1
                                          ELSE it-nota-fisc.qt-faturada[2] / it-nota-fisc.qt-faturada[1]
                          de-pre-unit-fat = ROUND(it-nota-fisc.vl-preori * de-indice,4).
               
                   IF de-pre-unit-fat > de-valor-max
                   OR de-pre-unit-fat < de-valor-min  THEN DO:

                      {method/svc/errors/inserr.i &ErrorNumber="57163"
                                                  &ErrorType="EMS"
                                                  &ErrorSubType="WARNING"
                                                  &ErrorParameters="trim(STRING(de-pre-unit-interno,'->>,>>>,>>>,>>9.9999')) + '~~~~' + STRING(pseq-item) + '~~~~' + trim(STRING(de-pre-unit-fat, '->>,>>>,>>>,>>9.9999')) + '~~~~' + STRING(it-nota-fisc.nr-nota-fis)"}
               
                      IF l-create-msg-ret-devol THEN DO:
                          FOR EACH RowErrors WHERE RowErrors.ErrorType <> "INTERNAL":U:
                              CREATE msg-ret-nfe.
                              ASSIGN msg-ret-nfe.ch-acesso-comp-nfe =  doc-orig-nfe.ch-acesso-comp-nfe 
                                     msg-ret-nfe.idi-orig-trad      = 2
                                     msg-ret-nfe.dt-msg             = TODAY
                                     msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
                                     msg-ret-nfe.log-ativo          = YES
                                     msg-ret-nfe.cd-msg             = RowErrors.ErrorNumber
                                     msg-ret-nfe.texto-msg          = RowErrors.ErrorHelp
                                     msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe)
                                     msg-ret-nfe.tipo-msg           = 2     
                                     msg-ret-nfe.usuario            = c-seg-usuario.   
                              RELEASE msg-ret-nfe.
                          END.
                      END.
                   END.
               END.
           END.
        END.
    END.
RETURN 'OK'.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSaldoTerc DBOProgram 
PROCEDURE validaSaldoTerc :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pch-acesso-comp-nfe LIKE item-doc-orig-nfe.ch-acesso-comp-nfe.
    DEF INPUT PARAM pseq-item           LIKE item-doc-orig-nfe.seq-item.
    DEF INPUT PARAM TABLE FOR tt-saldo-terc-aux.

    DEF BUFFER b-natur-oper FOR natur-oper.
    DEF VAR dt-ref-saldo-aux AS DATE NO-UNDO.

    FIND FIRST tt-saldo-terc-aux NO-LOCK NO-ERROR.

    FIND FIRST item-doc-orig-nfe
         WHERE item-doc-orig-nfe.ch-acesso-comp-nfe  = pch-acesso-comp-nfe
           AND item-doc-orig-nfe.seq-item            = pseq-item
           AND item-doc-orig-nfe.idi-orig-trad       = 2 NO-LOCK NO-ERROR. 

    IF AVAIL item-doc-orig-nfe AND 
       AVAIL tt-saldo-terc-aux THEN DO:

        FOR FIRST doc-orig-nfe FIELDS(cod-estabel dt-emissao)
            WHERE doc-orig-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe
              AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK: END.

        ASSIGN dt-ref-saldo-aux = tt-saldo-terc-aux.dt-retorno.
        
        IF doc-orig-nfe.dt-emissao < dt-ref-saldo-aux
        AND NOT CAN-FIND(FIRST nota-fiscal
                         WHERE nota-fiscal.cod-estabel  = doc-orig-nfe.cod-estabel
                           AND nota-fiscal.serie        = tt-saldo-terc-aux.serie-docto
                           AND nota-fiscal.nr-nota-fis  = tt-saldo-terc-aux.nro-docto
                           AND nota-fiscal.cod-emitente = tt-saldo-terc-aux.cod-emitente) THEN DO:
            FOR FIRST docum-est FIELDS(dt-emissao)
                WHERE docum-est.serie-docto  = tt-saldo-terc-aux.serie-docto
                  AND docum-est.nro-docto    = tt-saldo-terc-aux.nro-docto
                  AND docum-est.cod-emitente = tt-saldo-terc-aux.cod-emitente
                  AND docum-est.cod-estabel  = doc-orig-nfe.cod-estabel NO-LOCK: END.
            IF AVAIL docum-est THEN
                ASSIGN dt-ref-saldo-aux = docum-est.dt-emissao.
        END.
              

        IF doc-orig-nfe.dt-emissao < dt-ref-saldo-aux THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="35859"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(doc-orig-nfe.dt-emissao) + '~~~~' + STRING(dt-ref-saldo-aux)"}
        END.

        IF (item-doc-orig-nfe.qtd-interna = 0 OR tt-saldo-terc-aux.qtd-alocada = 0) AND 
            NOT tt-saldo-terc-aux.qtd-alocar      = 0 THEN DO:
             {utp/ut-liter.i "vincular_ao_Item/Nota" *}
             {method/svc/errors/inserr.i &ErrorNumber="52011"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF tt-saldo-terc-aux.qtd-alocar = 0 AND
           NOT CAN-FIND(FIRST item-ref-nfe 
                        WHERE item-ref-nfe.ch-acesso-comp-nfe = pch-acesso-comp-nfe
                          AND item-ref-nfe.nro-docto          = tt-saldo-terc-aux.nro-docto
                          AND item-ref-nfe.cod-emitente       = tt-saldo-terc-aux.cod-emitente
                          AND item-ref-nfe.serie-docto        = tt-saldo-terc-aux.serie-docto
                          AND item-ref-nfe.nat-operacao       = tt-saldo-terc-aux.nat-operacao
                          AND item-ref-nfe.seq-saldo-terc     = tt-saldo-terc-aux.seq-saldo-terc
                          AND item-ref-nfe.seq-item           = pseq-item) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="52012"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.

        IF tt-saldo-terc-aux.qtd-alocar > tt-saldo-terc-aux.qtd-alocada THEN DO: // qtd-alocada eh o saldo
             {utp/ut-liter.i "Quantidade_a_alocar" *}
             {method/svc/errors/inserr.i &ErrorNumber="34809"
                                         &ErrorType="EMS"
                                         &ErrorSubType="ERROR"
                                         &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~' + STRING(tt-saldo-terc-aux.qtd-alocada)"}
        END.

        IF item-doc-orig-nfe.nat-operacao <> "" THEN DO:

            FIND FIRST b-natur-oper NO-LOCK 
                 WHERE b-natur-oper.nat-operacao = item-doc-orig-nfe.nat-operacao NO-ERROR.
                 
            /*include que contem a logica para identificar se a natureza eh de fatura faturamento antecipado,
              remessa faturamento antecipado, fatura entrega futura ou remessa entrega futura*/
            {cdp/cd9700.i1 b-natur-oper} 

            FOR FIRST saldo-terc FIELDS(log-entreg-fut)
                WHERE saldo-terc.serie-docto  = tt-saldo-terc-aux.serie-docto
                  AND saldo-terc.nro-docto    = tt-saldo-terc-aux.nro-docto
                  AND saldo-terc.cod-emitente = tt-saldo-terc-aux.cod-emitente
                  AND saldo-terc.nat-operacao = tt-saldo-terc-aux.nat-operacao
                  AND saldo-terc.sequencia    = tt-saldo-terc-aux.seq-saldo-terc
                  AND saldo-terc.it-codigo    = tt-saldo-terc-aux.it-codigo NO-LOCK: END.

            IF  l-remessa-ent-futura 
            AND saldo-terc.log-entreg-fut = no THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="57019"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.

            IF  l-remessa-ent-futura = no
            AND saldo-terc.log-entreg-fut THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="57020"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSaldosNotaDevolItem DBOProgram 
PROCEDURE getSaldosNotaDevolItem :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER pchave-acesso AS CHAR NO-UNDO.
    DEF INPUT  PARAMETER pseq-item     AS INT NO-UNDO.
    DEF INPUT  PARAMETER pSerieIni             LIKE saldo-terc.serie-docto      NO-UNDO.
    DEF INPUT  PARAMETER pSerieFim             LIKE saldo-terc.serie-docto      NO-UNDO.
    DEF INPUT  PARAMETER pNroDoctoIni          LIKE saldo-terc.nro-docto        NO-UNDO.
    DEF INPUT  PARAMETER pNroDoctoFim          LIKE saldo-terc.nro-docto        NO-UNDO.
    DEF INPUT  PARAMETER pDtSaldoIni           LIKE saldo-terc.dt-retorno       NO-UNDO.
    DEF INPUT  PARAMETER pDtSaldoFim           LIKE saldo-terc.dt-retorno       NO-UNDO.
    DEF INPUT  PARAMETER pSeqItemSaidaIni      LIKE item-ref-nfe.seq-saldo-terc NO-UNDO.
    DEF INPUT  PARAMETER pSeqItemSaidaFim      LIKE item-ref-nfe.seq-saldo-terc NO-UNDO.
    DEF INPUT  PARAMETER plDesconsiderarItem   AS   LOGICAL                     NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-saldo-aux.

    DEFINE VARIABLE h-bodi088na     AS HANDLE      NO-UNDO.
    RUN dibo/bodi088na.p PERSISTENT SET h-bodi088na.
    
    RUN filtroNotaDevol  IN h-bodi088na (INPUT pSerieIni,
                                         INPUT pSerieFim,
                                         INPUT pNroDoctoIni,
                                         INPUT pNroDoctoFim,
                                         INPUT pDtSaldoIni,
                                         INPUT pDtSaldoFim,
                                         INPUT pSeqItemSaidaIni,
                                         INPUT pSeqItemSaidaFim,
                                         INPUT plDesconsiderarItem).

    RUN carregaNotaDevolItem IN h-bodi088na (INPUT        pchave-acesso,
                                             INPUT        pseq-item,
                                             OUTPUT TABLE tt-saldo-aux).

    RUN buscaSaldoVincul (INPUT-OUTPUT TABLE tt-saldo-aux).

    FOR EACH tt-saldo-aux WHERE tt-saldo-aux.qtd-alocar <= 0:
        DELETE tt-saldo-aux. /* remove da TT saldos zerados, sem quantidade a alocar */
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-bodi088na NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSaldosNotaTercItem DBOProgram 
PROCEDURE getSaldosNotaTercItem :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER pchave-acesso        AS CHAR NO-UNDO.
    DEF INPUT  PARAMETER pseq-item            AS INT  NO-UNDO.
    DEF INPUT  PARAMETER pdesconsidera-item   AS LOG  NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-saldo-terc-aux.

    DEFINE VARIABLE h-boin404re     AS HANDLE      NO-UNDO.
    RUN inbo/boin404re.p PERSISTENT SET h-boin404re.

    RUN carregaSaldoTercItem IN h-boin404re (INPUT        pchave-acesso,
                                             INPUT        pseq-item,
                                             INPUT        pdesconsidera-item,
                                             OUTPUT TABLE tt-saldo-terc-aux).

    FOR EACH tt-saldo-terc-aux:
        /** ATUALIZA QUANTIDADE VINCULADA E SALDO TERCEIROS - mesma logica do re0118b **/
        ASSIGN de-qtd-vinc = 0.
        FOR EACH item-ref-nfe NO-LOCK
           WHERE item-ref-nfe.ch-acesso-comp-nfe = pchave-acesso
             AND item-ref-nfe.nro-docto          = tt-saldo-terc-aux.nro-docto
             AND item-ref-nfe.cod-emitente       = tt-saldo-terc-aux.cod-emitente
             AND item-ref-nfe.serie-docto        = tt-saldo-terc-aux.serie-docto
             AND item-ref-nfe.nat-operacao       = tt-saldo-terc-aux.nat-operacao
             AND item-ref-nfe.seq-saldo-terc     = tt-saldo-terc-aux.seq-saldo-terc:

            ASSIGN de-qtd-vinc = de-qtd-vinc + item-ref-nfe.qtd-alocada.
        END.

        ASSIGN tt-saldo-terc-aux.qtd-comercial = de-qtd-vinc
               tt-saldo-terc-aux.qtd-alocar    = tt-saldo-terc-aux.qtd-alocada.

        IF tt-saldo-terc-aux.qtd-alocar <= 0 THEN
            DELETE tt-saldo-terc-aux. /* remove da TT saldos zerados, sem quantidade a alocar */
    END.

    RETURN "OK":U.

    FINALLY:
        DELETE PROCEDURE h-boin404re NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTSaldoTerc DBOProgram 
PROCEDURE setTTSaldoTerc :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER TABLE FOR tt-saldo-terc-aux.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTSaldoDevol DBOProgram 
PROCEDURE setTTSaldoDevol :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER TABLE FOR tt-saldo-aux.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaComprasRemessaEntFut DBOProgram 
PROCEDURE atualizaComprasRemessaEntFut PRIVATE:
/*:T------------------------------------------------------------------------------
  Purpose:    Quando a natureza for do tipo remessa entrega futura copia as ordens de compra 
              informada na nota de fatura - Logica copiada do re0118b.w
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST tt-saldo-terc-aux NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-saldo-terc-aux THEN
        RETURN "NOK":U.

    FIND FIRST componente NO-LOCK
         WHERE componente.cod-emitente = tt-saldo-terc-aux.cod-emitente
           AND componente.serie-docto  = tt-saldo-terc-aux.serie-docto
           AND componente.nat-operacao = tt-saldo-terc-aux.nat-operacao
           AND componente.nro-docto    = tt-saldo-terc-aux.nro-docto
           AND componente.it-codigo    = tt-saldo-terc-aux.it-codigo
           AND componente.sequencia    = tt-saldo-terc-aux.seq-saldo-terc NO-ERROR.

    IF  AVAIL componente
    AND item-doc-orig-nfe.num-pedido = 0
    AND item-doc-orig-nfe.numero-ordem = 0 THEN DO:
        FIND CURRENT item-doc-orig-nfe EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN item-doc-orig-nfe.num-pedido    = componente.num-pedido
               item-doc-orig-nfe.numero-ordem  = componente.numero-ordem
               item-doc-orig-nfe.parcela       = componente.parcela.
        FIND CURRENT item-doc-orig-nfe NO-LOCK NO-ERROR.
    END.

    /* FIFO NAO ESTA SENDO CONSIDERADO NESSE PONTO, PORQUE AVALIANDO A LOGICA DO RE0118B, NAO FAZIA SENTIDO. */

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTRateioLoteTerceiros DBOProgram 
PROCEDURE setTTRateioLoteTerceiros :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER TABLE FOR tt-rat-lote-medic-terc.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveTTRateioLoteTerceiros DBOProgram 
PROCEDURE saveTTRateioLoteTerceiros :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h-boin006    AS HANDLE NO-UNDO.

    run inbo/boin006.p persistent set h-boin006.

    FOR FIRST tt-rat-lote-medic-terc,
        FIRST item-ref-nfe NO-LOCK
        WHERE item-ref-nfe.ch-acesso-comp-nfe = tt-rat-lote-medic-terc.ch-acesso-comp-nfe
          AND item-ref-nfe.seq-item           = INT(SUBSTRING(tt-rat-lote-medic-terc.cod-livre-1,68,4))
          AND item-ref-nfe.seq-saldo-terc     = tt-rat-lote-medic-terc.seq-item
          AND item-ref-nfe.nro-docto          = SUBSTRING(tt-rat-lote-medic-terc.cod-livre-1,51,16): END.

    IF NOT AVAIL item-ref-nfe THEN DO:
        {utp/ut-liter.i Item_referenciado_documento_XML_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.

    FOR EACH tt-rat-lote-medic-terc:
        RUN validateSaldo IN h-boin006 (INPUT item-ref-nfe.serie-docto,
                                        INPUT item-ref-nfe.nro-docto,
                                        INPUT item-ref-nfe.cod-emitente,
                                        INPUT item-ref-nfe.nat-operacao,
                                        INPUT item-ref-nfe.it-codigo,
                                        INPUT tt-rat-lote-medic-terc.cod-refer,
                                        INPUT item-ref-nfe.seq-saldo-terc,
                                        INPUT tt-rat-lote-medic-terc.cod-lote-fabrican,
                                        INPUT tt-rat-lote-medic-terc.qtd-lote-fabrican).
    END.

    RUN getRowErrors IN h-boin006 (OUTPUT TABLE RowErrors).

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    /* Se nao ocorreram erros salva os lotes */
    FOR EACH tt-rat-lote-medic-terc
       WHERE tt-rat-lote-medic-terc.qtd-lote-fabrican > 0 NO-LOCK:

        IF NOT CAN-FIND(rat-lote-medic-nfe 
                  WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = item-ref-nfe.ch-acesso-comp-nfe
                    AND rat-lote-medic-nfe.idi-orig-trad      = 2
                    AND rat-lote-medic-nfe.seq-item           = item-ref-nfe.seq-saldo-terc
                    AND rat-lote-medic-nfe.cod-lote-fabrican  = tt-rat-lote-medic-terc.cod-lote-fabrican
                    AND rat-lote-medic-nfe.it-codigo          = item-ref-nfe.it-codigo
                    AND rat-lote-medic-nfe.cod-refer          = tt-rat-lote-medic-terc.cod-refer
                    AND SUBSTRING(rat-lote-medic-nfe.cod-livre-1,51,16) = item-ref-nfe.nro-docto 
                    AND SUBSTRING(rat-lote-medic-nfe.cod-livre-1,68,4)  = STRING(item-ref-nfe.seq-item)) THEN DO:

             CREATE rat-lote-medic-nfe.
             BUFFER-COPY tt-rat-lote-medic-terc TO rat-lote-medic-nfe.
        END.
        ELSE DO:
            FOR EACH rat-lote-medic-nfe
               WHERE rat-lote-medic-nfe.ch-acesso-comp-nfe = item-ref-nfe.ch-acesso-comp-nfe
                 AND rat-lote-medic-nfe.idi-orig-trad      = 2
                 AND rat-lote-medic-nfe.seq-item           = item-ref-nfe.seq-saldo-terc
                 AND rat-lote-medic-nfe.cod-lote-fabrican  = tt-rat-lote-medic-terc.cod-lote-fabrican
                 AND rat-lote-medic-nfe.it-codigo          = item-ref-nfe.it-codigo
                 AND rat-lote-medic-nfe.cod-refer          = tt-rat-lote-medic-terc.cod-refer EXCLUSIVE-LOCK:
                 IF SUBSTRING(rat-lote-medic-nfe.cod-livre-1,51,16) = item-ref-nfe.nro-docto AND
                    SUBSTRING(rat-lote-medic-nfe.cod-livre-1,68,4)  = STRING(item-ref-nfe.seq-item) THEN 
                    ASSIGN rat-lote-medic-nfe.qtd-lote-fabrican = tt-rat-lote-medic-terc.qtd-lote-fabrican
                           rat-lote-medic-nfe.cod-depos         = tt-rat-lote-medic-terc.cod-depos
                           rat-lote-medic-nfe.cod-localiz       = tt-rat-lote-medic-terc.cod-localiz.
            END.
        END.
   END.

    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-boin006 NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereQtdRateioLoteTerceiros DBOProgram 
PROCEDURE sugereQtdRateioLoteTerceiros :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       Executar antes o goToKey para posicionar o RowObject da item-ref-nfe
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAMETER TABLE FOR tt-rat-lote-medic-terc.

    DEFINE VARIABLE h-boin006       AS HANDLE NO-UNDO.
    DEFINE VARIABLE r-doc-orig-nfe  AS ROWID  NO-UNDO.
    DEFINE VARIABLE iSeq            AS INT    NO-UNDO.

    FIND FIRST RowObject NO-LOCK NO-ERROR.
    IF NOT AVAIL RowObject THEN RETURN "NOK":U.

    FOR FIRST item-doc-orig-nfe FIELDS (nat-operacao)
        WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
          AND item-doc-orig-nfe.seq-item           = RowObject.seq-item
          AND item-doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK: END.

    IF NOT AVAIL item-doc-orig-nfe THEN RETURN "NOK":U.

    run inbo/boin006.p persistent set h-boin006.

    RUN ValidaLoteConversor IN h-boin006 (INPUT item-doc-orig-nfe.nat-operacao,
                                          INPUT RowObject.serie-docto, 
                                          INPUT RowObject.nro-docto,   
                                          INPUT RowObject.cod-emitente,
                                          INPUT RowObject.nat-operacao,
                                          INPUT RowObject.ch-acesso-comp-nfe,
                                          INPUT RowObject.ch-acesso-comp-nfe,
                                          INPUT RowObject.seq-saldo-terc, 
                                          INPUT RowObject.qtd-alocada,
                                          INPUT RowObject.seq-item, 
                                          OUTPUT r-doc-orig-nfe,
                                          OUTPUT TABLE tt-rat-saldo-terc-dep).

    IF RETURN-VALUE = "NOK":U THEN DO:
        RUN getRowErrors IN h-boin006 (OUTPUT TABLE RowErrors).
        RETURN "NOK":U.
    END.

    EMPTY TEMP-TABLE tt-rat-lote-medic-terc NO-ERROR.

    FOR EACH tt-rat-saldo-terc-dep WHERE tt-rat-saldo-terc-dep.sequencia = RowObject.seq-saldo-terc:
        ASSIGN iSeq = iSeq + 1.
        CREATE tt-rat-lote-medic-terc.
        ASSIGN tt-rat-lote-medic-terc.ch-acesso-comp-nfe      = RowObject.ch-acesso-comp-nfe 
               tt-rat-lote-medic-terc.idi-orig-trad           = 2 
               tt-rat-lote-medic-terc.seq-item                = RowObject.seq-saldo-terc
               tt-rat-lote-medic-terc.num-seq-rat             = iSeq
               tt-rat-lote-medic-terc.cod-lote-fabrican       = tt-rat-saldo-terc-dep.lote 
               tt-rat-lote-medic-terc.dat-valid-lote-fabrican = tt-rat-saldo-terc-dep.dt-vali-lote
               tt-rat-lote-medic-terc.qtd-lote-fabrican       = tt-rat-saldo-terc-dep.qtd-digitada
               tt-rat-lote-medic-terc.cod-depos               = tt-rat-saldo-terc-dep.cod-depos 
               tt-rat-lote-medic-terc.cod-localiz             = tt-rat-saldo-terc-dep.cod-localiz
               tt-rat-lote-medic-terc.it-codigo               = tt-rat-saldo-terc-dep.it-codigo
               tt-rat-lote-medic-terc.cod-refer               = tt-rat-saldo-terc-dep.cod-refer.

        OVERLAY(tt-rat-lote-medic-terc.cod-livre-1,51,16) = RowObject.nro-docto.
        OVERLAY(tt-rat-lote-medic-terc.cod-livre-1,68,4) = STRING(RowObject.seq-item).
    END.

    RETURN "OK":U.
    FINALLY:
        DELETE PROCEDURE h-boin006 NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
