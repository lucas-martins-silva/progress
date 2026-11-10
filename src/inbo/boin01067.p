&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
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

{include/i-prgvrs.i BOIN01067 2.00.00.021 } /*** "010021" 02/10/2026 10:05:36 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin01067 MUT}
&ENDIF
  
{utp/ut-glob.i}
   
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN01067
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName sdo-estoq-internac
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
{inbo/boin01067.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER b-movto-estoq  FOR movto-estoq.
DEFINE VARIABLE h-boin01068 AS HANDLE NO-UNDO.

{cep/ceapi001k.i} /* Definicao TT-MOVTO*/
{inbo/boin01067.i2} /* Definicao tt-aduana*/

DEFINE TEMP-TABLE tt-sdo-estoq-internac-aux NO-UNDO       
    FIELD cdn-aduana        LIKE docto-estoq-internac.cdn-aduana       
    FIELD cdn-agent         LIKE docto-estoq-internac.cdn-agent        
    FIELD cod-destinac      LIKE docto-estoq-internac.cod-destinac     
    FIELD cod-verfdor       LIKE docto-estoq-internac.cod-verfdor      
    FIELD cod-despch        LIKE docto-estoq-internac.cod-despch       
    FIELD cdn-ano-import    LIKE docto-estoq-internac.cdn-ano-import   
    FIELD idi-operac-import LIKE docto-estoq-internac.idi-operac-import
    FIELD qtidade-atu       LIKE sdo-estoq-internac.qtidade-atu        
    FIELD qt-alocada        LIKE sdo-estoq-internac.qt-alocada    
    FIELD declaracao-import LIKE sdo-estoq-internac.declaracao-import
    FIELD data-di           LIKE sdo-estoq-internac.data-di.

{cdp/cd0666.i}

/* Variavel utilizada para movimentaá‰es manuais ce0206/ce0220 */
DEF NEW GLOBAL SHARED VAR g-declar-control-aduana LIKE sdo-estoq-internac.declaracao-import NO-UNDO.

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
         HEIGHT             = 11.67
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alocaDoctoAuto DBOProgram 
PROCEDURE alocaDoctoAuto :
/*------------------------------------------------------------------------------
  Purpose:     Efetuar a alocaá∆o autom†tica do documento enviado por parÉmetro.
  Parameters:  p-tipo-docto - qual documento foi enviado 
                              1 - embarque
                              2 - wt-docto
               p-rowid      - rowid do documento enviado, conforme o tipo 
  Notes:       Utilizar a procedure getRowErrors para retornar os erros no programa chamador.
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-tipo-docto AS INT NO-UNDO.
    DEF INPUT PARAM p-rowid      AS ROWID NO-UNDO.
    
    EMPTY TEMP-TABLE rowErrors.

    CASE p-tipo-docto:
        WHEN 1 THEN DO:
            RUN alocaEmbarqueAuto (INPUT p-rowid).

            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.
        WHEN 2 THEN DO:
            RUN alocaWtDoctoAuto (INPUT p-rowid).

            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.
        WHEN 3 THEN DO:
            RUN del-wt-fatur-ser-lote-internac (INPUT p-rowid).

            IF  RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.
    END CASE.
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alocaEmbarqueAuto DBOProgram 
PROCEDURE alocaEmbarqueAuto PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.

    DEF VAR de-qt-alocada   LIKE saldo-estoq.qtidade-atu NO-UNDO.
    DEF VAR de-saldo-dispon LIKE saldo-estoq.qtidade-atu NO-UNDO.

    FIND embarque
        WHERE ROWID(embarque) = p-rowid NO-LOCK NO-ERROR.
    IF  NOT AVAIL embarque THEN DO:
        {utp/ut-liter.i Embarque *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    END.

    /* Somente executa para internacional e se funá∆o estiver ativa */
    IF  i-pais-impto-usuario = 1 /* Brasil */
    OR  NOT CAN-FIND(FIRST funcao 
                     WHERE funcao.cd-funcao = "spp-controle-aduana-internac":U AND funcao.ativo) THEN
        RETURN "OK":U.

    /* Elimina todas as alocaá‰es anteriores para n∆o haver duplicidade */
    FOR EACH item-depos-fatur-internac EXCLUSIVE-LOCK
        WHERE item-depos-fatur-internac.cdd-embarq = embarque.cdd-embarq,
        FIRST sdo-estoq-internac EXCLUSIVE-LOCK
            WHERE sdo-estoq-internac.cod-estabel       = item-depos-fatur-internac.cod-estabel
              AND sdo-estoq-internac.cod-depos         = item-depos-fatur-internac.cod-depos
              AND sdo-estoq-internac.cod-localiz       = item-depos-fatur-internac.cod-localiz
              AND sdo-estoq-internac.it-codigo         = item-depos-fatur-internac.it-codigo
              AND sdo-estoq-internac.cod-refer         = item-depos-fatur-internac.cod-refer
              AND sdo-estoq-internac.lote              = item-depos-fatur-internac.nr-serlote
              AND sdo-estoq-internac.declaracao-import = item-depos-fatur-internac.declaracao-import:
        
        ASSIGN sdo-estoq-internac.qt-alocada = sdo-estoq-internac.qt-alocada - item-depos-fatur-internac.qt-alocada.
        IF  sdo-estoq-internac.qt-alocada < 0 THEN
            ASSIGN sdo-estoq-internac.qt-alocada = 0.

        DELETE item-depos-fatur-internac.
    END.

    /* Efetua alocaá∆o dos saldos de aduana */
    FOR EACH it-dep-fat NO-LOCK
        WHERE it-dep-fat.cdd-embarq = embarque.cdd-embarq:
        
        ASSIGN de-qt-alocada = it-dep-fat.qt-alocada.

        /* Localiza todos os codigos de aduana e ordena pela data da declaraá∆o */
        FOR EACH sdo-estoq-internac EXCLUSIVE-LOCK
            WHERE sdo-estoq-internac.cod-estabel = it-dep-fat.cod-estabel
              AND sdo-estoq-internac.cod-depos   = it-dep-fat.cod-depos
              AND sdo-estoq-internac.cod-localiz = it-dep-fat.cod-localiz
              AND sdo-estoq-internac.it-codigo   = it-dep-fat.it-codigo
              AND sdo-estoq-internac.cod-refer   = it-dep-fat.cod-refer
              AND sdo-estoq-internac.lote        = it-dep-fat.nr-serlote
            BY sdo-estoq-internac.data-di:

            /* Considera apenas os que possuem saldo */
            IF  sdo-estoq-internac.qtidade-atu - sdo-estoq-internac.qt-alocada <= 0 THEN
                NEXT.

            FIND FIRST item-depos-fatur-internac EXCLUSIVE-LOCK
                WHERE item-depos-fatur-internac.cdd-embarq        = it-dep-fat.cdd-embarq
                  AND item-depos-fatur-internac.nr-resumo         = it-dep-fat.nr-resumo
                  AND item-depos-fatur-internac.nome-abrev        = it-dep-fat.nome-abrev
                  AND item-depos-fatur-internac.nr-pedcli         = it-dep-fat.nr-pedcli
                  AND item-depos-fatur-internac.nr-sequencia      = it-dep-fat.nr-sequencia
                  AND item-depos-fatur-internac.nr-entrega        = it-dep-fat.nr-entrega
                  AND item-depos-fatur-internac.cod-estabel       = it-dep-fat.cod-estabel  
                  AND item-depos-fatur-internac.cod-depos         = it-dep-fat.cod-depos    
                  AND item-depos-fatur-internac.cod-localiz       = it-dep-fat.cod-localiz  
                  AND item-depos-fatur-internac.it-codigo         = it-dep-fat.it-codigo    
                  AND item-depos-fatur-internac.cod-refer         = it-dep-fat.cod-refer    
                  AND item-depos-fatur-internac.nr-serlote        = it-dep-fat.nr-serlote
                  AND item-depos-fatur-internac.declaracao-import = sdo-estoq-internac.declaracao-import NO-ERROR.
            IF  NOT AVAIL item-depos-fatur-internac THEN DO:
                CREATE item-depos-fatur-internac.
                ASSIGN item-depos-fatur-internac.cdd-embarq        = it-dep-fat.cdd-embarq 
                       item-depos-fatur-internac.nr-resumo         = it-dep-fat.nr-resumo   
                       item-depos-fatur-internac.nome-abrev        = it-dep-fat.nome-abrev  
                       item-depos-fatur-internac.nr-pedcli         = it-dep-fat.nr-pedcli   
                       item-depos-fatur-internac.nr-sequencia      = it-dep-fat.nr-sequencia
                       item-depos-fatur-internac.nr-entrega        = it-dep-fat.nr-entrega  
                       item-depos-fatur-internac.cod-estabel       = it-dep-fat.cod-estabel 
                       item-depos-fatur-internac.cod-depos         = it-dep-fat.cod-depos   
                       item-depos-fatur-internac.cod-localiz       = it-dep-fat.cod-localiz 
                       item-depos-fatur-internac.it-codigo         = it-dep-fat.it-codigo   
                       item-depos-fatur-internac.cod-refer         = it-dep-fat.cod-refer   
                       item-depos-fatur-internac.nr-serlote        = it-dep-fat.nr-serlote  
                       item-depos-fatur-internac.declaracao-import = sdo-estoq-internac.declaracao-import.
            END.

            /* Consegue alocar toda a quantidade neste registro */
            IF  sdo-estoq-internac.qtidade-atu - sdo-estoq-internac.qt-alocada >= de-qt-alocada THEN
                ASSIGN item-depos-fatur-internac.qt-alocada = item-depos-fatur-internac.qt-alocada  + de-qt-alocada
                       sdo-estoq-internac.qt-alocada        = sdo-estoq-internac.qt-alocada         + de-qt-alocada
                       de-qt-alocada                        = 0.
            ELSE
                ASSIGN de-saldo-dispon                      = sdo-estoq-internac.qtidade-atu       - sdo-estoq-internac.qt-alocada
                       item-depos-fatur-internac.qt-alocada = item-depos-fatur-internac.qt-alocada + de-saldo-dispon
                       sdo-estoq-internac.qt-alocada        = sdo-estoq-internac.qt-alocada        + de-saldo-dispon
                       de-qt-alocada                        = de-qt-alocada                        - de-saldo-dispon.

            /* Se alocou tudo, vai para o proximo item */
            IF  de-qt-alocada <= 0 THEN
                LEAVE.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alocaWtDoctoAuto DBOProgram 
