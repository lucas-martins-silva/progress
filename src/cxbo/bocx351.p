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
{include/i-prgvrs.i BOCX351 2.00.00.016 } /*** "010016" 07/10/2025 18:42:42 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx351 MUT}
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
&GLOBAL-DEFINE DBOName BOCX351
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName licenciam-import-oc
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
{cxbo/bocx351.i RowObject}
{cxbo/bocx351.i tt-licenciam-import-oc}
{cxbo/bocx351.i tt-licenciam-import-oc-aux}
{cxbo/bocx404.i tt-decla-import-ord}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

define variable lRecarrega as logical no-undo.
define variable inumero-ordem  like {&TableName}.numero-ordem no-undo.
define variable iparcela       like {&TableName}.parcela      no-undo.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-integra-di(INPUT "CREATE":U).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-integra-di(INPUT "DELETE":U).

RETURN "OK":U.
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

RUN pi-integra-di(INPUT "UPDATE":U).

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
        WHEN "licenca-import":U THEN ASSIGN pFieldValue = RowObject.licenca-import.
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
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice lcncmmpr-id
  Parameters:  
               retorna valor do campo numero-ordem
               retorna valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE licenciam-import-oc.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pparcela LIKE licenciam-import-oc.parcela NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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
  Purpose:     Reposiciona registro com base no °ndice lcncmmpr-id
  Parameters:  
               recebe valor do campo numero-ordem
               recebe valor do campo parcela
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE licenciam-import-oc.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pparcela LIKE licenciam-import-oc.parcela NO-UNDO.

    FIND FIRST bflicenciam-import-oc WHERE 
        bflicenciam-import-oc.numero-ordem = pnumero-ordem AND 
        bflicenciam-import-oc.parcela = pparcela NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bflicenciam-import-oc THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bflicenciam-import-oc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByPU DBOProgram 
PROCEDURE openQueryByPU :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QueryName}
        for each {&TableName} where {&TableName}.numero-ordem = inumero-ordem 
                              and   {&TableName}.parcela      = iparcela no-lock indexed-reposition.

    return "OK":U.

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
    open query {&QueryName}
        for each {&TableName} no-lock indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integra-di DBOProgram 
PROCEDURE pi-integra-di :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pType AS CHARACTER NO-UNDO.

empty temp-table tt-decla-import-ord.

IF  pType <> "DELETE" THEN DO:    
    IF CAN-FIND(FIRST decla-import-ord
                WHERE decla-import-ord.num-ordem   = RowObject.numero-ordem
                AND   decla-import-ord.num-parcela = RowObject.parcela) THEN DO:

        FOR EACH  decla-import-ord no-lock
            WHERE decla-import-ord.num-ordem   = RowObject.numero-ordem
            AND   decla-import-ord.num-parcela = RowObject.parcela:
            create tt-decla-import-ord.
            buffer-copy decla-import-ord to tt-decla-import-ord.
        end.
        
        FOR each tt-decla-import-ord no-lock:
            find first decla-import-ord exclusive-lock
                where decla-import-ord.num-di-ems       = tt-decla-import-ord.num-di-ems      
                and   decla-import-ord.num-ordem        = tt-decla-import-ord.num-ordem       
                and   decla-import-ord.num-parcela      = tt-decla-import-ord.num-parcela     
                and   decla-import-ord.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts no-error.
            assign decla-import-ord.cod-licenc-import = RowObject.licenca-import
                   decla-import-ord.dat-livre-1       = RowObject.dat-livre-1.
        END.

    END. /* IF CAN-FIND(FIRST decla-import-ord */
