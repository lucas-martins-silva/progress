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

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN178
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-fornec
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
{inbo/boin178.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
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
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-embal":U THEN ASSIGN pFieldValue = RowObject.cod-embal.
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
        WHEN "val-aliq-cofins":U THEN ASSIGN pFieldValue = RowObject.val-aliq-cofins.
        WHEN "val-aliq-pis":U THEN ASSIGN pFieldValue = RowObject.val-aliq-pis.
        WHEN "val-reduc-cofins-normal":U THEN ASSIGN pFieldValue = RowObject.val-reduc-cofins-normal.
        WHEN "val-reduc-pis-normal":U THEN ASSIGN pFieldValue = RowObject.val-reduc-pis-normal.
        WHEN "val-unit-cofins":U THEN ASSIGN pFieldValue = RowObject.val-unit-cofins.
        WHEN "val-unit-pis":U THEN ASSIGN pFieldValue = RowObject.val-unit-pis.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getImportFields DBOProgram 
PROCEDURE getImportFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pr-item-fornec AS ROWID NO-UNDO.
DEF OUTPUT PARAM pcdn-fabrican  LIKE item-fornec.cdn-fabrican  NO-UNDO.
DEF OUTPUT PARAM pcdn-pais-orig LIKE item-fornec.cdn-pais-orig NO-UNDO.

    FOR FIRST item-fornec FIELDS(cdn-fabrican cdn-pais-orig)
        WHERE ROWID(item-fornec) = pr-item-fornec NO-LOCK:
        ASSIGN pcdn-fabrican  = item-fornec.cdn-fabrican
               pcdn-pais-orig = item-fornec.cdn-pais-orig.
    END.

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
        WHEN "cdn-fabrican":U THEN ASSIGN pFieldValue = RowObject.cdn-fabrican.
        WHEN "cdn-pais-orig":U THEN ASSIGN pFieldValue = RowObject.cdn-pais-orig.
        WHEN "classe-repro":U THEN ASSIGN pFieldValue = RowObject.classe-repro.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        WHEN "conceito":U THEN ASSIGN pFieldValue = RowObject.conceito.
        WHEN "criticidade":U THEN ASSIGN pFieldValue = RowObject.criticidade.
        WHEN "hora-fim":U THEN ASSIGN pFieldValue = RowObject.hora-fim.
        WHEN "hora-ini":U THEN ASSIGN pFieldValue = RowObject.hora-ini.
        WHEN "horiz-fixo":U THEN ASSIGN pFieldValue = RowObject.horiz-fixo.
        WHEN "idi-tributac-cofins":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-cofins.
        WHEN "idi-tributac-pis":U THEN ASSIGN pFieldValue = RowObject.idi-tributac-pis.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&queryName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sugereFabricPais DBOProgram 
PROCEDURE sugereFabricPais :
/*------------------------------------------------------------------------------
  Purpose: sugerir codigo do fabricante e do pais de origem para o item-fornec
           baseado no item.
------------------------------------------------------------------------------*/
DEF INPUT  PARAM pc-it-codigo AS CHAR NO-UNDO.
DEF OUTPUT PARAM pcdn-fabrican LIKE item-fornec.cdn-fabrican   NO-UNDO.
DEF OUTPUT PARAM pcdn-pais-orig LIKE item-fornec.cdn-pais-orig NO-UNDO.

    FOR FIRST item-mat FIELDS(cdn-fabrican cdn-pais-orig)
        WHERE item-mat.it-codigo = pc-it-codigo NO-LOCK:

        ASSIGN pcdn-fabrican  = item-mat.cdn-fabrican
               pcdn-pais-orig = item-mat.cdn-pais-orig.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFabricPais DBOProgram 
PROCEDURE validateFabricPais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT AVAIL rowObject THEN
        RETURN "NOK":U.

    IF  rowObject.cdn-fabrican <> 0 THEN DO:

        FOR FIRST emitente FIELDS(identific)
            WHERE emitente.cod-emitente = rowObject.cdn-fabrican NO-LOCK: END.

        IF  NOT AVAIL emitente  THEN DO:

            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-fabricante AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "fabricante" *}
            ASSIGN c-lbl-liter-fabricante = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-lbl-liter-fabricante"}
                                
        END.
        ELSE IF  (    emitente.identific <> 2 /* fornecedor */
                  AND emitente.identific <> 3 /* ambos */ ) THEN DO:

              /* Inicio -- Projeto Internacional */
              DEFINE VARIABLE c-lbl-liter-fabricante-informado AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "Fabricante_informado" *}
              ASSIGN c-lbl-liter-fabricante-informado = TRIM(RETURN-VALUE).
              DEFINE VARIABLE c-lbl-liter-fornecedor AS CHARACTER NO-UNDO.
              {utp/ut-liter.i "fornecedor" *}
              ASSIGN c-lbl-liter-fornecedor = TRIM(RETURN-VALUE).
              {method/svc/errors/inserr.i &ErrorNumber="17195"
                                          &ErrorType="EMS":U
                                          &ErrorSubType="ERROR":U
                                          &ErrorParameters="c-lbl-liter-fabricante-informado + '~~~~' + c-lbl-liter-fornecedor"}
                                  
        END.
    END.

    IF  rowObject.cdn-pais-orig <> 0 
    AND NOT CAN-FIND(FIRST pais 
                     WHERE pais.cod-pais = rowObject.cdn-pais-orig) THEN DO:

        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-pais-de-origem AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "pa°s_de_origem" *}
        ASSIGN c-lbl-liter-pais-de-origem = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="2"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-liter-pais-de-origem"}


    END.

    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.


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

