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
{include/i-prgvrs.i BOCX00451 2.00.00.028 } /*** "010028" 07/10/2024 16:59:53 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00451
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName antecip-import
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
{cxbo/bocx00451.i RowObject}
{cxbo/bocx00451.i tt-antecip-import-aux}
{cxbo/bocx230.i tt-historico-embarque} /*definiá∆o temp-table tt-historico-embarque*/
{cxbo/bocx00451.i1} /*temp-tables de integraá∆o com o AP*/

/* Definiá∆o de Vari†veis*/
DEFINE VARIABLE de-sld-a-vincular  AS DECIMAL NO-UNDO.
DEFINE VARIABLE de-tot-vinculado   AS DECIMAL NO-UNDO.
DEFINE VARIABLE l-encontrou        AS LOGICAL NO-UNDO.
DEFINE VARIABLE i-seq-erro         AS INTEGER NO-UNDO.
DEFINE VARIABLE h_api_tit_antecip  AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx402          AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx383          AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx383a         AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-bocx225          AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boin274          AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-acr933zb         AS HANDLE  NO-UNDO.
DEFINE VARIABLE i-moeda-negoc      LIKE moeda.mo-codigo               NO-UNDO.
DEFINE VARIABLE vdat-di            LIKE decla-import.dat-di           NO-UNDO.
DEFINE VARIABLE vnat-operacao      LIKE decla-import.cod-natur-operac NO-UNDO.
DEFINE VARIABLE vnum-di-siscomex   LIKE decla-import.cod-di-siscomex  NO-UNDO.
DEFINE VARIABLE i-cod-emitente-emb LIKE ordem-compra.cod-emitente     NO-UNDO.

DEFINE BUFFER bf-antecip-import FOR antecip-import.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE ccod-estabel    LIKE antecip-import.cod-estabel        NO-UNDO. 
DEFINE VARIABLE ccod-embarq     LIKE antecip-import.cod-embarq         NO-UNDO.
DEFINE VARIABLE c-estab-ini     LIKE antecip-import.cod-estabel        NO-UNDO.  
DEFINE VARIABLE c-estab-fim     LIKE antecip-import.cod-estabel        NO-UNDO.  
DEFINE VARIABLE i-fornec-ini    LIKE antecip-import.cdn-emitente       NO-UNDO.  
DEFINE VARIABLE i-fornec-fim    LIKE antecip-import.cdn-emitente       NO-UNDO.  
DEFINE VARIABLE da-dt-trans-ini LIKE antecip-import.dat-transacao      NO-UNDO.  
DEFINE VARIABLE da-dt-trans-fim LIKE antecip-import.dat-transacao      NO-UNDO.  
DEFINE VARIABLE c-espec-ini     LIKE antecip-import.cod-espec-docto-ap NO-UNDO.  
DEFINE VARIABLE c-espec-fim     LIKE antecip-import.cod-espec-docto-ap NO-UNDO.  
DEFINE VARIABLE c-serie-ini     LIKE antecip-import.cod-ser-docto-ap   NO-UNDO.  
DEFINE VARIABLE c-serie-fim     LIKE antecip-import.cod-ser-docto-ap   NO-UNDO.  
DEFINE VARIABLE c-titulo-ini    LIKE antecip-import.cod-tit-ap         NO-UNDO.  
DEFINE VARIABLE c-titulo-fim    LIKE antecip-import.cod-tit-ap         NO-UNDO.

def temp-table tt_xml_input_output no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_des_conteudo_aux             as character format "x(40)"
    field ttv_num_seq_1                    as integer format ">>>,>>9"
    .

