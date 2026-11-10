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
{include/i-prgvrs.i BOIN735 2.00.00.004} /*** "010004" 13/11/2023 11:45:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin735 MUT}
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
&GLOBAL-DEFINE DBOName BOIN735
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-doc-est-serial
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
{inbo/boin735.i RowObject}
{dibo/bodi400.i tt-serial-faturam}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName}        FOR {&TableName}.
DEFINE BUFFER b-item-doc-est-serial FOR {&TableName}.

DEFINE VARIABLE c-cod-serie    LIKE item-doc-est-serial.cod-ser-docto    NO-UNDO.
DEFINE VARIABLE c-cod-docto    LIKE item-doc-est-serial.cod-docto        NO-UNDO.
DEFINE VARIABLE i-cod-emitente LIKE item-doc-est-serial.cdn-emitente     NO-UNDO.
DEFINE VARIABLE c-cod-natureza LIKE item-doc-est-serial.cod-natur-operac NO-UNDO.
DEFINE VARIABLE i-sequencia    LIKE item-doc-est-serial.num-seq          NO-UNDO.

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
         HEIGHT             = 10.33
         WIDTH              = 40.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE associaSerialNFaDevolucao DBOProgram 
PROCEDURE associaSerialNFaDevolucao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER prwItNotaFisc AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER prwItemDocEst AS ROWID NO-UNDO.

    FIND FIRST it-nota-fisc
         WHERE ROWID(it-nota-fisc) = prwItNotaFisc NO-LOCK NO-ERROR.

    FIND FIRST item-doc-est
         WHERE ROWID(item-doc-est) = prwItemDocEst NO-LOCK NO-ERROR.

    IF  AVAIL it-nota-fisc AND
        AVAIL item-doc-est THEN DO:

        FOR EACH  it-nota-fisc-serial
            WHERE it-nota-fisc-serial.cod-estab       = it-nota-fisc.cod-estabel AND
                  it-nota-fisc-serial.cod-serie       = it-nota-fisc.serie       AND
                  it-nota-fisc-serial.cod-nota-fisc   = it-nota-fisc.nr-nota-fis AND
                  it-nota-fisc-serial.num-seq-item-nf = it-nota-fisc.nr-seq-fat  AND
                  it-nota-fisc-serial.cod-item        = it-nota-fisc.it-codigo   NO-LOCK:

            IF NOT CAN-FIND(FIRST b-item-doc-est-serial
                            WHERE b-item-doc-est-serial.cod-ser-docto    = item-doc-est.serie-docto       AND
                                  b-item-doc-est-serial.cod-docto        = item-doc-est.nro-docto         AND
                                  b-item-doc-est-serial.cdn-emitente     = item-doc-est.cod-emitente      AND
                                  b-item-doc-est-serial.cod-natur-operac = item-doc-est.nat-operacao      AND
                                  b-item-doc-est-serial.num-seq          = item-doc-est.sequencia         AND
                                  b-item-doc-est-serial.cod-serial       = it-nota-fisc-serial.cod-serial NO-LOCK) THEN DO:

                IF CAN-FIND(FIRST item-dist
                            WHERE item-dist.it-codigo = item-doc-est.it-codigo      AND
                                  item-dist.log-1     = YES /** Controla Serial **/ NO-LOCK) THEN DO:
                    
                    IF CAN-FIND(FIRST serial-faturam
                                WHERE serial-faturam.cod-serial        = it-nota-fisc-serial.cod-serial AND
                                      serial-faturam.idi-estado-serial = 2                              NO-LOCK) THEN DO:

                        CREATE b-item-doc-est-serial.
                        ASSIGN b-item-doc-est-serial.cod-ser-docto    = item-doc-est.serie-docto
                               b-item-doc-est-serial.cod-docto        = item-doc-est.nro-docto
                               b-item-doc-est-serial.cdn-emitente     = item-doc-est.cod-emitente
                               b-item-doc-est-serial.cod-natur-operac = item-doc-est.nat-operacao
                               b-item-doc-est-serial.num-seq          = item-doc-est.sequencia
                               b-item-doc-est-serial.cod-serial       = it-nota-fisc-serial.cod-serial.
                    END.
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaItemRecFiscal DBOProgram 
PROCEDURE atualizaItemRecFiscal :
/*------------------------------------------------------------------------------
  Purpose:     Chama o metodo que atualiza/desatualiza o estado dos seriais, 
               dependendo do p-tipo-trans (1- Atualiza  2- Desatualiza)
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter p-quantidade   as decimal   format ">>>>,>>>,>>9.9999":U no-undo.
    define input parameter p-tipo-trans   as integer                                no-undo.
    define input parameter p-serie-docto  as character format "x(5)":U              no-undo.
    define input parameter p-nro-docto    as character format "x(16)":U             no-undo.
    define input parameter p-cod-emitente as integer   format "999999999":U         no-undo.
    define input parameter p-nat-operacao as character format "x(6)":U              no-undo.
    define input parameter p-sequencia    as integer   format "99999":U             no-undo.

    define variable h-bodi400         as handle                                     no-undo.
    define variable c-chave           as character                                  no-undo.
    define variable de-qtd-serial-seq as decimal   format ">>>>,>>>,>>9.9999":U     no-undo.

    FOR FIRST item-doc-est FIELDS(serie-docto nro-docto cod-emitente nat-operacao sequencia baixa-ce)
        WHERE item-doc-est.serie-docto  = p-serie-docto 
        AND   item-doc-est.nro-docto    = p-nro-docto   
        AND   item-doc-est.cod-emitente = p-cod-emitente
        AND   item-doc-est.nat-operacao = p-nat-operacao
        AND   item-doc-est.sequencia    = p-sequencia  NO-LOCK: END.

    IF NOT AVAIL item-doc-est THEN
        RETURN.

    IF item-doc-est.baixa-ce = NO THEN
        RETURN "OK":U.

    assign c-chave           = " Ser: "  + trim(p-serie-docto)          + " Nr Docto: " + trim(p-nro-docto)
                             + " Emit: " + trim(string(p-cod-emitente)) + " Nat Oper: " + trim(p-nat-operacao)
                             + " Seq: "  + trim(string(p-sequencia))
           de-qtd-serial-seq = 0.

    do trans:

        if  not valid-handle (h-bodi400) then
            run dibo/bodi400.p persistent set h-bodi400.

        for each  item-doc-est-serial fields (cod-serial)
            where item-doc-est-serial.cod-ser-docto    = p-serie-docto 
            and   item-doc-est-serial.cod-docto        = p-nro-docto   
            and   item-doc-est-serial.cdn-emitente     = p-cod-emitente
            and   item-doc-est-serial.cod-natur-operac = p-nat-operacao
            and   item-doc-est-serial.num-seq          = p-sequencia no-lock:
    
            for first serial-faturam fields (qtd-item-serial)
                where serial-faturam.cod-serial = item-doc-est-serial.cod-serial no-lock: end.
            if  avail serial-faturam then
                assign de-qtd-serial-seq = de-qtd-serial-seq + serial-faturam.qtd-item-serial.
    
            run atualizaSerial in h-bodi400 (input item-doc-est-serial.cod-serial,
                                             input p-tipo-trans, /** 1- Atualiza 2- Desatualiza **/
                                             input 3,            /** Devolucao Fiscal   **/
                                             input c-chave).     /** Chave item-doc-est **/
            if  return-value = "NOK":U then
                run getRowErrors in h-bodi400 (output table rowErrors).
        end.
    
        if  p-tipo-trans = 1 /** Atualizacao **/
        and de-qtd-serial-seq <> p-quantidade then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-qtd-item-serial AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Qtd_Item_Serial" *}
            ASSIGN c-lbl-liter-qtd-item-serial = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-qtd-item-na-sequencia AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Qtd_Item_na_sequància" *}
            ASSIGN c-lbl-liter-qtd-item-na-sequencia = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="29523" 
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-qtd-item-serial + '~~~~' + c-lbl-liter-qtd-item-na-sequencia + ' ' + string(p-sequencia)"}
        end.
        
        if  valid-handle (h-bodi400) then do:
            delete procedure h-bodi400.
            assign h-bodi400 = ?.
        end.

        if  can-find(first RowErrors where RowErrors.ErrorSubType = "ERROR":U) then
            undo, return "NOK":U.
    end.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaSerialRecFisicoParaRecFiscal DBOProgram 