PROCEDURE alocaWtDoctoAuto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.

    DEF VAR de-qt-alocada   LIKE saldo-estoq.qtidade-atu NO-UNDO.
    DEF VAR de-saldo-dispon LIKE saldo-estoq.qtidade-atu NO-UNDO.

    FIND wt-docto
        WHERE ROWID(wt-docto) = p-rowid NO-LOCK NO-ERROR.
    IF  NOT AVAIL wt-docto THEN DO:
        {utp/ut-liter.i _Worktable_da_nota_fiscal *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    END.

    /* Somente executa para internacional e se funá∆o estiver ativa */
    IF  i-pais-impto-usuario = 1 /* Brasil */
    OR  NOT CAN-FIND(FIRST funcao 
                     WHERE funcao.cd-funcao = "spp-controle-aduana-internac":U AND funcao.ativo) THEN
        RETURN "OK":U.

    /* Elimina todas as alocaá‰es anteriores para n∆o haver duplicidade */
    FOR EACH wt-fatur-ser-lote-internac EXCLUSIVE-LOCK
        WHERE wt-fatur-ser-lote-internac.seq-wt-docto = wt-docto.seq-wt-docto,
        FIRST sdo-estoq-internac EXCLUSIVE-LOCK
            WHERE sdo-estoq-internac.cod-estabel       = wt-docto.cod-estabel
              AND sdo-estoq-internac.cod-depos         = wt-fatur-ser-lote-internac.cod-depos
              AND sdo-estoq-internac.cod-localiz       = wt-fatur-ser-lote-internac.cod-localiz
              AND sdo-estoq-internac.it-codigo         = wt-fatur-ser-lote-internac.it-codigo
              AND sdo-estoq-internac.cod-refer         = wt-fatur-ser-lote-internac.cod-refer
              AND sdo-estoq-internac.lote              = wt-fatur-ser-lote-internac.lote
              AND sdo-estoq-internac.declaracao-import = wt-fatur-ser-lote-internac.des-decla-import:
        
        ASSIGN sdo-estoq-internac.qt-alocada = sdo-estoq-internac.qt-alocada - wt-fatur-ser-lote-internac.quantidade.
        IF  sdo-estoq-internac.qt-alocada < 0 THEN
            ASSIGN sdo-estoq-internac.qt-alocada = 0.

        DELETE wt-fatur-ser-lote-internac.
    END.

    /* Efetua alocaá∆o dos saldos de aduana */
    FOR EACH wt-fat-ser-lote NO-LOCK
        WHERE wt-fat-ser-lote.seq-wt-docto = wt-docto.seq-wt-docto:
        
        ASSIGN de-qt-alocada = wt-fat-ser-lote.quantidade[1].

        /* Localiza todos os codigos de aduana e ordena pela data da declaraá∆o */
        FOR EACH sdo-estoq-internac EXCLUSIVE-LOCK
            WHERE sdo-estoq-internac.cod-estabel = wt-docto.cod-estabel
              AND sdo-estoq-internac.cod-depos   = wt-fat-ser-lote.cod-depos
              AND sdo-estoq-internac.cod-localiz = wt-fat-ser-lote.cod-localiz
              AND sdo-estoq-internac.it-codigo   = wt-fat-ser-lote.it-codigo
              AND sdo-estoq-internac.cod-refer   = wt-fat-ser-lote.cod-refer
              AND sdo-estoq-internac.lote        = wt-fat-ser-lote.lote
            BY sdo-estoq-internac.data-di:

            /* Considera apenas os que possuem saldo */
            IF  sdo-estoq-internac.qtidade-atu - sdo-estoq-internac.qt-alocada <= 0 THEN
                NEXT.

            FIND FIRST wt-fatur-ser-lote-internac EXCLUSIVE-LOCK
                WHERE wt-fatur-ser-lote-internac.seq-wt-docto      = wt-fat-ser-lote.seq-wt-docto
                  AND wt-fatur-ser-lote-internac.seq-wt-it-docto   = wt-fat-ser-lote.seq-wt-it-docto
                  AND wt-fatur-ser-lote-internac.cod-depos         = wt-fat-ser-lote.cod-depos    
                  AND wt-fatur-ser-lote-internac.cod-localiz       = wt-fat-ser-lote.cod-localiz  
                  AND wt-fatur-ser-lote-internac.it-codigo         = wt-fat-ser-lote.it-codigo    
                  AND wt-fatur-ser-lote-internac.cod-refer         = wt-fat-ser-lote.cod-refer    
                  AND wt-fatur-ser-lote-internac.lote              = wt-fat-ser-lote.lote
                  AND wt-fatur-ser-lote-internac.des-decla-import  = sdo-estoq-internac.declaracao-import NO-ERROR.
            IF  NOT AVAIL wt-fatur-ser-lote-internac THEN DO:
                CREATE wt-fatur-ser-lote-internac.
                ASSIGN wt-fatur-ser-lote-internac.seq-wt-docto      = wt-fat-ser-lote.seq-wt-docto 
                       wt-fatur-ser-lote-internac.seq-wt-it-docto   = wt-fat-ser-lote.seq-wt-it-docto
                       wt-fatur-ser-lote-internac.cod-depos         = wt-fat-ser-lote.cod-depos   
                       wt-fatur-ser-lote-internac.cod-localiz       = wt-fat-ser-lote.cod-localiz 
                       wt-fatur-ser-lote-internac.it-codigo         = wt-fat-ser-lote.it-codigo   
                       wt-fatur-ser-lote-internac.cod-refer         = wt-fat-ser-lote.cod-refer   
                       wt-fatur-ser-lote-internac.lote              = wt-fat-ser-lote.lote
                       wt-fatur-ser-lote-internac.des-decla-import  = sdo-estoq-internac.declaracao-import.
            END.

            /* Consegue alocar toda a quantidade neste registro */
            IF  sdo-estoq-internac.qtidade-atu - sdo-estoq-internac.qt-alocada >= de-qt-alocada THEN
                ASSIGN wt-fatur-ser-lote-internac.quantidade = wt-fatur-ser-lote-internac.quantidade + de-qt-alocada
                       sdo-estoq-internac.qt-alocada         = sdo-estoq-internac.qt-alocada         + de-qt-alocada
                       de-qt-alocada                         = 0.
            ELSE
                ASSIGN de-saldo-dispon                       = sdo-estoq-internac.qtidade-atu        - sdo-estoq-internac.qt-alocada
                       wt-fatur-ser-lote-internac.quantidade = wt-fatur-ser-lote-internac.quantidade + de-saldo-dispon
                       sdo-estoq-internac.qt-alocada         = sdo-estoq-internac.qt-alocada         + de-saldo-dispon
                       de-qt-alocada                         = de-qt-alocada                         - de-saldo-dispon.

            /* Se alocou tudo, vai para o proximo item */
            IF  de-qt-alocada <= 0 THEN
                LEAVE.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CancelaMovtoSaldoRemito DBOProgram 
PROCEDURE CancelaMovtoSaldoRemito :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar os movimentos criados para os documentos, na desatualizaá∆o do estoque (RE0402/FT2100)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rw-movto AS ROWID NO-UNDO.
    
    FIND movto-estoq WHERE ROWID(movto-estoq) = p-rw-movto NO-LOCK NO-ERROR. /* entrada */
    IF NOT AVAIL movto-estoq THEN RETURN.

    FIND FIRST b-movto-estoq 
         WHERE b-movto-estoq.serie-docto  = movto-estoq.serie-docto
           AND b-movto-estoq.nro-docto    = movto-estoq.nro-docto
           AND b-movto-estoq.cod-emitente = movto-estoq.cod-emitente
           AND b-movto-estoq.nat-operacao = movto-estoq.nat-operacao
           AND b-movto-estoq.cod-depos    = movto-estoq.cod-depos
           AND b-movto-estoq.cod-localiz  = movto-estoq.cod-localiz
           AND b-movto-estoq.it-codigo    = movto-estoq.it-codigo
           AND b-movto-estoq.cod-refer    = movto-estoq.cod-refer
           AND b-movto-estoq.cod-lote-fabrican     = movto-estoq.cod-lote-fabrican
           AND b-movto-estoq.sequen-nf    = movto-estoq.sequen-nf
           AND b-movto-estoq.tipo-trans   = 2  NO-LOCK NO-ERROR. /* Sa°da */
    IF NOT AVAIL b-movto-estoq THEN RETURN.

    IF  NOT VALID-HANDLE(h-boin01068) THEN
        RUN inbo/boin01068.p PERSISTENT SET h-boin01068.

    FOR EACH movto-estoq-internac OF b-movto-estoq NO-LOCK:

       FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
            WHERE bf{&TableName}.cod-estabel       = movto-estoq-internac.cod-estabel      
              AND bf{&TableName}.cod-depos         = movto-estoq-internac.cod-depos        
              AND bf{&TableName}.cod-localiz       = movto-estoq-internac.cod-localiz      
              AND bf{&TableName}.it-codigo         = movto-estoq-internac.it-codigo        
              AND bf{&TableName}.cod-refer         = movto-estoq-internac.cod-refer         
              AND bf{&TableName}.lote              = movto-estoq-internac.lote             
              AND bf{&TableName}.declaracao-import = movto-estoq-internac.des-decla-import NO-ERROR.
       IF AVAIL bf{&TableName} THEN DO:
            ASSIGN bf{&TableName}.qt-alocada  = bf{&TableName}.qt-alocada  + movto-estoq-internac.quantidade
                   bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu + movto-estoq-internac.quantidade.

            RUN criaMovtoControleAduana IN h-boin01068 (INPUT movto-estoq.nr-trans, 
                                                        INPUT ROWID(bf{&TableName}),
                                                        INPUT movto-estoq-internac.quantidade).
       END.

    END.

    IF  VALID-HANDLE(h-boin01068) THEN DO:
        RUN destroy IN h-boin01068.
        ASSIGN h-boin01068 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelaNotaFiscalAduana DBOProgram 
PROCEDURE cancelaNotaFiscalAduana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-r-fat-ser-lote AS ROWID NO-UNDO.
    
    FIND FIRST fat-ser-lote WHERE ROWID(fat-ser-lote) = p-r-fat-ser-lote NO-LOCK NO-ERROR.
    IF NOT AVAIL fat-ser-lote THEN RETURN "NOK":U.

    FOR EACH fatur-ser-lote-internac NO-LOCK
       WHERE fatur-ser-lote-internac.cod-estabel = fat-ser-lote.cod-estabel                                 
         AND fatur-ser-lote-internac.serie       = fat-ser-lote.serie                                       
         AND fatur-ser-lote-internac.nr-nota-fis = fat-ser-lote.nr-nota-fis                                 
         AND fatur-ser-lote-internac.nr-seq-fat  = fat-ser-lote.nr-seq-fat                                  
         AND fatur-ser-lote-internac.cod-depos   = fat-ser-lote.cod-depos                                   
         AND fatur-ser-lote-internac.cod-localiz = fat-ser-lote.cod-localiz                                 
         AND fatur-ser-lote-internac.nr-serlote  = fat-ser-lote.nr-serlote                                  
         AND fatur-ser-lote-internac.it-codigo   = fat-ser-lote.it-codigo                                   
         AND fatur-ser-lote-internac.cod-refer   = fat-ser-lote.cod-refer:

      FIND FIRST bf{&TableName} EXCLUSIVE-LOCK                                                              
           WHERE bf{&TableName}.cod-estabel       = fatur-ser-lote-internac.cod-estabel                        
             AND bf{&TableName}.cod-depos         = fatur-ser-lote-internac.cod-depos                          
             AND bf{&TableName}.cod-localiz       = fatur-ser-lote-internac.cod-localiz                        
             AND bf{&TableName}.it-codigo         = fatur-ser-lote-internac.it-codigo                          
             AND bf{&TableName}.cod-refer         = fatur-ser-lote-internac.cod-refer                          
             AND bf{&TableName}.lote              = fatur-ser-lote-internac.nr-serlote                               
             AND bf{&TableName}.declaracao-import = fatur-ser-lote-internac.declaracao-import NO-ERROR.         
      IF AVAIL bf{&TableName} THEN DO:     
           ASSIGN bf{&TableName}.qt-alocada  = bf{&TableName}.qt-alocada - fatur-ser-lote-internac.qt-baixada.

           IF bf{&TableName}.qt-alocada < 0 THEN
               ASSIGN bf{&TableName}.qt-alocada = 0.
      END.
    END.                  

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE del-wt-fatur-ser-lote-internac DBOProgram 
PROCEDURE del-wt-fatur-ser-lote-internac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-rowid AS ROWID NO-UNDO.

    /* Somente executa para internacional e se funá∆o estiver ativa */
    IF  NOT CAN-FIND(FIRST funcao 
                     WHERE funcao.cd-funcao = "spp-controle-aduana-internac":U AND funcao.ativo) THEN
        RETURN "OK":U.

    FIND wt-docto
        WHERE ROWID(wt-docto) = p-rowid NO-LOCK NO-ERROR.
    IF  NOT AVAIL wt-docto THEN DO:
        {utp/ut-liter.i _Worktable_da_nota_fiscal *}
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=TRIM(RETURN-VALUE)}
        RETURN "NOK":U.
    END.

    /* Elimina todas as alocaá‰es anteriores para n∆o haver duplicidade */
    FOR EACH wt-fatur-ser-lote-internac EXCLUSIVE-LOCK
        WHERE wt-fatur-ser-lote-internac.seq-wt-docto = wt-docto.seq-wt-docto:
        DELETE wt-fatur-ser-lote-internac.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DesatualizaDocto DBOProgram 
