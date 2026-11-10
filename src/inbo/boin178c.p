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
{include/i-prgvrs.i BOIN178C 2.00.00.002} /*** "010002" 23/11/2023 16:19:43  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN178C MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN178
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-fornec
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

DEFINE QUERY {&QUERYNAME} for {&TABLENAME}, item scrolling.

&IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
   &GLOBAL-DEFINE v9indrep  INDEXED-REPOSITION
&endif


/* DBO-XML-BEGIN */
/* Pre-processadores para ativar XML no DBO */
/* Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /* DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /* Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /* Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /* Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /* Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /* Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /* Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /* DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /* Nome da Query que d† acessos a todos os registros, exceto os exclu°dos pela constraint de seguranáa. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /* Informar os campos da chave quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin178.i RowObject}


/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
/*{method/dboqry.i}*/

/*Vari†veis SetConstraintZoomItem*/
def var i-op-radio   as integer no-undo.
def var i-fornec     as integer no-undo.
def var c-codigo-ini as char    no-undo. 
def var c-codigo-fim as char    no-undo.   

DEF VAR c-it-fornec-ini   AS CHAR NO-UNDO.
DEF VAR c-it-fornec-fim   AS CHAR NO-UNDO.
DEF VAR i-fornec-ini      AS INT  NO-UNDO.
DEF VAR i-fornec-fim      AS INT  NO-UNDO.
DEF VAR c-nome-abrev-ini  AS CHAR NO-UNDO.
DEF VAR c-nome-abrev-fim  AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tt-emitente NO-UNDO
    FIELD r-rowid      AS ROWID
    FIELD nome-abrev   LIKE emitente.nome-abrev
    FIELD cod-emitente LIKE emitente.cod-emitente
    FIELD nome-emit    LIKE emitente.nome-emit.

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetBatchRecordsCustom DBOProgram 
PROCEDURE GetBatchRecordsCustom :
/*------------------------------------------------------------------------------
  Purpose:     Retorna faixa de registros da query atravÇs da 
               temptable RowObjectAux 
  Parameters:  recebe rowid inicial
               recebe flag indicando a execuá∆o de novo GET NEXT
               recebe n£mero de linhas a serem retornadas
               retorna n£mero de linhas retornadas
               retorna temptable RowObjectAux
  Notes: 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pItCodigo     AS CHAR FORMAT "x(16)" NO-UNDO.
DEFINE INPUT  PARAMETER pCodEmitente  AS INTEGER FORMAT ">>>>>>>>9" NO-UNDO.
DEFINE INPUT  PARAMETER pNext         AS LOGICAL NO-UNDO.
DEFINE INPUT  PARAMETER pRowsToReturn AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pRowsReturned AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR RowObjectAux.

DEFINE BUFFER bfRowObjectAux FOR RowObjectAux.
DEFINE VAR pRowid        AS ROWID   NO-UNDO.

 IF pItCodigo = ? OR pCodEmitente = ? THEN DO:
    GET FIRST {&QueryName} NO-LOCK.
    ASSIGN pRowid = ROWID({&TableName}).
 END.
 ELSE DO:
    FIND item-fornec
       WHERE item-fornec.it-codigo    = pItCodigo 
       AND   item-fornec.cod-emitente = pCodEmitente 
       NO-LOCK NO-ERROR.
    IF AVAIL item-fornec THEN
        ASSIGN pRowid = ROWID(item-fornec).
 END.

 &IF "{&ROW-NUM-DEFINED}" = "YES" &THEN
    DEFINE VARIABLE iNextSeq AS INTEGER NO-UNDO INIT 0.
 &ENDIF
    
    /*--- Verifica permiss∆o de execuá∆o ---*/
    {method/svc/security/permit.i &Method="Navigation"}
    
    /*--- Limpa temptable RowObjectAux ---*/
    RUN emptyRowObjectAux IN THIS-PROCEDURE.
    
    IF pRowid <> ? THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
        &ELSE
            REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
        &ENDIF
        /* DBO-XML-END */

	 IF ERROR-STATUS:ERROR THEN DO:
            &IF "{&NewRecordOffQuery}" = "YES" &THEN
                /* DBO-XML-BEGIN */
                /* Se a Query Dinamica estiver habilitada, usa o handle dela */
                &IF {&DYNAMIC-QUERY-ENABLED} &THEN
          	         hQuery:GET-FIRST(NO-LOCK).
            	  ASSIGN pRowid = rowid({&TableName}).
          	         hQuery:REPOSITION-TO-ROWID(pRowid) NO-ERROR.
                &ELSE
                    GET FIRST {&QueryName} NO-LOCK.
                    ASSIGN pRowid = rowid({&TableName}).
                    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
                &ENDIF
            &ELSE
                RETURN "NOK":U.
            &ENDIF
            IF ERROR-STATUS:ERROR THEN do:
                RETURN "NOK":U.
            end.
        END.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        /* DBO-XML-END */
        
        /*--- Este teste torna-se necess†rio devido ao fato de realizar-se um 
              reposicionamento de um registro recÇm eliminado. Neste caso n∆o Ç 
              retornado erro no comando REPOSITION, pois o reposicionamento da
              QUERY Ç processado com base no RESULT-LIST ---*/
        IF NOT AVAILABLE {&TableName} THEN
            RETURN "NOK":U.
    END.
    
    IF pNext THEN DO:
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        /* DBO-XML-END */
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
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="before"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /*--- Copia o registro da temptable RowObject para a temptable RowObjectAux ---*/
        CREATE RowObjectAux.
        ASSIGN RowObjectAux.item-do-forn = RowObject.item-do-forn
               RowObjectAux.it-codigo    = RowObject.it-codigo
               RowObjectAux.cod-emitente = RowObject.cod-emitente
               RowObjectAux.char-1       = ITEM.desc-item
               RowObjectAux.r-rowid      = ROWID(ITEM).
        
        ASSIGN pRowsReturned = pRowsReturned + 1.
        
        /*--- Executa mÇtodos sobrepostos (before/after) ---*/
        {method/svc/override/override.i &Position="after"
                                        &Procedure="getBatchRecords"}
        IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
        
        /* DBO-XML-BEGIN */
        /* Se a Query Dinamica estiver habilitada, usa o handle dela */
        &IF {&DYNAMIC-QUERY-ENABLED} &THEN
            hQuery:GET-NEXT(NO-LOCK).
        &ELSE
            GET NEXT {&QueryName} NO-LOCK.
        &ENDIF
        /* DBO-XML-END */
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
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-do-forn":U THEN ASSIGN pFieldValue = RowObject.item-do-forn.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "numero-nota":U THEN ASSIGN pFieldValue = RowObject.numero-nota.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "serie-nota":U THEN ASSIGN pFieldValue = RowObject.serie-nota.
        WHEN "unid-med-for":U THEN ASSIGN pFieldValue = RowObject.unid-med-for.
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
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-conver":U THEN ASSIGN pFieldValue = RowObject.fator-conver.
        WHEN "lote-minimo":U THEN ASSIGN pFieldValue = RowObject.lote-minimo.
        WHEN "lote-mul-for":U THEN ASSIGN pFieldValue = RowObject.lote-mul-for.
        WHEN "niv-qua-ac":U THEN ASSIGN pFieldValue = RowObject.niv-qua-ac.
        WHEN "perc-dev-forn":U THEN ASSIGN pFieldValue = RowObject.perc-dev-forn.
        WHEN "perc-pont-forn":U THEN ASSIGN pFieldValue = RowObject.perc-pont-forn.
        WHEN "qt-max-ordem":U THEN ASSIGN pFieldValue = RowObject.qt-max-ordem.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getemitente DBOProgram 