PROCEDURE copiaSerialRecFisicoParaRecFiscal :
/*------------------------------------------------------------------------------
  Purpose:     Replica os seriais existentes nos documentos fisicos para
               os documentos fiscais
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter r-docum-est as rowid no-undo.

    find docum-est 
        where rowid(docum-est) = r-docum-est no-lock no-error.
    if  avail docum-est then do:
        for each  it-doc-fisico-serial 
            where it-doc-fisico-serial.cod-ser-docto = docum-est.serie-docto
            and   it-doc-fisico-serial.cod-docto     = docum-est.nro-docto
            and   it-doc-fisico-serial.cdn-emitente  = docum-est.cod-emitente no-lock:
            for first it-doc-fisico fields (it-codigo)
                where it-doc-fisico.serie-docto  = it-doc-fisico-serial.cod-ser-docto
                and   it-doc-fisico.nro-docto    = it-doc-fisico-serial.cod-docto
                and   it-doc-fisico.cod-emitente = it-doc-fisico-serial.cdn-emitente
                and   it-doc-fisico.tipo-nota    = it-doc-fisico-serial.idi-tip-nf no-lock: end.
            if  avail it-doc-fisico then

                for first item-dist fields (log-1)
                    where item-dist.it-codigo = it-doc-fisico.it-codigo no-lock: end.
                if  avail item-dist
                and item-dist.log-1 then

                    if  not can-find (item-doc-est-serial
                                       where item-doc-est-serial.cod-ser-docto    = it-doc-fisico-serial.cod-ser-docto
                                       and   item-doc-est-serial.cod-docto        = it-doc-fisico-serial.cod-docto
                                       and   item-doc-est-serial.cdn-emitente     = it-doc-fisico-serial.cdn-emitente 
                                       and   item-doc-est-serial.cod-natur-operac = docum-est.nat-operacao
                                       and   item-doc-est-serial.cod-serial       = it-doc-fisico-serial.cod-serial
                                       and   item-doc-est-serial.num-seq          = it-doc-fisico-serial.num-seq) then do:
                        create b-item-doc-est-serial.
                        assign b-item-doc-est-serial.cod-ser-docto    = it-doc-fisico-serial.cod-ser-docto
                               b-item-doc-est-serial.cod-docto        = it-doc-fisico-serial.cod-docto
                               b-item-doc-est-serial.cdn-emitente     = it-doc-fisico-serial.cdn-emitente 
                               b-item-doc-est-serial.cod-natur-operac = docum-est.nat-operacao
                               b-item-doc-est-serial.cod-serial       = it-doc-fisico-serial.cod-serial
                               b-item-doc-est-serial.num-seq          = it-doc-fisico-serial.num-seq.
                    end.
        end.
    end.

    return "OK":U.
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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
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
  Purpose:     Retorna valores dos campos do °ndice itmdctsb-id
  Parameters:  
               retorna valor do campo cod-ser-docto
               retorna valor do campo cod-docto
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-natur-operac
               retorna valor do campo num-seq
               retorna valor do campo cod-serial
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-ser-docto LIKE item-doc-est-serial.cod-ser-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto LIKE item-doc-est-serial.cod-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE item-doc-est-serial.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-natur-operac LIKE item-doc-est-serial.cod-natur-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE item-doc-est-serial.num-seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-serial LIKE item-doc-est-serial.cod-serial NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-ser-docto = RowObject.cod-ser-docto
           pcod-docto = RowObject.cod-docto
           pcdn-emitente = RowObject.cdn-emitente
           pcod-natur-operac = RowObject.cod-natur-operac
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

    DEFINE INPUT  PARAMETER prwItemDocEst    AS ROWID                         NO-UNDO.
    DEFINE OUTPUT PARAMETER pQtdSeriaisLidos AS DECIMAL FORMAT ">>>>>>9.9999" NO-UNDO.

    ASSIGN pQtdSeriaisLidos = 0.

    FIND FIRST item-doc-est
         WHERE ROWID(item-doc-est) = prwItemDocEst NO-LOCK NO-ERROR.

    IF AVAIL item-doc-est THEN DO:

        FOR EACH  b-item-doc-est-serial
            WHERE b-item-doc-est-serial.cod-ser-docto    = item-doc-est.serie-docto  AND
                  b-item-doc-est-serial.cod-docto        = item-doc-est.nro-docto    AND
                  b-item-doc-est-serial.cdn-emitente     = item-doc-est.cod-emitente AND
                  b-item-doc-est-serial.cod-natur-operac = item-doc-est.nat-operacao AND
                  b-item-doc-est-serial.num-seq          = item-doc-est.sequencia    NO-LOCK,
            FIRST serial-faturam
            WHERE serial-faturam.cod-serial = b-item-doc-est-serial.cod-serial NO-LOCK:

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
  Purpose:     Reposiciona registro com base no °ndice itmdctsb-id
  Parameters:  
               recebe valor do campo cod-ser-docto
               recebe valor do campo cod-docto
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-natur-operac
               recebe valor do campo num-seq
               recebe valor do campo cod-serial
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ser-docto LIKE item-doc-est-serial.cod-ser-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto LIKE item-doc-est-serial.cod-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emitente LIKE item-doc-est-serial.cdn-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac LIKE item-doc-est-serial.cod-natur-operac NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE item-doc-est-serial.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pcod-serial LIKE item-doc-est-serial.cod-serial NO-UNDO.

    FIND FIRST bfitem-doc-est-serial WHERE 
        bfitem-doc-est-serial.cod-ser-docto = pcod-ser-docto AND 
        bfitem-doc-est-serial.cod-docto = pcod-docto AND 
        bfitem-doc-est-serial.cdn-emitente = pcdn-emitente AND 
        bfitem-doc-est-serial.cod-natur-operac = pcod-natur-operac AND 
        bfitem-doc-est-serial.num-seq = pnum-seq AND 
        bfitem-doc-est-serial.cod-serial = pcod-serial NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-doc-est-serial THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-doc-est-serial)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inclusaoItemDocEstSerial DBOProgram 
PROCEDURE inclusaoItemDocEstSerial :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pSerie      LIKE item-doc-est.serie-docto       NO-UNDO.
    DEFINE INPUT PARAMETER pNrDocto    LIKE item-doc-est.nro-docto         NO-UNDO.
    DEFINE INPUT PARAMETER pEmitente   LIKE item-doc-est.cod-emitente      NO-UNDO.
    DEFINE INPUT PARAMETER pNatureza   LIKE item-doc-est.nat-operacao      NO-UNDO.
    DEFINE INPUT PARAMETER pSequencia  LIKE item-doc-est.sequencia         NO-UNDO.
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

    FIND FIRST docum-est
         WHERE docum-est.serie-docto  = pSerie    AND
               docum-est.nro-docto    = pNrDocto  AND
               docum-est.cod-emitente = pEmitente AND
               docum-est.nat-operacao = pNatureza NO-LOCK NO-ERROR.

    IF NOT AVAIL docum-est THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-documento-do-recebimento-fisca AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Documento_do_Recebimento_Fiscal" *}
        ASSIGN c-lbl-liter-documento-do-recebimento-fisca = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="56"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-liter-documento-do-recebimento-fisca"}
    END.
    ELSE DO:
        /***********************************
        ** Situacao = NO (N∆o Atualizado) **
        ***********************************/
        IF docum-est.ce-atual THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="7183"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="''"}
        END.

        FIND FIRST item-doc-est
             WHERE item-doc-est.serie-docto  = docum-est.serie-docto  AND
                   item-doc-est.nro-docto    = docum-est.nro-docto    AND
                   item-doc-est.cod-emitente = docum-est.cod-emitente AND
                   item-doc-est.nat-operacao = docum-est.nat-operacao AND
                   item-doc-est.sequencia    = pSequencia             NO-LOCK NO-ERROR.

        IF NOT AVAIL item-doc-est THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-do-recebimento-fiscal AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_do_Recebimento_Fiscal" *}
            ASSIGN c-lbl-liter-item-do-recebimento-fiscal = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="56"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-item-do-recebimento-fiscal"}
        END.
        ELSE DO:
            FIND FIRST item-dist
                 WHERE item-dist.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.

            IF NOT AVAIL item-dist THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="56"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-item + ' ' + STRING(item-doc-est.it-codigo)"}
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
         WHERE it-nota-fisc.cod-estabel = docum-est.cod-estabel   AND
               it-nota-fisc.nr-nota-fis = item-doc-est.nro-comp   AND
               it-nota-fisc.serie       = item-doc-est.serie-comp AND
               it-nota-fisc.nr-seq-fat  = item-doc-est.seq-comp   AND
               it-nota-fisc.it-codigo   = item-doc-est.it-codigo  NO-LOCK NO-ERROR.

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
        IF c-cod-item-serial <> item-doc-est.it-codigo THEN DO:
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
                                              INPUT docum-est.cod-estabel,
                                              INPUT ROWID(item-doc-est) ).
                  
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

    FOR EACH  b-item-doc-est-serial
        WHERE b-item-doc-est-serial.cod-ser-docto    = item-doc-est.serie-docto  AND
              b-item-doc-est-serial.cod-docto        = item-doc-est.nro-docto    AND
              b-item-doc-est-serial.cdn-emitente     = item-doc-est.cod-emitente AND
              b-item-doc-est-serial.cod-natur-operac = item-doc-est.nat-operacao AND
              b-item-doc-est-serial.num-seq          = item-doc-est.sequencia    NO-LOCK,
        FIRST serial-faturam
        WHERE serial-faturam.cod-serial = b-item-doc-est-serial.cod-serial NO-LOCK:

        ASSIGN d-qtd-total-serial = d-qtd-total-serial + serial-faturam.qtd-item-serial.
    END.
    
    ASSIGN d-qtd-total-serial = d-qtd-total-serial + pQuantidade.

    IF d-qtd-total-serial > item-doc-est.quantidade THEN DO:
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
                   tt-serial-faturam.cod-item          = item-doc-est.it-codigo
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
        ** Criacao Item Documento Fiscal Serial **
        *****************************************/

        FOR EACH RowErrors:
            CREATE RowErrorsAux.
            BUFFER-COPY RowErrors TO RowErrorsAux.
            DELETE RowErrors.
        END.
    
        CREATE RowObject.
        ASSIGN RowObject.cod-ser-docto    = pSerie
               RowObject.cod-docto        = pNrDocto
               RowObject.cdn-emitente     = pEmitente
               RowObject.cod-natur-operac = pNatureza
               RowObject.num-seq          = pSequencia
               RowObject.cod-serial       = pSerial.
    
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
                                             INPUT 6,       /** Historico: Devoluá∆o Fiscal - Gerado na Devoluá∆o **/
                                             INPUT "":U).   /** Chave do Documento                                **/
        END.
        ELSE DO:
            RUN atualizaSerial IN h-bodi400 (INPUT pSerial, /** Codigo do Serial                                  **/
                                             INPUT 2,       /** Estado: 2 - Faturado                              **/
                                             INPUT 3,       /** Historico: Devoluá∆o Fiscal                       **/
                                             INPUT "SÇrie: "     + STRING(pSerie)    + "; ":U +
                                                   "Docto: "     + STRING(pNrDocto)  + "; ":U +
                                                   "Emitente: "  + STRING(pEmitente) + "; ":U +
                                                   "Natureza: "  + STRING(pNatureza) + "; ":U +
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

    IF AVAIL item-doc-est THEN
        IF d-qtd-total-serial = item-doc-est.quantidade THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="28714"
                                        &ErrorType="EMS"
                                        &ErrorSubType="WARNING"
                                        &ErrorParameters="''"}
        END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItemDocEst DBOProgram 
