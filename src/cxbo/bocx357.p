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
{include/i-prgvrs.i BOCX357 2.00.00.012 } /*** "010012" 15/10/2025 07:56:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx357 MUT}
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
&GLOBAL-DEFINE DBOName BOCX357
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName ped-ent-desp
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
{cxbo/bocx357.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cNomeAbrev   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNrPedCli    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCdnDespes   AS INTEGER    NO-UNDO.
DEFINE VARIABLE h-exapi015   AS HANDLE      NO-UNDO.

define temp-table tt-desp-entr no-undo
    FIELD cod-emitente-desp AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD nome-emit         AS CHARACTER FORMAT "x(40)"
    FIELD cdn-despes        AS INTEGER   FORMAT ">>,>>9"
    FIELD desc-desp         AS CHARACTER FORMAT "x(30)"
    FIELD cod-pto-contr     AS INTEGER   FORMAT ">>,>>9" 
    FIELD desc-pto-contr    AS CHARACTER FORMAT "x(30)"
    FIELD log-forma-preco   AS LOGICAL   FORMAT "Sim/N∆o"
    FIELD mo-codigo         AS INTEGER   FORMAT ">9"
    FIELD desc-mo           AS CHARACTER FORMAT "x(12)"
    FIELD val-desp          AS DECIMAL   FORMAT ">>>,>>>,>>9.99".

{exp/exapi015.i} /* Definiá∆o Temp-tables Rateio Despesas para as Entregas */
{cxbo/bocx357.i tt-ped-ent-desp}

DEFINE TEMP-TABLE tt-despes-fatur NO-UNDO
    FIELD cdn-despes   LIKE ped-venda-desp.cdn-despes
    FIELD val-despes   LIKE ped-venda-desp.val-despes
    FIELD mo-codigo    LIKE ped-venda-desp.mo-codigo.

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
         HEIGHT             = 15.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AlteraCodigoItem DBOProgram 
PROCEDURE AlteraCodigoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pcItCodigo    LIKE ITEM.it-codigo NO-UNDO.
    DEF INPUT PARAM pcNewItCodigo LIKE ITEM.it-codigo NO-UNDO.

    FOR EACH  ped-ent-desp EXCLUSIVE-LOCK
        WHERE ped-ent-desp.it-codigo  = pcItCodigo:
            ASSIGN ped-ent-desp.it-codigo = pcNewItCodigo.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTDespEntrDesp DBOProgram 
PROCEDURE criaTTDespEntrDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev-desp   LIKE ped-ent-desp.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli-desp    LIKE ped-ent-desp.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-desp-entr.

    EMPTY TEMP-TABLE tt-desp-entr.
    FOR EACH ped-ent-desp NO-LOCK
       WHERE ped-ent-desp.nome-abrev   = pnome-abrev-desp        
         AND ped-ent-desp.nr-pedcli    = pnr-pedcli-desp 
         BREAK BY ped-ent-desp.nome-abrev
               BY ped-ent-desp.nr-pedcli
               BY ped-ent-desp.cdn-despes :
         
       IF FIRST-OF(ped-ent-desp.cdn-despes) THEN DO:
           CREATE tt-desp-entr.
            ASSIGN tt-desp-entr.cdn-despes = ped-ent-desp.cdn-despes.
                                                                     
            FIND FIRST desp-imp
                 WHERE desp-imp.cod-desp = ped-ent-desp.cdn-despes NO-LOCK NO-ERROR.
            IF AVAIL desp-imp THEN
                ASSIGN tt-desp-entr.desc-desp = desp-imp.descricao.
    
            FIND FIRST ped-venda-desp 
                 WHERE ped-venda-desp.nome-abrev = ped-ent-desp.nome-abrev
                   AND ped-venda-desp.nr-pedcli  = ped-ent-desp.nr-pedcli 
                   AND ped-venda-desp.cdn-despes = ped-ent-desp.cdn-despes NO-LOCK NO-ERROR.
    
            IF AVAIL ped-venda-desp THEN DO:
                ASSIGN tt-desp-entr.cod-emitente-desp = ped-venda-desp.cod-emitente-desp
                       tt-desp-entr.cod-pto-contr     = ped-venda-desp.cod-pto-contr
                       tt-desp-entr.log-forma-preco   = ped-venda-desp.log-forma-preco
                       tt-desp-entr.mo-codigo         = ped-venda-desp.mo-codigo
                       tt-desp-entr.val-desp          = ped-venda-desp.val-despes.
                
                FOR FIRST emitente FIELDS(nome-emit)  NO-LOCK
                    WHERE emitente.cod-emitente = ped-venda-desp.cod-emitente-desp:
                    ASSIGN tt-desp-entr.nome-emit = emitente.nome-emit.
                END.
                
                FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
                    WHERE pto-contr.cod-pto-contr = ped-venda-desp.cod-pto-contr:
                    ASSIGN tt-desp-entr.desc-pto-contr = pto-contr.descricao.
                END.
                
                FOR FIRST moeda FIELDS(descricao) NO-LOCK
                    WHERE moeda.mo-codigo = ped-venda-desp.mo-codigo:
                    ASSIGN tt-desp-entr.desc-mo = moeda.descricao.
                END.

            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTDespEntrItem DBOProgram 
