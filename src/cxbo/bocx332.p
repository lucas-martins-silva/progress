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
{include/i-prgvrs.i BOCX332 2.00.00.051 } /*** "010051" 11/12/2023 10:13:25 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx332 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS 
                 que cont²m a l½gica de neg½cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName              bocx332
&GLOBAL-DEFINE DBOVersion           1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName            movto-ato
&GLOBAL-DEFINE TableLabel           Movimentos Ato Concess½rio
&GLOBAL-DEFINE QueryName            qr{&TableName} 

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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m²todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que dÿ acessos a todos os registros, exceto os exclu­dos pela constraint de seguran»a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress n’o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini»’o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com 
      extens’o .i ---*/
{cxbo/bocx332.i RowObject}
{cxbo/bocx315.i tt-pedido-drb-item}

/*:T--- Include com defini»’o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini»’o de buffer que serÿ utilizado pelo m²todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var ccod-estabel-ini   like movto-ato.cod-estabel    initial "" no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var ccod-estabel-fim   like movto-ato.cod-estabel    initial "ZZZZZ" no-undo.
&ELSE
def var ccod-estabel-fim   like movto-ato.cod-estabel    initial "ZZZ" no-undo.
&ENDIF
def var cnr-pedido-drb-ini like movto-ato.nr-pedido-drb  initial "" no-undo.
def var cnr-pedido-drb-fim like movto-ato.nr-pedido-drb  initial "ZZZZZZZZZZZZZZZZ" no-undo.
def var cit-codigo-ini     like movto-ato.it-codigo      initial "" no-undo.
def var cit-codigo-fim     like movto-ato.it-codigo      initial "ZZZZZZZZZZZZZZZZ" no-undo.
def var csequencia-ini     like movto-ato.sequencia      initial "" no-undo.
def var csequencia-fim     like movto-ato.sequencia      initial "99999" no-undo.

def var c-cod-estabel      like movto-ato.cod-estabel    initial "" no-undo.
def var c-nr-pedido-drb    like movto-ato.nr-pedido-drb  initial "" no-undo.
def var c-it-codigo        like movto-ato.it-codigo      initial "" no-undo.
def var c-sequencia        like movto-ato.sequencia      initial "" no-undo.
DEF VAR c-trad-literal     as character                            no-undo.
DEF VAR c-trad-literal2    as character                            no-undo.
def var i-idi-tip-movto    like movto-ato.idi-tip-movto  initial 1 no-undo.
def var i-moeda            like movto-ato.mo-codigo      no-undo.
DEF VAR i-moeda-aux        LIKE movto-ato.mo-codigo      NO-UNDO.

DEFINE TEMP-TABLE tt-movto-ato NO-UNDO LIKE movto-ato .
DEFINE VARIABLE h-cxbo315   AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-exapi025  AS HANDLE      NO-UNDO.

DEFINE VARIABLE i-nivel           AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-programa        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-ultimo-programa AS CHARACTER NO-UNDO.
DEFINE VARIABLE r-rowidAux        AS ROWID     NO-UNDO.
DEFINE VARIABLE l-cria-automatico AS LOGICAL   NO-UNDO.

{cdp/cdcfgdis.i}   /* Defini»’o preprocessadores materiais*/
{cdp/cdcfgcex.i}   /* Defini»’o preprocessadores materiais*/
{utp/ut-glob.i}

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
         HEIGHT             = 24.21
         WIDTH              = 40.14.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*Vai calcular o saldo do item*/
    RUN pi-recompoe-saldo (INPUT RowObject.cod-estabel,
                           INPUT RowObject.nr-pedido-drb,
                           INPUT RowObject.it-codigo,
                           INPUT RowObject.idi-tip-item-movto).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualiza-valor-moeda DBOProgram 
PROCEDURE atualiza-valor-moeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER c-cod-estabel       LIKE  movto-ato.cod-estabel      NO-UNDO.
DEFINE INPUT  PARAMETER it-codigo           LIKE  movto-ato.it-codigo        NO-UNDO.
DEFINE INPUT  PARAMETER i-mo-codigo         LIKE  movto-ato.mo-codigo        NO-UNDO. 
DEFINE INPUT  PARAMETER da-dat-cotac        LIKE  movto-ato.dat-cotac        NO-UNDO.
DEFINE INPUT  PARAMETER de-val-movto-ato-me LIKE  movto-ato.val-movto-ato-me NO-UNDO.
DEFINE OUTPUT PARAMETER de-val-orig         AS   DECIMAL                     NO-UNDO.
DEFINE OUTPUT PARAMETER de-val-cotacao      LIKE movto-ato.cotacao           NO-UNDO.

DEFINE VARIABLE de-valor-conv AS DECIMAL    NO-UNDO.
DEFINE VARIABLE c-periodo     AS CHARACTER  NO-UNDO.

    ASSIGN i-moeda = i-mo-codigo.

    IF i-mo-codigo <> 0 THEN
        RUN cdp/cd0812.p (INPUT i-mo-codigo,
                          INPUT 0,
                          INPUT de-val-movto-ato-me,
                          INPUT da-dat-cotac,
                          OUTPUT de-valor-conv).
    ELSE
        ASSIGN de-valor-conv = de-val-movto-ato-me.

    ASSIGN c-periodo = STRING(YEAR(da-dat-cotac),"9999") + STRING(MONTH(da-dat-cotac),"99").

    FIND cotacao WHERE cotacao.mo-codigo = i-mo-codigo
                   AND cotacao.ano-periodo = c-periodo NO-LOCK NO-ERROR.
    IF  AVAIL cotacao THEN
        ASSIGN  de-val-orig = de-valor-conv
                de-val-cotacao = cotacao.cotacao[DAY(da-dat-cotac)].
    ELSE
        ASSIGN  de-val-orig = de-valor-conv
                de-val-cotacao = 0.
        
        
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo-saldo-itens DBOProgram 
PROCEDURE calculo-saldo-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER  c-cod-estabel        LIKE pedido-drb-item.cod-estabel.
    DEFINE INPUT  PARAMETER  nr-pedido-drb        LIKE pedido-drb-item.nr-pedido-drb.
    DEFINE INPUT  PARAMETER  c-it-codigo          LIKE pedido-drb-item.it-codigo. 
    DEFINE INPUT  PARAMETER  i-tip-item-movto     AS INTEGER.
    DEFINE OUTPUT PARAMETER  de-quant-saldo       AS DECIMAL.
    DEFINE OUTPUT PARAMETER  de-valor-saldo       AS DECIMAL.
    DEFINE OUTPUT PARAMETER  de-tot-quant-ent     AS DECIMAL.
    DEFINE OUTPUT PARAMETER  de-tot-quant-baixa   AS DECIMAL.

    DEFINE VARIABLE  de-tot-valor-ent           AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE  de-tot-valor-baixa         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE  de-valor-conv              AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE  de-valor-baixa             AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE  d-dt-cotac                 AS DATE       NO-UNDO.
    
    ASSIGN i-moeda-aux = 0.
    FIND FIRST pedido-drb-item
         WHERE pedido-drb-item.cod-estabel   = c-cod-estabel  
           AND pedido-drb-item.nr-pedido-drb = nr-pedido-drb
           AND pedido-drb-item.it-codigo     = c-it-codigo NO-LOCK NO-ERROR.
    IF AVAIL pedido-drb-item THEN DO:        
        IF i-tip-item-movto = 1 THEN 
            ASSIGN i-moeda-aux = pedido-drb-item.moeda.
        ELSE
            ASSIGN i-moeda-aux = pedido-drb-item.cdn-moed-nac.

        FOR EACH  bf{&TableName}
            WHERE bf{&TableName}.cod-estabel        = pedido-drb-item.cod-estabel
              AND bf{&TableName}.nr-pedido-drb      = pedido-drb-item.nr-pedido-drb
              AND bf{&tablename}.it-codigo          = pedido-drb-item.it-codigo
              AND bf{&tablename}.idi-tip-movto      = 1 /*Entrada*/ 
              AND bf{&tablename}.idi-tip-item-movto = i-tip-item-movto
              NO-LOCK:
                                                
              IF i-moeda-aux <> bf{&TableName}.mo-codigo  THEN DO:
                  /*Se as moedas forem diferentes buscar o emitente do movimento
                    para quando o movimento for nacional e a data da cota‡Æo nÆo estiver preenchida
                    pegar a data de movimento para realizar a conversÆo*/
                  FOR FIRST emitente NO-LOCK
                      WHERE emitente.cod-emitente = bf{&tablename}.cod-emitente: END.

                  ASSIGN d-dt-cotac = bf{&TableName}.dat-cotac.

                  IF d-dt-cotac = ? AND emitente.natureza < 3 AND bf{&TableName}.mo-codigo = 0 THEN
                      ASSIGN d-dt-cotac = bf{&TableName}.dat-movto.

                RUN cdp/cd0812.p (INPUT bf{&TableName}.mo-codigo,
                                  INPUT i-moeda-aux , 
                                  INPUT bf{&TableName}.val-movto-ato-me, 
                                  INPUT d-dt-cotac, 
                                  OUTPUT de-valor-conv).
              END.
              ELSE
                  ASSIGN de-valor-conv = bf{&TableName}.val-movto-ato-me.                  
                                              
              ASSIGN de-tot-quant-ent = de-tot-quant-ent + bf{&TableName}.val-quant-movto-ato.
                            
              IF de-valor-conv <> ? THEN
                 ASSIGN de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
              ELSE 
                  ASSIGN de-tot-valor-ent = de-tot-valor-ent + bf{&TableName}.val-movto-ato-me.                              
        END.
        
        FOR EACH  bf{&TableName}
            WHERE bf{&TableName}.cod-estabel       = pedido-drb-item.cod-estabel
              AND bf{&TableName}.nr-pedido-drb     = pedido-drb-item.nr-pedido-drb
              AND bf{&tablename}.it-codigo         = pedido-drb-item.it-codigo
              AND bf{&tablename}.idi-tip-movto     = 2 /*Baixa*/ 
              AND bf{&tablename}.idi-tip-item-movto = i-tip-item-movto 
              NO-LOCK:
          
            ASSIGN de-valor-baixa      = ((bf{&TableName}.val-quant-movto-ato  * de-tot-valor-ent ) / de-tot-quant-ent)
                   de-tot-quant-baixa  = de-tot-quant-baixa + bf{&TableName}.val-quant-movto-ato
                   de-tot-valor-baixa  = de-tot-valor-baixa  + de-valor-baixa .
        END.
    END.

    ASSIGN de-quant-saldo = de-tot-quant-ent - de-tot-quant-baixa
           de-valor-saldo = de-tot-valor-ent - de-tot-valor-baixa.
     
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo-tot-saldo-itens DBOProgram 
PROCEDURE calculo-tot-saldo-itens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER  c-cod-estabel        LIKE pedido-drb-item.cod-estabel.
    DEFINE INPUT  PARAMETER  nr-pedido-drb        LIKE pedido-drb-item.nr-pedido-drb.
    DEFINE INPUT  PARAMETER  c-it-codigo          LIKE pedido-drb-item.it-codigo. 
    DEFINE INPUT  PARAMETER  i-tip-item-movto     AS INTEGER.
    DEFINE OUTPUT PARAMETER  de-quant-saldo       AS DECIMAL.
    DEFINE OUTPUT PARAMETER  de-valor-saldo       AS DECIMAL.
    DEFINE OUTPUT PARAMETER  de-tot-quant-ent     AS DECIMAL.
    DEFINE OUTPUT PARAMETER  de-tot-quant-baixa   AS DECIMAL.

    DEFINE VARIABLE  de-tot-valor-ent           AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE  de-tot-valor-baixa         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE  de-valor-conv              AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE  de-valor-baixa             AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE  d-dt-cotac                 AS DATE       NO-UNDO.
    
    ASSIGN i-moeda-aux = 0.
    FIND FIRST pedido-drb-item
         WHERE pedido-drb-item.cod-estabel   = c-cod-estabel  
           AND pedido-drb-item.nr-pedido-drb = nr-pedido-drb
           AND pedido-drb-item.it-codigo     = c-it-codigo NO-LOCK NO-ERROR.
    IF AVAIL pedido-drb-item THEN DO:        
        IF i-tip-item-movto = 1 THEN 
            ASSIGN i-moeda-aux = pedido-drb-item.moeda.
        ELSE
            ASSIGN i-moeda-aux = pedido-drb-item.cdn-moed-nac.

        FOR EACH  bf{&TableName}
            WHERE bf{&TableName}.cod-estabel        = pedido-drb-item.cod-estabel
              AND bf{&TableName}.nr-pedido-drb      = pedido-drb-item.nr-pedido-drb
              AND bf{&tablename}.it-codigo          = pedido-drb-item.it-codigo
              AND bf{&tablename}.idi-tip-movto      = 1 /*Entrada*/ 
              /*AND bf{&tablename}.idi-tip-item-movto = i-tip-item-movto*/
              NO-LOCK:
                                                
              IF i-moeda-aux <> bf{&TableName}.mo-codigo  THEN DO:
                  /*Se as moedas forem diferentes buscar o emitente do movimento
                    para quando o movimento for nacional e a data da cota‡Æo nÆo estiver preenchida
                    pegar a data de movimento para realizar a conversÆo*/
                  FOR FIRST emitente NO-LOCK
                      WHERE emitente.cod-emitente = bf{&tablename}.cod-emitente: END.

                  ASSIGN d-dt-cotac = bf{&TableName}.dat-cotac.

                  IF d-dt-cotac = ? AND emitente.natureza < 3 AND bf{&TableName}.mo-codigo = 0 THEN
                      ASSIGN d-dt-cotac = bf{&TableName}.dat-movto.

                RUN cdp/cd0812.p (INPUT bf{&TableName}.mo-codigo,
                                  INPUT i-moeda-aux , 
                                  INPUT bf{&TableName}.val-movto-ato-me, 
                                  INPUT d-dt-cotac, 
                                  OUTPUT de-valor-conv).
              END.
              ELSE
                  ASSIGN de-valor-conv = bf{&TableName}.val-movto-ato-me.                  
                                              
              ASSIGN de-tot-quant-ent = de-tot-quant-ent + bf{&TableName}.val-quant-movto-ato.
                            
              IF de-valor-conv <> ? THEN
                 ASSIGN de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
              ELSE 
                  ASSIGN de-tot-valor-ent = de-tot-valor-ent + bf{&TableName}.val-movto-ato-me.                              
        END.
        
        FOR EACH  bf{&TableName}
            WHERE bf{&TableName}.cod-estabel       = pedido-drb-item.cod-estabel
              AND bf{&TableName}.nr-pedido-drb     = pedido-drb-item.nr-pedido-drb
              AND bf{&tablename}.it-codigo         = pedido-drb-item.it-codigo
              AND bf{&tablename}.idi-tip-movto     = 2 /*Baixa*/ 
              /*AND bf{&tablename}.idi-tip-item-movto = i-tip-item-movto */
              NO-LOCK:
          
            ASSIGN de-valor-baixa      = ((bf{&TableName}.val-quant-movto-ato  * de-tot-valor-ent ) / de-tot-quant-ent)
                   de-tot-quant-baixa  = de-tot-quant-baixa + bf{&TableName}.val-quant-movto-ato
                   de-tot-valor-baixa  = de-tot-valor-baixa  + de-valor-baixa .
        END.
    END.

    ASSIGN de-quant-saldo = de-tot-quant-ent - de-tot-quant-baixa
           de-valor-saldo = de-tot-valor-ent - de-tot-valor-baixa.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculo-saldo-itens-unif DBOProgram 
