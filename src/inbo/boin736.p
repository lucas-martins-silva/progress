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
{include/i-prgvrs.i BOIN736 2.00.00.002} /*** "010002" 13/11/2023 11:45:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin736 MUT}
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
&GLOBAL-DEFINE DBOName BOIN736
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName it-doc-fisico-serial
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
{inbo/boin736.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}         FOR {&TableName}.
DEFINE BUFFER b-it-doc-fisico-serial FOR {&TableName}.

{inbo/boin163.i tt-it-doc-fisico}
{dibo/bodi400.i tt-serial-faturam}

DEFINE VARIABLE c-serie-docto  LIKE it-doc-fisico-serial.cod-ser-docto NO-UNDO.
DEFINE VARIABLE c-cod-docto    LIKE it-doc-fisico-serial.cod-docto     NO-UNDO.
DEFINE VARIABLE i-cod-emitente LIKE it-doc-fisico-serial.cdn-emitente  NO-UNDO.
DEFINE VARIABLE i-tipo-nf      LIKE it-doc-fisico-serial.idi-tip-nf    NO-UNDO.
DEFINE VARIABLE i-sequencia    LIKE it-doc-fisico-serial.num-seq       NO-UNDO.

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
         HEIGHT             = 3.21
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
DEFINE TEMP-TABLE RowErrorsAux LIKE RowErrors.

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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-ser-docto":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
        WHEN "cod-serial":U THEN ASSIGN pFieldValue = RowObject.cod-serial.
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
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "idi-tip-nf":U THEN ASSIGN pFieldValue = RowObject.idi-tip-nf.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itmdctfb-id
  Parameters:  
               retorna valor do campo cod-ser-docto
               retorna valor do campo cod-docto
               retorna valor do campo cdn-emitente
               retorna valor do campo idi-tip-nf
               retorna valor do campo num-seq
               retorna valor do campo cod-serial
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-ser-docto LIKE it-doc-fisico-serial.cod-ser-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto LIKE it-doc-fisico-serial.cod-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE it-doc-fisico-serial.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-nf LIKE it-doc-fisico-serial.idi-tip-nf NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE it-doc-fisico-serial.num-seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-serial LIKE it-doc-fisico-serial.cod-serial NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-ser-docto = RowObject.cod-ser-docto
           pcod-docto = RowObject.cod-docto
           pcdn-emitente = RowObject.cdn-emitente
           pidi-tip-nf = RowObject.idi-tip-nf
           pnum-seq = RowObject.num-seq
           pcod-serial = RowObject.cod-serial.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQtdSeriaisLidos DBOProgram 
PROCEDURE getQtdSeriaisLidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER prwItemDocFisico AS ROWID                         NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdSeriaisLidos AS DECIMAL FORMAT ">>>>>>9.9999" NO-UNDO.

    ASSIGN pQtdSeriaisLidos = 0.

    FIND FIRST it-doc-fisico
         WHERE ROWID(it-doc-fisico) = prwItemDocFisico NO-LOCK NO-ERROR.

    IF AVAIL it-doc-fisico THEN DO:

        FOR EACH  b-it-doc-fisico-serial
            WHERE b-it-doc-fisico-serial.cod-ser-docto = it-doc-fisico.serie-docto  AND
                  b-it-doc-fisico-serial.cod-docto     = it-doc-fisico.nro-docto    AND
                  b-it-doc-fisico-serial.cdn-emitente  = it-doc-fisico.cod-emitente AND
                  b-it-doc-fisico-serial.idi-tip-nf    = it-doc-fisico.tipo-nota    AND
                  b-it-doc-fisico-serial.num-seq       = it-doc-fisico.sequencia    NO-LOCK,
            FIRST serial-faturam
            WHERE serial-faturam.cod-serial = b-it-doc-fisico-serial.cod-serial NO-LOCK:

            ASSIGN pQtdSeriaisLidos = pQtdSeriaisLidos + serial-faturam.qtd-item-serial.
        END.
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
  Purpose:     Reposiciona registro com base no °ndice itmdctfb-id
  Parameters:  
               recebe valor do campo cod-ser-docto
               recebe valor do campo cod-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo idi-tip-nf
               recebe valor do campo num-seq
               recebe valor do campo cod-serial
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ser-docto LIKE it-doc-fisico-serial.cod-ser-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto LIKE it-doc-fisico-serial.cod-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente LIKE it-doc-fisico-serial.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-nf LIKE it-doc-fisico-serial.idi-tip-nf NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE it-doc-fisico-serial.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pcod-serial LIKE it-doc-fisico-serial.cod-serial NO-UNDO.

    FIND FIRST bfit-doc-fisico-serial WHERE 
        bfit-doc-fisico-serial.cod-ser-docto = pcod-ser-docto AND 
        bfit-doc-fisico-serial.cod-docto = pcod-docto AND 
        bfit-doc-fisico-serial.cdn-emitente = pcdn-emitente AND 
        bfit-doc-fisico-serial.idi-tip-nf = pidi-tip-nf AND 
        bfit-doc-fisico-serial.num-seq = pnum-seq AND 
        bfit-doc-fisico-serial.cod-serial = pcod-serial NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfit-doc-fisico-serial THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfit-doc-fisico-serial)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inclusaoItDocFisicoSerial DBOProgram 
PROCEDURE inclusaoItDocFisicoSerial :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pSerie      LIKE it-doc-fisico.serie-docto      NO-UNDO.
    DEFINE INPUT PARAMETER pNrDocto    LIKE it-doc-fisico.nro-docto        NO-UNDO.
    DEFINE INPUT PARAMETER pEmitente   LIKE it-doc-fisico.cod-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pTipoNota   LIKE it-doc-fisico.tipo-nota        NO-UNDO.
    DEFINE INPUT PARAMETER pSequencia  LIKE it-doc-fisico.sequencia        NO-UNDO.
    DEFINE INPUT PARAMETER pSerial     LIKE serial-faturam.cod-serial      NO-UNDO.
    DEFINE INPUT PARAMETER pQuantidade LIKE serial-faturam.qtd-item-serial NO-UNDO.
    DEFINE INPUT PARAMETER pUsuario    AS   CHARACTER FORMAT "X(12)"       NO-UNDO.

    DEFINE VARIABLE h-bodi400            AS HANDLE    NO-UNDO.
    DEFINE VARIABLE l-serial-faturamento AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-serial-gerado      AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE i-estado-serial      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-desc-situacao      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-cod-item-serial    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE d-qtd-item-serial    AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE d-qtd-total-serial   AS DECIMAL   NO-UNDO.

    ASSIGN l-serial-gerado    = NO
           i-estado-serial    = 0
           d-qtd-item-serial  = 0
           d-qtd-total-serial = 0.

    RUN emptyRowErrors IN THIS-PROCEDURE.
    RUN emptyRowObject IN THIS-PROCEDURE.

    IF NOT CAN-FIND(FIRST usuar_mestre
                    WHERE usuar_mestre.cod_usuario = pUsuario NO-LOCK) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Usu†rio" *}
        ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-usuario"}
    END.
    
    FIND FIRST doc-fisico
         WHERE doc-fisico.serie-docto  = pSerie    AND
               doc-fisico.nro-docto    = pNrDocto  AND
               doc-fisico.cod-emitente = pEmitente AND
               doc-fisico.tipo-nota    = pTipoNota NO-LOCK NO-ERROR.

    IF NOT AVAIL doc-fisico THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-do-recebimento-fisic AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento_do_Recebimento_F°sico" *}
        ASSIGN c-lbl-liter-documento-do-recebimento-fisic = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-documento-do-recebimento-fisic"}
    END.
    ELSE DO:
        /***********************************
        ** Situacao = 1 (N∆o Atualizado)  **
        ***********************************/
        IF doc-fisico.situacao <> 1 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="7183"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
        END.

        FIND FIRST it-doc-fisico
             WHERE it-doc-fisico.serie-docto  = doc-fisico.serie-docto  AND
                   it-doc-fisico.nro-docto    = doc-fisico.nro-docto    AND
                   it-doc-fisico.cod-emitente = doc-fisico.cod-emitente AND
                   it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota    AND
                   it-doc-fisico.sequencia    = pSequencia              NO-LOCK NO-ERROR.

        IF NOT AVAIL it-doc-fisico THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-do-recebimento-fisico AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_do_Recebimento_F°sico" *}
            ASSIGN c-lbl-liter-item-do-recebimento-fisico = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-item-do-recebimento-fisico"}
        END.
        ELSE DO:
            FIND FIRST item-dist
                 WHERE item-dist.it-codigo = it-doc-fisico.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAIL item-dist THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="56"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-item + ' ' + STRING(it-doc-fisico.it-codigo)"}
            END.
            ELSE DO:
                /******************************
                ** Item Controla Serial?     **
                ******************************/
                IF NOT item-dist.log-1 THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="28704"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="STRING(item-dist.it-codigo)"}
                END.
            END.
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN
        RETURN "NOK":U.

    FIND FIRST it-nota-fisc
         WHERE it-nota-fisc.cod-estabel = doc-fisico.cod-estabel   AND
               it-nota-fisc.nr-nota-fis = it-doc-fisico.nro-comp   AND
               it-nota-fisc.serie       = it-doc-fisico.serie-comp AND
               it-nota-fisc.nr-seq-fat  = it-doc-fisico.seq-comp   AND
               it-nota-fisc.it-codigo   = it-doc-fisico.it-codigo  NO-LOCK NO-ERROR.

    IF AVAIL it-nota-fisc THEN DO:

         /*****************************************************************
        ** Se no faturamento (FT0502) forem relacionados seriais a NFS, **
        ** entao o serial passado como parametro deve estar relacionado **
        ** a esta nota.                                                 **
        ** Se um item faturado nao possuir "Controle Seriais" (CD0903), **
        ** passar a possuir esta parametrizacao e houver uma devoluá∆o  **
        ** do mesmo, com a parametrizacao antiga, Controle Seriais = NO.**
        ** Entao com o serial passado como parametro, sera criado um    **
        ** novo serial.                                                 **  
        *****************************************************************/
        IF CAN-FIND(FIRST it-nota-fisc-serial
                    WHERE it-nota-fisc-serial.cod-estab       = it-nota-fisc.cod-estabel AND
                          it-nota-fisc-serial.cod-serie       = it-nota-fisc.serie       AND
                          it-nota-fisc-serial.cod-nota-fisc   = it-nota-fisc.nr-nota-fis AND
                          it-nota-fisc-serial.num-seq-item-nf = it-nota-fisc.nr-seq-fat  AND
                          it-nota-fisc-serial.cod-item        = it-nota-fisc.it-codigo   NO-LOCK) THEN
            ASSIGN l-serial-faturamento = YES.
        ELSE
            ASSIGN l-serial-faturamento = NO.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN
        RETURN "NOK":U.

    IF  NOT VALID-HANDLE(h-bodi400)               OR  
        h-bodi400:TYPE      <> "PROCEDURE":U      OR
        h-bodi400:FILE-NAME <> "dibo/bodi400.p":U THEN DO:
        RUN dibo/bodi400.p PERSISTENT SET h-bodi400.
    END.

    RUN emptyRowErrors  IN h-bodi400.
    RUN openQueryStatic IN h-bodi400 (INPUT "Main":U).
    RUN goToKey         IN h-bodi400 (INPUT  pSerial).
    
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getIntField  IN h-bodi400 (INPUT  "idi-estado-serial":U,
                                       OUTPUT i-estado-serial).


        /***********************************
        ** Situacao 1 - Disponivel        **             
        ***********************************/
        
        IF  i-estado-serial <> 2 THEN DO:   /* Alfa */

            ASSIGN c-desc-situacao = STRING({diinc/i01di400.i 04 i-estado-serial}).
    
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-faturar AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "faturar" *}
            ASSIGN c-lbl-liter-faturar = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="28710"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-faturar + '~~~~' + STRING(c-desc-situacao)"}
        END.

        RUN getCharField IN h-bodi400 (INPUT  "cod-item":U,
                                       OUTPUT c-cod-item-serial).

        /*******************************************************
        ** Item do Serial diferente do Item na Nota?          **
        *******************************************************/
        IF c-cod-item-serial <> it-doc-fisico.it-codigo THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="28711"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(pSerial) + '~~~~' + STRING(c-cod-item-serial)"}
        END.
        
        RUN getDecField  IN h-bodi400 (INPUT  "qtd-item-serial":U,
                                       OUTPUT d-qtd-item-serial).

        IF pQuantidade <> d-qtd-item-serial THEN
            ASSIGN pQuantidade = d-qtd-item-serial.

        /* Alfa */
        IF  l-serial-faturamento = NO THEN DO:
         
            RUN validaCodSerial IN h-bodi400 (INPUT pSerial,
                                              INPUT doc-fisico.cod-estabel,
                                              INPUT ROWID(it-doc-fisico) ).
                  
            IF  RETURN-VALUE = "NOK":U THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-codigo-serial-ja-pertence-a-ou AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "C¢digo_Serial_j†_pertence_a_outra_NFS" *}
                ASSIGN c-lbl-liter-codigo-serial-ja-pertence-a-ou = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="25997"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-codigo-serial-ja-pertence-a-ou + 
                                                              '~~~~' + c-lbl-liter-codigo-serial-ja-pertence-a-ou"}
            END.    
        END.
    END.

    IF pQuantidade = 0 THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-quantidade-serial AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Quantidade_Serial" *}
        ASSIGN c-lbl-liter-quantidade-serial = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="36"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-quantidade-serial"}
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN DO:
        IF VALID-HANDLE(h-bodi400) THEN DO:
            DELETE PROCEDURE h-bodi400 NO-ERROR.
            ASSIGN h-bodi400 = ?.
        END.
    
        RETURN "NOK":U.
    END.

    FOR EACH  b-it-doc-fisico-serial
        WHERE b-it-doc-fisico-serial.cod-ser-docto = it-doc-fisico.serie-docto  AND
              b-it-doc-fisico-serial.cod-docto     = it-doc-fisico.nro-docto    AND
              b-it-doc-fisico-serial.cdn-emitente  = it-doc-fisico.cod-emitente AND
              b-it-doc-fisico-serial.idi-tip-nf    = it-doc-fisico.tipo-nota    AND
              b-it-doc-fisico-serial.num-seq       = it-doc-fisico.sequencia    NO-LOCK,
        FIRST serial-faturam
        WHERE serial-faturam.cod-serial = b-it-doc-fisico-serial.cod-serial NO-LOCK:
        
        ASSIGN d-qtd-total-serial = d-qtd-total-serial + serial-faturam.qtd-item-serial.
    END.
    
    ASSIGN d-qtd-total-serial = d-qtd-total-serial + pQuantidade.

    IF d-qtd-total-serial > it-doc-fisico.quantidade THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="28712"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="''"}
    END.

    IF  l-serial-faturamento AND
        AVAIL it-nota-fisc   THEN DO:
        IF NOT CAN-FIND(FIRST it-nota-fisc-serial
                        WHERE it-nota-fisc-serial.cod-estab       = it-nota-fisc.cod-estabel AND
                              it-nota-fisc-serial.cod-serie       = it-nota-fisc.serie       AND
                              it-nota-fisc-serial.cod-nota-fisc   = it-nota-fisc.nr-nota-fis AND
                              it-nota-fisc-serial.num-seq-item-nf = it-nota-fisc.nr-seq-fat  AND
                              it-nota-fisc-serial.cod-item        = it-nota-fisc.it-codigo   AND
                              it-nota-fisc-serial.cod-serial      = pSerial                  NO-LOCK) THEN DO:

            {method/svc/errors/inserr.i &ErrorNumber="29531"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="STRING(pSerial)"}
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN DO:
        IF VALID-HANDLE(h-bodi400) THEN DO:
            DELETE PROCEDURE h-bodi400 NO-ERROR.
            ASSIGN h-bodi400 = ?.
        END.

        RETURN "NOK":U.
    END.

    transacao:
    DO ON ERROR UNDO transacao, LEAVE transacao:

        RUN goToKey IN h-bodi400 (INPUT  pSerial).

        /*****************************************
        ** Criacao de um Novo Serial            **
        *****************************************/

        IF RETURN-VALUE = "NOK":U THEN DO:

            &IF INTEGER(ENTRY(1,proversion,".")) >= 9 &THEN
                EMPTY TEMP-TABLE tt-serial-faturam.
            &ELSE
                FOR EACH tt-serial-faturam:
                    DELETE tt-serial-faturam.
                END.
            &ENDIF
            
            CREATE tt-serial-faturam.
            ASSIGN tt-serial-faturam.cod-serial        = pSerial
                   tt-serial-faturam.cod-item          = it-doc-fisico.it-codigo
                   tt-serial-faturam.idi-estado-serial = 2 /** Faturado **/
                   tt-serial-faturam.qtd-item-serial   = pQuantidade
                   l-serial-gerado                     = YES.
    
            RUN setRecord      IN h-bodi400 (INPUT TABLE tt-serial-faturam).
            RUN validateRecord IN h-bodi400 (INPUT "Create":U).
    
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN createRecord IN h-bodi400.
            END.
            ELSE DO:
                RUN getRowErrors IN h-bodi400 (OUTPUT TABLE RowErrors APPEND).
            END.
        END.
    
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN
            UNDO transacao, LEAVE transacao.

        /*****************************************
        ** Criacao Item Documento F°sico Serial **
        *****************************************/

        FOR EACH RowErrors:
            CREATE RowErrorsAux.
            BUFFER-COPY RowErrors TO RowErrorsAux.
            DELETE RowErrors.
        END.
    
        CREATE RowObject.
        ASSIGN RowObject.cod-ser-docto = pSerie
               RowObject.cod-docto     = pNrDocto
               RowObject.cdn-emitente  = pEmitente
               RowObject.idi-tip-nf    = pTipoNota
               RowObject.num-seq       = pSequencia
               RowObject.cod-serial    = pSerial.
    
        RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).
    
        IF RETURN-VALUE = "OK":U THEN DO:
            RUN createRecord IN THIS-PROCEDURE.
        END.
    
        FOR EACH RowErrorsAux:
            CREATE RowErrors.
            BUFFER-COPY RowErrorsAux TO RowErrors.
            DELETE RowErrorsAux.
        END.
        
        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN
            UNDO transacao, LEAVE transacao.

        /*****************************************
        ** Atualizacao do Estado do Serial e    **
        ** Criacao de Historico de Movimentacao **
        *****************************************/

        IF l-serial-gerado THEN DO:
            RUN atualizaSerial IN h-bodi400 (INPUT pSerial, /** Codigo do Serial                                  **/
                                             INPUT 2,       /** Estado: 2 - Faturado                              **/
                                             INPUT 7,       /** Historico: Devoluá∆o F°sica - Gerado na Devoluá∆o **/
                                             INPUT "":U).   /** Chave do Documento                                **/
        END.
        ELSE DO:
            RUN atualizaSerial IN h-bodi400 (INPUT pSerial, /** Codigo do Serial                                  **/
                                             INPUT 2,       /** Estado: 2 - Faturado                              **/
                                             INPUT 5,       /** Historico: Devoluá∆o F°sica                       **/
                                             INPUT "SÇrie: "     + STRING(pSerie)    + "; ":U +
                                                   "Docto: "     + STRING(pNrDocto)  + "; ":U +
                                                   "Emitente: "  + STRING(pEmitente) + "; ":U +
                                                   "Tipo Nota: " + STRING(pTipoNota) + "; ":U +
                                                   "Sequància: " + STRING(pSequencia)).
        END.

        RUN getRowErrors IN h-bodi400 (OUTPUT TABLE RowErrors APPEND).

        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN
            UNDO transacao, LEAVE transacao.
    END.
    
    IF VALID-HANDLE(h-bodi400) THEN DO:
        DELETE PROCEDURE h-bodi400 NO-ERROR.
        ASSIGN h-bodi400 = ?.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-LOCK) THEN
        RETURN "NOK":U.

    IF AVAIL it-doc-fisico THEN
        IF d-qtd-total-serial = it-doc-fisico.quantidade THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="28714"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="''"}
        END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemDocFisico DBOProgram 