PROCEDURE DesatualizaDocto :
/*------------------------------------------------------------------------------
  Purpose:     Eliminar os movimentos criados para os documentos, na desatualizaá∆o do estoque (RE0402/FT2100)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-rw-movto AS ROWID NO-UNDO.
    
    FIND movto-estoq
        WHERE ROWID(movto-estoq) = p-rw-movto NO-LOCK NO-ERROR.
    IF  NOT AVAIL movto-estoq THEN
        RETURN.

    FOR EACH movto-estoq-internac EXCLUSIVE-LOCK
        WHERE movto-estoq-internac.nr-trans = movto-estoq.nr-trans:

        FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
            WHERE bf{&TableName}.cod-estabel       = movto-estoq-internac.cod-estabel      
              AND bf{&TableName}.cod-depos         = movto-estoq-internac.cod-depos        
              AND bf{&TableName}.cod-localiz       = movto-estoq-internac.cod-localiz      
              AND bf{&TableName}.it-codigo         = movto-estoq-internac.it-codigo        
              AND bf{&TableName}.cod-refer         = movto-estoq-internac.cod-refer         
              AND bf{&TableName}.lote              = movto-estoq-internac.lote             
              AND bf{&TableName}.declaracao-import = movto-estoq-internac.des-decla-import NO-ERROR.
        IF  AVAIL bf{&TableName} THEN

            IF  movto-estoq.tipo-trans = 1 THEN DO:
                IF (bf{&TableName}.qtidade-atu - movto-estoq-internac.quantidade) < 0 THEN RETURN "NOK":U.

                ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu - movto-estoq-internac.quantidade.
            END.
            ELSE 
                ASSIGN bf{&TableName}.qt-alocada  = bf{&TableName}.qt-alocada  + movto-estoq-internac.quantidade
                       bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu + movto-estoq-internac.quantidade.

        DELETE movto-estoq-internac.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gera-fatur-ser-lote-internac DBOProgram 
PROCEDURE gera-fatur-ser-lote-internac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-rw-fat-ser-lote       as ROWID no-undo.
    DEF INPUT  PARAM p-rw-wt-fat-ser-lote    as ROWID no-undo.

    /* Somente executa para internacional e se funá∆o estiver ativa */
    IF NOT CAN-FIND(FIRST funcao 
                     WHERE funcao.cd-funcao = "spp-controle-aduana-internac":U AND funcao.ativo) THEN
        RETURN "OK":U.
    
    FIND FIRST wt-fat-ser-lote WHERE ROWID(wt-fat-ser-lote) = p-rw-wt-fat-ser-lote NO-LOCK NO-ERROR.
    FIND FIRST fat-ser-lote    WHERE ROWID(fat-ser-lote)    = p-rw-fat-ser-lote    NO-LOCK NO-ERROR.

    FOR EACH wt-fatur-ser-lote-internac NO-LOCK
       WHERE wt-fatur-ser-lote-internac.seq-wt-docto    = wt-fat-ser-lote.seq-wt-docto                                    
         AND wt-fatur-ser-lote-internac.seq-wt-it-docto = wt-fat-ser-lote.seq-wt-it-docto                                 
         AND wt-fatur-ser-lote-internac.it-codigo       = wt-fat-ser-lote.it-codigo                                       
         AND wt-fatur-ser-lote-internac.cod-depos       = wt-fat-ser-lote.cod-depos                                       
         AND wt-fatur-ser-lote-internac.cod-localiz     = wt-fat-ser-lote.cod-localiz                                     
         AND wt-fatur-ser-lote-internac.lote            = wt-fat-ser-lote.lote:

        FIND FIRST fatur-ser-lote-internac NO-LOCK                                                                      
            WHERE fatur-ser-lote-internac.cod-estabel = fat-ser-lote.cod-estabel                                       
              AND fatur-ser-lote-internac.serie       = fat-ser-lote.serie                                             
              AND fatur-ser-lote-internac.nr-nota-fis = fat-ser-lote.nr-nota-fis                                       
              AND fatur-ser-lote-internac.nr-seq-fat  = fat-ser-lote.nr-seq-fat                                        
              AND fatur-ser-lote-internac.cod-depos   = fat-ser-lote.cod-depos                                         
              AND fatur-ser-lote-internac.cod-localiz = fat-ser-lote.cod-localiz                                       
              AND fatur-ser-lote-internac.nr-serlote  = fat-ser-lote.nr-serlote                                        
              AND fatur-ser-lote-internac.it-codigo   = fat-ser-lote.it-codigo                                         
              AND fatur-ser-lote-internac.cod-refer   = fat-ser-lote.cod-refer                                         
              AND fatur-ser-lote-internac.declaracao-import = wt-fatur-ser-lote-internac.des-decla-import 
           NO-ERROR.                                                                                                   
                                                                                                                       
        IF  NOT AVAIL fatur-ser-lote-internac THEN DO:                                                                  
            
            CREATE fatur-ser-lote-internac.                                                                             
            ASSIGN fatur-ser-lote-internac.cod-estabel       = fat-ser-lote.cod-estabel                                 
                   fatur-ser-lote-internac.serie             = fat-ser-lote.serie                                       
                   fatur-ser-lote-internac.nr-nota-fis       = fat-ser-lote.nr-nota-fis                                 
                   fatur-ser-lote-internac.nr-seq-fat        = fat-ser-lote.nr-seq-fat                                  
                   fatur-ser-lote-internac.cod-depos         = fat-ser-lote.cod-depos                                   
                   fatur-ser-lote-internac.cod-localiz       = fat-ser-lote.cod-localiz                                 
                   fatur-ser-lote-internac.nr-serlote        = fat-ser-lote.nr-serlote                                  
                   fatur-ser-lote-internac.it-codigo         = fat-ser-lote.it-codigo                                   
                   fatur-ser-lote-internac.cod-refer         = fat-ser-lote.cod-refer
                   fatur-ser-lote-internac.declaracao-import = wt-fatur-ser-lote-internac.des-decla-import
                   fatur-ser-lote-internac.qt-baixada        = wt-fatur-ser-lote-internac.quantidade.
       END.
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
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "declaracao-import":U THEN ASSIGN pFieldValue = RowObject.declaracao-import.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
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
        WHEN "data-di":U THEN ASSIGN pFieldValue = RowObject.data-di.
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
        WHEN "qt-alocada":U THEN ASSIGN pFieldValue = RowObject.qt-alocada.
        WHEN "qtidade-atu":U THEN ASSIGN pFieldValue = RowObject.qtidade-atu.
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
  Purpose:     Retorna valores dos campos do °ndice sdstqntr_id2
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-depos
               retorna valor do campo cod-localiz
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo lote
               retorna valor do campo declaracao-import
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE sdo-estoq-internac.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-depos LIKE sdo-estoq-internac.cod-depos NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-localiz LIKE sdo-estoq-internac.cod-localiz NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE sdo-estoq-internac.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE sdo-estoq-internac.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER plote LIKE sdo-estoq-internac.lote NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeclaracao-import LIKE sdo-estoq-internac.declaracao-import NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-depos = RowObject.cod-depos
           pcod-localiz = RowObject.cod-localiz
           pit-codigo = RowObject.it-codigo
           pcod-refer = RowObject.cod-refer
           plote = RowObject.lote
           pdeclaracao-import = RowObject.declaracao-import.

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
  Purpose:     Reposiciona registro com base no °ndice sdstqntr_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-depos
               recebe valor do campo cod-localiz
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo lote
               recebe valor do campo declaracao-import
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE sdo-estoq-internac.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-depos LIKE sdo-estoq-internac.cod-depos NO-UNDO.
    DEFINE INPUT PARAMETER pcod-localiz LIKE sdo-estoq-internac.cod-localiz NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE sdo-estoq-internac.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE sdo-estoq-internac.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER plote LIKE sdo-estoq-internac.lote NO-UNDO.
    DEFINE INPUT PARAMETER pdeclaracao-import LIKE sdo-estoq-internac.declaracao-import NO-UNDO.

    FIND FIRST bfsdo-estoq-internac WHERE 
        bfsdo-estoq-internac.cod-estabel = pcod-estabel AND 
        bfsdo-estoq-internac.cod-depos = pcod-depos AND 
        bfsdo-estoq-internac.cod-localiz = pcod-localiz AND 
        bfsdo-estoq-internac.it-codigo = pit-codigo AND 
        bfsdo-estoq-internac.cod-refer = pcod-refer AND 
        bfsdo-estoq-internac.lote = plote AND 
        bfsdo-estoq-internac.declaracao-import = pdeclaracao-import NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsdo-estoq-internac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsdo-estoq-internac)).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraControleAduana DBOProgram 
