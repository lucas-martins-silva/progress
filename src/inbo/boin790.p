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
{include/i-prgvrs.i BOIN790 2.00.00.009 } /*** "010009" 17/06/2025 16:40:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin790 MUT}
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
&GLOBAL-DEFINE DBOName inbo790
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-emails
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
{inbo/boin790.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{lap/mlaapi001.i99}
{cdp/cd0666.i}
{utp/utapi019.i}
{laphtml/mlahtml.i}
{utp/ut-glob.i}

DEFINE VARIABLE hmla-param-aprov    AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-tipo-doc-aprov AS HANDLE NO-UNDO.
DEFINE VARIABLE hmla-rej-aprov      AS HANDLE NO-UNDO.

DEFINE VARIABLE l-atachado          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-email             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-servidor-email    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-porta-email       AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-des-tip-doc       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-des-rejeicao      AS CHARACTER  NO-UNDO.
                                   
DEFINE VARIABLE l-log-email         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-prog-html         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-titulo-email      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-texto-email       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-exchange          AS LOGICAL    NO-UNDO.

DEFINE VARIABLE l-anexar-conteudo   AS LOGICAL     NO-UNDO.

def buffer b-mla-doc-pend-aprov for mla-doc-pend-aprov.

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
         HEIGHT             = 2.58
         WIDTH              = 25.29.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyBO DBOProgram 
PROCEDURE destroyBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(hmla-param-aprov) THEN
        DELETE PROCEDURE hmla-param-aprov.

    IF VALID-HANDLE(hmla-tipo-doc-aprov) THEN
        DELETE PROCEDURE hmla-tipo-doc-aprov.

    IF VALID-HANDLE(hmla-rej-aprov) THEN
        DELETE PROCEDURE hmla-rej-aprov.

    RETURN "OK".
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
        WHEN "char-3":U THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "html-aprovacao":U THEN ASSIGN pFieldValue = RowObject.html-aprovacao.
        WHEN "html-documento":U THEN ASSIGN pFieldValue = RowObject.html-documento.
        WHEN "html-geracao":U THEN ASSIGN pFieldValue = RowObject.html-geracao.
        WHEN "html-rejeicao":U THEN ASSIGN pFieldValue = RowObject.html-rejeicao.
        WHEN "texto-email-aprova":U THEN ASSIGN pFieldValue = RowObject.texto-email-aprova.
        WHEN "texto-email-doc":U THEN ASSIGN pFieldValue = RowObject.texto-email-doc.
        WHEN "texto-email-gera":U THEN ASSIGN pFieldValue = RowObject.texto-email-gera.
        WHEN "texto-email-rej":U THEN ASSIGN pFieldValue = RowObject.texto-email-rej.
        WHEN "titulo-email-aprova":U THEN ASSIGN pFieldValue = RowObject.titulo-email-aprova.
        WHEN "titulo-email-doc":U THEN ASSIGN pFieldValue = RowObject.titulo-email-doc.
        WHEN "titulo-email-gera":U THEN ASSIGN pFieldValue = RowObject.titulo-email-gera.
        WHEN "titulo-email-rej":U THEN ASSIGN pFieldValue = RowObject.titulo-email-rej.
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
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
        WHEN "data-3":U THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U THEN ASSIGN pFieldValue = RowObject.data-5.
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
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
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
        WHEN "cod-tip-doc":U THEN ASSIGN pFieldValue = RowObject.cod-tip-doc.
        &IF "{&mguni_version}" < "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice e-mail
  Parameters:  
               retorna valor do campo ep-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-tip-doc
               retorna valor do campo e-mail
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pep-codigo LIKE mla-emails.ep-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE mla-emails.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-tip-doc LIKE mla-emails.cod-tip-doc NO-UNDO.
    DEFINE OUTPUT PARAMETER pe-mail LIKE mla-emails.e-mail NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pep-codigo = RowObject.ep-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-tip-doc = RowObject.cod-tip-doc
           pe-mail = RowObject.e-mail.

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U THEN ASSIGN pFieldValue = RowObject.log-5.
        WHEN "log-aprovacao":U THEN ASSIGN pFieldValue = RowObject.log-aprovacao.
        WHEN "log-documento":U THEN ASSIGN pFieldValue = RowObject.log-documento.
        WHEN "log-geracao":U THEN ASSIGN pFieldValue = RowObject.log-geracao.
        WHEN "log-rejeicao":U THEN ASSIGN pFieldValue = RowObject.log-rejeicao.
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
  Purpose:     Reposiciona registro com base no °ndice e-mail
  Parameters:  
               recebe valor do campo ep-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-tip-doc
               recebe valor do campo e-mail
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pep-codigo LIKE mla-emails.ep-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE mla-emails.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tip-doc LIKE mla-emails.cod-tip-doc NO-UNDO.
    DEFINE INPUT PARAMETER pe-mail LIKE mla-emails.e-mail NO-UNDO.

    FIND FIRST bfmla-emails WHERE 
        bfmla-emails.ep-codigo = pep-codigo AND 
        bfmla-emails.cod-estabel = pcod-estabel AND 
        bfmla-emails.cod-tip-doc = pcod-tip-doc AND 
        bfmla-emails.e-mail = pe-mail NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-emails THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-emails)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeBO DBOProgram 
PROCEDURE initializeBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(hmla-param-aprov) THEN DO:
        RUN inbo/boin773.p PERSISTENT SET hmla-param-aprov.
        run openQueryStatic in hmla-param-aprov (input "Main").
    END.
     
    IF  NOT VALID-HANDLE(hmla-tipo-doc-aprov) THEN DO:
        RUN inbo/boin784.p PERSISTENT SET hmla-tipo-doc-aprov.
        run openQueryStatic in hmla-tipo-doc-aprov (input "Main").
    END.

    IF  NOT VALID-HANDLE(hmla-rej-aprov) THEN DO:
        RUN inbo/boin778.p PERSISTENT SET hmla-rej-aprov.
        run openQueryStatic in hmla-rej-aprov (input "Main").
    END.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (input "Main":U). 

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
    open query {&QUERYNAME} 
        for each {&TABLENAME} 
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmailAltern DBOProgram 
PROCEDURE setEnviaEmailAltern :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-tipo-mov       as integer no-undo.
    def INPUT PARAMETER p-origem         AS INTEGER NO-UNDO.
    def input parameter p-cod-aprovador  as char    no-undo.
    def input parameter p-rowid-doc-pend as rowid   no-undo.
    def input parameter table for tt-mla-chave.

    RUN initializeBO IN THIS-PROCEDURE.

    find mla-doc-pend-aprov where
        rowid(mla-doc-pend-aprov) = p-rowid-doc-pend
        no-lock no-error.

    if not available mla-doc-pend-aprov then
        RETURN "NOK".
    
    RUN goToKey IN hmla-param-aprov (INPUT mla-doc-pend-aprov.ep-codigo,
                                     INPUT mla-doc-pend-aprov.cod-estabel).


    IF  p-origem = 2 THEN
        ASSIGN l-exchange = NO.
    ELSE
        RUN getLogField IN hmla-param-aprov (INPUT  "log-exchange",
                                             OUTPUT l-exchange).
    
    RUN getLogField IN hmla-param-aprov (INPUT  "log-atachado",
                                         OUTPUT l-atachado).
    RUN getCharField IN hmla-param-aprov (INPUT  "servidor-email",
                                          OUTPUT c-servidor-email).
    RUN getIntField IN hmla-param-aprov (INPUT  "porta-email",
                                          OUTPUT i-porta-email).

    find first param-global
        no-lock no-error.

    RUN goToKey IN hmla-tipo-doc-aprov (INPUT mla-doc-pend-aprov.cod-tip-doc).
    RUN getCharField IN hmla-tipo-doc-aprov (INPUT  "des-tip-doc",
                                             OUTPUT c-des-tip-doc).

    RUN goToKey IN hmla-rej-aprov (INPUT mla-doc-pend-aprov.cod-rejeicao).
    RUN getCharField IN hmla-rej-aprov (INPUT  "des-rejeicao",
                                        OUTPUT c-des-rejeicao).

    for each mla-emails where
        mla-emails.ep-codigo   = mla-doc-pend-aprov.ep-codigo   and
        mla-emails.cod-estabel = mla-doc-pend-aprov.cod-estabel and
        mla-emails.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc no-lock:
        
        ASSIGN c-email = mla-emails.e-mail.

        case p-tipo-mov:
            when 1 then
                assign l-log-email    = mla-emails.log-geracao
                       c-prog-html    = mla-emails.html-geracao
                       c-titulo-email = mla-emails.titulo-email-gera
                       c-texto-email  = mla-emails.texto-email-gera.
            when 2 then
                assign l-log-email    = mla-emails.log-aprovacao
                       c-prog-html    = mla-emails.html-aprovacao
                       c-titulo-email = mla-emails.titulo-email-aprova
                       c-texto-email  = mla-emails.texto-email-aprova.
            when 3 then
                assign l-log-email    = mla-emails.log-rejeicao
                       c-prog-html    = mla-emails.html-rejeicao
                       c-titulo-email = mla-emails.titulo-email-rej
                       c-texto-email  = mla-emails.texto-email-rej.
            when 4 then
                assign l-log-email    = mla-emails.log-documento
                       c-prog-html    = mla-emails.html-documento
                       c-titulo-email = mla-emails.titulo-email-doc
                       c-texto-email  = mla-emails.texto-email-doc.
        end case.

        if  l-log-email then do:
    
            if  p-tipo-mov = 4 then do:
                /** Aprovaá∆o Documento 
                **/
                find first b-mla-doc-pend-aprov where
                    b-mla-doc-pend-aprov.ep-codigo    = mla-doc-pend-aprov.ep-codigo and
                    b-mla-doc-pend-aprov.cod-estabel  = mla-doc-pend-aprov.cod-estabel and
                    b-mla-doc-pend-aprov.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc and
                    b-mla-doc-pend-aprov.chave-doc    = mla-doc-pend-aprov.chave-doc   and
                   (b-mla-doc-pend-aprov.ind-situacao = 1  or
                    b-mla-doc-pend-aprov.ind-situacao = 3) and
                    b-mla-doc-pend-aprov.historico    = no
                    no-lock no-error.
                if available b-mla-doc-pend-aprov then
                    return.                
            end.
    
            if  c-prog-html <> "" and
                c-prog-html <> ?  then do:
                for each tt-html:
                    delete tt-html.
                end.
                for each tt-mensagem:
                    delete tt-mensagem.
                end.
                
                run value("laphtml/" + trim(c-prog-html)) (p-tipo-mov,
                                                           p-cod-aprovador,
                                                           /*p-rowid-doc-pend,*/
                                                           input  table tt-mla-chave,
                                                           output table tt-html).
                                                           
                /* Verifica o tamanho do e-mail para que n∆o ultrapasse 32kb. Se ultrapassar ser† enviado um arquivo em anexo. */
                RUN verificaTamanhoEmail.

                if  l-anexar-conteudo then do:
                    OUTPUT TO value(SESSION:TEMP-DIRECTORY + "/" + REPLACE(p-cod-aprovador," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm") CONVERT TARGET "UTF-8":U APPEND.
                    FOR EACH tt-html :
                            PUT UNFORMATTED tt-html.html-doc SKIP.
                    END.
                    OUTPUT CLOSE.
                end.
                else do:
                    FOR EACH tt-html:
                        CREATE tt-mensagem.
                        ASSIGN tt-mensagem.seq-mensagem = tt-html.seq-html
                               tt-mensagem.mensagem     = tt-html.html-doc.
                    END.
                end.
                
                FOR EACH tt-envio2:
                    DELETE tt-envio2.
                END.      
                create tt-envio2.
                assign tt-envio2.versao-integracao = 1
                       tt-envio2.exchange    = l-exchange
                       tt-envio2.destino     = mla-emails.e-mail
                       tt-envio2.assunto     = c-titulo-email
                       tt-envio2.importancia = 2
                       tt-envio2.log-enviada = no
                       tt-envio2.log-lida    = no
                       tt-envio2.acomp       = no
                       tt-envio2.formato     = "HTML"
                       tt-envio2.remetente   = c-email.
    
                if  l-anexar-conteudo then
                    assign tt-envio2.mensagem    = "Foi gerada uma pendància de aprovaá∆o!" + chr(13) +
                                                   "Favor verificar o arquivo atachado."
                           tt-envio2.arq-anexo   = STRING(SESSION:TEMP-DIRECTORY) + "/" + REPLACE(p-cod-aprovador," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                else                           
                    assign tt-envio2.mensagem    = c-texto-email.
    
                IF NOT l-exchange THEN 
                     ASSIGN tt-envio2.servidor = c-servidor-email
                            tt-envio2.porta    = i-porta-email.
                       
                run utp/utapi019.p persistent set h-utapi019.
                
                if  l-anexar-conteudo then
                    run pi-execute  in h-utapi019 (input table tt-envio2,                   
                                                   output table tt-erros).
                else
                    run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                                   INPUT TABLE tt-mensagem,
                                                   output table tt-erros).                                                                           
    
                /**  Output do erro (e-mail)
                **/               
                find first tt-envio2 no-error.                    
                {lap/mlaapi001.i02 "aed0130a.p (01)" tt-envio2.destino tt-envio2.remetente}                                    
    
                delete procedure h-utapi019.
                
                if  l-anexar-conteudo then
                    OS-DELETE value(SESSION:TEMP-DIRECTORY + "/" + REPLACE(p-cod-aprovador," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm").
                
            end.
            else do:
            
                for each tt-envio:
                    delete tt-envio.
                end.
                create tt-envio.
                assign tt-envio.versao-integracao = 1
                       tt-envio.exchange    = l-exchange
                       tt-envio.destino     = mla-emails.e-mail
                       tt-envio.assunto     = c-titulo-email
                       tt-envio.mensagem    = c-texto-email
                       tt-envio.importancia = 2
                       tt-envio.log-enviada = no
                       tt-envio.log-lida    = no
                       tt-envio.acomp       = no
                       tt-envio.arq-anexo   = ""
                       tt-envio.remetente   = c-email.
    
                IF  NOT l-exchange THEN 
                    ASSIGN tt-envio.servidor = c-servidor-email
                           tt-envio.porta    = i-porta-email.
    
                assign tt-envio.assunto = replace(tt-envio.assunto,"$01",string(mla-doc-pend-aprov.ep-codigo))
                       tt-envio.assunto = replace(tt-envio.assunto,"$02",mla-doc-pend-aprov.cod-estabel)
                       tt-envio.assunto = replace(tt-envio.assunto,"$03",mla-doc-pend-aprov.cod-usuar-doc)
                       tt-envio.assunto = replace(tt-envio.assunto,"$04",mla-doc-pend-aprov.cod-usuar-trans).
                if  mla-doc-pend-aprov.cod-usuar-altern <> "" then
                    assign tt-envio.assunto = replace(tt-envio.assunto,"$05",mla-doc-pend-aprov.cod-usuar-altern).
                else
                    assign tt-envio.assunto = replace(tt-envio.assunto,"$05",mla-doc-pend-aprov.cod-usuar).
                assign tt-envio.assunto = replace(tt-envio.assunto,"$06",string(mla-doc-pend-aprov.cod-tip-doc)).
                assign tt-envio.assunto = replace(tt-envio.assunto,"$07",c-des-tip-doc).
                assign tt-envio.assunto = replace(tt-envio.assunto,"$08",string(mla-doc-pend-aprov.valor-doc))
                       tt-envio.assunto = replace(tt-envio.assunto,"$09",string(mla-doc-pend-aprov.cod-rejeicao)).
                assign tt-envio.assunto = replace(tt-envio.assunto,"$10",c-des-rejeicao).
                assign tt-envio.assunto = replace(tt-envio.assunto,"$11",mla-doc-pend-aprov.narrativa-rej)
                       tt-envio.assunto = replace(tt-envio.assunto,"$12",mla-doc-pend-aprov.narrativa-apr)
                       tt-envio.assunto = replace(tt-envio.assunto,"$13",mla-doc-pend-aprov.chave-doc).
    
                assign tt-envio.mensagem = replace(tt-envio.mensagem,"$01",string(mla-doc-pend-aprov.ep-codigo))
                       tt-envio.mensagem = replace(tt-envio.mensagem,"$02",mla-doc-pend-aprov.cod-estabel)
                       tt-envio.mensagem = replace(tt-envio.mensagem,"$03",mla-doc-pend-aprov.cod-usuar-doc)
                       tt-envio.mensagem = replace(tt-envio.mensagem,"$04",mla-doc-pend-aprov.cod-usuar-trans).
                if mla-doc-pend-aprov.cod-usuar-altern <> "" then
                    assign tt-envio.mensagem = replace(tt-envio.mensagem,"$05",mla-doc-pend-aprov.cod-usuar-altern).
                else
                    assign tt-envio.mensagem = replace(tt-envio.mensagem,"$05",mla-doc-pend-aprov.cod-usuar).
                assign tt-envio.mensagem = replace(tt-envio.mensagem,"$06",string(mla-doc-pend-aprov.cod-tip-doc)).
                assign tt-envio.mensagem = replace(tt-envio.mensagem,"$07",c-des-tip-doc).
                assign tt-envio.mensagem = replace(tt-envio.mensagem,"$08",string(mla-doc-pend-aprov.valor-doc))
                       tt-envio.mensagem = replace(tt-envio.mensagem,"$09",string(mla-doc-pend-aprov.cod-rejeicao)).
                assign tt-envio.mensagem = replace(tt-envio.mensagem,"$10",c-des-rejeicao).
    
                assign tt-envio.mensagem = replace(tt-envio.mensagem,"$11",mla-doc-pend-aprov.narrativa-rej)
                       tt-envio.mensagem = replace(tt-envio.mensagem,"$12",mla-doc-pend-aprov.narrativa-apr)
                       tt-envio.mensagem = replace(tt-envio.mensagem,"$13",mla-doc-pend-aprov.chave-doc).
                   
                run utp/utapi009.p (input  table tt-envio,
                                    output table tt-erros).
                                    
                /**  Output do erro (e-mail)
                **/               
                find first tt-envio no-error.                    
                {lap/mlaapi001.i02 "aed0130a.p (02)" tt-envio.destino tt-envio.remetente}                                    
                                    
            end.
        end.
    end.

    RUN destroyBO IN THIS-PROCEDURE.


    RETURN "OK".
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
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:
        IF pType = "CREATE":U
        AND CAN-FIND(FIRST mla-emails
                     WHERE mla-emails.ep-codigo = RowObject.ep-codigo
                       AND mla-emails.cod-estabel = RowObject.cod-estabel
                       AND mla-emails.cod-tip-doc = RowObject.cod-tip-doc
                       AND mla-emails.e-mail = RowObject.e-mail) THEN DO:
            {utp/ut-liter.i "e-mails_alternativos"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida empresa */
        IF NOT CAN-FIND(FIRST empresa
                        WHERE empresa.ep-codigo = RowObject.ep-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */ 
            {utp/ut-liter.i "empresa"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida estabelecimento */
        IF NOT CAN-FIND(FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
            /* Inicio -- Projeto Internacional */ 
            {utp/ut-liter.i "estabelecimento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        /* Valida documento */
        IF NOT CAN-FIND(FIRST mla-tipo-doc-aprov
                        WHERE mla-tipo-doc-aprov.cod-tip-doc = RowObject.cod-tip-doc
                          AND mla-tipo-doc-aprov.ep-codigo   = RowObject.ep-codigo) THEN DO:
            /* Inicio -- Projeto Internacional */ 
            {utp/ut-liter.i "documento"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaTamanhoEmail DBOProgram 
PROCEDURE verificaTamanhoEmail :
/* -----------------------------------------------------------
  Purpose: Validar se o tamanho do e-mail ultrapassa 32k.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE i-tamanho-msg     AS INTEGER     NO-UNDO.

    IF NOT l-atachado  THEN DO:
        FOR EACH tt-html :
            ASSIGN i-tamanho-msg = i-tamanho-msg + LENGTH(tt-html.html-doc).
        END.

        IF i-tamanho-msg > 32000 THEN DO:
            ASSIGN l-anexar-conteudo = YES.
        END.
    END.
    ELSE DO:
        ASSIGN l-anexar-conteudo = l-atachado.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

