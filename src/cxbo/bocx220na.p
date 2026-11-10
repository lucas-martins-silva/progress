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
{include/i-prgvrs.i BOCX220NA 2.00.00.010 } /*** "010010" 03/12/2024 19:07:35 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX220
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName embarque-imp
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
{cxbo/bocx220.i RowObject}
{cxbo/bocx220.i tt-embarque-imp-aux}

/*DEFINIÄ«O DA tt-param*/
{imp/im0420.i tt-param}
{imp/im0720.i tt-param-adiant}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR c-cod-estab  LIKE {&TABLENAME}.cod-estabel NO-UNDO.
DEF VAR i-num-di-ems LIKE decla-import.num-di-ems  NO-UNDO.
def var c-est-ini      like estabelec.cod-estabel    no-undo.
def var c-est-fim      like estabelec.cod-estabel    no-undo.
def var c-embarque-ini like embarque-imp.embarque    no-undo.
def var c-embarque-fim like embarque-imp.embarque    no-undo.

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
         HEIGHT             = 9.46
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
        WHEN "carta-credito":U THEN ASSIGN pFieldValue = RowObject.carta-credito.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-cobr-bcia":U THEN ASSIGN pFieldValue = RowObject.cod-cobr-bcia.
        WHEN "cod-conhecto-house":U THEN ASSIGN pFieldValue = RowObject.cod-conhecto-house.
        WHEN "cod-conhecto-master":U THEN ASSIGN pFieldValue = RowObject.cod-conhecto-master.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "declaracao-import":U THEN ASSIGN pFieldValue = RowObject.declaracao-import.
        WHEN "embarque":U THEN ASSIGN pFieldValue = RowObject.embarque.
        WHEN "embarque-ori":U THEN ASSIGN pFieldValue = RowObject.embarque-ori.
        WHEN "id-meio-transp":U THEN ASSIGN pFieldValue = RowObject.id-meio-transp.
        WHEN "licenca-import":U THEN ASSIGN pFieldValue = RowObject.licenca-import.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "nr-rof":U THEN ASSIGN pFieldValue = RowObject.nr-rof.
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
        WHEN "data-DI":U THEN ASSIGN pFieldValue = RowObject.data-DI.
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
        WHEN "val-perc-ir":U THEN ASSIGN pFieldValue = RowObject.val-perc-ir.
        WHEN "val-perc-juros":U THEN ASSIGN pFieldValue = RowObject.val-perc-juros.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEmbarqueImpByParams DBOProgram 
PROCEDURE getEmbarqueImpByParams :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM TABLE FOR tt-param.
DEF OUTPUT PARAM TABLE FOR tt-embarque-imp-aux.

FOR EACH tt-embarque-imp-aux:
    DELETE tt-embarque-imp-aux.
END.

FOR FIRST tt-param:
    FOR EACH  estabelec NO-LOCK
        WHERE estabelec.cod-estabel          >= tt-param.cod-estab-ini
        AND   estabelec.cod-estabel          <= tt-param.cod-estab-fim:

        blk_embarque:
        FOR EACH  embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel        = estabelec.cod-estabel
            AND   embarque-imp.embarque          >= tt-param.cdn-embarq-ini
            AND   embarque-imp.embarque          <= tt-param.cdn-embarq-fim
            AND   embarque-imp.int-2              = 0
            AND   embarque-imp.data-DI            = ?
            AND   embarque-imp.situacao           = 1:           
            FOR EACH  ordens-embarque NO-LOCK
                WHERE ordens-embarque.cod-estabel   = embarque-imp.cod-estabel
                AND   ordens-embarque.embarque      = embarque-imp.embarque
                AND   ordens-embarque.numero-ordem >= tt-param.numero-ordem-ini
                AND   ordens-embarque.numero-ordem <= tt-param.numero-ordem-fim:
                IF CAN-FIND(FIRST tt-embarque-imp-aux
                            WHERE tt-embarque-imp-aux.cod-estabel = embarque-imp.cod-estabel
                            AND   tt-embarque-imp-aux.embarque    = embarque-imp.embarque) THEN
                    NEXT blk_embarque.

                FOR FIRST processo-imp NO-LOCK
                    WHERE processo-imp.cod-estabel  = estabelec.cod-estabel
                    AND   processo-imp.nr-proc-imp  = ordens-embarque.nr-proc-imp
                    AND   processo-imp.nr-proc-imp >= tt-param.nr-proc-ini 
                    AND   processo-imp.nr-proc-imp <= tt-param.nr-proc-fim
                    AND   processo-imp.situacao <> 4:

                    IF  processo-imp.num-pedido < tt-param.num-pedido-ini 
                    OR  processo-imp.num-pedido > tt-param.num-pedido-fim THEN
                        NEXT.

                    CREATE tt-embarque-imp-aux.
                    BUFFER-COPY embarque-imp TO tt-embarque-imp-aux.
                END.
            END.
        END.
    END.