PROCEDURE criaTTDespEntrItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev-item   LIKE ped-ent-desp.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli-item    LIKE ped-ent-desp.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia-item LIKE ped-ent-desp.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo-item    LIKE ped-ent-desp.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer-item    LIKE ped-ent-desp.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pnr-entrega-item   LIKE ped-ent-desp.nr-entrega NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-desp-entr.

   EMPTY TEMP-TABLE tt-desp-entr.
    FOR EACH ped-ent-desp 
       WHERE ped-ent-desp.nome-abrev   = pnome-abrev-item        
         AND ped-ent-desp.nr-pedcli    = pnr-pedcli-item    
         AND ped-ent-desp.nr-sequencia = pnr-sequencia-item 
         AND ped-ent-desp.it-codigo    = pit-codigo-item    
         AND ped-ent-desp.cod-refer    = pcod-refer-item    
         AND ped-ent-desp.nr-entrega   = pnr-entrega-item NO-LOCK:
        CREATE tt-desp-entr.
        ASSIGN tt-desp-entr.cdn-despes = ped-ent-desp.cdn-despes
               tt-desp-entr.val-desp   = ped-ent-desp.val-despes.

        FIND FIRST desp-imp
             WHERE desp-imp.cod-desp = ped-ent-desp.cdn-despes NO-LOCK NO-ERROR.
        IF AVAIL desp-imp THEN
            ASSIGN tt-desp-entr.desc-desp = desp-imp.descricao.

        FIND FIRST ped-venda-desp 
             WHERE ped-venda-desp.nome-abrev = ped-ent-desp.nome-abrev
               AND ped-venda-desp.nr-pedcli  = ped-ent-desp.nr-pedcli 
               AND ped-venda-desp.cdn-despes = ped-ent-desp.cdn-despes NO-LOCK NO-ERROR.

        IF AVAIL ped-venda-desp THEN DO:
            ASSIGN tt-desp-entr.cod-emitente-desp = ped-venda-desp.cod-emitente-desp
                   tt-desp-entr.cod-pto-contr     = ped-venda-desp.cod-pto-contr
                   tt-desp-entr.log-forma-preco   = ped-venda-desp.log-forma-preco
                   tt-desp-entr.mo-codigo         = ped-venda-desp.mo-codigo.
            
            FOR FIRST emitente FIELDS(nome-emit)  NO-LOCK
                WHERE emitente.cod-emitente = ped-venda-desp.cod-emitente-desp:
                ASSIGN tt-desp-entr.nome-emit = emitente.nome-emit.
            END.
            
            FOR FIRST pto-contr FIELDS(descricao) NO-LOCK
                WHERE pto-contr.cod-pto-contr = ped-venda-desp.cod-pto-contr:
                ASSIGN tt-desp-entr.desc-pto-contr = pto-contr.descricao.
            END.
            
            FOR FIRST moeda FIELDS(descricao) NO-LOCK
                WHERE moeda.mo-codigo = ped-venda-desp.mo-codigo:
                ASSIGN tt-desp-entr.desc-mo = moeda.descricao.
            END.

        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraDespesasEntregas DBOProgram 