PROCEDURE calculo-saldo-itens-unif :
/*------------------------------------------------------------------------------
  Purpose:     Faz o mesmo que a procedure calculo-saldo-itens, mas soma o saldo
               Internacional e o Nacional.
  Parameters:  pcod-estabel       = C¢digo do Estabelecimento
               pnr-pedido-drb     = Nr. do pedido do Ato
               pit-codigo         = C¢digo do Item
               pd-qtd-saldo-aux   = Quantidade de Saldo
               pd-val-saldo-aux   = Valor do Saldo
               pd-tot-qtd-ent-aux = Quantidade Total
               pd-tot-qtd-sai-aux = Valor Total
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcod-estabel        LIKE pedido-drb-item.cod-estabel    NO-UNDO.
DEFINE INPUT  PARAMETER pnr-pedido-drb      LIKE pedido-drb-item.nr-pedido-drb  NO-UNDO.
DEFINE INPUT  PARAMETER pit-codigo          LIKE pedido-drb-item.it-codigo      NO-UNDO.
DEFINE OUTPUT PARAMETER pd-qtd-saldo-aux    AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER pd-val-saldo-aux    AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER pd-tot-qtd-ent-aux  AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER pd-tot-qtd-sai-aux  AS DECIMAL NO-UNDO.

DEFINE VARIABLE d-qtd-saldo-aux1    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-val-saldo-aux1    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-qtd-ent-aux1  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-qtd-sai-aux1  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-qtd-saldo-aux2    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-val-saldo-aux2    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-qtd-ent-aux2  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE d-tot-qtd-sai-aux2  AS DECIMAL     NO-UNDO.

RUN calculo-saldo-itens    (INPUT  pcod-estabel,
                            INPUT  pnr-pedido-drb,
                            INPUT  pit-codigo, 
                            INPUT  1, /*INTERNACIONAL */
                            OUTPUT d-qtd-saldo-aux1,
                            OUTPUT d-val-saldo-aux1,
                            OUTPUT d-tot-qtd-ent-aux1,
                            OUTPUT d-tot-qtd-sai-aux1).

RUN calculo-saldo-itens    (INPUT  pcod-estabel,
                            INPUT  pnr-pedido-drb,
                            INPUT  pit-codigo, 
                            INPUT  2, /*NACIONAL */
                            OUTPUT d-qtd-saldo-aux2,
                            OUTPUT d-val-saldo-aux2,
                            OUTPUT d-tot-qtd-ent-aux2,
                            OUTPUT d-tot-qtd-sai-aux2).

ASSIGN pd-qtd-saldo-aux   = d-qtd-saldo-aux1    + d-qtd-saldo-aux2
       pd-val-saldo-aux   = d-val-saldo-aux1    + d-val-saldo-aux2
       pd-tot-qtd-ent-aux = d-tot-qtd-ent-aux1  + d-tot-qtd-ent-aux2
       pd-tot-qtd-sai-aux = d-tot-qtd-sai-aux1  + d-tot-qtd-sai-aux2.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelaNotaFiscal DBOProgram 
PROCEDURE cancelaNotaFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.071" &THEN
   DEFINE INPUT PARAMETER pc-cod-estabel AS CHAR format "x(05)"  NO-UNDO.
&ELSE
   DEFINE INPUT PARAMETER pc-cod-estabel AS CHAR FORMAT "x(3)"  NO-UNDO.
&ENDIF
   DEFINE INPUT PARAMETER pc-nr-nota-fis AS CHAR FORMAT "x(16)" NO-UNDO.
   DEFINE INPUT PARAMETER pc-serie       AS CHAR FORMAT "x(5)"  NO-UNDO.

   FOR EACH movto-ato
      WHERE movto-ato.cod-estab-docto = pc-cod-estabel
        AND movto-ato.nro-docto       = pc-nr-nota-fis
        AND movto-ato.serie           = pc-serie NO-LOCK :

       FIND pedido-drb WHERE pedido-drb.cod-estabel   = movto-ato.cod-estabel
                         AND pedido-drb.nr-pedido-drb = movto-ato.nr-pedido-drb NO-LOCK NO-ERROR.
       
       IF  AVAIL pedido-drb AND
           pedido-drb.modalidade = 1 THEN DO:
           FIND nota-fiscal WHERE nota-fiscal.cod-estabel = pc-cod-estabel
                              AND nota-fiscal.serie       = pc-serie  
                              AND nota-fiscal.nr-nota-fis = pc-nr-nota-fis NO-LOCK NO-ERROR.
        
           IF  AVAIL nota-fiscal THEN DO:
               FIND emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente
                               AND emitente.nome-abrev   = nota-fiscal.nome-ab-cli NO-LOCK NO-ERROR .
        
               FIND it-nota-fisc WHERE it-nota-fisc.cod-estabel = movto-ato.cod-estab-docto
                                   AND it-nota-fisc.serie       = movto-ato.serie
                                   AND it-nota-fisc.nr-nota-fis = movto-ato.nro-docto
                                   AND it-nota-fisc.it-codigo   = movto-ato.it-codigo-re 
                                   AND it-nota-fisc.nr-seq-fat  = movto-ato.seq-docto NO-LOCK NO-ERROR.
               IF AVAIL it-nota-fisc THEN DO:
                   FIND natur-oper WHERE natur-oper.nat-operacao = it-nota-fisc.nat-operacao NO-LOCK NO-ERROR.
    
                   IF NOT AVAIL param-global THEN
                       FIND FIRST param-global NO-LOCK NO-ERROR.
    
                   IF  AVAIL emitente AND
                       (emitente.natureza = 3 OR emitente.natureza = 4) AND
                       param-global.modulo-07 AND param-global.modulo-ex AND /*M¢dulo de Importa‡Æo e Exporta‡Æo*/
                       (AVAIL natur-oper AND &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                                                 natur-oper.log-natur-operac-draw = YES)
                                            &ELSE 
                                                 SUBSTRING(natur-oper.CHAR-1,94,1) = "1") &ENDIF THEN DO:
    
                       RUN elimina-movto-baixa-suspensao (INPUT nota-fiscal.cod-estabel,
                                                          INPUT nota-fiscal.nr-nota-fis,
                                                          INPUT nota-fiscal.serie).
                   END.
               END.
           END.      
       END.
       ELSE IF  AVAIL pedido-drb AND 
                pedido-drb.modalidade = 2 THEN DO:
           
            FIND pedido-drb-re WHERE pedido-drb-re.cod-estabel   = movto-ato.cod-estabel    
                                 AND pedido-drb-re.nr-pedido-drb = movto-ato.nr-pedido-drb
                                 AND pedido-drb-re.nr-re         = movto-ato.num-re NO-LOCK NO-ERROR.

            IF  AVAIL pedido-drb-re THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber=28859
                                            &ErrorType="EMS"}
            END.
       END.
   END.
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-movimentos DBOProgram 
PROCEDURE elimina-movimentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER  c-cod-estabel        AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER  c-nr-pedido-drb      AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER  c-it-codigo          AS CHAR NO-UNDO.
    
   FOR EACH movto-ato WHERE movto-ato.cod-estabel       = c-cod-estabel
                        AND movto-ato.nr-pedido-drb     = c-nr-pedido-drb
                        AND movto-ato.it-codigo         = c-it-codigo 
                        AND movto-ato.idi-tip-movto     = i-idi-tip-movto EXCLUSIVE-LOCK:
      DELETE movto-ato.                       
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-movimentos-item-nota DBOProgram 
PROCEDURE elimina-movimentos-item-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-cod-estabel   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER c-nr-pedido-drb AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER c-it-codigo     AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p-cod-serie     LIKE nota-fiscal.serie         NO-UNDO.
DEFINE INPUT PARAMETER p-nro-docto     LIKE nota-fiscal.nr-nota-fis   NO-UNDO.
DEFINE INPUT PARAMETER p-natur-oper    LIKE docum-est.nat-operacao    NO-UNDO.
DEFINE INPUT PARAMETER p-cod-emitente  LIKE docum-est.cod-emitente    NO-UNDO.
DEFINE INPUT PARAMETER p-nr-sequencia  LIKE item-doc-est.sequencia    NO-UNDO.

    FOR EACH movto-ato WHERE movto-ato.cod-estabel   = c-cod-estabel
                        AND movto-ato.nr-pedido-drb  = c-nr-pedido-drb
                        AND movto-ato.it-codigo      = c-it-codigo 
                        AND movto-ato.idi-tip-movto  = i-idi-tip-movto 
                        AND movto-ato.serie          = p-cod-serie
                        AND movto-ato.nro-docto      = p-nro-docto
                        AND movto-ato.cod-emitente   = p-cod-emitente
                        AND movto-ato.nat-operacao   = p-natur-oper                   
                        AND movto-ato.seq-docto      = p-nr-sequencia EXCLUSIVE-LOCK:

        FOR EACH tab-ocor EXCLUSIVE-LOCK
            WHERE tab-ocor.cod-tab = 720 
            AND   TRIM(SUBSTRING(tab-ocor.char-1,76,5))       = c-cod-estabel
            AND   TRIM(SUBSTRING(tab-ocor.char-1,40,20))      = c-nr-pedido-drb
            AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))        = movto-ato.serie     
            AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))       = movto-ato.nro-docto 
            AND   TRIM(SUBSTRING(tab-ocor.char-1,22,6))       = movto-ato.nat-operacao
            AND   TRIM(SUBSTRING(tab-ocor.char-1,28,12))      = STRING(movto-ato.cod-emitente)
            AND   tab-ocor.int-1                              = movto-ato.seq-docto:

            DELETE tab-ocor.

        END.
        DELETE movto-ato.
   END.

   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-movto-baixa-suspensao DBOProgram 
