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
{include/i-prgvrs.i BOIN762 2.00.00.013 } /*** "010013" 24/11/2023 13:25:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin762 MUT}
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
&GLOBAL-DEFINE DBOName BOIN762
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName campo-lote-pregao-ord
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
{inbo/boin762.i RowObject}
{inbo/boin762.i tt-campo-lote-pregao-ord}
{inbo/boin274.i tt-ordem-compra}

DEFINE TEMP-TABLE tt-campos-aux NO-UNDO
    FIELD cod-campo   LIKE campo-lote-pregao-ord.cod-campo
    FIELD replica-ord AS LOGICAL FORMAT "S/N".
                             
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{cdp/cdcfgmat.i} 

&IF "{&bf_mat_versao_ems}" < "2.07" &THEN
    &GLOBAL-DEFINE TT-ORDEM-COMPRA.CDN-TIP-LOTE-PREGAO SUBSTRING(tt-ordem-compra.char-1,64,5)
&ELSE
    &GLOBAL-DEFINE TT-ORDEM-COMPRA.CDN-TIP-LOTE-PREGAO tt-ordem-compra.cdn-tip-lote-pregao
&ENDIF

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER bfordem-compra FOR ordem-compra.
DEFINE VARIABLE i-numero-ordem LIKE campo-lote-pregao-ord.numero-ordem NO-UNDO.
DEFINE VARIABLE h-boin274      AS HANDLE                               NO-UNDO.

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
         HEIGHT             = 23.25
         WIDTH              = 43.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminarCampoLotePregaoOrd DBOProgram 
PROCEDURE eliminarCampoLotePregaoOrd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pi-numero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    FOR EACH campo-lote-pregao-ord EXCLUSIVE-LOCK
       WHERE campo-lote-pregao-ord.numero-ordem = pi-numero-ordem:
        DELETE campo-lote-pregao-ord.
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
        WHEN "cod-campo":U THEN ASSIGN pFieldValue = RowObject.cod-campo.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "dsl-conteudo":U THEN ASSIGN pFieldValue = RowObject.dsl-conteudo.
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
        WHEN "cdn-tip-lote-pregao":U THEN ASSIGN pFieldValue = RowObject.cdn-tip-lote-pregao.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice cmpltpra-codigo-id
  Parameters:  
               retorna valor do campo numero-ordem
               retorna valor do campo cod-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE campo-lote-pregao-ord.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-campo LIKE campo-lote-pregao-ord.cod-campo NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem
           pcod-campo = RowObject.cod-campo.

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
  Purpose:     Reposiciona registro com base no °ndice cmpltpra-codigo-id
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo cod-campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE campo-lote-pregao-ord.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-campo LIKE campo-lote-pregao-ord.cod-campo NO-UNDO.

    FIND FIRST bfcampo-lote-pregao-ord WHERE 
        bfcampo-lote-pregao-ord.numero-ordem = pnumero-ordem AND 
        bfcampo-lote-pregao-ord.cod-campo = pcod-campo NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcampo-lote-pregao-ord THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcampo-lote-pregao-ord)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE informaLoteOrdem DBOProgram 
PROCEDURE informaLoteOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pi-numero-ordem        LIKE ordem-compra.numero-ordem           NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cdn-tip-lote-pregao LIKE tip-lote-pregao.cdn-tip-lote-pregao NO-UNDO.                  
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    DEFINE VARIABLE i-hora  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-min   AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-seg   AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-tempo AS INTEGER NO-UNDO.

    IF NOT VALID-HANDLE(h-boin274) THEN DO:    
        RUN "inbo/boin274.p" PERSISTENT SET h-boin274.
        RUN openQueryStatic IN h-boin274 (INPUT "Main").
    END.

    IF NOT CAN-FIND (FIRST tip-lote-pregao NO-LOCK
                     WHERE tip-lote-pregao.cdn-tip-lote-pregao = pi-cdn-tip-lote-pregao) THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-tipo-lote-pregao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tipo_Lote_Preg∆o" *}
        ASSIGN c-lbl-liter-tipo-lote-pregao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber=2
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-tipo-lote-pregao"}       
        RETURN "NOK":U.                                    
    END.

    RUN goToKey IN h-boin274 (INPUT pi-numero-ordem).
    IF RETURN-VALUE = "OK":U THEN
        RUN getRecord IN h-boin274 (OUTPUT TABLE tt-ordem-compra).

    FIND FIRST tt-ordem-compra NO-LOCK NO-ERROR.

    IF AVAIL tt-ordem-compra THEN DO:        
        
        FOR EACH campo-lote-pregao-ord EXCLUSIVE-LOCK
           WHERE campo-lote-pregao-ord.numero-ordem = pi-numero-ordem:
            DELETE campo-lote-pregao-ord.
        END.
                    
        &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
            OVERLAY(tt-ordem-compra.char-1,64,5) = STRING(pi-cdn-tip-lote-pregao).
        &ELSE
            ASSIGN tt-ordem-compra.cdn-tip-lote-pregao = pi-cdn-tip-lote-pregao.
        &ENDIF
        
        RUN emptyRowErrors  IN h-boin274.
        RUN setRecord       IN h-boin274 (INPUT TABLE tt-ordem-compra).
        RUN updateRecord    IN h-boin274.
        RUN getRowErrors    IN h-boin274 (OUTPUT TABLE RowErrors).

        FOR EACH campo-lote-pregao NO-LOCK
           WHERE campo-lote-pregao.cdn-tip-lote-pregao = pi-cdn-tip-lote-pregao:

            CREATE campo-lote-pregao-ord.
            ASSIGN campo-lote-pregao-ord.numero-ordem        = pi-numero-ordem
                   campo-lote-pregao-ord.cdn-tip-lote-pregao = pi-cdn-tip-lote-pregao
                   campo-lote-pregao-ord.cod-campo           = campo-lote-pregao.cod-campo.
            
            {inbo/boin762.i1 tt-ordem-compra campo-lote-pregao campo-lote-pregao-ord}
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToByNumeroOrdem DBOProgram 
PROCEDURE linkToByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.                  

    RUN getKey IN pHandle (OUTPUT i-numero-ordem).                  
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumeroOrdem DBOProgram 
PROCEDURE openQueryByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH campo-lote-pregao-ord NO-LOCK 
                               WHERE campo-lote-pregao-ord.numero-ordem = i-numero-ordem INDEXED-REPOSITION.
    
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

    OPEN QUERY {&QueryName} FOR EACH campo-lote-pregao-ord NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-campos-bbm DBOProgram 
PROCEDURE pi-valida-campos-bbm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pi-cod-tipo-lote LIKE campo-lote-pregao-ord.cdn-tip-lote-pregao NO-UNDO.
    DEFINE INPUT  PARAMETER c-cod-campo      LIKE campo-lote-pregao-ord.cod-campo           NO-UNDO.    

    DEFINE VARIABLE hr-amos-ini AS CHARACTER  NO-UNDO.                                      
    DEFINE VARIABLE hr-cad-ini  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hr-aber-ini AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE hr-preg-ini AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dt-amos-ini AS DATE       NO-UNDO.
    DEFINE VARIABLE dt-cad-ini  AS DATE       NO-UNDO.
    DEFINE VARIABLE dt-aber-ini AS DATE       NO-UNDO.
    DEFINE VARIABLE dt-preg-ini AS DATE       NO-UNDO.

    DEFINE BUFFER bf-campo-lote-pregao-ord FOR campo-lote-pregao-ord.

    {inbo/boin761.i1 bf-campo-lote-pregao-ord}

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-faixas-bbm DBOProgram 
PROCEDURE pi-valida-faixas-bbm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER TABLE FOR tt-campo-lote-pregao-ord.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE dt-inicial   AS DATE      NO-UNDO.
    DEFINE VARIABLE dt-final     AS DATE      NO-UNDO.
    DEFINE VARIABLE c-hr-inicial AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-formato    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-index      AS INTEGER   NO-UNDO.

    DEFINE BUFFER bf-tt-campo-lote-pregao-ord FOR tt-campo-lote-pregao-ord.

    FOR EACH tt-campo-lote-pregao-ord NO-LOCK:

        FIND FIRST campo-lote-pregao NO-LOCK
             WHERE campo-lote-pregao.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
               AND campo-lote-pregao.cod-campo           = tt-campo-lote-pregao-ord.cod-campo NO-ERROR.
        IF NOT AVAIL campo-lote-pregao THEN NEXT.
        
        IF campo-lote-pregao.log-campo-obrig AND TRIM(tt-campo-lote-pregao-ord.dsl-conteudo) = "" THEN DO:
           {method/svc/errors/inserr.i
               &ErrorNumber="265"
               &ErrorType="EMS":U
               &ErrorSubType="Error":U
               &ErrorParameters = "tt-campo-lote-pregao-ord.cod-campo"} 
        END.

        IF tt-campo-lote-pregao-ord.cod-campo = "BBM-DT-ABER-FIM" THEN DO:
            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-ABER-INI" NO-ERROR.
            IF AVAIL bf-tt-campo-lote-pregao-ord THEN DO:            
                IF DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo) > 
                   DATE(tt-campo-lote-pregao-ord.dsl-conteudo) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-conteudo-do-campo AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Conte£do_do_campo" *}
                    ASSIGN c-lbl-liter-conteudo-do-campo = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-regra-bbm AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "a_regra_BBM" *}
                    ASSIGN c-lbl-liter-a-regra-bbm = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-ser-maior-que-a-data-de-abertu AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "ser_maior_que_a_data_de_abertura_de_propostas_inicial" *}
                    ASSIGN c-lbl-liter-ser-maior-que-a-data-de-abertu = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-inserr-conteudo-do-campo-tt-cam AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-inserr-conteudo-do-campo-tt-cam = c-lbl-liter-conteudo-do-campo + ' ' + tt-campo-lote-pregao-ord.cod-campo + '~~~~' + ' ' + c-lbl-liter-a-regra-bbm + '.' + '~~~~' + c-lbl-liter-ser-maior-que-a-data-de-abertu + '.'.
                   {method/svc/errors/inserr.i
                       &ErrorNumber="32853"
                       &ErrorType="EMS":U
                       &ErrorSubType="Error":U
                       &ErrorParameters = "c-lbl-inserr-conteudo-do-campo-tt-cam"} 
                END.
            END.
        END.
        ELSE IF tt-campo-lote-pregao-ord.cod-campo = "BBM-DT-AMOS-FIM" THEN DO:
            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-AMOS-INI" NO-ERROR.
            IF AVAIL bf-tt-campo-lote-pregao-ord THEN DO:            
                IF DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo) > 
                   DATE(tt-campo-lote-pregao-ord.dsl-conteudo) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-conteudo-do-campo-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Conte£do_do_campo" *}
                    ASSIGN c-lbl-liter-conteudo-do-campo-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-regra-bbm-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "a_regra_BBM" *}
                    ASSIGN c-lbl-liter-a-regra-bbm-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-ser-maior-que-a-data-de-amostr AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "ser_maior_que_a_data_de_amostra_inicial" *}
                    ASSIGN c-lbl-liter-ser-maior-que-a-data-de-amostr = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-inserr-conteudo-do-campo-2-tt-c AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-inserr-conteudo-do-campo-2-tt-c = c-lbl-liter-conteudo-do-campo-2 + ' ' + tt-campo-lote-pregao-ord.cod-campo + '~~~~' + ' ' + c-lbl-liter-a-regra-bbm-2 + '.' + '~~~~' + c-lbl-liter-ser-maior-que-a-data-de-amostr + '.'.
                   {method/svc/errors/inserr.i
                       &ErrorNumber="32853"
                       &ErrorType="EMS":U
                       &ErrorSubType="Error":U
                       &ErrorParameters = "c-lbl-inserr-conteudo-do-campo-2-tt-c"} 
                END.
            END.
        END. 
        ELSE IF tt-campo-lote-pregao-ord.cod-campo = "BBM-DT-CAD-FIM" THEN DO:
            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-CAD-INI" NO-ERROR.
            IF AVAIL bf-tt-campo-lote-pregao-ord THEN DO:            
                IF DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo) > 
                   DATE(tt-campo-lote-pregao-ord.dsl-conteudo) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-conteudo-do-campo-3 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Conte£do_do_campo" *}
                    ASSIGN c-lbl-liter-conteudo-do-campo-3 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-regra-bbm-3 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "a_regra_BBM" *}
                    ASSIGN c-lbl-liter-a-regra-bbm-3 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-ser-maior-que-a-data-de-cadast AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "ser_maior_que_a_data_de_cadastro_de_propostas_inicial" *}
                    ASSIGN c-lbl-liter-ser-maior-que-a-data-de-cadast = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-inserr-conteudo-do-campo-3-tt-c AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-inserr-conteudo-do-campo-3-tt-c = c-lbl-liter-conteudo-do-campo-3 + ' ' + tt-campo-lote-pregao-ord.cod-campo + '~~~~' + ' ' + c-lbl-liter-a-regra-bbm-3 + '.' + '~~~~' + c-lbl-liter-ser-maior-que-a-data-de-cadast + '.'.
                    {method/svc/errors/inserr.i
                       &ErrorNumber="32853"
                       &ErrorType="EMS":U
                       &ErrorSubType="Error":U
                       &ErrorParameters = "c-lbl-inserr-conteudo-do-campo-3-tt-c"} 
                END.
            END.
        END.
        ELSE IF tt-campo-lote-pregao-ord.cod-campo = "BBM-DT-PREG-FIM" THEN DO:
            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-PREG-INI" NO-ERROR.
            IF AVAIL bf-tt-campo-lote-pregao-ord THEN DO:            
                IF DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo) > 
                   DATE(tt-campo-lote-pregao-ord.dsl-conteudo) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-conteudo-do-campo-4 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Conte£do_do_campo" *}
                    ASSIGN c-lbl-liter-conteudo-do-campo-4 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-a-regra-bbm-4 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "a_regra_BBM" *}
                    ASSIGN c-lbl-liter-a-regra-bbm-4 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-liter-ser-maior-que-a-data-de-abertu-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "ser_maior_que_a_data_de_abertura_de_prospostas_inicial" *}
                    ASSIGN c-lbl-liter-ser-maior-que-a-data-de-abertu-2 = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-inserr-conteudo-do-campo-4-tt-c AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-inserr-conteudo-do-campo-4-tt-c = c-lbl-liter-conteudo-do-campo-4 + ' ' + tt-campo-lote-pregao-ord.cod-campo + '~~~~' + ' ' + c-lbl-liter-a-regra-bbm-4 + '.' + '~~~~' + c-lbl-liter-ser-maior-que-a-data-de-abertu-2 + '.'.
                    {method/svc/errors/inserr.i
                       &ErrorNumber="32853"
                       &ErrorType="EMS":U
                       &ErrorSubType="Error":U
                       &ErrorParameters = "c-lbl-inserr-conteudo-do-campo-4-tt-c"} 
                END.
            END.
        END. 
        ELSE IF tt-campo-lote-pregao-ord.cod-campo = "BBM-HR-ABER-FIM" THEN DO:
            
            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-HR-ABER-INI" NO-ERROR.            
            ASSIGN c-hr-inicial = IF AVAIL bf-tt-campo-lote-pregao-ord THEN bf-tt-campo-lote-pregao-ord.dsl-conteudo
                                  ELSE "00:00:00".

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-ABER-INI" NO-ERROR.
            ASSIGN dt-inicial = IF AVAIL bf-tt-campo-lote-pregao-ord THEN DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo)
                                ELSE 01.01.0001.

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-ABER-FIM" NO-ERROR.
            ASSIGN dt-final = IF AVAIL bf-tt-campo-lote-pregao-ord THEN DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo)
                              ELSE 12.31.9999.
            IF dt-inicial = dt-final AND
               c-hr-inicial > tt-campo-lote-pregao-ord.dsl-conteudo THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-conteudo-do-campo-5 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Conte£do_do_campo" *}
                ASSIGN c-lbl-liter-conteudo-do-campo-5 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-regra-bbm-5 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "a_regra_BBM" *}
                ASSIGN c-lbl-liter-a-regra-bbm-5 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-ser-maior-que-a-hora-de-abertu AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "ser_maior_que_a_hora_de_abertura_de_prospostas_inicial" *}
                ASSIGN c-lbl-liter-ser-maior-que-a-hora-de-abertu = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-conteudo-do-campo-5-tt-c AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-conteudo-do-campo-5-tt-c = c-lbl-liter-conteudo-do-campo-5 + ' ' + tt-campo-lote-pregao-ord.cod-campo + '~~~~' + ' ' + c-lbl-liter-a-regra-bbm-5 + '.' + '~~~~' + c-lbl-liter-ser-maior-que-a-hora-de-abertu + '.'.
                {method/svc/errors/inserr.i
                   &ErrorNumber="32853"
                   &ErrorType="EMS":U
                   &ErrorSubType="Error":U
                   &ErrorParameters = "c-lbl-inserr-conteudo-do-campo-5-tt-c"} 
            END.
        END.
        ELSE IF tt-campo-lote-pregao-ord.cod-campo = "BBM-HR-AMOS-FIM" THEN DO:

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-HR-AMOS-INI" NO-ERROR.
            ASSIGN c-hr-inicial = IF AVAIL bf-tt-campo-lote-pregao-ord THEN bf-tt-campo-lote-pregao-ord.dsl-conteudo
                                  ELSE "00:00:00".

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-AMOS-INI" NO-ERROR.
            ASSIGN dt-inicial = IF AVAIL bf-tt-campo-lote-pregao-ord THEN DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo)
                                ELSE 01.01.0001.

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-AMOS-FIM" NO-ERROR.
            ASSIGN dt-final = IF AVAIL bf-tt-campo-lote-pregao-ord THEN DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo)
                              ELSE 12.31.9999.

           IF dt-inicial = dt-final AND
              c-hr-inicial > tt-campo-lote-pregao-ord.dsl-conteudo THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-conteudo-do-campo-6 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Conte£do_do_campo" *}
                ASSIGN c-lbl-liter-conteudo-do-campo-6 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-regra-bbm-6 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "a_regra_BBM" *}
                ASSIGN c-lbl-liter-a-regra-bbm-6 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-ser-maior-que-a-hora-de-amostr AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "ser_maior_que_a_hora_de_amostra_inicial" *}
                ASSIGN c-lbl-liter-ser-maior-que-a-hora-de-amostr = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-conteudo-do-campo-6-tt-c AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-conteudo-do-campo-6-tt-c = c-lbl-liter-conteudo-do-campo-6 + ' ' + tt-campo-lote-pregao-ord.cod-campo + '~~~~' + ' ' + c-lbl-liter-a-regra-bbm-6 + '.' + '~~~~' + c-lbl-liter-ser-maior-que-a-hora-de-amostr + '.'.
                {method/svc/errors/inserr.i
                   &ErrorNumber="32853"
                   &ErrorType="EMS":U
                   &ErrorSubType="Error":U
                   &ErrorParameters = "c-lbl-inserr-conteudo-do-campo-6-tt-c"} 
            END.
        END.
        ELSE IF tt-campo-lote-pregao-ord.cod-campo = "BBM-HR-CAD-FIM" THEN DO:

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-HR-CAD-INI" NO-ERROR.
            ASSIGN c-hr-inicial = IF AVAIL bf-tt-campo-lote-pregao-ord THEN bf-tt-campo-lote-pregao-ord.dsl-conteudo
                                  ELSE "00:00:00".

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-CAD-INI" NO-ERROR.
            ASSIGN dt-inicial = IF AVAIL bf-tt-campo-lote-pregao-ord THEN DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo)
                                ELSE 01.01.0001.

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-CAD-FIM" NO-ERROR.
            ASSIGN dt-final = IF AVAIL bf-tt-campo-lote-pregao-ord THEN DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo)
                              ELSE 12.31.9999.

            IF dt-inicial = dt-final AND
               c-hr-inicial > tt-campo-lote-pregao-ord.dsl-conteudo THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-conteudo-do-campo-7 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Conte£do_do_campo" *}
                ASSIGN c-lbl-liter-conteudo-do-campo-7 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-regra-bbm-7 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "a_regra_BBM" *}
                ASSIGN c-lbl-liter-a-regra-bbm-7 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-ser-maior-que-a-hora-de-cadast AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "ser_maior_que_a_hora_de_cadastro_de_prospostas_inicial" *}
                ASSIGN c-lbl-liter-ser-maior-que-a-hora-de-cadast = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-conteudo-do-campo-7-tt-c AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-conteudo-do-campo-7-tt-c = c-lbl-liter-conteudo-do-campo-7 + ' ' + tt-campo-lote-pregao-ord.cod-campo + '~~~~' + ' ' + c-lbl-liter-a-regra-bbm-7 + '.' + '~~~~' + c-lbl-liter-ser-maior-que-a-hora-de-cadast + '.'.
                {method/svc/errors/inserr.i
                   &ErrorNumber="32853"
                   &ErrorType="EMS":U
                   &ErrorSubType="Error":U
                   &ErrorParameters = "c-lbl-inserr-conteudo-do-campo-7-tt-c"} 
            END.
        END.
        ELSE IF tt-campo-lote-pregao-ord.cod-campo = "BBM-HR-PREG-FIM" THEN DO:

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-HR-PREG-INI" NO-ERROR.
            ASSIGN c-hr-inicial = IF AVAIL bf-tt-campo-lote-pregao-ord THEN bf-tt-campo-lote-pregao-ord.dsl-conteudo
                                  ELSE "00:00:00".

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-PREG-INI" NO-ERROR.
            ASSIGN dt-inicial = IF AVAIL bf-tt-campo-lote-pregao-ord THEN DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo)
                                ELSE 01.01.0001.

            FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                 WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-DT-PREG-FIM" NO-ERROR.
            ASSIGN dt-final = IF AVAIL bf-tt-campo-lote-pregao-ord THEN DATE(bf-tt-campo-lote-pregao-ord.dsl-conteudo)
                              ELSE 12.31.9999.

            IF dt-inicial = dt-final AND
               c-hr-inicial > tt-campo-lote-pregao-ord.dsl-conteudo THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-conteudo-do-campo-8 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Conte£do_do_campo" *}
                ASSIGN c-lbl-liter-conteudo-do-campo-8 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-a-regra-bbm-8 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "a_regra_BBM" *}
                ASSIGN c-lbl-liter-a-regra-bbm-8 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-ser-maior-que-a-hora-de-abertu-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "ser_maior_que_a_hora_de_abertura_de_prospostas_inicial" *}
                ASSIGN c-lbl-liter-ser-maior-que-a-hora-de-abertu-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-conteudo-do-campo-8-tt-c AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-conteudo-do-campo-8-tt-c = c-lbl-liter-conteudo-do-campo-8 + ' ' + tt-campo-lote-pregao-ord.cod-campo + '~~~~' + ' ' + c-lbl-liter-a-regra-bbm-8 + '.' + '~~~~' + c-lbl-liter-ser-maior-que-a-hora-de-abertu-2 + '.'.
                {method/svc/errors/inserr.i
                   &ErrorNumber="32853"
                   &ErrorType="EMS":U
                   &ErrorSubType="Error":U
                   &ErrorParameters = "c-lbl-inserr-conteudo-do-campo-8-tt-c"} 
            END.
        END.
        ELSE IF tt-campo-lote-pregao-ord.cod-campo = "BBM-ANEXO-ARQ" THEN DO:

            IF tt-campo-lote-pregao-ord.dsl-conteudo <> "" THEN DO:

                FIND FIRST bf-tt-campo-lote-pregao-ord NO-LOCK
                     WHERE bf-tt-campo-lote-pregao-ord.cdn-tip-lote-pregao = tt-campo-lote-pregao-ord.cdn-tip-lote-pregao
                       AND bf-tt-campo-lote-pregao-ord.cod-campo           = "BBM-ANEXO-TIPO" NO-ERROR.
                IF AVAIL bf-tt-campo-lote-pregao-ord THEN DO:

                    ASSIGN i-index = INDEX(tt-campo-lote-pregao-ord.dsl-conteudo,".") + 1.
    
                    IF bf-tt-campo-lote-pregao-ord.dsl-conteudo = "application/msword"           AND 
                       SUBSTRING(tt-campo-lote-pregao-ord.dsl-conteudo, i-index , 3) <> "doc"    OR
                       bf-tt-campo-lote-pregao-ord.dsl-conteudo = "application/pdf"              AND
                       SUBSTRING(tt-campo-lote-pregao-ord.dsl-conteudo, i-index , 3) <> "pdf"    OR
                       bf-tt-campo-lote-pregao-ord.dsl-conteudo = "application/x-zip-compressed" AND 
                      (SUBSTRING(tt-campo-lote-pregao-ord.dsl-conteudo, i-index , 3) =  "doc"    OR
                       SUBSTRING(tt-campo-lote-pregao-ord.dsl-conteudo, i-index , 3) =  "pdf")   THEN DO:

                        IF bf-tt-campo-lote-pregao-ord.dsl-conteudo = "application/msword" THEN
                            ASSIGN c-formato = "msword".
                        ELSE IF bf-tt-campo-lote-pregao-ord.dsl-conteudo = "application/pdf" THEN 
                            ASSIGN c-formato = "pdf".
                        ELSE 
                            ASSIGN c-formato = "x-zip-compressed".

                             /* Inicio -- Projeto Internacional */
                             DEFINE VARIABLE c-arquivo AS CHARACTER FORMAT "X(3)" NO-UNDO.   
                             {utp/ut-liter.i "arquivo " *}
                             ASSIGN c-arquivo = RETURN-VALUE.

                        {method/svc/errors/inserr.i
                           &ErrorNumber="19071"
                           &ErrorType="EMS":U
                           &ErrorSubType="Error":U
                           &ErrorParameters = "c-formato + '~~~~' + c-arquivo +  tt-campo-lote-pregao-ord.dsl-conteudo"} 
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE replicaCamposPregao DBOProgram 
PROCEDURE replicaCamposPregao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pi-numero-ordem LIKE ordem-compra.numero-ordem                 NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cdn-tip-lote LIKE campo-lote-pregao-ord.cdn-tip-lote-pregao NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-campos-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.
    
    DEFINE BUFFER bf-ordem-compra FOR ordem-compra.
    DEFINE BUFFER bf-campo-lote-pregao-ord FOR campo-lote-pregao-ord.

    DEFINE VARIABLE i-hora  AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-min   AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-seg   AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-tempo AS INTEGER NO-UNDO.
    
    FOR FIRST bf-ordem-compra FIELDS (nr-processo)
        WHERE bf-ordem-compra.numero-ordem = pi-numero-ordem NO-LOCK. END.

    FOR EACH ordem-compra EXCLUSIVE-LOCK
       WHERE ordem-compra.numero-ordem <> pi-numero-ordem
         AND ordem-compra.nr-processo  = bf-ordem-compra.nr-processo:        

        &IF "{&bf_mat_versao_ems}" < "2.07" &THEN
            ASSIGN OVERLAY(ordem-compra.char-1,64,5) = STRING(pi-cdn-tip-lote).
        &ELSE
            ASSIGN ordem-compra.cdn-tip-lote-pregao  = pi-cdn-tip-lote.
        &ENDIF        

        FOR EACH campo-lote-pregao-ord EXCLUSIVE-LOCK
           WHERE campo-lote-pregao-ord.numero-ordem = ordem-compra.numero-ordem:
            DELETE campo-lote-pregao-ord.
        END.

        FOR EACH bf-campo-lote-pregao-ord NO-LOCK
           WHERE bf-campo-lote-pregao-ord.numero-ordem = pi-numero-ordem:

            CREATE campo-lote-pregao-ord.
            ASSIGN campo-lote-pregao-ord.numero-ordem        = ordem-compra.numero-ordem
                   campo-lote-pregao-ord.cdn-tip-lote-pregao = bf-campo-lote-pregao-ord.cdn-tip-lote-pregao
                   campo-lote-pregao-ord.cod-campo           = bf-campo-lote-pregao-ord.cod-campo.

            FIND FIRST tt-campos-aux NO-LOCK
                 WHERE tt-campos-aux.cod-campo = bf-campo-lote-pregao-ord.cod-campo NO-ERROR.

            IF AVAIL tt-campos-aux THEN DO:
                IF tt-campos-aux.replica-ord THEN                 
                    ASSIGN campo-lote-pregao-ord.dsl-conteudo = bf-campo-lote-pregao-ord.dsl-conteudo.
                ELSE DO:
                    FIND campo-lote-pregao 
                        WHERE campo-lote-pregao.cdn-tip-lote-pregao = bf-campo-lote-pregao-ord.cdn-tip-lote-pregao
                          AND campo-lote-pregao.cod-campo           = bf-campo-lote-pregao-ord.cod-campo NO-LOCK NO-ERROR.
                    {inbo/boin762.i1 ordem-compra campo-lote-pregao campo-lote-pregao-ord}
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE replicarCampo DBOProgram 
PROCEDURE replicarCampo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pi-numero-ordem LIKE ordem-compra.numero-ordem                 NO-UNDO.
    DEF INPUT PARAM pi-cdn-tip-lote LIKE campo-lote-pregao-ord.cdn-tip-lote-pregao NO-UNDO.
    DEF INPUT PARAM pc-cod-campo    LIKE campo-lote-pregao-ord.cod-campo           NO-UNDO.
    DEF INPUT PARAM pc-conteudo     LIKE campo-lote-pregao-ord.dsl-conteudo        NO-UNDO.

    DEFINE BUFFER bf-ordem-compra FOR ordem-compra.

    FOR FIRST bf-ordem-compra FIELDS (nr-processo)
        WHERE bf-ordem-compra.numero-ordem = pi-numero-ordem NO-LOCK. END.

    FOR EACH ordem-compra NO-LOCK
       WHERE ordem-compra.numero-ordem <> pi-numero-ordem
         AND ordem-compra.nr-processo  = bf-ordem-compra.nr-processo:        

        FIND FIRST campo-lote-pregao-ord EXCLUSIVE-LOCK
             WHERE campo-lote-pregao-ord.numero-ordem        = ordem-compra.numero-ordem
               AND campo-lote-pregao-ord.cod-campo           = pc-cod-campo
               AND campo-lote-pregao-ord.cdn-tip-lote-pregao = pi-cdn-tip-lote NO-ERROR.
        IF AVAIL campo-lote-pregao-ord THEN
            ASSIGN campo-lote-pregao-ord.dsl-conteudo = pc-conteudo.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumeroOrdem DBOProgram 