PROCEDURE geraDespesasEntregas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-ped-venda AS ROWID NO-UNDO.

    DEFINE VARIABLE de-despes-fatur LIKE ped-venda-desp.val-despes          NO-UNDO.
    DEFINE VARIABLE de-valor-despes AS   DECIMAL FORMAT "->>>,>>>,>>9.99":U NO-UNDO.
    DEFINE VARIABLE de-fator-conver AS   DECIMAL INITIAL 1                  NO-UNDO.

    /*Convers∆o do valor do volume do item*/
    FOR FIRST para-dis NO-LOCK:
        /*Unidade de Medida da Convers∆o 1 = Cent°metros 2 = Metros*/
        IF para-dis.int-1 = 1 THEN
            ASSIGN de-fator-conver = 0.000001.
        ELSE
            ASSIGN de-fator-conver = 1.
    END.
    

    FIND FIRST ped-venda 
         WHERE ROWID(ped-venda) = pr-ped-venda NO-LOCK NO-ERROR.

    IF  AVAIL ped-venda THEN DO:

        IF  NOT VALID-HANDLE(h-exapi015) THEN
            RUN exp/exapi015.p PERSISTENT SET h-exapi015.
        
        EMPTY TEMP-TABLE tt-entrega.
        EMPTY TEMP-TABLE tt-ped-ent-desp.

        FOR EACH ped-ent OF ped-venda NO-LOCK:

            FIND FIRST ped-item OF ped-ent WHERE ped-item.ind-componen <> 3 NO-LOCK NO-ERROR.

            IF AVAIL ped-item THEN DO:
                     
                IF ped-item.cod-sit-item = 6 THEN NEXT.

                FOR FIRST ITEM FIELDS(peso-liquido largura comprim altura)
                    WHERE ITEM.it-codigo = ped-ent.it-codigo NO-LOCK: 
                END.

                CREATE tt-entrega.
                ASSIGN tt-entrega.nome-abrev   = ped-ent.nome-abrev
                       tt-entrega.nr-pedcli    = ped-ent.nr-pedcli 
                       tt-entrega.nr-sequencia = ped-ent.nr-sequencia
                       tt-entrega.it-codigo    = ped-ent.it-codigo   
                       tt-entrega.cod-refer    = ped-ent.cod-refer   
                       tt-entrega.nr-entrega   = ped-ent.nr-entrega  
                       tt-entrega.quantidade   = ped-ent.qt-pedida - ped-ent.qt-atendida
                       tt-entrega.valor        = ped-item.vl-preuni
                       tt-entrega.peso-liquido = IF AVAIL ITEM THEN (ITEM.peso-liquido * tt-entrega.quantidade) ELSE 0
                       tt-entrega.volume       = IF AVAIL ITEM THEN  (ITEM.largura * ITEM.comprim * ITEM.altura) * de-fator-conver  ELSE 0.

                FOR EACH it-nota-fisc 
                   WHERE it-nota-fisc.nome-ab-cli = ped-ent.nome-abrev   
                     AND it-nota-fisc.nr-pedcli   = ped-ent.nr-pedcli    
                     AND it-nota-fisc.nr-seq-ped  = ped-ent.nr-sequencia 
                     AND it-nota-fisc.it-codigo   = ped-ent.it-codigo    
                     AND it-nota-fisc.cod-refer   = ped-ent.cod-refer    
                     AND it-nota-fisc.nr-entrega  = ped-ent.nr-entrega NO-LOCK:

                     FOR FIRST nota-fiscal FIELDS (dt-cancela) 
                         WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel 
                           AND nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis  
                           AND nota-fiscal.serie       = it-nota-fisc.serie NO-LOCK:
                     END.
                     IF AVAIL nota-fiscal THEN
                        IF nota-fiscal.dt-cancela <> ? THEN NEXT.

                     FOR EACH proc-it-nota-desp 
                        WHERE proc-it-nota-desp.cod-estab-faturam = it-nota-fisc.cod-estabel 
                          AND proc-it-nota-desp.serie       = it-nota-fisc.serie       
                          AND proc-it-nota-desp.nr-nota-fis = it-nota-fisc.nr-nota-fis 
                          AND proc-it-nota-desp.nr-seq-fat  = it-nota-fisc.nr-seq-fat  
                          AND proc-it-nota-desp.it-codigo   = it-nota-fisc.it-codigo NO-LOCK:

                        /*Acumula despesas j† faturadas totais por cod-desp*/
                         FIND tt-despes-fatur WHERE tt-despes-fatur.cdn-despes = proc-it-nota-desp.cdn-despes NO-ERROR.
                         IF NOT AVAIL tt-despes-fatur THEN DO:
                             CREATE tt-despes-fatur.
                             ASSIGN tt-despes-fatur.cdn-despes = proc-it-nota-desp.cdn-despes
                                    tt-despes-fatur.val-despes = proc-it-nota-desp.val-despes.
                         END.
                         ELSE DO:
                             ASSIGN tt-despes-fatur.val-despes = tt-despes-fatur.val-despes + proc-it-nota-desp.val-despes.
                         END.

                         /*Cria temp-table de rateio para as despesas j† faturadas pois seu valor n∆o poder† ser alterado*/
                         FIND FIRST tt-ped-ent-desp 
                              WHERE tt-ped-ent-desp.nome-abrev = it-nota-fisc.nome-ab-cli         
                                AND tt-ped-ent-desp.nr-pedcli       = it-nota-fisc.nr-pedcli      
                                AND tt-ped-ent-desp.nr-sequencia    = it-nota-fisc.nr-seq-ped     
                                AND tt-ped-ent-desp.it-codigo       = proc-it-nota-desp.it-codigo 
                                AND tt-ped-ent-desp.cod-refer       = it-nota-fisc.cod-refer      
                                AND tt-ped-ent-desp.nr-entrega      = it-nota-fisc.nr-entrega     
                                AND tt-ped-ent-desp.cdn-despes      = proc-it-nota-desp.cdn-despes NO-LOCK NO-ERROR.

                         IF  NOT AVAIL tt-ped-ent-desp THEN DO:
                             CREATE tt-ped-ent-desp.
                             ASSIGN tt-ped-ent-desp.nome-abrev    = it-nota-fisc.nome-ab-cli  
                                    tt-ped-ent-desp.nr-pedcli     = it-nota-fisc.nr-pedcli   
                                    tt-ped-ent-desp.nr-sequencia  = it-nota-fisc.nr-seq-ped
                                    tt-ped-ent-desp.it-codigo     = proc-it-nota-desp.it-codigo   
                                    tt-ped-ent-desp.cod-refer     = it-nota-fisc.cod-refer   
                                    tt-ped-ent-desp.nr-entrega    = it-nota-fisc.nr-entrega  
                                    tt-ped-ent-desp.cdn-despes    = proc-it-nota-desp.cdn-despes.

                         END.
                         ASSIGN tt-ped-ent-desp.val-despes = tt-ped-ent-desp.val-despes + proc-it-nota-desp.val-despes.
                     END.
                 END.

            END.
        END.
    
        EMPTY TEMP-TABLE tt-despesa.

        FOR EACH ped-venda-desp
           WHERE ped-venda-desp.nome-abrev = ped-venda.nome-abrev
             AND ped-venda-desp.nr-pedcli  = ped-venda.nr-pedcli NO-LOCK:

            FIND FIRST tt-despes-fatur 
                 WHERE tt-despes-fatur.cdn-despes = ped-venda-desp.cdn-despes NO-ERROR.
            IF AVAIL tt-despes-fatur THEN 
               ASSIGN de-despes-fatur = tt-despes-fatur.val-despes.
            ELSE 
               ASSIGN de-despes-fatur = 0.
            
            ASSIGN de-valor-despes = (ped-venda-desp.val-despes - de-despes-fatur).

            IF de-valor-despes < 0 THEN 
                ASSIGN de-valor-despes = 0.

            CREATE tt-despesa.
            ASSIGN tt-despesa.cdn-despes = ped-venda-desp.cdn-despes
                   tt-despesa.val-despes = de-valor-despes
                   tt-despesa.mo-codigo  = ped-venda-desp.mo-codigo.
        END.
    
        EMPTY TEMP-TABLE tt-despes-fatur.
        EMPTY TEMP-TABLE tt-param.

        FOR FIRST ped-venda-cex FIELDS(volume)
            WHERE ped-venda-cex.nr-pedido = ped-venda.nr-pedido NO-LOCK:
            CREATE tt-param.
            ASSIGN tt-param.campo = "Volume":U
                   tt-param.valor = ped-venda-cex.volume.
        END.
    
        RUN geraTTPedEntDesp IN h-exapi015 (INPUT  TABLE tt-entrega,
                                            INPUT  TABLE tt-despesa,
                                            INPUT  TABLE tt-param,
                                            OUTPUT TABLE tt-despes-entr).
    
        FOR EACH ped-ent-desp EXCLUSIVE-LOCK
           WHERE ped-ent-desp.nome-abrev = ped-venda.nome-abrev
             AND ped-ent-desp.nr-pedcli  = ped-venda.nr-pedcli:
            DELETE ped-ent-desp.
        END.
        
        FOR EACH tt-despes-entr:
            /*Verifica se j† existe um registro na temp-table de rateio, se existir quer dizer que esta despesa ja foi faturada parcialmente
              sendo assim somente dever† ser acumulado o valor rateado em aberto*/
            FIND FIRST tt-ped-ent-desp 
                 WHERE tt-ped-ent-desp.nome-abrev    = tt-despes-entr.nome-abrev   
                   AND tt-ped-ent-desp.nr-pedcli     = tt-despes-entr.nr-pedcli    
                   AND tt-ped-ent-desp.nr-sequencia  = tt-despes-entr.nr-sequencia 
                   AND tt-ped-ent-desp.it-codigo     = tt-despes-entr.it-codigo    
                   AND tt-ped-ent-desp.cod-refer     = tt-despes-entr.cod-refer    
                   AND tt-ped-ent-desp.nr-entrega    = tt-despes-entr.nr-entrega   
                   AND tt-ped-ent-desp.cdn-despes    = tt-despes-entr.cdn-despes   NO-ERROR.
            IF AVAIL tt-ped-ent-desp THEN DO:
                ASSIGN tt-ped-ent-desp.val-despes = tt-ped-ent-desp.val-despes + tt-despes-entr.val-despes.
            END.
            ELSE DO:
                CREATE tt-ped-ent-desp.
                ASSIGN tt-ped-ent-desp.nome-abrev   = tt-despes-entr.nome-abrev  
                       tt-ped-ent-desp.nr-pedcli    = tt-despes-entr.nr-pedcli   
                       tt-ped-ent-desp.nr-sequencia = tt-despes-entr.nr-sequencia
                       tt-ped-ent-desp.it-codigo    = tt-despes-entr.it-codigo   
                       tt-ped-ent-desp.cod-refer    = tt-despes-entr.cod-refer   
                       tt-ped-ent-desp.nr-entrega   = tt-despes-entr.nr-entrega  
                       tt-ped-ent-desp.cdn-despes   = tt-despes-entr.cdn-despes  
                       tt-ped-ent-desp.val-despes   = tt-despes-entr.val-despes.
            END.
        END.
        
        FOR EACH tt-ped-ent-desp:
           RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).           
           RUN emptyRowErrors  IN THIS-PROCEDURE.
           RUN emptyRowObject  IN THIS-PROCEDURE.
           RUN setRecord       IN THIS-PROCEDURE (INPUT TABLE tt-ped-ent-desp).
           RUN createRecord    IN THIS-PROCEDURE.
           
           DELETE tt-ped-ent-desp.
        END.

        IF  VALID-HANDLE (h-exapi015) THEN DO:
            DELETE PROCEDURE h-exapi015.
            ASSIGN h-exapi015 = ?.
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
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
        WHEN "val-despes":U THEN ASSIGN pFieldValue = RowObject.val-despes.
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
        WHEN "cdn-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-despes.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
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
  Purpose:     Retorna valores dos campos do °ndice pdntrgds-id
  Parameters:  
               retorna valor do campo nome-abrev
               retorna valor do campo nr-pedcli
               retorna valor do campo nr-sequencia
               retorna valor do campo it-codigo
               retorna valor do campo cod-refer
               retorna valor do campo nr-entrega
               retorna valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE ped-ent-desp.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE ped-ent-desp.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia LIKE ped-ent-desp.nr-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE ped-ent-desp.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE ped-ent-desp.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-entrega LIKE ped-ent-desp.nr-entrega NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-despes LIKE ped-ent-desp.cdn-despes NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnome-abrev   = RowObject.nome-abrev
           pnr-pedcli    = RowObject.nr-pedcli
           pnr-sequencia = RowObject.nr-sequencia
           pit-codigo    = RowObject.it-codigo
           pcod-refer    = RowObject.cod-refer
           pnr-entrega   = RowObject.nr-entrega
           pcdn-despes   = RowObject.cdn-despes.

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
  Purpose:     Reposiciona registro com base no °ndice pdntrgds-id
  Parameters:  
               recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
               recebe valor do campo nr-sequencia
               recebe valor do campo it-codigo
               recebe valor do campo cod-refer
               recebe valor do campo nr-entrega
               recebe valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE ped-ent-desp.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE ped-ent-desp.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia LIKE ped-ent-desp.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE ped-ent-desp.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE ped-ent-desp.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pnr-entrega LIKE ped-ent-desp.nr-entrega NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-despes LIKE ped-ent-desp.cdn-despes NO-UNDO.

    FIND FIRST bfped-ent-desp WHERE 
        bfped-ent-desp.nome-abrev = pnome-abrev AND 
        bfped-ent-desp.nr-pedcli = pnr-pedcli AND 
        bfped-ent-desp.nr-sequencia = pnr-sequencia AND 
        bfped-ent-desp.it-codigo = pit-codigo AND 
        bfped-ent-desp.cod-refer = pcod-refer AND 
        bfped-ent-desp.nr-entrega = pnr-entrega AND 
        bfped-ent-desp.cdn-despes = pcdn-despes NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfped-ent-desp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfped-ent-desp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDespesa DBOProgram 