END. /* IF pType <> "DELETE" */
ELSE DO:
    IF CAN-FIND(FIRST decla-import-ord
                WHERE decla-import-ord.num-ordem   = RowObject.numero-ordem
                AND   decla-import-ord.num-parcela = RowObject.parcela) THEN DO:

        FOR EACH  decla-import-ord no-lock
            WHERE decla-import-ord.num-ordem   = RowObject.numero-ordem
            AND   decla-import-ord.num-parcela = RowObject.parcela:
            create tt-decla-import-ord.
            buffer-copy decla-import-ord to tt-decla-import-ord.
        end.
        
        FOR EACH tt-decla-import-ord no-lock:
            find first decla-import-ord exclusive-lock
                where decla-import-ord.num-di-ems       = tt-decla-import-ord.num-di-ems      
                and   decla-import-ord.num-ordem        = tt-decla-import-ord.num-ordem       
                and   decla-import-ord.num-parcela      = tt-decla-import-ord.num-parcela     
                and   decla-import-ord.cdd-siscomex-dts = tt-decla-import-ord.cdd-siscomex-dts no-error.
            assign decla-import-ord.cod-licenc-import = ""
                   decla-import-ord.dat-livre-1       = ?.
        end.

    END. /* IF CAN-FIND(FIRST decla-import-ord */
END. /* ELSE DO: */

RELEASE decla-import-ord.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExportaLi DBOProgram 
PROCEDURE piExportaLi :
/*------------------------------------------------------------------------------
  Purpose: Exporta LI para os itens de mesma classificacao passada como parametro
           Utilizada no programa im0041b    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter pcClassFiscal as character format "9999.99.99":U no-undo.
    define input parameter cNrLi         as character format "x(20)":U      no-undo.
    define input parameter dData         as date format 99/99/9999          no-undo.
    define input parameter table for tt-licenciam-import-oc-aux.

    define variable cClassFiscal as character format "9999.99.99":U no-undo.
    define variable cReturn      as character                       no-undo.

    for each  tt-licenciam-import-oc-aux,
        first prazo-compra fields (situacao)
        where prazo-compra.numero-ordem = tt-licenciam-import-oc-aux.numero-ordem
        and   prazo-compra.parcela      = tt-licenciam-import-oc-aux.parcela 
        and   (    prazo-compra.situacao <> 6
               and prazo-compra.situacao <> 4),
        first ordem-compra fields (it-codigo numero-ordem cod-emitente)
        where ordem-compra.numero-ordem = tt-licenciam-import-oc-aux.numero-ordem no-lock:

        empty temp-table tt-licenciam-import-oc.

        for first item fields (class-fiscal tipo-contr)
            where item.it-codigo = ordem-compra.it-codigo no-lock: end.
        if  not avail item then
            next.

        assign cClassFiscal = "".

        for first cotacao-item fields (char-1)
            where cotacao-item.numero-ordem = ordem-compra.numero-ordem
            and   cotacao-item.cod-emitente = ordem-compra.cod-emitente
            and   cotacao-item.it-codigo    = ordem-compra.it-codigo
            and   cotacao-item.cot-aprovada no-lock: end.
        if  avail cotacao-item
        and item.tipo-contr = 4 then /*debito direto*/
            assign cClassFiscal = substr(cotacao-item.char-1,81,20).
        else 
            assign cClassFiscal = item.class-fiscal.

        if  cClassFiscal = pcClassFiscal then do:

            run gotokey  in this-procedure (input tt-licenciam-import-oc-aux.numero-ordem,
                                            input tt-licenciam-import-oc-aux.parcela).
            assign cReturn = return-value.

            if  cNrLi <> "" then do:

                assign tt-licenciam-import-oc-aux.licenca-import = cNrLi
                       tt-licenciam-import-oc-aux.dat-livre-1    = dData.
                
                create tt-licenciam-import-oc.
                buffer-copy tt-licenciam-import-oc-aux to tt-licenciam-import-oc.

                run emptyRowErrors in this-procedure.
                run emptyRowObject in this-procedure.
                run setRecord      in this-procedure (input table tt-licenciam-import-oc).

                if  cReturn = "OK":U then
                    run updateRecord in this-procedure.
                else
                    run createRecord in this-procedure.
            end.
            else if  cReturn = "OK" then
                 run deleteRecord in this-procedure.
        end.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaLi DBOProgram 
