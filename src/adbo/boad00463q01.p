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

/* ***************************  Definitions  **************************** */
{include/i-prgvrs.i BOAD00463Q01 2.00.00.004 } /*** "010004" 13/11/2023 11:45:42 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boad00463q01 MUT}
&ENDIF

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAD00463q01
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName docum-est-esoc
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
{adbo/boad00463.i RowObject}
{adbo/boad00463.i tt-docum-est-esoc-br}

DEFINE TEMP-TABLE tt-esoc-ctrl NO-UNDO
    FIELD cod-estabel  LIKE {&TableName}.cod-estabel
    FIELD cod-emitente LIKE {&TableName}.cod-emitente
    FIELD periodo      AS CHARACTER
    FIELD dt-trans     LIKE {&TableName}.dt-trans.

DEFINE TEMP-TABLE tt-esoc-ctrl2 NO-UNDO LIKE tt-esoc-ctrl
    index indice periodo
          cod-estabel
          cod-emitente.

DEFINE TEMP-TABLE tt-estabelec NO-UNDO
    FIELD cod-estabel  LIKE {&TableName}.cod-estabel.

DEFINE TEMP-TABLE tt-data NO-UNDO
    FIELD data    AS DATE
    FIELD periodo AS CHARACTER.


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/

DEFINE QUERY {&QueryName} FOR tt-esoc-ctrl,{&TableName} SCROLLING.


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}   FOR {&TableName}.
DEFINE BUFFER b-docum-est-esoc for docum-est-esoc.

DEFINE VARIABLE c-cod-emitente-ini LIKE {&TableName}.cod-emitente NO-UNDO.
DEFINE VARIABLE c-cod-emitente-fim LIKE {&TableName}.cod-emitente NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini  LIKE {&TableName}.cod-estabel  NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim  LIKE {&TableName}.cod-estabel  NO-UNDO.
DEFINE VARIABLE da-dt-trans-ini    LIKE {&TableName}.dt-trans     NO-UNDO.
DEFINE VARIABLE da-dt-trans-fim    LIKE {&TableName}.dt-trans     NO-UNDO.

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
        WHEN "cod-espec-docto":U THEN ASSIGN pFieldValue = RowObject.cod-espec-docto.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-layout":U THEN ASSIGN pFieldValue = RowObject.cod-layout.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-parcela":U THEN ASSIGN pFieldValue = RowObject.cod-parcela.
        WHEN "cod-tit-ap":U THEN ASSIGN pFieldValue = RowObject.cod-tit-ap.
        WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "id-arquivo":U THEN ASSIGN pFieldValue = RowObject.id-arquivo.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nr-insc-cno":U THEN ASSIGN pFieldValue = RowObject.nr-insc-cno.
        WHEN "nr-proc-jud":U THEN ASSIGN pFieldValue = RowObject.nr-proc-jud.
        WHEN "cod-seq-suspen":U THEN ASSIGN pFieldValue = RowObject.cod-seq-suspen.
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
        WHEN "dat-livre-1":U THEN ASSIGN pFieldValue = RowObject.dat-livre-1.
        WHEN "dat-livre-2":U THEN ASSIGN pFieldValue = RowObject.dat-livre-2.
        WHEN "dt-repasse":U THEN ASSIGN pFieldValue = RowObject.dt-repasse.
        WHEN "dt-trans":U THEN ASSIGN pFieldValue = RowObject.dt-trans.
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
        WHEN "nr-cno":U THEN ASSIGN pFieldValue = RowObject.nr-cno.
        /*WHEN "nro-docto-esoc":U THEN ASSIGN pFieldValue = RowObject.nro-docto-esoc.*/ /*N∆o descomentar devido ao erro de sequence, caso necess†rio utilizar o getKey */
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "vl-adicional":U THEN ASSIGN pFieldValue = RowObject.vl-adicional.
        WHEN "vl-apurad":U THEN ASSIGN pFieldValue = RowObject.vl-apurad.
        WHEN "vl-base-calc":U THEN ASSIGN pFieldValue = RowObject.vl-base-calc.
        WHEN "vl-base-coop":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop.
        WHEN "vl-base-coop-15":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop-15.
        WHEN "vl-base-coop-20":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop-20.
        WHEN "vl-base-coop-25":U THEN ASSIGN pFieldValue = RowObject.vl-base-coop-25.
        WHEN "vl-base-retencao":U THEN ASSIGN pFieldValue = RowObject.vl-base-retencao.
        WHEN "vl-bruto":U THEN ASSIGN pFieldValue = RowObject.vl-bruto.
        WHEN "vl-contrib-financ":U THEN ASSIGN pFieldValue = RowObject.vl-contrib-financ.
        WHEN "vl-contrib-prev":U THEN ASSIGN pFieldValue = RowObject.vl-contrib-prev.
        WHEN "vl-contrib-senar":U THEN ASSIGN pFieldValue = RowObject.vl-contrib-senar.
        WHEN "vl-deducao":U THEN ASSIGN pFieldValue = RowObject.vl-deducao.
        WHEN "vl-mat-equip":U THEN ASSIGN pFieldValue = RowObject.vl-mat-equip.
        WHEN "vl-nao-retido":U THEN ASSIGN pFieldValue = RowObject.vl-nao-retido.
        WHEN "vl-repasse":U THEN ASSIGN pFieldValue = RowObject.vl-repasse.
        WHEN "vl-ret-subempr":U THEN ASSIGN pFieldValue = RowObject.vl-ret-subempr.
        WHEN "vl-retido":U THEN ASSIGN pFieldValue = RowObject.vl-retido.
        WHEN "vl-servicos":U THEN ASSIGN pFieldValue = RowObject.vl-servicos.
        WHEN "vl-servicos-15":U THEN ASSIGN pFieldValue = RowObject.vl-servicos-15.
        WHEN "vl-servicos-20":U THEN ASSIGN pFieldValue = RowObject.vl-servicos-20.
        WHEN "vl-servicos-25":U THEN ASSIGN pFieldValue = RowObject.vl-servicos-25.
        WHEN "vl-total-retido":U THEN ASSIGN pFieldValue = RowObject.vl-total-retido.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "idi-ind-obra":U THEN ASSIGN pFieldValue = RowObject.idi-ind-obra.
        WHEN "num-contrato-gfe":U THEN ASSIGN pFieldValue = RowObject.num-contrato-gfe.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-romaneio":U THEN ASSIGN pFieldValue = RowObject.num-romaneio.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        WHEN "tp-aquis":U THEN ASSIGN pFieldValue = RowObject.tp-aquis.
        WHEN "tp-incidencia":U THEN ASSIGN pFieldValue = RowObject.tp-incidencia.
        WHEN "tp-insc-cno":U THEN ASSIGN pFieldValue = RowObject.tp-insc-cno.
        WHEN "tp-origem":U THEN ASSIGN pFieldValue = RowObject.tp-origem.
        WHEN "tp-repasse":U THEN ASSIGN pFieldValue = RowObject.tp-repasse.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dctstqsc_id
  Parameters:  
               retorna valor do campo nro-docto-esoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnro-docto-esoc LIKE docum-est-esoc.nro-docto-esoc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnro-docto-esoc = RowObject.nro-docto-esoc.

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
  Purpose:     Reposiciona registro com base no °ndice dctstqsc_id
  Parameters:  
               recebe valor do campo nro-docto-esoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnro-docto-esoc LIKE docum-est-esoc.nro-docto-esoc NO-UNDO.
    
    FIND FIRST bfdocum-est-esoc WHERE 
        bfdocum-est-esoc.nro-docto-esoc = pnro-docto-esoc NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdocum-est-esoc THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/         
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdocum-est-esoc)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEstabEmit DBOProgram 
PROCEDURE setConstraintEstabEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-emitente-ini LIKE {&TableName}.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente-fim LIKE {&TableName}.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel-ini  LIKE {&TableName}.cod-estabel  NO-UNDO.    
    DEFINE INPUT PARAMETER p-cod-estabel-fim  LIKE {&TableName}.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-trans-ini     LIKE {&TableName}.dt-trans     NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-trans-fim     LIKE {&TableName}.dt-trans     NO-UNDO.

    ASSIGN c-cod-emitente-ini = p-cod-emitente-ini
           c-cod-emitente-fim = p-cod-emitente-fim
           c-cod-estabel-ini  = p-cod-estabel-ini 
           c-cod-estabel-fim  = p-cod-estabel-fim 
           da-dt-trans-ini    = p-dt-trans-ini    
           da-dt-trans-fim    = p-dt-trans-fim.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEstabEmit DBOProgram 
