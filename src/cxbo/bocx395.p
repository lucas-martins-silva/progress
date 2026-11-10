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
{include/i-prgvrs.i BOCX395 2.00.00.011 } /*** "010011" 14/11/2025 16:15:32 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX395
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName decla-import-cotac
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
{cxbo/bocx395.i RowObject}
{cxbo/bocx395.i tt-decla-import-cotac-aux}
{cxbo/bocx310.i tt-desp-embarque}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE h-bocx310 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx407 AS HANDLE      NO-UNDO.
DEFINE VARIABLE iRowsReturned    AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-seq-nacionaliz AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-num-di-ems LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEFINE VARIABLE d-cotacao    LIKE decla-import-cotac.val-cotac NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnCotacao DBOProgram 
FUNCTION fnCotacao RETURNS DECIMAL
  ( p-cdn-moeda AS INTEGER, 
    p-data-cotacao AS DATE)  FORWARD.

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
         HEIGHT             = 7.13
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTtMoedas DBOProgram 
PROCEDURE criaTtMoedas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM pMoeda    LIKE moeda.mo-codigo         NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

IF NOT CAN-FIND(FIRST tt-decla-import-cotac-aux
                WHERE tt-decla-import-cotac-aux.num-di-ems = pNumDiEms
                AND   tt-decla-import-cotac-aux.cdn-moeda  = pMoeda  
                AND   tt-decla-import-cotac-aux.cdd-siscomex = pCddSiscomexDts) THEN DO:
    CREATE tt-decla-import-cotac-aux.
    ASSIGN tt-decla-import-cotac-aux.cdn-moeda  = pMoeda
           tt-decla-import-cotac-aux.num-di-ems = pNumDiEms
           tt-decla-import-cotac-aux.cdd-siscomex = pCddSiscomexDts.

    IF CAN-FIND(FIRST bf{&TABLENAME}
                WHERE bf{&TABLENAME}.num-di-ems = tt-decla-import-cotac-aux.num-di-ems
                AND   bf{&TABLENAME}.cdn-moeda  = tt-decla-import-cotac-aux.cdn-moeda    
                AND   bf{&TABLENAME}.cdd-siscomex-dts = tt-decla-import-cotac-aux.cdd-siscomex-dts) THEN DO:
        FOR FIRST bf{&TABLENAME} NO-LOCK
            WHERE bf{&TABLENAME}.num-di-ems = tt-decla-import-cotac-aux.num-di-ems  
            AND   bf{&TABLENAME}.cdn-moeda  = tt-decla-import-cotac-aux.cdn-moeda
            AND   bf{&TABLENAME}.cdd-siscomex-dts = tt-decla-import-cotac-aux.cdd-siscomex-dts:
            ASSIGN tt-decla-import-cotac-aux.val-cotac  = bf{&TABLENAME}.val-cotac.
        END.
    END.
    ELSE DO:
        FOR FIRST decla-import NO-LOCK
            WHERE decla-import.num-di-ems = pNumDiEms
              AND decla-import.cdd-siscomex-dts = pCddSiscomexDts:
            ASSIGN tt-decla-import-cotac-aux.val-cotac  = fnCotacao(INPUT tt-decla-import-cotac-aux.cdn-moeda,
                                                                    INPUT decla-import.dat-di).
        END.
    END.
    RELEASE tt-decla-import-cotac-aux.
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
        WHEN "val-cotac":U THEN ASSIGN pFieldValue = RowObject.val-cotac.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "cdd-siscomex-dts":U THEN ASSIGN pFieldValue = RowObject.cdd-siscomex-dts.
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
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
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
  Purpose:     Retorna valores dos campos do °ndice dclmpctc-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo cdn-moeda
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE decla-import-cotac.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-moeda LIKE decla-import-cotac.cdn-moeda NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-cotac.cdd-siscomex-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pcdn-moeda = RowObject.cdn-moeda
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMoedasDespesas DBOProgram 
PROCEDURE getMoedasDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms       LIKE {&TABLENAME}.num-di-ems NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-decla-import-cotac-aux.

EMPTY TEMP-TABLE tt-decla-import-cotac-aux.


IF NOT VALID-HANDLE(h-bocx310) THEN
    RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.

IF NOT VALID-HANDLE(h-bocx407) THEN
    RUN cxbo/bocx407.p PERSISTENT SET h-bocx407.

/*VERIFICANDO QUAIS AS MOEDAS EXISTENTES*/
FOR EACH bf{&TABLENAME} 
    WHERE bf{&TABLENAME}.num-di-ems = pNumDiEms 
      AND bf{&TABLENAME}.cdd-siscomex-dts = pCddSiscomexDts NO-LOCK:
    RUN criaTtMoedas(INPUT bf{&TABLENAME}.num-di-ems,
                     INPUT bf{&TABLENAME}.cdn-moeda,
                     INPUT bf{&TABLENAME}.cdd-siscomex-dts).