PROCEDURE getemitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pCodEmit   AS CHAR FORMAT "X(12)":U     NO-UNDO.
DEFINE OUTPUT PARAMETER pEmitente  AS INT  FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE OUTPUT PARAMETER pNomeEmit  AS CHAR FORMAT "x(40)":U     NO-UNDO.
DEFINE OUTPUT PARAMETER pAvailEmit AS LOG NO-UNDO.

DEFINE VAR c-emitente AS CHAR CASE-SENSITIVE NO-UNDO.

   assign c-emitente = pCodEmit.

   if  lc(c-emitente) = caps(c-emitente) then
       find emitente where
            emitente.cod-emitente = int(pCodEmit) and
            emitente.identific    >= 2 no-lock no-error.
   if  not available(emitente)
   or  lc(c-emitente) <> caps(c-emitente) then
       find emitente where
            emitente.nome-abrev = pCodEmit and
            emitente.identific    >= 2 no-lock no-error.
   if available emitente then
       assign pNomeEmit  = emitente.nome-emit
              pAvailEmit = yes
              pEmitente  = emitente.cod-emitente.
   else 
       assign pNomeEmit = ""
              pAvailEmit = no
              pEmitente = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidItemFornec DBOProgram 
PROCEDURE getRowidItemFornec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pItCodigo  AS CHAR FORMAT "x(16)" NO-UNDO.
DEFINE INPUT PARAMETER pCodEmit   AS INT FORMAT ">>>>>>>>9" NO-UNDO.
DEFINE OUTPUT PARAMETER pRowidItem AS ROWID NO-UNDO.

    FIND item-fornec 
         WHERE item-fornec.it-codigo    = pItCodigo and
               item-fornec.cod-emitente = pCodEmit no-lock NO-ERROR.
    IF AVAIL item-fornec THEN
        pRowidItem = rowid(item-fornec).
    ELSE
        pRowidItem = ?.

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
        WHEN "aval-insp[1]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[1].
        WHEN "aval-insp[2]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[2].
        WHEN "aval-insp[3]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[3].
        WHEN "aval-insp[4]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[4].
        WHEN "aval-insp[5]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[5].
        WHEN "aval-insp[6]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[6].
        WHEN "aval-insp[7]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[7].
        WHEN "aval-insp[8]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[8].
        WHEN "aval-insp[9]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[9].
        WHEN "aval-insp[10]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[10].
        WHEN "aval-insp[11]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[11].
        WHEN "aval-insp[12]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[12].
        WHEN "aval-insp[13]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[13].
        WHEN "aval-insp[14]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[14].
        WHEN "aval-insp[15]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[15].
        WHEN "aval-insp[16]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[16].
        WHEN "aval-insp[17]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[17].
        WHEN "aval-insp[18]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[18].
        WHEN "aval-insp[19]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[19].
        WHEN "aval-insp[20]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[20].
        WHEN "aval-insp[21]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[21].
        WHEN "aval-insp[22]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[22].
        WHEN "aval-insp[23]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[23].
        WHEN "aval-insp[24]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[24].
        WHEN "aval-insp[25]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[25].
        WHEN "aval-insp[26]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[26].
        WHEN "aval-insp[27]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[27].
        WHEN "aval-insp[28]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[28].
        WHEN "aval-insp[29]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[29].
        WHEN "aval-insp[30]":U THEN ASSIGN pFieldValue = RowObject.aval-insp[30].
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "conceito":U THEN ASSIGN pFieldValue = RowObject.conceito.
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "hora-fim":U THEN ASSIGN pFieldValue = RowObject.hora-fim.
        WHEN "hora-ini":U THEN ASSIGN pFieldValue = RowObject.hora-ini.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "ind-pont":U THEN ASSIGN pFieldValue = RowObject.ind-pont.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "niv-inspecao":U THEN ASSIGN pFieldValue = RowObject.niv-inspecao.
        WHEN "num-casa-dec":U THEN ASSIGN pFieldValue = RowObject.num-casa-dec.
        WHEN "ped-fornec":U THEN ASSIGN pFieldValue = RowObject.ped-fornec.
        WHEN "perc-compra":U THEN ASSIGN pFieldValue = RowObject.perc-compra.
        WHEN "tempo-ressup":U THEN ASSIGN pFieldValue = RowObject.tempo-ressup.
        WHEN "tp-inspecao":U THEN ASSIGN pFieldValue = RowObject.tp-inspecao.
        WHEN "ult-ficha[1]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[1].
        WHEN "ult-ficha[2]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[2].
        WHEN "ult-ficha[3]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[3].
        WHEN "ult-ficha[4]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[4].
        WHEN "ult-ficha[5]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[5].
        WHEN "ult-ficha[6]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[6].
        WHEN "ult-ficha[7]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[7].
        WHEN "ult-ficha[8]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[8].
        WHEN "ult-ficha[9]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[9].
        WHEN "ult-ficha[10]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[10].
        WHEN "ult-ficha[11]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[11].
        WHEN "ult-ficha[12]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[12].
        WHEN "ult-ficha[13]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[13].
        WHEN "ult-ficha[14]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[14].
        WHEN "ult-ficha[15]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[15].
        WHEN "ult-ficha[16]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[16].
        WHEN "ult-ficha[17]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[17].
        WHEN "ult-ficha[18]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[18].
        WHEN "ult-ficha[19]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[19].
        WHEN "ult-ficha[20]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[20].
        WHEN "ult-ficha[21]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[21].
        WHEN "ult-ficha[22]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[22].
        WHEN "ult-ficha[23]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[23].
        WHEN "ult-ficha[24]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[24].
        WHEN "ult-ficha[25]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[25].
        WHEN "ult-ficha[26]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[26].
        WHEN "ult-ficha[27]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[27].
        WHEN "ult-ficha[28]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[28].
        WHEN "ult-ficha[29]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[29].
        WHEN "ult-ficha[30]":U THEN ASSIGN pFieldValue = RowObject.ult-ficha[30].
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice onde-compra
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE item-fornec.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE item-fornec.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-emitente = RowObject.cod-emitente.

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
        WHEN "ativo":U THEN ASSIGN pFieldValue = RowObject.ativo.
        WHEN "contr-forn":U THEN ASSIGN pFieldValue = RowObject.contr-forn.
        WHEN "cot-aut":U THEN ASSIGN pFieldValue = RowObject.cot-aut.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "reaj-tabela":U THEN ASSIGN pFieldValue = RowObject.reaj-tabela.
        WHEN "usa-contrato":U THEN ASSIGN pFieldValue = RowObject.usa-contrato.
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
  Purpose:     Reposiciona registro com base no °ndice onde-compra
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE item-fornec.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE item-fornec.cod-emitente NO-UNDO.

    FIND FIRST bfitem-fornec WHERE 
        bfitem-fornec.it-codigo = pit-codigo AND 
        bfitem-fornec.cod-emitente = pcod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-fornec THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-fornec)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryZoomItem2 DBOProgram 
