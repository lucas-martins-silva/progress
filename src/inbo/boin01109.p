&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/**************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
***************************************************************************/
{include/i-prgvrs.i BOIN01109 2.00.00.008 } /*** "010008" 13/11/2023 11:45:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin01109 MUT}
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
&GLOBAL-DEFINE DBOName BOIN01109
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName doc-xml-compar
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
{inbo/boin01109.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren         AS CHARACTER FORMAT "x(12)":U NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUFFER bf-doc-xml-compar FOR doc-xml-compar.
    
    FOR LAST bf-doc-xml-compar
       WHERE bf-doc-xml-compar.ch-acesso-comp-nfe = rowObject.ch-acesso-comp-nfe
         AND bf-doc-xml-compar.seq-item           = rowObject.seq-item NO-LOCK: END.

    ASSIGN rowObject.num-seq = IF AVAIL bf-doc-xml-compar THEN 
                                  bf-doc-xml-compar.num-seq + 1 
                               ELSE 1.
    
END PROCEDURE.

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
        WHEN "cod-usuar-gerac":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-gerac.
        WHEN "cod-usuar-justif":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-justif.
        WHEN "des-contdo-erp":U THEN ASSIGN pFieldValue = RowObject.des-contdo-erp.
        WHEN "des-contdo-orig-xml":U THEN ASSIGN pFieldValue = RowObject.des-contdo-orig-xml.
        WHEN "des-justif":U THEN ASSIGN pFieldValue = RowObject.des-justif.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDatetimeField DBOProgram  
PROCEDURE getDatetimeField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo datetime
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATETIME NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dtm-gerac":U THEN ASSIGN pFieldValue = RowObject.dtm-gerac.
        WHEN "dtm-justif":U THEN ASSIGN pFieldValue = RowObject.dtm-justif.
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
        WHEN "idi-sit-compar":U THEN ASSIGN pFieldValue = RowObject.idi-sit-compar.
        WHEN "idi-tip-compar":U THEN ASSIGN pFieldValue = RowObject.idi-tip-compar.
        WHEN "idi-tip-docto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-docto.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
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
  Purpose:     Retorna valores dos campos do °ndice dcxmlcmp_id2
  Parameters:  
               retorna valor do campo ch-acesso-comp-nfe
               retorna valor do campo seq-item
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pch-acesso-comp-nfe LIKE doc-xml-compar.ch-acesso-comp-nfe NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-item LIKE doc-xml-compar.seq-item NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE doc-xml-compar.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
           pseq-item = RowObject.seq-item
           pnum-seq = RowObject.num-seq.

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
  Purpose:     Reposiciona registro com base no °ndice dcxmlcmp_id2
  Parameters:  
               recebe valor do campo ch-acesso-comp-nfe
               recebe valor do campo seq-item
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pch-acesso-comp-nfe LIKE doc-xml-compar.ch-acesso-comp-nfe NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item LIKE doc-xml-compar.seq-item NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE doc-xml-compar.num-seq NO-UNDO.

    FIND FIRST bfdoc-xml-compar WHERE 
        bfdoc-xml-compar.ch-acesso-comp-nfe = pch-acesso-comp-nfe AND 
        bfdoc-xml-compar.seq-item = pseq-item AND 
        bfdoc-xml-compar.num-seq = pnum-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdoc-xml-compar THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdoc-xml-compar)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaSitHistorico DBOProgram 
PROCEDURE setaSitHistorico :
/*------------------------------------------------------------------------------
  Purpose: Passa para historico
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pch-acesso-comp-nfe  LIKE doc-xml-compar.ch-acesso-comp-nfe  NO-UNDO.   
    DEFINE INPUT PARAMETER pidi-tip-compar      LIKE doc-xml-compar.idi-tip-compar      NO-UNDO.
    DEFINE INPUT PARAMETER pseq-item            LIKE doc-xml-compar.seq-item            NO-UNDO.

    IF pidi-tip-compar = 0 THEN
        FOR EACH bf{&TableName} EXCLUSIVE-LOCK
            WHERE bf{&TableName}.ch-acesso-comp-nfe  = pch-acesso-comp-nfe 
              AND bf{&TableName}.seq-item            = pseq-item
              AND bf{&TableName}.idi-sit-compar      = 1:
                ASSIGN bf{&TableName}.idi-sit-compar = 3. /*1-Pendente, 2-Liberada, 3-Hist¢rico, 4-Recusada*/
        END.
    ELSE 
        FOR EACH bf{&TableName} EXCLUSIVE-LOCK
            WHERE bf{&TableName}.ch-acesso-comp-nfe  = pch-acesso-comp-nfe 
              AND bf{&TableName}.idi-tip-compar      = pidi-tip-compar     
              AND bf{&TableName}.seq-item            = pseq-item
              AND bf{&TableName}.idi-sit-compar      = 1:
                ASSIGN bf{&TableName}.idi-sit-compar = 3. /*1-Pendente, 2-Liberada, 3-Hist¢rico, 4-Recusada*/
        END.

    RETURN "OK":U.