PROCEDURE setConstraintByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pi-numero-ordem LIKE campo-lote-pregao-ord.numero-ordem NO-UNDO.

    ASSIGN i-numero-ordem = pi-numero-ordem.

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
    
    /*Declaraá∆o de teste de formatos diferentes de variaveis*/
    DEFINE VARIABLE i-integer AS INTEGER NO-UNDO.
    DEFINE VARIABLE i-decimal AS DECIMAL NO-UNDO.
    DEFINE VARIABLE i-date    AS DATE    NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF pType = "Create" OR
       pType = "Update" THEN DO:

        IF NOT RowObject.dsl-conteudo MATCHES "*&*" THEN DO:

           FIND FIRST campo-lote-pregao NO-LOCK 
                WHERE campo-lote-pregao.cdn-tip-lote-pregao = RowObject.cdn-tip-lote-pregao
                  AND campo-lote-pregao.cod-campo           = RowObject.cod-campo NO-ERROR.

           IF campo-lote-pregao.cdn-tip-dado = 2 THEN DO:
              ASSIGN i-integer = INT(RowObject.dsl-conteudo) no-error.
              IF ERROR-STATUS:ERROR THEN DO:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-numerico AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "NumÇrico" *}
                 ASSIGN c-lbl-liter-numerico = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i
                            &ErrorNumber="18733"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="campo-lote-pregao.cod-campo + ' (' + c-lbl-liter-numerico + ')'"}  
              END.
            END.
            IF campo-lote-pregao.cdn-tip-dado = 3 THEN DO:
               ASSIGN i-decimal = DEC(RowObject.dsl-conteudo) no-error.
              IF ERROR-STATUS:ERROR THEN DO:
                 /* Inicio -- Projeto Internacional */
                 DEFINE VARIABLE c-lbl-liter-decimal AS CHARACTER NO-UNDO.
                 {utp/ut-liter.i "Decimal" *}
                 ASSIGN c-lbl-liter-decimal = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                            &ErrorNumber="18733"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="campo-lote-pregao.cod-campo + ' (' + c-lbl-liter-decimal + ')'"} 
              END.
            END.

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-opcao AS CHARACTER FORMAT "X(7)" NO-UNDO.
            {utp/ut-liter.i "Sim/N∆o" *}
            ASSIGN c-opcao = TRIM(RETURN-VALUE).

            IF campo-lote-pregao.cdn-tip-dado = 4 THEN DO:
               IF RowObject.dsl-conteudo <> "Sim" AND
                  RowObject.dsl-conteudo <> "N∆o" AND
                  RowObject.dsl-conteudo <> "Nao" THEN 
                  /* Inicio -- Projeto Internacional */
                  DO:
                  DEFINE VARIABLE c-lbl-liter-logico AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "L¢gico" *}
                  ASSIGN c-lbl-liter-logico = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                             &ErrorNumber="18733"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters="campo-lote-pregao.cod-campo + ' (' + c-lbl-liter-logico + ') ' + '~~~~' + c-opcao "} 
                  END. 
            END.
            IF campo-lote-pregao.cdn-tip-dado = 5 THEN DO:
               ASSIGN i-date = DATE(RowObject.dsl-conteudo) no-error.
               IF i-date = ? THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-data AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Data" *}
                  ASSIGN c-lbl-liter-data = TRIM(RETURN-VALUE).
                 {method/svc/errors/inserr.i
                             &ErrorNumber="18733"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters="campo-lote-pregao.cod-campo + ' (' + c-lbl-liter-data + ')'"} 
               END.
            END.
        END.
        
        RUN pi-valida-campos-bbm (INPUT RowObject.cdn-tip-lote-pregao,
                                  INPUT RowObject.cod-campo) NO-ERROR.

        /*
        ** Valida se o lote j† foi informado para outra ordem de compra e verifica se as ordens podem fazer parte do mesmo lote
        */
        IF rowObject.cod-campo = "BBM-NR-LOTE" THEN DO:
            FIND ordem-compra
                WHERE ordem-compra.numero-ordem = rowObject.numero-ordem NO-LOCK NO-ERROR.
            FOR EACH bfordem-compra 
                WHERE bfordem-compra.nr-processo = ordem-compra.nr-processo
                  AND bfordem-compra.numero-ordem <> ordem-compra.numero-ordem NO-LOCK:
                FIND bfcampo-lote-pregao-ord
                    WHERE bfcampo-lote-pregao-ord.numero-ordem = bfordem-compra.numero-ordem 
                      AND bfcampo-lote-pregao-ord.cod-campo    = "BBM-NR-LOTE":U 
                      AND bfcampo-lote-pregao-ord.dsl-conteudo = rowObject.dsl-conteudo NO-LOCK NO-ERROR.
                IF NOT AVAIL bfcampo-lote-pregao-ord THEN
                    NEXT.
                /*
                ** Verifica se Ç o mesmo item
                */ 
                IF ordem-compra.it-codigo <> bfordem-compra.it-codigo THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-lote-ja-informado-para-outra-o AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Lote_j†_informado_para_outra_ordem_de_compra_com_item_diferente" *}
                  ASSIGN c-lbl-liter-lote-ja-informado-para-outra-o = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-so-podem-ser-informadas-para-u AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "S¢_podem_ser_informadas_para_um_mesmo_lote,_ordens_de_compra_com_o_mesmo_item" *}
                  ASSIGN c-lbl-liter-so-podem-ser-informadas-para-u = TRIM(RETURN-VALUE).
                             {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters="c-lbl-liter-lote-ja-informado-para-outra-o + '.' + '~~~~' + c-lbl-liter-so-podem-ser-informadas-para-u"} 
                END.
                /*
                ** Verifica se item Ç dÇbito direto
                */
                FIND ITEM 
                    WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK NO-ERROR.
                IF AVAIL item AND
                   ITEM.tipo-contr = 4 THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-ordens-de-compra-de-item-debit AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Ordens_de_compra_de_item_dÇbito_direto_n∆o_podem_pertencer_ao_mesmo_lote" *}
                  ASSIGN c-lbl-liter-ordens-de-compra-de-item-debit = TRIM(RETURN-VALUE).
                  DEFINE VARIABLE c-lbl-liter-item-possui-tipo-de-controle-i AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Item_possui_tipo_de_controle_iguai_a_dÇbito_direto" *}
                  ASSIGN c-lbl-liter-item-possui-tipo-de-controle-i = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                             &ErrorNumber="17006"
                             &ErrorType="EMS"
                             &ErrorSubType="ERROR" 
                             &ErrorParameters="c-lbl-liter-ordens-de-compra-de-item-debit + '.' + '~~~~' + c-lbl-liter-item-possui-tipo-de-controle-i + '.'"}
                END.
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