PROCEDURE elimina-movto-baixa-suspensao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF "{&mguni_version}" >= "2.071" &THEN
    DEFINE INPUT PARAMETER c-cod-estabel AS CHAR format "x(05)"  NO-UNDO.
&ELSE
    DEFINE INPUT PARAMETER c-cod-estabel AS CHAR FORMAT "x(3)"  NO-UNDO.
&ENDIF
    DEFINE INPUT PARAMETER c-nr-nota-fis AS CHAR FORMAT "x(16)" NO-UNDO.
    DEFINE INPUT PARAMETER c-serie       AS CHAR FORMAT "x(5)"  NO-UNDO.
    
    DEFINE VARIABLE de-valor-baixa   AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-tot-quant-ent AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-tot-valor-ent AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-valor-conv    AS DECIMAL NO-UNDO.

    FOR EACH it-nota-fisc
       WHERE it-nota-fisc.cod-estabel = c-cod-estabel
         AND it-nota-fisc.nr-nota-fis = c-nr-nota-fis
         AND it-nota-fisc.serie       = c-serie NO-LOCK:

        FOR EACH movto-ato
           WHERE movto-ato.cod-estab-docto = it-nota-fisc.cod-estabel
             AND movto-ato.nro-docto       = it-nota-fisc.nr-nota-fis
             AND movto-ato.serie           = it-nota-fisc.serie
             AND movto-ato.seq-docto       = it-nota-fisc.nr-seq-fat
             AND movto-ato.it-codigo-re    = it-nota-fisc.it-codigo
             AND movto-ato.idi-tip-movto   = 2 EXCLUSIVE-LOCK:

            FIND pedido-drb-item
              WHERE pedido-drb-item.cod-estabel   = movto-ato.cod-estabel  
                AND pedido-drb-item.nr-pedido-drb = movto-ato.nr-pedido-drb
                AND pedido-drb-item.it-codigo     = movto-ato.it-codigo EXCLUSIVE-LOCK NO-ERROR.

            IF AVAIL pedido-drb-item THEN DO: 

                ASSIGN de-tot-quant-ent = 0
                       de-tot-valor-ent = 0.

                FOR EACH  bf{&TableName}
                    WHERE bf{&TableName}.cod-estabel       = pedido-drb-item.cod-estabel
                    AND   bf{&TableName}.nr-pedido-drb     = pedido-drb-item.nr-pedido-drb
                    AND   bf{&tablename}.it-codigo         = pedido-drb-item.it-codigo
                    AND   bf{&tablename}.idi-tip-movto     = 1 /*Entrada*/ NO-LOCK:

                    RUN cdp/cd0812.p (INPUT bf{&TableName}.mo-codigo,
                                      INPUT pedido-drb-item.moeda , 
                                      INPUT bf{&TableName}.val-movto-ato-me, 
                                      INPUT bf{&TableName}.dat-cotac, 
                                      OUTPUT de-valor-conv).

                    IF de-valor-conv = ? THEN
                        ASSIGN de-valor-conv =  bf{&TableName}.val-movto-ato-me.

                    ASSIGN de-tot-quant-ent = de-tot-quant-ent + bf{&TableName}.val-quant-movto-ato
                           de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
                END.

                &IF "{&bf_dis_versao_ems}" >= "2.06" &THEN
                    ASSIGN de-valor-baixa = (movto-ato.val-quant-movto-ato * de-tot-valor-ent) / de-tot-quant-ent
                           pedido-drb-item.qtd-sdo-item = pedido-drb-item.qtd-sdo-item + movto-ato.val-quant-movto-ato
                           pedido-drb-item.val-sdo-item = pedido-drb-item.val-sdo-item + de-valor-baixa .
                &ELSE
                    ASSIGN de-valor-baixa                       = (movto-ato.val-quant-movto-ato * de-tot-valor-ent) / de-tot-quant-ent
                           OVERLAY(pedido-drb-item.char-1,1,15) = STRING( dec(SUBSTR(pedido-drb-item.char-1,1,15)) + movto-ato.val-quant-movto-ato )
                           pedido-drb-item.dec-2                = pedido-drb-item.dec-2 + de-valor-baixa .
                &ENDIF
            END.
            DELETE movto-ato.
        END.
    END.

    RETURN "OK":U .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaMovtos DBOProgram 
PROCEDURE eliminaMovtos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter pRowid         as rowid   no-undo.
    define input  parameter pEliminaMovtos as logical no-undo. /** Efetiva a eliminacao dos movimentos  **/
    define input  parameter plRe0402       as logical no-undo. /** Desatualizacao de Documentos         **/
    define output parameter table for RowErrors.
    
    define variable deValMovtoAtoMeConv as decimal no-undo format ">,>>>,>>>,>>9.99":U.
    define variable deValBaixa          as decimal no-undo format ">,>>>,>>>,>>9.99":U.
    DEFINE VARIABLE de-tot-quant-ent    AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-tot-valor-ent    AS DECIMAL NO-UNDO.

    find item-doc-est where rowid(item-doc-est) = pRowid no-lock no-error.

    bloco: 
    do transaction:

        for each  movto-ato 
            where movto-ato.serie        = item-doc-est.serie-docto
              and movto-ato.nro-docto    = item-doc-est.nro-docto
              and movto-ato.cod-emitente = item-doc-est.cod-emitente
              and movto-ato.nat-operacao = item-doc-est.nat-operacao
              and movto-ato.seq-docto    = item-doc-est.sequencia exclusive-lock:
    
            find pedido-drb-item of movto-ato exclusive-lock no-error.
            if  avail pedido-drb-item then do:

                find pedido-drb of pedido-drb-item no-lock no-error.

                ASSIGN de-tot-quant-ent = 0
                       de-tot-valor-ent = 0
                       i-moeda-aux      = 0.

                    IF movto-ato.idi-tip-item-movto = 1 THEN
                        ASSIGN i-moeda-aux = pedido-drb-item.moeda.
                    ELSE
                        ASSIGN i-moeda-aux = pedido-drb-item.cdn-moed-nac.

                FOR EACH  bf{&TableName}
                    WHERE bf{&TableName}.cod-estabel       = pedido-drb-item.cod-estabel
                      AND bf{&TableName}.nr-pedido-drb     = pedido-drb-item.nr-pedido-drb
                      AND bf{&tablename}.it-codigo         = pedido-drb-item.it-codigo
                      AND bf{&tablename}.idi-tip-movto     = 1 /*Entrada*/
                      AND bf{&tablename}.idi-tip-item-movto = movto-ato.idi-tip-item-movto NO-LOCK:                    

                    IF i-moeda-aux <> bf{&TableName}.mo-codigo THEN
                        RUN cdp/cd0812.p (INPUT bf{&TableName}.mo-codigo,
                                          INPUT i-moeda-aux, 
                                          INPUT bf{&TableName}.val-movto-ato-me, 
                                          INPUT bf{&TableName}.dat-cotac, 
                                          OUTPUT deValMovtoAtoMeConv).
                    ELSE
                        ASSIGN deValMovtoAtoMeConv = bf{&TableName}.val-movto-ato-me.
                    
                    ASSIGN de-tot-quant-ent = de-tot-quant-ent + bf{&TableName}.val-quant-movto-ato
                           de-tot-valor-ent = de-tot-valor-ent + deValMovtoAtoMeConv.
                END.

                IF i-moeda-aux <> movto-ato.mo-codigo THEN
                    run cdp/cd0812.p (input  movto-ato.mo-codigo,
                                      input  i-moeda-aux,
                                      input  movto-ato.val-movto-ato-me,
                                      input  movto-ato.dat-cotac,
                                      output deValMovtoAtoMeConv).
                ELSE
                    ASSIGN deValMovtoAtoMeConv = movto-ato.val-movto-ato-me.

                if  movto-ato.idi-tip-movto = 1 then do:  /** Entrada **/ 
                   
                    IF movto-ato.idi-tip-item-movto = 1 THEN DO: /* internacional */
                        &if  "{&bf_dis_versao_ems}":U >= "2.06":U &then                                                   
                            assign pedido-drb-item.qtd-sdo-item = pedido-drb-item.qtd-sdo-item - movto-ato.val-quant-movto-ato
                                   pedido-drb-item.val-sdo-item = pedido-drb-item.val-sdo-item - deValMovtoAtoMeConv.
                        &else
                            assign OVERLAY(pedido-drb-item.char-1,1,15) = STRING( dec(SUBSTR(pedido-drb-item.char-1,1,15)) - 
                                                                                  movto-ato.val-quant-movto-ato )
                                   pedido-drb-item.dec-2                = pedido-drb-item.dec-2 - deValMovtoAtoMeConv.
                        &endif
                         IF pedido-drb.modalidade = 1 THEN /*SuspensÆo*/
                            ASSIGN pedido-drb-item.qtd-alocada-import  = pedido-drb-item.qtd-alocada-import + movto-ato.val-quant-movto-ato.
                    END.
                    ELSE DO: /* nacional */                        
                        ASSIGN pedido-drb-item.val-sdo-item-nac = pedido-drb-item.val-sdo-item-nac - deValMovtoAtoMeConv
                               pedido-drb-item.qtd-sdo-item-nac = pedido-drb-item.qtd-sdo-item-nac - movto-ato.val-quant-movto-ato.
                        IF pedido-drb.modalidade = 1 THEN /*SuspensÆo*/
                            ASSIGN pedido-drb-item.qtd-alocada-nac  = pedido-drb-item.qtd-alocada-nac + movto-ato.val-quant-movto-ato.                               
                    END.
                    
                end.
                else do: /** Baixa **/
                    IF movto-ato.idi-tip-item-movto = 1 THEN DO: /* internacional */
                        &if  "{&bf_dis_versao_ems}":U >= "2.06":U &then

                            IF movto-ato.idi-tip-movto = 3 /* Transferˆncia */ THEN
                                assign deValBaixa = movto-ato.val-movto-ato-me.
                            ELSE
                                assign deValBaixa = (movto-ato.val-quant-movto-ato * de-tot-valor-ent) / de-tot-quant-ent.

                            ASSIGN pedido-drb-item.qtd-sdo-item = pedido-drb-item.qtd-sdo-item + movto-ato.val-quant-movto-ato
                                   pedido-drb-item.val-sdo-item = pedido-drb-item.val-sdo-item + deValBaixa.                
                        &else
                            assign deValBaixa                           = (movto-ato.val-quant-movto-ato * de-tot-valor-ent) / de-tot-quant-ent
                                   OVERLAY(pedido-drb-item.char-1,1,15) = STRING(dec(SUBSTR(pedido-drb-item.char-1,1,15)) + movto-ato.val-quant-movto-ato)
                                   pedido-drb-item.dec-2                = pedido-drb-item.dec-2 + deValBaixa.
                        &endif
                        
                        IF pedido-drb.modalidade = 2 THEN
                            ASSIGN pedido-drb-item.qtd-alocada-import  = pedido-drb-item.qtd-alocada-import + movto-ato.val-quant-movto-ato.
                    END.
                    ELSE DO: /* nacional */
                        ASSIGN deValBaixa                       = (movto-ato.val-quant-movto-ato * de-tot-valor-ent) / de-tot-quant-ent
                               pedido-drb-item.val-sdo-item-nac = pedido-drb-item.val-sdo-item-nac + deValBaixa
                               pedido-drb-item.qtd-sdo-item-nac = pedido-drb-item.qtd-sdo-item-nac + movto-ato.val-quant-movto-ato.
                        IF pedido-drb.modalidade = 2 THEN
                             ASSIGN pedido-drb-item.qtd-alocada-nac  = pedido-drb-item.qtd-alocada-nac  + movto-ato.val-quant-movto-ato.
                    END.
                END.
            END.
            if  pEliminaMovtos then
                delete movto-ato.

        end.

        find pedido-drb of pedido-drb-item no-lock no-error.
        if  avail pedido-drb 
        and pedido-drb.modalidade = 1  /** Suspensao **/
        and dec(SUBSTR(pedido-drb-item.char-1,1,15)) < 0 then do:
       
            {method/svc/errors/inserr.i
                               &ErrorNumber="28963"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="item-doc-est.it-codigo"}                       
            undo bloco, return "NOK":U.

        end.

        /** Qndo for apenas validacao para verificar se o saldo do item ficara negativo,
            e nao houver erro, desfaz todas as alteracoes feitas no base de dados **/
        if  not pEliminaMovtos then
            undo bloco, return "NOK":U.

        if  plRe0402 then do: /** Desatualizacao Documentos **/

            find docum-est of item-doc-est exclusive-lock no-error.
            if  avail docum-est then
                /** Desatualiza Modulo de Drawback **/
                &if  "{&bf_dis_versao_ems}":U >= "2.06":U &then
                    assign docum-est.log-draw-atlzdo = no.
                &else
                    assign substr(docum-est.char-1,90,1) = "0".
                &endif
                
        end.
    end. 

    return "OK":U .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FormaValoresTotais DBOProgram 