PROCEDURE openQueryZoomItem2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-emitente >= i-fornec-ini
          AND {&TableName}.cod-emitente <= i-fornec-fim
          AND {&TableName}.item-do-forn >= c-it-fornec-ini
          AND {&TableName}.item-do-forn <= c-it-fornec-fim,
          FIRST ITEM WHERE item.it-codigo = {&TableName}.it-codigo NO-LOCK
        {&v9indrep}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryZoomItem DBOProgram 
PROCEDURE OpenQueryZoomItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  if i-op-radio = 1 then 
    open query {&QueryName} for each {&TableName} where
                                     {&TableName}.cod-emitente =  i-fornec     and 
                                     {&TableName}.item-do-forn >= c-codigo-ini and 
                                     {&TableName}.item-do-forn <= c-codigo-fim,
                             first item where item.it-codigo = {&TableName}.it-codigo         
                                     no-lock by item-fornec.item-do-forn {&v9indrep}.
  else 
     open query {&QueryName} for each {&TableName} where
                                      {&TableName}.cod-emitente =  i-fornec     and 
                                      {&TableName}.item-do-forn >= c-codigo-ini and 
                                      {&TableName}.item-do-forn <= c-codigo-fim,
                              first item where item.it-codigo = {&TableName}.it-codigo        
                                     no-lock by item.desc-item 
                                             by {&tablename}.item-do-forn {&v9indrep}.
                                     
         return "OK":U.                       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-emitente DBOProgram 