END.


RETURN "OK":U.
END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEmbarqueImpByAdiant DBOProgram 
PROCEDURE getEmbarqueImpByAdiant :
/*------------------------------------------------------------------------------
  Purpose: Filtro dos embarques para relacionamento com os adiantamentos de despesas     
  Parameters:  Recebe tabela de parametros do filtro
               Envia tabela de embarques de importaá∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM TABLE FOR tt-param-adiant.
    DEF OUTPUT PARAM TABLE FOR tt-embarque-imp-aux.
    
    EMPTY TEMP-TABLE  tt-embarque-imp-aux.
    
    FOR FIRST tt-param-adiant:
    
        blk_embarque:
        FOR EACH  embarque-imp NO-LOCK
            WHERE embarque-imp.cod-estabel        >= tt-param-adiant.cod-estab-ini  
            AND   embarque-imp.cod-estabel        <= tt-param-adiant.cod-estab-fim 
            AND   embarque-imp.embarque           >= tt-param-adiant.cdn-embarq-ini
            AND   embarque-imp.embarque           <= tt-param-adiant.cdn-embarq-fim
            AND   embarque-imp.situacao           = 1:

            IF  embarque-imp.int-2              < tt-param-adiant.num-di-ems-ini   OR   
                embarque-imp.int-2              > tt-param-adiant.num-di-ems-fim   OR  
                embarque-imp.declaracao-import  < tt-param-adiant.di-siscomex-ini  OR  
                embarque-imp.declaracao-import  > tt-param-adiant.di-siscomex-fim  OR   
                embarque-imp.data-di            < tt-param-adiant.dat-di-ini       OR  
                embarque-imp.data-di            > tt-param-adiant.dat-di-fim  THEN 
                NEXT blk_embarque.

            /* Verifica se j† est† relacionado a um adiantamento */
            IF CAN-FIND(FIRST adiant-despes-embarq
                        WHERE adiant-despes-embarq.cod-estabel = embarque-imp.cod-estabel 
                          AND adiant-despes-embarq.cod-embarq  = embarque-imp.embarque) THEN
                NEXT blk_embarque. 
            
            /*Verifica se possue nota gerada no recebimento*/
            IF CAN-FIND(FIRST embarq-import-docto 
                        WHERE embarq-import-docto.cod-estab   = embarque-imp.cod-estabel 
                        AND   embarq-import-docto.cod-embarq  = embarque-imp.embarque) THEN 
                NEXT blk_embarque. 

            FOR EACH  ordens-embarque NO-LOCK
                WHERE ordens-embarque.cod-estabel   = embarque-imp.cod-estabel
                AND   ordens-embarque.embarque      = embarque-imp.embarque
                AND   ordens-embarque.numero-ordem >= tt-param-adiant.numero-ordem-ini
                AND   ordens-embarque.numero-ordem <= tt-param-adiant.numero-ordem-fim,
                FIRST ordem-compra NO-LOCK 
                      WHERE ordem-compra.numero-ordem  = ordens-embarque.numero-ordem 
                      AND   ordem-compra.cod-emitente >= tt-param-adiant.cod-emitente-ini
                      AND   ordem-compra.cod-emitente <= tt-param-adiant.cod-emitente-fim,
                      FIRST emitente NO-LOCK
                            WHERE emitente.cod-emitente = ordem-compra.cod-emitente
                            AND   emitente.nome-abrev >= tt-param-adiant.nome-abrev-ini
                            AND   emitente.nome-abrev <= tt-param-adiant.nome-abrev-fim :

                IF  ordem-compra.num-pedido < tt-param-adiant.num-pedido-ini OR
                    ordem-compra.num-pedido > tt-param-adiant.num-pedido-fim THEN
                    NEXT blk_embarque.

                IF ordens-embarque.nr-proc-imp < tt-param-adiant.nr-proc-ini OR 
                   ordens-embarque.nr-proc-imp > tt-param-adiant.nr-proc-fim THEN
                   NEXT blk_embarque.

                IF CAN-FIND(FIRST tt-embarque-imp-aux
                            WHERE tt-embarque-imp-aux.cod-estabel = embarque-imp.cod-estabel
                            AND   tt-embarque-imp-aux.embarque    = embarque-imp.embarque) THEN
                    NEXT blk_embarque.

                CREATE tt-embarque-imp-aux.
                BUFFER-COPY embarque-imp TO tt-embarque-imp-aux.
            END.  
        END.

    END. /* FOR FIRST tt-param-adiant: */

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
        WHEN "cdn-corretor-cambio-import":U THEN ASSIGN pFieldValue = RowObject.cdn-corretor-cambio-import.
        WHEN "cdn-corretor-import":U THEN ASSIGN pFieldValue = RowObject.cdn-corretor-import.
        WHEN "cdn-despa-exter-import":U THEN ASSIGN pFieldValue = RowObject.cdn-despa-exter-import.
        WHEN "cdn-segurad-import":U THEN ASSIGN pFieldValue = RowObject.cdn-segurad-import.
        WHEN "cod-banco":U THEN ASSIGN pFieldValue = RowObject.cod-banco.
        WHEN "cod-despachante":U THEN ASSIGN pFieldValue = RowObject.cod-despachante.
        WHEN "cod-transportador":U THEN ASSIGN pFieldValue = RowObject.cod-transportador.
        WHEN "cod-via-transp":U THEN ASSIGN pFieldValue = RowObject.cod-via-transp.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
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
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque LIKE embarque-imp.embarque NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pembarque = RowObject.embarque.

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
        WHEN "contabilizado":U THEN ASSIGN pFieldValue = RowObject.contabilizado.
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
               recebe valor do campo cod-estabel
               recebe valor do campo embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE embarque-imp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pembarque LIKE embarque-imp.embarque NO-UNDO.

    FIND FIRST bfembarque-imp WHERE 
        bfembarque-imp.cod-estabel = pcod-estabel AND 
        bfembarque-imp.embarque = pembarque NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfembarque-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfembarque-imp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmbDi DBOProgram 