PROCEDURE openQueryEstabEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-periodo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE da-data   AS DATE      NO-UNDO.

    DEFINE VARIABLE c-estab-contr  AS CHAR NO-UNDO.
    DEFINE VARIABLE c-period-contr AS CHAR NO-UNDO.
    DEFINE VARIABLE i-emit-contr   AS INT  NO-UNDO.

    EMPTY TEMP-TABLE tt-esoc-ctrl  NO-ERROR.
    EMPTY TEMP-TABLE tt-esoc-ctrl2 NO-ERROR.
    EMPTY TEMP-TABLE tt-data       NO-ERROR.
    EMPTY TEMP-TABLE tt-estabelec  NO-ERROR.

    FOR EACH estabelec FIELDS(cod-estabel) NO-LOCK
        WHERE estabelec.cod-estabel >= c-cod-estabel-ini
          AND estabelec.cod-estabel <= c-cod-estabel-fim:

        IF CAN-FIND (FIRST {&TableName}
                    WHERE {&TableName}.cod-estabel = estabelec.cod-estabel) THEN DO:

            CREATE tt-estabelec.
            ASSIGN tt-estabelec.cod-estabel = estabelec.cod-estabel.
    
        END.

    END.

    DO  da-data = da-dt-trans-ini to da-dt-trans-fim:
        IF CAN-FIND(FIRST {&TableName}
                    WHERE {&TableName}.dt-trans = da-data) THEN DO:
            CREATE tt-data.
            ASSIGN tt-data.data    = da-data
                   tt-data.periodo = STRING(MONTH(da-data),"99") + STRING(YEAR(da-data)).

        END.
    END.



    FOR EACH tt-data:
        FOR EACH tt-estabelec:
            FOR EACH {&TableName}
                WHERE {&TableName}.dt-trans      = tt-data.data
                  AND {&TableName}.cod-estabel   = tt-estabelec.cod-estabel
                  AND {&TableName}.cod-emitente >= c-cod-emitente-ini
                  AND {&TableName}.cod-emitente <= c-cod-emitente-fim NO-LOCK:
        
                CREATE tt-esoc-ctrl2.
                ASSIGN tt-esoc-ctrl2.cod-emitente = {&TableName}.cod-emitente
                       tt-esoc-ctrl2.cod-estabel  = {&TableName}.cod-estabel
                       tt-esoc-ctrl2.dt-trans     = {&TableName}.dt-trans
                       tt-esoc-ctrl2.periodo      = tt-data.periodo.
        
            END.
        END.
    END.

