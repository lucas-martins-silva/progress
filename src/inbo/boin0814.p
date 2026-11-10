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
{include/i-prgvrs.i BOIN0814 2.00.00.013 } /*** "010013" 15/05/2024 15:30:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin0814 MUT}
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
&GLOBAL-DEFINE DBOName BOIN0814
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName item-docto-estoq-nfe-imp
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
      
{inbo/boin0814.i RowObject}
{inbo/boin176.i tt-item-doc-est}
{cdp/cdcfgmat.i}
DEFINE TEMP-TABLE tt-item-docto-estoq-nfe-imp-aux NO-UNDO LIKE item-docto-estoq-nfe-imp
    FIELD r-rowid AS ROWID.

DEF VAR  cSerDocto      LIKE item-doc-est.serie-docto  NO-UNDO.   
DEF VAR  cNumDocto      LIKE item-doc-est.nro-docto    NO-UNDO.   
DEF VAR  iEmitDocto     LIKE item-doc-est.cod-emitente NO-UNDO.  
DEF VAR  cNatOperDocto  LIKE item-doc-est.nat-operacao NO-UNDO. 

DEF VAR  h-cdapi995      AS HANDLE                      NO-UNDO.
DEF VAR  de-aliq-pis    AS DECIMAL FORMAT ">9.9999":U  NO-UNDO.
DEF VAR  de-aliq-cofins AS DECIMAL FORMAT ">9.9999":U  NO-UNDO.
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
         HEIGHT             = 25.71
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
        WHEN "cod-docto":U THEN ASSIGN pFieldValue = RowObject.cod-docto.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-natur-operac":U THEN ASSIGN pFieldValue = RowObject.cod-natur-operac.
        WHEN "cod-ser-docto":U THEN ASSIGN pFieldValue = RowObject.cod-ser-docto.
        WHEN "des-decla-import":U THEN ASSIGN pFieldValue = RowObject.des-decla-import.
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
        WHEN "val-base":U THEN ASSIGN pFieldValue = RowObject.val-base.
        WHEN "val-desc":U THEN ASSIGN pFieldValue = RowObject.val-desc.
        WHEN "val-despesa":U THEN ASSIGN pFieldValue = RowObject.val-despesa.
        WHEN "val-impto-import":U THEN ASSIGN pFieldValue = RowObject.val-impto-import.
        WHEN "val-iof":U THEN ASSIGN pFieldValue = RowObject.val-iof.
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
        WHEN "cdn-expdor":U THEN ASSIGN pFieldValue = RowObject.cdn-expdor.
        WHEN "num-adic":U THEN ASSIGN pFieldValue = RowObject.num-adic.
        WHEN "num-seq":U THEN ASSIGN pFieldValue = RowObject.num-seq.
        WHEN "num-seq-import":U THEN ASSIGN pFieldValue = RowObject.num-seq-import.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice itmdctsc-id
  Parameters:  
               retorna valor do campo cdn-emitente
               retorna valor do campo cod-docto
               retorna valor do campo cod-ser-docto
               retorna valor do campo cod-natur-operac
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdn-emitente LIKE item-docto-estoq-nfe-imp.cdn-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-docto LIKE item-docto-estoq-nfe-imp.cod-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-ser-docto LIKE item-docto-estoq-nfe-imp.cod-ser-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-natur-operac LIKE item-docto-estoq-nfe-imp.cod-natur-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE item-docto-estoq-nfe-imp.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdn-emitente = RowObject.cdn-emitente
           pcod-docto = RowObject.cod-docto
           pcod-ser-docto = RowObject.cod-ser-docto
           pcod-natur-operac = RowObject.cod-natur-operac
           pnum-seq = RowObject.num-seq.

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
  Purpose:     Reposiciona registro com base no °ndice itmdctsc-id
  Parameters:  
               recebe valor do campo cdn-emitente
               recebe valor do campo cod-docto
               recebe valor do campo cod-ser-docto
               recebe valor do campo cod-natur-operac
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-emitente      LIKE item-docto-estoq-nfe-imp.cdn-emitente     NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto         LIKE item-docto-estoq-nfe-imp.cod-docto        NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ser-docto     LIKE item-docto-estoq-nfe-imp.cod-ser-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac  LIKE item-docto-estoq-nfe-imp.cod-natur-operac NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq           LIKE item-docto-estoq-nfe-imp.num-seq          NO-UNDO.

    FIND FIRST bfitem-docto-estoq-nfe-imp 
         WHERE bfitem-docto-estoq-nfe-imp.cdn-emitente     = pcdn-emitente 
         AND   bfitem-docto-estoq-nfe-imp.cod-docto        = pcod-docto 
         AND   bfitem-docto-estoq-nfe-imp.cod-ser-docto    = pcod-ser-docto 
         AND   bfitem-docto-estoq-nfe-imp.cod-natur-operac = pcod-natur-operac 
         AND   bfitem-docto-estoq-nfe-imp.num-seq          = pnum-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfitem-docto-estoq-nfe-imp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfitem-docto-estoq-nfe-imp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK INDEXED-REPOSITION. 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryDocto DBOProgram 
PROCEDURE OpenQueryDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY qr{&tableName} FOR EACH {&tableName} NO-LOCK
         WHERE {&tableName}.cod-ser-docto    = cSerDocto
           AND {&tableName}.cod-docto        = cNumDocto
           AND {&tableName}.cdn-emitente     = iEmitDocto 
           AND {&tableName}.cod-natur-operac = cNatOperDocto 
        INDEXED-REPOSITION. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piretornaitem DBOProgram 
PROCEDURE piretornaitem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-emitente      LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto         LIKE item-doc-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ser-docto     LIKE item-doc-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac  LIKE item-doc-est.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt-item-doc-est.


    FOR EACH item-doc-est NO-LOCK
        WHERE item-doc-est.cod-emitente = pcdn-emitente
        AND   item-doc-est.serie-docto  = pcod-ser-docto
        AND   item-doc-est.nro-docto    = pcod-docto
        AND   item-doc-est.nat-operacao = pcod-natur-operac :
       CREATE tt-item-doc-est.
       BUFFER-COPY item-doc-est TO tt-item-doc-est.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDocto DBOProgram 
PROCEDURE setConstraintDocto:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input parameter pNumDocto      LIKE item-doc-est.nro-docto    NO-UNDO.  
  def input parameter pSerDocto      LIKE item-doc-est.serie-docto  NO-UNDO. 
  def input parameter pEmitDocto     LIKE item-doc-est.cod-emitente NO-UNDO. 
  def input parameter pNatOperDocto  LIKE item-doc-est.nat-operacao NO-UNDO.  

    assign cSerDocto     = pSerDocto    
           cNumDocto     = pNumDocto    
           iEmitDocto    = pEmitDocto   
           cNatOperDocto = pNatOperDocto.
    
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
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piretornaitem DBOProgram 
PROCEDURE piatualizaImpostos:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdn-emitente      LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pcod-docto         LIKE item-doc-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-ser-docto     LIKE item-doc-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAMETER pcod-natur-operac  LIKE item-doc-est.nat-operacao NO-UNDO.
    define input parameter pval-despesa      as decimal no-undo.
    define input parameter pval-impto-import as decimal no-undo.
    define input parameter pval-iof          as decimal no-undo.

    
    
    DEFINE VARIABLE h-boin176 AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-boin090 AS HANDLE      NO-UNDO.

    if not valid-handle (h-boin176) then 
        run inbo/boin176.p persistent set h-boin176.

    if not valid-handle (h-boin090) then
        run inbo/boin090.p persistent set h-boin090.

    IF NOT VALID-HANDLE(h-cdapi995) THEN
        RUN cdp/cdapi995.p PERSISTENT SET h-cdapi995.

    run openQueryStatic in h-boin176 (input "Main").
    run openQueryStatic in h-boin090 (input "Main").


    find first item-doc-est
         where item-doc-est.cod-emitente = pcdn-emitente
           and item-doc-est.serie-docto  = pcod-docto       
           and item-doc-est.nro-docto    = pcod-ser-docto   
           and item-doc-est.nat-operacao = pcod-natur-operac exclusive-lock no-error.
    if avail item-doc-est then do:
        
        assign item-doc-est.despesas[1]  = item-doc-est.despesas[1] +  pval-despesa + pval-impto-import + pval-iof
               item-doc-est.base-icm[1]  = item-doc-est.base-icm[1] + pval-despesa + pval-impto-import + pval-iof
               item-doc-est.valor-icm[1] = item-doc-est.valor-icm[1] * item-doc-est.aliquota-icm.

        
        &if '{&bf_mat_versao_ems}' >= '2.062' &then
            if valid-handle (h-boin176) then do:


                run gotoKey in h-boin176 (input item-doc-est.serie-docto,
                                         input item-doc-est.nro-docto,
                                         input item-doc-est.cod-emitente,
                                         input item-doc-est.nat-operacao,
                                         input item-doc-est.sequencia).

                run gotoKey in h-boin090 (input item-doc-est.serie-docto,
                                          input item-doc-est.nro-docto,
                                          input item-doc-est.cod-emitente,
                                          input item-doc-est.nat-operacao).
                

                run setHandleDocumEst in h-boin176 (h-boin090).
    
                run setDocumEst in h-boin176.

                RUN recupera-aliquotas IN h-cdapi995 (INPUT "item-doc-est",
                                                     INPUT item-doc-est.serie-docto + "/" + 
                                                           item-doc-est.nro-docto + "/" + 
                                                           string(item-doc-est.cod-emitente) + "/" + 
                                                           item-doc-est.nat-operacao + "/" + 
                                                           string(item-doc-est.sequencia), 
                                                     INPUT de-aliq-pis,
                                                     INPUT de-aliq-cofins).


                IF de-aliq-pis    = 0 THEN ASSIGN de-aliq-pis    = item-doc-est.val-aliq-pis.  
                IF de-aliq-cofins = 0 THEN ASSIGN de-aliq-cofins = item-doc-est.val-aliq-cofins.

                run recalculateImposto in h-boin176 ( input item-doc-est.qt-do-forn,
                                                      INPUT item-doc-est.preco-unit[1],
                                                      input item-doc-est.preco-total[1],
                                                      input item-doc-est.desconto[1],
                                                      input item-doc-est.aliquota-ipi,
                                                      input item-doc-est.cd-trib-ipi,
                                                      input item-doc-est.aliquota-iss,
                                                      input item-doc-est.cd-trib-iss,
                                                      input item-doc-est.aliquota-icm,
                                                      input item-doc-est.cd-trib-icm,
                                                      input IF item-doc-est.val-perc-rep-ipi <> 0 THEN STRING(item-doc-est.val-perc-rep-ipi) ELSE string(dec(substring(item-doc-est.char-2,1,6)) / 10000), /* perc ipi */
                                                      input IF item-doc-est.val-perc-red-icms <> 0 THEN STRING(item-doc-est.val-perc-red-icms) ELSE string(dec(substring(item-doc-est.char-2,7,6)) / 10000), /* perc icm */
                                                      input item-doc-est.log-2,
                                                      input item-doc-est.idi-tributac-pis,
                                                      input de-aliq-pis,
                                                      input item-doc-est.idi-tributac-cofins,
                                                      input de-aliq-cofins,
                                                      input no).
                run updateRecord in h-boin176.
            end.

        &else
            if valid-handle (h-boin176) then do:

                run gotoKey in h-boin176 (input item-doc-est.serie-docto,
                                          input item-doc-est.nro-docto,
                                          input item-doc-est.cod-emitente,
                                          input item-doc-est.nat-operacao,
                                          input item-doc-est.sequencia).

                run gotoKey in h-boin090 (input item-doc-est.serie-docto,
                                          input item-doc-est.nro-docto,
                                          input item-doc-est.cod-emitente,
                                          input item-doc-est.nat-operacao).
                

                run setHandleDocumEst in h-boin176 (h-boin090).
    
                run setDocumEst in h-boin176.

                 
                run recalculateImposto in h-boin176 ( input item-doc-est.qt-do-forn,
                                                      INPUT item-doc-est.preco-unit[1],
                                                      input item-doc-est.preco-total[1],
                                                      input item-doc-est.desconto[1],
                                                      input item-doc-est.aliquota-ipi,
                                                      input item-doc-est.cd-trib-ipi,
                                                      input item-doc-est.aliquota-iss,
                                                      input item-doc-est.cd-trib-iss,
                                                      input item-doc-est.aliquota-icm,
                                                      input item-doc-est.cd-trib-icm,
                                                      input if item-doc-est.val-perc-rep-ipi <> 0 THEN STRING(item-doc-est.val-perc-rep-ipi) ELSE string(dec(substring(item-doc-est.char-2,1,6)) / 10000), /* perc ipi */
                                                      input if item-doc-est.val-perc-red-icms <> 0 THEN STRING(item-doc-est.val-perc-red-icms) ELSE string(dec(substring(item-doc-est.char-2,7,6)) / 10000), /* perc icm */
                                                      input item-doc-est.log-2,
                                                      input substring(item-doc-est.char-2,21,1),
                                                      input substring(item-doc-est.char-2,22,5),
                                                      input substring(item-doc-est.char-2,83,1),
                                                      input substring(item-doc-est.char-2,84,5),
                                                      input no).



                run updateRecord in h-boin176.
            end.
        &endif
    end.

    if valid-handle (h-boin176) then do:
        run destroy in h-boin176.
        delete procedure h-boin176 no-error.
        assign h-boin176 = ?.
    end.

    if valid-handle (h-boin090) then
        delete procedure h-boin090.

    IF VALID-HANDLE (h-cdapi995) THEN DO:
        RUN pi-finalizar in h-cdapi995.
        ASSIGN h-cdapi995 = ?.
    END.

    return "OK":U.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCarregaPaisOrigemDoEmit DBOProgram 
PROCEDURE piCarregaPaisOrigemDoEmit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-cdn-emitente      LIKE item-doc-est.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cdn-pais-orig     AS INTEGER     NO-UNDO.
    
    FOR FIRST emitente FIELDS(pais) NO-LOCK
        WHERE emitente.cod-emitente = pi-cdn-emitente,
        FIRST pais NO-LOCK
        WHERE pais.nome-pais = emitente.pais:

        ASSIGN pi-cdn-pais-orig = pais.cod-pais.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
