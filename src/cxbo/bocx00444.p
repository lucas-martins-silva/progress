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
{include/i-prgvrs.i BOCX00444 2.00.00.006 } /*** "010006" 13/03/2025 17:18:55 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx00444 MUT}
&ENDIF
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00444
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName adiant-despes-lista
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
{cxbo/bocx00444.i RowObject}
{cxbo/bocx00444.i tt-adiant-despes-lista}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
    FIELD cod-emitente LIKE ordem-compra.cod-emitente
    FIELD it-codigo    LIKE ordem-compra.it-codigo
    FIELD num-pedido   LIKE ordem-compra.num-pedido
    FIELD mo-codigo    LIKE cotacao-item.mo-codigo
    FIELD preco-unit   LIKE cotacao-item.preco-unit
    FIELD preco-total  AS   DECIMAL FORMAT ">>>>>,>>>,>>9.99999":U
    FIELD marca        AS   CHARACTER
    FIELD r-rowid      AS ROWID.

DEFINE TEMP-TABLE tt-ordens-embarque-faixa NO-UNDO LIKE tt-ordens-embarque.

DEFINE TEMP-TABLE tt-adiant-despes-lista-det-aux NO-UNDO LIKE adiant-despes-lista-det
    FIELD cod-refer         LIKE adiant-despes-parc.cod-refer      
    FIELD cod-parcela       LIKE adiant-despes-parc.cod-parcela    
    FIELD cod-espec-docto   LIKE adiant-despes-parc.cod-espec-docto
    FIELD cod-ser-docto     LIKE adiant-despes-parc.cod-ser-docto  
    FIELD cod-tit-ap        LIKE adiant-despes-parc.cod-tit-ap     
    FIELD val-adiant-moed   LIKE adiant-despes-parc.val-adiant-moed
    FIELD dat-emissao       LIKE adiant-despes-parc.dat-emissao    
    FIELD dat-vencto        LIKE adiant-despes-parc.dat-vencto     
    FIELD num-pedido        LIKE ordem-compra.num-pedido
    FIELD parcela           LIKE ordens-embarque.parcela
    FIELD cod-emitente      LIKE ordem-compra.cod-emitente
    FIELD it-codigo         LIKE ordem-compra.it-codigo
    FIELD observacao        LIKE adiant-despes-lista.observacao
    FIELD marca             AS   CHARACTER
    FIELD r-rowid           AS ROWID.

DEFINE TEMP-TABLE tt-adiant-despes-lista-det-faixa NO-UNDO LIKE tt-adiant-despes-lista-det-aux.

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
        WHEN "cod-embarq":U THEN ASSIGN pFieldValue = RowObject.cod-embarq.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "desc-identif":U THEN ASSIGN pFieldValue = RowObject.desc-identif.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
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
        WHEN "dat-emissao":U THEN ASSIGN pFieldValue = RowObject.dat-emissao.
        WHEN "dat-implant":U THEN ASSIGN pFieldValue = RowObject.dat-implant.
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dat-prev-pagto":U THEN ASSIGN pFieldValue = RowObject.dat-prev-pagto.
        WHEN "dat-vencto":U THEN ASSIGN pFieldValue = RowObject.dat-vencto.
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
        WHEN "cdd-adiant":U THEN ASSIGN pFieldValue = RowObject.cdd-adiant.
        WHEN "perc-mercad":U THEN ASSIGN pFieldValue = RowObject.perc-mercad.
        WHEN "val-adiant":U THEN ASSIGN pFieldValue = RowObject.val-adiant.
        WHEN "val-adiant-moed":U THEN ASSIGN pFieldValue = RowObject.val-adiant-moed.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-previs":U THEN ASSIGN pFieldValue = RowObject.val-previs.
        WHEN "val-realzdo":U THEN ASSIGN pFieldValue = RowObject.val-realzdo.
        WHEN "val-realzdo-moed":U THEN ASSIGN pFieldValue = RowObject.val-realzdo-moed.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "dias-vencto":U THEN ASSIGN pFieldValue = RowObject.dias-vencto.
        WHEN "idi-identif":U THEN ASSIGN pFieldValue = RowObject.idi-identif.
        WHEN "idi-informa":U THEN ASSIGN pFieldValue = RowObject.idi-informa.
        WHEN "idi-lancto":U THEN ASSIGN pFieldValue = RowObject.idi-lancto.
        WHEN "idi-operac-antecip":U THEN ASSIGN pFieldValue = RowObject.idi-operac-antecip.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-lista":U THEN ASSIGN pFieldValue = RowObject.num-seq-lista.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice adntdspb_id2
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo cdd-adiant
               retorna valor do campo num-seq-lista
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE adiant-despes-lista.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-adiant LIKE adiant-despes-lista.cdd-adiant NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-lista LIKE adiant-despes-lista.num-seq-lista NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pcdd-adiant = RowObject.cdd-adiant
           pnum-seq-lista = RowObject.num-seq-lista.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextSeq DBOProgram 
PROCEDURE getNextSeq :
/*------------------------------------------------------------------------------
  Purpose: Retorna a pr¢xima sequencia da lista de adiantamentos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-estabel LIKE adiant-despes-lista.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pcdd-adiant  LIKE adiant-despes-lista.cdd-adiant  NO-UNDO.
    DEFINE OUTPUT PARAMETER pSeq         LIKE adiant-despes-lista.num-seq     NO-UNDO.

    ASSIGN pSeq = 1.

    FOR LAST adiant-despes-lista
       WHERE adiant-despes-lista.cod-estabel = pcod-estabel
         AND adiant-despes-lista.cdd-adiant  = pcdd-adiant
          BY adiant-despes-lista.num-seq-lista:
        ASSIGN pSeq = adiant-despes-lista.num-seq-lista + 1.
    END.
                  
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
  Purpose:     Reposiciona registro com base no °ndice adntdspb_id2
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo cdd-adiant
               recebe valor do campo num-seq-lista
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE adiant-despes-lista.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-adiant LIKE adiant-despes-lista.cdd-adiant NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-lista LIKE adiant-despes-lista.num-seq-lista NO-UNDO.

    FIND FIRST bfadiant-despes-lista WHERE 
        bfadiant-despes-lista.cod-estabel = pcod-estabel AND 
        bfadiant-despes-lista.cdd-adiant = pcdd-adiant AND 
        bfadiant-despes-lista.num-seq-lista = pnum-seq-lista NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfadiant-despes-lista THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfadiant-despes-lista)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaBrowserAntecipacao DBOProgram  
PROCEDURE piCriaBrowserAntecipacao :
/*------------------------------------------------------------------------------
  Purpose:     Reabre a query das antecipaá‰es de acordo com o filtro utilizado 
               via IM0720pr
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-nr-proc-imp-ini      LIKE processo-imp.nr-proc-imp           NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-proc-imp-fim      LIKE processo-imp.nr-proc-imp           NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-pedido-ini       LIKE pedido-compr.num-pedido            NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-pedido-fim       LIKE pedido-compr.num-pedido            NO-UNDO.  
    DEFINE INPUT  PARAMETER pi-numero-ordem-ini     LIKE ordem-compra.numero-ordem          NO-UNDO.
    DEFINE INPUT  PARAMETER pi-numero-ordem-fim     LIKE ordem-compra.numero-ordem          NO-UNDO.
    DEFINE INPUT  PARAMETER pi-parcela-ini          LIKE prazo-compra.parcela               NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-parcela-fim          LIKE prazo-compra.parcela               NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-cod-emitente-ini     LIKE emitente.cod-emitente              NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente-fim     LIKE emitente.cod-emitente              NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nome-abrev-ini       LIKE emitente.nome-abrev                NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nome-abrev-fim       LIKE emitente.nome-abrev                NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-refer-ini        LIKE adiant-despes-parc.cod-refer       NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-refer-fim        LIKE adiant-despes-parc.cod-refer       NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-espec-docto-ini  LIKE adiant-despes-parc.cod-espec-docto NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-espec-docto-fim  LIKE adiant-despes-parc.cod-espec-docto NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-ser-docto-ini    LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-ser-docto-fim    LIKE adiant-despes-parc.cod-ser-docto   NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-tit-ap-ini       LIKE adiant-despes-parc.cod-tit-ap      NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-tit-ap-fim       LIKE adiant-despes-parc.cod-tit-ap      NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-parcela-ini      LIKE adiant-despes-parc.cod-parcela     NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-parcela-fim      LIKE adiant-despes-parc.cod-parcela     NO-UNDO.
    DEFINE INPUT  PARAMETER pdt-dat-emissao-ini     LIKE adiant-despes-parc.dat-emissao     NO-UNDO.
    DEFINE INPUT  PARAMETER pdt-dat-emissao-fim     LIKE adiant-despes-parc.dat-emissao     NO-UNDO.
    DEFINE INPUT  PARAMETER pdt-dat-vencto-ini      LIKE adiant-despes-parc.dat-vencto      NO-UNDO.
    DEFINE INPUT  PARAMETER pdt-dat-vencto-fim      LIKE adiant-despes-parc.dat-vencto      NO-UNDO.
    DEFINE INPUT  PARAMETER pde-val-adiant-moed-ini LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.
    DEFINE INPUT  PARAMETER pde-val-adiant-moed-fim LIKE adiant-despes-parc.val-adiant-moed NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-adiant-despes-lista-det-faixa.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-adiant-despes-lista-det-aux.

    EMPTY TEMP-TABLE tt-adiant-despes-lista-det-aux.

    FOR EACH tt-adiant-despes-lista-det-faixa
       WHERE tt-adiant-despes-lista-det-faixa.nr-proc-imp      >= pc-nr-proc-imp-ini  
         AND tt-adiant-despes-lista-det-faixa.nr-proc-imp      <= pc-nr-proc-imp-fim  
         AND tt-adiant-despes-lista-det-faixa.num-pedido       >= pi-num-pedido-ini
         AND tt-adiant-despes-lista-det-faixa.num-pedido       <= pi-num-pedido-fim
         AND tt-adiant-despes-lista-det-faixa.numero-ordem     >= pi-numero-ordem-ini
         AND tt-adiant-despes-lista-det-faixa.numero-ordem     <= pi-numero-ordem-fim
         AND tt-adiant-despes-lista-det-faixa.parcela          >= pi-parcela-ini
         AND tt-adiant-despes-lista-det-faixa.parcela          <= pi-parcela-fim
         AND tt-adiant-despes-lista-det-faixa.cod-emitente     >= pi-cod-emitente-ini
         AND tt-adiant-despes-lista-det-faixa.cod-emitente     <= pi-cod-emitente-fim
         AND tt-adiant-despes-lista-det-faixa.cod-refer        >= pc-cod-refer-ini
         AND tt-adiant-despes-lista-det-faixa.cod-refer        <= pc-cod-refer-fim
         AND tt-adiant-despes-lista-det-faixa.cod-espec-docto  >= pc-cod-espec-docto-ini
         AND tt-adiant-despes-lista-det-faixa.cod-espec-docto  <= pc-cod-espec-docto-fim
         AND tt-adiant-despes-lista-det-faixa.cod-ser-docto    >= pc-cod-ser-docto-ini
         AND tt-adiant-despes-lista-det-faixa.cod-ser-docto    <= pc-cod-ser-docto-fim
         AND tt-adiant-despes-lista-det-faixa.cod-tit-ap       >= pc-cod-tit-ap-ini
         AND tt-adiant-despes-lista-det-faixa.cod-tit-ap       <= pc-cod-tit-ap-fim
         AND tt-adiant-despes-lista-det-faixa.cod-parcela      >= pc-cod-parcela-ini
         AND tt-adiant-despes-lista-det-faixa.cod-parcela      <= pc-cod-parcela-fim
         AND tt-adiant-despes-lista-det-faixa.dat-emissao      >= pdt-dat-emissao-ini
         AND tt-adiant-despes-lista-det-faixa.dat-emissao      <= pdt-dat-emissao-fim
         AND tt-adiant-despes-lista-det-faixa.dat-vencto       >= pdt-dat-vencto-ini
         AND tt-adiant-despes-lista-det-faixa.dat-vencto       <= pdt-dat-vencto-fim
         AND tt-adiant-despes-lista-det-faixa.val-adiant-moed  >= pde-val-adiant-moed-ini
         AND tt-adiant-despes-lista-det-faixa.val-adiant-moed  <= pde-val-adiant-moed-fim,
        FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-adiant-despes-lista-det-faixa.cod-emitente:
        
        IF emitente.nome-abrev  < pc-nome-abrev-ini  
        OR emitente.nome-abrev  > pc-nome-abrev-fim THEN NEXT.

        CREATE tt-adiant-despes-lista-det-aux.
        BUFFER-COPY tt-adiant-despes-lista-det-faixa TO tt-adiant-despes-lista-det-aux.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaBrowserOrdens DBOProgram  
PROCEDURE piCriaBrowserOrdens :
/*------------------------------------------------------------------------------
  Purpose:     Reabre a query das ordens de embarque de acordo com o filtro 
               utilizado via IM0720pr
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-nr-proc-imp-ini      LIKE processo-imp.nr-proc-imp           NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-proc-imp-fim      LIKE processo-imp.nr-proc-imp           NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-pedido-ini       LIKE pedido-compr.num-pedido            NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-pedido-fim       LIKE pedido-compr.num-pedido            NO-UNDO.  
    DEFINE INPUT  PARAMETER pi-numero-ordem-ini     LIKE ordem-compra.numero-ordem          NO-UNDO.
    DEFINE INPUT  PARAMETER pi-numero-ordem-fim     LIKE ordem-compra.numero-ordem          NO-UNDO.
    DEFINE INPUT  PARAMETER pi-parcela-ini          LIKE prazo-compra.parcela               NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-parcela-fim          LIKE prazo-compra.parcela               NO-UNDO. 
    DEFINE INPUT  PARAMETER pi-cod-emitente-ini     LIKE emitente.cod-emitente              NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-emitente-fim     LIKE emitente.cod-emitente              NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nome-abrev-ini       LIKE emitente.nome-abrev                NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nome-abrev-fim       LIKE emitente.nome-abrev                NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-ordens-embarque-faixa.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-ordens-embarque.

    EMPTY TEMP-TABLE tt-ordens-embarque.

    FOR EACH tt-ordens-embarque-faixa
       WHERE tt-ordens-embarque-faixa.nr-proc-imp  >= pc-nr-proc-imp-ini 
         AND tt-ordens-embarque-faixa.nr-proc-imp  <= pc-nr-proc-imp-fim 
         AND tt-ordens-embarque-faixa.num-pedido   >= pi-num-pedido-ini  
         AND tt-ordens-embarque-faixa.num-pedido   <= pi-num-pedido-fim  
         AND tt-ordens-embarque-faixa.numero-ordem >= pi-numero-ordem-ini
         AND tt-ordens-embarque-faixa.numero-ordem <= pi-numero-ordem-fim
         AND tt-ordens-embarque-faixa.parcela      >= pi-parcela-ini     
         AND tt-ordens-embarque-faixa.parcela      <= pi-parcela-fim     
         AND tt-ordens-embarque-faixa.cod-emitente >= pi-cod-emitente-ini
         AND tt-ordens-embarque-faixa.cod-emitente <= pi-cod-emitente-fim,
        FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = tt-ordens-embarque-faixa.cod-emitente:
    
        IF emitente.nome-abrev  < pc-nome-abrev-ini  
        OR emitente.nome-abrev  > pc-nome-abrev-fim THEN NEXT.
        
        CREATE tt-ordens-embarque.
        BUFFER-COPY tt-ordens-embarque-faixa TO tt-ordens-embarque.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura de todos os registros da query
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK 
                       INDEXED-REPOSITION.

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
    
    IF pType = "CREATE":U 
    OR pType = "UPDATE":U THEN DO:
        IF RowObject.cod-refer = "":U THEN DO:
            {utp/ut-liter.i Referància * R}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="Error"
                                        &ErrorParameters="RETURN-VALUE"}
        END.
        IF CAN-FIND(FIRST bf{&TableName}
                    WHERE bf{&TableName}.cod-estabel   = RowObject.cod-estabel  
                      AND bf{&TableName}.cdd-adiant    = RowObject.cdd-adiant   
                      AND bf{&TableName}.num-seq-lista = RowObject.num-seq-lista
                      AND bf{&TableName}.cdn-moeda     = RowObject.cdn-moeda
                      AND ROWID(bf{&TableName})        <> RowObject.r-rowid) THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="55028"    
                                            &ErrorType="EMS"
                                            &ErrorSubType="Error"
                                            &ErrorParameters="RowObject.cdn-moeda"}
        END.
    END.
    ELSE
        IF pType = "DELETE":U THEN DO:
            IF CAN-FIND(FIRST adiant-despes-parc
                        WHERE adiant-despes-parc.cod-estabel = RowObject.cod-estabel
                          AND adiant-despes-parc.cdd-adiant  = RowObject.cdd-adiant
                          AND adiant-despes-parc.cod-refer   = RowObject.cod-refer
                          AND adiant-despes-parc.log-gerou-tit-ap ) THEN DO:
                {utp/ut-liter.i Adiantamento_possui_T°tulo_no_APB * R }
                {method/svc/errors/inserr.i &ErrorNumber="34621"    
                                            &ErrorType="EMS"
                                            &ErrorSubType="Error"
                                            &ErrorParameters="RETURN-VALUE"}
    
            END.
        END.



    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

