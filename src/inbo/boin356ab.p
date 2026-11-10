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
{include/i-prgvrs.i BOIN356AB 2.00.00.009 } /*** "010009" 23/11/2023 16:19:46  ***/
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN356AB
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName prazo-compra
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin356ab.i RowObject}


/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

DEF TEMP-TABLE tt-eq-simul-carg NO-UNDO LIKE eq-simul-carg
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-prazo-compra NO-UNDO LIKE prazo-compra
    field r-rowid as rowid
    field num-pedido like pedido-compr.num-pedido
    field grp-emb-princ like eq-grp-embarq.nom-grp-embarq
    field quant-saldo-disp like prazo-compra.quant-saldo label "Qtde Saldo Disp"
    field qtd-alocar like prazo-compra.quant-saldo
    field cod-embal-sigla as char format "x(30)" label "Embalagem"
    field qtd-embal as dec label "Qtde Embalag"
    field vol-unit  as dec label "Volume Unit rio"
    field vol-total as dec label "Volume Total"
    field peso-bruto-unit as dec label "Peso Bruto Unit rio"
    field peso-bruto-tot as dec label "Peso Bruto Total"
    field fornecedor  as char format "x(60)" label "Fornecedor" 
    field desc-item as char format "x(60)" label "Descri‡Æo Item".

