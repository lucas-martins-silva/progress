/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX185Q01 2.00.00.002 } /*** "010002" 11/12/2023 10:13:23 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx185q01 MUT}
&ENDIF

/*
**  BOCX185.P
**
**  PROCESSO-EXP    -  Processo Exporta‡Æo
**
********************************************************************************/

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOCX185Q01
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName tt-processo-exp
&GLOBAL-DEFINE TableLabel tt-processo-exp
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

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0
&GLOBAL-DEFINE EXCLUDE-getBatchRecords 0

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{cxbo/bocx185q01.i tt-processo-exp}
{cxbo/bocx185q01.i RowObject}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
/*DEFINE BUFFER bf{&TableName} FOR {&TableName}.*/

DEFINE VARIABLE i-cod-emitente-ini   LIKE processo-exp.cod-emitente             INITIAL 0               NO-UNDO.
DEFINE VARIABLE i-cod-emitente-fim   LIKE processo-exp.cod-emitente             INITIAL 999999999       NO-UNDO.
DEFINE VARIABLE c-nome-abrev-ini     LIKE emitente.nome-abrev                   INITIAL ""              NO-UNDO.
DEFINE VARIABLE c-nome-abrev-fim     LIKE emitente.nome-abrev                   INITIAL "ZZZZZZZZZZZZ"  NO-UNDO.
DEFINE VARIABLE d-dt-data-impl-ini   LIKE processo-exp.dat-impl-proces-export   INITIAL 01/01/1900      NO-UNDO.
DEFINE VARIABLE d-dt-data-impl-fim   LIKE processo-exp.dat-impl-proces-export   INITIAL 12/31/9999      NO-UNDO.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN rowObject.r-rowid = tt-processo-exp.r-rowid.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.
    
    ASSIGN pRowid = tt-processo-exp.r-rowid.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforerepositionrecord DBOProgram 
