&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/**************************************************************************
** Copyright TOTVS S.A. (2025) 
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa. 
***************************************************************************/
{include/i-prgvrs.i BOIN303 2.00.00.021 } /*** "010021" 12/06/2026 17:19:26 ***/
{include/i-license-manager.i boin303 MUT}

/*:T--------------------------------------------------------------------------
    File       : boin303.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Notes: Tabela de cabeáalho dos eventos dos tributos (Reforma tribut†ria)
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN303
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName evento-trib-dfe
&GLOBAL-DEFINE TableLabel Eventos tributos
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m?todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d? acessos a todos os registros, exceto os exclu?dos pela constraint de seguran?a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret?rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id?ntico ao nome do DBO mas com 
      extens?o .i ---*/
{inbo/boin303.i RowObject}


/*:T--- Include com defini??o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera??o da defini??o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini??o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
{inbo/boin303.i tt-evento-trib-dfe}
{inbo/boin304.i tt-evento-trib-dfe-item}    
{inbo/boin303-211130.i tt-bem-pat-event-trib-dfe}
{inbo/boin303-110750.i tt-tit-acr-event-trib-dfe}  

def new global shared var v_cod_usuar_corren as CHARACTER format "x(12)" no-undo.
def var hBOEspecifica as handle no-undo.
DEF VAR hdlDBOEms5 AS HANDLE NO-UNDO.
DEF VAR hDboAcr AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt_tit_acr_event_trib_dfe_aux LIKE tt_tit_acr_event_trib_dfe.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/*************************  Function Prototypes ********************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValidaFormatoVersao DBOProgram 
FUNCTION fnValidaFormatoVersao RETURNS LOGICAL
  (INPUT codVersao AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE dVersao AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE lValida  AS LOGICAL   NO-UNDO.

    
    ASSIGN
        lValida = TRUE
        dVersao = DECIMAL(codVersao) NO-ERROR.

    /* Se n∆o conseguir converter para decimal, j† Ç inv†lido */
    IF ERROR-STATUS:ERROR THEN
        lValida = FALSE.

    IF lValida THEN DO:
        IF LENGTH(codVersao) <> 4 THEN
            lValida = FALSE.
        ELSE IF INDEX(codVersao, ".") <> 2 THEN
            lValida = FALSE.

        ELSE IF NUM-ENTRIES(codVersao, ".") <> 2 THEN
            lValida = FALSE.
    END.

    RETURN lValida. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnExisteListaEventoTributo DBOProgram 
FUNCTION fnExisteListaEventoTributo RETURNS LOGICAL
  (INPUT listaEventoTributo AS CHAR) :
    DEFINE VARIABLE oEventoTributosList   AS cdp.list.EventoTributosList   NO-UNDO.
    oEventoTributosList = new cdp.list.EventoTributosList().

    RETURN oEventoTributosList:existe(listaEventoTributo).

    FINALLY:
        DELETE OBJECT oEventoTributosList NO-ERROR. 
    END FINALLY.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
          
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnExisteListaModuloOrigem DBOProgram 
FUNCTION fnExisteListaModuloOrigem RETURNS LOGICAL
  (INPUT moduloOrigem AS CHAR) :
    DEFINE VARIABLE oModuloOrigEventoList   AS cdp.list.ModuloOrigEventoList   NO-UNDO. 
    oModuloOrigEventoList = new cdp.list.ModuloOrigEventoList().
     
    RETURN oModuloOrigEventoList:existe(moduloOrigem).

    FINALLY:
        DELETE OBJECT oModuloOrigEventoList NO-ERROR. 
    END FINALLY.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnExisteListaTipoDfe DBOProgram 
FUNCTION fnExisteListaTipoDfe RETURNS LOGICAL
  (INPUT tipoDfe AS INTEGER) :
    DEFINE VARIABLE oTipoDfeList   AS cdp.list.TipoDfeList   NO-UNDO.
    oTipoDfeList = new cdp.list.TipoDfeList().

    RETURN oTipoDfeList:existe(tipoDfe).

    FINALLY:
        DELETE OBJECT oTipoDfeList NO-ERROR. 
    END FINALLY.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnExisteListaTipoAutor DBOProgram 
FUNCTION fnExisteListaTipoAutor RETURNS LOGICAL
  (INPUT tipoAutor AS INTEGER) :
    DEFINE VARIABLE oTipoAutorList   AS cdp.list.TipoAutorEventoList   NO-UNDO. 
    oTipoAutorList = new cdp.list.TipoAutorEventoList().
 

    RETURN oTipoAutorList:existe(tipoAutor).

    FINALLY:
        DELETE OBJECT oTipoAutorList NO-ERROR. 
    END FINALLY.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
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
        WHEN "cod-chave-aces-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-chave-aces-nf-eletro.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-evento":U THEN ASSIGN pFieldValue = RowObject.cod-evento.
        WHEN "cod-evento-a-canc":U THEN ASSIGN pFieldValue = RowObject.cod-evento-a-canc.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-protoc-a-canc":U THEN ASSIGN pFieldValue = RowObject.cod-protoc-a-canc.
        WHEN "cod-protocolo":U THEN ASSIGN pFieldValue = RowObject.cod-protocolo.
        WHEN "cod-protocolo-canc":U THEN ASSIGN pFieldValue = RowObject.cod-protocolo-canc.
        WHEN "cod-usuario-envio":U THEN ASSIGN pFieldValue = RowObject.cod-usuario-envio.
        WHEN "cod-usuario-inclusao":U THEN ASSIGN pFieldValue = RowObject.cod-usuario-inclusao.
        WHEN "cod-usuario-retorno":U THEN ASSIGN pFieldValue = RowObject.cod-usuario-retorno.
        WHEN "cod-versao-evento":U THEN ASSIGN pFieldValue = RowObject.cod-versao-evento.
        WHEN "modulo-orig-info":U THEN ASSIGN pFieldValue = RowObject.modulo-orig-info.
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
        WHEN "dt-emissao-docto":U THEN ASSIGN pFieldValue = RowObject.dt-emissao-docto.
        WHEN "dt-prev-entrega":U THEN ASSIGN pFieldValue = RowObject.dt-prev-entrega.
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
        WHEN "dec-livre-1":U THEN ASSIGN pFieldValue = RowObject.dec-livre-1.
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
        WHEN "idi-ind-aceitacao":U THEN ASSIGN pFieldValue = RowObject.idi-ind-aceitacao.
        WHEN "idi-ind-quitacao":U THEN ASSIGN pFieldValue = RowObject.idi-ind-quitacao.
        WHEN "idi-sit-evento":U THEN ASSIGN pFieldValue = RowObject.idi-sit-evento.
        WHEN "idi-tip-autor":U THEN ASSIGN pFieldValue = RowObject.idi-tip-autor.
        WHEN "idi-tip-dfe":U THEN ASSIGN pFieldValue = RowObject.idi-tip-dfe.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescIdiField DBOProgram