PROCEDURE openQueryItemDocFisico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY    {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.cod-ser-docto = c-serie-docto  AND
                  {&TableName}.cod-docto     = c-cod-docto    AND
                  {&TableName}.cdn-emitente  = i-cod-emitente AND
                  {&tablename}.idi-tip-nf    = i-tipo-nf      AND
                  {&TableName}.num-seq       = i-sequencia    NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemDocFisico DBOProgram 
PROCEDURE setConstraintItemDocFisico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pSerieDocto  LIKE it-doc-fisico-serial.cod-ser-docto NO-UNDO.
    DEFINE INPUT PARAMETER pCodDocto    LIKE it-doc-fisico-serial.cod-docto     NO-UNDO.
    DEFINE INPUT PARAMETER pCodEmitente LIKE it-doc-fisico-serial.cdn-emitente  NO-UNDO.
    DEFINE INPUT PARAMETER pTipoNF      LIKE it-doc-fisico-serial.idi-tip-nf    NO-UNDO.
    DEFINE INPUT PARAMETER pSequencia   LIKE it-doc-fisico-serial.num-seq       NO-UNDO.
    
    ASSIGN c-serie-docto  = pSerieDocto
           c-cod-docto    = pCodDocto
           i-cod-emitente = pCodEmitente
           i-tipo-nf      = pTipoNF
           i-sequencia    = pSequencia.
    
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

    IF  pType = "Create":U THEN DO:
        IF CAN-FIND (FIRST bf{&TableName}
                     WHERE bf{&TableName}.cod-ser-docto = RowObject.cod-ser-docto AND
                           bf{&TableName}.cod-docto     = RowObject.cod-docto     AND
                           bf{&TableName}.cdn-emitente  = RowObject.cdn-emitente  AND
                           bf{&tablename}.idi-tip-nf    = RowObject.idi-tip-nf    AND
                           bf{&TableName}.num-seq       = RowObject.num-seq       AND
                           bf{&TableName}.cod-serial    = RowObject.cod-serial    NO-LOCK) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-documento-fisico-serial AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Documento_F°sico_Serial" *}
            ASSIGN c-lbl-liter-item-documento-fisico-serial = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="4242"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-item-documento-fisico-serial"}
        END.

        FIND FIRST bf{&TableName}
             WHERE bf{&TableName}.cod-serial = RowObject.cod-serial NO-LOCK NO-ERROR.

        IF AVAIL bf{&TableName} THEN DO:

            FIND FIRST doc-fisico
                 WHERE doc-fisico.serie-docto  = bf{&TableName}.cod-ser-docto AND
                       doc-fisico.nro-docto    = bf{&TableName}.cod-docto     AND
                       doc-fisico.cod-emitente = bf{&TableName}.cdn-emitente  AND
                       doc-fisico.tipo-nota    = bf{&tablename}.idi-tip-nf    AND
                       doc-fisico.situacao     = 1 /** Nao Atualizado **/     NO-LOCK NO-ERROR.

            IF AVAIL doc-fisico THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="29521"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="STRING(RowObject.cod-serial) + '~~~~' + STRING(bf{&TableName}.cod-docto)"}
            END.
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