PROCEDURE piGeraControleAduana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-movto.

    DEF BUFFER b2-{&TableName} FOR sdo-estoq-internac.
    DEF BUFFER b-tt-movto      FOR tt-movto.
    DEFINE BUFFER b-nota-fiscal FOR nota-fiscal.    
    DEFINE VARIABLE de-qtde-atual AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-qtde-restante AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-qt-baixada AS DECIMAL NO-UNDO.

    FOR EACH tt-movto:

        FIND movto-estoq NO-LOCK
            WHERE ROWID(movto-estoq) = tt-movto.r-mov-inv NO-ERROR.
        IF  NOT AVAIL movto-estoq THEN
            RETURN "NOK":U.

        FIND FIRST saldo-estoq NO-LOCK
            WHERE saldo-estoq.cod-estabel = movto-estoq.cod-estabel
              AND saldo-estoq.it-codigo   = movto-estoq.it-codigo
              AND saldo-estoq.cod-depos   = movto-estoq.cod-depos
              AND saldo-estoq.cod-localiz = movto-estoq.cod-localiz
              AND saldo-estoq.lote        = movto-estoq.lote
              AND saldo-estoq.cod-refer   = movto-estoq.cod-refer NO-ERROR.
        IF  NOT AVAIL saldo-estoq THEN
            RETURN "NOK":U.            
    
         IF  NOT VALID-HANDLE(h-boin01068) THEN
            RUN inbo/boin01068.p PERSISTENT SET h-boin01068.         
 
        /* Entrada recebimento ou liberaá∆o CQ */
        entrada-recebimento:
        DO:
            IF  movto-estoq.esp-docto = 21 /* NFE */ 
            OR  movto-estoq.esp-docto = 33 /* TRA */ AND movto-estoq.cod-prog-orig = "v03in218" /* cq0210e */ THEN DO:
                
                /* Localiza a natureza de operaá∆o da ficha-cq, quando movimento vier do CQ */
                IF  movto-estoq.esp-docto = 33 /* TRA */ 
                AND movto-estoq.cod-prog-orig = "v03in218" /* cq0210e */ THEN DO:
                    FIND ficha-cq
                        WHERE ficha-cq.nr-ficha = INT(movto-estoq.referencia) NO-LOCK NO-ERROR.
                    IF  AVAIL ficha-cq THEN
                        ASSIGN movto-estoq.nat-operacao = ficha-cq.nat-operacao.
                END.
        
                /* Localiza documento original */
                FIND FIRST docto-estoq-internac NO-LOCK
                    WHERE docto-estoq-internac.serie-docto   = movto-estoq.serie-docto
                      AND docto-estoq-internac.nro-docto     = movto-estoq.nro-docto 
                      AND docto-estoq-internac.cod-emitente  = movto-estoq.cod-emitente 
                      AND docto-estoq-internac.nat-operacao  = movto-estoq.nat-operacao NO-ERROR.                                
                
                IF  NOT AVAIL docto-estoq-internac OR NOT(docto-estoq-internac.data-di <> ?) THEN
                    LEAVE entrada-recebimento.
                
                FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                    WHERE bf{&TableName}.cod-estabel       = saldo-estoq.cod-estabel
                      AND bf{&TableName}.cod-depos         = saldo-estoq.cod-depos  
                      AND bf{&TableName}.cod-localiz       = saldo-estoq.cod-localiz
                      AND bf{&TableName}.it-codigo         = saldo-estoq.it-codigo  
                      AND bf{&TableName}.cod-refer         = saldo-estoq.cod-refer  
                      AND bf{&TableName}.lote              = saldo-estoq.lote       
                      AND bf{&TableName}.declaracao-import = docto-estoq-internac.declaracao-import NO-ERROR.
                       
                IF  NOT AVAIL bf{&TableName} THEN DO:
                    CREATE bf{&TableName}.
                    ASSIGN bf{&TableName}.cod-estabel       = saldo-estoq.cod-estabel                  
                           bf{&TableName}.cod-depos         = saldo-estoq.cod-depos                    
                           bf{&TableName}.cod-localiz       = saldo-estoq.cod-localiz                  
                           bf{&TableName}.it-codigo         = saldo-estoq.it-codigo                    
                           bf{&TableName}.cod-refer         = saldo-estoq.cod-refer                    
                           bf{&TableName}.lote              = saldo-estoq.lote                         
                           bf{&TableName}.declaracao-import = docto-estoq-internac.declaracao-import
                           bf{&TableName}.data-di           = docto-estoq-internac.data-di.
                END.
        
                IF  movto-estoq.tipo-trans = 1 /* entrada */ THEN
                    ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu + movto-estoq.quantidade.
                ELSE
                    ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu - movto-estoq.quantidade.
              
                RUN criaMovtoControleAduana IN h-boin01068 (INPUT movto-estoq.nr-trans,
                                                            INPUT ROWID(bf{&TableName}),
                                                            INPUT movto-estoq.quantidade).
            END.
        END.        

        /* Atualiza retirada por remito e por fatura */
        IF  movto-estoq.esp-docto = 22 /* NFS */ THEN DO:

            FIND natur-oper NO-LOCK
                WHERE natur-oper.nat-operacao = movto-estoq.nat-operacao NO-ERROR.
            IF  AVAIL natur-oper 
            AND substring(natur-oper.char-2,41,5) = "1    "
            AND natur-oper.baixa-ship             = YES THEN DO:

                FIND FIRST remito NO-LOCK
                    WHERE remito.cod-estabel = saldo-estoq.cod-estabel
                      AND remito.serie       = movto-estoq.serie-docto
                      AND remito.nr-remito   = movto-estoq.nro-docto NO-ERROR.
    
                IF  AVAIL remito THEN DO:
    
                    FOR EACH item-depos-fatur-internac NO-LOCK
                        WHERE item-depos-fatur-internac.cdd-embarq   = remito.cdd-embarq
                          AND item-depos-fatur-internac.nr-resumo    = remito.nr-resumo
                          AND item-depos-fatur-internac.cod-estabel  = saldo-estoq.cod-estabel  
                          AND item-depos-fatur-internac.nr-sequencia = movto-estoq.sequen-nf
                          AND item-depos-fatur-internac.cod-depos    = saldo-estoq.cod-depos
                          AND item-depos-fatur-internac.cod-localiz  = saldo-estoq.cod-localiz
                          AND item-depos-fatur-internac.it-codigo    = saldo-estoq.it-codigo    
                          AND item-depos-fatur-internac.cod-refer    = saldo-estoq.cod-refer
                          AND item-depos-fatur-internac.nr-serlote   = saldo-estoq.lote:
    
                        /* Atualiza alocaá∆o e quantidade do saldo */
                        FIND FIRST bf{&TableName}
                            WHERE bf{&TableName}.cod-estabel       = item-depos-fatur-internac.cod-estabel
                              AND bf{&TableName}.cod-depos         = item-depos-fatur-internac.cod-depos  
                              AND bf{&TableName}.cod-localiz       = item-depos-fatur-internac.cod-localiz
                              AND bf{&TableName}.it-codigo         = item-depos-fatur-internac.it-codigo  
                              AND bf{&TableName}.cod-refer         = item-depos-fatur-internac.cod-refer  
                              AND bf{&TableName}.lote              = item-depos-fatur-internac.nr-serlote
                              AND bf{&TableName}.declaracao-import = item-depos-fatur-internac.declaracao-import EXCLUSIVE-LOCK NO-ERROR.
    
                        IF  AVAIL bf{&TableName} THEN DO:
                            ASSIGN bf{&TableName}.qt-alocada  = bf{&TableName}.qt-alocada  - item-depos-fatur-internac.qt-alocada
                                   bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu - item-depos-fatur-internac.qt-alocada.
                            VALIDATE bf{&TableName}.
        
                            RUN criaMovtoControleAduana IN h-boin01068 (INPUT movto-estoq.nr-trans, 
                                                                        INPUT ROWID(bf{&TableName}),
                                                                        INPUT item-depos-fatur-internac.qt-alocada).
                        END.
                    END.
                END.
            END.
            ELSE DO:

                FOR EACH fatur-ser-lote-internac NO-LOCK                                                                      
                    WHERE fatur-ser-lote-internac.cod-estabel = saldo-estoq.cod-estabel                                       
                      AND fatur-ser-lote-internac.serie       = movto-estoq.serie-docto                                            
                      AND fatur-ser-lote-internac.nr-nota-fis = movto-estoq.nro-docto
                      AND fatur-ser-lote-internac.nr-seq-fat  = movto-estoq.sequen-nf
                      AND fatur-ser-lote-internac.cod-depos   = saldo-estoq.cod-depos                                         
                      AND fatur-ser-lote-internac.cod-localiz = saldo-estoq.cod-localiz                                       
                      AND fatur-ser-lote-internac.nr-serlote  = saldo-estoq.lote                                        
                      AND fatur-ser-lote-internac.it-codigo   = saldo-estoq.it-codigo                                         
                      AND fatur-ser-lote-internac.cod-refer   = saldo-estoq.cod-refer:

                    /* Atualiza alocaá∆o e quantidade do saldo */
                    FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                         WHERE bf{&TableName}.cod-estabel       = fatur-ser-lote-internac.cod-estabel
                           AND bf{&TableName}.cod-depos         = fatur-ser-lote-internac.cod-depos  
                           AND bf{&TableName}.cod-localiz       = fatur-ser-lote-internac.cod-localiz
                           AND bf{&TableName}.it-codigo         = fatur-ser-lote-internac.it-codigo  
                           AND bf{&TableName}.cod-refer         = fatur-ser-lote-internac.cod-refer  
                           AND bf{&TableName}.lote              = fatur-ser-lote-internac.nr-serlote
                           AND bf{&TableName}.declaracao-import = fatur-ser-lote-internac.declaracao-import NO-ERROR.
    
                    IF AVAIL bf{&TableName} THEN DO:
                        ASSIGN bf{&TableName}.qt-alocada  = bf{&TableName}.qt-alocada  - fatur-ser-lote-internac.qt-baixada
                               bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu - fatur-ser-lote-internac.qt-baixada.
                        VALIDATE bf{&TableName}.
        
                        RUN criaMovtoControleAduana IN h-boin01068 (INPUT movto-estoq.nr-trans, 
                                                                    INPUT ROWID(bf{&TableName}),
                                                                    INPUT fatur-ser-lote-internac.qt-baixada).
                    END.
                END.
            END.
        END.

        

        /* Transaá‰es diversas */
        IF  movto-estoq.esp-docto = 6 /* DIV */ AND movto-estoq.cod-prog-orig = "v07in218" /* CE0220 */ 
        AND g-declar-control-aduana <> "" THEN DO:
            FIND FIRST internac-decla-aduana NO-LOCK
                WHERE internac-decla-aduana.declaracao-import = g-declar-control-aduana NO-ERROR.
            IF  AVAIL internac-decla-aduana THEN DO:

                FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                    WHERE bf{&TableName}.cod-estabel       = saldo-estoq.cod-estabel
                      AND bf{&TableName}.cod-depos         = saldo-estoq.cod-depos  
                      AND bf{&TableName}.cod-localiz       = saldo-estoq.cod-localiz
                      AND bf{&TableName}.it-codigo         = saldo-estoq.it-codigo  
                      AND bf{&TableName}.cod-refer         = saldo-estoq.cod-refer  
                      AND bf{&TableName}.lote              = saldo-estoq.lote       
                      AND bf{&TableName}.declaracao-import = g-declar-control-aduana NO-ERROR.
                       
                IF  NOT AVAIL bf{&TableName} THEN DO:
                    CREATE bf{&TableName}.
                    ASSIGN bf{&TableName}.cod-estabel       = saldo-estoq.cod-estabel                  
                           bf{&TableName}.cod-depos         = saldo-estoq.cod-depos                    
                           bf{&TableName}.cod-localiz       = saldo-estoq.cod-localiz                  
                           bf{&TableName}.it-codigo         = saldo-estoq.it-codigo                    
                           bf{&TableName}.cod-refer         = saldo-estoq.cod-refer                    
                           bf{&TableName}.lote              = saldo-estoq.lote                         
                           bf{&TableName}.declaracao-import = internac-decla-aduana.declaracao-import
                           bf{&TableName}.data-di           = internac-decla-aduana.data-di.
                END.
        
                IF  movto-estoq.tipo-trans = 1 /* entrada */ THEN
                    ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu + movto-estoq.quantidade.
                ELSE
                    ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu - movto-estoq.quantidade.
              
                RUN criaMovtoControleAduana IN h-boin01068 (INPUT movto-estoq.nr-trans,
                                                            INPUT ROWID(bf{&TableName}),
                                                            INPUT movto-estoq.quantidade).
            END.
        END.

        IF  movto-estoq.esp-docto     = 33 /* TRA */ 
        AND movto-estoq.cod-prog-orig = "ce0206" 
        AND g-declar-control-aduana  <> "" THEN DO:

            FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                WHERE bf{&TableName}.cod-estabel       = saldo-estoq.cod-estabel
                  AND bf{&TableName}.cod-depos         = saldo-estoq.cod-depos  
                  AND bf{&TableName}.cod-localiz       = saldo-estoq.cod-localiz
                  AND bf{&TableName}.it-codigo         = saldo-estoq.it-codigo  
                  AND bf{&TableName}.cod-refer         = saldo-estoq.cod-refer  
                  AND bf{&TableName}.lote              = saldo-estoq.lote       
                  AND bf{&TableName}.declaracao-import = g-declar-control-aduana NO-ERROR.

            IF  tt-movto.tipo-trans = 2 /* sa°da */ AND AVAIL bf{&TableName} THEN
                ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu - tt-movto.quantidade.

            IF  tt-movto.tipo-trans = 1 /* entrada */ THEN DO:
                
                IF  NOT AVAIL bf{&TableName} THEN DO:

                    /* localiza movto de sa°da para encontrar a data-di */
                    FIND FIRST b-tt-movto
                        WHERE b-tt-movto.tipo-trans = 2 NO-LOCK NO-ERROR.

                    FIND FIRST b2-{&TableName}
                        WHERE b2-{&TableName}.cod-estabel       = b-tt-movto.cod-estabel
                          AND b2-{&TableName}.cod-depos         = b-tt-movto.cod-depos  
                          AND b2-{&TableName}.cod-localiz       = b-tt-movto.cod-localiz
                          AND b2-{&TableName}.it-codigo         = b-tt-movto.it-codigo  
                          AND b2-{&TableName}.cod-refer         = b-tt-movto.cod-refer  
                          AND b2-{&TableName}.lote              = b-tt-movto.lote       
                          AND b2-{&TableName}.declaracao-import = g-declar-control-aduana NO-LOCK NO-ERROR.
                
                    /* Para o movimento de entrada da transferància, localiza o saldo destino. Se nao encontrar, cria. Caso j† exista, atualiza. */
                    CREATE bf{&TableName}.
                    ASSIGN bf{&TableName}.cod-estabel       = saldo-estoq.cod-estabel        
                           bf{&TableName}.cod-depos         = saldo-estoq.cod-depos          
                           bf{&TableName}.cod-localiz       = saldo-estoq.cod-localiz        
                           bf{&TableName}.it-codigo         = saldo-estoq.it-codigo          
                           bf{&TableName}.cod-refer         = saldo-estoq.cod-refer          
                           bf{&TableName}.lote              = saldo-estoq.lote               
                           bf{&TableName}.declaracao-import = g-declar-control-aduana
                           bf{&TableName}.data-di           = b2-{&TableName}.data-di.
                END.
                
                ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu + tt-movto.quantidade.
            END.

            VALIDATE bf{&TableName}.

            RUN criaMovtoControleAduana IN h-boin01068 (INPUT movto-estoq.nr-trans, 
                                                        INPUT ROWID(bf{&TableName}),
                                                        INPUT tt-movto.quantidade).
        END.

        IF  movto-estoq.esp-docto = 20 /* NFD */ THEN DO:

            FOR EACH rat-lote-internac
                WHERE  rat-lote-internac.serie-docto   = movto-estoq.serie-docto   
                   AND  rat-lote-internac.nro-docto    = movto-estoq.nro-docto  
                   AND  rat-lote-internac.cod-emitente = movto-estoq.cod-emitente
                   AND  rat-lote-internac.nat-operacao = movto-estoq.nat-operacao  
                   AND  rat-lote-internac.sequencia    = movto-estoq.sequen-nf
                   AND  rat-lote-internac.it-codigo    = movto-estoq.it-codigo
                   AND  rat-lote-internac.cod-refer    = movto-estoq.cod-refer
                   AND  rat-lote-internac.cod-depos    = movto-estoq.cod-depos
                   AND  rat-lote-internac.cod-localiz  = movto-estoq.cod-localiz
                   AND  rat-lote-internac.lote         = movto-estoq.lote NO-LOCK:

                FIND FIRST bf{&TableName} EXCLUSIVE-LOCK
                    WHERE bf{&TableName}.cod-estabel       = saldo-estoq.cod-estabel
                      AND bf{&TableName}.cod-depos         = saldo-estoq.cod-depos  
                      AND bf{&TableName}.cod-localiz       = saldo-estoq.cod-localiz
                      AND bf{&TableName}.it-codigo         = saldo-estoq.it-codigo  
                      AND bf{&TableName}.cod-refer         = saldo-estoq.cod-refer  
                      AND bf{&TableName}.lote              = saldo-estoq.lote       
                      AND bf{&TableName}.declaracao-import = rat-lote-internac.declaracao-import NO-ERROR.

                IF AVAIL bf{&TableName} THEN DO:
                    IF movto-estoq.tipo-trans = 1 /* entrada */ THEN
                        ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu + rat-lote-internac.quantidade.
                    ELSE
                        ASSIGN bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu - rat-lote-internac.quantidade.

                    RUN criaMovtoControleAduana IN h-boin01068 (INPUT movto-estoq.nr-trans, 
                                                                INPUT ROWID(bf{&TableName}),
                                                                INPUT rat-lote-internac.quantidade).
                END.
            END.
        END.                
        
               
        IF movto-estoq.esp-docto    = 21 /* NFE */ AND 
           movto-estoq.origem-valor = "FT" THEN DO:                            
            FOR FIRST nota-fiscal NO-LOCK
                WHERE nota-fiscal.cod-estabel = movto-estoq.cod-estabel 
                AND   nota-fiscal.serie = movto-estoq.serie-docto
                AND   nota-fiscal.nr-nota-fis = movto-estoq.nro-docto:                                
                
                FOR FIRST b-nota-fiscal NO-LOCK 
                    WHERE b-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
                    AND   b-nota-fiscal.serie = nota-fiscal.serie-orig
                    AND   b-nota-fiscal.nr-nota-fis = nota-fiscal.nro-nota-orig:                                        
                    
                    ASSIGN de-qtde-restante = movto-estoq.quantidade.
                    
                    fatur-ser-lote-internac:
                    FOR EACH fatur-ser-lote-internac EXCLUSIVE-LOCK
                        WHERE fatur-ser-lote-internac.cod-estabel = b-nota-fiscal.cod-estabel
                        AND   fatur-ser-lote-internac.serie = b-nota-fiscal.serie
                        AND   fatur-ser-lote-internac.nr-nota-fis = b-nota-fiscal.nr-nota-fis
                        AND   fatur-ser-lote-internac.nr-seq-fat = movto-estoq.sequen-nf
                        AND   fatur-ser-lote-internac.cod-depos = movto-estoq.cod-depos
                        AND   fatur-ser-lote-internac.cod-localiz = movto-estoq.cod-localiz
                        AND   fatur-ser-lote-internac.nr-serlote = movto-estoq.lote
                        AND   fatur-ser-lote-internac.it-codigo = movto-estoq.it-codigo
                        AND   fatur-ser-lote-internac.cod-refer = movto-estoq.cod-refer                                                
                        BY fatur-ser-lote-internac.qt-baixada:                        
                            
                        IF de-qtde-restante = 0 THEN
                            LEAVE fatur-ser-lote-internac.                        
                        
                        FOR FIRST bf{&TableName} EXCLUSIVE-LOCK
                            WHERE bf{&TableName}.cod-estabel       = fatur-ser-lote-internac.cod-estabel
                              AND bf{&TableName}.cod-depos         = fatur-ser-lote-internac.cod-depos  
                              AND bf{&TableName}.cod-localiz       = fatur-ser-lote-internac.cod-localiz
                              AND bf{&TableName}.it-codigo         = fatur-ser-lote-internac.it-codigo  
                              AND bf{&TableName}.cod-refer         = fatur-ser-lote-internac.cod-refer  
                              AND bf{&TableName}.lote              = fatur-ser-lote-internac.nr-serlote       
                              AND bf{&TableName}.declaracao-import = fatur-ser-lote-internac.declaracao-import:
                            
                            ASSIGN
                                de-qt-baixada = fatur-ser-lote-internac.qt-baixada 
                                de-qtde-atual = de-qtde-restante
                                de-qtde-restante = de-qtde-atual - de-qt-baixada.
                                
                            IF de-qtde-restante < 0 THEN
                                ASSIGN 
                                    de-qtde-restante = 0
                                    de-qt-baixada = de-qtde-atual.
                            
                            ASSIGN 
                                bf{&TableName}.qtidade-atu = bf{&TableName}.qtidade-atu + de-qt-baixada
                                fatur-ser-lote-internac.val-livre-1 = fatur-ser-lote-internac.val-livre-1 + de-qt-baixada.
        
                            RUN criaMovtoControleAduana IN h-boin01068(INPUT movto-estoq.nr-trans, 
                                                                       INPUT ROWID(bf{&TableName}),
                                                                       INPUT de-qt-baixada).                                                                                                                                                                          
                        END.
                    END.                        
                END.
            END.
        END.

        IF  VALID-HANDLE(h-boin01068) THEN DO:
            RUN destroy IN h-boin01068.
            ASSIGN h-boin01068 = ?.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraTempTableAduana DBOProgram 