PROCEDURE FormaValoresTotais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-cod-estabel     LIKE estabelec.cod-estabel         NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-pedido-drb   LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo       LIKE ITEM.it-codigo                NO-UNDO.
    DEFINE INPUT  PARAMETER pi-idi-tip-item-movto AS INTEGER.
    DEFINE OUTPUT PARAMETER de-qtde-tot-movto  LIKE movto-ato.val-quant-movto-ato NO-UNDO.
    DEFINE OUTPUT PARAMETER de-valor-tot-movto LIKE movto-ato.val-movto-ato-me    NO-UNDO. 
    
    DEFINE VARIABLE de-valor-conv AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE d-dt-cotac    AS DATE       NO-UNDO.

    ASSIGN de-valor-conv = 0.

    FIND FIRST pedido-drb-item
         WHERE pedido-drb-item.cod-estabel   = pc-cod-estabel  
           AND pedido-drb-item.nr-pedido-drb = pc-nr-pedido-drb
           AND pedido-drb-item.it-codigo     = pc-it-codigo NO-LOCK NO-ERROR.
    
    FOR EACH  bf{&TableName}
        WHERE bf{&TableName}.cod-estabel       = pedido-drb-item.cod-estabel
          AND bf{&TableName}.nr-pedido-drb     = pedido-drb-item.nr-pedido-drb
          AND bf{&tablename}.it-codigo         = pedido-drb-item.it-codigo
          AND bf{&tablename}.idi-tip-movto     = 1 /*Entrada*/ 
          AND bf{&tablename}.idi-tip-item-movto = pi-idi-tip-item-movto /*Entrada*/ NO-LOCK:
                
          /*
           pegar moeda de acordo com o tipo do movimento
          */
          IF pi-idi-tip-item-movto = 1 THEN /* internacional */
              ASSIGN i-moeda-aux = pedido-drb-item.moeda.
          ELSE /* nacional */
              ASSIGN i-moeda-aux = pedido-drb-item.cdn-moed-nac.

          IF i-moeda-aux <> bf{&TableName}.mo-codigo THEN DO: 
              /*Se as moedas forem diferentes buscar o emitente do movimento
                    para quando o movimento for nacional e a data da cota‡Æo nÆo estiver preenchida
                    pegar a data de movimento para realizar a conversÆo*/
              FOR FIRST emitente NO-LOCK
                      WHERE emitente.cod-emitente = bf{&tablename}.cod-emitente: END.

              ASSIGN d-dt-cotac = bf{&TableName}.dat-cotac.
              IF d-dt-cotac = ? AND emitente.natureza < 3 AND bf{&TableName}.mo-codigo = 0 THEN
                      ASSIGN d-dt-cotac = bf{&TableName}.dat-movto.

              RUN cdp/cd0812.p (INPUT bf{&TableName}.mo-codigo,
                                INPUT i-moeda-aux , 
                                INPUT bf{&TableName}.val-movto-ato-me, 
                                INPUT d-dt-cotac, 
                                OUTPUT de-valor-conv).
          END.
          ELSE
              ASSIGN de-valor-conv = bf{&TableName}.val-movto-ato-me.

        IF de-valor-conv = ? THEN
            ASSIGN de-valor-conv = 0.

        ASSIGN de-qtde-tot-movto  = de-qtde-tot-movto  + bf{&TableName}.val-quant-movto-ato
               de-valor-tot-movto = de-valor-tot-movto + de-valor-conv.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getcalculoSaldos DBOProgram 
PROCEDURE getcalculoSaldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-estabel    LIKE movto-ato.cod-estabel NO-UNDO.
DEFINE INPUT PARAMETER pnr-pedido-drb  LIKE movto-ato.nr-pedido-drb NO-UNDO.
DEFINE INPUT PARAMETER pit-codigo      LIKE movto-ato.it-codigo NO-UNDO.
DEFINE INPUT PARAMETER pmoeda          AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER de-saldo-valor AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER de-saldo-qtd   AS DECIMAL NO-UNDO.

DEF VAR de-valor-conv                  AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant-ent               AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor-ent               AS DECIMAL NO-UNDO.
DEF VAR de-tot-quant-baixa             AS DECIMAL NO-UNDO.
DEF VAR de-tot-valor-baixa             AS DECIMAL NO-UNDO.

   
   FOR EACH {&TableName} 
      WHERE {&TableName}.cod-estabel   = pcod-estabel 
        AND {&TableName}.nr-pedido-drb = pnr-pedido-drb
        AND {&tablename}.it-codigo     = pit-codigo
        AND {&tablename}.idi-tip-movto = 1 NO-LOCK:

        RUN cdp/cd0812.p (INPUT {&TableName}.mo-codigo,
                          INPUT pmoeda, 
                          INPUT {&TableName}.val-movto-ato-me , /*verificar */
                          INPUT {&TableName}.dat-decla-import,
                          OUTPUT de-valor-conv).
    
        ASSIGN de-tot-quant-ent = de-tot-quant-ent + {&TableName}.val-quant-movto-ato
               de-tot-valor-ent = de-tot-valor-ent + de-valor-conv.
    END.

   FOR EACH {&TableName} 
      WHERE {&TableName}.cod-estabel   = pcod-estabel 
        AND {&TableName}.nr-pedido-drb = pnr-pedido-drb
        AND {&tablename}.it-codigo     = pit-codigo
        AND {&tablename}.idi-tip-movto = 2 NO-LOCK:

        RUN cdp/cd0812.p (INPUT {&TableName}.mo-codigo,
                          INPUT pmoeda, 
                          INPUT {&TableName}.val-movto-ato-me ,
                          INPUT {&TableName}.dat-reg-export,
                          OUTPUT de-valor-conv).
    
        ASSIGN de-tot-quant-baixa = de-tot-quant-baixa + {&TableName}.val-quant-movto-ato
               de-tot-valor-baixa = de-tot-valor-baixa + de-valor-conv.
    END.

    ASSIGN de-saldo-valor = de-tot-valor-ent - de-tot-valor-baixa
           de-saldo-qtd   = de-tot-quant-ent - de-tot-quant-baixa .

    
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
    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdd-ncm":U THEN ASSIGN pFieldValue = RowObject.cdd-ncm.
        WHEN "cod-estab-docto":U THEN ASSIGN pFieldValue = RowObject.cod-estab-docto.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "declaracao-import":U THEN ASSIGN pFieldValue = RowObject.declaracao-import.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "it-codigo-re":U THEN ASSIGN pFieldValue = RowObject.it-codigo-re.
        WHEN "it-codigo-similar":U THEN ASSIGN pFieldValue = RowObject.it-codigo-similar.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nr-pedido-drb":U THEN ASSIGN pFieldValue = RowObject.nr-pedido-drb.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "num-re":U THEN ASSIGN pFieldValue = RowObject.num-re.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
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
    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-cotac":U THEN ASSIGN pFieldValue = RowObject.dat-cotac.
        WHEN "dat-decla-import":U THEN ASSIGN pFieldValue = RowObject.dat-decla-import.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-movto":U THEN ASSIGN pFieldValue = RowObject.dat-movto.
        WHEN "dat-nf":U THEN ASSIGN pFieldValue = RowObject.dat-nf.
        WHEN "dat-reg-export":U THEN ASSIGN pFieldValue = RowObject.dat-reg-export.
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
    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cotacao":U THEN ASSIGN pFieldValue = RowObject.cotacao.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-movto-ato-me":U THEN ASSIGN pFieldValue = RowObject.val-movto-ato-me.
        WHEN "val-movto-ato-orig":U THEN ASSIGN pFieldValue = RowObject.val-movto-ato-orig.
        WHEN "val-movto-ato-re-me":U THEN ASSIGN pFieldValue = RowObject.val-movto-ato-re-me.
        WHEN "val-peso":U THEN ASSIGN pFieldValue = RowObject.val-peso.
        WHEN "val-quant-movto-ato":U THEN ASSIGN pFieldValue = RowObject.val-quant-movto-ato.
        WHEN "val-quant-movto-ato-re":U THEN ASSIGN pFieldValue = RowObject.val-quant-movto-ato-re.
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
    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-tip-movto":U THEN ASSIGN pFieldValue = RowObject.idi-tip-movto.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "seq-docto":U THEN ASSIGN pFieldValue = RowObject.seq-docto.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice movtoato-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-pedido-drb
               retorna valor do campo it-codigo
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel   LIKE movto-ato.cod-estabel   NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedido-drb LIKE movto-ato.nr-pedido-drb NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo     LIKE movto-ato.it-codigo     NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia     LIKE movto-ato.sequencia     NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel   = RowObject.cod-estabel   
           pnr-pedido-drb = RowObject.nr-pedido-drb 
           pit-codigo     = RowObject.it-codigo     
           psequencia     = RowObject.sequencia .
           
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSequencia DBOProgram 
PROCEDURE getSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcod-estabel   LIKE movto-ato.cod-estabel   NO-UNDO.
  DEFINE INPUT PARAMETER pnr-pedido-drb LIKE movto-ato.nr-pedido-drb NO-UNDO.
  DEFINE INPUT PARAMETER pit-codigo     LIKE movto-ato.it-codigo     NO-UNDO.
  DEFINE OUTPUT PARAMETER i-seq         AS   INTEGER                 NO-UNDO.
  
  FIND LAST movto-ato
      WHERE movto-ato.cod-estabel   = pcod-estabel 
        AND movto-ato.nr-pedido-drb = pnr-pedido-drb
        AND movto-ato.it-codigo     = pit-codigo  NO-LOCK NO-ERROR.

  IF AVAIL movto-ato THEN
     ASSIGN i-seq = movto-ato.sequencia + 1 .
  ELSE
     ASSIGN i-seq = 1 .

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotaisItDrawback DBOProgram 
PROCEDURE getTotaisItDrawback :
/*------------------------------------------------------------------------------
  Purpose:     Calcula quantidade e valor baseado em
               todos os movimentos de entrada do Item do Pedido de Drawback
  Parameters:  
              Entrada:
               pc-cod-estabel        codigo do estabelecimento
               pc-nr-pedido-drb      numero do pedido de Drawback
               pc-it-codigo          codigo do Item
               pi-idi-tip-item-movto tipo de movimento
              
              Saida: 
               de-qtde-tot-movto    
               de-valor-tot-movto   
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel        LIKE estabelec.cod-estabel         NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-pedido-drb      LIKE pedido-drb-item.nr-pedido-drb NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo          LIKE ITEM.it-codigo                NO-UNDO.
    DEFINE INPUT  PARAMETER pi-idi-tip-item-movto AS INTEGER.
    DEFINE OUTPUT PARAMETER de-qtde-tot-movto     LIKE movto-ato.val-quant-movto-ato NO-UNDO.
    DEFINE OUTPUT PARAMETER de-valor-tot-movto    LIKE movto-ato.val-movto-ato-me    NO-UNDO. 
    
    DEFINE VARIABLE de-valor-conv AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE d-dt-cotac    AS DATE       NO-UNDO.

    ASSIGN de-valor-conv = 0.

    FIND FIRST pedido-drb-item
         WHERE pedido-drb-item.cod-estabel   = pc-cod-estabel  
           AND pedido-drb-item.nr-pedido-drb = pc-nr-pedido-drb
           AND pedido-drb-item.it-codigo     = pc-it-codigo NO-LOCK NO-ERROR.
    
    FOR EACH  bf{&TableName}
        WHERE bf{&TableName}.cod-estabel       = pedido-drb-item.cod-estabel
          AND bf{&TableName}.nr-pedido-drb     = pedido-drb-item.nr-pedido-drb
          AND bf{&tablename}.it-codigo         = pedido-drb-item.it-codigo
          AND bf{&tablename}.idi-tip-movto     = 1 /*Entrada*/ NO-LOCK:
                
          /*
           pegar moeda de acordo com o tipo do movimento
          */
          IF pi-idi-tip-item-movto = 1 THEN /* internacional */
              ASSIGN i-moeda-aux = pedido-drb-item.moeda.
          ELSE /* nacional */
              ASSIGN i-moeda-aux = pedido-drb-item.cdn-moed-nac.

          IF i-moeda-aux <> bf{&TableName}.mo-codigo THEN DO: 
              /*Se as moedas forem diferentes buscar o emitente do movimento
                    para quando o movimento for nacional e a data da cota‡Æo nÆo estiver preenchida
                    pegar a data de movimento para realizar a conversÆo*/
              FOR FIRST emitente NO-LOCK
                      WHERE emitente.cod-emitente = bf{&tablename}.cod-emitente: END.

              ASSIGN d-dt-cotac = bf{&TableName}.dat-cotac.
              IF d-dt-cotac = ? AND emitente.natureza < 3 AND bf{&TableName}.mo-codigo = 0 THEN
                      ASSIGN d-dt-cotac = bf{&TableName}.dat-movto.

              RUN cdp/cd0812.p (INPUT bf{&TableName}.mo-codigo,
                                INPUT i-moeda-aux , 
                                INPUT bf{&TableName}.val-movto-ato-me, 
                                INPUT d-dt-cotac, 
                                OUTPUT de-valor-conv).
          END.
          ELSE
              ASSIGN de-valor-conv = bf{&TableName}.val-movto-ato-me.

        IF de-valor-conv = ? THEN
            ASSIGN de-valor-conv = 0.

        ASSIGN de-qtde-tot-movto  = de-qtde-tot-movto  + bf{&TableName}.val-quant-movto-ato
               de-valor-tot-movto = de-valor-tot-movto + de-valor-conv.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice movtoato-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-pedido-drb
               recebe valor do campo it-codigo
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel   LIKE movto-ato.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE movto-ato.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo     LIKE movto-ato.it-codigo     NO-UNDO.
    DEFINE INPUT PARAMETER psequencia     LIKE movto-ato.sequencia     NO-UNDO.
    
    FIND FIRST bfmovto-ato WHERE 
        bfmovto-ato.cod-estabel   = pcod-estabel   AND 
        bfmovto-ato.nr-pedido-drb = pnr-pedido-drb AND 
        bfmovto-ato.it-codigo     = pit-codigo     AND 
        bfmovto-ato.sequencia     = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmovto-ato THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmovto-ato)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideAtoConcessorio DBOProgram 
