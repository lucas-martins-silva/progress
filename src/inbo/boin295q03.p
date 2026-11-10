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
{include/i-prgvrs.i BOIN295Q03 2.00.00.008 } /*** "010008" 23/11/2023 16:19:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin295q03 MUT}
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
&GLOBAL-DEFINE DBOName BOIN295Q03
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName pedido-compr
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName}
 

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/

DEFINE TEMP-TABLE RowObject NO-UNDO LIKE pedido-compr
    FIELD r-rowid AS ROWID.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/

&Scoped-define SEGUR-ESTAB-ATRIBUTE end-entrega /*atributo que contem o estabelecimento na query*/

&Scoped-define FIRST-TABLE-IN-QUERY-{&QueryName}  {&TableName}
&Scoped-define SECOND-TABLE-IN-QUERY-{&QueryName} ordem-compra
&Scoped-define THIRD-TABLE-IN-QUERY-{&QueryName}  emitente

&Scoped-define REPOSITION-PROCEDURE-KEY-PHRASE TRUE NO-LOCK, ~
     FIRST ordem-compra WHERE ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK, ~
     FIRST emitente WHERE emitente.cod-emitente = {&TableName}.cod-emitente NO-LOCK

{include/i-estab-security.i}

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/
DEFINE VARIABLE i-num-pedido-ini LIKE pedido-compr.num-pedido NO-UNDO.
DEFINE VARIABLE i-num-pedido-fim LIKE pedido-compr.num-pedido NO-UNDO.
DEFINE VARIABLE c-nome-abrev-ini LIKE emitente.nome-abrev     NO-UNDO.
DEFINE VARIABLE c-nome-abrev-fim LIKE emitente.nome-abrev     NO-UNDO.

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
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "c-cod-tabela":U THEN ASSIGN pFieldValue = RowObject.c-cod-tabela.
        WHEN "c-descr-merc[1]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[1].
        WHEN "c-descr-merc[2]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[2].
        WHEN "c-descr-merc[3]":U THEN ASSIGN pFieldValue = RowObject.c-descr-merc[3].
        WHEN "c-embalagem[1]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[1].
        WHEN "c-embalagem[2]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[2].
        WHEN "c-embalagem[3]":U THEN ASSIGN pFieldValue = RowObject.c-embalagem[3].
        WHEN "c-observacao[1]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[1].
        WHEN "c-observacao[2]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[2].
        WHEN "c-observacao[3]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[3].
        WHEN "c-observacao[4]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[4].
        WHEN "c-observacao[5]":U THEN ASSIGN pFieldValue = RowObject.c-observacao[5].
        WHEN "c-prazo":U THEN ASSIGN pFieldValue = RowObject.c-prazo.
        WHEN "cargo-ass[1]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[1].
        WHEN "cargo-ass[2]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[2].
        WHEN "cargo-ass[3]":U THEN ASSIGN pFieldValue = RowObject.cargo-ass[3].
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cod-entrega":U THEN ASSIGN pFieldValue = RowObject.cod-entrega.
        WHEN "cod-estab-gestor":U THEN ASSIGN pFieldValue = RowObject.cod-estab-gestor.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "comentarios":U THEN ASSIGN pFieldValue = RowObject.comentarios.
        WHEN "compl-entrega":U THEN ASSIGN pFieldValue = RowObject.compl-entrega.
        WHEN "desc-forma":U THEN ASSIGN pFieldValue = RowObject.desc-forma.
        WHEN "desc-via":U THEN ASSIGN pFieldValue = RowObject.desc-via.
        WHEN "end-cobranca":U THEN ASSIGN pFieldValue = RowObject.end-cobranca.
        WHEN "end-entrega":U THEN ASSIGN pFieldValue = RowObject.end-entrega.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "endereco_text":U THEN ASSIGN pFieldValue = RowObject.endereco_text.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "jurisdicao":U THEN ASSIGN pFieldValue = RowObject.jurisdicao.
        WHEN "mot-elimina":U THEN ASSIGN pFieldValue = RowObject.mot-elimina.
        WHEN "nome-ass[1]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[1].
        WHEN "nome-ass[2]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[2].
        WHEN "nome-ass[3]":U THEN ASSIGN pFieldValue = RowObject.nome-ass[3].
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "responsavel":U THEN ASSIGN pFieldValue = RowObject.responsavel.
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
        WHEN "data-pedido":U THEN ASSIGN pFieldValue = RowObject.data-pedido.
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
        WHEN "de-vl-fob":U THEN ASSIGN pFieldValue = RowObject.de-vl-fob.
        WHEN "de-vl-frete-i":U THEN ASSIGN pFieldValue = RowObject.de-vl-frete-i.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emit-terc":U THEN ASSIGN pFieldValue = RowObject.cod-emit-terc.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-maq-origem":U THEN ASSIGN pFieldValue = RowObject.cod-maq-origem.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
        WHEN "i-cod-forma":U THEN ASSIGN pFieldValue = RowObject.i-cod-forma.
        WHEN "i-cod-porto":U THEN ASSIGN pFieldValue = RowObject.i-cod-porto.
        WHEN "i-cod-via":U THEN ASSIGN pFieldValue = RowObject.i-cod-via.
        WHEN "i-exportador":U THEN ASSIGN pFieldValue = RowObject.i-exportador.
        WHEN "i-importador":U THEN ASSIGN pFieldValue = RowObject.i-importador.
        WHEN "i-moeda":U THEN ASSIGN pFieldValue = RowObject.i-moeda.
        WHEN "i-situacao":U THEN ASSIGN pFieldValue = RowObject.i-situacao.
        WHEN "ind-orig-entrada":U THEN ASSIGN pFieldValue = RowObject.ind-orig-entrada.
        WHEN "ind-via-envio":U THEN ASSIGN pFieldValue = RowObject.ind-via-envio.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "l-classificacao":U THEN ASSIGN pFieldValue = RowObject.l-classificacao.
        WHEN "l-tipo-ped":U THEN ASSIGN pFieldValue = RowObject.l-tipo-ped.
        WHEN "local-entrega":U THEN ASSIGN pFieldValue = RowObject.local-entrega.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-ped-venda":U THEN ASSIGN pFieldValue = RowObject.nr-ped-venda.
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-prox-ped":U THEN ASSIGN pFieldValue = RowObject.nr-prox-ped.
        WHEN "nro-proc-alteracao":U THEN ASSIGN pFieldValue = RowObject.nro-proc-alteracao.
        WHEN "nro-proc-entrada":U THEN ASSIGN pFieldValue = RowObject.nro-proc-entrada.
        WHEN "nro-proc-saida":U THEN ASSIGN pFieldValue = RowObject.nro-proc-saida.
        WHEN "num-id-documento":U THEN ASSIGN pFieldValue = RowObject.num-id-documento.
        WHEN "num-ped-benef":U THEN ASSIGN pFieldValue = RowObject.num-ped-benef.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "num-processo-mp":U THEN ASSIGN pFieldValue = RowObject.num-processo-mp.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "via-transp":U THEN ASSIGN pFieldValue = RowObject.via-transp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice numero
  Parameters:  
               retorna valor do campo num-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-pedido = RowObject.num-pedido.

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
        WHEN "contr-forn":U THEN ASSIGN pFieldValue = RowObject.contr-forn.
        WHEN "emergencial":U THEN ASSIGN pFieldValue = RowObject.emergencial.
        WHEN "gera-edi":U THEN ASSIGN pFieldValue = RowObject.gera-edi.
        WHEN "impr-pedido":U THEN ASSIGN pFieldValue = RowObject.impr-pedido.
        WHEN "l-ind-prof":U THEN ASSIGN pFieldValue = RowObject.l-ind-prof.
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
  Purpose:     Reposiciona registro com base no °ndice numero
  Parameters:  
               recebe valor do campo num-pedido
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-pedido LIKE pedido-compr.num-pedido NO-UNDO.

    FIND FIRST bfpedido-compr WHERE 
        bfpedido-compr.num-pedido = pnum-pedido NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpedido-compr THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpedido-compr)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNomeAbrev DBOProgram 