PROCEDURE piGeraTempTableAduana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-rowid      AS ROWID NO-UNDO.
    DEF OUTPUT PARAM TABLE        FOR tt-aduana.

    FIND FIRST nota-fiscal NO-LOCK
        where rowid(nota-fiscal) = p-rowid NO-ERROR.

    IF NOT AVAIL nota-fiscal THEN
        RETURN "NOK":U. 

    FOR EACH it-nota-fisc NO-LOCK
        WHERE it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
        AND it-nota-fisc.serie       = nota-fiscal.serie 
        AND it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel: 

        FOR EACH fatur-ser-lote-internac NO-LOCK                                                                      
            WHERE fatur-ser-lote-internac.cod-estabel = it-nota-fisc.cod-estabel                                       
            AND fatur-ser-lote-internac.serie       = it-nota-fisc.serie                                            
            AND fatur-ser-lote-internac.nr-nota-fis = it-nota-fisc.nr-nota-fis 
            AND fatur-ser-lote-internac.it-codigo   = it-nota-fisc.it-codigo 
            AND fatur-ser-lote-internac.nr-seq-fat  = it-nota-fisc.nr-seq-fat: 

            CREATE tt-aduana.
            ASSIGN tt-aduana.c-it-codigo   = it-nota-fisc.it-codigo
                tt-aduana.i-secuecia       = it-nota-fisc.nr-seq-fat
                tt-aduana.c-num-ped-aduana = TRIM(SUBSTRING(fatur-ser-lote-internac.declaracao-import, 1, 2) 
                                                    + '  ' +  
                                                    SUBSTRING(fatur-ser-lote-internac.declaracao-import, 3, 2) 
                                                    + '  ' +  
                                                    SUBSTRING(fatur-ser-lote-internac.declaracao-import, 5, 4) 
                                                    + '  ' +
                                                    SUBSTRING(fatur-ser-lote-internac.declaracao-import, 9, 7)).
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDadosSdoAduana DBOProgram 
PROCEDURE retornaDadosSdoAduana :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM p-cod-estab  LIKE sdo-estoq-internac.cod-estabel NO-UNDO.
DEF INPUT  PARAM p-cod-depos  LIKE sdo-estoq-internac.cod-depos   NO-UNDO.
DEF INPUT  PARAM p-cod-local  LIKE sdo-estoq-internac.cod-localiz NO-UNDO.
DEF INPUT  PARAM p-it-codigo  LIKE sdo-estoq-internac.it-codigo   NO-UNDO.
DEF INPUT  PARAM p-cod-refer  LIKE sdo-estoq-internac.cod-refer   NO-UNDO.
DEF INPUT  PARAM p-lote       LIKE sdo-estoq-internac.lote        NO-UNDO.
DEF OUTPUT PARAM p-des-estab  LIKE estabelec.nome                 NO-UNDO.
DEF OUTPUT PARAM p-des-dep    LIKE deposito.nome                  NO-UNDO.
DEF OUTPUT PARAM p-des-locali LIKE localizacao.descricao          NO-UNDO.
DEF OUTPUT PARAM p-des-item   LIKE ITEM.desc-item                 NO-UNDO.
DEF OUTPUT PARAM p-des-refer  LIKE referencia.descricao           NO-UNDO.
DEF OUTPUT PARAM TABLE         FOR tt-sdo-estoq-internac-aux.