def temp-table tt_log_erros no-undo
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±ºncia" column-label "Seq"
    field ttv_num_cod_erro                 as integer format ">>>>,>>9" label "Número" column-label "Número"
    field ttv_des_erro                     as character format "x(50)" label "Inconsistºncia" column-label "Inconsistºncia"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    index tt_id                           
          ttv_num_seq                      ascending
          ttv_num_cod_erro                 ascending
    .

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
         HEIGHT             = 16.21
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaRelacDocum-est DBOProgram 
PROCEDURE criaRelacDocum-est :
/*------------------------------------------------------------------------------
  Purpose:     Cria relacionamentos com a docum-est
  Parameters:  Entrada: recebe chave do docum-est, estabelecimento e embarque
                
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-serie-docto  LIKE antecip-import.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER p-nro-docto    LIKE antecip-import.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente LIKE antecip-import.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-nat-operacao LIKE antecip-import.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel  LIKE antecip-import.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER p-embarque     LIKE antecip-import.cod-embarq   NO-UNDO.

    DEFINE VARIABLE da-data-cotacao     AS   DATE    FORMAT "99/99/9999":U      NO-UNDO.
    DEFINE VARIABLE de-cotacao-dia      AS   DECIMAL FORMAT ">>>,>9.99999999":U NO-UNDO.
    DEFINE VARIABLE h-bocx220na         AS   HANDLE                             NO-UNDO.
    DEFINE VARIABLE i-moeda-antecipacao LIKE moeda.mo-codigo                    NO-UNDO.

    IF  NOT VALID-HANDLE(h-bocx220na) THEN                
        RUN cxbo/bocx220na.p PERSISTENT SET h-bocx220na.  
    RUN openQueryStatic IN h-bocx220na (INPUT 'Main':U).    
    
    /* Busca Data da Cotaá∆o */
    RUN goToKey         IN h-bocx220na (INPUT p-cod-estabel,INPUT p-embarque).
    IF  RETURN-VALUE = "OK":U THEN DO:
        RUN getDateField IN h-bocx220na(INPUT "data-1":U, OUTPUT da-data-cotacao).
    END. 

    /* Grava chave do documento, data e valor da cotaá∆o */
    FOR EACH bf{&TableName}
       WHERE bf{&TableName}.cod-estabel  = p-cod-estabel 
         AND bf{&TableName}.cod-embarq   = p-embarque NO-LOCK:

         /* Busca Moeda do EMS2 referente Ö Antecipaá∆o do Embarque */
        RUN pi-retorna-moeda-ems-2(INPUT bf{&TableName}.cod-empres-ap,
                                   INPUT bf{&TableName}.cod-estab-ap,
                                   INPUT bf{&TableName}.cod-moed-ap,
                                   INPUT bf{&TableName}.dat-transacao,
                                   OUTPUT i-moeda-antecipacao).

        IF RETURN-VALUE <> "NOK":U THEN DO:
            FOR FIRST cotacao FIELDS(cotacao)
                WHERE cotacao.mo-codigo   = i-moeda-antecipacao
                  AND cotacao.ano-periodo = STRING(YEAR(da-data-cotacao)) + STRING(MONTH(da-data-cotacao),"99")
                  AND cotacao.cotacao[INT(DAY(da-data-cotacao))] <> 0 NO-LOCK:
            END.
            IF NOT AVAIL cotacao THEN DO:
               ASSIGN de-cotacao-dia = 1.                               
            END.
            ELSE 
              ASSIGN de-cotacao-dia = cotacao.cotacao[INT(DAY(da-data-cotacao))].                      
    
             FIND FIRST {&TableName} 
                 WHERE ROWID({&TableName}) = ROWID(bf{&TableName}) EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL {&TableName} THEN
               ASSIGN {&TableName}.serie-docto          = p-serie-docto  
                      {&TableName}.nro-docto            = p-nro-docto    
                      {&TableName}.cdn-emitente         = p-cod-emitente 
                      {&TableName}.nat-operacao         = p-nat-operacao
                      {&TableName}.dat-cotac-nacionaliz = da-data-cotacao
                      {&TableName}.val-cotac-nacionaliz = de-cotacao-dia. 
        END. 
    END.
    
    IF VALID-HANDLE(h-bocx220na) THEN DO:
        DELETE PROCEDURE h-bocx220na.
        ASSIGN h-bocx220na = ?.
    END.  

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRelacDocum-est DBOProgram 
PROCEDURE deleteRelacDocum-est :
/*------------------------------------------------------------------------------
  Purpose:     Elimina relacionamentos com a docum-est
  Parameters:  Entrada: 
                
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-serie-docto  LIKE antecip-import.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER p-nro-docto    LIKE antecip-import.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente LIKE antecip-import.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-nat-operacao LIKE antecip-import.nat-operacao NO-UNDO.

    FOR EACH bf{&TableName}
       WHERE bf{&TableName}.serie-docto  = p-serie-docto 
         AND bf{&TableName}.nro-docto    = p-nro-docto
         AND bf{&TableName}.cdn-emitente = p-cod-emitente
         AND bf{&TableName}.nat-operacao = p-nat-operacao NO-LOCK:

        FIND FIRST {&TableName} 
             WHERE ROWID({&TableName}) = ROWID(bf{&TableName}) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL {&TableName} THEN
            ASSIGN {&TableName}.serie-docto          = "":U
                   {&TableName}.nro-docto            = "":U
                   {&TableName}.cdn-emitente         = 0
                   {&TableName}.nat-operacao         = "":U
                   {&TableName}.dat-cotac-nacionaliz = ?
                   {&TableName}.val-cotac-nacionaliz = 0.

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
        WHEN "cod-embarq":U THEN ASSIGN pFieldValue = RowObject.cod-embarq.
        WHEN "cod-empres-ap":U THEN ASSIGN pFieldValue = RowObject.cod-empres-ap.
        WHEN "cod-espec-docto-ap":U THEN ASSIGN pFieldValue = RowObject.cod-espec-docto-ap.
        WHEN "cod-estab-ap":U THEN ASSIGN pFieldValue = RowObject.cod-estab-ap.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-moed-ap":U THEN ASSIGN pFieldValue = RowObject.cod-moed-ap.
        WHEN "cod-parc-ap":U THEN ASSIGN pFieldValue = RowObject.cod-parc-ap.
        WHEN "cod-refer-antecip-ap":U THEN ASSIGN pFieldValue = RowObject.cod-refer-antecip-ap.
        WHEN "cod-ser-docto-ap":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto-ap.
        WHEN "cod-tit-ap":U THEN ASSIGN pFieldValue = RowObject.cod-tit-ap.
        WHEN "cod-usuar-criac":U THEN ASSIGN pFieldValue = RowObject.cod-usuar-criac.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nom-abrev-ap":U THEN ASSIGN pFieldValue = RowObject.nom-abrev-ap.
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
        WHEN "dat-cotac-nacionaliz":U THEN ASSIGN pFieldValue = RowObject.dat-cotac-nacionaliz.
        WHEN "dat-emis":U THEN ASSIGN pFieldValue = RowObject.dat-emis.
        WHEN "dat-liquidac-tit-ap":U THEN ASSIGN pFieldValue = RowObject.dat-liquidac-tit-ap.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-prev-pagto":U THEN ASSIGN pFieldValue = RowObject.dat-prev-pagto.
        WHEN "dat-transacao":U THEN ASSIGN pFieldValue = RowObject.dat-transacao.
        WHEN "dat-ult-apurac-variac-val":U THEN ASSIGN pFieldValue = RowObject.dat-ult-apurac-variac-val.
        WHEN "dat-ult-pagto":U THEN ASSIGN pFieldValue = RowObject.dat-ult-pagto.
        WHEN "dat-vencto-tit":U THEN ASSIGN pFieldValue = RowObject.dat-vencto-tit.
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
        WHEN "cdd-id-antecip":U THEN ASSIGN pFieldValue = RowObject.cdd-id-antecip.
        WHEN "val-cotac-nacionaliz":U THEN ASSIGN pFieldValue = RowObject.val-cotac-nacionaliz.
        WHEN "val-cotac-tit":U THEN ASSIGN pFieldValue = RowObject.val-cotac-tit.
        WHEN "val-cotac-tit-inver":U THEN ASSIGN pFieldValue = RowObject.val-cotac-tit-inver.
        WHEN "val-entr-transf-estab":U THEN ASSIGN pFieldValue = RowObject.val-entr-transf-estab.
        WHEN "val-liber-pagto-orig-tot":U THEN ASSIGN pFieldValue = RowObject.val-liber-pagto-orig-tot.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-origin-tit-ap":U THEN ASSIGN pFieldValue = RowObject.val-origin-tit-ap.
        WHEN "val-origin-tit-ap-aux":U THEN ASSIGN pFieldValue = RowObject.val-origin-tit-ap-aux.
        WHEN "val-sdo-tit-ap":U THEN ASSIGN pFieldValue = RowObject.val-sdo-tit-ap.
        WHEN "val-sdo-tit-ap-aux":U THEN ASSIGN pFieldValue = RowObject.val-sdo-tit-ap-aux.
        WHEN "val-tot-pagto-tit-ap":U THEN ASSIGN pFieldValue = RowObject.val-tot-pagto-tit-ap.
        WHEN "val-vinc-embarq":U THEN ASSIGN pFieldValue = RowObject.val-vinc-embarq.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "cdn-emitente-ap":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente-ap.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice antcpmpr_id2
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cod-embarq
               retorna valor do campo cdd-id-antecip
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE antecip-import.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-embarq LIKE antecip-import.cod-embarq NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-id-antecip LIKE antecip-import.cdd-id-antecip NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcod-embarq = RowObject.cod-embarq
           pcdd-id-antecip = RowObject.cdd-id-antecip.

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
  Purpose:     Reposiciona registro com base no °ndice antcpmpr_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cod-embarq
               recebe valor do campo cdd-id-antecip
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE antecip-import.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-embarq LIKE antecip-import.cod-embarq NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-id-antecip LIKE antecip-import.cdd-id-antecip NO-UNDO.

    FIND FIRST bfantecip-import WHERE 
        bfantecip-import.cod-estabel = pcod-estabel AND 
        bfantecip-import.cod-embarq = pcod-embarq AND 
        bfantecip-import.cdd-id-antecip = pcdd-id-antecip NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfantecip-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfantecip-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyTituloEmb DBOProgram 
PROCEDURE goToKeyTituloEmb :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base nas chaves do t°tulo AP e Embarque
  Parameters:  
               recebe valor do campo cod-estab-ap
               recebe valor do campo cod-espec-docto-ap
               recebe valor do campo cod-ser-docto-ap
               recebe valor do campo cod-tit-ap
               recebe valor do campo cod-parc-ap
               recebe valor do campo cdn-emitente-ap
               recebe valor do campo cod-estabel
               recebe valor do campo cod-embarq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab-ap       LIKE antecip-import.cod-estab-ap       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-espec-docto-ap LIKE antecip-import.cod-espec-docto-ap NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ser-docto-ap   LIKE antecip-import.cod-ser-docto-ap   NO-UNDO.
    DEFINE INPUT PARAMETER pcod-tit-ap         LIKE antecip-import.cod-tit-ap         NO-UNDO.
    DEFINE INPUT PARAMETER pcod-parc-ap        LIKE antecip-import.cod-parc-ap        NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente-ap    LIKE antecip-import.cdn-emitente-ap    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel        LIKE antecip-import.cod-estabel        NO-UNDO.
    DEFINE INPUT PARAMETER pcod-embarq         LIKE antecip-import.cod-embarq         NO-UNDO.

    FIND FIRST bfantecip-import 
         WHERE bfantecip-import.cod-estab-ap       = pcod-estab-ap      
           AND bfantecip-import.cod-espec-docto-ap = pcod-espec-docto-ap
           AND bfantecip-import.cod-ser-docto-ap   = pcod-ser-docto-ap  
           AND bfantecip-import.cod-tit-ap         = pcod-tit-ap        
           AND bfantecip-import.cod-parc-ap        = pcod-parc-ap       
           AND bfantecip-import.cdn-emitente-ap    = pcdn-emitente-ap   
           AND bfantecip-import.cod-estabel        = pcod-estabel 
           AND bfantecip-import.cod-embarq         = pcod-embarq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfantecip-import THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfantecip-import)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToEmbarque DBOProgram 
PROCEDURE linkToEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Procedure utilizada para relacionar o registro pai x registro filho
               na abertura da query e navegaá∆o.
  Parameters:  Entrada: Handle da DBO Pai
  Notes:       Utilizada no programa IM0055
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER ph-bocx230 AS HANDLE NO-UNDO.

    RUN getCurrent IN ph-bocx230 (OUTPUT TABLE tt-historico-embarque).
    FOR FIRST tt-historico-embarque FIELDS(cod-estabel embarque):
        ASSIGN ccod-estabel = tt-historico-embarque.cod-estabel
               ccod-embarq  = tt-historico-embarque.embarque.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByEmbarque DBOProgram 
PROCEDURE openQueryByEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Realizar abertura da query de acordo com Embarque selecionado
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
         WHERE {&TABLENAME}.cod-estabel    = ccod-estabel
           AND {&TABLENAME}.cod-embarq     = ccod-embarq INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmbarqueComFaixa DBOProgram 
PROCEDURE openQueryEmbarqueComFaixa :
/*------------------------------------------------------------------------------
  Purpose: Realiza a abertura da query conforme parÉmetros recebidos pela execuá∆o da
           setConstraintEmbarqueComFaixa    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cod-embarq         = ccod-embarq
                                 AND {&TABLENAME}.cod-estabel        = ccod-estabel
                                 AND {&TABLENAME}.cod-estab-ap       >= c-estab-ini 
                                 AND {&TABLENAME}.cod-estab-ap       <= c-estab-fim
                                 AND {&TABLENAME}.cdn-emitente-ap    >= i-fornec-ini
                                 AND {&TABLENAME}.cdn-emitente-ap    <= i-fornec-fim
                                 AND {&TABLENAME}.dat-transacao      >= da-dt-trans-ini 
                                 AND {&TABLENAME}.dat-transacao      <= da-dt-trans-fim 
                                 AND {&TABLENAME}.cod-espec-docto-ap >= c-espec-ini  
                                 AND {&TABLENAME}.cod-espec-docto-ap <= c-espec-fim  
                                 AND {&TABLENAME}.cod-ser-docto-ap   >= c-serie-ini
                                 AND {&TABLENAME}.cod-ser-docto-ap   <= c-serie-fim
                                 AND {&TABLENAME}.cod-tit-ap         >= c-titulo-ini
                                 AND {&TABLENAME}.cod-tit-ap         <= c-titulo-fim NO-LOCK INDEXED-REPOSITION.    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaAntecipVincular DBOProgram 
PROCEDURE piBuscaAntecipVincular :
/*:T------------------------------------------------------------------------------
  Purpose:     Busca antecipaá‰es a vincular
  Parameters:  tt-param-antecip: TT com os parÉmetros para a busca das antecipaá‰es
               tt_tit_ap_antecip_sdo_a_vincular: TT com as antecipaá‰es a vincular
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-param-antecip. 
    DEFINE OUTPUT PARAMETER TABLE FOR tt_tit_ap_antecip_sdo_a_vincular.

    EMPTY TEMP-TABLE tt_tit_ap_antecip_sdo_a_vincular.

    FOR FIRST tt-param-antecip NO-LOCK:
        IF NOT VALID-HANDLE(h_api_tit_antecip) THEN
            RUN prgfin/apb/apb909zo.py PERSISTENT SET h_api_tit_antecip.

        RUN pi_main_retorna_antecip_saldos IN h_api_tit_antecip (INPUT tt-param-antecip.cod-estab-ini,        /*estabelecimento inicial*/
                                                                 INPUT tt-param-antecip.cod-estab-fim,        /*estabelecimento final*/
                                                                 INPUT tt-param-antecip.cdn-emitente-ini,     /*fornecedor inicial*/
                                                                 INPUT tt-param-antecip.cdn-emitente-fim,     /*fornecedor final*/
                                                                 INPUT tt-param-antecip.dat-transacao-ini,    /*data de transaá∆o inicial*/
                                                                 INPUT tt-param-antecip.dat-transacao-fim,    /*data de transaá∆o final*/
                                                                 INPUT tt-param-antecip.cod-espec-docto-ini,  /*espÇcie inicial*/
                                                                 INPUT tt-param-antecip.cod-espec-docto-fim,  /*espÇcie final*/
                                                                 INPUT tt-param-antecip.cod-ser-docto-ini,    /*sÇrie inicial*/
                                                                 INPUT tt-param-antecip.cod-ser-docto-fim,    /*sÇrie final*/
                                                                 INPUT tt-param-antecip.cod-tit-ap-ini,       /*t°tulo inicial*/
                                                                 INPUT tt-param-antecip.cod-tit-ap-fim,       /*t°tulo final*/
                                                                 OUTPUT TABLE tt_tit_ap_antecip_sdo,
                                                                 OUTPUT TABLE tt_log_erros_atualiz).
        IF VALID-HANDLE(h_api_tit_antecip) THEN DO:
            DELETE PROCEDURE h_api_tit_antecip.
            ASSIGN h_api_tit_antecip = ?.
        END.

        FOR EACH tt_tit_ap_antecip_sdo NO-LOCK:
            /*Se tiver saldo e moeda estrangeira*/
            IF tt_tit_ap_antecip_sdo.tta_val_sdo_tit_ap > 0 AND TRIM(UPPER(tt_tit_ap_antecip_sdo.tta_cod_indic_econ)) <> "REAL":U THEN DO:
                
                RUN piCalculaSaldoAntecip (OUTPUT de-sld-a-vincular).

                IF de-sld-a-vincular > 0 THEN DO:

                    CREATE tt_tit_ap_antecip_sdo_a_vincular.
                    BUFFER-COPY tt_tit_ap_antecip_sdo TO tt_tit_ap_antecip_sdo_a_vincular.
                    ASSIGN tt_tit_ap_antecip_sdo_a_vincular.tta_val_sdo_vincular = de-sld-a-vincular.
                END.
            END.
        END.
    END.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaCotacaoDia DBOProgram 
