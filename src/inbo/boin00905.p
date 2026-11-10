&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-docto-estoq-transp NO-UNDO LIKE docto-estoq-transp
       FIELD r-Rowid AS ROWID.



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
&GLOBAL-DEFINE DBOName BOIN00905
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docto-estoq-transp
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
{inbo/boin00905.i RowObject}
{utp/ut-glob.i}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfdocum-est    FOR docum-est.

{include/i-getEntryField.i}

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
   Temp-Tables and Buffers:
      TABLE: tt-docto-estoq-transp T "?" NO-UNDO MGMOV docto-estoq-transp
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 16.54
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
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-livre-3":U THEN ASSIGN pFieldValue = RowObject.cod-livre-3.
        WHEN "cod-livre-4":U THEN ASSIGN pFieldValue = RowObject.cod-livre-4.
        WHEN "cod-motiv":U THEN ASSIGN pFieldValue = RowObject.cod-motiv.
        WHEN "cod-placa":U THEN ASSIGN pFieldValue = RowObject.cod-placa.
        WHEN "cod-pto-partida":U THEN ASSIGN pFieldValue = RowObject.cod-pto-partida.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nom-motoris":U THEN ASSIGN pFieldValue = RowObject.nom-motoris.
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
        WHEN "dat-fim-transp":U THEN ASSIGN pFieldValue = RowObject.dat-fim-transp.
        WHEN "dat-inic-transp":U THEN ASSIGN pFieldValue = RowObject.dat-inic-transp.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-livre-3":U THEN ASSIGN pFieldValue = RowObject.dat-livre-3.
        WHEN "dat-livre-4":U THEN ASSIGN pFieldValue = RowObject.dat-livre-4.
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
        WHEN "val-livre-3":U THEN ASSIGN pFieldValue = RowObject.val-livre-3.
        WHEN "val-livre-4":U THEN ASSIGN pFieldValue = RowObject.val-livre-4.
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
        WHEN "cdn-destin":U THEN ASSIGN pFieldValue = RowObject.cdn-destin.
        WHEN "cdn-transpdor":U THEN ASSIGN pFieldValue = RowObject.cdn-transpdor.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-livre-3":U THEN ASSIGN pFieldValue = RowObject.num-livre-3.
        WHEN "num-livre-4":U THEN ASSIGN pFieldValue = RowObject.num-livre-4.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dctstqtr_id
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nat-operacao
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE docto-estoq-transp.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE docto-estoq-transp.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE docto-estoq-transp.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE docto-estoq-transp.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnat-operacao = RowObject.nat-operacao
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente.

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
        WHEN "log-livre-3":U THEN ASSIGN pFieldValue = RowObject.log-livre-3.
        WHEN "log-livre-4":U THEN ASSIGN pFieldValue = RowObject.log-livre-4.
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
  Purpose:     Reposiciona registro com base no °ndice dctstqtr_id
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nat-operacao
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE docto-estoq-transp.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE docto-estoq-transp.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE docto-estoq-transp.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE docto-estoq-transp.cod-emitente NO-UNDO.

    FIND FIRST bfdocto-estoq-transp WHERE 
        bfdocto-estoq-transp.serie-docto = pserie-docto AND 
        bfdocto-estoq-transp.nat-operacao = pnat-operacao AND 
        bfdocto-estoq-transp.nro-docto = pnro-docto AND 
        bfdocto-estoq-transp.cod-emitente = pcod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-estoq-transp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-estoq-transp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyDocto DBOProgram 