PROCEDURE piRetornaLi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter iTipoBusca          as integer                         no-undo. /*1-pedido de compra 2-embarque 3-parcela de compra*/
    define input  parameter lRetornaSemLi       as logical                         no-undo.
    define input  parameter iNumPedido          as integer   format ">>>>>,>>9":U  no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
    define input  parameter cCodEstabel         as character format "x(05)":U       no-undo.
&ELSE
    define input  parameter cCodEstabel         as character format "x(3)":U       no-undo.
&ENDIF
    define input  parameter cEmbarque           LIKE embarque-imp.embarque         no-undo. 
    define input  parameter iParcela            as integer   format ">>>>9":U      no-undo.
    define input  parameter lParcelasEliminadas as logical                         no-undo.
    define input  parameter lParcelasRecebidas  as logical                         no-undo.
    define input  parameter iNumeroOrdemIni     as integer   format ">>>>>9.99":U  no-undo.
    define input  parameter iNumeroOrdemFim     as integer   format ">>>>>9.99":U  no-undo.
    define input  parameter cItCodigoIni        as character format "x(16)":U      no-undo.
    define input  parameter cItCodigoFim        as character format "x(16)":U      no-undo.
    define input  parameter cClassFiscalIni     as character format "9999.99.99":U no-undo.
    define input  parameter cClassFiscalFim     as character format "9999.99.99":U no-undo.
    define input  parameter cNrLiIni            as character format "x(20)":U      no-undo.
    define input  parameter cNrLiFim            as character format "x(20)":U      no-undo.
    define output parameter table for tt-licenciam-import-oc-aux.

    define variable cClassFiscal                as character format "9999.99.99":U no-undo.
    define variable l-necessita-li              as logical                         no-undo.

    empty temp-table tt-licenciam-import-oc-aux.

    if  iTipoBusca = 1 then do: /* Pedido de Compra */

        for each  ordem-compra fields (situacao it-codigo cod-emitente numero-ordem cod-estabel)
            where ordem-compra.num-pedido    = iNumPedido 
            and   ordem-compra.numero-ordem >= iNumeroOrdemIni
            and   ordem-compra.numero-ordem <= iNumeroOrdemFim
            and   ordem-compra.it-codigo    >= cItCodigoIni
            and   ordem-compra.it-codigo    <= cItCodigoFim no-lock:

            if  not lParcelasEliminadas
            and ordem-compra.situacao = 4 then
                next.

            if  not lParcelasRecebidas
            and ordem-compra.situacao = 6 then
                next.
            
            FOR FIRST param-imp
                WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK: 
            END.

            for first item fields (class-fiscal tipo-contr log-necessita-li)
                where item.it-codigo = ordem-compra.it-codigo no-lock: end.
            if  not avail item then
                next.

            IF AVAIL param-imp AND SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
                ASSIGN l-necessita-li = YES.
            ELSE
                ASSIGN l-necessita-li = item.log-necessita-li.

            assign cClassFiscal = "".

            for first cotacao-item fields (char-1)
                where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                and   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                and   cotacao-item.it-codigo    = ordem-compra.it-codigo
                and   cotacao-item.cot-aprovada no-lock: end.
            if  avail cotacao-item
            and item.tipo-contr = 4 then /*debito direto*/
                assign cClassFiscal = substr(cotacao-item.char-1,81,20).
            else 
                assign cClassFiscal = item.class-fiscal.

            if  cClassFiscal < cClassFiscalIni
            or  cClassFiscal > cClassFiscalFim then
                next.

            for each  prazo-compra fields (situacao parcela)
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem no-lock:

                if  not lParcelasEliminadas
                and prazo-compra.situacao = 4 then
                    next.
    
                if  not lParcelasRecebidas
                and prazo-compra.situacao = 6 then
                    next.

                for first bflicenciam-import-oc 
                    where bflicenciam-import-oc.numero-ordem = ordem-compra.numero-ordem
                    and   bflicenciam-import-oc.parcela      = prazo-compra.parcela no-lock: end.
                if  avail bflicenciam-import-oc then do:
                    
                    if  bflicenciam-import-oc.licenca-import >= cNrLiIni
                    and bflicenciam-import-oc.licenca-import <= cNrLiFim then do:
    
                        if  (    lRecarrega 
                             and l-necessita-li)
                        or  not lRecarrega then do:
                        
                            create tt-licenciam-import-oc-aux.
                            buffer-copy bflicenciam-import-oc to tt-licenciam-import-oc-aux.
                            assign tt-licenciam-import-oc-aux.cod-livre-1 = ordem-compra.it-codigo /*temporario - somente p/ uso na tela im0041*/
                                   tt-licenciam-import-oc-aux.cod-livre-2 = cClassFiscal           /*temporario - somente p/ uso na tela im0041*/
                                   tt-licenciam-import-oc-aux.r-rowid     = rowid (bflicenciam-import-oc).
                        end.
                    end.
                end.
                else 
                    if  l-necessita-li
                    and lRetornaSemLi
                    and (    "" >= cNrLiIni
                         and "" <= cNrLiFim) then do:

                        create tt-licenciam-import-oc-aux.
                        assign tt-licenciam-import-oc-aux.numero-ordem   = ordem-compra.numero-ordem
                               tt-licenciam-import-oc-aux.parcela        = prazo-compra.parcela
                               tt-licenciam-import-oc-aux.licenca-import = ""
                               tt-licenciam-import-oc-aux.cod-livre-1    = ordem-compra.it-codigo /*temporario - somente p/ uso na tela im0041*/
                               tt-licenciam-import-oc-aux.cod-livre-2    = cClassFiscal.          /*temporario - somente p/ uso na tela im0041*/
                    end.
            end.
        end.
    end.
    else if iTipoBusca = 2 then do: /*embarque*/

        for each  ordens-embarque fields (parcela cod-estabel)
            where ordens-embarque.cod-estabel   = cCodEstabel
            and   ordens-embarque.embarque      = cEmbarque
            and   ordens-embarque.numero-ordem >= iNumeroOrdemIni
            and   ordens-embarque.numero-ordem <= iNumeroOrdemFim no-lock,
            first ordem-compra fields (numero-ordem it-codigo cod-emitente)
            where ordem-compra.numero-ordem     = ordens-embarque.numero-ordem
            and   ordem-compra.it-codigo       >= cItCodigoIni
            and   ordem-compra.it-codigo       <= cItCodigoFim no-lock:

            FOR FIRST param-imp
                WHERE param-imp.cod-estabel = ordens-embarque.cod-estabel NO-LOCK:
            END.

            for first item fields (class-fiscal tipo-contr log-necessita-li)
                where item.it-codigo = ordem-compra.it-codigo no-lock: end.
            if  not avail item then
                next.

            IF SUBSTRING(param-imp.char-1,167,1) = "S":U THEN
                ASSIGN l-necessita-li = YES.
            ELSE
                ASSIGN l-necessita-li = item.log-necessita-li.

            assign cClassFiscal = "".

            for first cotacao-item fields (char-1)
                where cotacao-item.numero-ordem = ordem-compra.numero-ordem
                and   cotacao-item.cod-emitente = ordem-compra.cod-emitente
                and   cotacao-item.it-codigo    = ordem-compra.it-codigo
                and   cotacao-item.cot-aprovada no-lock: end.
            if  avail cotacao-item
            and item.tipo-contr = 4 then /*debito direto*/
                assign cClassFiscal = substr(cotacao-item.char-1,81,20).
            else 
                assign cClassFiscal = item.class-fiscal.

            if  cClassFiscal < cClassFiscalIni
            or  cClassFiscal > cClassFiscalFim then
                next.

            for first prazo-compra fields (situacao)
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem
                and   prazo-compra.parcela      = ordens-embarque.parcela no-lock: end.
            if  avail prazo-compra then do:

               if  not lParcelasEliminadas
               and prazo-compra.situacao = 4 then
                   next.
    
                if  not lParcelasRecebidas
                and prazo-compra.situacao = 6 then
                    next.

                for first bflicenciam-import-oc 
                    where bflicenciam-import-oc.numero-ordem = ordem-compra.numero-ordem
                    and   bflicenciam-import-oc.parcela      = ordens-embarque.parcela no-lock: end.
                if  avail bflicenciam-import-oc then do:
                    
                    if  bflicenciam-import-oc.licenca-import >= cNrLiIni
                    and bflicenciam-import-oc.licenca-import <= cNrLiFim then do:
    
                        if  (    lRecarrega 
                             and l-necessita-li)
                        or  not lRecarrega then do:

                            create tt-licenciam-import-oc-aux.
                            buffer-copy bflicenciam-import-oc to tt-licenciam-import-oc-aux.
                            assign tt-licenciam-import-oc-aux.cod-livre-1 = ordem-compra.it-codigo /*temporario - somente p/ uso na tela im0041*/
                                   tt-licenciam-import-oc-aux.cod-livre-2 = cClassFiscal           /*temporario - somente p/ uso na tela im0041*/
                                   tt-licenciam-import-oc-aux.r-rowid     = rowid (bflicenciam-import-oc).
                        end.
                    end.
                end.
                else do:

                    if  l-necessita-li
                    and lRetornaSemLi
                    and (    "" >= cNrLiIni
                         and "" <= cNrLiFim) then do:

                        create tt-licenciam-import-oc-aux.
                        assign tt-licenciam-import-oc-aux.numero-ordem   = ordem-compra.numero-ordem
                               tt-licenciam-import-oc-aux.parcela        = ordens-embarque.parcela
                               tt-licenciam-import-oc-aux.licenca-import = ""
                               tt-licenciam-import-oc-aux.cod-livre-1    = ordem-compra.it-codigo /*temporario - somente p/ uso na tela im0041*/
                               tt-licenciam-import-oc-aux.cod-livre-2    = cClassFiscal.          /*temporario - somente p/ uso na tela im0041*/
                    end.
                end.
            end.
        end.
    end.
    else do: /*iTipoBusca = 3 - parcela de compra*/

        for first prazo-compra fields (situacao numero-ordem parcela)
            where prazo-compra.numero-ordem = iNumeroOrdemIni
            and   prazo-compra.parcela      = iParcela no-lock: end.
        if  avail prazo-compra then do:

            for first ordem-compra fields (it-codigo cod-estabel)
                where ordem-compra.numero-ordem = prazo-compra.numero-ordem no-lock: end.
            if  avail ordem-compra then do:

                for first item fields (log-necessita-li)
                    where item.it-codigo = ordem-compra.it-codigo no-lock: end.
                if  avail item then do:

                    FOR FIRST param-imp
                        WHERE param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK:
                    END.

                    IF AVAIL param-imp AND SUBSTRING(param-imp.char-1, 167,1) = "S":U THEN
                        ASSIGN l-necessita-li = YES.
                    ELSE 
                        ASSIGN l-necessita-li = item.log-necessita-li.

                    if  not lParcelasEliminadas
                    and prazo-compra.situacao = 4 then
                        next.
            
                    if  not lParcelasRecebidas
                    and prazo-compra.situacao = 6 then
                        next.
        
                    for first bflicenciam-import-oc 
                        where bflicenciam-import-oc.numero-ordem = prazo-compra.numero-ordem
                        and   bflicenciam-import-oc.parcela      = prazo-compra.parcela no-lock: end.
                    if  avail bflicenciam-import-oc then do:
                        
                        create tt-licenciam-import-oc-aux.
                        buffer-copy bflicenciam-import-oc to tt-licenciam-import-oc-aux.
                    end.
                    else 
                        if  l-necessita-li
                        and lRetornaSemLi then do:
        
                            create tt-licenciam-import-oc-aux.
                            assign tt-licenciam-import-oc-aux.numero-ordem   = prazo-compra.numero-ordem
                                   tt-licenciam-import-oc-aux.parcela        = prazo-compra.parcela
                                   tt-licenciam-import-oc-aux.licenca-import = "".
                        end.
                end.
            end.
        end.
    end.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetalRecarrega DBOProgram 