PROCEDURE piBuscaCotacaoDia :
/*------------------------------------------------------------------------------
  Purpose: Busca o valor da cotaá∆o dia      
  Parameters:  Entrada: pEstab: Estabelecimento do Embarque de Importaá∆o
                        pEmbarq: Embarque de Importaá∆o
                        pData: Data da Cotaá∆o
               Sa°da: Valor na Data da Cotaá∆o.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pEstab LIKE antecip-import.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pEmbarq LIKE antecip-import.cod-embarq  NO-UNDO.
    DEFINE INPUT  PARAMETER pData LIKE embarque-imp.data-1 NO-UNDO.
    DEFINE OUTPUT PARAMETER pCotacaoDia LIKE decla-import-cotac.val-cotac NO-UNDO.

    ASSIGN l-encontrou = NO.
    IF  NOT VALID-HANDLE(h-bocx402) THEN 
        RUN cxbo/bocx402.p PERSISTENT SET h-bocx402.
    /* Retorna se o embarque est† vinculado a DI */
    RUN verificaRelacionamentos IN h-bocx402 (INPUT pEmbarq, 
                                              INPUT pEstab, 
                                              OUTPUT vnum-di-siscomex, 
                                              OUTPUT l-encontrou, 
                                              OUTPUT vdat-di, 
                                              OUTPUT vnat-operacao).
    IF VALID-HANDLE(h-bocx402) THEN DO:
       DELETE PROCEDURE h-bocx402.
       ASSIGN h-bocx402 = ?.
    END.

    /* Nacionalizaá∆o por DI*/
    IF l-encontrou THEN DO: 
       IF NOT VALID-HANDLE(h-bocx383) THEN
          RUN cxbo/bocx383.p PERSISTENT SET h-bocx383.
       IF NOT VALID-HANDLE(h-bocx383a) THEN
          RUN cxbo/bocx383a.p PERSISTENT SET h-bocx383a.   
       RUN buscaMoedaNegociacao IN h-bocx383 (INPUT vnum-di-siscomex,
                                              OUTPUT i-moeda-negoc).
       RUN buscaMoedaNegociacao IN h-bocx383  (INPUT vnum-di-siscomex,
                                               OUTPUT i-moeda-negoc).
       RUN retornaCotacaoDia    IN h-bocx383a (INPUT vnum-di-siscomex,
                                               INPUT i-moeda-negoc,
                                               INPUT pData,
                                               OUTPUT pCotacaoDia).

       IF VALID-HANDLE(h-bocx383) THEN DO:
          DELETE PROCEDURE h-bocx383.
          ASSIGN h-bocx383 = ?.
       END.
       IF VALID-HANDLE(h-bocx383a) THEN DO:
          DELETE PROCEDURE h-bocx383a.
          ASSIGN h-bocx383a = ?.
       END.
    END.
    /* Nacionalizaá∆o por Embarque */
    ELSE DO: 
       FOR FIRST ordens-embarque FIELDS(numero-ordem)
           WHERE ordens-embarque.cod-estabel = pEstab 
           AND   ordens-embarque.embarque  = pEmbarq NO-LOCK:  
           FOR FIRST ordem-compra FIELDS( numero-ordem  cod-emitente it-codigo)
               WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:      
               FOR FIRST cotacao-item FIELDS(mo-codigo) 
                   WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
                     AND cotacao-item.cod-emitente = ordem-compra.cod-emitente
                     AND cotacao-item.it-codigo    = ordem-compra.it-codigo
                     AND cotacao-item.cot-aprovada NO-LOCK:               
                   FOR FIRST cotacao FIELDS(cotacao)
                       WHERE cotacao.mo-codigo   = cotacao-item.mo-codigo
                         AND cotacao.ano-periodo = STRING(YEAR(pData)) + STRING(MONTH(pData),"99")
                         AND cotacao.cotacao[INT(DAY(pData))] <> 0 NO-LOCK:
                   END.
                   IF NOT AVAIL cotacao THEN DO:
                      ASSIGN pCotacaoDia = 1.                               
                   END.
                   ELSE 
                      ASSIGN pCotacaoDia = cotacao.cotacao[int(day(pData))].                         
               END.
           END.
       END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaSaldoAntecip DBOProgram 