PROCEDURE beforerepositionrecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    find {&TableName} where {&TableName}.r-rowid = pRowid no-lock no-error.

    if avail {&TableName} then 
       assign pRowid = rowid({&TableName}).

    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: NÊo foi possðvel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.
    
    /*--- Ô necess˜rio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.

    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}" = "ORACLE":U &THEN
        ASSIGN lRepositioned = YES.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecords DBOProgram 
PROCEDURE getBatchRecords :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atravýs da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execu¯Êo de novo GET NEXT
               recebe nßmero de linhas a serem retornadas
               retorna nßmero de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pRowid        AS ROWID   NO-UNDO.
    DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.
    
    &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
        DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
    &ENDIF
    
    /*--- Verifica permissÊo de execu¯Êo ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.

    IF pRowid <> ? THEN DO:
        /* customiza»’o */
        
        for first tt-processo-exp fields(nr-proc-exp cod-estabel)
             WHERE tt-processo-exp.r-rowid = pRowid.
        end.
        if avail tt-processo-exp then 
            ASSIGN pRowid = rowid(tt-processo-exp).
 
        REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}" = "YES" &THEN
                GET FIRST {&QueryName} NO-LOCK.
                ASSIGN pRowid = rowid({&TableName}).
                REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                IF ERROR-STATUS:ERROR THEN do:
                    RETURN "NOK":U.
                end.
            &ELSE
                RETURN "NOK":U.
            &ENDIF
        END.
        
        GET NEXT {&QueryName} NO-LOCK.
        
        /*--- Este teste torna-se necess˜rio devido ao fato de realizar-se um 
              reposicionamento de um registro recým eliminado. Neste caso nÊo ý 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY ý processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
        GET NEXT {&QueryName} NO-LOCK.
    END.
    
    /*--- Grava temptable RowObjectAux ---*/
    DO WHILE AVAILABLE({&TableName}):
        IF pRowsToReturn <> 0 AND pRowsReturned >= pRowsToReturn THEN
            LEAVE.

        /*--- Atualiza temptable RowObject ---*/
        RUN _copyBuffer2TT IN THIS-PROCEDURE.

        &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
            ASSIGN iNextSeq = iNextSeq + 1
                   RowObject.RowNum = iNextSeq.
        &ENDIF
        
        /*--- Executa mýtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        IF NOT CAN-FIND(FIRST RowObjectAux
                            WHERE RowObjectAux.cod-estabel = RowObject.cod-estabel
                            AND   RowObjectAux.nr-proc-exp = RowObject.nr-proc-exp) THEN DO:
            CREATE RowObjectAux.
            BUFFER-COPY RowObject TO RowObjectAux.
            ASSIGN pRowsReturned = pRowsReturned + 1.
        END.
        
        /*--- Executa mýtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        GET NEXT {&QueryName}.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "bairro":U THEN ASSIGN pFieldValue = RowObject.bairro.
        WHEN "bairro-consign":U THEN ASSIGN pFieldValue = RowObject.bairro-consign.
        WHEN "bairro-estab":U THEN ASSIGN pFieldValue = RowObject.bairro-estab.
        WHEN "bairro-notif":U THEN ASSIGN pFieldValue = RowObject.bairro-notif.
        WHEN "bairro-notif2":U THEN ASSIGN pFieldValue = RowObject.bairro-notif2.
        WHEN "bairro-transp":U THEN ASSIGN pFieldValue = RowObject.bairro-transp.
        WHEN "carta-credito":U THEN ASSIGN pFieldValue = RowObject.carta-credito.
        WHEN "cep":U THEN ASSIGN pFieldValue = RowObject.cep.
        WHEN "cep-consign":U THEN ASSIGN pFieldValue = RowObject.cep-consign.
        WHEN "cep-notif":U THEN ASSIGN pFieldValue = RowObject.cep-notif.
        WHEN "cep-notif2":U THEN ASSIGN pFieldValue = RowObject.cep-notif2.
        WHEN "cep-transp":U THEN ASSIGN pFieldValue = RowObject.cep-transp.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cidade":U THEN ASSIGN pFieldValue = RowObject.cidade.
        WHEN "cidade-consign":U THEN ASSIGN pFieldValue = RowObject.cidade-consign.
        WHEN "cidade-estab":U THEN ASSIGN pFieldValue = RowObject.cidade-estab.
        WHEN "cidade-notif":U THEN ASSIGN pFieldValue = RowObject.cidade-notif.
        WHEN "cidade-notif2":U THEN ASSIGN pFieldValue = RowObject.cidade-notif2.
        WHEN "cidade-transp":U THEN ASSIGN pFieldValue = RowObject.cidade-transp.
        WHEN "cod-agenc-carta-cr":U THEN ASSIGN pFieldValue = RowObject.cod-agenc-carta-cr.
        WHEN "cod-agenc-cobr":U THEN ASSIGN pFieldValue = RowObject.cod-agenc-cobr.
        WHEN "cod-agenc-entreg-docto":U THEN ASSIGN pFieldValue = RowObject.cod-agenc-entreg-docto.
        WHEN "cod-cep-emit-final":U THEN ASSIGN pFieldValue = RowObject.cod-cep-emit-final.
        WHEN "cod-courier-cobr":U THEN ASSIGN pFieldValue = RowObject.cod-courier-cobr.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-estado-emit-final":U THEN ASSIGN pFieldValue = RowObject.cod-estado-emit-final.
        WHEN "cod-idioma":U THEN ASSIGN pFieldValue = RowObject.cod-idioma.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "cod-pais-emit-final":U THEN ASSIGN pFieldValue = RowObject.cod-pais-emit-final.
        WHEN "cod-pais-final":U THEN ASSIGN pFieldValue = RowObject.cod-pais-final.
        WHEN "cod-refer-bcia":U THEN ASSIGN pFieldValue = RowObject.cod-refer-bcia.
        WHEN "des-end-emit-final":U THEN ASSIGN pFieldValue = RowObject.des-end-emit-final.
        WHEN "desc-vl-liq":U THEN ASSIGN pFieldValue = RowObject.desc-vl-liq.
        WHEN "end-consign":U THEN ASSIGN pFieldValue = RowObject.end-consign.
        WHEN "end-notif":U THEN ASSIGN pFieldValue = RowObject.end-notif.
        WHEN "end-notif2":U THEN ASSIGN pFieldValue = RowObject.end-notif2.
        WHEN "end-transp":U THEN ASSIGN pFieldValue = RowObject.end-transp.
        WHEN "endereco":U THEN ASSIGN pFieldValue = RowObject.endereco.
        WHEN "endereco-estab":U THEN ASSIGN pFieldValue = RowObject.endereco-estab.
        WHEN "endereco_text":U THEN ASSIGN pFieldValue = RowObject.endereco_text.
        WHEN "endereco_text_consign":U THEN ASSIGN pFieldValue = RowObject.endereco_text_consign.
        WHEN "endereco_text_estab":U THEN ASSIGN pFieldValue = RowObject.endereco_text_estab.
        WHEN "endereco_text_notif1":U THEN ASSIGN pFieldValue = RowObject.endereco_text_notif1.
        WHEN "endereco_text_notif2":U THEN ASSIGN pFieldValue = RowObject.endereco_text_notif2.
        WHEN "estab-fisc":U THEN ASSIGN pFieldValue = RowObject.estab-fisc.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "estado-consign":U THEN ASSIGN pFieldValue = RowObject.estado-consign.
        WHEN "estado-estab":U THEN ASSIGN pFieldValue = RowObject.estado-estab.
        WHEN "estado-notif":U THEN ASSIGN pFieldValue = RowObject.estado-notif.
        WHEN "estado-notif2":U THEN ASSIGN pFieldValue = RowObject.estado-notif2.
        WHEN "estado-transp":U THEN ASSIGN pFieldValue = RowObject.estado-transp.
        WHEN "form-envio-docs":U THEN ASSIGN pFieldValue = RowObject.form-envio-docs.
        WHEN "hra-deadline":U THEN ASSIGN pFieldValue = RowObject.hra-deadline.
        WHEN "inf-adicionais":U THEN ASSIGN pFieldValue = RowObject.inf-adicionais.
        WHEN "instr-despachante":U THEN ASSIGN pFieldValue = RowObject.instr-despachante.
        WHEN "marca-1":U THEN ASSIGN pFieldValue = RowObject.marca-1.
        WHEN "marca-2":U THEN ASSIGN pFieldValue = RowObject.marca-2.
        WHEN "marca-3":U THEN ASSIGN pFieldValue = RowObject.marca-3.
        WHEN "marca-4":U THEN ASSIGN pFieldValue = RowObject.marca-4.
        WHEN "marca-5":U THEN ASSIGN pFieldValue = RowObject.marca-5.
        WHEN "motivo-cancela":U THEN ASSIGN pFieldValue = RowObject.motivo-cancela.
        WHEN "nom-bairro-emit-final":U THEN ASSIGN pFieldValue = RowObject.nom-bairro-emit-final.
        WHEN "nom-cidad-emit-final":U THEN ASSIGN pFieldValue = RowObject.nom-cidad-emit-final.
        WHEN "nom-emit-final":U THEN ASSIGN pFieldValue = RowObject.nom-emit-final.
        WHEN "nome-completo":U THEN ASSIGN pFieldValue = RowObject.nome-completo.
        WHEN "nome-consign":U THEN ASSIGN pFieldValue = RowObject.nome-consign.
        WHEN "nome-estab":U THEN ASSIGN pFieldValue = RowObject.nome-estab.
        WHEN "nome-notif":U THEN ASSIGN pFieldValue = RowObject.nome-notif.
        WHEN "nome-notif2":U THEN ASSIGN pFieldValue = RowObject.nome-notif2.
        WHEN "nome-transp":U THEN ASSIGN pFieldValue = RowObject.nome-transp.
        WHEN "nr-apolice":U THEN ASSIGN pFieldValue = RowObject.nr-apolice.
        WHEN "nr-averbacao":U THEN ASSIGN pFieldValue = RowObject.nr-averbacao.
        WHEN "nr-cert-seguro":U THEN ASSIGN pFieldValue = RowObject.nr-cert-seguro.
        WHEN "nr-conhec-master":U THEN ASSIGN pFieldValue = RowObject.nr-conhec-master.
        WHEN "nr-conhecimento":U THEN ASSIGN pFieldValue = RowObject.nr-conhecimento.
        WHEN "nr-courier":U THEN ASSIGN pFieldValue = RowObject.nr-courier.
        WHEN "nr-form-a":U THEN ASSIGN pFieldValue = RowObject.nr-form-a.
        WHEN "nr-invoice":U THEN ASSIGN pFieldValue = RowObject.nr-invoice.
        WHEN "nr-packing":U THEN ASSIGN pFieldValue = RowObject.nr-packing.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "nr-saque":U THEN ASSIGN pFieldValue = RowObject.nr-saque.
        WHEN "pais":U THEN ASSIGN pFieldValue = RowObject.pais.
        WHEN "pais-consign":U THEN ASSIGN pFieldValue = RowObject.pais-consign.
        WHEN "pais-estab":U THEN ASSIGN pFieldValue = RowObject.pais-estab.
        WHEN "pais-notif":U THEN ASSIGN pFieldValue = RowObject.pais-notif.
        WHEN "pais-notif2":U THEN ASSIGN pFieldValue = RowObject.pais-notif2.
        WHEN "pais-transp":U THEN ASSIGN pFieldValue = RowObject.pais-transp.
        WHEN "texto-declaracoes":U THEN ASSIGN pFieldValue = RowObject.texto-declaracoes.
        WHEN "veic-transp":U THEN ASSIGN pFieldValue = RowObject.veic-transp.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dat-deadline":U THEN ASSIGN pFieldValue = RowObject.dat-deadline.
        WHEN "dat-entreg-docto":U THEN ASSIGN pFieldValue = RowObject.dat-entreg-docto.
        WHEN "dat-impl-proces-export":U THEN ASSIGN pFieldValue = RowObject.dat-impl-proces-export.
        WHEN "dat-remes":U THEN ASSIGN pFieldValue = RowObject.dat-remes.
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-aceita-prof":U THEN ASSIGN pFieldValue = RowObject.dt-aceita-prof.
        WHEN "dt-cancela":U THEN ASSIGN pFieldValue = RowObject.dt-cancela.
        WHEN "dt-cert-seguro":U THEN ASSIGN pFieldValue = RowObject.dt-cert-seguro.
        WHEN "dt-conhecimento":U THEN ASSIGN pFieldValue = RowObject.dt-conhecimento.
        WHEN "dt-courier":U THEN ASSIGN pFieldValue = RowObject.dt-courier.
        WHEN "dt-cruze":U THEN ASSIGN pFieldValue = RowObject.dt-cruze.
        WHEN "dt-embarque":U THEN ASSIGN pFieldValue = RowObject.dt-embarque.
        WHEN "dt-form-a":U THEN ASSIGN pFieldValue = RowObject.dt-form-a.
        WHEN "dt-invoice":U THEN ASSIGN pFieldValue = RowObject.dt-invoice.
        WHEN "dt-prev-embarque":U THEN ASSIGN pFieldValue = RowObject.dt-prev-embarque.
        WHEN "dt-prev-ex-factory":U THEN ASSIGN pFieldValue = RowObject.dt-prev-ex-factory.
        WHEN "dt-saque":U THEN ASSIGN pFieldValue = RowObject.dt-saque.
        WHEN "dt-val-prof":U THEN ASSIGN pFieldValue = RowObject.dt-val-prof.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "volume":U THEN ASSIGN pFieldValue = RowObject.volume.
        WHEN "volume-inf":U THEN ASSIGN pFieldValue = RowObject.volume-inf.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cdn-bco-carta-cr":U THEN ASSIGN pFieldValue = RowObject.cdn-bco-carta-cr.
        WHEN "cdn-bco-cobr":U THEN ASSIGN pFieldValue = RowObject.cdn-bco-cobr.
        WHEN "cdn-bco-entreg-docto":U THEN ASSIGN pFieldValue = RowObject.cdn-bco-entreg-docto.
        WHEN "cdn-emit-final":U THEN ASSIGN pFieldValue = RowObject.cdn-emit-final.
        WHEN "cdn-pto-transb[1]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[1].
        WHEN "cdn-pto-transb[2]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[2].
        WHEN "cdn-pto-transb[3]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[3].
        WHEN "cdn-pto-transb[4]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[4].
        WHEN "cdn-pto-transb[5]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[5].
        WHEN "cdn-pto-transb[6]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[6].
        WHEN "cdn-pto-transb[7]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[7].
        WHEN "cdn-pto-transb[8]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[8].
        WHEN "cdn-pto-transb[9]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[9].
        WHEN "cdn-pto-transb[10]":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-transb[10].
        WHEN "cep-estab":U THEN ASSIGN pFieldValue = RowObject.cep-estab.
        WHEN "cod-agente-cia":U THEN ASSIGN pFieldValue = RowObject.cod-agente-cia.
        WHEN "cod-armador":U THEN ASSIGN pFieldValue = RowObject.cod-armador.
        WHEN "cod-cond-pagto":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pagto.
        WHEN "cod-consign":U THEN ASSIGN pFieldValue = RowObject.cod-consign.
        WHEN "cod-decl-cliente":U THEN ASSIGN pFieldValue = RowObject.cod-decl-cliente.
        WHEN "cod-decl-conhec":U THEN ASSIGN pFieldValue = RowObject.cod-decl-conhec.
        WHEN "cod-decl-padrao":U THEN ASSIGN pFieldValue = RowObject.cod-decl-padrao.
        WHEN "cod-decl-pais":U THEN ASSIGN pFieldValue = RowObject.cod-decl-pais.
        WHEN "cod-despachante":U THEN ASSIGN pFieldValue = RowObject.cod-despachante.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-fabric":U THEN ASSIGN pFieldValue = RowObject.cod-fabric.
        WHEN "cod-itiner":U THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        WHEN "cod-notif":U THEN ASSIGN pFieldValue = RowObject.cod-notif.
        WHEN "cod-notif2":U THEN ASSIGN pFieldValue = RowObject.cod-notif2.
        WHEN "cod-origem-proc":U THEN ASSIGN pFieldValue = RowObject.cod-origem-proc.
        WHEN "cod-pais":U THEN ASSIGN pFieldValue = RowObject.cod-pais.
        WHEN "cod-pto-inicio-pagto":U THEN ASSIGN pFieldValue = RowObject.cod-pto-inicio-pagto.
        WHEN "cod-seguradora":U THEN ASSIGN pFieldValue = RowObject.cod-seguradora.
        WHEN "cod-sit-proc":U THEN ASSIGN pFieldValue = RowObject.cod-sit-proc.
        WHEN "cod-transp-int":U THEN ASSIGN pFieldValue = RowObject.cod-transp-int.
        WHEN "cod-via-transp":U THEN ASSIGN pFieldValue = RowObject.cod-via-transp.
        WHEN "idi-tip-frete-export":U THEN ASSIGN pFieldValue = RowObject.idi-tip-frete-export.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-containers":U THEN ASSIGN pFieldValue = RowObject.nr-containers.
        WHEN "pto-chegada":U THEN ASSIGN pFieldValue = RowObject.pto-chegada.
        WHEN "pto-desembarque":U THEN ASSIGN pFieldValue = RowObject.pto-desembarque.
        WHEN "pto-despacho":U THEN ASSIGN pFieldValue = RowObject.pto-despacho.
        WHEN "pto-embarque":U THEN ASSIGN pFieldValue = RowObject.pto-embarque.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice pk-proc-exp
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp.

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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "completo":U THEN ASSIGN pFieldValue = RowObject.completo.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-atualiz-apb":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-apb.
        WHEN "log-atualiz-ce":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-ce.
        WHEN "log-atualiz-crb":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-crb.
        WHEN "log-atualiz-ctb":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-ctb.
        WHEN "log-nf-atlzdo":U THEN ASSIGN pFieldValue = RowObject.log-nf-atlzdo.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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
  Purpose:     Reposiciona registro com base no ¡ndice pk-proc-exp
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
  Notes:       
------------------------------------------------------------------------------*/
    /*DEFINE INPUT PARAMETER pcod-estabel LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.

    FIND FIRST bftt-processo-exp WHERE 
        bftt-processo-exp.cod-estabel = pcod-estabel AND 
        bftt-processo-exp.nr-proc-exp = pnr-proc-exp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-processo-exp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-processo-exp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER i-abertura AS INTEGER NO-UNDO.
    
    CASE i-abertura:
        WHEN 8 THEN DO:
            RUN openQueryEmitente IN THIS-PROCEDURE.
        END.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEmitente DBOProgram 
PROCEDURE openQueryEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName}
        FOR EACH tt-processo-exp NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
        FOR EACH tt-processo-exp NO-LOCK 
        INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-tt DBOProgram 
PROCEDURE pi-carrega-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-processo-exp.

    FOR EACH processo-exp NO-LOCK 
       WHERE processo-exp.cod-emitente >= i-cod-emitente-ini
         AND processo-exp.cod-emitente <= i-cod-emitente-fim
         AND processo-exp.dat-impl-proces-export >= d-dt-data-impl-ini  
         AND processo-exp.dat-impl-proces-export <= d-dt-data-impl-fim:

        IF NOT CAN-FIND(FIRST emitente WHERE emitente.cod-emitente = processo-exp.cod-emitente
                                         AND emitente.nome-abrev >= c-nome-abrev-ini
                                         AND emitente.nome-abrev <= c-nome-abrev-fim) THEN NEXT.

        IF NOT CAN-FIND(FIRST tt-processo-exp NO-LOCK
                        WHERE tt-processo-exp.cod-estabel = processo-exp.cod-estabel
                          AND tt-processo-exp.nr-proc-exp = processo-exp.nr-proc-exp) THEN DO:                     
            CREATE tt-processo-exp.
            BUFFER-COPY processo-exp TO tt-processo-exp.
            ASSIGN tt-processo-exp.r-rowid = ROWID(processo-exp).
        END.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintEmitente DBOProgram 
PROCEDURE setConstraintEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-emitente-ini  LIKE processo-exp.cod-emitente            NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente-fim  LIKE processo-exp.cod-emitente            NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-abrev-ini    LIKE emitente.nome-abrev                  NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-abrev-fim    LIKE emitente.nome-abrev                  NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-data-impl-ini  LIKE processo-exp.dat-impl-proces-export  NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-data-impl-fim  LIKE processo-exp.dat-impl-proces-export  NO-UNDO.

    ASSIGN  i-cod-emitente-ini = p-cod-emitente-ini 
            i-cod-emitente-fim = p-cod-emitente-fim
            c-nome-abrev-ini   = p-nome-abrev-ini
            c-nome-abrev-fim   = p-nome-abrev-fim
            d-dt-data-impl-ini = p-dt-data-impl-ini
            d-dt-data-impl-fim = p-dt-data-impl-fim.

    RUN pi-carrega-tt IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

