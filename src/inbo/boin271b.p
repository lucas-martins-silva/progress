&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN271B 2.00.00.011 } /*** "010011" 27/10/2023 17:03:44  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin271b MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN271B
&GLOBAL-DEFINE DBOVersion   2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ord-prod
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */


/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/


/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin271b.i RowObject}

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var cItemIni      as char no-undo.
def var cItemFim      as char no-undo.
def var iOrdIni       as int  no-undo.
def var iOrdFim       as int  no-undo.
def var lNaoIniciadas as log  no-undo.
def var lLiberadas    as log  no-undo.
def var lAlocadas     as log  no-undo.
def var lSeparadas    as log  no-undo.
def var lRequisitadas as log  no-undo.
def var lIniciadas    as log  no-undo.

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
        WHEN "cd-planejado":U THEN ASSIGN pFieldValue = RowObject.cd-planejado.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estab-ctr":U THEN ASSIGN pFieldValue = RowObject.cod-estab-ctr.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-lista-compon":U THEN ASSIGN pFieldValue = RowObject.cod-lista-compon.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        WHEN "conta-despesa":U THEN ASSIGN pFieldValue = RowObject.conta-despesa.
        WHEN "conta-imob":U THEN ASSIGN pFieldValue = RowObject.conta-imob.
        WHEN "conta-ordem":U THEN ASSIGN pFieldValue = RowObject.conta-ordem.
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "ct-desp":U THEN ASSIGN pFieldValue = RowObject.ct-desp.
        WHEN "ct-imob":U THEN ASSIGN pFieldValue = RowObject.ct-imob.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "hr-efetiv-term":U THEN ASSIGN pFieldValue = RowObject.hr-efetiv-term.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "it-inspec":U THEN ASSIGN pFieldValue = RowObject.it-inspec.
        WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        WHEN "lote-serie":U THEN ASSIGN pFieldValue = RowObject.lote-serie.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedido":U THEN ASSIGN pFieldValue = RowObject.nr-pedido.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "sc-desp":U THEN ASSIGN pFieldValue = RowObject.sc-desp.
        WHEN "sc-imob":U THEN ASSIGN pFieldValue = RowObject.sc-imob.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "usuario-alt":U THEN ASSIGN pFieldValue = RowObject.usuario-alt.
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
        WHEN "data-alt":U THEN ASSIGN pFieldValue = RowObject.data-alt.
        WHEN "dt-efetiv-term":U THEN ASSIGN pFieldValue = RowObject.dt-efetiv-term.
        WHEN "dt-emissao":U THEN ASSIGN pFieldValue = RowObject.dt-emissao.
        WHEN "dt-inicio":U THEN ASSIGN pFieldValue = RowObject.dt-inicio.
        WHEN "dt-orig":U THEN ASSIGN pFieldValue = RowObject.dt-orig.
        WHEN "dt-termino":U THEN ASSIGN pFieldValue = RowObject.dt-termino.
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
        WHEN "qt-apr-cond":U THEN ASSIGN pFieldValue = RowObject.qt-apr-cond.
        WHEN "qt-inicial":U THEN ASSIGN pFieldValue = RowObject.qt-inicial.
        WHEN "qt-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-ordem.
        WHEN "qt-perda":U THEN ASSIGN pFieldValue = RowObject.qt-perda.
        WHEN "qt-produzida":U THEN ASSIGN pFieldValue = RowObject.qt-produzida.
        WHEN "qt-refugada":U THEN ASSIGN pFieldValue = RowObject.qt-refugada.
        WHEN "qt-reportada":U THEN ASSIGN pFieldValue = RowObject.qt-reportada.
        WHEN "qt-requisita":U THEN ASSIGN pFieldValue = RowObject.qt-requisita.
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
        WHEN "calc-cs-ggf":U THEN ASSIGN pFieldValue = RowObject.calc-cs-ggf.
        WHEN "calc-cs-mat":U THEN ASSIGN pFieldValue = RowObject.calc-cs-mat.
        WHEN "calc-cs-mob":U THEN ASSIGN pFieldValue = RowObject.calc-cs-mob.
        WHEN "cdn-orig-aps":U THEN ASSIGN pFieldValue = RowObject.cdn-orig-aps.
        WHEN "cod-gr-cli":U THEN ASSIGN pFieldValue = RowObject.cod-gr-cli.
        WHEN "custeio-prop-ggf":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-ggf.
        WHEN "custeio-prop-mat":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-mat.
        WHEN "custeio-prop-mob":U THEN ASSIGN pFieldValue = RowObject.custeio-prop-mob.
        WHEN "dest-manut":U THEN ASSIGN pFieldValue = RowObject.dest-manut.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-contrato-venda":U THEN ASSIGN pFieldValue = RowObject.nr-contrato-venda.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "nr-linha":U THEN ASSIGN pFieldValue = RowObject.nr-linha.
        WHEN "nr-ord-aber":U THEN ASSIGN pFieldValue = RowObject.nr-ord-aber.
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "nr-seq-contr-it":U THEN ASSIGN pFieldValue = RowObject.nr-seq-contr-it.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "nr-ult-seq":U THEN ASSIGN pFieldValue = RowObject.nr-ult-seq.
        WHEN "num-ord-inv":U THEN ASSIGN pFieldValue = RowObject.num-ord-inv.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "rep-prod":U THEN ASSIGN pFieldValue = RowObject.rep-prod.
        WHEN "reporte-ggf":U THEN ASSIGN pFieldValue = RowObject.reporte-ggf.
        WHEN "reporte-mob":U THEN ASSIGN pFieldValue = RowObject.reporte-mob.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "sit-aloc":U THEN ASSIGN pFieldValue = RowObject.sit-aloc.
        WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
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
               retorna valor do campo nr-ord-produ
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE ord-prod.nr-ord-produ NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ.

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
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "emite-ordem":U THEN ASSIGN pFieldValue = RowObject.emite-ordem.
        WHEN "emite-requis":U THEN ASSIGN pFieldValue = RowObject.emite-requis.
        WHEN "enc-mensal":U THEN ASSIGN pFieldValue = RowObject.enc-mensal.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "prod-repet":U THEN ASSIGN pFieldValue = RowObject.prod-repet.
        WHEN "prototipo":U THEN ASSIGN pFieldValue = RowObject.prototipo.
        WHEN "req-emitida":U THEN ASSIGN pFieldValue = RowObject.req-emitida.
        WHEN "val-per":U THEN ASSIGN pFieldValue = RowObject.val-per.
        WHEN "valorizada":U THEN ASSIGN pFieldValue = RowObject.valorizada.
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
               recebe valor do campo nr-ord-produ
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE ord-prod.nr-ord-produ NO-UNDO.

    FIND FIRST bford-prod WHERE 
        bford-prod.nr-ord-produ = pnr-ord-produ NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bford-prod THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bford-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryOrdServ DBOProgram 