PROCEDURE openQueryByNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName} ~
            FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
            EACH {&TableName} NO-LOCK, ~
            FIRST ordem-compra WHERE ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK, ~
            FIRST emitente WHERE emitente.cod-emitente = {&TableName}.cod-emitente ~
            AND   emitente.nome-abrev  >= c-nome-abrev-ini ~
            AND   emitente.nome-abrev  <= c-nome-abrev-fim ~
            AND   emitente.natureza    > 2 ~
            AND   emitente.natureza    < 5 NO-LOCK ~
            BY    emitente.nome-abrev ~
            BY {&TableName}.num-pedido INDEXED-REPOSITION.
 
                
    &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName} ~
            FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
            EACH {&TableName} WHERE {&TableName}.end-entrega = {&ESTAB-SEC-TT-FIELD} NO-LOCK,  ~
            FIRST ordem-compra WHERE ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK, ~
            FIRST emitente WHERE emitente.cod-emitente = {&TableName}.cod-emitente ~
            AND   emitente.nome-abrev  >= c-nome-abrev-ini ~
            AND   emitente.nome-abrev  <= c-nome-abrev-fim ~
            AND   emitente.natureza    > 2 ~
            AND   emitente.natureza    < 5 NO-LOCK ~
            BY emitente.nome-abrev ~
            BY {&TableName}.end-entrega ~
            BY {&TableName}.num-pedido INDEXED-REPOSITION.

     {include/i-estab-openquery.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumPedido DBOProgram 
PROCEDURE openQueryByNumPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName} ~
            FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
            EACH {&TableName} ~
            WHERE {&TableName}.num-pedido >= i-num-pedido-ini ~
            AND {&TableName}.num-pedido <= i-num-pedido-fim NO-LOCK, ~
            FIRST ordem-compra WHERE ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK, ~
            FIRST emitente WHERE emitente.cod-emitente = {&TableName}.cod-emitente ~
            AND   emitente.natureza    > 2 ~
            AND   emitente.natureza    < 5 NO-LOCK ~
            BY {&TableName}.num-pedido INDEXED-REPOSITION.
 
                
    &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName} ~
            FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
            EACH {&TableName} WHERE {&TableName}.end-entrega = {&ESTAB-SEC-TT-FIELD} ~
            AND {&TableName}.num-pedido >= i-num-pedido-ini ~
            AND {&TableName}.num-pedido <= i-num-pedido-fim NO-LOCK, ~
            FIRST ordem-compra WHERE ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK, ~
            FIRST emitente WHERE emitente.cod-emitente = {&TableName}.cod-emitente ~
            AND   emitente.natureza    > 2 ~
            AND   emitente.natureza    < 5 NO-LOCK ~
            BY {&TableName}.end-entrega ~
            BY {&TableName}.num-pedido INDEXED-REPOSITION.
     

     {include/i-estab-openquery.i}

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
    &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-IN OPEN QUERY {&QueryName} ~
            FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
            EACH {&TableName} NO-LOCK, ~
            FIRST ordem-compra WHERE ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK, ~
            FIRST emitente WHERE emitente.cod-emitente = {&TableName}.cod-emitente ~
            AND   emitente.natureza    > 2 ~
            AND   emitente.natureza    < 5 NO-LOCK INDEXED-REPOSITION.
 
                
    &SCOPED-DEFINE OPEN-QUERY-{&QueryName}-AT OPEN QUERY {&QueryName} ~
            FOR EACH {&ESTAB-SEC-TT} NO-LOCK,~
            EACH {&TableName} WHERE {&TableName}.end-entrega = {&ESTAB-SEC-TT-FIELD} NO-LOCK,  ~
            FIRST ordem-compra WHERE ordem-compra.num-pedido = {&TableName}.num-pedido NO-LOCK, ~
            FIRST emitente WHERE emitente.cod-emitente = {&TableName}.cod-emitente ~
            AND   emitente.natureza    > 2 ~
            AND   emitente.natureza    < 5 NO-LOCK INDEXED-REPOSITION.

     {include/i-estab-openquery.i}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNomeAbrev DBOProgram 
PROCEDURE setConstraintByNomeAbrev :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nome-abrev-ini LIKE emitente.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-abrev-fim LIKE emitente.nome-abrev NO-UNDO.

    ASSIGN c-nome-abrev-ini = p-nome-abrev-ini
           c-nome-abrev-fim = p-nome-abrev-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumPedido DBOProgram 
PROCEDURE setConstraintByNumPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-num-pedido-ini LIKE pedido-compr.num-pedido NO-UNDO.
    DEFINE INPUT PARAMETER p-num-pedido-fim LIKE pedido-compr.num-pedido NO-UNDO.

    ASSIGN i-num-pedido-ini = p-num-pedido-ini
           i-num-pedido-fim = p-num-pedido-fim.

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