END.

/*BUSCANDO A MOEDA DOLAR DO PARAMETRO DE IMPORTAÄ«O*/
FOR FIRST decla-import NO-LOCK
    WHERE decla-import.num-di-ems = pNumDiEms
      AND decla-import.cdd-siscomex-dts = pCddSiscomexDts,
    FIRST param-imp NO-LOCK
    WHERE param-imp.cod-estabel = decla-import.cod-estab : 
    RUN criaTtMoedas(INPUT pNumDiEms,
                     INPUT param-imp.int-2,
                     INPUT pCddSiscomexDts).                  
END.

/*Moeda Corrente*/
RUN criaTtMoedas(INPUT pNumDiEms,
                 INPUT 0,
                 INPUT pCddSiscomexDts).    

/*BUSCANDO MOEDAS DAS DESPESAS DOS EMBARQUES VINCULADOS A DI*/
FOR EACH decla-import-embarq NO-LOCK
    WHERE decla-import-embarq.num-di-ems = pNumDiEms
      AND decla-import-embarq.cdd-siscomex-dts = pCddSiscomexDts,
    FIRST embarque-imp
    WHERE embarque-imp.embarque    = decla-import-embarq.cod-embarq
    AND   embarque-imp.cod-estabel = decla-import-embarq.cod-estab   :  
    RUN retorna-seq-ponto-nacionaliz IN h-bocx407 (INPUT decla-import-embarq.cod-embarq, 
                                                   INPUT decla-import-embarq.cod-estab,
                                                   OUTPUT i-seq-nacionaliz).

    FOR EACH historico-embarque NO-LOCK
        WHERE historico-embarque.embarque    = embarque-imp.embarque
        AND   historico-embarque.cod-estabel = embarque-imp.cod-estabel   :

        IF historico-embarque.sequencia > i-seq-nacionaliz THEN
            NEXT.

        EMPTY TEMP-TABLE tt-desp-embarque.
    
        RUN setConstraint4 IN h-bocx310 (INPUT ROWID(historico-embarque)).
            
            /*--- Abre query do DBO filho ---*/
        RUN openQuery IN h-bocx310 (INPUT 4).
            
            /*--- Posiciona DBO filho no primeiro registro, caso necess†rio ---*/
        RUN findFirst IN h-bocx310.
            
            /*--- Retorna faixa de registro do DBO Filho ---*/
        RUN serverSendRows IN h-bocx310 (INPUT ?,
                                         INPUT ?,
                                         INPUT NO,
                                         INPUT ?,
                                         OUTPUT iRowsReturned,
                                         OUTPUT TABLE tt-desp-embarque).   
        IF CAN-FIND(FIRST tt-desp-embarque) THEN
            FOR EACH tt-desp-embarque:
                RUN criaTtMoedas(INPUT pNumDiEms,
                                 INPUT tt-desp-embarque.mo-codigo,
                                 INPUT pCddSiscomexDts).
            END.
            
    END.