PROCEDURE OpenQueryOrdServ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Seguranáa por Estabelecimento */
    &scoped-define KEY-PHRASE {&tablename}.estado <= 6 NO-LOCK
    &Scoped-define BY-ESTAB-IN by {&tablename}.nr-ord-produ

    &Scoped-define BY-ESTAB-AT by {&tablename}.cod-estabel ~
                               by {&tablename}.nr-ord-produ
    
    {include/i-estab-openquery.i}

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroItem DBOProgram 
PROCEDURE setConstraintFiltroItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pItemIni      as char no-undo.
def input param pItemFim      as char no-undo.
def input param pNaoIniciadas as log no-undo.
def input param pLiberadas    as log no-undo.
def input param pAlocadas     as log no-undo.
def input param pSeparadas    as log no-undo.
def input param pRequisitadas as log no-undo.
def input param pIniciadas    as log no-undo.

assign cItemIni      = pItemIni
       cItemFim      = pItemFim
       lNaoIniciadas = pNaoIniciadas
       lLiberadas    = pLiberadas
       lAlocadas     = pAlocadas
       lSeparadas    = pSeparadas
       lRequisitadas = pRequisitadas
       lIniciadas    = pIniciadas.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroOrdem DBOProgram 
PROCEDURE setConstraintFiltroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pOrdIni       as int no-undo.
def input param pOrdFim       as int no-undo.
def input param pNaoIniciadas as log no-undo.
def input param pLiberadas    as log no-undo.
def input param pAlocadas     as log no-undo.
def input param pSeparadas    as log no-undo.
def input param pRequisitadas as log no-undo.
def input param pIniciadas    as log no-undo.