PROCEDURE piCalculaSaldoAntecip :
/*:T------------------------------------------------------------------------------
  Purpose:     Calcula saldo das antecipaá‰es a vincular nos embarques
  Parameters:  pde-sld-a-vincular: Saldo a Vincular
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pde-sld-a-vincular AS DECIMAL NO-UNDO.
    
    ASSIGN de-tot-vinculado = 0.
    FOR EACH antecip-import FIELDS(val-vinc-embarq) NO-LOCK
       WHERE antecip-import.cod-estab-ap       = tt_tit_ap_antecip_sdo.tta_cod_estab 
         AND antecip-import.cod-espec-docto-ap = tt_tit_ap_antecip_sdo.tta_cod_espec_docto
         AND antecip-import.cod-ser-docto-ap   = tt_tit_ap_antecip_sdo.tta_cod_ser_docto 
         AND antecip-import.cod-tit-ap         = tt_tit_ap_antecip_sdo.tta_cod_tit_ap 
         AND antecip-import.cod-parc-ap        = tt_tit_ap_antecip_sdo.tta_cod_parcela 
         AND antecip-import.cdn-emitente-ap    = tt_tit_ap_antecip_sdo.tta_cdn_fornecedor:
        
        ASSIGN de-tot-vinculado = de-tot-vinculado + antecip-import.val-vinc-embarq.
    END.

    ASSIGN pde-sld-a-vincular = tt_tit_ap_antecip_sdo.tta_val_sdo_tit_ap - de-tot-vinculado.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEliminaAntecipEmbarque DBOProgram 
PROCEDURE piEliminaAntecipEmbarque :
/*------------------------------------------------------------------------------
  Purpose: Elimina antecipaªÑes vinculadas a um embarque de importaªío    
  Parameters: Entrada - pc-cod-estabel - cΩdigo do estabelecimento
                        pc-cod-embarq  - cΩdigo do embarque
  Notes:        
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE antecip-import.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-embarq  LIKE antecip-import.cod-estabel NO-UNDO.

    FOR EACH antecip-import
       WHERE antecip-import.cod-estabel = pc-cod-estabel
         AND antecip-import.cod-embarq  = pc-cod-embarq EXCLUSIVE-LOCK:

        DELETE antecip-import.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEmbarqPossuiAntecip DBOProgram 
PROCEDURE piEmbarqPossuiAntecip :
/*:T------------------------------------------------------------------------------
  Purpose:     Verifica se existe antecipaá‰es vinculadas ao embarque 
  Parameters:  Entrada: c¢digo do estabelecimento e embarque 
               Sa°da: pPossuiAntecip (vari†vel l¢gica)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT  PARAMETER pEstab LIKE antecip-import.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pEmbarq LIKE antecip-import.cod-embarq  NO-UNDO.
    DEFINE OUTPUT PARAMETER pPossuiAntecip AS LOGICAL NO-UNDO.
    
    ASSIGN pPossuiAntecip = CAN-FIND(FIRST antecip-import
                            WHERE antecip-import.cod-estabel = pEstab
                              AND antecip-import.cod-embarq  = pEmbarq).

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaAntecipEmbarq DBOProgram 
PROCEDURE piRetornaAntecipEmbarq :
/*------------------------------------------------------------------------------
  Purpose: Retorna todas as antecipaá‰es de um embarque de importaá∆o     
  Parameters:  Entrada: pEstab: Estabelecimento do Embarque de Importaá∆o
                        pEmbarq: Embarque de Importaá∆o
               Sa°da: RowObjectAux: temp-table com todas as antecipaá‰es 
                      vinculadas ao embarque de importaá∆o.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pEstab  LIKE antecip-import.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pEmbarq LIKE antecip-import.cod-embarq  NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-antecip-import-aux.

    EMPTY TEMP-TABLE tt-antecip-import-aux.

    FOR EACH  bfantecip-import  NO-LOCK
        WHERE bfantecip-import.cod-estabel = pEstab
        AND   bfantecip-import.cod-embarq  = pEmbarq:
        CREATE tt-antecip-import-aux.
        BUFFER-COPY bfantecip-import TO tt-antecip-import-aux.
    END.                    
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaIdAntecip DBOProgram 
PROCEDURE piRetornaIdAntecip :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o pr¢ximo n£mero ID a ser criado
  Parameters:  Entrada: pc-cod-estabel: Estabelecimento do Embarque de Importaá∆o
                        pc-embarque: Embarque de Importaá∆o
               Sa°da: Pr¢ximo n£mero ID a ser criado.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE embarque-imp.cod-estabel      NO-UNDO.
    DEFINE INPUT  PARAMETER pc-embarque    LIKE embarque-imp.embarque         NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-prox-id     LIKE antecip-import.cdd-id-antecip NO-UNDO.

    FOR LAST antecip-import
        WHERE antecip-import.cod-estabel = pc-cod-estabel
          AND antecip-import.cod-embarq  = pc-embarque
          BY antecip-import.cdd-id-antecip:
        ASSIGN pi-prox-id = antecip-import.cdd-id-antecip + 1.
    END.

    IF NOT AVAIL antecip-import THEN
        ASSIGN pi-prox-id = 1.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaNFEmbarque DBOProgram 
PROCEDURE piVerificaNFEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     Verifica existància de nota fiscal vinculada ao embarque para habilitar 
               ou n∆o o bot∆o de Relacionamentos respons†vel por permitir vincular 
               antecipaá‰es ao Embarque de Importaá∆o
  Parameters:  Entrada - pc-cod-estabel: Estabelecimento do Embarque de Importaá∆o
                       - pc-embarque: Embarque de Importaá∆o
  Notes:       Somente habilita caso n∆o tenha nota fiscal, OU
               Se a nota Fiscal emitida referir-se a Nota M∆e que N«O gera primeira remessa
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE antecip-import.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pc-embarque    LIKE antecip-import.cod-embarq  NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-habilita    AS   LOGICAL                    NO-UNDO.

    ASSIGN pl-habilita = YES.
    IF NOT CAN-FIND(FIRST embarq-import-docto 
                    WHERE embarq-import-docto.cod-estab  = pc-cod-estabel
                      AND embarq-import-docto.cod-embarq = pc-embarque) THEN DO:
        ASSIGN pl-habilita = YES.
    END.
    ELSE DO:
        bloco:
        FOR EACH embarq-import-docto FIELDS(cod-ser-docto cod-docto cdn-emitente cod-natur-operac) NO-LOCK
            WHERE embarq-import-docto.cod-estab  = pc-cod-estabel
              AND embarq-import-docto.cod-embarq = pc-embarque:

            FOR FIRST docum-est FIELD (idi-nf-simples-remes char-1)
                WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto
                  AND docum-est.nro-docto    = embarq-import-docto.cod-docto
                  AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente
                  AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:

                IF docum-est.idi-nf-simples-remes = 1 THEN DO: /*nota m∆e*/
                    IF TRIM(SUBSTRING(docum-est.char-1,209,1)) <> "S":U THEN DO: /*N∆o gera primeira remessa*/
                        ASSIGN pl-habilita = YES.
                    END.
                    ELSE DO:
                        ASSIGN pl-habilita = NO. /*gera primeira remessa*/
                        LEAVE bloco.
                    END.
                END.
                ELSE DO:
                    IF docum-est.idi-nf-simples-remes >= 2 THEN DO: /*notas filhas e entradas normais*/
                        ASSIGN pl-habilita = NO.
                        LEAVE bloco.
                    END.
                END.
            END.
        END.
    END.
        

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmbarqueComFaixa DBOProgram 
PROCEDURE setConstraintEmbarqueComFaixa :
/*------------------------------------------------------------------------------
  Purpose: Recebe os parÉmetos para abertura da query "EmbarqueComFaixa"    
  Parameters: pc-embarque (INPUT) - Character: Embarque 
              pc-cod-estabel (INPUT) - Character: Estabelecimento
              tt-param-antecip (INPUT) - Temp-table: ContÇm as informaá‰es de 
                                                     faixa para abertura da query
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-embarque    LIKE antecip-import.cod-embarq  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE antecip-import.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR tt-param-antecip.

    FIND FIRST tt-param-antecip NO-ERROR.

    IF AVAIL tt-param-antecip THEN DO:
        ASSIGN ccod-embarq     = pc-embarque
               ccod-estabel    = pc-cod-estabel
               c-estab-ini     = tt-param-antecip.cod-estab-ini        
               c-estab-fim     = tt-param-antecip.cod-estab-fim        
               i-fornec-ini    = tt-param-antecip.cdn-emitente-ini     
               i-fornec-fim    = tt-param-antecip.cdn-emitente-fim     
               da-dt-trans-ini = tt-param-antecip.dat-transacao-ini    
               da-dt-trans-fim = tt-param-antecip.dat-transacao-fim    
               c-espec-ini     = tt-param-antecip.cod-espec-docto-ini  
               c-espec-fim     = tt-param-antecip.cod-espec-docto-fim  
               c-serie-ini     = tt-param-antecip.cod-ser-docto-ini    
               c-serie-fim     = tt-param-antecip.cod-ser-docto-fim    
               c-titulo-ini    = tt-param-antecip.cod-tit-ap-ini       
               c-titulo-fim    = tt-param-antecip.cod-tit-ap-fim.   
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
    
    ASSIGN i-seq-erro = 0.
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    IF pType = "CREATE":U OR pType = "UPDATE":U THEN DO:

        IF  NOT VALID-HANDLE(h-bocx225) THEN 
            RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.
        IF  NOT VALID-HANDLE(h-acr933zb) THEN 
            RUN prgfin/acr/acr933zb.py   PERSISTENT SET h-acr933zb.

        RUN piValidaAntecip.

        IF VALID-HANDLE(h-bocx225) THEN DO:
           DELETE PROCEDURE h-bocx225.
           ASSIGN h-bocx225 = ?.
        END.
        IF  VALID-HANDLE(h-acr933zb) THEN DO:
           DELETE PROCEDURE h-acr933zb.
           ASSIGN h-acr933zb = ?.
        END.

        
    END.
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaAntecip DBOProgram 
PROCEDURE piValidaAntecip :
/*------------------------------------------------------------------------------
  Purpose: Validaá‰es para permitir somente antecipaá‰es de fornecedor da mercadoria, 
           despachante ou despesas e com valor da antecipaá∆o menor ou igual que 
           mercadoria ou despesas(dependendo do fornecedor da antecipaá∆o).
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-moeda-destino         LIKE moeda.mo-codigo NO-UNDO.
    DEFINE VARIABLE i-moeda-mercad          LIKE moeda.mo-codigo NO-UNDO.
    DEFINE VARIABLE de-valor-permitido      AS DECIMAL           NO-UNDO.
    DEFINE VARIABLE de-valor-mercad         AS DECIMAL           NO-UNDO.
    DEFINE VARIABLE de-valor-total-antecip  AS DECIMAL           NO-UNDO.
    DEFINE VARIABLE de-valor-total-despes   AS DECIMAL           NO-UNDO.
    DEFINE VARIABLE de-saldo-antecip        AS DECIMAL           NO-UNDO.
    DEFINE VARIABLE de-valor-antecip-vinc   AS DECIMAL           NO-UNDO.
    DEFINE VARIABLE i-msg-valida-valor      AS INTEGER           NO-UNDO.
    DEFINE VARIABLE c-param-msg             AS CHARACTER         NO-UNDO.
    DEFINE VARIABLE dt-conversao            AS DATE              NO-UNDO.

    /*Busca emitente do embarque*/
    RUN pi-busca-fornecedor-emb (INPUT RowObject.cod-estabel,
                                 INPUT RowObject.cod-embarq,
                                 OUTPUT i-cod-emitente-emb).
   

    /*Se o fornecedor da antecipaá∆o n∆o for da mercadoria, despachante ou 
    de nenhuma despesa do embarque ent∆o bloqueia a vinculaá∆o*/
    IF RowObject.cdn-emitente-ap <> i-cod-emitente-emb AND 
       NOT CAN-FIND(FIRST embarque-imp
                    WHERE embarque-imp.cod-estabel      = RowObject.cod-estabel
                      AND embarque-imp.embarque         = RowObject.cod-embarq
                      AND embarque-imp.cod-despachante  = RowObject.cdn-emitente-ap) AND
       NOT CAN-FIND(FIRST desp-embarque 
                    WHERE desp-embarque.cod-estabel       = RowObject.cod-estabel
                      AND desp-embarque.embarque          = RowObject.cod-embarq
                      AND desp-embarque.cod-emitente-desp = RowObject.cdn-emitente-ap) THEN DO:
        
                RUN piCriaErro(INPUT 55812,
                               INPUT "ERROR":U,
                               INPUT "":U).
                RETURN "NOK":U.
    END.

    /*Retorna moeda do EMS2 da antecipaá∆o que est† sendo vinculada. Essa ser† a moeda destino*/
    RUN pi-retorna-moeda-ems-2(INPUT RowObject.cod-empres-ap,
                               INPUT RowObject.cod-estab-ap,
                               INPUT RowObject.cod-moed-ap,
                               INPUT RowObject.dat-transacao,
                               OUTPUT i-moeda-destino).

    /*Calcula total das antecipaá‰es na moeda destino*/
    RUN piCalculaTotalAntecip (INPUT i-moeda-destino,
                               OUTPUT de-valor-total-antecip).

    /*Busca data de efetivaá∆o ou ultima previs∆o do ponto de controle 
    de nacionalizaá∆o do embarque para converter as despesas e mercadoria 
    para a moeda destino*/
    RUN retornaDataEfetivaNacionaliz (INPUT  RowObject.cod-estabel, 
                                      INPUT  RowObject.cod-embarq,
                                      OUTPUT dt-conversao).

    /*Verifica se o emitente da antecipaá∆o Ç o mesmo da MERCADORIA*/
    IF RowObject.cdn-emitente-ap = i-cod-emitente-emb THEN DO:

        /*Calcula o valor total da mercadoria do embarque*/
        RUN calcularTotalembarque IN h-bocx225 (INPUT RowObject.cod-estabel, 
                                                INPUT RowObject.cod-embarq,
                                                OUTPUT i-moeda-mercad,
                                                OUTPUT de-valor-mercad).
        
        /*Se a moeda da mercadoria for diferente da moeda da antecipaá∆o
          converte o valor da mercadoria para a moeda da antecipaá∆o*/
        IF i-moeda-mercad <> i-moeda-destino THEN DO:

            run pi-converte-moeda (input i-moeda-mercad,
                                   input i-moeda-destino,
                                   input de-valor-mercad,
                                   input dt-conversao,
                                  output de-valor-permitido).
        END.
        ELSE
            ASSIGN de-valor-permitido = de-valor-mercad.

        /*Calcula total das despesas do fornecedor da mercadoria na moeda destino*/
        RUN piCalculaTotalDespes (input RowObject.cod-estabel,    
                                  input RowObject.cod-embarq,     
                                  input RowObject.cdn-emitente-ap,
                                  INPUT i-moeda-destino,  
                                  INPUT dt-conversao,
                                  INPUT i-cod-emitente-emb, 
                                  INPUT NO, /*Antecipaá∆o n∆o Ç para o despachante*/
                                  OUTPUT de-valor-total-despes).

        ASSIGN de-valor-permitido = de-valor-permitido + de-valor-total-despes.

        
        /*Texto: Total das antecipaá‰es maior que total da mercadoria.
          Ajuda: N∆o Ç permitido que o valor total das antecipaá‰es efetuadas para o fornecedor da mercadoria
                 seja maior que o valor total da mercadoria somado as despesas desse mesmo fornecedor no embarque. 
                 Valor total das antecipaá‰es do fornecedor da mercadoria (&1): &2; valor m†ximo permitido (&1): &3.*/
        ASSIGN i-msg-valida-valor = 55785.

    END.
    ELSE DO: /*Se o fornecedor da antecipaá∆o n∆o for o mesmo da mercadoria*/
        /*Verifica se o fornecedor da antecipaá∆o Ç o DESPACHANTE do embarque*/
        IF CAN-FIND(FIRST embarque-imp
                    WHERE embarque-imp.cod-estabel      = RowObject.cod-estabel
                      AND embarque-imp.embarque         = RowObject.cod-embarq
                      AND embarque-imp.cod-despachante  = RowObject.cdn-emitente-ap) THEN DO:


            /*Calcula total das despesas de fornecedores diferentes da mercadoria na moeda destino*/
            RUN piCalculaTotalDespes (input RowObject.cod-estabel,    
                                      input RowObject.cod-embarq,     
                                      input RowObject.cdn-emitente-ap,
                                      INPUT i-moeda-destino,   
                                      INPUT dt-conversao,
                                      INPUT i-cod-emitente-emb, 
                                      INPUT YES, /*Antecipaá∆o Ç para o despachante*/
                                      OUTPUT de-valor-permitido).

            
            /*Texto: Total das antecipaá‰es maior que total das despesas.
              Ajuda: N∆o Ç permitido que o valor total das antecipaá‰es efetuadas para o despachante 
                     seja maior que o valor total das despesas no embarque. 
                     Valor total das antecipaá‰es do despachante (&1): &2; valor m†ximo permitido (&1): &3.*/
            ASSIGN i-msg-valida-valor = 55845.


        END.
        ELSE DO: /*Se o fornecedor da antecipaá∆o n∆o for o mesmo da mercadoria ou o despachante*/
            /*Verifica se o fornecedor da antecipaá∆o Ç o fornecedor de alguma DESPESA do embarque*/
            IF CAN-FIND(FIRST desp-embarque 
                        WHERE desp-embarque.cod-estabel       = RowObject.cod-estabel
                          AND desp-embarque.embarque          = RowObject.cod-embarq
                          AND desp-embarque.cod-emitente-desp = RowObject.cdn-emitente-ap) THEN DO:
                
                /*Retorna moeda do EMS2 da antecipaá∆o que est† sendo vinculada*/
                RUN pi-retorna-moeda-ems-2(INPUT RowObject.cod-empres-ap,
                                           INPUT RowObject.cod-estab-ap,
                                           INPUT RowObject.cod-moed-ap,
                                           INPUT RowObject.dat-transacao,
                                           OUTPUT i-moeda-destino).

                /*Calcula total das despesas do fornecedor da antecipaá∆o na moeda destino*/
                RUN piCalculaTotalDespes (input RowObject.cod-estabel,    
                                          input RowObject.cod-embarq,     
                                          input RowObject.cdn-emitente-ap,
                                          INPUT i-moeda-destino,    
                                          INPUT dt-conversao,
                                          INPUT i-cod-emitente-emb, 
                                          INPUT NO, /*Antecipaá∆o n∆o Ç para o despachante*/
                                          OUTPUT de-valor-permitido).

                /*Texto: Total das antecipaá‰es maior que total das despesas.
                  Ajuda: N∆o Ç permitido que o valor total das antecipaá‰es efetuadas para esse fornecedor 
                         seja maior que o valor total das despesas, do mesmo fornecedor, no embarque. 
                         Valor total das antecipaá‰es do fornecedor (&1): &2; valor m†ximo permitido (&1): &3.*/
                ASSIGN i-msg-valida-valor = 55846.


            END.
        END.
    END.

    /*Valida valor da antecipaá∆o*/
    IF i-msg-valida-valor > 0 THEN DO:
        /*N∆o permite que o valor das antecipaá‰es para o fornecedor 
        seja maior que o valor total da mercadoria/despesas no embarque.*/
        IF de-valor-permitido = ? OR de-valor-total-antecip = ? THEN RETURN "NOK":U.

        IF round(de-valor-total-antecip,2) > round(de-valor-permitido,2) THEN DO:

			/*Se ja tiver sido vinculado um valor para a mesma antecipaÁ„o 
			faz uma tratativa para considerar apenas o valor vinculado*/
            IF CAN-FIND(FIRST bf-antecip-import
                        WHERE bf-antecip-import.cod-estabel      = RowObject.cod-estabel
                          AND bf-antecip-import.cod-embarq       = RowObject.cod-embarq
                          AND bf-antecip-import.cdd-id-antecip   = RowObject.cdd-id-antecip) THEN DO:
                
                FOR FIRST bf-antecip-import NO-LOCK
                    WHERE bf-antecip-import.cod-estabel      = RowObject.cod-estabel
                      AND bf-antecip-import.cod-embarq       = RowObject.cod-embarq
                      AND bf-antecip-import.cdd-id-antecip   = RowObject.cdd-id-antecip:

                    ASSIGN de-valor-antecip-vinc = (de-valor-total-antecip - RowObject.val-vinc-embarq) + bf-antecip-import.val-vinc-embarq.
                END.
            END.
            ELSE
                ASSIGN de-valor-antecip-vinc = de-valor-total-antecip - RowObject.val-vinc-embarq.

            ASSIGN de-saldo-antecip = de-valor-permitido - de-valor-antecip-vinc.

            FOR FIRST moeda WHERE moeda.mo-codigo = i-moeda-destino NO-LOCK: 
                ASSIGN c-param-msg = moeda.descricao + "~~" + 
                                     STRING(ROUND(de-valor-permitido,2),">>>,>>>,>>>,>>9.99":U) + "~~" +
                                     STRING(ROUND(de-valor-total-antecip,2),">>>,>>>,>>>,>>9.99":U) + "~~" + 
                                     STRING(ROUND(de-saldo-antecip,2),">>>,>>>,>>>,>>9.99":U).
            END.

            RUN piCriaErro(INPUT i-msg-valida-valor,
                           INPUT "ERROR":U,
                           INPUT c-param-msg).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaTotalDespes DBOProgram 