FOR EACH tt-esoc-ctrl2 USE-INDEX indice:

    IF NOT (tt-esoc-ctrl2.cod-estabel  = c-estab-contr  AND
            tt-esoc-ctrl2.periodo      = c-period-contr AND
            tt-esoc-ctrl2.cod-emitente = i-emit-contr) THEN DO:  

        CREATE tt-esoc-ctrl.
        ASSIGN tt-esoc-ctrl.cod-emitente = tt-esoc-ctrl2.cod-emitente
               tt-esoc-ctrl.cod-estabel  = tt-esoc-ctrl2.cod-estabel
               tt-esoc-ctrl.dt-trans     = tt-esoc-ctrl2.dt-trans
               tt-esoc-ctrl.periodo      = tt-esoc-ctrl2.periodo.

    END.

        ASSIGN c-estab-contr  = tt-esoc-ctrl2.cod-estabel 
               c-period-contr = tt-esoc-ctrl2.periodo     
               i-emit-contr   = tt-esoc-ctrl2.cod-emitente.


END.

    OPEN QUERY {&QueryName} 
        FOR EACH tt-esoc-ctrl NO-LOCK, 
        FIRST {&TableName} NO-LOCK
            WHERE {&TableName}.dt-trans     = tt-esoc-ctrl.dt-trans 
              AND {&TableName}.cod-estabel  = tt-esoc-ctrl.cod-estabel 
              AND {&TableName}.cod-emitente = tt-esoc-ctrl.cod-emitente
                BY tt-esoc-ctrl.periodo DESCENDING
                BY tt-esoc-ctrl.cod-estabel.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gettt-docum-est-esoc-br DBOProgram 
PROCEDURE gettt-docum-est-esoc-br :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-emitente LIKE {&tableName}.cod-emitente NO-UNDO.  
    DEFINE INPUT PARAMETER p-cod-estabel  LIKE {&tableName}.cod-estabel  NO-UNDO.
    DEFINE INPUT PARAMETER p-da-dt-trans  LIKE {&tableName}.dt-trans     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-docum-est-esoc-br.

    DEFINE VARIABLE c-periodo     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-periodo-tab AS CHARACTER NO-UNDO.

    ASSIGN c-periodo = STRING(MONTH(p-da-dt-trans),"99") + STRING(YEAR(p-da-dt-trans)). 

    EMPTY TEMP-TABLE tt-docum-est-esoc-br NO-ERROR.

    FOR EACH {&TableName} NO-LOCK
         WHERE {&tableName}.cod-emitente    = p-cod-emitente
           AND {&tableName}.cod-estabel     = p-cod-estabel:

        ASSIGN c-periodo-tab = STRING(MONTH({&TableName}.dt-trans),"99") + STRING(YEAR({&TableName}.dt-trans)).

        IF c-periodo-tab <> c-periodo THEN
            NEXT.

        CREATE tt-docum-est-esoc-br.
        BUFFER-COPY {&tableName} TO tt-docum-est-esoc-br.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecordDocmEstEsoc wMaintenance 
PROCEDURE deleteRecordDocmEstEsoc :
/*------------------------------------------------------------------------------
  Purpose: Deletar o registro posicionado com base no ROWID
  Parameters: p-rowid - RowId da tabela docum-est-esoc
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-nro-docto-esoc LIKE docum-est-esoc.nro-docto-esoc NO-UNDO.

    FOR FIRST docum-est-esoc EXCLUSIVE-LOCK 
         WHERE docum-est-esoc.nro-docto-esoc = p-nro-docto-esoc:
        
        DELETE docum-est-esoc.

    END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