assign iOrdIni       = pOrdIni
       iOrdFim       = pOrdFim
       lNaoIniciadas = pNaoIniciadas
       lLiberadas    = pLiberadas
       lAlocadas     = pAlocadas
       lSeparadas    = pSeparadas
       lRequisitadas = pRequisitadas
       lIniciadas    = pIniciadas.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*************************************************************************************************************************
*************************************************************************************************************************/
PROCEDURE openQueryOrdServFiltroOrdemALL:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &scoped-define KEY-PHRASE {&tablename}.nr-ord-produ >= iOrdIni and ~
                              {&tablename}.nr-ord-produ <= iOrdFim and ~
                             (({&tablename}.estado = 1 and lNaoIniciadas) or ~
                              ({&tablename}.estado = 2 and lLiberadas)    or ~
                              ({&tablename}.estado = 3 and lAlocadas)     or ~
                              ({&tablename}.estado = 4 and lSeparadas)    or ~
                              ({&tablename}.estado = 5 and lRequisitadas) or ~
                              ({&tablename}.estado = 6 and lIniciadas)) NO-LOCK
    
    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroOrdemEstado16:
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/
    &scoped-define KEY-PHRASE {&tablename}.nr-ord-produ >= iOrdIni and ~
                              {&tablename}.nr-ord-produ <= iOrdFim and ~
                              {&tablename}.estado <= 6 NO-LOCK
    
    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ
    
    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroOrdemEstado :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.nr-ord-produ >= iOrdIni and ~
                              {&tablename}.nr-ord-produ <= iOrdFim and ~
                              {&tablename}.estado = 1 USE-INDEX estado NO-LOCK
    
    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ
    
    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroOrdemEstado2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.nr-ord-produ >= iOrdIni and ~
                              {&tablename}.nr-ord-produ <= iOrdFim and ~
                              {&tablename}.estado = 2 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.

PROCEDURE openQueryOrdServFiltroOrdemEstado3 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.nr-ord-produ >= iOrdIni and ~
                              {&tablename}.nr-ord-produ <= iOrdFim and ~
                              {&tablename}.estado = 3 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroOrdemEstado4 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.nr-ord-produ >= iOrdIni and ~
                              {&tablename}.nr-ord-produ <= iOrdFim and ~
                              {&tablename}.estado = 4 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroOrdemEstado5 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.nr-ord-produ >= iOrdIni and ~
                              {&tablename}.nr-ord-produ <= iOrdFim and ~
                              {&tablename}.estado = 5 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroOrdemEstado6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.nr-ord-produ >= iOrdIni and ~
                              {&tablename}.nr-ord-produ <= iOrdFim and ~
                              {&tablename}.estado = 6 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdServFiltroOrdem DBOProgram 
PROCEDURE openQueryOrdServFiltroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF (    lNaoIniciadas = YES
        AND lLiberadas     = YES
        AND lAlocadas      = YES
        AND lSeparadas     = YES
        AND lRequisitadas  = YES
        AND lIniciadas     = YES)
    THEN DO:
        RUN openQueryOrdServFiltroOrdemEstado16.
    END.
    ELSE IF (lNaoIniciadas  = YES   AND lLiberadas      = NO    AND lAlocadas   = NO  AND 
             lSeparadas     = NO    AND lRequisitadas   = NO    AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroOrdemEstado.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = YES   AND lAlocadas   = NO  AND 
             lSeparadas     = NO    AND lRequisitadas   = NO    AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroOrdemEstado2.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = NO    AND lAlocadas   = YES  AND 
             lSeparadas     = NO    AND lRequisitadas   = NO    AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroOrdemEstado3.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = NO    AND lAlocadas   = NO  AND 
             lSeparadas     = YES   AND lRequisitadas   = NO    AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroOrdemEstado4.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = NO    AND lAlocadas   = NO  AND 
             lSeparadas     = NO    AND lRequisitadas   = YES   AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroOrdemEstado5.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = NO    AND lAlocadas   = NO  AND 
             lSeparadas     = NO    AND lRequisitadas   = NO    AND lIniciadas  = YES )
    THEN DO:
        RUN openQueryOrdServFiltroOrdemEstado6.
    END.
    ELSE DO:
        RUN openQueryOrdServFiltroOrdemALL.
    END.

    return 'ok':u.

END PROCEDURE.


