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
{include/i-prgvrs.i BOCX366 2.00.00.004} /*** "010004" 11/12/2023 10:13:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX366 MUT}
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
&GLOBAL-DEFINE DBOName BOCX366
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName model-docto
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
{cxbo/bocx366.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Definiá∆o de Vari†veis Locais */
DEFINE VARIABLE c-cod-prog-dtsul-ini AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-cod-prog-dtsul-fim AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-cdn-model-ini      AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cdn-model-fim      AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-mercosul-bolivia   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-mercosul-chile     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-mercosul-II        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-aladi              AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-form-a             AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-comum              AS LOGICAL    NO-UNDO.

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
        WHEN "cod_prog_dtsul":U THEN ASSIGN pFieldValue = RowObject.cod_prog_dtsul.
        WHEN "des-model-docto":U THEN ASSIGN pFieldValue = RowObject.des-model-docto.
        WHEN "nom-arq-model":U THEN ASSIGN pFieldValue = RowObject.nom-arq-model.
        WHEN "nom-dir-dest":U THEN ASSIGN pFieldValue = RowObject.nom-dir-dest.
        WHEN "nom-entid-certific":U THEN ASSIGN pFieldValue = RowObject.nom-entid-certific.
        WHEN "nom-prog-impres":U THEN ASSIGN pFieldValue = RowObject.nom-prog-impres.
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
        WHEN "cdn-model":U THEN ASSIGN pFieldValue = RowObject.cdn-model.
        WHEN "idi-tip-docto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-docto.
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
  Purpose:     Retorna valores dos campos do °ndice mdldct-id
  Parameters:  
               retorna valor do campo cod_prog_dtsul
               retorna valor do campo cdn-model
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod_prog_dtsul LIKE model-docto.cod_prog_dtsul NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-model LIKE model-docto.cdn-model NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod_prog_dtsul = RowObject.cod_prog_dtsul
           pcdn-model = RowObject.cdn-model.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getProxCodModelo DBOProgram 
PROCEDURE getProxCodModelo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod_prog_dtsul LIKE model-docto.cod_prog_dtsul NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-model      LIKE model-docto.cdn-model      NO-UNDO.

    FIND LAST bf{&TableName}
        WHERE bf{&TableName}.cod_prog_dtsul = pcod_prog_dtsul NO-LOCK NO-ERROR.
    IF  AVAIL bf{&TableName} THEN
        ASSIGN pcdn-model = bf{&TableName}.cdn-model + 1.
    ELSE
        ASSIGN pcdn-model = 1.

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
  Purpose:     Reposiciona registro com base no °ndice mdldct-id
  Parameters:  
               recebe valor do campo cod_prog_dtsul
               recebe valor do campo cdn-model
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod_prog_dtsul LIKE model-docto.cod_prog_dtsul NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-model LIKE model-docto.cdn-model NO-UNDO.

    FIND FIRST bfmodel-docto WHERE 
        bfmodel-docto.cod_prog_dtsul = pcod_prog_dtsul AND 
        bfmodel-docto.cdn-model = pcdn-model NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmodel-docto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmodel-docto)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryModelos DBOProgram 
PROCEDURE openQueryModelos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod_prog_dtsul >= c-cod-prog-dtsul-ini
           AND {&TableName}.cod_prog_dtsul <= c-cod-prog-dtsul-fim
           AND {&TableName}.cdn-model      >= i-cdn-model-ini     
           AND {&TableName}.cdn-model      <= i-cdn-model-fim
           AND (    ({&tablename}.idi-tip-docto = 1 AND l-mercosul-bolivia)
                OR  ({&tablename}.idi-tip-docto = 2 AND l-mercosul-chile)
                OR  ({&tablename}.idi-tip-docto = 3 AND l-mercosul-II)
                OR  ({&tablename}.idi-tip-docto = 4 AND l-aladi)
                OR  ({&tablename}.idi-tip-docto = 5 AND l-form-a)
                OR  ({&tablename}.idi-tip-docto = 6 AND l-comum)    ) INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintModelos DBOProgram 
