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

{include/i-prgvrs.i BOIN759NA 2.00.00.011 } /*** "010011" 24/02/2025 15:28:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin759na MUT}
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
&GLOBAL-DEFINE DBOName BOIN759
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName impto-item-docto
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
{inbo/boin759.i RowObject}
{inbo/boin759.i tt-impto-item-docto-aux}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
{cdp/cdapi027.i}
DEFINE VARIABLE h-boar2006 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-cdapi027 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-col114   AS HANDLE NO-UNDO.

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
         HEIGHT             = 20.17
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE (h-cdapi027) THEN do:
        DELETE procedure h-cdapi027.
        ASSIGN h-cdapi027 = ?.
    END.

    IF VALID-HANDLE(h-boar2006) THEN DO:
        RUN destroy IN h-boar2006.
        ASSIGN h-boar2006 = ?.
    END.

    IF VALID-HANDLE(h-col114) THEN DO:
        DELETE PROCEDURE h-col114.
        ASSIGN h-col114 = ?.
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
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
        WHEN "perc-imposto":U THEN ASSIGN pFieldValue = RowObject.perc-imposto.
        WHEN "val-impto":U THEN ASSIGN pFieldValue = RowObject.val-impto.
        WHEN "val-impto-merc-ext":U THEN ASSIGN pFieldValue = RowObject.val-impto-merc-ext.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getImptoItemDoctoByDocumEst DBOProgram 
PROCEDURE getImptoItemDoctoByDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-rowid-docum-est AS ROWID NO-UNDO.
DEF INPUT PARAM p-tipo            LIKE tipo-tax.tipo NO-UNDO.
DEF OUTPUT PARAM TABLE FOR tt-impto-item-docto-aux.

DEF VAR de-val-impto LIKE tt-impto-item-docto-aux.val-impto NO-UNDO.

EMPTY TEMP-TABLE tt-impto-item-docto-aux.

FOR FIRST docum-est NO-LOCK
    WHERE ROWID(docum-est) = p-rowid-docum-est: 
    
    FOR EACH  impto-item-docto
        WHERE impto-item-docto.serie-docto  = docum-est.serie-docto          
        AND   impto-item-docto.nro-docto    = docum-est.nro-docto            
        AND   impto-item-docto.cod-emitente = docum-est.cod-emitente         
        AND   impto-item-docto.nat-operacao = docum-est.nat-operacao NO-LOCK,
        FIRST tipo-tax NO-LOCK
        WHERE tipo-tax.cod-tax = impto-item-docto.cdn-imposto:  

        IF  p-tipo <> 0
        AND p-tipo <> tipo-tax.tipo THEN
            NEXT.

        IF NOT CAN-FIND(FIRST tt-impto-item-docto-aux 
                        WHERE tt-impto-item-docto-aux.cod-emitente = docum-est.cod-emitente 
                        AND   tt-impto-item-docto-aux.serie-docto  = docum-est.serie-docto  
                        AND   tt-impto-item-docto-aux.nat-operacao = docum-est.nat-operacao 
                        AND   tt-impto-item-docto-aux.nro-docto    = docum-est.nro-docto
                        AND   tt-impto-item-docto-aux.cdn-imposto  = tipo-tax.cod-tax        ) THEN DO:

            CREATE tt-impto-item-docto-aux.
            BUFFER-COPY impto-item-docto TO tt-impto-item-docto-aux.
            
            /* Arredondamento para ISD/Imposto Pa°s */
            IF (i-pais-impto-usuario = 2 
            OR  i-pais-impto-usuario = 21)
            AND CAN-FIND(FIRST tipo-tax-internac
                         WHERE tipo-tax-internac.cod-tax          = tipo-tax.cod-tax
                           AND tipo-tax-internac.log-cr-saida-div = YES) /* CrÇdito ISD */ THEN
                ASSIGN tt-impto-item-docto-aux.val-impto = ROUND(tt-impto-item-docto-aux.val-impto,2).
        END.
        ELSE DO:
            FOR FIRST tt-impto-item-docto-aux 
                WHERE tt-impto-item-docto-aux.cod-emitente = docum-est.cod-emitente 
                AND   tt-impto-item-docto-aux.serie-docto  = docum-est.serie-docto  
                AND   tt-impto-item-docto-aux.nat-operacao = docum-est.nat-operacao 
                AND   tt-impto-item-docto-aux.nro-docto    = docum-est.nro-docto
                AND   tt-impto-item-docto-aux.cdn-imposto  = tipo-tax.cod-tax:
                
                /* Arredondamento para ISD/Imposto Pa°s */
                IF (i-pais-impto-usuario = 2 
                OR  i-pais-impto-usuario = 21)
                AND CAN-FIND(FIRST tipo-tax-internac
                             WHERE tipo-tax-internac.cod-tax          = tipo-tax.cod-tax
                               AND tipo-tax-internac.log-cr-saida-div = YES) /* CrÇdito ISD */ THEN
                    ASSIGN de-val-impto = ROUND(impto-item-docto.val-impto,2).
                ELSE
                    ASSIGN de-val-impto = impto-item-docto.val-impto.

                ASSIGN tt-impto-item-docto-aux.val-impto          = tt-impto-item-docto-aux.val-impto          + de-val-impto
                       tt-impto-item-docto-aux.val-impto-merc-ext = tt-impto-item-docto-aux.val-impto-merc-ext + impto-item-docto.val-impto-merc-ext
                       tt-impto-item-docto-aux.val-base           = tt-impto-item-docto-aux.val-base           + impto-item-docto.val-base 
                       tt-impto-item-docto-aux.val-base-me        = tt-impto-item-docto-aux.val-base-me        + impto-item-docto.val-base-me.
            END.
        END.
    END.
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
        WHEN "cdn-imposto":U THEN ASSIGN pFieldValue = RowObject.cdn-imposto.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
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
  Purpose:     Retorna valores dos campos do °ndice impttmdc-id
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo num-seq
               retorna valor do campo cdn-imposto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE impto-item-docto.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE impto-item-docto.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE impto-item-docto.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE impto-item-docto.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE impto-item-docto.num-seq NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-imposto LIKE impto-item-docto.cdn-imposto NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           pnum-seq = RowObject.num-seq
           pcdn-imposto = RowObject.cdn-imposto.

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
  Purpose:     Reposiciona registro com base no °ndice impttmdc-id
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo num-seq
               recebe valor do campo cdn-imposto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE impto-item-docto.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE impto-item-docto.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE impto-item-docto.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE impto-item-docto.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE impto-item-docto.num-seq NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-imposto LIKE impto-item-docto.cdn-imposto NO-UNDO.

    FIND FIRST bfimpto-item-docto WHERE 
        bfimpto-item-docto.serie-docto = pserie-docto AND 
        bfimpto-item-docto.nro-docto = pnro-docto AND 
        bfimpto-item-docto.cod-emitente = pcod-emitente AND 
        bfimpto-item-docto.nat-operacao = pnat-operacao AND 
        bfimpto-item-docto.num-seq = pnum-seq AND 
        bfimpto-item-docto.cdn-imposto = pcdn-imposto NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfimpto-item-docto THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfimpto-item-docto)).
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
OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-impostos-item DBOProgram 
PROCEDURE pi-calcula-impostos-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM p-sequencia LIKE item-doc-est.sequencia.
  DEF INPUT PARAM p-it-codigo LIKE item.it-codigo.
  DEF INPUT PARAM p-table-docum AS ROWID.
  DEF INPUT PARAM p-preco-total-me AS DEC.
  DEF INPUT PARAM p-desconto-me    AS DEC. 
  DEF OUTPUT PARAM TABLE FOR tt-impto-item-docto-aux.
  
  DEF VAR i-emitente       AS INT  NO-UNDO.
  DEF VAR c-pais           AS CHAR NO-UNDO.
  DEF VAR c-estabel        AS CHAR NO-UNDO.
  DEF VAR c-uf             AS CHAR NO-UNDO.
  DEF VAR c-familia        AS CHAR NO-UNDO.
  DEF VAR c-item           AS CHAR NO-UNDO.
  DEF VAR c-nat-oper       AS CHAR NO-UNDO.
  DEF VAR c-cidade         AS CHAR NO-UNDO.
  DEF VAR i-emit-natur     AS INT  NO-UNDO.
  DEF VAR i-imp-retido     AS INT  NO-UNDO.
  DEF VAR i-nat-imp        AS INT  NO-UNDO.
  DEF VAR i-cod-tax-aux    AS INT  NO-UNDO.
  DEF VAR l-iva-normal     AS LOG  NO-UNDO.
  DEF VAR de-vl-base-calc  AS DEC  NO-UNDO.
  DEF VAR de-vl-imposto    AS DEC  NO-UNDO.
  DEF VAR de-vl-imposto-me AS DEC  NO-UNDO.
  DEF VAR v-log-return     AS LOG  NO-UNDO.
  DEF VAR l-fornec-ag-perc AS LOG  NO-UNDO.
  
  DEF BUFFER b-tipo-tax FOR tipo-tax.

  EMPTY TEMP-TABLE tt-imposto.
  EMPTY TEMP-TABLE tt-impto-item-docto-aux.

  IF i-pais-impto-usuario = 2 AND NOT VALID-HANDLE(h-boar2006) THEN
      RUN local/arg/boar2006.p PERSISTENT SET h-boar2006.

  IF NOT VALID-HANDLE(h-cdapi027) THEN
      RUN cdp/cdapi027.p PERSISTENT SET h-cdapi027.

  IF i-pais-impto-usuario = 17 THEN
      IF NOT VALID-HANDLE(h-col114) THEN
          RUN local/col/col114.p PERSISTENT SET h-col114.

  FIND FIRST docum-est WHERE rowid(docum-est) = p-table-docum NO-LOCK NO-ERROR.

  IF NOT AVAIL docum-est THEN
     RETURN.
     
  if can-find(first emitente-internac
              where emitente-internac.cdn-emitente = docum-est.cod-emitente
                and emitente-internac.log-livre-1  = yes) /* fornecedor Ç agente de percepá∆o */ 
     and i-pais-impto-usuario = 33 /* peru */ then do:
     assign l-fornec-ag-perc = yes.
  end.
  else 
     assign l-fornec-ag-perc = no.

  ASSIGN c-pais     = docum-est.pais
         c-uf       = docum-est.uf
         c-cidade   = docum-est.cidade
         c-nat-oper = docum-est.nat-operacao.
  
  FIND FIRST item-doc-est WHERE 
             item-doc-est.serie-docto  = docum-est.serie-docto  AND
             item-doc-est.nro-docto    = docum-est.nro-docto    AND
             item-doc-est.cod-emitente = docum-est.cod-emitente AND
             item-doc-est.nat-operacao = docum-est.nat-operacao AND
             item-doc-est.sequencia    = p-sequencia            NO-LOCK NO-ERROR.
  
  FIND FIRST item 
       WHERE item.it-codigo = p-it-codigo NO-LOCK NO-ERROR.
  
  IF  AVAIL ITEM THEN
      ASSIGN c-item    = ITEM.it-codigo
             c-familia = ITEM.fm-codigo.

  FIND FIRST estabelec 
       WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
       IF  AVAIL estabelec THEN 
           ASSIGN c-estabel  = estabelec.cod-estabel.
       
  FIND FIRST emitente 
       WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
       IF  AVAIL emitente THEN
           ASSIGN i-emitente   = emitente.cod-emitente
                  i-emit-natur = emitente.natureza
                  c-pais       = emitente.pais    WHEN c-pais = ""             
                  c-uf         = emitente.estado  WHEN c-uf = ""  
                  c-cidade     = emitente.cidade  WHEN c-cidade = "".

    FIND FIRST natur-oper WHERE 
             natur-oper.nat-operacao = c-nat-oper NO-LOCK NO-ERROR.

    IF AVAIL natur-oper 
        AND natur-oper.tipo-trib = 2 /* normal */
        AND ( docum-est.nff 
         OR ( NOT docum-est.nff AND natur-oper.emite-duplic )) THEN DO:
       
       RUN pi-busca-impostos IN h-cdapi027(INPUT c-estabel,
                                           INPUT c-nat-oper,
                                           INPUT c-pais,
                                           INPUT c-uf,
                                           INPUT c-cidade,
                                           INPUT c-familia,
                                           INPUT c-item,
                                           INPUT-OUTPUT TABLE tt-imposto,
                                           INPUT-OUTPUT TABLE tt-erro).  
    END.    
  
    FIND FIRST tt-imposto NO-ERROR.

    IF NOT CAN-FIND(FIRST impto-remito-fatur
                    WHERE impto-remito-fatur.cod-estabel  = c-estabel 
                      AND impto-remito-fatur.nat-operacao = c-nat-oper
                      AND impto-remito-fatur.nome-pais    = c-pais    
                      AND impto-remito-fatur.cod-estado   = c-uf      
                      AND impto-remito-fatur.nom-cidade   = c-cidade  
                      AND impto-remito-fatur.fm-codigo    = c-familia 
                      AND impto-remito-fatur.it-codigo    = c-item) 
    AND NOT AVAIL tt-imposto THEN DO:
      
        IF  AVAIL natur-oper 
        AND natur-oper.tipo-trib = 2 /* normal */
        AND (docum-est.nff 
         OR ( not docum-est.nff and natur-oper.emite-duplic )) THEN DO:
        
            FOR FIRST item-mat FIELDS(cod-tax)
                WHERE item-mat.it-codigo = item.it-codigo
                AND   item-mat.cod-tax > 0 NO-LOCK: END.
            ASSIGN i-cod-tax-aux = IF AVAIL item-mat THEN item-mat.cod-tax ELSE 0.
        
            FOR FIRST nat-imp FIELDS(cod-imposto)
                WHERE nat-imp.nat-operacao = natur-oper.nat-operacao 
                  AND nat-imp.cod-imposto > 0 NO-LOCK: END.
            ASSIGN i-nat-imp =  IF  AVAIL nat-imp THEN nat-imp.cod-imposto ELSE 0. 

            IF  AVAIL item 
            AND item.cod-tax-serv > 0 
            AND i-emit-natur      = 1 THEN 
                ASSIGN i-imp-retido = item.cod-tax-serv.
              
            FIND FIRST tt-imposto WHERE tt-imposto.cdn-imposto = i-cod-tax-aux NO-LOCK NO-ERROR.
            IF  NOT AVAIL tt-imposto THEN DO:
            
                FOR FIRST tipo-tax FIELDS( tipo ) NO-LOCK 
                    WHERE tipo-tax.cod-tax = i-cod-tax-aux:

                    ASSIGN v-log-return = YES.

                    IF  i-pais-impto-usuario = 2 AND AVAIL ITEM AND VALID-HANDLE(h-boar2006) THEN
                        RUN pi-tip-item IN h-boar2006 (INPUT tipo-tax.tipo,
                                                       INPUT item.it-codigo,
                                                       OUTPUT v-log-return).              


                    IF  v-log-return THEN DO:
                        CREATE tt-imposto.
                        ASSIGN tt-imposto.cdn-imposto  = i-cod-tax-aux
                               tt-imposto.tipo-imposto = tipo-tax.tipo
                               tt-imposto.cod-estabel  = c-estabel
                               tt-imposto.nat-operacao = c-nat-oper
                               tt-imposto.nome-pais    = c-pais
                               tt-imposto.cod-estado   = c-uf
                               tt-imposto.nom-cidade   = c-cidade
                               tt-imposto.fm-codigo    = c-familia
                               tt-imposto.it-codigo    = c-item.
                    END.
                END.
            END.
                 
            FIND FIRST tt-imposto WHERE tt-imposto.cdn-imposto  = i-nat-imp NO-LOCK NO-ERROR.
            IF  NOT AVAIL tt-imposto THEN DO:
                FOR FIRST tipo-tax FIELDS( tipo ) NO-LOCK WHERE
                          tipo-tax.cod-tax = i-nat-imp: 
                    CREATE tt-imposto.
                    ASSIGN tt-imposto.cdn-imposto  = i-nat-imp
                           tt-imposto.tipo-imposto = tipo-tax.tipo
                           tt-imposto.cod-estabel  = c-estabel
                           tt-imposto.nat-operacao = c-nat-oper
                           tt-imposto.nome-pais    = c-pais
                           tt-imposto.cod-estado   = c-uf
                           tt-imposto.nom-cidade   = c-cidade
                           tt-imposto.fm-codigo    = c-familia
                           tt-imposto.it-codigo    = c-item.
                END.
            END.
        
            FIND FIRST tt-imposto WHERE tt-imposto.cdn-imposto = i-imp-retido NO-LOCK NO-ERROR.
            IF  NOT AVAIL tt-imposto THEN DO:
                FOR FIRST tipo-tax FIELDS( tipo ) NO-LOCK WHERE
                          tipo-tax.cod-tax = i-imp-retido: 
                    CREATE tt-imposto.
                    ASSIGN tt-imposto.cdn-imposto  = i-imp-retido
                           tt-imposto.tipo-imposto = tipo-tax.tipo
                           tt-imposto.cod-estabel  = c-estabel
                           tt-imposto.nat-operacao = c-nat-oper
                           tt-imposto.nome-pais    = c-pais
                           tt-imposto.cod-estado   = c-uf
                           tt-imposto.nom-cidade   = c-cidade
                           tt-imposto.fm-codigo    = c-familia
                           tt-imposto.it-codigo    = c-item.
                END.
            END.
            
            /* Imposto de percepá∆o do item para o Peru */
            IF  i-pais-impto-usuario = 33 and 
                l-fornec-ag-perc THEN DO:

                FIND FIRST item-internac
                    WHERE item-internac.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
                IF  AVAIL item-internac
                AND item-internac.num-livre-2 <> 0 THEN DO:
                
                    FIND FIRST tt-imposto WHERE tt-imposto.cdn-imposto = item-internac.num-livre-2 NO-LOCK NO-ERROR.
                    IF  NOT AVAIL tt-imposto THEN DO:

                        FOR FIRST tipo-tax FIELDS( tipo ) NO-LOCK
                            WHERE tipo-tax.cod-tax = item-internac.num-livre-2: 
                            
                            CREATE tt-imposto.
                            ASSIGN tt-imposto.cdn-imposto  = item-internac.num-livre-2
                                   tt-imposto.tipo-imposto = tipo-tax.tipo
                                   tt-imposto.cod-estabel  = c-estabel
                                   tt-imposto.nat-operacao = c-nat-oper
                                   tt-imposto.nome-pais    = c-pais
                                   tt-imposto.cod-estado   = c-uf
                                   tt-imposto.nom-cidade   = c-cidade
                                   tt-imposto.fm-codigo    = c-familia
                                   tt-imposto.it-codigo    = c-item.
                        END.
                    END.
                END.
            END. /* Percepá∆o Peru */
        END.
    END.

    FOR EACH tt-imposto WHERE tt-imposto.cdn-imposto <> 0 NO-LOCK BY tt-imposto.tipo-imposto DESC:

        FIND FIRST tipo-tax 
            WHERE tipo-tax.cod-tax = tt-imposto.cdn-imposto NO-LOCK NO-ERROR.

        IF  tipo-tax.tipo                = 1 
        AND tipo-tax.idi-val-base-retenc = 2 THEN DO:
            FOR EACH tt-impto-item-docto-aux WHERE 
                     tt-impto-item-docto-aux.serie-docto  = docum-est.serie-docto   AND
                     tt-impto-item-docto-aux.nro-docto    = docum-est.nro-docto     AND
                     tt-impto-item-docto-aux.cod-emitente = docum-est.cod-emitente  AND
                     tt-impto-item-docto-aux.nat-operacao = docum-est.nat-operacao  AND
                     tt-impto-item-docto-aux.num-seq      = p-sequencia,
                FIRST b-tipo-tax NO-LOCK 
                    WHERE b-tipo-tax.cod-tax = tt-impto-item-docto-aux.cdn-imposto 
                      AND b-tipo-tax.tipo    = 2: 
                ASSIGN l-iva-normal = YES.
            END.
          
            IF NOT l-iva-normal THEN NEXT.
        END.       

        FIND FIRST tt-impto-item-docto-aux 
             WHERE tt-impto-item-docto-aux.serie-docto   = docum-est.serie-docto  
               AND tt-impto-item-docto-aux.nro-docto     = docum-est.nro-docto    
               AND tt-impto-item-docto-aux.cod-emitente  = docum-est.cod-emitente 
               AND tt-impto-item-docto-aux.nat-operacao  = docum-est.nat-operacao 
               AND tt-impto-item-docto-aux.num-seq       = p-sequencia 
               AND tt-impto-item-docto-aux.cdn-imposto   = tt-imposto.cdn-imposto NO-LOCK NO-ERROR.
        IF  NOT AVAIL tt-impto-item-docto-aux THEN DO:
        
            CREATE tt-impto-item-docto-aux.
            ASSIGN tt-impto-item-docto-aux.serie-docto  = docum-est.serie-docto
                   tt-impto-item-docto-aux.nro-docto    = docum-est.nro-docto
                   tt-impto-item-docto-aux.cod-emitente = docum-est.cod-emitente
                   tt-impto-item-docto-aux.nat-operacao = docum-est.nat-operacao
                   tt-impto-item-docto-aux.num-seq      = p-sequencia
                   tt-impto-item-docto-aux.cdn-imposto  = tt-imposto.cdn-imposto
                   tt-impto-item-docto-aux.perc-imposto = IF AVAIL tipo-tax THEN tipo-tax.tax-perc ELSE 0.
                   
            /* Verificaá∆o para utilizaá∆o de al°quota reduzida/alternativa do imposto de percepá∆o */
            IF  i-pais-impto-usuario = 33 /* Peru */ THEN DO:
                FIND FIRST empres-internac NO-LOCK
                     WHERE empres-internac.cod-empresa = i-ep-codigo-usuario NO-ERROR.
                     
                FIND FIRST emitente-internac NO-LOCK
                     WHERE emitente-internac.cdn-emitente = docum-est.cod-emitente NO-ERROR.
                
                FIND FIRST tipo-tax-internac NO-LOCK
                     WHERE tipo-tax-internac.cod-tax = tipo-tax.cod-tax NO-ERROR.
                     
                IF  AVAIL empres-internac   AND empres-internac.log-agent     /* empresa Ç agente de percepá∆o */   
                AND AVAIL emitente-internac AND emitente-internac.log-livre-1 /* emitente Ç agente de percepá∆o */
                AND AVAIL tipo-tax-internac AND tipo-tax-internac.log-livre-1 /* imposto Ç de percepá∆o */ THEN DO:
                    ASSIGN tt-impto-item-docto-aux.perc-imposto = tipo-tax-internac.val-livre-2. /* aliquota reduzida quando empresa e fornecedor s∆o de percepá∆o*/
                END.
            END.                      

            RUN rep/re0412.p(INPUT IF AVAIL item-doc-est THEN item-doc-est.preco-total-me ELSE p-preco-total-me,
                             INPUT IF AVAIL item-doc-est THEN item-doc-est.desconto-me ELSE p-desconto-me,
                             INPUT tt-impto-item-docto-aux.cdn-imposto,
                             INPUT tt-impto-item-docto-aux.perc-imposto,
                             INPUT TABLE tt-impto-item-docto-aux,
                             INPUT IF AVAIL docum-est THEN docum-est.mo-codigo ELSE 0,
                             INPUT IF AVAIL docum-est THEN docum-est.cotacao-dia ELSE 0,
                             OUTPUT de-vl-base-calc,
                             OUTPUT de-vl-imposto,
                             OUTPUT de-vl-imposto-me).

            ASSIGN tt-impto-item-docto-aux.val-impto-merc-ext = de-vl-imposto-me
                   tt-impto-item-docto-aux.val-impto          = de-vl-imposto.
        END.
    END.

    IF  i-pais-impto-usuario = 17 THEN DO:
        IF  VALID-HANDLE(h-col114) THEN
            RUN pi-item IN h-col114 (INPUT docum-est.cod-emitente,
                                     INPUT p-it-codigo,
                                     INPUT c-estabel,
                                     INPUT docum-est.cotacao-dia,
                                     INPUT p-preco-total-me,
                                     INPUT p-sequencia,
                                     INPUT docum-est.nat-operacao,
                                     INPUT docum-est.nro-docto,
                                     INPUT docum-est.serie-docto,
                                     INPUT-OUTPUT TABLE tt-impto-item-docto-aux).
    END.

    IF  i-pais-impto-usuario = 2       
    AND docum-est.nff /*Fatura*/
    AND VALID-HANDLE(h-boar2006) THEN DO:
        RUN calcularImpostoPercep IN h-boar2006 (INPUT p-it-codigo,
                                                 INPUT p-sequencia,
                                                 INPUT ROWID(docum-est),
                                                 INPUT p-preco-total-me,
                                                 INPUT-OUTPUT TABLE tt-impto-item-docto-aux).
    END.
   
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-valor-original-impto DBOProgram 
PROCEDURE pi-retorna-valor-original-impto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-emitente LIKE impto-item-docto.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER pnat-operacao LIKE impto-item-docto.nat-operacao NO-UNDO.
    DEFINE INPUT  PARAMETER pserie-docto  LIKE impto-item-docto.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER pnro-docto    LIKE impto-item-docto.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER pcdn-imposto  LIKE impto-item-docto.cdn-imposto  NO-UNDO.
    DEFINE OUTPUT PARAMETER pval-impto    LIKE impto-item-docto.val-impto    NO-UNDO.

    FOR EACH bf{&TableName} NO-LOCK
        WHERE bf{&TableName}.cod-emitente = pcod-emitente 
        AND   bf{&TableName}.nat-operacao = pnat-operacao 
        AND   bf{&TableName}.serie-docto  = pserie-docto  
        AND   bf{&TableName}.nro-docto    = pnro-docto    
        AND   bf{&TableName}.cdn-imposto  = pcdn-imposto  :

        ASSIGN pval-impto = pval-impto + bf{&TableName}.val-impto.
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