PROCEDURE piCalculaTotalDespes :
/*---------------------------------------------------------------------------------------------------------
  Purpose: Calcula o total das despesas do fornecedor da antecipaá∆o e converte na moeda destino.
  Parameters: pc-cod-estabel          - C¢digo do estabelecimento do embarque        - (input) (character)
              pc-cod-embarq         - C¢digo do embarque                           - (input) (character)
              pi-cod-emitente         - C¢digo do emitente das ordens do embarque    - (input) (integer)
              pi-moeda-destino        - C¢digo da moeda de destino                   - (input) (integer)
              pdt-conversao           - Data de convers∆o das moedas                 - (input) (date)
              pi-fornec-mercad        - C¢digo do fornecedor da mercadoria           - (input) (integer)
              pl-antecip-despach      - Indica se a antecipaá∆o Ç para o despachante - (input) (logical)
              pde-valor-total-despes  - Valor total das despesas na moeda destino    - (output)(decimal)
  Notes:       
-----------------------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pc-cod-estabel            LIKE embarque-imp.cod-estabel     NO-UNDO.
    DEFINE INPUT  PARAM pc-cod-embarq           LIKE embarque-imp.embarque        NO-UNDO.
    DEFINE INPUT  PARAM pi-cod-emitente           LIKE ordem-compra.cod-emitente    NO-UNDO.
    DEFINE INPUT  PARAM pi-moeda-destino          LIKE moeda.mo-codigo              NO-UNDO.
    DEFINE INPUT  PARAM pdt-conversao             LIKE antecip-import.dat-transacao NO-UNDO.
    DEFINE INPUT  PARAM pi-fornec-mercad          LIKE emitente.cod-emitente        NO-UNDO.
    DEFINE INPUT  PARAM pl-antecip-despach        AS LOGICAL                        NO-UNDO.
    DEFINE OUTPUT PARAM pde-valor-total-despes    AS DECIMAL                        NO-UNDO.

    DEFINE VARIABLE de-valor-convertido AS DECIMAL  NO-UNDO.

    IF NOT pl-antecip-despach THEN DO:
        FOR EACH desp-embarque 
           WHERE desp-embarque.cod-estabel       = pc-cod-estabel
             AND desp-embarque.embarque          = pc-cod-embarq 
             AND desp-embarque.cod-emitente-desp = pi-cod-emitente NO-LOCK:
            IF desp-embarque.mo-codigo <> pi-moeda-destino THEN DO:

                run pi-converte-moeda (input desp-embarque.mo-codigo,
                                       input pi-moeda-destino,
                                       input desp-embarque.val-desp,
                                       input pdt-conversao,
                                      output de-valor-convertido).

                IF de-valor-convertido <> ? THEN 
                    ASSIGN pde-valor-total-despes = pde-valor-total-despes + de-valor-convertido.
            END.
            ELSE
                ASSIGN pde-valor-total-despes = pde-valor-total-despes + desp-embarque.val-desp.
        END.
    END.
    ELSE DO: 
        /*Antecipaá∆o feita para o despachante. Nesse caso soma 
        todas as despesas que n∆o s∆o do fornecedor da mercadoria*/
        FOR EACH desp-embarque 
           WHERE desp-embarque.cod-estabel       = pc-cod-estabel
             AND desp-embarque.embarque          = pc-cod-embarq 
             AND desp-embarque.cod-emitente-desp <> pi-fornec-mercad NO-LOCK:
            IF desp-embarque.mo-codigo <> pi-moeda-destino THEN DO:
                run pi-converte-moeda (input desp-embarque.mo-codigo,
                                       input pi-moeda-destino,
                                       input desp-embarque.val-desp,
                                       input pdt-conversao,
                                      output de-valor-convertido).
                IF de-valor-convertido <> ? THEN 
                    ASSIGN pde-valor-total-despes = pde-valor-total-despes + de-valor-convertido.
            END.
            ELSE
                ASSIGN pde-valor-total-despes = pde-valor-total-despes + desp-embarque.val-desp.
        END.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaTotalAntecip DBOProgram 