PROCEDURE setConstraintModelos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-prog-dtsul-ini   LIKE {&TableName}.cod_prog_dtsul   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-prog-dtsul-fim   LIKE {&TableName}.cod_prog_dtsul   NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-model-ini        LIKE {&TableName}.cdn-model        NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-model-fim        LIKE {&TableName}.cdn-model        NO-UNDO.
    DEFINE INPUT PARAMETER pl-mercosul-bolivia   AS LOG                             NO-UNDO.
    DEFINE INPUT PARAMETER pl-mercosul-chile     AS LOG                             NO-UNDO.
    DEFINE INPUT PARAMETER pl-mercosul-II        AS LOG                             NO-UNDO.
    DEFINE INPUT PARAMETER pl-aladi              AS LOG                             NO-UNDO.
    DEFINE INPUT PARAMETER pl-form-a             AS LOG                             NO-UNDO.
    DEFINE INPUT PARAMETER pl-comum              AS LOG                             NO-UNDO.

    ASSIGN c-cod-prog-dtsul-ini = pcod-prog-dtsul-ini
           c-cod-prog-dtsul-fim = pcod-prog-dtsul-fim
           i-cdn-model-ini      = pcdn-model-ini     
           i-cdn-model-fim      = pcdn-model-fim
           l-mercosul-bolivia   = pl-mercosul-bolivia
           l-mercosul-chile     = pl-mercosul-chile
           l-mercosul-II        = pl-mercosul-II
           l-aladi              = pl-aladi           
           l-form-a             = pl-form-a
           l-comum              = pl-comum.

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

    IF  pType = "Create":U THEN DO:
        IF  CAN-FIND(FIRST bf{&TableName}
                     WHERE bf{&TableName}.cod_prog_dtsul = RowObject.cod_prog_dtsul
                       AND bf{&TableName}.cdn-model      = RowObject.cdn-model) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-modelo-documento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Modelo_Documento" *}
            ASSIGN c-lbl-liter-modelo-documento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="1" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-modelo-documento"}
        END.
    END.

    IF  pType = "Create":U OR pType = "Update":U THEN DO:

        IF  RowObject.cod_prog_dtsul = "":U THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codigo-do-programa AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_do_Programa" *}
            ASSIGN c-lbl-liter-codigo-do-programa = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="4241" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-codigo-do-programa"}
        END.
        ELSE DO:
            IF  NOT CAN-FIND(FIRST prog_dtsul
                             WHERE prog_dtsul.cod_prog_dtsul = RowObject.cod_prog_dtsul) THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="4709" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="''"}
            END.
        END.

        IF  RowObject.des-model-docto = "" OR
            RowObject.des-model-docto = ? THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-descricao-do-modelo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Descriá∆o_do_Modelo" *}
            ASSIGN c-lbl-liter-descricao-do-modelo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="4241" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-descricao-do-modelo"}
        END.

        IF  RowObject.nom-arq-model = "":U THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nome-do-arquivo-origem AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Nome_do_Arquivo_Origem" *}
            ASSIGN c-lbl-liter-nome-do-arquivo-origem = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="4241" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-nome-do-arquivo-origem"}
        END.
        ELSE DO:
            ASSIGN FILE-INFO:FILE-NAME = RowObject.nom-arq-model.
            IF  FILE-INFO:PATHNAME = ? OR SEARCH(RowObject.nom-arq-model) = ? THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-arquivo-modelo-origem AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Arquivo_Modelo_Origem" *}
                ASSIGN c-lbl-liter-arquivo-modelo-origem = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="17201" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-arquivo-modelo-origem"}
            END.
        END.

        IF  RowObject.nom-prog-impres = "":U THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nome-do-arquivo-de-impressao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Nome_do_Arquivo_de_Impress∆o" *}
            ASSIGN c-lbl-liter-nome-do-arquivo-de-impressao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="4241" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-nome-do-arquivo-de-impressao"}
        END.
        ELSE DO:
            ASSIGN FILE-INFO:FILE-NAME = RowObject.nom-prog-impres.
            IF  FILE-INFO:PATHNAME = ? OR SEARCH(RowObject.nom-prog-impres) = ? THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-arquivo-de-impressao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Arquivo_de_Impress∆o" *}
                ASSIGN c-lbl-liter-arquivo-de-impressao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="17201" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-arquivo-de-impressao"}
            END.
        END.

        IF  RowObject.nom-dir-dest = "":U THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-diretorio-destino AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Diret¢rio_Destino" *}
            ASSIGN c-lbl-liter-diretorio-destino = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="4241" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-diretorio-destino"}
        END.
        ELSE DO:
            ASSIGN FILE-INFO:FILE-NAME = RowObject.nom-dir-dest.
            IF  FILE-INFO:PATHNAME = ? OR SEARCH(RowObject.nom-dir-dest) <> ? THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-diretorio-destino-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Diret¢rio_Destino" *}
                ASSIGN c-lbl-liter-diretorio-destino-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="17201"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-diretorio-destino-2"}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaDoctoExportacao DBOProgram 
PROCEDURE verificaDoctoExportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcod-estabel-ini LIKE proc-docto-export.cod-estabel   NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-estabel-fim LIKE proc-docto-export.cod-estabel   NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-processo-ini LIKE proc-docto-export.nr-proc-exp   NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-processo-fim LIKE proc-docto-export.nr-proc-exp   NO-UNDO.
    DEFINE INPUT  PARAMETER pidi-tip-docto   LIKE proc-docto-export.idi-tip-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-processos     AS CHAR                              NO-UNDO.

    FOR EACH  estabelec
        WHERE estabelec.cod-estabel >= pcod-estabel-ini AND
              estabelec.cod-estabel <= pcod-estabel-fim NO-LOCK,
        EACH  processo-exp
        WHERE processo-exp.cod-estabel  = estabelec.cod-estabel AND
              processo-exp.nr-proc-exp >= pnr-processo-ini      AND
              processo-exp.nr-proc-exp <= pnr-processo-fim      NO-LOCK:

        IF  CAN-FIND (FIRST proc-docto-export
                      WHERE proc-docto-export.cod-estabel   = processo-exp.cod-estabel AND
                            proc-docto-export.nr-proc-exp   = processo-exp.nr-proc-exp AND
                            proc-docto-export.idi-tip-docto = pidi-tip-docto           NO-LOCK) THEN DO:

            IF  pc-processos <> "":U THEN
                ASSIGN pc-processos = pc-processos + ", " + processo-exp.nr-proc-exp.
            ELSE
                ASSIGN pc-processos = processo-exp.nr-proc-exp.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