DEF TEMP-TABLE tt-prazo-compra-aux2 NO-UNDO LIKE prazo-compra
    field r-rowid as rowid
    field num-pedido like pedido-compr.num-pedido
    field grp-emb-princ like eq-grp-embarq.nom-grp-embarq
    field quant-saldo-disp like prazo-compra.quant-saldo label "Qtde Saldo Disp"
    field qtd-alocar like prazo-compra.quant-saldo
    field cod-embal-sigla as char format "x(30)" label "Embalagem"
    field qtd-embal as dec label "Qtde Embalag"
    field vol-unit  as dec label "Volume Unit rio"
    field vol-total as dec label "Volume Total"
    field peso-bruto-unit as dec label "Peso Bruto Unit rio"
    field peso-bruto-tot as dec label "Peso Bruto Total"
    field fornecedor  as char format "x(60)" label "Fornecedor" 
    field desc-item as char format "x(60)" label "Descri‡Æo Item".

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{eqp/eq0502.i}
{eqp/eq0502b.i}

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
         HEIGHT             = 6.79
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cc-codigo":U THEN ASSIGN pFieldValue = RowObject.cc-codigo.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-cotacao":U THEN ASSIGN pFieldValue = RowObject.item-cotacao.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "pedido-clien":U THEN ASSIGN pFieldValue = RowObject.pedido-clien.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-alter":U THEN ASSIGN pFieldValue = RowObject.data-alter.
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "data-entrega-ant":U THEN ASSIGN pFieldValue = RowObject.data-entrega-ant.
        WHEN "data-orig":U THEN ASSIGN pFieldValue = RowObject.data-orig.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qtd-a-ped-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-a-ped-forn.
        WHEN "qtd-aloc-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-aloc-forn.
        WHEN "qtd-do-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-do-forn.
        WHEN "qtd-rec-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rec-forn.
        WHEN "qtd-rej-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-rej-forn.
        WHEN "qtd-sal-forn":U THEN ASSIGN pFieldValue = RowObject.qtd-sal-forn.
        WHEN "quant-a-ped":U THEN ASSIGN pFieldValue = RowObject.quant-a-ped.
        WHEN "quant-alocada":U THEN ASSIGN pFieldValue = RowObject.quant-alocada.
        WHEN "quant-receb":U THEN ASSIGN pFieldValue = RowObject.quant-receb.
        WHEN "quant-rejeit":U THEN ASSIGN pFieldValue = RowObject.quant-rejeit.
        WHEN "quant-saldo":U THEN ASSIGN pFieldValue = RowObject.quant-saldo.
        WHEN "quantid-orig":U THEN ASSIGN pFieldValue = RowObject.quantid-orig.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "hora":U THEN ASSIGN pFieldValue = RowObject.hora.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "MRP":U THEN ASSIGN pFieldValue = RowObject.MRP.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "nr-alt-data":U THEN ASSIGN pFieldValue = RowObject.nr-alt-data.
        WHEN "nr-alt-quant":U THEN ASSIGN pFieldValue = RowObject.nr-alt-quant.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "nr-estrut-filha":U THEN ASSIGN pFieldValue = RowObject.nr-estrut-filha.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice ordem
  Parameters:  
               retorna valor do campo numero-ordem
               retorna valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem
           pparcela = RowObject.parcela.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-alter":U THEN ASSIGN pFieldValue = RowObject.cod-alter.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        WHEN "cons-pmp":U THEN ASSIGN pFieldValue = RowObject.cons-pmp.
        WHEN "expectativa":U THEN ASSIGN pFieldValue = RowObject.expectativa.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "ordem-emitida":U THEN ASSIGN pFieldValue = RowObject.ordem-emitida.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice ordem
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE prazo-compra.parcela NO-UNDO.

    FIND FIRST bf{&tableName} WHERE 
        bf{&tableName}.numero-ordem = pnumero-ordem AND 
        bf{&tableName}.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf{&tableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf{&tableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piModificaSituacao DBOProgram 
PROCEDURE piModificaSituacao :
/*:T------------------------------------------------------------------------------
  Purpose:     Altera situa‡Æo da parcela (Fixada - NÆo Fixada)
  Parameters:  Numero da ordem
               Parcela
               Situa‡Æo: 0- NÆo Fixada ; 2 - Fixada
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pi-numero-ordem LIKE prazo-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pi-parcela      LIKE prazo-compra.parcela      NO-UNDO.
    DEFINE INPUT PARAMETER pi-situacao     LIKE prazo-compra.int-2        NO-UNDO.

    FOR FIRST bf{&TableName} WHERE
              bf{&TableName}.numero-ordem = pi-numero-ordem AND
              bf{&TableName}.parcela      = pi-parcela      EXCLUSIVE-LOCK: END.

        IF AVAIL bf{&TableName} THEN
          ASSIGN bf{&tablename}.int-2 = pi-situacao.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSelecaoParcelas DBOProgram 
PROCEDURE piSelecaoParcelas :
/*------------------------------------------------------------------------------
  Purpose: Seleciona parcelas de compra 
           (eq0502 - browser Ocupa‡Æo Embarque/Pedido de Compras)    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM TABLE FOR tt-selecao-b.
    DEF INPUT  PARAM prRowid AS ROWID.
    DEF INPUT  PARAM h-bodi447 AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-prazo-compra-tela.
    
    DEF VAR de-qtd-disponivel       LIKE prazo-compra.quant-saldo NO-UNDO.
    DEF VAR l-usuario-tem-permissao AS LOG                        NO-UNDO.
    DEF VAR l-elimina-bo            AS LOG                        NO-UNDO.
    DEF VAR l-embarque-imp          AS LOG                        NO-UNDO.
    DEF VAR l-parcela-vinculada     AS LOG                        NO-UNDO.

    FIND FIRST tt-selecao-b        NO-ERROR.

    FIND FIRST eq-simul-carg WHERE
         ROWID(eq-simul-carg) = prRowid NO-LOCK NO-ERROR.

    IF NOT AVAIL eq-simul-carg THEN
       RETURN "NOK".

    EMPTY TEMP-TABLE tt-prazo-compra-tela NO-ERROR.

    IF tt-selecao-b.data-entrega-ini = ? THEN
       ASSIGN tt-selecao-b.data-entrega-ini = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF .

    FOR EACH bf{&tableName}
       WHERE bf{&tableName}.situacao = 2 /* confirmada */
         AND bf{&tableName}.numero-ordem >= tt-selecao-b.numero-ordem-ini
         AND bf{&tableName}.numero-ordem <= tt-selecao-b.numero-ordem-fim
         AND bf{&tableName}.data-entrega >= tt-selecao-b.data-entrega-ini
         AND bf{&tableName}.data-entrega <= tt-selecao-b.data-entrega-fim NO-LOCK:
          
        FOR FIRST ordem-compra FIELDS (cod-emitente numero-ordem cod-estabel it-codigo num-pedido) WHERE 
                  ordem-compra.numero-ordem  = bf{&tableName}.numero-ordem 
              AND ordem-compra.it-codigo    >= tt-selecao-b.it-codigo-ini
              AND ordem-compra.it-codigo    <= tt-selecao-b.it-codigo-fim
              AND ordem-compra.cod-emitente >= tt-selecao-b.cod-emitente-ini
              AND ordem-compra.cod-emitente <= tt-selecao-b.cod-emitente-fim 
              AND ordem-compra.cod-estabel  >= tt-selecao-b.cod-estabel-ini
              AND ordem-compra.cod-estabel  <= tt-selecao-b.cod-estabel-fim 
              AND ordem-compra.num-pedido   >= tt-selecao-b.num-pedido-ini 
              AND ordem-compra.num-pedido   <= tt-selecao-b.num-pedido-fim NO-LOCK: END.

        IF NOT AVAIL ordem-compra THEN NEXT.

        FOR FIRST emitente FIELDS (nome-abrev natureza)
            WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.

        /*--- emitente tem que ser estrangeiro (3) ou trading (4) ---*/
        IF  NOT AVAIL emitente OR emitente.natureza < 3 THEN
            NEXT.

        /* parcela vinculada a outro tipo carga */
        IF CAN-FIND (FIRST eq-simul-carg-ped WHERE 
                           eq-simul-carg-ped.numero-ordem   = bf{&tableName}.numero-ordem   AND
                           eq-simul-carg-ped.nr-parcela     = bf{&tableName}.parcela        AND 
                          (eq-simul-carg-ped.cod-estabel   <> eq-simul-carg.cod-estabel     OR
                           eq-simul-carg-ped.dat-planej    <> eq-simul-carg.dat-planej      OR
                           eq-simul-carg-ped.hra-planej    <> eq-simul-carg.hra-planej      OR
                           eq-simul-carg-ped.num-seq-simul <> eq-simul-carg.num-seq-simul))  THEN
           NEXT.
        /*--- verifica se parcela est  vinculada a tipo carga ---*/
        ASSIGN l-parcela-vinculada = NO.
        IF CAN-FIND (FIRST eq-simul-carg-ped WHERE 
                           eq-simul-carg-ped.numero-ordem   = bf{&tableName}.numero-ordem  AND
                           eq-simul-carg-ped.nr-parcela     = bf{&tableName}.parcela       AND 
                           eq-simul-carg-ped.cod-estabel    = eq-simul-carg.cod-estabel    AND
                           eq-simul-carg-ped.dat-planej     = eq-simul-carg.dat-planej     AND
                           eq-simul-carg-ped.hra-planej     = eq-simul-carg.hra-planej     AND
                           eq-simul-carg-ped.num-seq-simul  = eq-simul-carg.num-seq-simul )  THEN
           ASSIGN l-parcela-vinculada = YES.
           
           IF ( NOT l-parcela-vinculada AND NOT tt-selecao-b.l-nao-vinculado ) OR
              (     l-parcela-vinculada AND NOT tt-selecao-b.l-vinculado     ) THEN NEXT.

        /* Verifica se a Parcela esta vinculada ao Embarque */
        IF  tt-selecao-b.embarque-ini <> "":U             OR
            tt-selecao-b.embarque-fim <> "ZZZZZZZZZZZZ":U THEN DO:
            ASSIGN l-embarque-imp = YES.

            FOR FIRST  ordens-embarque
                FIELDS (embarque)
                WHERE  ordens-embarque.numero-ordem = ordem-compra.numero-ordem AND
                       ordens-embarque.parcela      = bf{&tableName}.parcela    NO-LOCK: END.

            IF  AVAIL ordens-embarque THEN DO:
                IF  ordens-embarque.embarque < tt-selecao-b.embarque-ini OR
                    ordens-embarque.embarque > tt-selecao-b.embarque-fim THEN
                    ASSIGN l-embarque-imp = NO.
            END.
            ELSE
                ASSIGN l-embarque-imp = NO.

            IF NOT l-embarque-imp THEN NEXT.
        END.

        /*--- verifica se o usuario possui permissao a todos 
              os grupos de embarque do item ---*/
        ASSIGN l-usuario-tem-permissao = YES.
        FOR FIRST eq-item-embarq
            WHERE eq-item-embarq.it-codigo = ordem-compra.it-codigo NO-LOCK:

            IF NOT CAN-FIND(FIRST eq-usuar-embarq-grp-embarq
                            WHERE eq-usuar-embarq-grp-embarq.nom-grp-embarq = eq-item-embarq.nom-grp-embarq
                              AND eq-usuar-embarq-grp-embarq.cod-usuario    = c-seg-usuario) THEN DO:
                ASSIGN l-usuario-tem-permissao = NO.
                LEAVE.
            END.
        END.

        IF  l-usuario-tem-permissao = NO THEN
            NEXT.

        FOR FIRST ITEM FIELDS(desc-item)
            WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK: END.

        FIND item-fornec
            WHERE item-fornec.cod-emitente = ordem-compra.cod-emitente
              AND item-fornec.it-codigo    = ordem-compra.it-codigo NO-LOCK NO-ERROR.

        IF  AVAIL item-fornec THEN
            FIND FIRST embalag
                 WHERE embalag.embalagem = item-fornec.cod-embal NO-LOCK NO-ERROR.

        IF  NOT CAN-FIND(FIRST tt-prazo-compra-tela
                         WHERE tt-prazo-compra-tela.numero-ordem = bf{&tableName}.numero-ordem
                           AND tt-prazo-compra-tela.parcela      = bf{&tableName}.parcela) THEN DO:

            /*--- retornar saldo da parcela ---*/
            RUN retornaQtdeSaldoDisp(INPUT bf{&tableName}.numero-ordem,
                                     INPUT bf{&tableName}.parcela,
                                     OUTPUT de-qtd-disponivel).

            CREATE tt-prazo-compra-tela.
            BUFFER-COPY bf{&tableName} TO tt-prazo-compra-tela.
    
            ASSIGN tt-prazo-compra-tela.r-rowid          = ROWID(bf{&tableName})
                   tt-prazo-compra-tela.num-pedido       = ordem-compra.num-pedido
                   tt-prazo-compra-tela.quant-saldo-disp = de-qtd-disponivel
                   tt-prazo-compra-tela.fornecedor       = STRING(ordem-compra.cod-emitente) + " - " + emitente.nome-abrev
                   tt-prazo-compra-tela.desc-item        = ITEM.desc-item
                   tt-prazo-compra-tela.situacao-vinc    = IF l-parcela-vinculada THEN "Vinculado" ELSE "NÆo Vinculado"
                   tt-prazo-compra-tela.cod-sigla-embal  = STRING(IF AVAIL item-fornec THEN item-fornec.cod-embal 
                                                             ELSE "" + 
                                                             " ("    +
                                                             IF  AVAIL embalag THEN embalag.sigla-emb
                                                             ELSE "" +
                                                             ") ") .
            IF  NOT VALID-HANDLE(h-bodi447) THEN DO:
                ASSIGN l-elimina-bo = YES.
                RUN dibo/bodi447.p PERSISTENT SET h-bodi447.
                RUN openQueryStatic IN h-bodi447("main":U).
            END.
            ELSE
                ASSIGN l-elimina-bo = NO.

            /*--- busca quantidade j  alocada ---*/
            FOR EACH eq-simul-carg-ped FIELDS ( qtd-alocada )
               WHERE eq-simul-carg-ped.numero-ordem = tt-prazo-compra-tela.numero-ordem
                 AND eq-simul-carg-ped.nr-parcela   = tt-prazo-compra-tela.parcela NO-LOCK:

                 ASSIGN tt-prazo-compra-tela.qtd-alocada = tt-prazo-compra-tela.qtd-alocada + eq-simul-carg-ped.qtd-alocada.
            END.

            IF  VALID-HANDLE(h-bodi447) THEN DO:

                RUN piRetornaGrpEmbarqPrincipal IN h-bodi447(INPUT bf{&tablename}.it-codigo, 
                                                             OUTPUT tt-prazo-compra-tela.nom-grp-embarq).

                RUN piRetornaQtdeEmbalagem IN h-bodi447(INPUT tt-prazo-compra-tela.qtd-alocada, 
                                                        INPUT bf{&tablename}.it-codigo, 
                                                        INPUT ordem-compra.cod-emitente, 
                                                        OUTPUT tt-prazo-compra-tela.qtd-embalag).
                IF  l-elimina-bo THEN DO:
                    DELETE PROCEDURE h-bodi447 NO-ERROR.
                    ASSIGN h-bodi447 = ?.
                END.
            END.

            RUN retornaVolumeUnitario IN THIS-PROCEDURE(INPUT ROWID(bf{&tableName}), 
                                                        OUTPUT tt-prazo-compra-tela.volume-unit).

            RUN retornaPesoUnitario IN THIS-PROCEDURE(INPUT ROWID(bf{&tableName}), 
                                                      OUTPUT tt-prazo-compra-tela.peso-bruto-unit).


            IF tt-prazo-compra-tela.qtd-embalag > 0 THEN
                RUN retornaVolumeTotal IN THIS-PROCEDURE(INPUT ROWID(bf{&tableName}), 
                                                         INPUT tt-prazo-compra-tela.qtd-embalag, 
                                                         OUTPUT tt-prazo-compra-tela.volume-total).
            ELSE
                RUN retornaVolumeTotal IN THIS-PROCEDURE(INPUT ROWID(bf{&tableName}), 
                                                         INPUT tt-prazo-compra-tela.qtd-alocada, 
                                                         OUTPUT tt-prazo-compra-tela.volume-total).
    
            RUN retornaPesoTotal IN THIS-PROCEDURE (INPUT ROWID(bf{&tableName}), 
                                                    INPUT tt-prazo-compra-tela.qtd-alocada, 
                                                    INPUT tt-prazo-compra-tela.qtd-embalag, 
                                                    OUTPUT tt-prazo-compra-tela.peso-bruto-total).
        END.

    END. /* bf{$TableName} */
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDadosEmbalagem DBOProgram 
PROCEDURE retornaDadosEmbalagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnumero-ordem   LIKE prazo-compra.numero-ordem  NO-UNDO.
    DEFINE INPUT  PARAMETER pit-codigo      LIKE prazo-compra.it-codigo     NO-UNDO.
    DEFINE INPUT  PARAMETER pqtd-alocada    LIKE prazo-compra.quant-alocada NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-altura      LIKE embalag.altura             NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-largura     LIKE embalag.largura            NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-comprim     LIKE embalag.comprim            NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-peso-embal  LIKE embalag.peso-embal         NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-volume      LIKE embalag.volume             NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-quantidade  AS DEC                          NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-emb          AS LOG                          NO-UNDO.

    FOR FIRST cotacao-item 
        WHERE cotacao-item.numero-ordem = pnumero-ordem AND
              cotacao-item.it-codigo    = pit-codigo    AND
              cotacao-item.cot-aprovada = YES           NO-LOCK: END.

    IF AVAIL cotacao-item THEN DO:
        FOR FIRST item-fornec 
            WHERE item-fornec.cod-emitente  = cotacao-item.cod-emitente
              AND item-fornec.it-codigo     = cotacao-item.it-codigo 
              AND item-fornec.cod-embal     <> "" NO-LOCK,
            FIRST embalag 
            WHERE embalag.embalagem = item-fornec.cod-embal NO-LOCK: END.

        IF  AVAIL embalag THEN DO:

            ASSIGN pl-emb         = YES
                   pde-altura     = embalag.altura
                   pde-largura    = embalag.largura
                   pde-comprim    = embalag.comprim
                   pde-peso-embal = embalag.peso-embal
                   pde-volume     = embalag.volume.

            FIND eq-item-embal-embarq NO-LOCK USE-INDEX eqtmmblm-id        WHERE
                 eq-item-embal-embarq.it-codigo = item-fornec.it-codigo      AND
                 eq-item-embal-embarq.cod-embal = item-fornec.cod-embal NO-ERROR.
            IF AVAIL eq-item-embal-embarq THEN
               ASSIGN pde-quantidade = pqtd-alocada / eq-item-embal-embarq.qtd-item-embal.    
        END.

        ASSIGN pde-quantidade = IF ROUND(pde-quantidade,0) < pde-quantidade THEN ROUND(pde-quantidade,0) + 1
                                ELSE ROUND(pde-quantidade,0).
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaParcelasDisponiveis DBOProgram 
PROCEDURE retornaParcelasDisponiveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEF INPUT  PARAM TABLE FOR tt-selecao-b.
    DEF INPUT  PARAM TABLE FOR tt-eq-simul-carg.
    DEF INPUT  PARAM h-bodi447 AS HANDLE NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-prazo-compra-aux2.
    
    DEF VAR de-qtd-disponivel       LIKE prazo-compra.quant-saldo NO-UNDO.
    DEF VAR l-usuario-tem-permissao AS LOG                        NO-UNDO.
    DEF VAR l-elimina-bo            AS LOG                        NO-UNDO.

    FIND FIRST tt-eq-simul-carg NO-ERROR.
    FIND FIRST tt-selecao-b        NO-ERROR.

    FOR EACH tt-prazo-compra:
        DELETE tt-prazo-compra.
    END.
    FOR EACH tt-prazo-compra-aux2:
        DELETE tt-prazo-compra-aux2.
    END.

    DEF VAR l-emb AS LOG NO-UNDO.

    FOR EACH bf{&tableName}
        WHERE bf{&tableName}.situacao = 2 /* confirmada */
          AND bf{&tableName}.numero-ordem >= tt-selecao-b.numero-ordem-ini
          AND bf{&tableName}.numero-ordem <= tt-selecao-b.numero-ordem-fim
          AND bf{&tableName}.data-entrega >= tt-selecao-b.data-entrega-ini
          AND bf{&tableName}.data-entrega <= tt-selecao-b.data-entrega-fim NO-LOCK:
          
        FIND ordem-compra WHERE 
             ordem-compra.numero-ordem = bf{&tableName}.numero-ordem 
         AND ordem-compra.it-codigo    >= tt-selecao-b.it-codigo-ini
         AND ordem-compra.it-codigo    <= tt-selecao-b.it-codigo-fim
         AND ordem-compra.cod-emitente >= tt-selecao-b.cod-emitente-ini
         AND ordem-compra.cod-emitente <= tt-selecao-b.cod-emitente-fim 
         AND ordem-compra.num-pedido   >= tt-selecao-b.num-pedido-ini 
         AND ordem-compra.num-pedido   <= tt-selecao-b.num-pedido-fim  NO-LOCK NO-ERROR.

        IF  NOT AVAIL ordem-compra THEN NEXT.

        FOR FIRST emitente FIELDS (nome-abrev natureza)
            WHERE emitente.cod-emitente = ordem-compra.cod-emitente NO-LOCK: END.
                           
        /*--- emitente tem que ser estrangeiro (3) ou trading (4) ---*/
        IF  NOT AVAIL emitente
        OR  emitente.natureza < 3 THEN
            NEXT.
                 
        /*--- verificar se o prazo ---*/
        IF  ordem-compra.cod-estabel <> tt-eq-simul-carg.cod-estabel THEN
            NEXT.
                 
        /*--- verifica se o usuario possui permissao a todos 
              os grupos de embarque do item ---*/
        ASSIGN l-usuario-tem-permissao = YES.
        FOR EACH  eq-item-embarq
            WHERE eq-item-embarq.it-codigo = ordem-compra.it-codigo NO-LOCK:

            IF NOT CAN-FIND(FIRST eq-usuar-embarq-grp-embarq
                            WHERE eq-usuar-embarq-grp-embarq.nom-grp-embarq = eq-item-embarq.nom-grp-embarq
                              AND eq-usuar-embarq-grp-embarq.cod-usuario    = c-seg-usuario) THEN DO:
                ASSIGN l-usuario-tem-permissao = NO.
                LEAVE.
            END.
        END.

        IF  l-usuario-tem-permissao = NO THEN
            NEXT.
            
        FOR FIRST ITEM FIELDS(desc-item)
            WHERE ITEM.it-codigo = ordem-compra.it-codigo NO-LOCK: END.

            ASSIGN l-emb = NO.

            FOR FIRST cotacao-item 
                WHERE cotacao-item.numero-ordem = bf{&tableName}.numero-ordem AND
                      cotacao-item.it-codigo    = bf{&tablename}.it-codigo    AND
                      cotacao-item.cot-aprovada = YES                         NO-LOCK: END.
             IF AVAIL cotacao-item THEN DO:
                 FOR FIRST item-fornec NO-LOCK  USE-INDEX onde-compra WHERE
                           item-fornec.it-codigo    = bf{&tablename}.it-codigo  AND
                           item-fornec.cod-emitente = cotacao-item.cod-emitente AND
                           item-fornec.cod-embal <> "" :
                      FIND embalag WHERE 
                           embalag.embalagem = item-fornec.cod-embal NO-LOCK NO-ERROR.
                      IF AVAIL embalag THEN 
                         ASSIGN l-emb = YES.
                 END.
             END.

        IF  NOT CAN-FIND(FIRST tt-prazo-compra
                         WHERE tt-prazo-compra.numero-ordem = bf{&tableName}.numero-ordem
                           AND tt-prazo-compra.parcela      = bf{&tableName}.parcela) THEN DO:

            /*--- retornar saldo da parcela ---*/
            RUN retornaQtdeSaldoDisp(INPUT bf{&tableName}.numero-ordem,
                                     INPUT bf{&tableName}.parcela,
                                     OUTPUT de-qtd-disponivel).
                                            
            IF  de-qtd-disponivel <= 0 THEN
                NEXT.

            CREATE tt-prazo-compra.
            BUFFER-COPY bf{&tableName} TO tt-prazo-compra.
  
            ASSIGN tt-prazo-compra.r-rowid      = ROWID(bf{&tableName})
                   tt-prazo-compra.num-pedido   = ordem-compra.num-pedido
                   tt-prazo-compra.quant-saldo-disp = de-qtd-disponivel
                   tt-prazo-compra.qtd-alocar       = de-qtd-disponivel
                   tt-prazo-compra.fornecedor       = STRING(ordem-compra.cod-emitente) + " - " + emitente.nome-abrev
                   tt-prazo-compra.desc-item        = ITEM.desc-item.

             IF l-emb THEN
                ASSIGN tt-prazo-compra.cod-embal-sigla  = STRING(item-fornec.cod-embal +  " ("  +
                                                                 embalag.sigla-emb  +  ") ").
            ELSE
                ASSIGN tt-prazo-compra.cod-embal-sigla  = "".

            IF  NOT VALID-HANDLE(h-bodi447) THEN DO:
                ASSIGN l-elimina-bo = YES.
                RUN dibo/bodi447.p PERSISTENT SET h-bodi447.
                RUN openQueryStatic IN h-bodi447("main":U).
            END.
            ELSE
                ASSIGN l-elimina-bo = NO.

            IF  VALID-HANDLE(h-bodi447) THEN DO:

                RUN piRetornaGrpEmbarqPrincipal IN h-bodi447(INPUT bf{&tablename}.it-codigo, 
                                                             OUTPUT tt-prazo-compra.grp-emb-princ).

                RUN piRetornaQtdeEmbalagem IN h-bodi447(INPUT tt-prazo-compra.qtd-alocar, 
                                                        INPUT bfprazo-compra.it-codigo, 
                                                        INPUT ordem-compra.cod-emitente, 
                                                        OUTPUT tt-prazo-compra.qtd-embal).

                IF  l-elimina-bo THEN DO:
                    DELETE PROCEDURE h-bodi447 NO-ERROR.
                    ASSIGN h-bodi447 = ?.
                END.
            END.

            RUN retornaVolumeUnitario IN THIS-PROCEDURE(INPUT ROWID(bfprazo-compra), 
                                                        OUTPUT tt-prazo-compra.vol-unit).

            RUN retornaPesoUnitario IN THIS-PROCEDURE(INPUT ROWID(bfprazo-compra), 
                                                      OUTPUT tt-prazo-compra.peso-bruto-unit).

            IF NOT l-emb THEN
                RUN retornaVolumeTotal IN THIS-PROCEDURE(INPUT ROWID(bfprazo-compra), 
                                                         INPUT tt-prazo-compra.qtd-alocar, 
                                                         OUTPUT tt-prazo-compra.vol-total).
            ELSE
                RUN retornaVolumeTotal IN THIS-PROCEDURE(INPUT ROWID(bfprazo-compra), 
                                                         INPUT tt-prazo-compra.qtd-embal, 
                                                         OUTPUT tt-prazo-compra.vol-total).
    
                RUN retornaPesoTotal IN THIS-PROCEDURE(INPUT ROWID(bfprazo-compra), 
                                                       INPUT tt-prazo-compra.qtd-alocar, 
                                                       INPUT tt-prazo-compra.qtd-embal, 
                                                       OUTPUT tt-prazo-compra.peso-bruto-tot).

            

        END.
    END.

    /*--- diminui a quantidade ja alocada para cada parcela. 
          Se ja foi alocado todo o saldo (tt-prazo-compra.quant-saldo-disp), 
          entao elimina tt-prazo-compra. ---*/
    FOR EACH tt-prazo-compra:

        FOR EACH  eq-simul-carg-ped
            WHERE eq-simul-carg-ped.numero-ordem = tt-prazo-compra.numero-ordem
              AND eq-simul-carg-ped.nr-parcela   = tt-prazo-compra.parcela      NO-LOCK:

            /*--- parcelas de embarques em simulacao ja
                  foram considerados na procedure
                  retornaQtdeSaldoDisp ---*/
            IF  CAN-FIND (FIRST eq-simul-carg
                          WHERE eq-simul-carg.cod-estabel   = eq-simul-carg-ped.cod-estabel  
                            AND eq-simul-carg.dat-planej    = eq-simul-carg-ped.dat-planej   
                            AND eq-simul-carg.hra-planej    = eq-simul-carg-ped.hra-planej   
                            AND eq-simul-carg.num-seq-simul = eq-simul-carg-ped.num-seq-simul
                            AND eq-simul-carg.idi-situacao = 2 /* em simulacao */) THEN
                NEXT.

            IF AVAIL tt-prazo-compra AND eq-simul-carg-ped.qtd-alocada  = tt-prazo-compra.quant-saldo-disp THEN DO:
                DELETE tt-prazo-compra.
                NEXT.
            END.
            ELSE
                ASSIGN tt-prazo-compra.quant-saldo-disp = tt-prazo-compra.quant-saldo-disp -
                                                          eq-simul-carg-ped.qtd-alocada WHEN AVAIL tt-prazo-compra.

            IF AVAIL tt-prazo-compra AND tt-prazo-compra.quant-saldo-disp <= 0 THEN DO:
                DELETE tt-prazo-compra.
                NEXT.
            END.
        END.

        IF  AVAIL tt-prazo-compra THEN 
            ASSIGN tt-prazo-compra.qtd-alocar = tt-prazo-compra.quant-saldo-disp.
    END.

    IF  tt-selecao-b.i-classifica = 1 THEN DO:
        FOR EACH tt-prazo-compra
              BY tt-prazo-compra.fornecedor
              BY tt-prazo-compra.data-entrega:
             
            CREATE tt-prazo-compra-aux2.
            BUFFER-COPY tt-prazo-compra TO tt-prazo-compra-aux2.
        END.
    END.

    IF tt-selecao-b.i-classifica = 2 THEN DO:
        FOR EACH tt-prazo-compra
              BY tt-prazo-compra.num-pedido
              BY tt-prazo-compra.numero-ordem:

            CREATE tt-prazo-compra-aux2.
            BUFFER-COPY tt-prazo-compra TO tt-prazo-compra-aux2.
        END.
    END.

    IF tt-selecao-b.i-classifica = 3 THEN DO:
        FOR EACH tt-prazo-compra
              BY tt-prazo-compra.data-entrega
              BY tt-prazo-compra.it-codigo:

            CREATE tt-prazo-compra-aux2.
            BUFFER-COPY tt-prazo-compra TO tt-prazo-compra-aux2.
        END.
    END.

    IF tt-selecao-b.i-classifica = 4 THEN DO:
        FOR EACH tt-prazo-compra
              BY tt-prazo-compra.data-entrega
              BY tt-prazo-compra.num-pedido
              BY tt-prazo-compra.numero-ordem:

            CREATE tt-prazo-compra-aux2.
            BUFFER-COPY tt-prazo-compra TO tt-prazo-compra-aux2.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaPesoTotal DBOProgram 
PROCEDURE retornaPesoTotal :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prRowid         AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pdeQtdeAlocar   AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER pdeQtdeEmbal    AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pdePesoTotal    AS DECIMAL NO-UNDO.

    DEF VAR de-peso-unit AS DEC NO-UNDO.
    DEF VAR l-emb        AS LOG NO-UNDO.
    DEF VAR deQtdeDisp   AS DEC NO-UNDO.

    FIND bfprazo-compra NO-LOCK WHERE 
         ROWID(bfprazo-compra) = prRowid NO-ERROR.
    
    FIND item WHERE 
         item.it-codigo = bfprazo-compra.it-codigo NO-LOCK NO-ERROR.
    
    FOR FIRST cotacao-item FIELDS(cod-emitente)
        WHERE cotacao-item.numero-ordem = bfprazo-compra.numero-ordem AND
              cotacao-item.it-codigo    = bfprazo-compra.it-codigo    AND
              cotacao-item.cot-aprovada = YES                         NO-LOCK: END.
       
    ASSIGN l-emb = NO.

    IF pdeQtdeEmbal <> 0 AND AVAIL cotacao-item THEN DO:
        
        FOR FIRST item-fornec NO-LOCK USE-INDEX onde-compra  WHERE
                  item-fornec.it-codigo    = bfprazo-compra.it-codigo  AND
                  item-fornec.cod-emitente = cotacao-item.cod-emitente AND
                  item-fornec.cod-embal <> "" :
                FIND embalag WHERE 
                     embalag.embalagem = item-fornec.cod-embal NO-LOCK NO-ERROR.
                     IF AVAIL embalag THEN DO:
                         ASSIGN pdePesoTotal = (pdeQtdeAlocar * ITEM.peso-bruto) + (pdeQtdeEmbal * embalag.peso-embal)
                                l-emb = YES.
                     END.             
            END.
    END.

        IF (pdeQtdeEmbal = 0 OR NOT l-emb) AND AVAIL item THEN
           ASSIGN pdePesoTotal = (pdeQtdeAlocar * ITEM.peso-bruto).
    
        IF pdePesoTotal = 0 AND AVAIL item THEN DO:
           RUN retornaQtdeSaldoDisp(INPUT bfprazo-compra.numero-ordem,
                                    INPUT bfprazo-compra.parcela,
                                    OUTPUT deQtdeDisp).
           ASSIGN pdePesoTotal = (deQtdeDisp * ITEM.peso-bruto).
        END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RetornaPesoUnitario DBOProgram 
PROCEDURE RetornaPesoUnitario :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prRowid         AS ROWID   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdePeso         AS DECIMAL NO-UNDO.

    FIND bfprazo-compra NO-LOCK WHERE 
         ROWID(bfprazo-compra) = prRowid NO-ERROR.

    DEF VAR l-emb        AS LOG NO-UNDO.

    FOR FIRST item FIELDS (peso-bruto) WHERE 
              item.it-codigo = bfprazo-compra.it-codigo NO-LOCK: END.

    ASSIGN l-emb = NO.

    FOR FIRST cotacao-item FIELDS(cod-emitente)
        WHERE cotacao-item.numero-ordem = bfprazo-compra.numero-ordem AND
              cotacao-item.it-codigo    = bfprazo-compra.it-codigo    AND
              cotacao-item.cot-aprovada = YES                         NO-LOCK: END.
    IF AVAIL cotacao-item THEN DO:
        
        FOR FIRST item-fornec NO-LOCK  USE-INDEX onde-compra  WHERE
                  item-fornec.it-codigo    = bfprazo-compra.it-codigo   AND
                  item-fornec.cod-emitente = cotacao-item.cod-emitente  AND 
                  item-fornec.cod-embal <> "" :
                  FIND embalag WHERE 
                       embalag.embalagem = item-fornec.cod-embal NO-LOCK NO-ERROR.
                  IF AVAIL embalag THEN DO:
                     FIND eq-item-embal-embarq NO-LOCK  WHERE
                          eq-item-embal-embarq.it-codigo = item-fornec.it-codigo AND
                          eq-item-embal-embarq.cod-embal = item-fornec.cod-embal AND 
                          eq-item-embal-embarq.qtd-item-embal > 0                NO-ERROR.
                     IF AVAIL eq-item-embal-embarq THEN DO:
                        ASSIGN pdePeso = (eq-item-embal-embarq.qtd-item-embal * ITEM.peso-bruto) + embalag.peso-embal
                               l-emb   = YES.
                     END.
                  END.             
        END.
    END.

    IF NOT l-emb THEN
       ASSIGN pdePeso = ITEM.peso-bruto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQtdeAlocar DBOProgram 
PROCEDURE retornaQtdeAlocar :
/*:T------------------------------------------------------------------------------
  Purpose:   Retorna quantidade da parcela a ser alocada  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT        PARAM pi-numero-ordem LIKE prazo-compra.numero-ordem  NO-UNDO.
    DEF INPUT        PARAM pi-parcela      LIKE prazo-compra.parcela       NO-UNDO.
    DEF INPUT-OUTPUT PARAM pde-qtd-disp    LIKE prazo-compra.quant-saldo   NO-UNDO.

    FOR EACH eq-simul-carg-ped
       WHERE eq-simul-carg-ped.numero-ordem = pi-numero-ordem
         AND eq-simul-carg-ped.nr-parcela   = pi-parcela NO-LOCK:

            /*--- parcelas de embarques em simulacao j  foram consideradas na procedure retornaQtdeSaldoDisp ---*/
            IF  CAN-FIND (FIRST eq-simul-carg
                          WHERE eq-simul-carg.cod-estabel    = eq-simul-carg-ped.cod-estabel  
                            AND eq-simul-carg.dat-planej     = eq-simul-carg-ped.dat-planej   
                            AND eq-simul-carg.hra-planej     = eq-simul-carg-ped.hra-planej   
                            AND eq-simul-carg.num-seq-simul  = eq-simul-carg-ped.num-seq-simul
                            AND eq-simul-carg.idi-situacao   = 2 /* em simulacao */ ) THEN 
                NEXT.

             ASSIGN pde-qtd-disp = pde-qtd-disp - eq-simul-carg-ped.qtd-alocada.       
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQtdeProcessoImp DBOProgram 
PROCEDURE retornaQtdeProcessoImp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pi-numero-ordem  LIKE ordem-compra.numero-ordem  NO-UNDO.
    DEF INPUT  PARAM pi-parcela       LIKE prazo-compra.parcela       NO-UNDO.
    DEF OUTPUT PARAM pde-qtd-processo LIKE ordens-embarque.quantidade NO-UNDO.

    FOR EACH ordens-embarque
        WHERE ordens-embarque.numero-ordem = pi-numero-ordem
          AND ordens-embarque.parcela      = pi-parcela NO-LOCK:

        IF  NOT CAN-FIND(FIRST eq-simul-carg
                      /*   WHERE eq-simul-carg.embarque = ordens-embarque.embarque */ ) THEN DO:
            ASSIGN pde-qtd-processo = pde-qtd-processo + ordens-embarque.quantidade.
        END.

    END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQtdeSaldoDisp DBOProgram 
PROCEDURE retornaQtdeSaldoDisp :
/*------------------------------------------------------------------------------
  Purpose: retornar o saldo da parcela, menos a quantidade alocada em embarques, 
           menos a quantidade alocada em processos de importa‡Æo
  Parameters: numero da ordem de compra
              numero da parcela
              retorna a quantidade disponivel
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pi-numero-ordem LIKE prazo-compra.numero-ordem  NO-UNDO.
    DEF INPUT  PARAM pi-parcela      LIKE prazo-compra.parcela       NO-UNDO.
    DEF OUTPUT PARAM pde-qtd-disp    LIKE prazo-compra.quant-saldo   NO-UNDO.

    DEF VAR de-qtd-praz-embarq       LIKE prazo-compra.quant-saldo   NO-UNDO.
    DEF VAR de-qtd-processo-imp      LIKE prazo-compra.quant-saldo   NO-UNDO.

    FIND prazo-compra 
         WHERE prazo-compra.numero-ordem = pi-numero-ordem
           AND prazo-compra.parcela      = pi-parcela NO-LOCK NO-ERROR.
    
    IF  AVAIL prazo-compra THEN DO:
        FOR EACH  eq-simul-carg-ped
            WHERE eq-simul-carg-ped.numero-ordem = pi-numero-ordem
              AND eq-simul-carg-ped.nr-parcela   = pi-parcela NO-LOCK:
    
            /*--- considera somente parcelas de embarques
                  em simulacao ---*/
            IF  NOT CAN-FIND (FIRST eq-simul-carg 
                              WHERE eq-simul-carg.cod-estabel    = eq-simul-carg-ped.cod-estabel  
                                AND eq-simul-carg.dat-planej     = eq-simul-carg-ped.dat-planej   
                                AND eq-simul-carg.hra-planej     = eq-simul-carg-ped.hra-planej   
                                AND eq-simul-carg.num-seq-simul  = eq-simul-carg-ped.num-seq-simul
                                AND eq-simul-carg.idi-situacao   = 2 /* em simulacao */) THEN
                NEXT.

            ASSIGN de-qtd-praz-embarq = de-qtd-praz-embarq + 
                                        eq-simul-carg-ped.qtd-alocada.

        END.
        
        /*
        RUN retornaQtdeProcessoImp(INPUT  pi-numero-ordem,
                                   INPUT  pi-parcela,
                                   OUTPUT de-qtd-processo-imp).
        */

        ASSIGN pde-qtd-disp = prazo-compra.quant-saldo - de-qtd-praz-embarq - de-qtd-processo-imp.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaQtdeSaldoDisp-1 DBOProgram 
PROCEDURE retornaQtdeSaldoDisp-1 :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prRowid         AS ROWID   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeQtdeSaldo    AS DECIMAL NO-UNDO.

    DEFINE VARIABLE deQtdeEmbarque          AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE deQtdeAlocada           AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE h-bocx225               AS HANDLE     NO-UNDO.

    RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

    FIND bf{&tableName} NO-LOCK WHERE 
         ROWID(bf{&tableName}) = prRowid NO-ERROR.

    /* Quantidade alocada da parcela em embarques */
    FOR EACH eq-simul-carg-ped WHERE
             eq-simul-carg-ped.numero-ordem = bf{&tableName}.numero-ordem AND
             eq-simul-carg-ped.nr-parcela   = bf{&tableName}.parcela  NO-LOCK:

        IF NOT CAN-FIND(FIRST eq-simul-carg WHERE 
                              eq-simul-carg.cod-estabel    = eq-simul-carg-ped.cod-estabel   AND
                              eq-simul-carg.dat-planej     = eq-simul-carg-ped.dat-planej    AND
                              eq-simul-carg.hra-planej     = eq-simul-carg-ped.hra-planej    AND
                              eq-simul-carg.num-seq-simul  = eq-simul-carg-ped.num-seq-simul AND
                              eq-simul-carg.idi-situacao   = 2 /* Em simulacao */) THEN NEXT.
        ASSIGN deQtdeEmbarque = deQtdeEmbarque + eq-simul-carg-ped.qtd-alocada.
    END.
        
    /* Quantidade alocada da parcela em processos de importacao sem embarque */
    RUN retorna_qtde_alocada IN h-bocx225 (INPUT bf{&tableName}.numero-ordem,
                                           INPUT bf{&tableName}.parcela,
                                           INPUT 0, /* TODO: Qtde de entrada deve ser zero? */
                                           OUTPUT deQtdeAlocada).

    /*- quantia alocada em embarques - quantia alocada da parcela em processos sem embarque*/
    ASSIGN pdeQtdeSaldo = bf{&tableName}.quant-saldo - deQtdeEmbarque - deQtdeAlocada.

    DELETE PROCEDURE h-bocx225.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RetornaVolumeTotal DBOProgram 
PROCEDURE RetornaVolumeTotal :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prRowid         AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pdeQtdeTotal    AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeVolumeTotal  AS DECIMAL NO-UNDO.

    DEF VAR de-volume AS DEC NO-UNDO.

    FIND bfprazo-compra NO-LOCK WHERE 
         ROWID(bfprazo-compra) = prRowid NO-ERROR.
    
    IF pdeQtdeTotal = 0 THEN
       RUN retornaQtdeSaldoDisp(INPUT bfprazo-compra.numero-ordem,
                                INPUT bfprazo-compra.parcela,
                                OUTPUT pdeQtdeTotal).

    RUN retornaVolumeUnitario IN THIS-PROCEDURE(INPUT prRowid, OUTPUT de-volume).

    ASSIGN pdeVolumeTotal = pdeQtdeTotal * de-volume.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RetornaVolumeUnitario DBOProgram 
PROCEDURE RetornaVolumeUnitario :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER prRowid      AS ROWID   NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeVolume    AS DECIMAL NO-UNDO.

    DEF VAR l-emb AS LOG NO-UNDO.

    FIND bfprazo-compra NO-LOCK WHERE 
         ROWID(bfprazo-compra) = prRowid NO-ERROR.

    ASSIGN l-emb = NO.
    FOR FIRST item FIELDS (altura largura comprim) WHERE 
              item.it-codigo = bfprazo-compra.it-codigo NO-LOCK: END.

    FOR FIRST cotacao-item FIELDS(cod-emitente)
        WHERE cotacao-item.numero-ordem = bfprazo-compra.numero-ordem AND
              cotacao-item.it-codigo    = bfprazo-compra.it-codigo    AND
              cotacao-item.cot-aprovada = YES                         NO-LOCK: END.

    IF AVAIL cotacao-item THEN DO:
       FOR FIRST item-fornec NO-LOCK  USE-INDEX onde-compra    WHERE
                 item-fornec.it-codigo    = bfprazo-compra.it-codigo   AND
                 item-fornec.cod-emitente = cotacao-item.cod-emitente  AND 
                 item-fornec.cod-embal <> "" :
              FIND embalag WHERE 
                   embalag.embalagem = item-fornec.cod-embal NO-LOCK NO-ERROR.
              IF AVAIL embalag THEN DO:
                 ASSIGN pdeVolume = embalag.volume
                        l-emb     = YES.
              END.
        END.
    END.

    IF NOT l-emb THEN 
       ASSIGN pdeVolume = item.altura * item.largura * item.comprim.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