END.

/*BUSCANDO DESPESAS INSERIDAS DIRETAMENTE NO IM0400*/
FOR EACH despes-decla-import NO-LOCK
    WHERE despes-decla-import.num-di-ems = pNumDiEms
      AND despes-decla-import.cdd-siscomex-dts = pCddSiscomexDts:
    RUN criaTtMoedas(INPUT despes-decla-import.num-di-ems,
                     INPUT despes-decla-import.cdn-moeda,
                     INPUT despes-decla-import.cdd-siscomex-dts).    
END.

/*BUSCANDO MOEDA DA NEGOCIAÄ«O*/
FOR FIRST decla-import-ord NO-LOCK
    WHERE decla-import-ord.num-di-ems = pNumDiEms
      AND decla-import-ord.cdd-siscomex-dts = pCddSiscomexDts,
    FIRST cotacao-item
    WHERE cotacao-item.numero-ordem = decla-import-ord.num-ordem
      AND cotacao-item.it-codigo    = decla-import-ord.cod-item
      AND cotacao-item.cod-emitente = decla-import-ord.cdn-fornec
      AND cotacao-item.cot-aprovada NO-LOCK:
    RUN criaTtMoedas(INPUT decla-import-ord.num-di-ems,
                     INPUT cotacao-item.mo-codigo,
                     INPUT decla-import-ord.cdd-siscomex-dts).
END.

IF VALID-HANDLE(h-bocx407) THEN 
    DELETE PROCEDURE h-bocx407.
ASSIGN h-bocx407 = ?.
IF VALID-HANDLE(h-bocx310) THEN 
    DELETE PROCEDURE h-bocx310.
ASSIGN h-bocx310 = ?.

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
  Purpose:     Reposiciona registro com base no °ndice dclmpctc-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo cdn-moed
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE decla-import-cotac.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-moeda LIKE decla-import-cotac.cdn-moeda NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE decla-import-cotac.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdecla-import-cotac WHERE 
        bfdecla-import-cotac.num-di-ems = pnum-di-ems AND 
        bfdecla-import-cotac.cdn-moeda = pcdn-moeda AND 
        bfdecla-import-cotac.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdecla-import-cotac THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdecla-import-cotac)).
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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

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
    
    IF pType = 'CREATE' OR
       pType = 'COPY' THEN DO:
         
        IF CAN-FIND(FIRST {&TABLENAME}
                    WHERE {&TABLENAME}.num-di-ems = RowObject.num-di-ems
                    AND   {&TABLENAME}.cdn-moeda   = RowObject.cdn-moeda
                    AND   {&TABLENAME}.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-cotacao-declaracao-importacao AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Cotaá∆o_Declaraá∆o_Importaá∆o" *}
                    ASSIGN c-lbl-liter-cotacao-declaracao-importacao = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                          &ErrorNumber="2"
                          &ErrorType="EMS"
                          &ErrorParameters="c-lbl-liter-cotacao-declaracao-importacao"}
        END.                                                                 
    END.


    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnCotacao DBOProgram 
FUNCTION fnCotacao RETURNS DECIMAL
  ( p-cdn-moeda AS INTEGER, 
    p-data-cotacao AS DATE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  
    /** Encontra cotacao que sera utilizada **/
    FIND FIRST cotacao
        WHERE cotacao.mo-codigo   = p-cdn-moeda
        AND   cotacao.ano-periodo = STRING(YEAR(p-data-cotacao)) 
                                  + STRING(MONTH(p-data-cotacao),"99") NO-LOCK NO-ERROR.
    IF  NOT AVAIL cotacao THEN DO:
        IF  p-cdn-moeda <> 0 THEN DO:
            ASSIGN d-cotacao = 0.
        END.
        ELSE
            ASSIGN d-cotacao = 1.
    END.
    ELSE
        ASSIGN d-cotacao = cotacao.cotacao[INT(DAY(p-data-cotacao))].

    RETURN d-cotacao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