PROCEDURE openQueryByEmbDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
open query {&QUERYNAME} for each embarque-imp no-lock 
    where embarque-imp.cod-estabel >= c-est-ini      
      and embarque-imp.cod-estabel <= c-est-fim      
      and embarque-imp.embarque    >= c-embarque-ini 
      and embarque-imp.embarque    <= c-embarque-fim indexed-reposition.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByParams DBOProgram 
PROCEDURE openQueryByParams :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmbarqueByEstabSemDi DBOProgram 
PROCEDURE openQueryEmbarqueByEstabSemDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                            WHERE {&TABLENAME}.situacao    = 1  /* nao encerrado */
                              AND {&TABLENAME}.cod-estabel = c-cod-estab
                              AND {&TABLENAME}.int-2       = 0 NO-LOCK INDEXED-REPOSITION.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmbarqueSemDi DBOProgram 
PROCEDURE openQueryEmbarqueSemDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                            WHERE {&TABLENAME}.int-2 = 0 NO-LOCK INDEXED-REPOSITION.
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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEmbDi DBOProgram 
PROCEDURE setConstraintByEmbDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-est-ini      like estabelec.cod-estabel no-undo.
    def input parameter p-est-fim      like estabelec.cod-estabel no-undo.
    def input parameter p-embarque-ini like embarque-imp.embarque no-undo.
    def input parameter p-embarque-fim like embarque-imp.embarque no-undo.

    assign c-est-ini      = p-est-ini
           c-est-fim      = p-est-fim
           c-embarque-ini = p-embarque-ini
           c-embarque-fim = p-embarque-fim.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByEstab DBOProgram 