PROCEDURE openQueryDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK 
                               WHERE {&tableName}.nome-abrev   = cNomeAbrev 
                                 AND {&tableName}.nr-pedcli    = cNrPedCli 
                                 AND {&tableName}.cdn-despes   = iCdnDespes INDEXED-REPOSITION.
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
OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedVenda DBOProgram 
PROCEDURE openQueryPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK 
                               WHERE {&tableName}.nome-abrev = cNomeAbrev 
                                 AND {&tableName}.nr-pedcli  = cNrPedCli INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDespesa DBOProgram 
PROCEDURE setConstraintDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNomeAbrev    AS CHARACTER NO-UNDO.
DEF INPUT PARAM pNrPedCli     AS CHARACTER NO-UNDO.
DEF INPUT PARAM pCdnDespes    AS INTEGER   NO-UNDO.

    ASSIGN cNomeAbrev   = pNomeAbrev  
           cNrPedCli    = pNrPedCli   
           iCdnDespes   = pCdnDespes.  
        
      RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedVenda DBOProgram 
PROCEDURE setConstraintPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pNomeAbrev AS CHARACTER NO-UNDO.
    DEF INPUT PARAM pNrPedCli AS CHARACTER NO-UNDO.

    ASSIGN cNomeAbrev = pNomeAbrev
           cNrPedCli  = pNrPedCli.

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

    IF pType = "Create":U THEN DO:

        IF CAN-FIND(FIRST ped-ent-desp
                    WHERE ped-ent-desp.nome-abrev   = RowObject.nome-abrev   
                      AND ped-ent-desp.nr-pedcli    = RowObject.nr-pedcli    
                      AND ped-ent-desp.nr-sequencia = RowObject.nr-sequencia 
                      AND ped-ent-desp.it-codigo    = RowObject.it-codigo    
                      AND ped-ent-desp.cod-refer    = RowObject.cod-refer    
                      AND ped-ent-desp.nr-entrega   = RowObject.nr-entrega   
                      AND ped-ent-desp.cdn-despes   = RowObject.cdn-despes) THEN DO:

                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-despesas-entregas-pedido AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Despesas_Entregas_Pedido" *}
                        ASSIGN c-lbl-liter-despesas-entregas-pedido = TRIM(RETURN-VALUE).
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="1"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-despesas-entregas-pedido"} 
        END.            
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