PROCEDURE piSetalRecarrega :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter plRecarrega as logical no-undo.

    assign lRecarrega = plRecarrega.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaSituacaoPedido DBOProgram 
PROCEDURE piVerificaSituacaoPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter rProcessoImp as rowid no-undo.

    find processo-imp
        where rowid(processo-imp) = rProcessoImp no-lock no-error.
    if  avail processo-imp then do:

        for first pedido-compr fields (situacao)
            where pedido-compr.num-pedido = processo-imp.num-pedido no-lock: end.
        if  avail pedido-compr 
        and pedido-compr.situacao = 2 then do: /*nao impresso*/

            {method/svc/errors/inserr.i
                   &ErrorNumber="30443"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR" 
                   &ErrorParameters="string(processo-imp.num-pedido)"}
        end.
    end.

    /*:T--- Verifica ocorrància de erros ---*/
    if  can-find(first RowErrors 
                 where RowErrors.ErrorSubType = "ERROR":U) then
        return "NOK":U.
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByPU DBOProgram 
PROCEDURE setConstraintByPU :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    def input param pnumero-ordem  like {&TableName}.numero-ordem no-undo.
    def input param pparcela       like {&TableName}.parcela      no-undo.

    assign inumero-ordem = pnumero-ordem 
           iparcela      = pparcela.

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
    
    if  pType = "Create"
    or  pType = "Update" then do:

        if  not can-find (first ordem-compra
                          where ordem-compra.numero-ordem = rowObject.numero-ordem) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ordem-de-compra AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ordem_de_Compra" *}
            ASSIGN c-lbl-liter-ordem-de-compra = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="2"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-ordem-de-compra"}
        end.

        if  not can-find (first prazo-compra
                          where prazo-compra.numero-ordem = rowObject.numero-ordem
                          and   prazo-compra.parcela      = rowObject.parcela) then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-parcela-de-compra AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Parcela_de_Compra" *}
            ASSIGN c-lbl-liter-parcela-de-compra = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="2"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lbl-liter-parcela-de-compra"}
        end.
    end.

    if  pType = "Create" then do:

        find first prazo-compra
            where  prazo-compra.numero-ordem = rowObject.numero-ordem
            and    prazo-compra.parcela      = rowObject.parcela exclusive-lock no-error.
        if  avail  prazo-compra then
            assign prazo-compra.int-2 = 2. /*parcela fixada - nao sera replanejada pelo MRP*/
    end.

    if  pType = "Delete" then do:
        
        find first prazo-compra
            where  prazo-compra.numero-ordem = rowObject.numero-ordem
            and    prazo-compra.parcela      = rowObject.parcela exclusive-lock no-error.
        if  avail  prazo-compra then do:

            for first ordens-embarque
                where ordens-embarque.numero-ordem = rowObject.numero-ordem
                and   ordens-embarque.parcela      = rowObject.parcela no-lock: end.
            
            for first ordem-compra
                where ordem-compra.numero-ordem = rowObject.numero-ordem no-lock: end.
            if  avail ordem-compra then do:

                for first pedido-compr
                    where pedido-compr.num-pedido = ordem-compra.num-pedido no-lock: end.
                if  avail pedido-compr then do:

                    for first processo-imp
                        where processo-imp.num-pedido = pedido-compr.num-pedido no-lock: end.
                    if  avail processo-imp then do:

                        for first historico-proc-imp
                            where historico-proc-imp.cod-estabel = processo-imp.cod-estabel
                            and   historico-proc-imp.nr-proc-imp = processo-imp.nr-proc-imp
                            and   historico-proc-imp.cod-itiner  = processo-imp.cod-itiner no-lock: end.
                    end.
                end.
            end.

            if  not avail ordens-embarque
            and not avail historico-proc-imp then
                assign prazo-compra.int-2 = 0. /*parcela nao fixada - sera replanejada pelo MRP*/
        end.
    end.

    RELEASE prazo-compra.
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