PROCEDURE hideAtoConcessorio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter pCodEstabel   as character no-undo.
    define input  parameter pNatOperacao  as character no-undo.
    define input  parameter pCodEmitente  as integer   no-undo.
    define output parameter lReturn       as logical   no-undo.

    for first param-global fields (modulo-07 modulo-ex) no-lock: end.

    for first natur-oper   fields (terceiros tp-oper-terc char-1 &if "{&bf_dis_versao_ems}":U >= "2.06":U &then natur-oper.log-natur-operac-draw &endif)                                                                                      
        where natur-oper.nat-operacao = pNatOperacao no-lock: end.

    for first estabelec fields (pais) 
        where estabelec.cod-estabel = pCodEstabel no-lock: end.

    for first emitente fields (pais natureza)
        where emitente.cod-emitente = pCodEmitente no-lock: end.

    if  avail natur-oper
    and avail estabelec
    and avail emitente then
        assign lReturn = not((   (can-find (funcao where funcao.cd-funcao = "spp-drb-sld-terc":U and funcao.ativo))         
                             and natur-oper.terceiros                                                                       
                             and natur-oper.tp-oper-terc = 7
                             and param-global.modulo-07
                             and param-global.modulo-ex)                                                               
                             or  (   (not can-find(funcao where funcao.cd-funcao = "spp-drb-sld-terc":U and funcao.ativo))  
                                 and emitente.natureza > 2
                                 &if "{&bf_dis_versao_ems}":U >= "2.06":U &then                                             
                                 and natur-oper.log-natur-operac-draw                                                       
                                 &else                                                                                      
                                 and substring(natur-oper.char-1,94,1) = "1"                                                
                                 &endif
                                 and param-global.modulo-07
                                 and param-global.modulo-ex
                                 and estabelec.pais <> emitente.pais)).
    return "OK":U .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToMovto-ato DBOProgram 
PROCEDURE linkToMovto-ato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
  RUN getKey IN pHandle (OUTPUT c-cod-estabel,
                         OUTPUT c-nr-pedido-drb).

  RUN setConstraintMovto-ato IN THIS-PROCEDURE (INPUT c-cod-estabel,
                                                INPUT c-nr-pedido-drb).
  RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToPedido-drb-item DBOProgram 
PROCEDURE linkToPedido-drb-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
  RUN getKey IN pHandle (OUTPUT c-cod-estabel,
                         OUTPUT c-nr-pedido-drb,
                         OUTPUT c-it-codigo).
                                            
  RUN setConstraintPedido-drb-item IN THIS-PROCEDURE (INPUT c-cod-estabel,
                                                      INPUT c-nr-pedido-drb,
                                                      INPUT c-it-codigo).
  RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE naoRecalculaItensNota DBOProgram 
PROCEDURE naoRecalculaItensNota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM i-cod-emitente       LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAM c-serie-docto        LIKE item-doc-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAM c-nro-docto          LIKE item-doc-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAM c-nat-operacao       LIKE item-doc-est.nat-operacao NO-UNDO.

   /*Se a nota for complementar de importa»’o e CFOP iniciado em 1 ou 2 n’o se deve
    "recalcular" nada*/
    IF NOT AVAIL param-global THEN
       FIND FIRST param-global NO-LOCK NO-ERROR.

    IF param-global.modulo-07 THEN DO: /*m½dulo de importa»’o implantado*/
        FIND FIRST docum-est 
             WHERE docum-est.cod-emitente = i-cod-emitente
               AND docum-est.serie-docto  = c-serie-docto
               AND docum-est.nro-docto    = c-nro-docto
               AND docum-est.nat-operacao = c-nat-operacao NO-LOCK NO-ERROR.
        IF  AVAIL docum-est 
        AND TRIM(SUBSTRING(docum-est.char-1,1,20)) <> "" THEN DO: /*Notas fiscais que tenham embarque = Importa»’o*/
            FIND FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-ERROR.
            IF AVAIL natur-oper
                 AND natur-oper.nota-rateio /*Parametrizado cd0606 para nota de rateio = Complementar*/
                 AND (natur-oper.nat-operacao BEGINS "1" OR natur-oper.nat-operacao BEGINS "2") THEN /*C½digo Fiscal de opera»„es e presta»„es - CFOP*/
                                                                                                         /*Iniciado em 1 - Entrada e ou aquisi»„es de servi»os do estado*/
                                                                                                        /*Iniciado em 2 - Entrada e ou aquisi»„es de servi»os de outros estados */
                 RETURN "OK":U. /*N’o recalcula a nota*/
        END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodEstabel DBOProgram 
PROCEDURE openQueryCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.cod-estabel >= ccod-estabel-ini AND
             {&TableName}.cod-estabel <= ccod-estabel-fim
       BY {&TableName}.cod-estabel .
        
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItem DBOProgram 
PROCEDURE openQueryItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
       WHERE {&tablename}.it-codigo >= cit-codigo-ini and
             {&tablename}.it-codigo <= cit-codigo-fim
       BY {&tablename}.it-codigo .
  
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
 OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK .
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMovto-ato DBOProgram 
PROCEDURE openQueryMovto-ato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.cod-estabel   = c-cod-estabel 
           AND {&TableName}.nr-pedido-drb = c-nr-pedido-drb
           AND {&tablename}.it-codigo     = c-it-codigo
           AND {&TableName}.sequencia     = c-sequencia
            BY {&TableName}.cod-estabel .

 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedido-drb DBOProgram 
PROCEDURE openQueryPedido-drb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.nr-pedido-drb >= cnr-pedido-drb-ini and
             {&TableName}.nr-pedido-drb <= cnr-pedido-drb-fim
       BY {&TableName}.nr-pedido-drb .

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedido-drb-item DBOProgram 
PROCEDURE openQueryPedido-drb-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.cod-estabel   = c-cod-estabel   AND
             {&TableName}.nr-pedido-drb = c-nr-pedido-drb and
             {&tablename}.it-codigo     = c-it-codigo.

  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryPedido-drb-item-imp DBOProgram 
PROCEDURE OpenQueryPedido-drb-item-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.cod-estabel   = c-cod-estabel   AND
               {&TableName}.nr-pedido-drb = c-nr-pedido-drb AND
               {&tablename}.it-codigo     = c-it-codigo     AND
               {&tablename}.idi-tip-item-movto = 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryPedido-drb-item-nac DBOProgram 
PROCEDURE OpenQueryPedido-drb-item-nac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
         WHERE {&TableName}.cod-estabel   = c-cod-estabel   AND
               {&TableName}.nr-pedido-drb = c-nr-pedido-drb AND
               {&tablename}.it-codigo     = c-it-codigo     AND
               {&tablename}.idi-tip-item-movto = 2.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySequencia DBOProgram 
PROCEDURE openQuerySequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
       WHERE {&TableName}.sequencia >= csequencia-ini and
             {&TableName}.sequencia <= csequencia-fim
       BY {&TableName}.sequencia .

  RETURN "OK":U.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recompoe-saldo DBOProgram 
PROCEDURE pi-recompoe-saldo :
/*------------------------------------------------------------------------------
  Purpose:     Procedure que recalcula o saldo do item.
  Parameters:  c-cod-estabel    - C½digo do Estabelecimento
               c-nr-pedido-drb  - Nõ do pedido do Drawback
               c-it-codigo      - C½digo do Item
               i-tip-item-movto - Tipo 1 - Internacional 2 - Nacional
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER c-cod-estabel    LIKE pedido-drb-item.cod-estabel    NO-UNDO.
DEFINE INPUT PARAMETER c-nr-pedido-drb  LIKE pedido-drb-item.nr-pedido-drb  NO-UNDO.
DEFINE INPUT PARAMETER c-it-codigo      LIKE pedido-drb-item.it-codigo      NO-UNDO.
DEFINE INPUT PARAMETER i-tip-item-movto AS INTEGER NO-UNDO.


    DEFINE VARIABLE de-saldo-valor AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-saldo-qtd AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-val-aux AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-saldo-qtd-aux AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-saldo-qtd-ent AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-saldo-qtd-baixa AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-quant-saldo AS DECIMAL    NO-UNDO.

    RUN calculo-saldo-itens (INPUT c-cod-estabel,          
                             INPUT c-nr-pedido-drb,        
                             INPUT c-it-codigo,
                             INPUT i-tip-item-movto,     
                             OUTPUT de-saldo-qtd-aux,
                             OUTPUT de-val-aux,
                             OUTPUT de-saldo-qtd-ent,                       
                             OUTPUT de-saldo-qtd-baixa).    

        IF NOT VALID-HANDLE(h-cxbo315) THEN
             RUN cxbo/bocx315.p PERSISTENT SET h-cxbo315.
        RUN openQueryStatic   IN h-cxbo315 (INPUT 'main':U).
        RUN gotoKey           IN h-cxbo315 (INPUT c-cod-estabel,
                                           INPUT c-nr-pedido-drb,
                                           INPUT c-it-codigo). 
        IF RETURN-VALUE = "OK":U THEN DO:  
             RUN getRecord         IN h-cxbo315 (OUTPUT TABLE tt-pedido-drb-item).

             FIND FIRST tt-pedido-drb-item EXCLUSIVE-LOCK NO-ERROR.

             IF i-tip-item-movto = 1 THEN DO:                 
                     ASSIGN  tt-pedido-drb-item.val-sdo-item = de-val-aux /*- de-saldo-valor*/
                             tt-pedido-drb-item.qtd-sdo-item =  de-saldo-qtd-aux. /*- de-saldo-qtd.                 */
             END.
             ELSE DO: 
                 ASSIGN  tt-pedido-drb-item.val-sdo-item-nac =  de-val-aux /*- de-saldo-valor*/
                         tt-pedido-drb-item.qtd-sdo-item-nac =  de-saldo-qtd-aux. /* - de-saldo-qtd. */
             END.
             
             RUN setRecord         IN h-cxbo315 (INPUT  TABLE tt-pedido-drb-item).
             RUN updateRecord      IN h-cxbo315.             
        END.  

        IF VALID-HANDLE(h-cxbo315) THEN DO:
            DELETE PROCEDURE h-cxbo315.
            ASSIGN h-cxbo315 = ?.
        END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaIntNac DBOProgram 