PROCEDURE piCalculaTotalAntecip :
/*---------------------------------------------------------------------------------------------------------
  Purpose: Calcula o total das antecipaá‰es do fornecedor e converte na moeda destino.
  Parameters: pi-moeda-destino        - C¢digo da moeda de destino                    - (input) (integer)
              pde-valor-total-antecip - Valor total das antecipaá‰es na moeda destino - (input) (decimal)
  Notes:       
-----------------------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pi-moeda-destino LIKE moeda.mo-codigo NO-UNDO.
    DEFINE OUTPUT PARAM pde-valor-total-antecip AS DECIMAL    NO-UNDO.

    /*Calcula total do valor de antecipaá‰es do emitente j† vinculados ao embarque*/
    RUN piCalculaTotalAntecipVinc(input RowObject.cod-estabel,      
                                  input RowObject.cod-embarq,       
                                  input RowObject.cdn-emitente-ap, 
                                  INPUT pi-moeda-destino,
                                  OUTPUT pde-valor-total-antecip).

    /*No caso de a antecipaá∆o j† estar vinculada e estar sendo acrescentado valor a ela
    deve-se eliminar o valor dessa antecipaá∆o para depois somar o valor atual*/
    FOR FIRST bf-antecip-import NO-LOCK
        WHERE bf-antecip-import.cod-estabel      = RowObject.cod-estabel
          AND bf-antecip-import.cod-embarq       = RowObject.cod-embarq
          AND bf-antecip-import.cdd-id-antecip   = RowObject.cdd-id-antecip:
        ASSIGN pde-valor-total-antecip = pde-valor-total-antecip - bf-antecip-import.val-vinc-embarq.
    END.

    /*Soma o valor que est† sendo vinculado com os valores das antecipaá‰es j† vinculadas*/
    ASSIGN pde-valor-total-antecip = pde-valor-total-antecip + RowObject.val-vinc-embarq.


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCalculaTotalAntecipVinc DBOProgram 
PROCEDURE piCalculaTotalAntecipVinc :
/*---------------------------------------------------------------------------------------------------------
  Purpose: Calcula o total das antecipaá‰es do fornecedor j† vinculadas e converte na moeda destino.
  Parameters: pc-cod-estabel            - C¢digo do estabelecimento do embarque         - (input) (character)
              pc-cod-embarq           - C¢digo do embarque                            - (input) (character)
              pi-cod-emitente           - C¢digo do emitente das ordens do embarque     - (input) (integer)
              pi-moeda-destino        - C¢digo da moeda de destino                    - (input) (integer)
              pde-valor-total-antecip - Valor total das antecipaá‰es na moeda destino - (output)(decimal)
  Notes:       
-----------------------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pc-cod-estabel            LIKE embarque-imp.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAM pc-cod-embarq           LIKE embarque-imp.embarque     NO-UNDO.
    DEFINE INPUT  PARAM pi-cod-emitente           LIKE ordem-compra.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAM pi-moeda-destino        LIKE moeda.mo-codigo           NO-UNDO.
    DEFINE OUTPUT PARAM pde-valor-total-antecip AS DECIMAL                     NO-UNDO.

    DEFINE VARIABLE i-mo-antec-vinculada    LIKE moeda.mo-codigo                NO-UNDO.
    DEFINE VARIABLE i-mo-corrente           LIKE moeda.mo-codigo                NO-UNDO.
    DEFINE VARIABLE c-mo-corrente           AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE de-valor-convertido     AS DECIMAL                          NO-UNDO.

    FOR EACH bf-antecip-import NO-LOCK
       WHERE bf-antecip-import.cod-estabel      = pc-cod-estabel
         AND bf-antecip-import.cod-embarq       = pc-cod-embarq
         AND bf-antecip-import.cdn-emitente-ap  = pi-cod-emitente:
        
         /*Retorna moeda do EMS2 da antecipaá∆o*/
        RUN pi-retorna-moeda-ems-2(INPUT bf-antecip-import.cod-empres-ap,
                                   INPUT bf-antecip-import.cod-estab-ap,
                                   INPUT bf-antecip-import.cod-moed-ap,
                                   INPUT bf-antecip-import.dat-transacao,
                                   OUTPUT i-mo-antec-vinculada).

        /*Se a moeda da antecipaá∆o lida for diferente da moeda destino converte para a moeda destino*/
        IF i-mo-antec-vinculada <> pi-moeda-destino THEN DO:

            /*Converte para moeda corrente utilizando a cotaá∆o gravada na antecipaá∆o*/
            ASSIGN de-valor-convertido = bf-antecip-import.val-vinc-embarq * bf-antecip-import.val-cotac-tit.

             /*Busca moeda EMS5 da finalidade corrente*/
            RUN pi_retornar_indic_econ_finalid IN h-acr933zb (INPUT "Corrente":U,
                                                              INPUT bf-antecip-import.dat-transacao,
                                                              OUTPUT c-mo-corrente).
        
            /*Retorna moeda do EMS2 referente a moeda da finalidade corrente*/
            RUN pi-retorna-moeda-ems-2(INPUT bf-antecip-import.cod-empres-ap,
                                       INPUT bf-antecip-import.cod-estab-ap,
                                       INPUT c-mo-corrente,
                                       INPUT bf-antecip-import.dat-transacao,
                                       OUTPUT i-mo-corrente).


            /*Se moeda destino <> corrente converte para moeda destino*/
            IF pi-moeda-destino <> i-mo-corrente THEN DO:

                run pi-converte-moeda (input i-mo-corrente,
                                       input pi-moeda-destino,
                                       input de-valor-convertido,
                                       input bf-antecip-import.dat-transacao,
                                      output de-valor-convertido ).
            END.
            ASSIGN pde-valor-total-antecip = pde-valor-total-antecip + de-valor-convertido.
        END.
        ELSE DO:
            ASSIGN pde-valor-total-antecip = pde-valor-total-antecip + bf-antecip-import.val-vinc-embarq.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-fornecedor-emb DBOProgram 