END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaSitHistTpDiv DBOProgram 
PROCEDURE setaSitHistTpDiv :
/*------------------------------------------------------------------------------
  Purpose: Passa para historico todas as divergencias daquele tipo
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pch-acesso-comp-nfe  LIKE doc-xml-compar.ch-acesso-comp-nfe  NO-UNDO.   
    DEFINE INPUT PARAMETER pidi-tip-compar      LIKE doc-xml-compar.idi-tip-compar      NO-UNDO.
    
    FOR EACH bf{&TableName} EXCLUSIVE-LOCK
        WHERE bf{&TableName}.ch-acesso-comp-nfe  = pch-acesso-comp-nfe 
          AND bf{&TableName}.idi-tip-compar      = pidi-tip-compar     
          AND bf{&TableName}.idi-sit-compar      = 1:
            ASSIGN bf{&TableName}.idi-sit-compar = 3. /*1-Pendente, 2-Liberada, 3-Hist¢rico, 4-Recusada*/
    END.

    RETURN "OK":U.

END PROCEDURE.

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

    FIND FIRST param-convrsr-nfe NO-LOCK NO-ERROR.
    IF NOT AVAIL param-convrsr-nfe THEN DO:
        {utp/ut-liter.i Parametros_conversor_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE"}
        RETURN "NOK":U.
    END.

    FOR FIRST doc-orig-nfe NO-LOCK
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
          AND doc-orig-nfe.idi-orig-trad      = 2:
    END.

    IF NOT AVAIL doc-orig-nfe THEN DO:
        {utp/ut-liter.i Documento_XML_NF-e *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U 
                                    &ErrorParameters="RETURN-VALUE + '~~~~' + RowObject.ch-acesso-comp-nfe"}
        RETURN "NOK":U.
    END.

    IF CAN-DO("1,3,5,6,7,8,9,10", STRING(doc-orig-nfe.idi-situacao)) THEN DO:
        IF (doc-orig-nfe.idi-situacao = 5 /* Cancelada */ AND param-convrsr-nfe.log-bloq-nfe-cancda) OR 
            doc-orig-nfe.idi-situacao <> 5 THEN DO:
            DEF VAR c-sit-txt AS CHAR NO-UNDO.
            assign c-sit-txt = {ininc/i01in847.i 04 doc-orig-nfe.idi-situacao}. /* Nao eh permitida alteracao de documento em situacoes dif de erro negoc, elimin e cancelada */
            {method/svc/errors/inserr.i &ErrorNumber="57071"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="c-sit-txt"}
            RETURN "NOK":U.
        END.
    END.

    IF pType = "Create":U OR pType = "Update":U THEN DO:
        FIND FIRST param-compar-xml
             WHERE param-compar-xml.cod-estabel   = doc-orig-nfe.cod-estabel
               AND param-compar-xml.idi-tip-docto = 1 NO-LOCK NO-ERROR. /* NF-e */

        IF NOT AVAIL param-compar-xml THEN DO:
            {utp/ut-liter.i Parametros_comparativo_XML *}
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="RETURN-VALUE + '~~~~' + doc-orig-nfe.cod-estabel"}
            RETURN "NOK":U.
        END.

        IF NOT param-compar-xml.log-ativo THEN DO:
            DEF VAR lb-estab AS CHAR NO-UNDO.
            {utp/ut-liter.i Estabelecimento *}
            ASSIGN lb-estab = RETURN-VALUE.
            {utp/ut-liter.i Parametros_comparativo_XML *}
            {method/svc/errors/inserr.i &ErrorNumber="52862"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U 
                                        &ErrorParameters="RETURN-VALUE + '~~~~' + lb-estab + ': ' + param-compar-xml.cod-estabel"}
            RETURN "NOK":U.
        END.

        IF NOT CAN-FIND(FIRST item-doc-orig-nfe
                        WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = RowObject.ch-acesso-comp-nfe
                          AND item-doc-orig-nfe.seq-item           = RowObject.seq-item
                          AND item-doc-orig-nfe.idi-orig-trad      = 2) THEN DO:
            {utp/ut-liter.i "Item_documento_XML_NF-e" *}
            {method/svc/errors/inserr.i
                &ErrorNumber="2"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        IF RowObject.num-seq = 0 THEN DO:
            {method/svc/errors/inserr.i
                &ErrorNumber="7781"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"}
        END.

        IF RowObject.idi-sit-compar = 2 THEN DO: // Liberada
            IF LENGTH(RowObject.des-justif) > 200 THEN DO:
                {utp/ut-liter.i Justificativa *}
                {method/svc/errors/inserr.i
                    &ErrorNumber="57359"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="TRIM(RETURN-VALUE) + '~~~~200'"}
            END.

            IF param-compar-xml.log-pedir-justif-liber AND
              (RowObject.des-justif = "" OR RowObject.des-justif = ?) THEN DO:
                {utp/ut-liter.i Justificativa *}
                {method/svc/errors/inserr.i &ErrorNumber="53949"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U 
                                            &ErrorParameters="RETURN-VALUE"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE liberarDivergencia DBOProgram 
PROCEDURE liberarDivergencia :
/*:T------------------------------------------------------------------------------
  Purpose:     Liberar divergencia
  Parameters:  pJustificativa - Justificativa da liberacao
  Notes:       Primeiro posicionar na divergencia a ser liberada (goToKey)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pJustificativa AS CHARACTER NO-UNDO.

    IF NOT AVAIL RowObject THEN
        RETURN "NOK":U.

    IF RowObject.idi-sit-compar <> 1 THEN DO: // "Pendente" - precisa estar pendente para poder passar para liberada
        // DivergÍncia nao esta pendente, portando nao pode ser liberada
        {method/svc/errors/inserr.i
            &ErrorNumber="57357"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="STRING(RowObject.seq-item) + '~~~~' + STRING(RowObject.num-seq)"}

        RETURN "NOK":U.
    END.

    ASSIGN RowObject.des-justif       = pJustificativa
           RowObject.dtm-justif       = NOW
           RowObject.cod-usuar-justif = v_cod_usuar_corren
           RowObject.idi-sit-compar   = 2. /* Liberada */

    RUN updateRecord.

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN atualizaSituacaoDivergenciaDoctoNFe (INPUT RowObject.ch-acesso-comp-nfe).
        RETURN "OK":U.
    END.

    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaSituacaoDivergenciaDoctoNFe DBOProgram 
PROCEDURE atualizaSituacaoDivergenciaDoctoNFe :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualizar a situacao de divergencia do documento
  Parameters:  pChaveAcesso - Chave de acesso
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pChaveAcesso   AS CHARACTER NO-UNDO.

    DEFINE VAR lTemPendentes AS LOG INIT NO NO-UNDO.
    DEFINE VAR lTemLiberadas AS LOG INIT NO NO-UNDO.
    DEFINE VAR lTemHistorico AS LOG INIT NO NO-UNDO.

    FOR EACH doc-xml-compar FIELDS (ch-acesso-comp-nfe idi-tip-docto idi-sit-compar) NO-LOCK
       WHERE doc-xml-compar.ch-acesso-comp-nfe = pChaveAcesso
         AND doc-xml-compar.idi-tip-docto      = 1: // NF-e

        IF doc-xml-compar.idi-sit-compar = 1 THEN DO:
            ASSIGN lTemPendentes = YES.
            LEAVE.
        END.

        IF doc-xml-compar.idi-sit-compar = 2 THEN DO:
            ASSIGN lTemLiberadas = YES.
        END.

        IF doc-xml-compar.idi-sit-compar = 3 THEN DO:
            ASSIGN lTemHistorico = YES.
        END.
    END.

    FOR FIRST doc-orig-nfe FIELDS(ch-acesso-comp-nfe idi-orig-trad idi-sit-diverg) EXCLUSIVE-LOCK
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = pChaveAcesso
          AND doc-orig-nfe.idi-orig-trad      = 2:

        IF lTemPendentes THEN DO:
            ASSIGN doc-orig-nfe.idi-sit-diverg = 1. /* Pendentes */
            LEAVE.
        END.

        IF lTemLiberadas OR lTemHistorico THEN DO:
            ASSIGN doc-orig-nfe.idi-sit-diverg = 3. /* Resolvidas */
            LEAVE.
        END.

        ASSIGN doc-orig-nfe.idi-sit-diverg = 2. /* Sem divergencias */
    END.

    FOR FIRST doc-orig-nfe FIELDS(ch-acesso-comp-nfe idi-orig-trad) NO-LOCK
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = pChaveAcesso
          AND doc-orig-nfe.idi-orig-trad      = 2: END. // retirar o lock

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bloqueiaEntradaNfeComDivergencia DBOProgram 
PROCEDURE bloqueiaEntradaNfeComDivergencia :
/*:T------------------------------------------------------------------------------
  Purpose:     Bloqueia entrada NF com divergància
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pChaveAcesso   AS CHARACTER NO-UNDO.
    
    FOR FIRST doc-orig-nfe FIELDS(ch-acesso-comp-nfe cod-estabel idi-orig-trad) NO-LOCK
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = pChaveAcesso
          AND doc-orig-nfe.idi-orig-trad      = 2:

        RUN bloqueiaNfeComDiverg (INPUT doc-orig-nfe.cod-estabel,
                                  INPUT doc-orig-nfe.ch-acesso-comp-nfe).
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bloqueiaEntNfeComDivergChaveDocto DBOProgram 
PROCEDURE bloqueiaEntNfeComDivergChaveDocto :
/*:T------------------------------------------------------------------------------
  Purpose:     Bloqueia entrada NF com divergància
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodEmitente   LIKE doc-orig-nfe.cod-emitente  NO-UNDO.
    DEFINE INPUT PARAMETER pCodEstabel    LIKE doc-orig-nfe.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER pSerieDocto    LIKE doc-orig-nfe.serie-docto   NO-UNDO.
    DEFINE INPUT PARAMETER pNroDocto      LIKE doc-orig-nfe.nro-docto     NO-UNDO.
    DEFINE INPUT PARAMETER pDtEmissao     LIKE doc-orig-nfe.dt-emissao    NO-UNDO.

    FOR FIRST doc-orig-nfe FIELDS(ch-acesso-comp-nfe cod-estabel idi-situacao)
        WHERE doc-orig-nfe.cod-emitente  = pCodEmitente
          AND doc-orig-nfe.cod-estabel   = pCodEstabel 
          AND doc-orig-nfe.serie-docto   = pSerieDocto 
          AND doc-orig-nfe.nro-docto     = pNroDocto   
          AND doc-orig-nfe.dt-emissao    = pDtEmissao  
          AND doc-orig-nfe.idi-orig-trad = 2 NO-LOCK:
    
        RUN bloqueiaNfeComDiverg (INPUT doc-orig-nfe.cod-estabel,
                                  INPUT doc-orig-nfe.ch-acesso-comp-nfe).
    
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bloqueiaNfeComDiverg DBOProgram 
PROCEDURE bloqueiaNfeComDiverg :
/*:T------------------------------------------------------------------------------
  Purpose:     Bloqueia entrada NF com divergància
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCodEstabel        LIKE doc-orig-nfe.cod-estabel           NO-UNDO.
    DEFINE INPUT PARAMETER pChaveAcessoNfe    LIKE doc-orig-nfe.ch-acesso-comp-nfe    NO-UNDO.

    FOR FIRST param-compar-xml NO-LOCK
        WHERE param-compar-xml.cod-estabel   = pCodEstabel
          AND param-compar-xml.idi-tip-docto = 1 /*NFe*/ 
          AND param-compar-xml.log-ativo
          AND param-compar-xml.log-bloq-gerac: 

          IF  CAN-FIND (FIRST bf{&TableName} NO-LOCK
                        WHERE bf{&TableName}.ch-acesso-comp-nfe  = pChaveAcessoNfe
                          AND bf{&TableName}.idi-sit-compar      = 1  /*Pendente*/
                          AND bf{&TableName}.idi-tip-docto       = 1) /*NFe*/     THEN DO:
          
             /*Existem divergàncias do comparativo XML para o documento*/
            {method/svc/errors/inserr.i
                            &ErrorNumber="57354"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
            RETURN "NOK":U.   
          END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