PROCEDURE goToKeyDocto :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice dctstqtr_id
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nat-operacao
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowidDocto AS ROWID NO-UNDO.

    FIND FIRST bfdocum-est NO-LOCK
        WHERE ROWID(bfdocum-est) = pRowidDocto NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est THEN 
        RETURN "NOK":U.

    FIND FIRST bfdocto-estoq-transp WHERE 
        bfdocto-estoq-transp.serie-docto = bfdocum-est.serie-docto AND 
        bfdocto-estoq-transp.nat-operacao = bfdocum-est.nat-operacao AND 
        bfdocto-estoq-transp.nro-docto = bfdocum-est.nro-docto AND 
        bfdocto-estoq-transp.cod-emitente = bfdocum-est.cod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocto-estoq-transp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocto-estoq-transp)).
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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} INDEXED-REPOSITION.

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
    
    DEFINE INPUT PARAMETER pType         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-dt-fim-traslado    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-dt-inicio-traslado AS CHARACTER NO-UNDO.
    DEF VAR l-transp-proprio             AS LOG INITIAL NO NO-UNDO.
  
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF pType <> "DELETE" THEN DO:   

        IF RowObject.cdn-transpdor = 0 THEN DO:
            {utp/ut-liter.i "Transportador" *}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        IF RowObject.cdn-destin = 0 THEN DO:
            {utp/ut-liter.i "Destinat†rio" *} 
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        IF RowObject.dat-fim-transp = ? THEN DO:
            {utp/ut-liter.i "Data_Fim_Traslado" *}    
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        IF RowObject.dat-inic-transp = ? THEN DO:
            {utp/ut-liter.i "Data_In°cio_Traslado" *}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        END.

        IF NOT CAN-FIND(FIRST transporte
                        WHERE transporte.cod-transp = RowObject.cdn-transpdor)  THEN DO:
            {utp/ut-liter.i "Transportador" *}            
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}

        END.

        IF NOT CAN-FIND(FIRST emitente
                        WHERE emitente.cod-emitente = RowObject.cdn-destin)  THEN DO:
            {utp/ut-liter.i "Destinat†rio" *}            
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}

        END.
        ELSE DO:
            FOR FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = RowObject.cdn-destin:
                IF NOT CAN-FIND(FIRST loc-entr
                                WHERE loc-entr.nome-abrev  = emitente.nome-abrev
                                AND   loc-entr.cod-entrega = RowObject.cod-entrega)  THEN DO:
                    {utp/ut-liter.i "Entrega_x_Emitente" *}            
                    {method/svc/errors/inserr.i &ErrorNumber="2"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"}
        
                END.
            END.
        END.

        IF RowObject.dat-fim-transp < RowObject.dat-inic-transp THEN DO:
            {utp/ut-liter.i "Data_Fim_Traslado" *}
            Assign c-dt-fim-traslado = return-value.
            {utp/ut-liter.i "Data_In°cio_Traslado" *}
            Assign c-dt-inicio-traslado = return-value.
            {method/svc/errors/inserr.i &ErrorNumber="321" /*18935*/
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'' + '~~~~' + c-dt-fim-traslado + '~~~~' + c-dt-inicio-traslado"} 
        END.
        
        IF i-pais-impto-usuario = 33 THEN DO:  /* Peru*/
        
            FIND FIRST docum-est
                 WHERE docum-est.nro-docto    = RowObject.nro-docto     AND
                       docum-est.cod-emitente = RowObject.cod-emitente  AND
                       docum-est.nat-operacao = RowObject.nat-operacao  AND
                       docum-est.serie-docto  = RowObject.serie-docto   NO-LOCK NO-ERROR.
                      
            FIND FIRST transporte 
                 WHERE transporte.cod-transp = RowObject.cdn-transpdor NO-LOCK NO-ERROR.
        
            IF CAN-FIND(FIRST estabelec 
                        WHERE estabelec.cod-estabel = docum-est.cod-estabel AND
                              estabelec.cgc         = transporte.cgc)       THEN DO: 
                              
                ASSIGN l-transp-proprio = YES. /* Quando for transporte pr¢prio precisa validar placa e condutor */
            END.
            ELSE 
                ASSIGN l-transp-proprio = NO.
               
            IF RowObject.nom-motoris = "" THEN DO: 
                IF l-transp-proprio AND RowObject.log-livre-1 = NO THEN DO:
                    {utp/ut-liter.i "Motorista" *}
                    {method/svc/errors/inserr.i &ErrorNumber="17677"  /* &1 deve ser diferente de branco. */
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"}
                END.
            END.
            ELSE DO:
                IF NOT CAN-FIND(FIRST pessoa-distrib 
                                WHERE pessoa-distrib.cdn-pessoa = INT(RowObject.nom-motoris)) THEN DO:
                    {utp/ut-liter.i "Motorista" *}
                    {method/svc/errors/inserr.i &ErrorNumber="2"  /* N∆o encontrado(a) &1 para chave informada. */
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"}
                END.
            END.
         
            IF RowObject.cod-placa = "" THEN DO:
                IF l-transp-proprio AND RowObject.log-livre-1 = NO THEN DO:
                    {utp/ut-liter.i "Placa" *}
                    {method/svc/errors/inserr.i &ErrorNumber="17677"  /* &1 deve ser diferente de branco. */
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"}
                END.                                
            END.
            ELSE DO:
                IF NOT CAN-FIND(FIRST internac-veic 
                                WHERE internac-veic.cod-placa = RowObject.cod-placa) AND RowObject.log-livre-1 = NO THEN DO:
                                      
                    {utp/ut-liter.i "Placa" *}
                    {method/svc/errors/inserr.i &ErrorNumber="2"  /*  N∆o encontrado(a) &1 para chave informada. */
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"}
                 END.
            END.
                       
            IF RowObject.num-livre-1 = 10 AND
               RowObject.cod-livre-1 = "" THEN DO:
               
              {utp/ut-liter.i "Descriá∆o do motivo do traslado" *}
              {method/svc/errors/inserr.i &ErrorNumber="4863"  /* Descriá∆o do Motivo Traslado n∆o informada. */
                                          &ErrorType="EMS"
                                          &ErrorSubType="ERROR"
                                          &ErrorParameters="return-value"} 
            END.                           
        END.
        
        IF  i-pais-impto-usuario = 7 THEN DO:  /* Chile */
        
            IF  RowObject.cod-placa = "" THEN DO:                 
                {utp/ut-liter.i "Placa" *}
                {method/svc/errors/inserr.i &ErrorNumber="17677"  /* &1 deve ser diferente de branco. */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"}
            END.
            
            IF  GetEntryField(2,RowObject.cod-livre-2,";") = "" THEN DO:
                {utp/ut-liter.i "Placa_Reboque" *}
                {method/svc/errors/inserr.i &ErrorNumber="17677"  /* &1 deve ser diferente de branco. */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"}
            END.

            IF  RowObject.nom-motoris = "" THEN DO: 
                {utp/ut-liter.i "Motorista" *}
                {method/svc/errors/inserr.i &ErrorNumber="17677"  /* &1 deve ser diferente de branco. */
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"}
            END.
            ELSE DO:
                IF  NOT CAN-FIND(FIRST pessoa-distrib 
                                 WHERE pessoa-distrib.cdn-pessoa = INT(RowObject.nom-motoris)) THEN DO:
                    {utp/ut-liter.i "Motorista" *}
                    {method/svc/errors/inserr.i &ErrorNumber="2"  /* N∆o encontrado(a) &1 para chave informada. */
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="return-value"}
                END.
            END.
        END.
    END.

    IF pType = "COPY" OR
        pType = "CREATE" THEN DO:

        IF CAN-FIND(FIRST docto-estoq-transp
                    WHERE docto-estoq-transp.cod-emitente = RowObject.cod-emitente
                    AND   docto-estoq-transp.serie-docto  = RowObject.serie-docto
                    AND   docto-estoq-transp.nro-docto    = RowObject.nro-docto
                    AND   docto-estoq-transp.nat-operacao = RowObject.nat-operacao) THEN DO:
            {utp/ut-liter.i "Dados_Transporte_do_Documento" *}        
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="'Dados Transporte do Documento'"}
        END.

    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