PROCEDURE pi-busca-fornecedor-emb :
/*------------------------------------------------------------------------------
  Purpose: Busca o fornecedor do embarque atravÇs da ordem do embarque.
  Parameters: pc-cod-estabel  - C¢digo do estabelecimento do embarque     - (input) (character)
              pc-cod-embarq - C¢digo do embarque                        - (input) (character)
              pi-cod-emitente - C¢digo do emitente das ordens do embarque - (output)(integer)
  Notes:       
------------------------------------------------------------------------------*/
     DEF INPUT  PARAM  pc-cod-estabel       LIKE embarque-imp.cod-estabel  NO-UNDO.
     DEF INPUT  PARAM  pc-cod-embarq      LIKE embarque-imp.embarque     NO-UNDO.
     DEF OUTPUT PARAM  pi-cod-emitente      LIKE ordem-compra.cod-emitente NO-UNDO.

     DEFINE VARIABLE c-return-ordens-emb  AS CHARACTER NO-UNDO.
     DEFINE VARIABLE c-return-ordem-compr AS CHARACTER NO-UNDO.
     DEFINE VARIABLE i-numero-ordem       LIKE ordem-compra.numero-ordem NO-UNDO.
     
     RUN findEmbarque IN h-bocx225 (INPUT pc-cod-estabel,
                                    INPUT pc-cod-embarq,
                                    OUTPUT c-return-ordens-emb).

     IF c-return-ordens-emb = "" THEN DO:
         RUN getintfield IN h-bocx225 ("numero-ordem":U, OUTPUT i-numero-ordem).

         IF NOT VALID-HANDLE(h-boin274) THEN
             RUN inbo/boin274.p PERSISTENT SET h-boin274.

         RUN findOrdem IN h-boin274 (INPUT i-numero-ordem,
                                     OUTPUT c-return-ordem-compr).
         IF c-return-ordem-compr = "":U THEN DO:
             RUN getintfield IN h-boin274 ("cod-emitente":U, OUTPUT pi-cod-emitente).
         END.     

         IF VALID-HANDLE(h-boin274) THEN DO:
             DELETE PROCEDURE h-boin274.
             ASSIGN h-boin274 = ?.
         END.
     END.

     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-moeda-ems2 DBOProgram 
PROCEDURE pi-retorna-moeda-ems-2 :
/*------------------------------------------------------------------------------------------
  Purpose: Retorna a moeda do EMS2 correspondente ao indicador financeiro do EMS5.
  Parameters: p-empresa    - C¢digo da empresa da antecipaá∆o          - (input)(character)
              p-estabel    - C¢digo do estabelecimento da antecipaá∆o  - (input)(character)
              p-moeda-ems5 - Moeda do EMS5 (Indicador Econìmico)       - (input)(character)
              p-data-trans - Data de transaá∆o                         - (input)(date)
              p-moeda-ems2 - Moeda do EMS2 correspondente a moeda EMS5 - (output)(integer)
              
  Notes:       
--------------------------------------------------------------------------------------------*/

    DEF INPUT  PARAM  p-empresa    as char NO-UNDO.
    def input  param  p-estabel    as char no-undo.
    def input  param  p-moeda-ems5 as char no-undo.
    def input  param  p-data-trans as date no-undo.
    def output param  p-moeda-ems2 as INT no-undo.

    def var v_dat_cotac_indic_econ as dec no-undo.
    def var v_val_cotac_contrat    as dec no-undo.
    def var v_cod_return           as char no-undo.
    def var v_cod_indic_econ       as char no-undo.

    FOR EACH tt_xml_input_output:
        DELETE tt_xml_input_output.
    END.

    FOR EACH tt_log_erros:
        DELETE tt_log_erros.
    END.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = 'Funá∆o':U
           tt_xml_input_output.ttv_des_conteudo = "Recebimento 2.00":U
           tt_xml_input_output.ttv_num_seq_1 = 1.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = 'Produto':U
           tt_xml_input_output.ttv_des_conteudo = "EMS 2":U /*Traduz para EMS 2*/  
           tt_xml_input_output.ttv_num_seq_1 = 1.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = 'Empresa':U
           tt_xml_input_output.ttv_des_conteudo = p-empresa
           tt_xml_input_output.ttv_num_seq_1 = 1.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = 'Estabel':U
           tt_xml_input_output.ttv_des_conteudo = p-estabel
           tt_xml_input_output.ttv_num_seq_1 = 1.

    CREATE tt_xml_input_output.
    ASSIGN tt_xml_input_output.ttv_cod_label = 'Moeda':U
           tt_xml_input_output.ttv_des_conteudo = p-moeda-ems5 + ";" + string(p-data-trans)
           tt_xml_input_output.ttv_num_seq_1 = 1.

   
    RUN prgint/utb/utb786za.py (INPUT-OUTPUT TABLE tt_xml_input_output,
                                OUTPUT TABLE tt_log_erros).

    IF CAN-FIND (FIRST tt_log_erros) THEN DO:
        FOR EACH tt_log_erros:
            assign i-seq-erro = i-seq-erro + 1.    
            create RowErrors.
            assign RowErrors.ErrorSequence    = i-seq-erro
                   RowErrors.ErrorSubType     = "ERROR":U
                   RowErrors.ErrorNumber      = tt_log_erros.ttv_num_cod_erro
                   RowErrors.ErrorDescription = tt_log_erros.ttv_des_erro   
                   RowErrors.ErrorHelp        = tt_log_erros.ttv_des_erro.
        END.
        RETURN "NOK":U.
    END.
    ELSE DO:
        FOR FIRST tt_xml_input_output
            where tt_xml_input_output.ttv_cod_label = 'Moeda':U  no-lock:
                assign  p-moeda-ems2 = int(tt_xml_input_output.ttv_des_conteudo_aux).
        end.
    end.


   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-converte-moeda DBOProgram 
PROCEDURE pi-converte-moeda :
/*------------------------------------------------------------------------------------------
  Purpose: Converte valores entre moedas e valida se existe cotaá∆o para as moedas.
  Parameters: p-moeda-origem     - Moeda em que se encontra o valor          - (input)(integer)
              p-moeda-destino    - Moeda a qual ser† convertido o valor      - (input)(integer)
              p-valor-origem     - Valor a ser convertido                    - (input)(decimal)
              p-data-conv        - Data de transaá∆o                         - (input)(date)
              p-valor-convertido - Valor convertido                          - (input)(decimal)
              
  Notes:
--------------------------------------------------------------------------------------------*/
    DEF INPUT  PARAM  p-moeda-origem     AS INT     NO-UNDO.
    DEF INPUT  PARAM  p-moeda-destino    AS INT     NO-UNDO.
    DEF INPUT  PARAM  p-valor-origem     AS DECIMAL NO-UNDO.
    DEF INPUT  PARAM  p-data-conv        AS DATE    NO-UNDO.
    DEF OUTPUT PARAM  p-valor-convertido AS DECIMAL NO-UNDO.


    run cdp/cd0812.p (input p-moeda-origem,
                      input p-moeda-destino,
                      input p-valor-origem,
                      input p-data-conv,
                     output p-valor-convertido ).

    IF p-valor-convertido = ? THEN DO:

        /*MOEDA DE ORIGEM - Valida se existe cotaá∆o para a moeda de origem na data informada*/
         for first cotacao
            where cotacao.mo-codigo   = p-moeda-origem
            and   cotacao.ano-periodo = string(year(p-data-conv),"9999":U) +
                                        string(month(p-data-conv),"99":U)
             and cotacao.cotacao[int(day(p-data-conv))] <> 0 no-lock:
        end.
        if not avail cotacao then do:

            /*Texto: N∆o h† cotaá∆o para a moeda &1 na data &2
            Ajuda: A moeda &1 n∆o tem cotaá∆o cadastrada na data &2.*/
            RUN piCriaErro (INPUT 316,
                            INPUT "ERROR":U,
                            INPUT string(p-moeda-origem) + '~~' + string(p-data-conv)).
        end.
        
        /*MOEDA DE DESTINO - Valida se existe cotaá∆o para a moeda de destino na data informada*/
         for first cotacao
            where cotacao.mo-codigo   = p-moeda-destino
            and   cotacao.ano-periodo = string(year(p-data-conv),"9999":U) +
                                        string(month(p-data-conv),"99":U)
             and cotacao.cotacao[int(day(p-data-conv))] <> 0 no-lock:
        end.
        if not avail cotacao then do:

            /*Texto: N∆o h† cotaá∆o para a moeda &1 na data &2
            Ajuda: A moeda &1 n∆o tem cotaá∆o cadastrada na data &2.*/
            RUN piCriaErro (INPUT 316,
                            INPUT "ERROR":U,
                            INPUT string(p-moeda-destino) + '~~' + string(p-data-conv)).
        end.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaAntecipFornec DBOProgram 