/*************************************************************************************************************************
*************************************************************************************************************************/
PROCEDURE openQueryOrdServFiltroItemALL:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &scoped-define KEY-PHRASE {&tablename}.it-codigo >= cItemIni and ~
                              {&tablename}.it-codigo <= cItemFim and ~
                             (({&tablename}.estado = 1 and lNaoIniciadas) or ~
                              ({&tablename}.estado = 2 and lLiberadas)    or ~
                              ({&tablename}.estado = 3 and lAlocadas)     or ~
                              ({&tablename}.estado = 4 and lSeparadas)    or ~
                              ({&tablename}.estado = 5 and lRequisitadas) or ~
                              ({&tablename}.estado = 6 and lIniciadas)) USE-INDEX item-emiss no-lock

    &Scoped-define BY-ESTAB-IN BY {&tablename}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT BY {&tablename}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroItemEstado16:
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/
    &scoped-define KEY-PHRASE {&tablename}.it-codigo >= cItemIni and ~
                              {&tablename}.it-codigo <= cItemFim and ~
                              {&tablename}.estado <= 6 NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroItemEstado1 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.it-codigo >= cItemIni and ~
                              {&tablename}.it-codigo <= cItemFim and ~
                              {&tablename}.estado = 1 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroItemEstado2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.it-codigo >= cItemIni and ~
                              {&tablename}.it-codigo <= cItemFim and ~
                              {&tablename}.estado = 2 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.

PROCEDURE openQueryOrdServFiltroItemEstado3 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.it-codigo >= cItemIni and ~
                              {&tablename}.it-codigo <= cItemFim and ~
                              {&tablename}.estado = 3 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroItemEstado4 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.it-codigo >= cItemIni and ~
                              {&tablename}.it-codigo <= cItemFim and ~
                              {&tablename}.estado = 4 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroItemEstado5 :
/*------------------------------------------------------------------------------
Purpose:     
Parameters:  <none>
Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.it-codigo >= cItemIni and ~
                              {&tablename}.it-codigo <= cItemFim and ~
                              {&tablename}.estado = 5 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.
PROCEDURE openQueryOrdServFiltroItemEstado6 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &scoped-define KEY-PHRASE {&tablename}.it-codigo >= cItemIni and ~
                              {&tablename}.it-codigo <= cItemFim and ~
                              {&tablename}.estado = 6 USE-INDEX estado NO-LOCK

    &Scoped-define BY-ESTAB-IN by {&tableName}.nr-ord-produ
    &Scoped-define BY-ESTAB-AT by {&tableName}.nr-ord-produ

    {include/i-estab-openquery.i}

END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdServFiltroItem DBOProgram 
PROCEDURE openQueryOrdServFiltroItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF (    lNaoIniciadas = YES
        AND lLiberadas     = YES
        AND lAlocadas      = YES
        AND lSeparadas     = YES
        AND lRequisitadas  = YES
        AND lIniciadas     = YES)
    THEN DO:
        RUN openQueryOrdServFiltroItemEstado16.
    END.
    ELSE IF (lNaoIniciadas  = YES   AND lLiberadas      = NO    AND lAlocadas   = NO  AND 
             lSeparadas     = NO    AND lRequisitadas   = NO    AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroItemEstado1.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = YES   AND lAlocadas   = NO  AND 
             lSeparadas     = NO    AND lRequisitadas   = NO    AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroItemEstado2.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = NO    AND lAlocadas   = YES  AND 
             lSeparadas     = NO    AND lRequisitadas   = NO    AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroItemEstado3.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = NO    AND lAlocadas   = NO  AND 
             lSeparadas     = YES   AND lRequisitadas   = NO    AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroItemEstado4.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = NO    AND lAlocadas   = NO  AND 
             lSeparadas     = NO    AND lRequisitadas   = YES   AND lIniciadas  = NO )
    THEN DO:
        RUN openQueryOrdServFiltroItemEstado5.
    END.
    ELSE IF (lNaoIniciadas  = NO    AND lLiberadas      = NO    AND lAlocadas   = NO  AND 
             lSeparadas     = NO    AND lRequisitadas   = NO    AND lIniciadas  = YES )
    THEN DO:
        RUN openQueryOrdServFiltroItemEstado6.
    END.
    ELSE DO:
        RUN openQueryOrdServFiltroItemALL.
    END.

    return 'ok':u.

END PROCEDURE.