EMPTY TEMP-TABLE tt-sdo-estoq-internac-aux.

    FOR EACH bf{&TableName}
       WHERE bf{&TableName}.cod-estabel = p-cod-estab
         AND bf{&TableName}.cod-depos   = p-cod-depos
         AND bf{&TableName}.cod-localiz = p-cod-local
         AND bf{&TableName}.it-codigo   = p-it-codigo
         AND bf{&TableName}.cod-refer   = p-cod-refer
         AND bf{&TableName}.lote        = p-lote     NO-LOCK:
          
         FIND FIRST internac-decla-aduana
              WHERE internac-decla-aduana.declaracao-import = bf{&TableName}.declaracao-import NO-LOCK NO-ERROR.

         IF AVAIL internac-decla-aduana THEN DO:    
           CREATE tt-sdo-estoq-internac-aux.                                
           ASSIGN tt-sdo-estoq-internac-aux.cdn-aduana        = internac-decla-aduana.cdn-aduana           
                  tt-sdo-estoq-internac-aux.cdn-agent         = internac-decla-aduana.cdn-agent            
                  tt-sdo-estoq-internac-aux.cod-destinac      = internac-decla-aduana.cod-destinac         
                  tt-sdo-estoq-internac-aux.cod-verfdor       = internac-decla-aduana.cod-verfdor          
                  tt-sdo-estoq-internac-aux.cod-despch        = internac-decla-aduana.cod-despch           
                  tt-sdo-estoq-internac-aux.cdn-ano-import    = internac-decla-aduana.cdn-ano-import       
                  tt-sdo-estoq-internac-aux.idi-operac-import = internac-decla-aduana.idi-operac-import    
                  tt-sdo-estoq-internac-aux.qtidade-atu       = bf{&TableName}.qtidade-atu            
                  tt-sdo-estoq-internac-aux.qt-alocada        = bf{&TableName}.qt-alocada             
                  tt-sdo-estoq-internac-aux.declaracao-import = bf{&TableName}.declaracao-import      
                  tt-sdo-estoq-internac-aux.data-di           = bf{&TableName}.data-di.               
         END.
    END.
    FIND FIRST estabelec
         WHERE estabelec.cod-estabel = p-cod-estab NO-LOCK NO-ERROR.
    FIND FIRST deposito
         WHERE deposito.cod-depos = p-cod-depos NO-LOCK NO-ERROR.
    FIND FIRST localizacao
         WHERE localizacao.cod-estabel = p-cod-estab
           AND localizacao.cod-depos   = p-cod-depos
           AND localizacao.cod-localiz = p-cod-local NO-LOCK NO-ERROR.
    FIND FIRST ITEM
         WHERE ITEM.it-codigo = p-it-codigo NO-LOCK NO-ERROR.
    FIND FIRST referencia
         WHERE referencia.cod-refer = p-cod-refer NO-LOCK NO-ERROR.
     
    ASSIGN p-des-estab  = IF AVAIL estabelec   THEN estabelec.nome        ELSE ""
           p-des-dep    = IF AVAIL deposito    THEN deposito.nome         ELSE ""
           p-des-locali = IF AVAIL localizacao THEN localizacao.descricao ELSE ""
           p-des-item   = IF AVAIL ITEM        THEN ITEM.desc-item        ELSE ""
           p-des-refer  = IF AVAIL referencia  THEN referencia.descricao  ELSE "".

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaSdoDisponDeclar DBOProgram 
PROCEDURE retornaSdoDisponDeclar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF  INPUT PARAM p-cod-estab LIKE saldo-estoq.cod-estabel NO-UNDO.
    DEF  INPUT PARAM p-cod-depos LIKE saldo-estoq.cod-depos   NO-UNDO.
    DEF  INPUT PARAM p-cod-local LIKE saldo-estoq.cod-localiz NO-UNDO.
    DEF  INPUT PARAM p-it-codigo LIKE saldo-estoq.it-codigo   NO-UNDO.
    DEF  INPUT PARAM p-cod-refer LIKE saldo-estoq.cod-refer   NO-UNDO.
    DEF  INPUT PARAM p-lote      LIKE saldo-estoq.lote        NO-UNDO.
    DEF OUTPUT PARAM p-declar    AS CHAR FORMAT "x(20)"       NO-UNDO.
    DEF OUTPUT PARAM p-habilita  AS LOG INIT NO               NO-UNDO.
    
    DEF VAR i-cont  AS INT NO-UNDO.
    DEF VAR d-saldo AS DEC NO-UNDO.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-estabel = p-cod-estab
          AND bf{&TableName}.cod-depos   = p-cod-depos
          AND bf{&TableName}.cod-localiz = p-cod-local
          AND bf{&TableName}.it-codigo   = p-it-codigo
          AND bf{&TableName}.cod-refer   = p-cod-refer
          AND bf{&TableName}.lote        = p-lote:

        /* considera apenas os que possuem saldo */
        IF  bf{&TableName}.qtidade-atu - bf{&TableName}.qt-alocada <= 0 THEN
            NEXT.

        ASSIGN d-saldo = d-saldo + bf{&TableName}.qtidade-atu - bf{&TableName}.qt-alocada.

        ASSIGN i-cont = i-cont + 1
               p-declar = bf{&TableName}.declaracao-import.        

    END.

    /* Se n∆o encontrou nenhum saldo, retorna ao programa original com valor em branco */
    IF  i-cont = 0 THEN DO:
        ASSIGN p-declar = ""
               p-habilita = NO.
        RETURN "OK":U.
    END.

    /* Se somente existir um despacho disponivel, retorna este saldo. */
    IF  i-cont = 1 THEN DO:

        /* Verifica se tambÇm existe saldo disponivel sem DI */
        IF CAN-FIND(FIRST saldo-estoq 
                    WHERE saldo-estoq.cod-depos   = p-cod-depos  
                      and saldo-estoq.cod-estabel = p-cod-estab
                      and saldo-estoq.cod-localiz = p-cod-local                                                   
                      and saldo-estoq.lote        = p-lote       
                      and saldo-estoq.it-codigo   = p-it-codigo  
                      and saldo-estoq.cod-refer   = p-cod-refer  
                      AND (saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada) > d-saldo) THEN DO:
            ASSIGN p-declar = ""
                   p-habilita = YES.
            
        END.
        ELSE
            ASSIGN p-habilita = NO.

        RETURN "OK":U.
    END.

    /* Existe mais de um. Habilita o campo para o usu†rio selecionar o despacho */
    IF  i-cont > 1 THEN DO:
        ASSIGN p-declar = ""
               p-habilita = YES.
        RETURN "OK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSaldoDeclar DBOProgram 