PROCEDURE piVerificaAntecipFornec :
/*------------------------------------------------------------------------------------------
  Purpose: Verifica se o fornecedor possu° antecipaá‰es vinculadas para o embarque
  Parameters: pcod-estabel      - C¢digo do estabelecimento do embarque  - (input)(character)
              pcod-embarque     - C¢digo do embarque                     - (input)(character)
              pcod-emitente     - C¢digo do fornecedor                   - (input)(integer)
              pl-possui-antecip - Indica se possui ou n∆o antecipaá∆o vinculada ao embarque - (output)(logical)
  Notes:    
--------------------------------------------------------------------------------------------*/
    DEF INPUT  PARAM  pcod-estabel       LIKE antecip-import.cod-estabel     NO-UNDO.
    DEF INPUT  PARAM  pcod-embarque      LIKE antecip-import.cod-embarq      NO-UNDO.
    DEF INPUT  PARAM  pcod-emitente      LIKE antecip-import.cdn-emitente-ap NO-UNDO.
    DEF OUTPUT PARAM  pl-possui-antecip  AS LOGICAL NO-UNDO.
   
    ASSIGN pl-possui-antecip = CAN-FIND(FIRST antecip-import
                                        WHERE antecip-import.cod-estabel     = pcod-estabel
                                          AND antecip-import.cod-embarq      = pcod-embarque
                                          AND antecip-import.cdn-emitente-ap = pcod-emitente).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaMoedasMercDespAntecip DBOProgram 
PROCEDURE piRetornaMoedasMercDespAntecip :
/*------------------------------------------------------------------------------------------
  Purpose: Retorna moedas da mercadoria/despesa e antecipaá∆o caso fornecedor da antecipaá∆o seja o 
           mesmo que a mercadoria/despesa.
  Parameters: pi-tipo-fornec  - Indica se o fornecedor da antecipaá∆o Ç o mesmo da mercadoria 
                                ou de alguma despesa.(1 = Mercadoria, 2 = Despesa) - (output)(integer)
              pi-mo-merc-desp - C¢digo da moeda da mercadoria ou despesa    - (output)(integer)
              pi-mo-antecip   - C¢digo da moeda da antecipaá∆o (EMS2)       - (output)(integer)
  Notes:    
--------------------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM pi-tipo-fornec        AS INT NO-UNDO.
    DEF OUTPUT PARAM pi-mo-merc-desp       LIKE moeda.mo-codigo NO-UNDO.
    DEF OUTPUT PARAM pi-mo-antecip         LIKE moeda.mo-codigo NO-UNDO.

    IF  NOT VALID-HANDLE(h-bocx225) THEN 
        RUN cxbo/bocx225.p PERSISTENT SET h-bocx225.

    /*Busca emitente do embarque*/
    RUN pi-busca-fornecedor-emb (INPUT RowObject.cod-estabel,
                                 INPUT RowObject.cod-embarq,
                                 OUTPUT i-cod-emitente-emb).

    /*Retorna moeda do EMS2 referente a moeda da antecipaá∆o*/
    RUN pi-retorna-moeda-ems-2(INPUT RowObject.cod-empres-ap,
                               INPUT RowObject.cod-estab-ap,
                               INPUT RowObject.cod-moed-ap,
                               INPUT RowObject.dat-transacao,
                               OUTPUT pi-mo-antecip).

      /*Verifica se o emitente da antecipaá∆o Ç o mesmo da MERCADORIA*/
    IF RowObject.cdn-emitente-ap = i-cod-emitente-emb THEN DO:

        /*Busca moeda da mercadoria*/
        FOR FIRST ordens-embarque FIELDS(numero-ordem)
            WHERE ordens-embarque.cod-estabel = RowObject.cod-estabel 
              AND ordens-embarque.embarque    = RowObject.cod-embarq NO-LOCK:
            FOR FIRST ordem-compra FIELDS(numero-ordem it-codigo cod-emitente)
                WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK:
                FOR FIRST cotacao-item FIELDS(mo-codigo) 
                    WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                      AND cotacao-item.it-codigo    = ordem-compra.it-codigo    
                      AND cotacao-item.cod-emitente = ordem-compra.cod-emitente 
                      AND cotacao-item.cot-aprovada = yes  NO-LOCK:
                    ASSIGN pi-mo-merc-desp = cotacao-item.mo-codigo.
                END.
            END.
        END.
            
        ASSIGN pi-tipo-fornec = 1. /*Mercadoria*/
    END.
    ELSE DO: 
        /*Se o fornecedor da antecipaá∆o n∆o for da mercadoria verifica se n∆o Ç 
          despachante mas Ç fornecedor de alguma despesa do embarque*/
        IF NOT CAN-FIND(FIRST embarque-imp
                         WHERE embarque-imp.cod-estabel      = RowObject.cod-estabel
                           AND embarque-imp.embarque         = RowObject.cod-embarq
                           AND embarque-imp.cod-despachante  = RowObject.cdn-emitente-ap) AND
        CAN-FIND(FIRST desp-embarque 
                 WHERE desp-embarque.cod-estabel       = RowObject.cod-estabel
                   AND desp-embarque.embarque          = RowObject.cod-embarq
                   AND desp-embarque.cod-emitente-desp = RowObject.cdn-emitente-ap) THEN DO:

            ASSIGN pi-tipo-fornec = 2. /*Despesa*/

            FOR FIRST desp-embarque FIELDS(mo-codigo)
                WHERE desp-embarque.cod-estabel       = RowObject.cod-estabel
                  AND desp-embarque.embarque          = RowObject.cod-embarq
                  AND desp-embarque.cod-emitente-desp = RowObject.cdn-emitente-ap
                  AND desp-embarque.mo-codigo         <> pi-mo-antecip NO-LOCK: END.

            IF NOT AVAIL desp-embarque THEN
                FOR FIRST desp-embarque FIELDS(mo-codigo)
                    WHERE desp-embarque.cod-estabel       = RowObject.cod-estabel
                      AND desp-embarque.embarque          = RowObject.cod-embarq
                      AND desp-embarque.cod-emitente-desp = RowObject.cdn-emitente-ap NO-LOCK: END.

            IF AVAIL desp-embarque THEN
                ASSIGN pi-mo-merc-desp = desp-embarque.mo-codigo.

        END.
    END.

    IF VALID-HANDLE(h-bocx225) THEN DO:
       DELETE PROCEDURE h-bocx225.
       ASSIGN h-bocx225 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDataEfetivaNacionaliz DBOProgram 
PROCEDURE retornaDataEfetivaNacionaliz :
/*------------------------------------------------------------------------------------------
  Purpose: Retorna data de efetivaá∆o do ponto de controle de nacionalizaá∆o.
  Parameters: pc-cod-estabel      - C¢digo do estabelecimento do embarque  - (input)(character)
  Notes:      pc-cod-embarq     - C¢digo do embarque                     - (input)(character)
              pdt-efetiva         - Data de efetivaá∆o ou £ltima previs∆o  - (output) (date)
--------------------------------------------------------------------------------------------*/
    DEF INPUT  PARAM pc-cod-estabel       LIKE antecip-import.cod-estabel    NO-UNDO.
    DEF INPUT  PARAM pc-cod-embarq        LIKE antecip-import.cod-embarq     NO-UNDO.
    DEF OUTPUT PARAM pdt-efetiva          LIKE historico-embarque.dt-efetiva NO-UNDO.

    for first embarque-imp fields(cdn-pto-desembar) no-lock
        where embarque-imp.cod-estabel = pc-cod-estabel
          and embarque-imp.embarque    = pc-cod-embarq:

         FOR FIRST historico-embarque FIELDS(dt-efetiva dt-ult-previsao)
             where historico-embarque.cod-estabel   = embarque-imp.cod-estabel
               and historico-embarque.embarque      = embarque-imp.embarque
               and historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar NO-LOCK:
             
                ASSIGN pdt-efetiva = IF historico-embarque.dt-efetiva <> ? THEN
                                        historico-embarque.dt-efetiva
                                     ELSE
                                        historico-embarque.dt-ult-previsao.
         END.
    end.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaErro DBOProgram 
PROCEDURE piCriaErro :
/*------------------------------------------------------------------------------------------
  Purpose: Cria registro na temp-table de erro.
  Parameters: piErrorNumber      - C¢digo do erro                  - (input)(integer)
              pcErrorSubType     - Tipo de erro (Error, Warning)   - (input)(character)
              pcErrorParameters  - ParÉmetros do erro              - (input)(integer)
  Notes:    
--------------------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM piErrorNumber     LIKE RowErrors.ErrorNumber     NO-UNDO.
    DEFINE INPUT PARAM pcErrorSubType    LIKE RowErrors.ErrorSubType    NO-UNDO.
    DEFINE INPUT PARAM pcErrorParameters LIKE RowErrors.ErrorParameters NO-UNDO.

    assign i-seq-erro = i-seq-erro + 1.    
    create RowErrors.
    run utp/ut-msgs.p (input "msg":U,
                      input piErrorNumber,
                       input pcErrorParameters).
    
    assign RowErrors.ErrorSequence    = i-seq-erro
           RowErrors.ErrorSubType     = pcErrorSubType
           RowErrors.ErrorNumber      = piErrorNumber
           RowErrors.ErrorDescription = return-value.   
    
    run utp/ut-msgs.p (input "help":U,
                       input piErrorNumber,
                       input pcErrorParameters).
    ASSIGN RowErrors.ErrorHelp = return-value.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
