&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
{include/i-prgvrs.i BOIN389 2.00.00.006 } /*** "010006" 25/10/2023 14:45:48  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN389 MCQ}
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
&GLOBAL-DEFINE DBOName BOIN389
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName res-fic-cq
&GLOBAL-DEFINE TableLabel Resultado do Roteiro de Inspecao
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
{inbo/boin389.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

DEFINE TEMP-TABLE ttRowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER
    index seq ErrorSequence.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-responsavel  FOR responsavel.

DEF NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHAR NO-UNDO.

DEF VAR l-resul-fora-faixa AS LOG  INITIAL NO  NO-UNDO.
DEF VAR l-valida-resp      AS LOG  INITIAL YES NO-UNDO.
DEF VAR c-mesg1            AS CHAR             NO-UNDO.
DEF VAR c-mesg2            AS CHAR             NO-UNDO.
DEF VAR i-tipo-result      AS INT              NO-UNDO.
DEF VAR i-nr-tabela        AS INT              NO-UNDO.
DEF VAR i-cdn-verso        AS INT              NO-UNDO.
DEF VAR h-boin124a         AS HANDLE           NO-UNDO.
DEF VAR h-boin052          AS HANDLE           NO-UNDO.

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
         HEIGHT             = 16.25
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaNarrativa DBOProgram 
PROCEDURE atualizaNarrativa :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza Narrativa
  Parameters:  
               recebe valor do campo nr-ficha
               recebe valor do campo it-codigo
               recebe valor do campo cod-exame
               recebe valor do campo cod-comp
               recebe narrativa
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ficha LIKE res-fic-cq.nr-ficha NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE res-fic-cq.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE res-fic-cq.cod-exame NO-UNDO.
    DEFINE INPUT PARAMETER pcod-comp LIKE res-fic-cq.cod-comp NO-UNDO.
    DEFINE INPUT PARAMETER pnarrativa LIKE res-fic-cq.narrativa NO-UNDO.
    
    FIND FIRST bfres-fic-cq WHERE 
        bfres-fic-cq.nr-ficha = pnr-ficha AND 
        bfres-fic-cq.it-codigo = pit-codigo AND 
        bfres-fic-cq.cod-exame = pcod-exame AND 
        bfres-fic-cq.cod-comp = pcod-comp EXCLUSIVE-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF AVAILABLE bfres-fic-cq THEN 
        ASSIGN bfres-fic-cq.narrativa = pnarrativa.
    ELSE
        RETURN "NOK":U.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-resp":U THEN ASSIGN pFieldValue = RowObject.cod-resp.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "laudo":U THEN ASSIGN pFieldValue = RowObject.laudo.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "usuario":U THEN ASSIGN pFieldValue = RowObject.usuario.
        WHEN "cod-num-amostra":U THEN ASSIGN pFieldValue = RowObject.cod-num-amostra. 
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-result":U THEN ASSIGN pFieldValue = RowObject.dt-result.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "res-max":U THEN ASSIGN pFieldValue = RowObject.res-max.
        WHEN "resultado":U THEN ASSIGN pFieldValue = RowObject.resultado.
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
        WHEN "cod-comp":U THEN ASSIGN pFieldValue = RowObject.cod-comp.
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ac-comp":U THEN ASSIGN pFieldValue = RowObject.nr-ac-comp.
        WHEN "nr-ac-ex":U THEN ASSIGN pFieldValue = RowObject.nr-ac-ex.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "nr-tabela":U THEN ASSIGN pFieldValue = RowObject.nr-tabela.
        WHEN "num-test":U THEN ASSIGN pFieldValue = RowObject.num-test.
        WHEN "seq-comp":U THEN ASSIGN pFieldValue = RowObject.seq-comp.
        WHEN "tipo-result":U THEN ASSIGN pFieldValue = RowObject.tipo-result.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo nr-ficha
               retorna valor do campo it-codigo
               retorna valor do campo cod-exame
               retorna valor do campo cod-comp
               retorna valor do campo num-test
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ficha LIKE res-fic-cq.nr-ficha NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE res-fic-cq.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-exame LIKE res-fic-cq.cod-exame NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-comp LIKE res-fic-cq.cod-comp NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-test LIKE res-fic-cq.num-test NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-ficha = RowObject.nr-ficha
           pit-codigo = RowObject.it-codigo
           pcod-exame = RowObject.cod-exame
           pcod-comp = RowObject.cod-comp
           pnum-test = RowObject.num-test.

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
        WHEN "inspecionado":U THEN ASSIGN pFieldValue = RowObject.inspecionado.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo nr-ficha
               recebe valor do campo it-codigo
               recebe valor do campo cod-exame
               recebe valor do campo cod-comp
               recebe valor do campo num-test
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ficha LIKE res-fic-cq.nr-ficha NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE res-fic-cq.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-exame LIKE res-fic-cq.cod-exame NO-UNDO.
    DEFINE INPUT PARAMETER pcod-comp LIKE res-fic-cq.cod-comp NO-UNDO.
    DEFINE INPUT PARAMETER pnum-test LIKE res-fic-cq.num-test NO-UNDO.

    FIND FIRST bfres-fic-cq WHERE 
        bfres-fic-cq.nr-ficha = pnr-ficha AND 
        bfres-fic-cq.it-codigo = pit-codigo AND 
        bfres-fic-cq.cod-exame = pcod-exame AND 
        bfres-fic-cq.cod-comp = pcod-comp AND 
        bfres-fic-cq.num-test = pnum-test NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfres-fic-cq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfres-fic-cq)).
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

    OPEN QUERY {&QueryName}
        FOR EACH res-fic-cq NO-LOCK INDEXED-REPOSITION.
    
    return 'OK':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintParamFaixa DBOProgram 
PROCEDURE setConstraintParamFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: p-resul-fora-faixa - Receber† um parÉmetro l¢gico para definir se
    deve aceitar resultados fora da faixa
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-resul-fora-faixa AS LOGICAL NO-UNDO.

    ASSIGN l-resul-fora-faixa = p-resul-fora-faixa.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintValidResp DBOProgram 
PROCEDURE setConstraintValidResp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: p-valid-responsavel - Receber† um parÉmetro l¢gico para definir se
    deve validar ou n∆o o usu†rio respons†vel com o usu†rio da importaá∆o.
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-valid-responsavel AS LOGICAL NO-UNDO.

    ASSIGN l-valida-resp = p-valid-responsavel.

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


    IF pType = "CREATE":U THEN DO:

        ASSIGN i-tipo-result = 0
               i-nr-tabela   = 0
               i-cdn-verso   = 0.

        /** VALIDAÄ«O REGISTRO Jµ EXISTENTE **/
        IF CAN-FIND(FIRST bfres-fic-cq NO-LOCK
                    WHERE bfres-fic-cq.nr-ficha  = RowObject.nr-ficha
                      AND bfres-fic-cq.it-codigo = RowObject.it-codigo
                      AND bfres-fic-cq.cod-exame = RowObject.cod-exame
                      AND bfres-fic-cq.cod-comp  = RowObject.cod-comp
                      AND bfres-fic-cq.num-test  = RowObject.num-test) THEN DO:

            {utp/ut-liter.i "Resultado_do_Roteiro_de_Inspecao" *}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        FIND FIRST ficha-cq NO-LOCK
             WHERE ficha-cq.nr-ficha = RowObject.nr-ficha NO-ERROR.
        IF NOT AVAIL ficha-cq THEN DO:
            {utp/ut-liter.i "Fichas_Controle_de_Qualidade" *}
            {method/svc/errors/inserr.i &ErrorNumber="1"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.
        ELSE DO:
            IF ficha-cq.inspecionado = YES THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="827"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.

            IF ficha-cq.situacao <> 2 THEN DO :
                {method/svc/errors/inserr.i &ErrorNumber="828"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.

            IF  ficha-cq.qt-original  - ficha-cq.qt-aprovada
              - ficha-cq.qt-consumida - ficha-cq.qt-rejeitada
              - ficha-cq.qt-apr-cond <= 0 THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="829"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
        END.

        FIND FIRST ITEM NO-LOCK
             WHERE item.it-codigo = RowObject.it-codigo NO-ERROR.
        IF NOT AVAIL ITEM THEN DO:
            {utp/ut-liter.i "Item" *}
            {method/svc/errors/inserr.i &ErrorNumber="47"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="TRIM(RETURN-VALUE)"}
        END.

        FIND FIRST item-uni-estab NO-LOCK
             WHERE item-uni-estab.it-codigo   = RowObject.it-codigo
               AND item-uni-estab.cod-estabel = ficha-cq.cod-estabel NO-ERROR.

        IF NOT AVAIL item-uni-estab THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="5101"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"}
        END.
        ELSE DO:
            IF item-uni-estab.contr-qualid = NO THEN DO:
                /* Item nío possui Controle da Qualidade */
                {method/svc/errors/inserr.i &ErrorNumber="8843"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
        END.

        FIND FIRST exam-ficha NO-LOCK
             WHERE exam-ficha.nr-ficha = ficha-cq.nr-ficha NO-ERROR.
        IF NOT AVAIL exam-ficha THEN DO:
            {utp/ut-liter.i Roteiro MCQ}
            ASSIGN c-mesg1 = TRIM(RETURN-VALUE).
            {utp/ut-table.i mgind exame 1}
            ASSIGN c-mesg2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2734"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-mesg1 + '~~~~' + c-mesg2"}
        END.
        ELSE DO:

            IF l-valida-resp THEN DO:
                FIND FIRST responsavel NO-LOCK
                     WHERE responsavel.cod-resp = c-seg-usuario NO-ERROR.

                IF AVAIL responsavel AND
                   exam-ficha.responsavel <> responsavel.cod-resp THEN DO:
                    FIND FIRST b-responsavel NO-LOCK
                         WHERE b-responsavel.cod-resp = exam-ficha.responsavel NO-ERROR.
                    IF AVAIL b-responsavel AND
                       b-responsavel.log-1 = NO THEN DO:

                        {method/svc/errors/inserr.i &ErrorNumber="4304"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="STRING(exam-ficha.cod-exame) + '~~~~' + exam-ficha.responsavel"}
                    END.
                END.
            END.

            IF CAN-FIND (FIRST it-comp-exame NO-LOCK
                         WHERE it-comp-exame.it-codigo = exam-ficha.it-codigo
                           AND it-comp-exame.cod-exame = exam-ficha.cod-exame
                           AND it-comp-exame.cod-comp  = RowObject.cod-comp) THEN DO:
                FIND FIRST it-comp-exame NO-LOCK
                     WHERE it-comp-exame.it-codigo = exam-ficha.it-codigo
                       AND it-comp-exame.cod-exame = exam-ficha.cod-exame
                       AND it-comp-exame.cod-comp  = RowObject.cod-comp NO-ERROR.
                ASSIGN i-tipo-result = it-comp-exame.tipo-result
                       i-nr-tabela   = it-comp-exame.nr-tabela.
            END.
            ELSE DO:
                IF CAN-FIND(FIRST comp-exame NO-LOCK
                            WHERE comp-exame.cod-exame = exam-ficha.cod-exame
                              AND comp-exame.cod-comp  = RowObject.cod-comp
                              AND comp-exame.cdn-versao = exam-ficha.cdn-versao
                              AND comp-exame.log-1) THEN DO:
                    FIND FIRST comp-exame NO-LOCK
                         WHERE comp-exame.cod-exame = exam-ficha.cod-exame
                           AND comp-exame.cod-comp  = RowObject.cod-comp
                           AND comp-exame.cdn-versao = exam-ficha.cdn-versao
                           AND comp-exame.log-1 NO-ERROR.
                    ASSIGN i-tipo-result = comp-exame.tipo-result
                           i-nr-tabela   = comp-exame.nr-tabela.
                END.
            END.

            ASSIGN i-cdn-verso = exam-ficha.cdn-versao.
        END.

        IF i-tipo-result <> 0 THEN DO:

            IF  NOT VALID-HANDLE(h-boin124a)          OR
                h-boin124a:TYPE      <> "PROCEDURE":U OR
                h-boin124a:FILE-NAME <> "inbo/boin124a.p":U THEN DO:
                RUN inbo/boin124a.p PERSISTENT SET h-boin124a.
            END.
            IF  NOT VALID-HANDLE(h-boin052)          OR
                h-boin052:TYPE      <> "PROCEDURE":U OR
                h-boin052:FILE-NAME <> "inbo/boin052.p":U THEN DO:
                RUN inbo/boin052.p PERSISTENT SET h-boin052.
            END.

            CASE i-tipo-result:
                WHEN 1 THEN DO: /*NUMêRICO*/
                    RUN validaDigitacaoResultado IN h-boin124a (INPUT i-tipo-result,
                                                                INPUT RowObject.cod-exame,
                                                                INPUT RowObject.cod-comp,
                                                                INPUT i-cdn-verso,
                                                                INPUT RowObject.it-codigo,
                                                                INPUT RowObject.resultado).

                    IF RETURN-VALUE = "NOK":U THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="833"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"}
                    END.
                END.
                WHEN 2 THEN DO: /*TABELA*/
                    RUN goToKey IN h-boin052 (INPUT i-nr-tabela,
                                              INPUT RowObject.seq-comp).
                    IF  RETURN-VALUE = "NOK" then do:
                        {utp/ut-table.i mgind comp-tab-res 1}
                        {method/svc/errors/inserr.i &ErrorNumber="47"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="TRIM(RETURN-VALUE)"}
                    END.
                END.
                WHEN 3 THEN DO: /*TEXTO*/
                    /* Se for texto n∆o precisa validar nada */
                END.
                WHEN 4 THEN DO: /*FAIXA*/
                    /*parte 1*/
                    EMPTY TEMP-TABLE ttRowErrors NO-ERROR.
                    RUN emptyRowErrors IN h-boin124a.
                    RUN validaResMin IN h-boin124a(INPUT RowObject.it-codigo,
                                                   INPUT RowObject.cod-exame,
                                                   INPUT RowObject.cod-comp,
                                                   INPUT i-cdn-verso,
                                                   INPUT RowObject.resultado,
                                                   OUTPUT TABLE ttRowErrors).

                    RUN getRowErrors IN h-boin124a(OUTPUT TABLE ttRowErrors).
                    FOR FIRST ttRowErrors:

                        IF l-resul-fora-faixa THEN DO: /*permite resultado fora da faixa exibe aviso*/
                            {method/svc/errors/inserr.i &ErrorNumber="54703"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="WARNING"}
                        END.
                        ELSE DO: /*n„o permite fora da faixa, ir· gerar erro*/
                            {method/svc/errors/inserr.i &ErrorNumber="54704"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"}
                        END.

                    END.
                    
                    /*parte 2*/
                    EMPTY TEMP-TABLE ttrowErrors NO-ERROR.
                    RUN emptyRowErrors IN h-boin124a.
                    RUN validaResMax IN h-boin124a(INPUT RowObject.it-codigo,
                                                   INPUT RowObject.cod-exame,
                                                   INPUT RowObject.cod-comp,
                                                   INPUT i-cdn-verso,
                                                   INPUT RowObject.res-max,
                                                   OUTPUT TABLE ttRowErrors).

                    FOR FIRST ttRowErrors:
                        
                        IF l-resul-fora-faixa THEN DO: /*permite resultado fora da faixa exibe aviso*/
                            {method/svc/errors/inserr.i &ErrorNumber="54705"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="WARNING"}
                        END.
                        ELSE DO: /*n„o permite fora da faixa, ir· gerar erro*/
                            {method/svc/errors/inserr.i &ErrorNumber="54706"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"}
                        END.
                    END.

                    /*parte 3*/
                    EMPTY TEMP-TABLE ttRowErrors NO-ERROR.
                    RUN emptyRowErrors IN h-boin124a.
                    RUN validaDigitacaoFaixa IN h-boin124a(INPUT RowObject.it-codigo,
                                                           INPUT RowObject.cod-exame,
                                                           INPUT RowObject.cod-comp,
                                                           INPUT i-cdn-verso,
                                                           INPUT RowObject.resultado,
                                                           INPUT RowObject.res-max,
                                                           OUTPUT TABLE ttRowErrors).

                    FOR FIRST ttRowErrors:
                        {method/svc/errors/inserr.i &ErrorNumber="ttRowErrors.ErrorNumber"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                                    &ErrorParameters="ttRowErrors.ErrorParameters"}
                    END.
                END.
            END CASE.

            IF  VALID-HANDLE(h-boin124a) THEN DO:
                DELETE PROCEDURE h-boin124a.
                ASSIGN h-boin124a = ?.
            END.
            IF  VALID-HANDLE(h-boin052) THEN DO:
                DELETE PROCEDURE h-boin052.
                ASSIGN h-boin052 = ?.
            END.

        END. /* IF i-tipo-result <> 0 THEN DO: */
    END. /* IF pType = "CREATE":U THEN DO: */

    IF pType = "CREATE":U OR
       pType = "UPDATE":U THEN DO:
       
    END.

    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