PROCEDURE setConstraintByEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pCodEstab LIKE {&TABLENAME}.cod-estabel NO-UNDO.

ASSIGN c-cod-estab = pCodEstab.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDi DBOProgram 
PROCEDURE setConstraintDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms LIKE decla-import.num-di-ems NO-UNDO.
                                
ASSIGN i-num-di-ems = pNumDiEms.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setVinculoEmbarqueDuimp DBOProgram 
PROCEDURE setVinculoEmbarqueDuimp :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel     LIKE ordens-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque        LIKE ordens-embarque.embarque NO-UNDO.
    DEFINE INPUT PARAMETER pcod-duimp-dts     LIKE duimp-siscomex.cod-duimp-dts NO-UNDO.
        
    DEFINE VARIABLE c-cod-duimp-siscomex      AS CHARACTER                           NO-UNDO.
    DEFINE VARIABLE da-reg-siscomex           AS DATE                                NO-UNDO.
    DEFINE VARIABLE h-bocx00487               AS HANDLE                              NO-UNDO.
        
    IF NOT VALID-HANDLE(h-bocx00487) THEN
        run cxbo/bocx00487.p PERSISTENT SET h-bocx00487.

    RUN setConstraintDuimpPKey in h-bocx00487 (input pcod-duimp-dts).  
    RUN openQueryStatic IN h-bocx00487 (INPUT "DuimpByKey":U).
    RUN goToKey IN h-bocx00487(INPUT pcod-duimp-dts).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getDateField in h-bocx00487(INPUT "dtz-reg-siscomex":U, OUTPUT da-reg-siscomex).
        RUN getCharField IN h-bocx00487(INPUT "cod-duimp-siscomex", OUTPUT c-cod-duimp-siscomex).
    END.

    IF VALID-HANDLE(h-bocx00487) THEN DO:
        DELETE PROCEDURE h-bocx00487.
        ASSIGN h-bocx00487 = ?.
    end.

    
     FIND FIRST embarque-imp WHERE embarque-imp.cod-estabel = pc-cod-estabel
                             AND   embarque-imp.embarque    = pc-embarque
                             EXCLUSIVE-LOCK NO-ERROR.
     IF AVAIL embarque-imp THEN
         ASSIGN embarque-imp.declaracao-import     = c-cod-duimp-siscomex
                embarque-imp.data-di               = da-reg-siscomex
                OVERLAY(embarque-imp.char-2,21,10) = STRING(pcod-duimp-dts).
     else 
         return "NOK":U.    

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setVinculoEmbarqueDuimp DBOProgram 
PROCEDURE setDesVinculoEmbarqueDuimp :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel     LIKE ordens-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-embarque        LIKE ordens-embarque.embarque NO-UNDO.
    
    FIND FIRST embarque-imp WHERE embarque-imp.cod-estabel = pc-cod-estabel
                            AND   embarque-imp.embarque    = pc-embarque
                            EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL embarque-imp THEN
        ASSIGN embarque-imp.declaracao-import     = ""
               embarque-imp.data-di               = ?
               OVERLAY(embarque-imp.char-2,21,10) = "".
    else 
        return "NOK":U.    

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