PROCEDURE retornaIntNac :
/*------------------------------------------------------------------------------
  Purpose: retorna se o movimento ‚ nacional(2) ou internacional (1) de acordo com seu emitente    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM  i-cod-emitente AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM  c-cod-estabel  LIKE pedido-drb-item.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAM i-int-nac      AS INTEGER NO-UNDO.

    FIND FIRST emitente WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK NO-ERROR.
    FIND FIRST estabelec WHERE estabelec.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
        
    IF emitente.natureza > 2 AND 
       emitente.pais <> estabelec.pais THEN
        ASSIGN i-int-nac = 1. /*internacional*/
    ELSE
        ASSIGN i-int-nac = 2. /*nacional*/


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNomeEmitente DBOProgram 
PROCEDURE retornaNomeEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER i-cod-emitente   AS INTEGER   NO-UNDO.
    DEF OUTPUT PARAMETER d-nome-emitente AS CHARACTER NO-UNDO.

    FIND emitente WHERE emitente.cod-emitente= i-cod-emitente NO-LOCK NO-ERROR.

    IF AVAIL emitente THEN
        ASSIGN d-nome-emitente = emitente.nome-abrev.
    ELSE
        ASSIGN d-nome-emitente = ''.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEstabel DBOProgram 
PROCEDURE setConstraintCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcod-estabel-ini like movto-ato.cod-estabel no-undo.
def input param pcod-estabel-fim like movto-ato.cod-estabel no-undo.

  ASSIGN ccod-estabel-ini = pcod-estabel-ini
         ccod-estabel-fim = pcod-estabel-fim.

 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItem DBOProgram 
PROCEDURE setConstraintItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pit-codigo-ini LIKE movto-ato.it-codigo NO-UNDO. 
DEF INPUT PARAM pit-codigo-fim LIKE movto-ato.it-codigo NO-UNDO.

  ASSIGN cit-codigo-ini = pit-codigo-ini
         cit-codigo-fim = pit-codigo-fim.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMovto-ato DBOProgram 
PROCEDURE setConstraintMovto-ato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-estabel   LIKE movto-ato.cod-estabel   NO-UNDO.
DEFINE INPUT PARAMETER pnr-pedido-drb LIKE movto-ato.nr-pedido-drb NO-UNDO.

  ASSIGN c-cod-estabel   = pcod-estabel  
         c-nr-pedido-drb = pnr-pedido-drb .

 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedido-drb DBOProgram 
PROCEDURE setConstraintPedido-drb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ppedido-drb-ini LIKE movto-ato.nr-pedido-drb NO-UNDO. 
DEF INPUT PARAM ppedido-drb-fim LIKE movto-ato.nr-pedido-drb NO-UNDO.

  ASSIGN cnr-pedido-drb-ini = ppedido-drb-ini
         cnr-pedido-drb-fim = ppedido-drb-fim.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedido-drb-item DBOProgram 
PROCEDURE setConstraintPedido-drb-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM p-cod-estabel   LIKE movto-ato.cod-estabel   NO-UNDO. 
  DEF INPUT PARAM p-nr-pedido-drb LIKE movto-ato.nr-pedido-drb NO-UNDO.
  DEF INPUT PARAM p-it-codigo     LIKE movto-ato.it-codigo     NO-UNDO.
 
  ASSIGN c-cod-estabel   = p-cod-estabel
         c-nr-pedido-drb = p-nr-pedido-drb
         c-it-codigo     = p-it-codigo.
                                                   
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSequencia DBOProgram 
PROCEDURE setConstraintSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM psequencia-ini LIKE movto-ato.sequencia NO-UNDO. 
DEF INPUT PARAM psequencia-fim LIKE movto-ato.sequencia NO-UNDO.

  ASSIGN csequencia-ini = psequencia-ini
         csequencia-fim = psequencia-fim.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setIdi-tip-movto DBOProgram 
PROCEDURE setIdi-tip-movto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pidi-tip-movto LIKE movto-ato.idi-tip-movto NO-UNDO.

  ASSIGN i-idi-tip-movto = pidi-tip-movto.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validadocumento DBOProgram 
PROCEDURE validadocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER c-mod           AS CHARACTER                      NO-UNDO.
  DEFINE INPUT PARAMETER idi-tip-movto   AS INTEGER                        NO-UNDO.
  DEFINE INPUT PARAMETER serie           LIKE tt-movto-ato.serie           NO-UNDO.
  DEFINE INPUT PARAMETER nro-docto       LIKE tt-movto-ato.nro-docto       NO-UNDO.
  DEFINE INPUT PARAMETER cod-emitente    LIKE tt-movto-ato.cod-emitente    NO-UNDO.
  DEFINE INPUT PARAMETER nat-operacao    LIKE tt-movto-ato.nat-operacao    NO-UNDO.
  DEFINE INPUT PARAMETER cod-estab-docto LIKE tt-movto-ato.cod-estab-docto NO-UNDO.
  
  FIND FIRST RowObject NO-ERROR.
  
  IF c-mod = "Suspensao" THEN DO:
       /*Entrada*/
      IF idi-tip-movto = 1 THEN DO:
         FIND docum-est WHERE docum-est.serie-docto  = serie
                          AND docum-est.nro-docto    = nro-docto
                          AND docum-est.cod-emitente = cod-emitente
                          AND docum-est.nat-operacao = nat-operacao NO-LOCK NO-ERROR.

         IF NOT AVAIL docum-est THEN
            RETURN "Entrada":U.
      END.
      /*Baixa*/
      IF idi-tip-movto = 2 THEN DO:
      
         FIND nota-fiscal WHERE nota-fiscal.cod-estabel = cod-estab-docto
                            AND nota-fiscal.serie       = serie
                            AND nota-fiscal.nr-nota-fis = nro-docto NO-LOCK NO-ERROR.

         IF NOT AVAIL nota-fiscal THEN
            RETURN "Baixa":U.
      END.
  END.      

  IF c-mod = "Isencao" THEN DO:
      FIND docum-est WHERE docum-est.serie-docto  = serie
                       AND docum-est.nro-docto    = nro-docto
                       AND docum-est.cod-emitente = cod-emitente
                       AND docum-est.nat-operacao = nat-operacao NO-LOCK NO-ERROR.

      IF NOT AVAIL docum-est THEN
         RETURN "Entrada":U.
  END.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaquantvalor DBOProgram 