PROCEDURE linkToItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER phParent AS HANDLE NO-UNDO.

    RUN getKey IN phParent (OUTPUT i-cod-emitente,
                            OUTPUT c-cod-serie,
                            OUTPUT c-cod-docto,
                            OUTPUT c-cod-natureza,
                            OUTPUT i-sequencia).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemDocEst DBOProgram 
PROCEDURE openQueryItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY    {&QueryName}
        FOR EACH  {&TableName}
            WHERE {&TableName}.cod-ser-docto    = c-cod-serie    AND
                  {&TableName}.cod-docto        = c-cod-docto    AND
                  {&TableName}.cdn-emitente     = i-cod-emitente AND
                  {&TableName}.cod-natur-operac = c-cod-natureza AND
                  {&TableName}.num-seq          = i-sequencia    NO-LOCK INDEXED-REPOSITION.

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
                     WHERE bf{&TableName}.cod-ser-docto    = RowObject.cod-ser-docto    AND
                           bf{&TableName}.cod-docto        = RowObject.cod-docto        AND
                           bf{&TableName}.cdn-emitente     = RowObject.cdn-emitente     AND
                           bf{&TableName}.cod-natur-operac = RowObject.cod-natur-operac AND
                           bf{&TableName}.num-seq          = RowObject.num-seq          AND
                           bf{&TableName}.cod-serial       = RowObject.cod-serial       NO-LOCK) THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item-documento-fiscal-serial AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item_Documento_Fiscal_Serial" *}
            ASSIGN c-lbl-liter-item-documento-fiscal-serial = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="4242"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-liter-item-documento-fiscal-serial"}
        END.

        FIND FIRST bf{&TableName}
             WHERE bf{&TableName}.cod-serial = RowObject.cod-serial NO-LOCK NO-ERROR.

        IF AVAIL bf{&TableName} THEN DO:

            FIND FIRST docum-est
                 WHERE docum-est.serie-docto  = bf{&TableName}.cod-ser-docto    AND
                       docum-est.nro-docto    = bf{&TableName}.cod-docto        AND
                       docum-est.cod-emitente = bf{&TableName}.cdn-emitente     AND
                       docum-est.nat-operacao = bf{&TableName}.cod-natur-operac AND
                       docum-est.ce-atual     = NO /** Docto Nao Atualizado **/ NO-LOCK NO-ERROR.

            IF AVAIL docum-est THEN DO:
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