PROCEDURE validaSaldoDeclar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF  INPUT PARAM p-cod-estab  LIKE saldo-estoq.cod-estabel NO-UNDO.
    DEF  INPUT PARAM p-cod-depos  LIKE saldo-estoq.cod-depos   NO-UNDO.
    DEF  INPUT PARAM p-cod-local  LIKE saldo-estoq.cod-localiz NO-UNDO.
    DEF  INPUT PARAM p-it-codigo  LIKE saldo-estoq.it-codigo   NO-UNDO.
    DEF  INPUT PARAM p-cod-refer  LIKE saldo-estoq.cod-refer   NO-UNDO.
    DEF  INPUT PARAM p-lote       LIKE saldo-estoq.lote        NO-UNDO.
    DEF  INPUT PARAM p-declar     AS CHAR FORMAT "x(20)"       NO-UNDO.
    DEF  INPUT PARAM p-qt-validar LIKE saldo-estoq.qtidade-atu NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-erro.

    DEF VAR c-liter1   AS CHAR NO-UNDO.
    DEF VAR c-liter2   AS CHAR NO-UNDO.
    DEF VAR c-liter3   AS CHAR NO-UNDO.
    DEF VAR d-saldo    AS DEC  NO-UNDO.
    DEF VAR d-saldo-di AS DEC  NO-UNDO.

    EMPTY TEMP-TABLE tt-erro.

    FIND bf{&TableName}
        WHERE bf{&TableName}.cod-estabel       = p-cod-estab
          AND bf{&TableName}.cod-depos         = p-cod-depos
          AND bf{&TableName}.cod-localiz       = p-cod-local
          AND bf{&TableName}.it-codigo         = p-it-codigo
          AND bf{&TableName}.cod-refer         = p-cod-refer
          AND bf{&TableName}.lote              = p-lote
          AND bf{&TableName}.declaracao-import = p-declar NO-LOCK NO-ERROR.
    IF  AVAIL bf{&TableName} THEN DO:

        IF  bf{&TableName}.qtidade-atu - bf{&TableName}.qt-alocada >= p-qt-validar THEN
            RETURN "OK":U.
        ELSE DO:
            /*32439Ÿ0ŸQuantidade &1 invˇlida.ŸA quantidade &1 (&2) deve ser &3 a quantidade &4 (&5).*/

            {utp/ut-liter.i movimentada      *} ASSIGN c-liter1 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "menor ou igual" *} ASSIGN c-liter2 = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "da declaraá∆o"  *} ASSIGN c-liter3 = TRIM(RETURN-VALUE).

            run utp/ut-msgs.p (input "help":u,
                               input 32439,
                               input c-liter1 + "~~" + STRING(p-qt-validar) + "~~" + c-liter2 + "~~" + c-liter3 + "~~" + 
                                     STRING(bf{&TableName}.qtidade-atu - bf{&TableName}.qt-alocada)).
            
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 32439
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
            RETURN "NOK":U.
        END.
    END.
    ELSE DO:
        /* Somente retorna erro de que nao encontrou o saldo qdo foi informado um valor na declaraá∆o */
        IF  p-declar <> "" THEN DO:
        
            {utp/ut-liter.i Declaraá∆o_de_Importaá∆o *}
            run utp/ut-msgs.p (input "msg":u,
                               input 2,
                               input RETURN-VALUE).
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 2
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
            RETURN "NOK":U.
        END.
        ELSE DO:
            /* Se for infomado branco, deve possuir saldo suficiente sem estar atrelado Ös declaraá‰es */
            FOR EACH bf{&TableName} NO-LOCK
                WHERE bf{&TableName}.cod-estabel = p-cod-estab
                  AND bf{&TableName}.cod-depos   = p-cod-depos
                  AND bf{&TableName}.cod-localiz = p-cod-local
                  AND bf{&TableName}.it-codigo   = p-it-codigo
                  AND bf{&TableName}.cod-refer   = p-cod-refer
                  AND bf{&TableName}.lote        = p-lote:
        
                /* considera apenas os que possuem saldo */
                IF  bf{&TableName}.qtidade-atu - bf{&TableName}.qt-alocada <= 0 THEN
                    NEXT.
        
                ASSIGN d-saldo-di = d-saldo-di + bf{&TableName}.qtidade-atu - bf{&TableName}.qt-alocada.      
        
            END.

            FOR FIRST saldo-estoq NO-LOCK
                WHERE saldo-estoq.cod-depos   = p-cod-depos  
                  and saldo-estoq.cod-estabel = p-cod-estab
                  and saldo-estoq.cod-localiz = p-cod-local                                                   
                  and saldo-estoq.lote        = p-lote       
                  and saldo-estoq.it-codigo   = p-it-codigo  
                  and saldo-estoq.cod-refer   = p-cod-refer:

                  ASSIGN d-saldo = saldo-estoq.qtidade-atu - saldo-estoq.qt-alocada.
            END.

            IF d-saldo < d-saldo-di + p-qt-validar THEN DO:
                /*32439 ŸŸ Quantidade &1 inv†lida. ~~ A quantidade &1 (&2) deve ser &3 a quantidade &4 (&5).*/
                {utp/ut-liter.i movimentada      *} ASSIGN c-liter1 = TRIM(RETURN-VALUE).
                {utp/ut-liter.i "menor ou igual" *} ASSIGN c-liter2 = TRIM(RETURN-VALUE).
    
                run utp/ut-msgs.p (input "help":u,
                                   input 32439,
                                   input c-liter1 + "~~" + STRING(p-qt-validar) + "~~" + c-liter2 + "~~~~" + 
                                         STRING(d-saldo - d-saldo-di)).
                
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 32439
                       tt-erro.mensagem = TRIM(RETURN-VALUE).
                RETURN "NOK":U.
            END.
        END.
    END.
    
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