PROCEDURE validaquantvalor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter c-modalidade       as character no-undo.
    define input parameter i-tip-movto        as integer   no-undo.
    define input parameter de-quant-movto-ato as decimal   no-undo.
    define input parameter de-val-movto-ato   as decimal   no-undo.
    define input parameter c-saldo-quant      as decimal   no-undo.
    define input parameter c-saldo-valor      as decimal   no-undo.
    define input parameter d-quant-ant        as decimal   no-undo.
    define input parameter d-valor-ant        as decimal   no-undo.
    define input parameter c-tip-alteracao    as character no-undo.
    define input parameter i-tip-item-movto   as integer   no-undo. /*Nacional ou Internacional*/
   
    define variable c-return              as character no-undo.
    define variable c-return1             as character no-undo.
    define variable d-tot-quant           as decimal   no-undo.
    define variable d-tot-valor           as decimal   no-undo.
    define variable d-quantidade          as decimal   no-undo.
    define variable d-valor               as decimal   no-undo.
    define variable de-quant-saldo        as decimal   no-undo.
    define variable de-qnt-saldo-tot       as decimal   no-undo.
    define variable de-valor-saldo        as decimal   no-undo.
    define variable de-quant-saldo-ent    as decimal   no-undo.
    define variable de-valor-saldo-ent    as decimal   no-undo.
    define variable de-quant-saldo-baixa  as decimal   no-undo.
    define variable de-valor-saldo-baixa  as decimal   no-undo.
    define variable de-qtde-tot-movto     like movto-ato.val-quant-movto-ato no-undo.
    define variable de-valor-tot-movto    like movto-ato.val-movto-ato-me    no-undo.
    define variable de-saldo-valor        as decimal                         no-undo.
    define variable de-saldo-qtd          as decimal                         no-undo.

    find first RowObject no-error.

    /*
    de-val-movto-ato         = estrangeiro
    d-valor       = nacional
    c-saldo-valor = nacional
    d-valor-ant   = estrangeiro
    */

    find pedido-drb-item
        where pedido-drb-item.cod-estabel   = RowObject.cod-estabel  
        and   pedido-drb-item.nr-pedido-drb = RowObject.nr-pedido-drb
        and   pedido-drb-item.it-codigo     = RowObject.it-codigo no-lock no-error.
    
    IF AVAIL pedido-drb-item THEN DO:
        RUN cdp/cd0812.p (INPUT i-moeda, /*moeda de origem do movto-ato*/
                          INPUT pedido-drb-item.moeda,
                          INPUT de-val-movto-ato,
                          INPUT TODAY,
                          OUTPUT de-val-movto-ato).

        RUN cdp/cd0812.p (INPUT RowObject.mo-codigo, /*moeda anterior ainda nao gravada*/
                          INPUT pedido-drb-item.moeda,
                          INPUT d-valor-ant,
                          INPUT TODAY,
                          OUTPUT d-valor-ant).
    END.
    
    if  c-modalidade = 'Suspensao':U then do:
        if  i-tip-movto = 1 then do: /*Entrada*/
            assign d-quantidade = de-quant-movto-ato + c-saldo-quant 
                   d-valor      = de-val-movto-ato   + c-saldo-valor.
    
            if  c-tip-alteracao = 'UPDATE':U THEN DO:
                assign d-quantidade = d-quantidade - d-quant-ant
                       d-valor      = d-valor      - d-valor-ant.
            END.
                
        end.
    end.
    
    if  c-modalidade = 'Suspensao':U 
    or  c-modalidade = 'Isencao':U then do:
  
        if  i-tip-movto = 2  then do: /*Baixa*/
  
            if  c-tip-alteracao = 'UPDATE':U then do:
  
                assign d-quantidade = (c-saldo-quant + d-quant-ant) - de-quant-movto-ato
                       d-valor      = (c-saldo-valor + d-valor-ant) - de-val-movto-ato .

                if i-tip-item-movto = 1 then 
                    assign  de-qnt-saldo-tot = c-saldo-quant + pedido-drb-item.qtd-sdo-item-nac when avail pedido-drb-item.
                                
                else
                    assign  de-qnt-saldo-tot = c-saldo-quant + pedido-drb-item.qtd-sdo-item when avail pedido-drb-item.

                if  de-quant-movto-ato > (d-quant-ant + de-qnt-saldo-tot) then
                    assign c-return = "quantmovto":U.
            end.
            else do:
                IF i-tip-item-movto = 1 THEN 
                    ASSIGN de-qnt-saldo-tot = c-saldo-quant + pedido-drb-item.qtd-sdo-item-nac when avail pedido-drb-item.
                ELSE 
                    ASSIGN de-qnt-saldo-tot = c-saldo-quant + pedido-drb-item.qtd-sdo-item when avail pedido-drb-item.
                  
                assign d-quantidade = c-saldo-quant - de-quant-movto-ato
                       d-valor      = c-saldo-valor - de-val-movto-ato.
               
                if  de-quant-movto-ato > de-qnt-saldo-tot then
                    assign c-return = "quantmovto":U.
            end.
        end.
    end.

    if  avail pedido-drb-item 
        AND   c-modalidade = 'Suspensao':U
        AND   i-tip-movto = 1 then do: /*Entrada*/
  
        if i-tip-item-movto = 1 then /* internacional */ do:

            if  d-quantidade > pedido-drb-item.quantidade then
                assign c-return = "quantidade":U.
                          
            if  d-valor > pedido-drb-item.preco-fob then
                assign c-return1 = "valor":U.
        end.
        else do: /* nacional */
        
            if  d-quantidade > pedido-drb-item.qtd-item-nac then
                assign c-return = "quantidade":U.
                          
            if  d-valor > pedido-drb-item.val-fob-nac then
                assign c-return1 = "valor":U.
        end.
    end.
  
    if  c-modalidade = 'Suspensao':U 
    or  c-modalidade = 'Isencao':U then do:

        /* Calcula os valores e quantidades totais dos movimentos ja existentes para o item do pedido de drawback */
        RUN getTotaisItDrawback IN THIS-PROCEDURE (INPUT pedido-drb-item.cod-estabel,
                                                   INPUT pedido-drb-item.nr-pedido-drb,
                                                   INPUT pedido-drb-item.it-codigo,
                                                   INPUT i-tip-item-movto,
                                                   OUTPUT de-qtde-tot-movto,
                                                   OUTPUT de-valor-tot-movto).
        

        IF i-tip-movto = 1 THEN /*Entrada*/
            ASSIGN de-valor-tot-movto = de-valor-tot-movto + de-val-movto-ato 
                   de-qtde-tot-movto  = de-qtde-tot-movto  + de-quant-movto-ato.
        ELSE DO: /*Baixa*/
            ASSIGN de-saldo-valor = pedido-drb-item.val-sdo-item + pedido-drb-item.val-sdo-item-nac
                   de-saldo-qtd   = pedido-drb-item.qtd-sdo-item + pedido-drb-item.qtd-sdo-item-nac.


            IF de-saldo-valor > de-valor-tot-movto THEN
                ASSIGN de-valor-tot-movto = de-valor-tot-movto + de-val-movto-ato.
    
            IF de-saldo-qtd   >  de-qtde-tot-movto THEN
                 ASSIGN de-qtde-tot-movto  = de-qtde-tot-movto  + de-quant-movto-ato.
        END.

        if  c-tip-alteracao = 'UPDATE':U
        and i-tip-movto     = 1 then do: /*Entrada*/
            
              assign de-valor-tot-movto  = de-valor-tot-movto - c-saldo-valor 
                     de-qtde-tot-movto   = (de-quant-movto-ato + c-saldo-quant) - d-quantidade.

        END.

        IF  de-qtde-tot-movto > (pedido-drb-item.quantidade + pedido-drb-item.qtd-item-nac)
        AND d-quant-ant <> de-quant-movto-ato THEN
            ASSIGN c-return1 = "qtde_tot":U.
        
        run calculo-tot-saldo-itens in this-procedure (input  pedido-drb-item.cod-estabel,       
                                                       input  pedido-drb-item.nr-pedido-drb,
                                                       input  pedido-drb-item.it-codigo,    
                                                       INPUT  i-tip-item-movto,
                                                       output de-quant-saldo,               
                                                       output de-valor-saldo,
                                                       output de-quant-saldo-ent,
                                                       output de-quant-saldo-baixa). 
      
        if  c-tip-alteracao = 'UPDATE':U then do:
  
            if  i-tip-movto = 1 then do: /*Entrada*/
                assign de-quant-saldo       = de-quant-saldo + (de-quant-movto-ato) - RowObject.val-quant-movto-ato
                       de-quant-saldo-ent   = de-quant-saldo-ent + (de-quant-movto-ato) - RowObject.val-quant-movto-ato. 
            end.
            else do:
                assign de-quant-saldo         = d-quantidade
                       de-quant-saldo-baixa   = de-quant-saldo-baixa - d-quant-ant + de-quant-movto-ato. 
            end.
        end.
  
        if  c-tip-alteracao = 'DELETE':U then do:
  
            if  i-tip-movto = 1 then do: /*Entrada*/
                assign de-quant-saldo     = de-quant-saldo     - (de-quant-movto-ato)   
                       de-quant-saldo-ent = de-quant-saldo-ent - (de-quant-movto-ato). 
            end.
            else do:
                assign de-quant-saldo       = de-quant-saldo       - (de-quant-movto-ato)
                       de-quant-saldo-baixa = de-quant-saldo-baixa - (de-quant-movto-ato). 
            end.
        end.
  
        if  de-quant-saldo < 0
        or  de-quant-saldo-ent < de-quant-saldo-baixa then
            assign c-return = "de-quant-saldo":U.
    end.

    if  c-return = "quantidade":U then do:
        {utp/ut-liter.i "Quantidade_ultrapassou_os_valores_iniciais" *}
        ASSIGN c-trad-literal = RETURN-VALUE.
        {utp/ut-liter.i "A_quantidade_nÆo_pode_ultrapassar_os_valores_iniciais_cadastrados_para_o_Item" *}
        ASSIGN c-trad-literal2 = RETURN-VALUE.

        {method/svc/errors/inserr.i
           &ErrorNumber=17006
           &ErrorType="EMS"
           &ErrorParameters="c-trad-literal + '.' + '~~~~' + c-trad-literal2 + '.'"}
    end.
      
    if  c-return1 = "valor":U then do:
        {utp/ut-liter.i "Valor_ultrapassou_os_valores_iniciais" *}
        ASSIGN c-trad-literal = RETURN-VALUE.
        {utp/ut-liter.i "O_valor_nÆo_pode_ultrapassar_os_valores_iniciais_cadastrados_para_o_Item" *}
        ASSIGN c-trad-literal2 = RETURN-VALUE.

        {method/svc/errors/inserr.i
           &ErrorNumber=17006
           &ErrorType="EMS"
           &ErrorParameters="c-trad-literal + '.' + '~~~~' + c-trad-literal2 + '.'"}
    end.
      
    if  c-return = "quantmovto":U then do:
        {utp/ut-liter.i "Quantidade_ultrapassou_os_valores_dos_movimentos_de_entrada_para_o_item" *}
        ASSIGN c-trad-literal = RETURN-VALUE.
        {utp/ut-liter.i "A_quantidade_nÆo_pode_ultrapassar_os_valores_dos_movimentos_de_entrada_para_o_item" *}
        ASSIGN c-trad-literal2 = RETURN-VALUE.

        {method/svc/errors/inserr.i
           &ErrorNumber=17006
           &ErrorType="EMS"
           &ErrorParameters="c-trad-literal + '.' + '~~~~' + c-trad-literal2 + '.'"}
    end.
      
    if  c-return = "de-quant-saldo":U then do:
        
        {utp/ut-liter.i "O_saldo_quantidade_do_item_se_tornou_negativo" *}
        ASSIGN c-trad-literal = RETURN-VALUE.
        {utp/ut-liter.i "O_saldo_quantidade_do_item_nÆo_poderÿ_ser_negativo" *}
        ASSIGN c-trad-literal2 = RETURN-VALUE.

        {method/svc/errors/inserr.i
            &ErrorNumber=17006
            &ErrorType="EMS"
            &ErrorParameters="c-trad-literal + '.' + '~~~~' + c-trad-literal2 + '.'"}
    end.

    if  c-return1 = "qtde_tot":U then do:
        {utp/ut-liter.i "Quantidade_ultrapassou_os_valores_dos_movimentos_de_entrada_para_o_item" *}
        ASSIGN c-trad-literal = RETURN-VALUE.
        {utp/ut-liter.i "A_quantidade_nÆo_pode_ultrapassar_os_valores_dos_movimentos_de_entrada_para_o_item" *}
        ASSIGN c-trad-literal2 = RETURN-VALUE.

        {method/svc/errors/inserr.i
           &ErrorNumber=17006
           &ErrorType="EMS"
           &ErrorParameters="c-trad-literal + '.' + '~~~~' + c-trad-literal2 + '.'"}
    end.
    

    /*--- Verifica ocorr¼ncia de erros ---*/
    if  can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
                
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida»„es pertinentes ao DBO
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*:T--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida»„es ---*/

    IF pType = "Create":U THEN DO:
        IF CAN-FIND(FIRST bfmovto-ato
                    WHERE bfmovto-ato.cod-estabel   = RowObject.cod-estabel  
                      AND bfmovto-ato.nr-pedido-drb = RowObject.nr-pedido-drb
                      AND bfmovto-ato.it-codigo     = RowObject.it-codigo    
                      AND bfmovto-ato.sequencia     = RowObject.sequencia NO-LOCK) THEN DO:
            
            {utp/ut-liter.i "MOVTO-ATO" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                &ErrorNumber=1
                &ErrorType="EMS"
                &ErrorParameters="c-trad-literal"}
        END.
    END.
    IF pType = "Create":U OR pType = "Update":U THEN DO:
        
       IF RowObject.cod-estabel = "" OR
          RowObject.cod-estabel = ? THEN DO:
            
            {utp/ut-liter.i "Estabelecimento~~~~Movto-ato" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=6216
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.nr-pedido-drb = "" OR 
          RowObject.nr-pedido-drb = ? THEN DO:
            
            {utp/ut-liter.i "Nr._Pedido_Drawback~~~~Movto-ato" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=6216
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.it-codigo = "" OR 
          RowObject.it-codigo = ? THEN DO:
            
            {utp/ut-liter.i "Item~~~~Movto-ato" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=6216
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.sequencia = 0 OR
          RowObject.sequencia = ? THEN DO:
            
            {utp/ut-liter.i "Sequˆncia~~~~Movto-ato" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=6216
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.nat-operacao = "" OR
          RowObject.nat-operacao = ? THEN DO:
            
            {utp/ut-liter.i "Nat_Opera‡Æo" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=25938
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.cod-emitente <= 0 OR
          RowObject.cod-emitente = ? THEN DO:
            
            {utp/ut-liter.i "Emitente" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=25938
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.dat-movto = ? THEN DO:
            
            {utp/ut-liter.i "Data_Movto" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=25938
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.dat-nf = ? THEN DO:
            
            {utp/ut-liter.i "Data_Nota" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=25938
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.un = "" OR 
          RowObject.un = ? THEN DO:
            
            {utp/ut-liter.i "UN" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=25938
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.mo-codigo < 0 OR
          RowObject.mo-codigo = ? THEN DO:
            
            {utp/ut-liter.i "Moeda" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=25938
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.nro-docto = "" OR
          RowObject.nro-docto = ? THEN DO:
            
            {utp/ut-liter.i "Documento/NF" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=25938
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       IF RowObject.cdd-ncm = "" OR
          RowObject.cdd-ncm = ? THEN DO:
            
            {utp/ut-liter.i "Cod._Ncm" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i
                        &ErrorNumber=25938
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal"}
       END.
       
       IF NOT CAN-FIND (FIRST estabelec
                        WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK) THEN DO:
           
           
           {utp/ut-liter.i "Estabelecimento" *}
           ASSIGN c-trad-literal = RETURN-VALUE.
           {utp/ut-liter.i "Estabelec" *}
           ASSIGN c-trad-literal2 = RETURN-VALUE.
           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal + '~~~~' + c-trad-literal2"}
       END.
       IF NOT CAN-FIND (FIRST serie
                        WHERE serie.serie = RowObject.serie NO-LOCK) THEN DO:
          
           {utp/ut-liter.i "Serie" *}
           ASSIGN c-trad-literal = RETURN-VALUE.
           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal + '~~~~' + c-trad-literal"}
       END.
       IF NOT CAN-FIND (FIRST emitente
                        WHERE emitente.cod-emitente = RowObject.cod-emitente NO-LOCK) THEN DO:
           
           {utp/ut-liter.i "Emitente" *}
           ASSIGN c-trad-literal = RETURN-VALUE.
           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal + '~~~~' + c-trad-literal"}
       END.
       IF NOT CAN-FIND (FIRST natur-oper
                        WHERE natur-oper.nat-operacao = RowObject.nat-operacao NO-LOCK) THEN DO:
           
           {utp/ut-liter.i "Nat._Opera‡Æo" *}
           ASSIGN c-trad-literal = RETURN-VALUE.
           {utp/ut-liter.i "Natur-oper" *}
           ASSIGN c-trad-literal2 = RETURN-VALUE.

           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal + '~~~~' + c-trad-literal2"}
       END.
       IF NOT CAN-FIND (FIRST tab-unidade
                        WHERE tab-unidade.un = RowObject.un NO-LOCK) THEN DO:
           
           {utp/ut-liter.i "Un" *}
           ASSIGN c-trad-literal = RETURN-VALUE.
           {utp/ut-liter.i "Tab-unidade" *}
           ASSIGN c-trad-literal = RETURN-VALUE.

           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal + '~~~~' + c-trad-literal2"}
       END.
       IF NOT CAN-FIND (FIRST moeda
                        WHERE moeda.mo-codigo = RowObject.mo-codigo NO-LOCK) THEN DO:
           
           {utp/ut-liter.i "Moeda" *}
           ASSIGN c-trad-literal = RETURN-VALUE.
           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal + '~~~~' + c-trad-literal"}
       END.
       IF NOT CAN-FIND (FIRST classif-fisc
                        WHERE classif-fisc.class-fiscal = RowObject.cdd-ncm NO-LOCK) THEN DO:
           
           {utp/ut-liter.i "Cod._Ncm" *}
           ASSIGN c-trad-literal = RETURN-VALUE.
           {utp/ut-liter.i "Classif-fisc" *}
           ASSIGN c-trad-literal2 = RETURN-VALUE.

           {method/svc/errors/inserr.i
                        &ErrorNumber=28590
                        &ErrorType="EMS"
                        &ErrorParameters="c-trad-literal + '~~~~' + c-trad-literal2"}
       END.
       
       FOR FIRST pedido-drb FIELDS(modalidade) WHERE
                 pedido-drb.cod-estabel = RowObject.cod-estabel AND
                 pedido-drb.nr-pedido-drb = RowObject.nr-pedido-drb NO-LOCK:
       END.       

       IF RowObject.idi-tip-movto = 1 THEN DO: /*MOVTO DE ENTRADA*/
            
           IF RowObject.idi-tip-item-movto = 1 THEN DO:

               IF RowObject.declaracao-import = " " AND NOT l-cria-automatico THEN DO:
                    
                    {utp/ut-liter.i "Declara‡Æo_de_importa‡Æo" *}
                    ASSIGN c-trad-literal = RETURN-VALUE.
                    {method/svc/errors/inserr.i                                  
                        &ErrorNumber=822                               
                        &ErrorType="EMS"                                
                        &ErrorParameters="c-trad-literal"} 
               END.
    
               IF RowObject.dat-decla-import = ? THEN DO:
                    
                    {utp/ut-liter.i "de_declara‡Æo_de_importa‡Æo" *}
                    ASSIGN c-trad-literal = RETURN-VALUE.
                    {method/svc/errors/inserr.i                                      
                        &ErrorNumber=1385                                  
                        &ErrorType="EMS"                                    
                        &ErrorParameters="c-trad-literal"} 
               END.
           END.

           IF RowObject.val-movto-ato-me <= 0 THEN DO:
                
                {utp/ut-liter.i "Valor_do_ato_concess rio" *}
                ASSIGN c-trad-literal = RETURN-VALUE.
                {method/svc/errors/inserr.i                                     
                    &ErrorNumber=6179                                       
                    &ErrorType="EMS"                                       
                    &ErrorParameters="c-trad-literal"} 
           END.

       END.
       ELSE DO: /*MOVTO DE BAIXA*/ 

           IF RowObject.idi-tip-item-movto = 1 THEN DO:
           
               IF pedido-drb.modalidade = 1  THEN DO: /*suspensao*/
                    
                    IF i-pais-impto-usuario = 1 /* Brasil */ THEN DO:
                        IF RowObject.dat-reg-export = ? AND NOT l-cria-automatico THEN DO:
                            
                            {utp/ut-liter.i "do_registro_de_exporta‡Æo" *}
                            ASSIGN c-trad-literal = RETURN-VALUE.
                            {method/svc/errors/inserr.i                                      
                                &ErrorNumber=56531
                                &ErrorType="EMS"
                                &ErrorParameters="c-trad-literal"}
                        END.   
                        
                        IF RowObject.num-re = " " AND NOT l-cria-automatico THEN DO:
                            
                            {utp/ut-liter.i "N£mero_do_registro_de_exporta‡Æo" *}
                            ASSIGN c-trad-literal = RETURN-VALUE.
                            {method/svc/errors/inserr.i                                 
                                &ErrorNumber=56532                              
                                &ErrorType="EMS"
                                &ErrorParameters="c-trad-literal"}
                        END.                             
                    END.

                    IF RowObject.val-movto-ato-re-me <= 0  AND
                       RowObject.idi-tip-movto <> 3 /* Transferˆncia */ THEN DO:                       

                       {utp/ut-liter.i "Valor_do_ato_concess rio" *}
                       ASSIGN c-trad-literal = RETURN-VALUE.
                       {method/svc/errors/inserr.i                                     
                       &ErrorNumber=6179                                       
                       &ErrorType="EMS"                                       
                       &ErrorParameters="c-trad-literal"}    

                    END.
               END.
               
               IF pedido-drb.modalidade = 2  THEN DO: /*isencao*/
                   IF RowObject.declaracao-import = " " AND NOT l-cria-automatico THEN DO:
                       
                       {utp/ut-liter.i "Declara‡Æo_de_importa‡Æo" *}
                       ASSIGN c-trad-literal = RETURN-VALUE.
                       {method/svc/errors/inserr.i                                  
                           &ErrorNumber=822                               
                           &ErrorType="EMS"                                
                           &ErrorParameters="c-trad-literal"} 
                   END.
        
                   IF RowObject.dat-decla-import = ? THEN DO:
                       
                       {utp/ut-liter.i "de_declara‡Æo_de_importa‡Æo" *}
                       ASSIGN c-trad-literal = RETURN-VALUE.
                       {method/svc/errors/inserr.i                                      
                           &ErrorNumber=1385                                  
                           &ErrorType="EMS"                                    
                           &ErrorParameters="c-trad-literal"} 
                   END.
               END.

           END.

       END.
       
       IF RowObject.val-peso <= 0 AND NOT l-cria-automatico THEN DO:
       
            {utp/ut-liter.i "O_Peso" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i                                     
                &ErrorNumber=6179                                       
                &ErrorType="EMS"                                       
                &ErrorParameters="c-trad-literal"} 
       END. 
       
       IF RowObject.val-quant-movto-ato <= 0 THEN DO:
       
            {utp/ut-liter.i "Quantidade_do_ato_concess¢rio" *}
            ASSIGN c-trad-literal = RETURN-VALUE.
            {method/svc/errors/inserr.i                                     
                &ErrorNumber=6179                                       
                &ErrorType="EMS"                                       
                &ErrorParameters="c-trad-literal"} 
       END. 
    
    END.

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
        RETURN "NOK":U.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE warningDrawback DBOProgram 
PROCEDURE warningDrawback :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter pSerieDocto    as character no-undo.
    define input  parameter pNroDocto      as character no-undo.
    define input  parameter pCodEmitente   as integer   no-undo.
    define input  parameter pNatOPeracao   as character no-undo.
    define output parameter table for RowErrors.

    find docum-est
        where docum-est.serie-docto  = pSerieDocto
        and   docum-est.nro-docto    = pNroDocto
        and   docum-est.cod-emitente = pCodEmitente
        and   docum-est.nat-operacao = pNatOperacao no-lock no-error.
    if  avail docum-est
    and substr(docum-est.char-1,90,1) = "1" then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-movimentos-de-drawback AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Movimentos_de_Drawback" *}
        ASSIGN c-lbl-liter-movimentos-de-drawback = RETURN-VALUE.
        {method/svc/errors/inserr.i
                    &ErrorNumber="28962" 
                    &ErrorType="EMS"
                    &ErrorSubType="WARNING"
                    &ErrorParameters="c-lbl-liter-movimentos-de-drawback"}
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS (char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:

        /* IM0000 - Folder Dawback - Marcado para gerar hist¢rico para Ato concess¢rio */
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            {utp/ut-liter.i "Cria‡Æo"}
            RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS (char-1)
        WHERE param-imp.cod-estabel = rowObject.cod-estabel NO-LOCK:

        /* IM0000 - Folder Dawback - Marcado para gerar hist¢rico para Documentos Relacionados */
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            {utp/ut-liter.i "Altera‡Æo"}
            RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
        END.	
    END.

RETURN "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS (char-1)
        WHERE param-imp.cod-estabel = rowObject.cod-estabel NO-LOCK:

        /* IM0000 - Folder Dawback - Marcado para gerar hist¢rico para Documentos Relacionados */
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            IF NOT VALID-HANDLE(h-exapi025) THEN
                RUN exp/exapi025.p PERSISTENT SET h-exapi025.
            
            RUN pi-salva-valor-antigo IN h-exapi025(INPUT "movto-ato":U, INPUT rowObject.r-rowid). 
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS (char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:

        /* IM0000 - Folder Dawback - Marcado para gerar hist¢rico para Documentos Relacionados */
        IF TRIM(SUBSTRING(param-imp.char-1,229,1)) = "1":U THEN DO:
            IF NOT VALID-HANDLE(h-exapi025) THEN
                RUN exp/exapi025.p PERSISTENT SET h-exapi025.
    
            RUN pi-salva-valor-antigo IN h-exapi025(INPUT "movto-ato":U, INPUT ?).
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-historico-criacao-alteracao DBOProgram 
PROCEDURE pi-cria-historico-criacao-alteracao:
/*------------------------------------------------------------------------------------------
Purpose:    Realiza a cria‡Æo do hist¢rico de cria‡Æo/altera‡Æo.
Parameters: c-metodo       : INPUT  : M²todo(Cria‡Æo, Altera‡Æo);
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-metodo AS CHARACTER   NO-UNDO.

    /* Verifica qual o £ltimo programa .w que executou esta procedure */
    ASSIGN i-nivel = 1.
    nivel_block:
    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?.
        ASSIGN c-programa = REPLACE(PROGRAM-NAME(i-nivel),"~/","~\")
               i-nivel = i-nivel + 1.

        IF c-programa MATCHES "*men*":U THEN NEXT.
        IF c-programa MATCHES "*.w":U THEN
            ASSIGN c-ultimo-programa = c-programa
                   c-ultimo-programa = ENTRY(NUM-ENTRIES(c-programa,"~\"),c-programa,"~\").
            
    END.
    /****************************************************************/

    FOR FIRST movto-ato NO-LOCK
        WHERE movto-ato.cod-estabel   = RowObject.cod-estabel
        AND   movto-ato.nr-pedido-drb = RowObject.nr-pedido-drb
        AND   movto-ato.it-codigo     = RowObject.it-codigo
        AND   movto-ato.sequencia     = RowObject.sequencia:

        ASSIGN r-rowidAux = rowid(movto-ato).
    END.

    IF NOT VALID-HANDLE(h-exapi025) THEN
        RUN exp/exapi025.p PERSISTENT SET h-exapi025.

    RUN pi-salva-alteracao IN h-exapi025 (INPUT c-metodo, INPUT "movto-ato":U, INPUT r-rowidAux, INPUT c-ultimo-programa).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:   Eliminar os handles utilizados 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-exapi025) THEN DO:
        DELETE PROCEDURE h-exapi025.
        ASSIGN h-exapi025 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-cria-automatico DBOProgram 
PROCEDURE pi-seta-cria-automatico :
/*------------------------------------------------------------------------------
  Purpose:   Seta vari vel que indica se a cria‡Æo da movto-ato ‚ feita de forma
             autom tica.
  Parameters:  pl-cria-automatico - Indica cria‡Æo autom tica
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pl-cria-automatico AS LOGICAL NO-UNDO.

    ASSIGN l-cria-automatico = pl-cria-automatico.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaNfMovto DBOProgram 
PROCEDURE piVerificaNfMovto :
/*------------------------------------------------------------------------------
  Purpose:   Verifica se j  existe movimento criado para o item da Nota Fiscal
  Parameters:  Entrada: pi-tipo       : 1 - Nota de Entrada/ 2 - Nota de Sa¡da
                        pc-cod-estabel: Estabelecimento do item da nota fiscal
                        pc-serie      : S‚rie do item da nota fiscal
                        pc-nr-nota-fis: N£mero da nota fiscal
                        pc-it-codigo  : Item da nota fiscal
                        p-nr-seq-fat  : Sequencia do item da nota fiscal.
               Sa¡da: vari vel l¢gica que identifica a existˆncia do registro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-tipo         AS   INTEGER                   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estabel  LIKE it-nota-fisc.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie        LIKE it-nota-fisc.serie        NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-nota-fis  LIKE it-nota-fisc.nr-nota-fis  NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-emitente  LIKE emitente.cod-emitente     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nat-operacao LIKE it-nota-fisc.nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo    LIKE it-nota-fisc.it-codigo    NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-seq-fat    LIKE it-nota-fisc.nr-seq-fat   NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-existe-movto AS   LOGICAL                   NO-UNDO.

    IF pi-tipo = 1 THEN DO: /*entrada*/
        ASSIGN pl-existe-movto = CAN-FIND (FIRST movto-ato 
                                           WHERE movto-ato.serie        = pc-serie
                                             AND movto-ato.nro-docto    = pc-nr-nota-fis
                                             AND movto-ato.cod-emitente = p-cod-emitente
                                             AND movto-ato.nat-operacao = pc-nat-operacao
                                             AND movto-ato.it-codigo    = pc-it-codigo
                                             AND movto-ato.seq-docto    = p-nr-seq-fat).

    END.
    ELSE DO: /*sa¡da*/
        ASSIGN pl-existe-movto = CAN-FIND(FIRST movto-ato 
                                          WHERE movto-ato.cod-estab-docto = pc-cod-estabel
                                            AND movto-ato.serie           = pc-serie      
                                            AND movto-ato.nro-docto       = pc-nr-nota-fis
                                            AND movto-ato.it-codigo-re    = pc-it-codigo  
                                            AND movto-ato.seq-docto       = p-nr-seq-fat).
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