PROCEDURE getDescIdiField :
/*------------------------------------------------------------------------------
    Purpose:     Retorna descriá∆o de campos do tipo idi
    Parameters:
                             recebe nome do campo
                             retorna descriá∆o do campo idi
    Notes:       Os atalhos de compilaá∆o do EMS5 n∆o possuem a estrutura de programas
                             do EMS2 no propath. Dessa forma n∆o Ç poss°vel utilizar as classes do
                             EMS2 para buscar as descriá‰es. Por esse motivo foi criada essa procedure
                             na BO.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    DEF VAR oIdiFieldList AS cdp.list.ListaFixa NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject then
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "idi-ind-aceitacao":U THEN do:
            assign oIdiFieldList = new cdp.list.IndicadorAceitacaoList()
                   pFieldValue   = oIdiFieldList:getDescricao(RowObject.idi-ind-aceitacao).
        end.
        WHEN "idi-ind-quitacao":U THEN do:
            assign oIdiFieldList = new cdp.list.IndicadorQuitacaoList()
                   pFieldValue   = oIdiFieldList:getDescricao(RowObject.idi-ind-quitacao).
        end.
        WHEN "idi-sit-evento":U THEN do:
            assign oIdiFieldList = new cdp.list.SituacaoEventoTributosList()
                   pFieldValue   = oIdiFieldList:getDescricao(RowObject.idi-sit-evento).
        end.
        WHEN "idi-tip-autor":U THEN do:
            assign oIdiFieldList = new cdp.list.TipoAutorEventoList()
                   pFieldValue   = oIdiFieldList:getDescricao(RowObject.idi-tip-autor).
        end.
        WHEN "idi-tip-dfe":U THEN do:
            assign oIdiFieldList = new cdp.list.TipoDfeList()
                   pFieldValue   = oIdiFieldList:getDescricao(RowObject.idi-tip-dfe).
        end.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.

    FINALLY:
        DELETE OBJECT oIdiFieldList NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getListIdiField DBOProgram
PROCEDURE getListIdiField :
/*------------------------------------------------------------------------------
    Purpose:     Retorna lista de opá‰es de campos do tipo idi
    Parameters:
                             recebe nome do campo
                             retorna lista de opá‰es do campo idi
    Notes:       Os atalhos de compilaá∆o do EMS5 n∆o possuem a estrutura de programas
                             do EMS2 no propath. Dessa forma n∆o Ç poss°vel utilizar as classes do
                             EMS2 para buscar as descriá‰es. Por esse motivo foi criada essa procedure
                             na BO.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    DEF VAR oIdiFieldList AS cdp.list.ListaFixa NO-UNDO.

    CASE pFieldName:
        WHEN "idi-ind-aceitacao":U then assign oIdiFieldList = new cdp.list.IndicadorAceitacaoList().
        WHEN "idi-ind-quitacao":U then assign oIdiFieldList = new cdp.list.IndicadorQuitacaoList().
        WHEN "idi-sit-evento":U then assign oIdiFieldList = new cdp.list.SituacaoEventoTributosList().
        WHEN "idi-tip-autor":U then assign oIdiFieldList = new cdp.list.TipoAutorEventoList().
        WHEN "idi-tip-dfe":U then assign oIdiFieldList = new cdp.list.TipoDfeList().
        OTHERWISE RETURN "NOK":U.
    END CASE.

    assign pFieldValue = oIdiFieldList:getLista().

    RETURN "OK":U.

    FINALLY:
        DELETE OBJECT oIdiFieldList NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ?ndice primary-unique
  Parameters:  
               retorna valor do campo cod-chave-aces-nf-eletro
               retorna valor do campo cod-evento
               retorna valor do campo seq-evento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-chave-aces-nf-eletro LIKE evento-trib-dfe.cod-chave-aces-nf-eletro NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-evento LIKE evento-trib-dfe.cod-evento NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-evento LIKE evento-trib-dfe.seq-evento NO-UNDO.

        /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
            retornada flag "NOK":U ---*/
        IF NOT AVAILABLE RowObject THEN 
         RETURN "NOK":U.

    ASSIGN pcod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
           pcod-evento = RowObject.cod-evento
           pseq-evento = RowObject.seq-evento.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram  
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l?gico
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
        WHEN "log-gerac-auto":U THEN ASSIGN pFieldValue = RowObject.log-gerac-auto.
        WHEN "log-tp-gerac":U THEN ASSIGN pFieldValue = RowObject.log-tp-gerac.
        WHEN "log-livre-1":U THEN ASSIGN pFieldValue = RowObject.log-livre-1.
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
  Purpose:     Reposiciona registro com base no ?ndice primary-unique
  Parameters:  
               recebe valor do campo cod-chave-aces-nf-eletro
               recebe valor do campo cod-evento
               recebe valor do campo seq-evento
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-chave-aces-nf-eletro LIKE evento-trib-dfe.cod-chave-aces-nf-eletro NO-UNDO.
    DEFINE INPUT PARAMETER pcod-evento LIKE evento-trib-dfe.cod-evento NO-UNDO.
    DEFINE INPUT PARAMETER pseq-evento LIKE evento-trib-dfe.seq-evento NO-UNDO.

    FIND FIRST bfevento-trib-dfe WHERE 
        bfevento-trib-dfe.cod-chave-aces-nf-eletro = pcod-chave-aces-nf-eletro AND 
        bfevento-trib-dfe.cod-evento = pcod-evento AND 
        bfevento-trib-dfe.seq-evento = pseq-evento NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser? retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfevento-trib-dfe THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav?s de rowid e verifica a ocorr?ncia de erros, caso
          existam erros ser? retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfevento-trib-dfe)).
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
   OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

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
    
    DEFINE VAR h-boin306 AS HANDLE NO-UNDO.
    DEFINE VAR cListModulos AS CHAR NO-UNDO.
    DEFINE VAR cModuloOrigDefault AS CHAR NO-UNDO.
    
        /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
            executadas ---*/
        /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
        /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
            include: method/svc/errors/inserr.i ---*/
        /*:T--- Inclua aqui as validaá‰es ---*/
    CASE pType:
        WHEN "Create":U OR WHEN "Update":U THEN DO:
            IF pType = "Create":U THEN DO:
                /*:T--- Validaá∆o espec°fica para Create ---*/
                /*:T--- Verifica se o registro j? existe, caso exista, retorna erro ---*/
                IF can-find(first bf{&TableName}
                            where bf{&TableName}.cod-chave-aces-nf-eletro  = RowObject.cod-chave-aces-nf-eletro
                              and bf{&TableName}.cod-evento                = RowObject.cod-evento
                              and bf{&TableName}.seq-evento                = RowObject.seq-evento) then do:
                    {utp/ut-liter.i "Evento_tributos" * }
                    {method/svc/errors/inserr.i &ErrorNumber=7
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="RETURN-VALUE"}
                end.
            END.
            IF RowObject.seq-evento > 99 THEN DO:                
                {method/svc/errors/inserr.i &ErrorNumber="58228"
                                                    &ErrorType="EMS"
                                                    &ErrorSubType="ERROR"
                                            &ErrorParameters=RowObject.cod-chave-aces-nf-eletro}
            END.
            IF RowObject.cod-chave-aces-nf-eletro = "" OR
               RowObject.cod-chave-aces-nf-eletro = ? THEN DO:
                {utp/ut-liter.i Chave_acesso * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:
                CASE RowObject.idi-tip-dfe:
                    WHEN 1 THEN DO: //NF-e
                        IF LENGTH(RowObject.cod-chave-aces-nf-eletro) <> 44 THEN DO:
                            {utp/ut-liter.i Chave_de_acesso_da_NF-e * }
                            {method/svc/errors/inserr.i &ErrorNumber="54898"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="RETURN-VALUE + '~~~~44'"}
                        END.
                        IF SUBSTRING(RowObject.cod-chave-aces-nf-eletro,21,2) <> "55":U THEN DO:
                            {utp/ut-liter.i Posiá∆o_21_da_chave_de_acesso_da_NF-e * }
                            {method/svc/errors/inserr.i &ErrorNumber="29928"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="RETURN-VALUE + '~~~~55'"}
                        END.
                        IF  LENGTH(RowObject.cod-chave-aces-nf-eletro) = 44 
                        AND SUBSTRING(RowObject.cod-chave-aces-nf-eletro,21,2) = "55":U 
                        AND RowObject.modulo-orig-info = "MRE":U THEN DO:
                            
                            FIND FIRST docum-est NO-LOCK
                                WHERE docum-est.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro NO-ERROR.
                            IF NOT AVAIL docum-est THEN DO:
                               DEF VAR c-literal AS CHAR NO-UNDO.

                               {utp/ut-liter.i Chave_acesso * }
                               ASSIGN c-literal = RETURN-VALUE.
                               {utp/ut-liter.i recebimento * }
                               {method/svc/errors/inserr.i &ErrorNumber="58189"
                                                           &ErrorType="EMS"
                                                           &ErrorSubType="ERROR"
                                                           &ErrorParameters="c-literal + '~~~~' + RETURN-VALUE"}
                            END.
                        END.
                        IF RowObject.modulo-orig-info = "MFT" THEN DO:
                            /* valida se a nota fiscal recebida existe */
                            FIND FIRST nota-fiscal 
                                 WHERE nota-fiscal.cod-estabel = RowObject.cod-estabel
                                   AND nota-fiscal.serie       = RowObject.serie-docto
                                   AND nota-fiscal.nr-nota-fis = RowObject.nro-docto NO-LOCK NO-ERROR.
                            
                            IF AVAIL nota-fiscal THEN DO:
                                /* nota existe, valida se a chave de acesso recebida ? da nota */
                                IF nota-fiscal.cod-chave-aces-nf-eletro <> RowObject.cod-chave-aces-nf-eletro THEN
                                    {method/svc/errors/inserr.i &ErrorNumber="53100"
                                                           &ErrorType="EMS"
                                                           &ErrorSubType="ERROR"}
                            END.
                            ELSE
                                {method/svc/errors/inserr.i &ErrorNumber="3084"
                                                           &ErrorType="EMS"
                                                           &ErrorSubType="ERROR"}
                        END.
                    END.
                  /*  WHEN 2 THEN DO: //CT-e
                        IF LENGTH(RowObject.cod-chave-aces-nf-eletro) <> 44 THEN DO:
                            {utp/ut-liter.i Chave_de_acesso_do_CT-e * }
                            {method/svc/errors/inserr.i &ErrorNumber="54898"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="RETURN-VALUE + '~~~~44'"}
                        END.
                        IF SUBSTRING(RowObject.cod-chave-aces-nf-eletro,21,2) <> "57":U THEN DO:
                            {utp/ut-liter.i Posiá∆o_21_da_chave_de_acesso_do_CT-e * }
                            {method/svc/errors/inserr.i &ErrorNumber="29928"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="RETURN-VALUE + '~~~~57'"}
                        END.
                    END.
                    WHEN 3 THEN DO: //NFS-e
                        IF LENGTH(RowObject.cod-chave-aces-nf-eletro) > 60 THEN DO:
                            {utp/ut-liter.i Chave_acesso_NFS-e * }
                            {method/svc/errors/inserr.i &ErrorNumber="57359"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="RETURN-VALUE + '~~~~60'"}
                        END.
                    END. */
                    OTHERWISE DO:                        
                        IF LENGTH(RowObject.cod-chave-aces-nf-eletro) <> 44 THEN DO:
                            {utp/ut-liter.i Chave_de_acesso_da_NF-e * }
                            {method/svc/errors/inserr.i &ErrorNumber="54898"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="RETURN-VALUE + '~~~~44'"}
                        END.
                        IF SUBSTRING(RowObject.cod-chave-aces-nf-eletro,21,2) <> "55":U THEN DO:
                            {utp/ut-liter.i Posiá∆o_21_da_chave_de_acesso_da_NF-e * }
                            {method/svc/errors/inserr.i &ErrorNumber="29928"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="RETURN-VALUE + '~~~~55'"}
                        END.

                        IF RowObject.idi-tip-dfe = 0 OR RowObject.idi-tip-dfe = ? THEN DO:
                            {utp/ut-liter.i Tipo_DFE * }
                            {method/svc/errors/inserr.i &ErrorNumber="56274"
                                                        &ErrorType="EMS"
                                                        &ErrorSubType="ERROR"
                                                        &ErrorParameters="RETURN-VALUE"}
                        END.
                    END.
                END CASE.
            END.
            IF RowObject.cod-evento = "" OR
               RowObject.cod-evento = ? THEN DO:
                {utp/ut-liter.i Evento * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:
                IF fnExisteListaEventoTributo(RowObject.cod-evento) = NO THEN DO:
                    {utp/ut-liter.i Evento * }
                    {method/svc/errors/inserr.i &ErrorNumber="2"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="RETURN-VALUE"}
                      
                END.
                
            END.
                        
            IF RowObject.cod-estabel = "" OR
               RowObject.cod-estabel = ? THEN DO:
                {utp/ut-liter.i Estabelecimento * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:
                IF NOT CAN-FIND (FIRST estabelec NO-LOCK
                                 WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
                   {utp/ut-liter.i Estabelecimento * }
                   {method/svc/errors/inserr.i &ErrorNumber="2"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="RETURN-VALUE"} 
                END.
            END.
            
            
            IF  RowObject.cod-emitente <> 0
            AND RowObject.cod-emitente <> ? THEN DO:
                IF NOT CAN-FIND (FIRST emitente NO-LOCK
                                 WHERE emitente.cod-emitente = RowObject.cod-emitente) THEN DO:
                   {utp/ut-liter.i Emitente * }
                   {method/svc/errors/inserr.i &ErrorNumber="2"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="RETURN-VALUE"} 
                END.
            END.
            
            IF RowObject.cod-versao-evento = "" OR
               RowObject.cod-versao-evento = ? THEN DO:
                {utp/ut-liter.i Vers?o_do_evento * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:
                IF fnValidaFormatoVersao(RowObject.cod-versao-evento) = FALSE THEN DO:
                    {utp/ut-liter.i Vers?o_do_evento * }
                    {method/svc/errors/inserr.i &ErrorNumber="15451"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="RETURN-VALUE"}
                END.
                
            END.
            IF  RowObject.idi-tip-dfe <> 0
            AND RowObject.idi-tip-dfe <> ? THEN  DO:
                IF fnExisteListaTipoDfe(RowObject.idi-tip-dfe) = NO THEN DO:
                   {utp/ut-liter.i tipo_DFE * }
                   {method/svc/errors/inserr.i &ErrorNumber="2"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="RETURN-VALUE"}
                END.
            END.
            
            IF  RowObject.modulo-orig-info <> ""
            AND RowObject.modulo-orig-info <> ? THEN DO:
                
                IF fnExisteListaModuloOrigem(RowObject.modulo-orig-info) = NO THEN DO:   
                   {utp/ut-liter.i m?dulo_origem_do_evento * }
                   {method/svc/errors/inserr.i &ErrorNumber="2"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="RETURN-VALUE"}
                END.
                ELSE DO:
                    IF  fnExisteListaEventoTributo(RowObject.cod-evento) = YES
                    AND fnExisteListaTipoDfe(RowObject.idi-tip-dfe)      = YES
                    AND CAN-FIND (FIRST estabelec NO-LOCK
                                  WHERE estabelec.cod-estabel = RowObject.cod-estabel) THEN DO:
                        RUN inbo/boin306.p PERSISTENT SET h-boin306.
                        RUN getModulosDefault IN h-boin306 (INPUT RowObject.cod-estabel, 
                                                            INPUT RowObject.cod-evento, 
                                                            INPUT RowObject.idi-tip-dfe, 
                                                            OUTPUT cListModulos, 
                                                            OUTPUT cModuloOrigDefault).   
                            
                        IF NOT CAN-DO(cListModulos, STRING(RowObject.modulo-orig-info)) THEN DO: 
                           {method/svc/errors/inserr.i &ErrorNumber="58172"
                                                       &ErrorType="EMS"
                                                       &ErrorSubType="ERROR"
                                                       &ErrorParameters="RowObject.cod-evento + '~~~~' + cListModulos"}
                                                                        
                        END.
                    END.
                END.
            END.
            ELSE DO:
                {utp/ut-liter.i m?dulo_origem_do_evento * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            
            IF RowObject.idi-tip-autor = 0 OR
               RowObject.idi-tip-autor = ? THEN DO:
                {utp/ut-liter.i Tipo_autor * }
                {method/svc/errors/inserr.i &ErrorNumber="56274"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="RETURN-VALUE"}
            END.
            ELSE DO:
                IF fnExisteListaTipoAutor(RowObject.idi-tip-autor) = NO THEN DO:   
                   {utp/ut-liter.i Tipo_autor * }
                   {method/svc/errors/inserr.i &ErrorNumber="2"
                                               &ErrorType="EMS"
                                               &ErrorSubType="ERROR"
                                               &ErrorParameters="RETURN-VALUE"}
                END.
            END.
        END.
        WHEN "Delete":U THEN DO:
            IF CAN-DO("2,3,5":U, STRING(RowObject.idi-sit-evento)) THEN DO:
                DEF VAR oSituacaoEventosList  AS cdp.list.SituacaoEventoTributosList  NO-UNDO.
                DEF VAR c-literal-aux AS CHAR NO-UNDO.
                oSituacaoEventosList = new cdp.list.SituacaoEventoTributosList().

                {utp/ut-liter.i evento * }
                ASSIGN c-literal-aux = RETURN-VALUE + " (" + oSituacaoEventosList:getDescricao(RowObject.idi-sit-evento) + ") ".
                {utp/ut-liter.i exclus?o * }
                {method/svc/errors/inserr.i &ErrorNumber="19194"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-literal-aux + '~~~~' + RETURN-VALUE"}
                DELETE OBJECT oSituacaoEventosList NO-ERROR.
            END.
        END.
    END CASE.

    RUN carregaHandleEspecifico (INPUT RowObject.modulo-orig-info,
                                 INPUT "validateRecord").
    IF RETURN-VALUE = "OK":U THEN DO:
        //Vai rodar o validateRecord espec?fico por m?dulo 
        RUN validateRecord IN hBOEspecifica (INPUT pType,
                                             INPUT TABLE RowObject,
                                             INPUT TABLE tt-evento-trib-dfe-item,
                                             OUTPUT TABLE RowErrors APPEND).
    END.
    DELETE PROCEDURE hBOEspecifica NO-ERROR.

    RUN carregaHandleEspecifico (INPUT RowObject.cod-evento,
                                 INPUT "validateRecord").
    IF RETURN-VALUE = "OK":U THEN DO:
        //Vai rodar o validateRecord espec?fico por evento 
        RUN validateRecord IN hBOEspecifica (INPUT pType,
                                             INPUT TABLE RowObject,
                                             INPUT TABLE tt-evento-trib-dfe-item,
                                             OUTPUT TABLE RowErrors APPEND).
    END.
    DELETE PROCEDURE hBOEspecifica NO-ERROR.

    /*:T--- Verifica ocorr?ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    FINALLY:
        IF VALID-HANDLE(h-boin306) THEN DO:
            DELETE PROCEDURE h-boin306 NO-ERROR.
            ASSIGN h-boin306 = ?.
        END.

    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord:
    DEFINE VARIABLE iSequencia AS INT INIT 1 NO-UNDO.

    IF RowObject.seq-evento = ? OR RowObject.seq-evento = 0 THEN DO:
        // Sugere a pr?xima sequ?ncia somente se a sequ?ncia enviada for zero
        FOR LAST bf{&TableName} NO-LOCK
           WHERE bf{&TableName}.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
             AND bf{&TableName}.cod-evento               = RowObject.cod-evento: 
            ASSIGN iSequencia = bf{&TableName}.seq-evento + 1.
        END.
        ASSIGN RowObject.seq-evento = iSequencia.
    END.

    IF RowObject.modulo-orig-info <> ? OR RowObject.modulo-orig-info <> "" THEN DO:
        /* se enviado via postman o m¢dulo de origem em min£sculo, ao consultar a informaá∆o na tela html n∆o Ç apresentada a informaá∆o */
           ASSIGN  RowObject.modulo-orig-info = UPPER( RowObject.modulo-orig-info). 
    END.
    
    IF (RowObject.nro-docto = "" OR RowObject.nro-docto = ?)
    AND SUBSTRING(RowObject.cod-chave-aces-nf-eletro,26,9)  <> "" 
    AND SUBSTRING(RowObject.cod-chave-aces-nf-eletro,26,9) <> ? THEN    
       ASSIGN RowObject.nro-docto = STRING(INT(SUBSTRING(RowObject.cod-chave-aces-nf-eletro,26,9)), ">>9999999").
       
    IF  (RowObject.serie-docto = "" OR RowObject.serie-docto = ?)
    AND SUBSTRING(RowObject.cod-chave-aces-nf-eletro,23,3) <> "" 
    AND SUBSTRING(RowObject.cod-chave-aces-nf-eletro,23,3) <> ? THEN       
      ASSIGN  RowObject.serie-docto = STRING(INT(SUBSTRING(RowObject.cod-chave-aces-nf-eletro,23,3))).
      
    // Atualizando chave do evento nos itens
    FOR EACH tt-evento-trib-dfe-item: 
        IF tt-evento-trib-dfe-item.cod-chave-aces-nf-eletro = "" OR tt-evento-trib-dfe-item.cod-chave-aces-nf-eletro = ? THEN
            ASSIGN tt-evento-trib-dfe-item.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro.

        IF tt-evento-trib-dfe-item.cod-evento = "" OR tt-evento-trib-dfe-item.cod-evento = ? THEN
            ASSIGN tt-evento-trib-dfe-item.cod-evento = RowObject.cod-evento.

        ASSIGN tt-evento-trib-dfe-item.seq-evento = RowObject.seq-evento.
        
        IF RowObject.cod-evento = '211130' THEN DO:
           FOR EACH tt-bem-pat-event-trib-dfe:
               ASSIGN tt-bem-pat-event-trib-dfe.num_seq_event = RowObject.seq-evento. 
                
           END.            
        END.
    END.

    IF RowObject.cod-usuario-inclusao = ? OR RowObject.cod-usuario-inclusao = "" THEN
        ASSIGN RowObject.cod-usuario-inclusao = v_cod_usuar_corren.
           
    ASSIGN RowObject.dtm-inclusao        = NOW
           RowObject.dtm-envio           = ?
           RowObject.dtm-retorno         = ?
           RowObject.idi-sit-evento      = 1 // N?o enviado
           RowObject.cod-usuario-envio   = ''
           RowObject.cod-usuario-retorno = ''
           RowObject.cod-protocolo       = ''
           RowObject.cod-protocolo-canc  = ''
           .

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord:

    FOR FIRST bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
          AND bf{&TableName}.cod-evento               = RowObject.cod-evento
          AND bf{&TableName}.seq-evento               = RowObject.seq-evento:

        // N∆o dever† atualizar esses campos via update da BO e sim via procedures espec°ficas. 
        ASSIGN RowObject.dtm-inclusao         = bf{&TableName}.dtm-inclusao
               RowObject.dtm-envio            = bf{&TableName}.dtm-envio
               RowObject.dtm-retorno          = bf{&TableName}.dtm-retorno
               RowObject.cod-usuario-inclusao = bf{&TableName}.cod-usuario-inclusao
               RowObject.cod-usuario-envio    = bf{&TableName}.cod-usuario-envio
               RowObject.idi-sit-evento       = bf{&TableName}.idi-sit-evento
               RowObject.cod-protocolo        = bf{&TableName}.cod-protocolo
               RowObject.cod-protocolo-canc   = bf{&TableName}.cod-protocolo-canc
             RowObject.log-gerac-auto       = NO. //em caso de update, a geraá∆o deixa de ser autom†tica
               
         //Alteraá∆o para que n∆o altere o n£mero do documento e sÇrie quando vier via postman       
        ASSIGN RowObject.nro-docto            = bf{&TableName}.nro-docto
               RowObject.serie-docto          = bf{&TableName}.serie-docto.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord:

    RUN createItems.
    RUN createFila. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord:

    RUN deleteItems.
    RUN createItems.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord:
        
    RUN deleteItems.
    RUN deleteMessages.
    RUN deleteFila. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaHandleEspecifico DBOProgram
PROCEDURE carregaHandleEspecifico PRIVATE:
    DEFINE INPUT  PARAM cCodEventoOuModulo AS CHAR NO-UNDO.
    DEFINE INPUT  PARAM cProcedureInterna AS CHAR NO-UNDO.

    IF SEARCH ("inbo/boin303-" + cCodEventoOuModulo + ".r") <> ? THEN DO:
        RUN VALUE("inbo/boin303-" + cCodEventoOuModulo + ".r") PERSISTENT SET hBOEspecifica.
        IF LOOKUP(cProcedureInterna, hBOEspecifica:INTERNAL-ENTRIES) <> 0 THEN DO: /* Existe a procedure interna no programa! */
            RETURN "OK":U.
        END.
        DELETE PROCEDURE hBOEspecifica NO-ERROR.
    END.
    RETURN "NOK":U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItems DBOProgram 
PROCEDURE createItems:
    
    //Criar os itens
    FOR EACH tt-evento-trib-dfe-item
       WHERE tt-evento-trib-dfe-item.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
         AND tt-evento-trib-dfe-item.cod-evento               = RowObject.cod-evento
         AND tt-evento-trib-dfe-item.seq-evento               = RowObject.seq-evento: 
        CREATE evento-trib-dfe-item.
        BUFFER-COPY tt-evento-trib-dfe-item TO evento-trib-dfe-item.
        
        /*evento 211130*/
        IF RowObject.cod-evento = "211130" THEN DO:
            IF  NOT VALID-HANDLE(hdlDBOEms5) THEN
                RUN prgfin/fas/fas929za.py PERSISTENT SET hdlDBOEms5.
                
            RUN pi_grava_bem_pat_event_trib_dfe IN hdlDBOEms5 (INPUT TABLE tt-bem-pat-event-trib-dfe, 
                                                                INPUT RowObject.cod-chave-aces-nf-eletro,
                                                                INPUT RowObject.cod-evento,
                                                                INPUT RowObject.seq-evento,
                                                                INPUT tt-evento-trib-dfe-item.seq-item-nf) .
            IF  VALID-HANDLE(hdlDBOEms5) THEN
                DELETE PROCEDURE hdlDBOEms5 NO-ERROR.
        END.
    END.
    RELEASE evento-trib-dfe-item.
    
    /*evento 110750 - Inclus?o dos Pagamentos*/
    IF RowObject.cod-evento = "110750":U THEN DO:
        
        RUN prgfin/acr/acr936wu.py PERSISTENT SET hDboAcr NO-ERROR.
        
        IF VALID-HANDLE(hDboAcr) THEN DO:

            FOR EACH tt_tit_acr_event_trib_dfe:
                
                RUN emptyRowErrors  IN hDboAcr.
                RUN emptyRowObject  IN hDboAcr.
                RUN openQueryStatic IN hDboAcr (INPUT 'main':U).
                
                RUN gotoKey IN hDboAcr (INPUT tt_tit_acr_event_trib_dfe.cod_chave_aces_docto_fisc, 
                                        INPUT tt_tit_acr_event_trib_dfe.cod_evento, 
                                        INPUT tt_tit_acr_event_trib_dfe.num_seq_event, 
                                        INPUT tt_tit_acr_event_trib_dfe.num_seq_pagto). 

                IF RETURN-VALUE = "NOK":U THEN DO:

                EMPTY TEMP-TABLE tt_tit_acr_event_trib_dfe_aux.
                CREATE tt_tit_acr_event_trib_dfe_aux.
                BUFFER-COPY tt_tit_acr_event_trib_dfe TO tt_tit_acr_event_trib_dfe_aux.    
                    
                    ASSIGN tt_tit_acr_event_trib_dfe_aux.cod_chave_aces_docto_fisc = RowObject.cod-chave-aces-nf-eletro
                           tt_tit_acr_event_trib_dfe_aux.cod_evento                = RowObject.cod-evento
                           tt_tit_acr_event_trib_dfe_aux.num_seq_event             = RowObject.seq-evento
                           tt_tit_acr_event_trib_dfe_aux.cod_estab                 = RowObject.cod-estabel
                           tt_tit_acr_event_trib_dfe_aux.cdn_cliente               = RowObject.cod-emitente.

                    FIND FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-ERROR.
                    IF AVAIL estabelec THEN DO:
                        ASSIGN tt_tit_acr_event_trib_dfe_aux.cod_empresa = estabelec.ep-codigo NO-ERROR.
                    END.
                   
                    RUN newRecord  IN hDboAcr.
                    RUN setRecord  IN hDboAcr (INPUT TABLE tt_tit_acr_event_trib_dfe_aux).
                    RUN createRecord IN hDboAcr.
                END.
            END.  
        END.
    END.
              
    RETURN "OK":U.
    
    FINALLY:
        IF VALID-HANDLE(hDboAcr) THEN
            DELETE PROCEDURE hDboAcr NO-ERROR.
    END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteItems DBOProgram 
PROCEDURE deleteItems:

    FOR EACH evento-trib-dfe-item EXCLUSIVE-LOCK
       WHERE evento-trib-dfe-item.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
         AND evento-trib-dfe-item.cod-evento               = RowObject.cod-evento
         AND evento-trib-dfe-item.seq-evento               = RowObject.seq-evento: 
                  
        IF evento-trib-dfe-item.cod-evento = '211130' THEN DO:
            IF  NOT VALID-HANDLE(hdlDBOEms5) THEN
                RUN prgfin/fas/fas929za.py PERSISTENT SET hdlDBOEms5.
                
            RUN pi_exclui_bem_pat_event_trib_dfe IN hdlDBOEms5 (INPUT RowObject.cod-chave-aces-nf-eletro,
                                                                INPUT RowObject.cod-evento,
                                                                INPUT RowObject.seq-evento,
                                                                INPUT evento-trib-dfe-item.seq-item-nf) .
            IF  VALID-HANDLE(hdlDBOEms5) THEN
                DELETE PROCEDURE hdlDBOEms5 NO-ERROR. 
        END.
        
        DELETE evento-trib-dfe-item.
    END.
    RELEASE evento-trib-dfe-item.
    
    /*evento 110750 - Excluir pagamentos*/
    IF RowObject.cod-evento = "110750" THEN DO:
        DEFINE VARIABLE hDboAcrDel AS HANDLE NO-UNDO.
        RUN prgfin/acr/acr936wu.py PERSISTENT SET hDboAcrDel NO-ERROR.
        
        IF VALID-HANDLE(hDboAcrDel) THEN DO:
            RUN setQueryWhere IN hDboAcrDel (INPUT "cod_chave_aces_docto_fisc = '" + RowObject.cod-chave-aces-nf-eletro + "' AND cod_evento = '" + RowObject.cod-evento + "' AND num_seq_event = " + STRING(RowObject.seq-evento)).
            RUN openQueryDynamic IN hDboAcrDel.
            RUN getFirst IN hDboAcrDel.
            
            DO WHILE RETURN-VALUE = "OK":
                RUN deleteRecord IN hDboAcrDel.
                RUN getNext IN hDboAcrDel.
            END.
            DELETE PROCEDURE hDboAcrDel NO-ERROR.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteMessages DBOProgram 
PROCEDURE deleteMessages:

    FOR EACH evento-trib-dfe-msg EXCLUSIVE-LOCK
       WHERE evento-trib-dfe-msg.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
         AND evento-trib-dfe-msg.cod-evento               = RowObject.cod-evento
         AND evento-trib-dfe-msg.seq-evento               = RowObject.seq-evento: 
        DELETE evento-trib-dfe-msg.
    END.
    RELEASE evento-trib-dfe-msg.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createFila DBOProgram 
PROCEDURE createFila:

    //Criar o evento na fila
    FIND FIRST evento-trib-fila NO-LOCK 
        WHERE evento-trib-fila.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
        AND   evento-trib-fila.cod-evento               = RowObject.cod-evento
        AND   evento-trib-fila.seq-evento               = RowObject.seq-evento NO-ERROR. 
    IF NOT AVAIL evento-trib-fila THEN DO:     
        CREATE evento-trib-fila.
        ASSIGN evento-trib-fila.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
               evento-trib-fila.cod-evento               = RowObject.cod-evento
               evento-trib-fila.seq-evento               = RowObject.seq-evento
               evento-trib-fila.idi-sit-evento           = RowObject.idi-sit-evento
               evento-trib-fila.seq-sefaz                = RowObject.seq-evento. 
    END.
    
    RELEASE evento-trib-fila.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteItems DBOProgram 
PROCEDURE deleteFila:

    FOR EACH evento-trib-fila EXCLUSIVE-LOCK 
        WHERE evento-trib-fila.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
        AND   evento-trib-fila.cod-evento               = RowObject.cod-evento
        AND   evento-trib-fila.seq-evento               = RowObject.seq-evento:     
        DELETE evento-trib-fila.
    END.
    RELEASE evento-trib-fila.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTEventoTribDfeItem DBOProgram
PROCEDURE setTTEventoTribDfeItem:
    DEFINE INPUT  PARAM TABLE FOR tt-evento-trib-dfe-item.
    RETURN "NOK":U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criarEventoCancelamento DBOProgram
PROCEDURE criarEventoCancelamento:
    DEFINE INPUT  PARAMETER p-pkEvento-a-canc    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-mod-orig-info      AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-log-gerac-auto     AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-pkEventoCancCriado AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VAR c-versao-evento       AS CHAR INIT "1.00":U NO-UNDO.
    DEFINE VAR c-evento-cancelamento AS CHAR NO-UNDO. 
    DEFINE VAR h-boin306             AS HANDLE NO-UNDO.
    DEFINE VAR c-params-msg          AS CHAR NO-UNDO.

    RUN emptyRowErrors.

    RUN findEventoTribDfe (input p-pkEvento-a-canc, NO).
    IF RETURN-VALUE = "NOK":U THEN DO:
        RETURN "NOK":U.
    END.

    IF evento-trib-dfe.idi-sit-evento <> 3 THEN DO: 
        {utp/ut-liter.i o_cancelamento *}
        c-params-msg = return-value.
        {utp/ut-liter.i Autorizado *}
        {method/svc/errors/inserr.i &ErrorNumber="58135"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-params-msg + '~~~~' + return-value + '~~~~' + p-pkEvento-a-canc"}
        RETURN "NOK":U.
    END.

    IF evento-trib-dfe.cod-evento = "110001":U OR evento-trib-dfe.cod-evento = "110751":U THEN DO: 
        {utp/ut-liter.i cancelar_um_evento_de_cancelamento *}
        {method/svc/errors/inserr.i &ErrorNumber="33073"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="return-value"}
        RETURN "NOK":U.
    END.

    IF evento-trib-dfe.cod-evento = "110750":U THEN
        ASSIGN c-evento-cancelamento = "110751":U
               p-mod-orig-info = "ACR".
    ELSE
        ASSIGN c-evento-cancelamento = "110001":U.

    IF p-mod-orig-info = "" OR p-mod-orig-info = ? THEN
        ASSIGN p-mod-orig-info = "NINFO":U.
    IF p-log-gerac-auto = ? THEN
        ASSIGN p-log-gerac-auto = NO.

    EMPTY TEMP-TABLE tt-evento-trib-dfe.
    CREATE tt-evento-trib-dfe.
    BUFFER-COPY evento-trib-dfe TO tt-evento-trib-dfe.    
    
    ASSIGN tt-evento-trib-dfe.cod-evento               = c-evento-cancelamento 
           tt-evento-trib-dfe.seq-evento               = 0 // Ser† sugerido no beforeCreateRecord
           tt-evento-trib-dfe.cod-evento-a-canc        = evento-trib-dfe.cod-evento
           tt-evento-trib-dfe.cod-protoc-a-canc        = evento-trib-dfe.cod-protocolo
           tt-evento-trib-dfe.modulo-orig-info         = upper(p-mod-orig-info)
           tt-evento-trib-dfe.log-gerac-auto           = p-log-gerac-auto
           tt-evento-trib-dfe.idi-ind-aceitacao        = ?
           tt-evento-trib-dfe.idi-ind-quitacao         = ?
           tt-evento-trib-dfe.cod-usuario-inclusao     = v_cod_usuar_corren.

    RUN inbo/boin306.p PERSISTENT SET h-boin306.
    RUN openQueryStatic IN h-boin306 (INPUT 'Main':U).
    RUN posicionaRegistro IN h-boin306 (INPUT tt-evento-trib-dfe.cod-estabel,
                                        INPUT tt-evento-trib-dfe.cod-evento,
                                        INPUT tt-evento-trib-dfe.idi-tip-dfe).
    IF RETURN-VALUE = "OK":U THEN
        RUN getCharField IN h-boin306 (INPUT "cod-versao-evento":U,
                                       OUTPUT c-versao-evento).
           
    ASSIGN tt-evento-trib-dfe.cod-versao-evento = c-versao-evento.

    RUN openQueryStatic (INPUT "Main":U).
    RUN emptyRowErrors.          
    RUN setRecord (INPUT TABLE tt-evento-trib-dfe).
    RUN createRecord.

    IF RETURN-VALUE = "OK":U THEN DO:
    
        //Posicionar na tabela da fila para pegar a sequància da sefaz
        FIND FIRST evento-trib-fila NO-LOCK 
            WHERE evento-trib-fila.cod-chave-aces-nf-eletro = RowObject.cod-chave-aces-nf-eletro
            AND   evento-trib-fila.cod-evento               = RowObject.cod-evento
            AND   evento-trib-fila.seq-evento               = RowObject.seq-evento NO-ERROR. 
        
        IF AVAIL evento-trib-fila THEN ASSIGN p-pkEventoCancCriado = RowObject.cod-chave-aces-nf-eletro + "|" + c-evento-cancelamento + "|":U + STRING(evento-trib-fila.seq-sefaz).
        ELSE ASSIGN p-pkEventoCancCriado = RowObject.cod-chave-aces-nf-eletro + "|" + c-evento-cancelamento + "|":U + STRING(RowObject.seq-evento).
        
        //Foi criado um evento de cancelamento referente ao evento &1!
        {method/svc/errors/inserr.i &ErrorNumber="58142"
                                    &ErrorType="EMS"
                                    &ErrorSubType="INFORMATION"
                                    &ErrorParameters="p-pkEvento-a-canc"}
        RETURN "OK":U.
    END.
    RETURN "NOK":U.

    FINALLY:
        DELETE PROCEDURE h-boin306 NO-ERROR.
    END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEventoTribDfe DBOProgram
PROCEDURE findEventoTribDfe:
    DEFINE INPUT  PARAMETER p-pkEvento-a-canc       AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER l-exclusive-lock AS LOGICAL NO-UNDO.

    IF l-exclusive-lock THEN
        FOR FIRST evento-trib-dfe EXCLUSIVE-LOCK
            WHERE evento-trib-dfe.cod-chave-aces-nf-eletro = ENTRY(1, p-pkEvento-a-canc, "|":U)
              AND evento-trib-dfe.cod-evento                 = ENTRY(2, p-pkEvento-a-canc, "|":U)
              AND evento-trib-dfe.seq-evento                 = INTEGER(ENTRY(3, p-pkEvento-a-canc, "|":U)):
        END.
    ELSE
        FOR FIRST evento-trib-dfe NO-LOCK
            WHERE evento-trib-dfe.cod-chave-aces-nf-eletro = ENTRY(1, p-pkEvento-a-canc, "|":U)
              AND evento-trib-dfe.cod-evento                 = ENTRY(2, p-pkEvento-a-canc, "|":U)
              AND evento-trib-dfe.seq-evento                 = INTEGER(ENTRY(3, p-pkEvento-a-canc, "|":U)):
        END.

    IF NOT AVAIL evento-trib-dfe THEN DO:
        {utp/ut-liter.i Evento_n?o_encontrado} 
        RUN piCreateTechnicalError (RETURN-VALUE + ": ":U + p-pkEvento-a-canc).
        RETURN "NOK":U.
    END.
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTEventoTribDfeBensItem DBOProgram 
PROCEDURE setTTEventoTribDfeBensItem :
DEFINE INPUT  PARAM TABLE FOR tt-bem-pat-event-trib-dfe.
    RETURN "NOK":U.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTEventoTribDfeBensItem DBOProgram 
PROCEDURE getTTEventoTribDfeBensItem :
    DEFINE OUTPUT  PARAM TABLE FOR tt-bem-pat-event-trib-dfe.
    RETURN "NOK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTEventoTribDfePagto DBOProgram
PROCEDURE setTTEventoTribDfePagto:
    DEFINE INPUT PARAM TABLE FOR tt_tit_acr_event_trib_dfe.
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTEventoTribDfePagto DBOProgram
PROCEDURE getTTEventoTribDfePagto:
    DEFINE OUTPUT PARAM TABLE FOR tt_tit_acr_event_trib_dfe.
    RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