PROCEDURE pi-busca-emitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM TABLE FOR tt-emitente.

    EMPTY TEMP-TABLE tt-emitente.
    FOR EACH {&TableName} NO-LOCK
        WHERE {&TableName}.cod-emitente >= i-fornec-ini
          AND {&TableName}.cod-emitente <= i-fornec-fim
          AND {&TableName}.item-do-forn >= c-it-fornec-ini
          AND {&TableName}.item-do-forn <= c-it-fornec-fim,
        EACH emitente NO-LOCK
            WHERE emitente.cod-emitente = item-fornec.cod-emitente
              AND emitente.nome-abrev >= c-nome-abrev-ini
              AND emitente.nome-abrev <= c-nome-abrev-fim
            BREAK BY emitente.nome-abrev:
            IF FIRST-OF (emitente.nome-abrev) THEN DO:
                CREATE tt-emitente.
                ASSIGN tt-emitente.nome-abrev = emitente.nome-abrev
                    tt-emitente.cod-emitente  = emitente.cod-emitente
                    tt-emitente.nome-emit     = emitente.nome-emit.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoomItem2 DBOProgram 
PROCEDURE setConstraintZoomItem2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-it-fornec-ini  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-it-fornec-fim  AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-fornec-ini     AS INT  NO-UNDO.
    DEFINE INPUT PARAMETER p-fornec-fim     AS INT  NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-abrev-ini AS CHAR NO-UNDO.
    DEFINE INPUT PARAMETER p-nome-abrev-fim AS CHAR NO-UNDO.
    
    ASSIGN i-fornec-ini     =  p-fornec-ini
           i-fornec-fim     =  p-fornec-fim
           c-it-fornec-ini  =  p-it-fornec-ini
           c-it-fornec-fim  =  p-it-fornec-fim
           c-nome-abrev-ini =  p-nome-abrev-ini
           c-nome-abrev-fim =  p-nome-abrev-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintZoomItem DBOProgram 
PROCEDURE SetConstraintZoomItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEmit    AS INT  FORMAT ">>>>>>>>9":U NO-UNDO.
DEFINE INPUT PARAMETER pCodigoIni  AS CHAR FORMAT "X(16)":U     NO-UNDO.
DEFINE INPUT PARAMETER pCodigoFim  AS CHAR FORMAT "X(16)":U     NO-UNDO.
DEFINE INPUT PARAMETER pRadio      AS INTEGER NO-UNDO.

    ASSIGN i-fornec       = pCodEmit
           c-codigo-ini   = pCodigoIni
           c-codigo-fim   = pCodigoFim
           i-op-radio     = pRadio.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


