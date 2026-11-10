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
{include/i-prgvrs.i BOCX390 2.00.00.011 } /*** "010011" 14/11/2025 16:15:32 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX390
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName despes-adic
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
{cxbo/bocx390.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bf_decla-import FOR decla-import.
DEFINE VARIABLE c-erro         AS CHARACTER   NO-UNDO.
DEF VAR inum-di-ems like decla-import.num-di-ems no-undo.
DEF VAR inum-adic   LIKE decla-import.num-adic   NO-UNDO.
DEF VAR dcdd-siscomex-dts LIKE decla-import.cdd-siscomex-dts NO-UNDO.
DEF VAR c-mensagem  AS CHAR                      NO-UNDO.

DEF VAR l-automatico AS LOGICAL INITIAL NO       NO-UNDO.

{cdp/cd4300.i3}  /* include tratamento atributo livre */
{cxbo/bocx250.i50} /* include tratamento atributo livre */
def var i-cod-desp-ii     like desp-imp.cod-desp              no-undo.

DEFINE VARIABLE i-cdn-moeda-old              LIKE despes-adic.cdn-moeda              NO-UNDO.
DEFINE VARIABLE d-val-despes-old             LIKE despes-adic.val-despes             NO-UNDO.
DEFINE VARIABLE l-log-forma-preco-compra-old LIKE despes-adic.log-forma-preco-compra  NO-UNDO.
DEFINE VARIABLE l-log-incid-vmle-old         LIKE despes-adic.log-incid-vmle         NO-UNDO.


DEF VAR i-cdn-despes-siscomex AS INTEGER NO-UNDO. 
DEF VAR i-cdn-emit-siscomex   AS INTEGER NO-UNDO.
DEF VAR l-taxa-siscomex       AS LOGICAL NO-UNDO.

DEFINE VARIABLE h-bocx383 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx406 AS HANDLE NO-UNDO.

DEFINE VARIABLE l-nt2024002   AS logical NO-UNDO.

ASSIGN l-nt2024002 = CAN-FIND(FIRST funcao NO-LOCK
                              WHERE funcao.cd-funcao = "spp-NT2024002":U AND funcao.ativo).

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
         HEIGHT             = 14.75
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-atualiza-log-pend-rat.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN pi-atualiza-log-pend-rat.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* validar se o valor foi alterado, se sim, ent∆o rodar a pi-atualiza-log-pend-rat */
IF i-cdn-moeda-old              <> RowObject.cdn-moeda              OR
   d-val-despes-old             <> RowObject.val-despes             OR
   l-log-forma-preco-compra-old <> RowObject.log-forma-preco-compra OR
   l-log-incid-vmle-old         <> RowObject.log-incid-vmle         THEN DO:

    RUN pi-atualiza-log-pend-rat.
END.

IF NOT VALID-HANDLE(h-bocx406) THEN
    RUN cxbo/bocx406.p PERSISTEN SET h-bocx406.
/* busca c¢dido da taxa siscomex da param-imp */
RUN pi-busca-despes-siscomex IN h-bocx406(INPUT  RowObject.num-di-ems,
                                          INPUT  RowObject.cdd-siscomex-dts,
                                          OUTPUT i-cdn-despes-siscomex,
                                          OUTPUT i-cdn-emit-siscomex,
                                          OUTPUT l-taxa-siscomex).



IF RowObject.val-despes      > 0 AND
   RowObject.cdn-despes      = i-cdn-despes-siscomex and
   l-taxa-siscomex THEN DO:

    FOR EACH decla-import-ord NO-LOCK
            WHERE decla-import-ord.num-adic = RowObject.num-adic:

        
        FOR FIRST ordens-embarque EXCLUSIVE-LOCK
                WHERE ordens-embarque.cod-estabel  = decla-import-ord.cod-estab
                AND   ordens-embarque.embarque     = decla-import-ord.cod-embarq
                AND   ordens-embarque.numero-ordem = decla-import-ord.num-ordem
                AND   ordens-embarque.parcela      = decla-import-ord.num-parcela:
            
            &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
                ASSIGN ordens-embarque.val-tax-siscomex = RowObject.val-despes.
            &ELSE
                OVERLAY(ordens-embarque.char-1,64,16) = STRING(TRUNCATE(RowObject.val-despes,5) * 100000).
            &ENDIF

        END.
    END.

    /* atualiza o total das despesas da taxa de siscomex na di */
    IF NOT VALID-HANDLE(h-bocx383) THEN
        RUN cxbo/bocx383.p PERSISTEN SET h-bocx383.

    RUN pi-totaliza-taxa-siscomex IN h-bocx383(INPUT RowObject.num-di-ems,
                                               INPUT RowObject.cdd-siscomex-dts).
END.

IF VALID-HANDLE(h-bocx383) THEN 
    DELETE PROCEDURE h-bocx383.
ASSIGN h-bocx383 = ?.
IF VALID-HANDLE(h-bocx406) THEN 
    DELETE PROCEDURE h-bocx406.
ASSIGN h-bocx406 = ?.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* validar se o valor foi alterado, se sim, ent∆o rodar a pi-atualiza-log-pend-rat */
    FOR FIRST bfdespes-adic NO-LOCK
        WHERE bfdespes-adic.num-di-ems       = RowObject.num-di-ems
        AND   bfdespes-adic.num-adic         = RowObject.num-adic
        AND   bfdespes-adic.cdn-despes       = RowObject.cdn-despes
        AND   bfdespes-adic.cdn-emit-despes  = RowObject.cdn-emit-despes
        AND   bfdespes-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
    
        ASSIGN i-cdn-moeda-old               = bfdespes-adic.cdn-moeda
               d-val-despes-old              = bfdespes-adic.val-despes
               l-log-forma-preco-compra-old  = bfdespes-adic.log-forma-preco-compra
               l-log-incid-vmle-old          = bfdespes-adic.log-incid-vmle.
    
    END.
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
        WHEN "cod-incoterm-rat":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm-rat.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
        WHEN "val-cotac-despes-compltar":U THEN ASSIGN pFieldValue = RowObject.val-cotac-despes-compltar.
        WHEN "val-despes":U THEN ASSIGN pFieldValue = RowObject.val-despes.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
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
        WHEN "cdn-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cdn-cond-pag.
        WHEN "cdn-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-despes.
        WHEN "cdn-emit-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-emit-despes.
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
        WHEN "cdn-pto-control":U THEN ASSIGN pFieldValue = RowObject.cdn-pto-control.
        WHEN "idi-despes":U THEN ASSIGN pFieldValue = RowObject.idi-despes.
        WHEN "idi-orig-despes":U THEN ASSIGN pFieldValue = RowObject.idi-orig-despes.
        WHEN "num-adic":U THEN ASSIGN pFieldValue = RowObject.num-adic.
        WHEN "num-di-ems":U THEN ASSIGN pFieldValue = RowObject.num-di-ems.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice ddspsdc-id
  Parameters:  
               retorna valor do campo num-di-ems
               retorna valor do campo num-adic
               retorna valor do campo cdn-despes
               retorna valor do campo cdn-emit-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnum-di-ems LIKE despes-adic.num-di-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-adic LIKE despes-adic.num-adic NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-despes LIKE despes-adic.cdn-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-emit-despes LIKE despes-adic.cdn-emit-despes NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdd-siscomex-dts LIKE despes-adic.cdd-siscomex-dts NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnum-di-ems = RowObject.num-di-ems
           pnum-adic = RowObject.num-adic
           pcdn-despes = RowObject.cdn-despes
           pcdn-emit-despes = RowObject.cdn-emit-despes
           pcdd-siscomex-dts = RowObject.cdd-siscomex-dts.

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
        WHEN "log-forma-preco-compra":U THEN ASSIGN pFieldValue = RowObject.log-forma-preco-compra.
        WHEN "log-incid-vmle":U THEN ASSIGN pFieldValue = RowObject.log-incid-vmle.
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
  Purpose:     Reposiciona registro com base no °ndice ddspsdc-id
  Parameters:  
               recebe valor do campo num-di-ems
               recebe valor do campo num-adic
               recebe valor do campo cdn-despes
               recebe valor do campo cdn-emit-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnum-di-ems LIKE despes-adic.num-di-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-adic LIKE despes-adic.num-adic NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-despes LIKE despes-adic.cdn-despes NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-emit-despes LIKE despes-adic.cdn-emit-despes NO-UNDO.
    DEFINE INPUT PARAMETER pcdd-siscomex-dts LIKE despes-adic.cdd-siscomex-dts NO-UNDO.

    FIND FIRST bfdespes-adic WHERE 
        bfdespes-adic.num-di-ems = pnum-di-ems AND 
        bfdespes-adic.num-adic = pnum-adic AND 
        bfdespes-adic.cdn-despes = pcdn-despes AND 
        bfdespes-adic.cdn-emit-despes = pcdn-emit-despes AND 
        bfdespes-adic.cdd-siscomex-dts = pcdd-siscomex-dts NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdespes-adic THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdespes-adic)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByDI DBOProgram 
PROCEDURE openQueryByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME} NO-LOCK
                            WHERE {&TABLENAME}.num-di-ems = inum-di-ems
                              AND {&TABLENAME}.cdd-siscomex-dts = dcdd-siscomex-dts
                            BY {&TABLENAME}.num-adic INDEXED-REPOSITION.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumDIEMS DBOProgram 
PROCEDURE openQueryByNumDIEMS :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QUERYNAME} FOR EACH  {&TABLENAME}
                            WHERE {&TABLENAME}.num-di-ems = inum-di-ems 
                            AND   {&TABLENAME}.num-adic   = inum-adic 
                            AND   {&TABLENAME}.cdd-siscomex-dts = dcdd-siscomex-dts NO-LOCK INDEXED-REPOSITION.
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-log-pend-rat DBOProgram 
PROCEDURE pi-atualiza-log-pend-rat :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR LAST decla-import EXCLUSIVE-LOCK
    WHERE decla-import.num-di-ems = RowObject.num-di-ems
      AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts:
    FOR FIRST despes-decla-import 
        WHERE despes-decla-import.num-di-ems      = RowObject.num-di-ems
          AND despes-decla-import.cdn-pto-control = RowObject.cdn-pto-control 
          AND despes-decla-import.cdn-despes      = RowObject.cdn-despes
          AND despes-decla-import.cdn-emit-despes = RowObject.cdn-emit-despes 
          AND despes-decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts NO-LOCK:

        IF despes-decla-import.idi-tip-incid-nf = 1 THEN /*1-Despesa Nacionalizaá∆o, 2-Despesa Complementar*/
            ASSIGN decla-import.log-pend-rat = NO.
        ELSE
            &if "{&bf_mat_versao_ems}" < "2.09" &then
                ASSIGN OVERLAY(decla-import.cod-livre-1,1,1) = "N"
                       decla-import.log-livre-2              = NO.
            &ELSE
                ASSIGN decla-import.log-pend-despes-compltar = NO
                       decla-import.log-pend-impto           = NO.
            &ENDIF
    END.
END.

RELEASE decla-import.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-l-automatico DBOProgram 
PROCEDURE pi-seta-l-automatico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM p-automatico AS LOGICAL NO-UNDO.

    ASSIGN l-automatico = p-automatico.
              
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateCreate DBOProgram 
PROCEDURE pi-validateCreate :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    FOR FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = RowObject.num-di-ems
          AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts,
        FIRST param-imp NO-LOCK
        WHERE param-imp.cod-estabel = decla-import.cod-estab : END.
    
    FIND FIRST param-imp-trib NO-LOCK
         WHERE param-imp-trib.cod-estabel = decla-import.cod-estab NO-ERROR.
        
    /* valida se j† n∆o h† cadastrado uma despes-adic para a chave prim†ria */
    IF CAN-FIND(FIRST despes-adic
                    WHERE despes-adic.num-di-ems      = RowObject.num-di-ems
                    AND   despes-adic.num-adic        = RowObject.num-adic
                    AND   despes-adic.cdn-despes      = RowObject.cdn-despes
                    AND   despes-adic.cdn-emit-despes = RowObject.cdn-emit-despes
                    AND   despes-adic.cdd-siscomex-dts = RowObject.cdd-siscomex-dts) THEN DO:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-despesa-da-adicao AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Despesa_da_Adiá∆o" *}
         ASSIGN c-lbl-liter-despesa-da-adicao = TRIM(RETURN-VALUE).
         {method/svc/errors/inserr.i &ErrorNumber="1"
                                     &ErrorType="EMS"
                                     &ErrorSubType="ERROR" 
                                     &ErrorParameters="c-lbl-liter-despesa-da-adicao"}
    END.
    /* fim - valida se j† n∆o h† cadastrado uma despes-adic para a chave prim†ria */

    /* validaá∆o para n∆o permitir cadastrar duas despesas com mesmo c¢digo para a mesma DI */
    IF CAN-FIND(FIRST despes-decla-import
                    WHERE despes-decla-import.num-di-ems = RowObject.num-di-ems
                    AND   despes-decla-import.cdn-despes = RowObject.cdn-despes
                    AND   RowObject.idi-orig-despes        = 1
                    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
                        AND  RowObject.cdn-despes <> param-imp.cdn-despes-siscomex
                    &ELSE
                        AND RowObject.cdn-despes <> INTEGER(SUBSTR(param-imp.char-1,91,5))
                    &ENDIF) 
                    AND despes-decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts
                    THEN DO:
        
        ASSIGN c-mensagem = 'Despesa ' + string(RowObject.cdn-despes) + ' j† inclusa na Declaraá∆o Importaá∆o ' + string(RowObject.num-di-ems).
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-inclusao-de-despesa-nao-permit AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Inclus∆o_de_Despesa_n∆o_permitida" *}
        ASSIGN c-lbl-liter-inclusao-de-despesa-nao-permit = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-inclusao-de-despesa-nao-permit + '!' + '~~~~' + c-mensagem"}.
    END.
    /* fim - validaá∆o para n∆o permitir cadastrar duas despesas com mesmo c¢digo para a mesma DI */

    {cdp/cd4300.i4 "yes" param-imp.char-1}
    {cxbo/bocx250.i51 "yes"}
    
    assign i-cod-desp-ii     = i-desp-ii-i50.

    /*--- Verificaá∆o se a despesa Ç uma despesa de imposto ---*/
    IF  RowObject.cdn-despes = param-imp.cdn-despes-impto-ipi    
    OR  RowObject.cdn-despes = param-imp.cdn-despes-impto-icms   
    OR  RowObject.cdn-despes = param-imp.cdn-despes-impto-cofins 
    OR  RowObject.cdn-despes = param-imp.cdn-despes-impto-pis 
    OR  RowObject.cdn-despes = i-cod-desp-ii THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-despesa-parametrizada-como-des AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Despesa_parametrizada_como_despesa_de_imposto" *}
        ASSIGN c-lbl-liter-despesa-parametrizada-como-des = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-esta-despesa-esta-parametrizad AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Esta_despesa_esta_parametrizada_como_despesa_de_imposto_nos_parÉmetros_do_m¢dulo_(im0000)_n∆o_sendo_poss°vel_incluir_na_Adiá∆o_da_Declaraá∆o_de_Importaá∆o" *}
        ASSIGN c-lbl-liter-esta-despesa-esta-parametrizad = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-despesa-parametrizada-como-des + '!' + '~~~~' + c-lbl-liter-esta-despesa-esta-parametrizad + '!'"}
    END.
    
    IF l-nt2024002 AND AVAIL param-imp-trib THEN DO:
        IF  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-CBS    
        OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IBSUF   
        OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IS 
        OR  RowObject.cdn-despes = param-imp-trib.cdn-despes-impto-IBSMun THEN DO:
            DEFINE VARIABLE c-liter-despesa AS CHARACTER NO-UNDO.
            DEFINE VARIABLE c-liter-despesa-parametrizada AS CHARACTER NO-UNDO.
            ASSIGN c-liter-despesa = "Despesa parametrizada como despesa de imposto":U.
            ASSIGN c-liter-despesa-parametrizada = "Esta despesa esta parametrizada como despesa de imposto nos parÉmetros do m¢dulo (im0000) n∆o sendo poss°vel incluir na Adiá∆o da Declaraá∆o de Importaá∆o":U.
            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS"
                                        &ErrorParameters="c-liter-despesa + '!' + '~~~~' + c-liter-despesa-parametrizada + '!'"}
        END.
    END.
    
    IF  CAN-FIND(FIRST desp-imp 
                 WHERE desp-imp.cod-desp = RowObject.cdn-despes 
                 AND   desp-imp.inc-val-frete)
    AND RowObject.idi-orig-despes = 1 /* Adiá∆o */ THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-despesa-incide-valor-de-frete AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Despesa_incide_valor_de_Frete._Procedimento_incorreto" *}
        ASSIGN c-lbl-liter-despesa-incide-valor-de-frete = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-despesas-de-frete-serao-permit AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Despesas_de_frete_ser∆o_permitidas_apenas_na_Declaraá∆o_de_Importaá∆o" *}
        ASSIGN c-lbl-liter-despesas-de-frete-serao-permit = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-despesa-incide-valor-de-frete + '.' + '~~~~' + c-lbl-liter-despesas-de-frete-serao-permit"}
        LEAVE.                          
    END. /* IF  CAN-FIND(FIRST desp-imp */

    IF  CAN-FIND(FIRST desp-imp 
                 WHERE desp-imp.cod-desp = RowObject.cdn-despes 
                 AND   desp-imp.inc-val-seguro)
    AND RowObject.idi-orig-despes = 1 /* Adiá∆o */ THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-despesa-incide-valor-de-seguro AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Despesa_incide_valor_de_Seguro._Procedimento_incorreto" *}
        ASSIGN c-lbl-liter-despesa-incide-valor-de-seguro = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-despesas-de-seguro-serao-permi AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Despesas_de_seguro_ser∆o_permitidas_apenas_na_Declaraá∆o_de_Importaá∆o" *}
        ASSIGN c-lbl-liter-despesas-de-seguro-serao-permi = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorParameters="c-lbl-liter-despesa-incide-valor-de-seguro + '.' + '~~~~' + c-lbl-liter-despesas-de-seguro-serao-permi"}
        LEAVE.                          
    END. /* IF CAN-FIND(FIRST desp-imp */

    /*--- Validando o Rateio Siscomex [ IM0000 ]------------------------------*/
    IF l-automatico = NO THEN DO:
        &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
            IF  (param-imp.log-tax-siscomex 
            AND  param-imp.cdn-despes-siscomex = RowObject.cdn-desp)
        &ELSE
            IF  (SUBSTR(param-imp.char-1,105,1) = '1' /* YES */
            AND  SUBSTR(param-imp.char-1,91,5)  = string(RowObject.cdn-despes))
        &ENDIF
                AND RowObject.idi-orig-despes = 1 /* Adiá∆o */ THEN DO:
                    {method/svc/errors/inserr.i &ErrorNumber="33677"
                                                &ErrorType="EMS"}
                    LEAVE.                          
            END.
    END.
    /*------------------------------------------------------------------------*/
    run pi-validateFields (INPUT pType).   
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateDelete DBOProgram 
PROCEDURE pi-validateDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateFields DBOProgram 
PROCEDURE pi-validateFields :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    ASSIGN c-erro = "".
   
    IF  pType <> "DELETE" THEN DO:
        if not can-find(moeda where moeda.mo-codigo = rowObject.cdn-moeda) then do:
            {method/svc/errors/inserr.i &ErrorNumber="151"
                                        &ErrorType="EMS"
                                        &ErrorParameters= rowObject.cdn-moeda}
        end. /* if not can-find(moeda where moeda.mo-codigo = rowObject.cdn-moed) then do: */
    
        if not can-find(cond-pagto where cond-pagto.cod-cond-pag = rowObject.cdn-cond-pag) then do:
            {method/svc/errors/inserr.i &ErrorNumber="8303"
                                        &ErrorType="EMS"
                                        &ErrorParameters= rowObject.cdn-cond-pag}
        end. /* if not can-find(cond-pagto where cond-pagto.cod-cond-pag = rowObject.cdn-cond-pag) then do: */
         
        IF NOT l-automatico THEN DO:
            if rowObject.val-despes = 0 then do:
                {utp/ut-field.i mgcex desp-embarque val-desp 1}
                {method/svc/errors/inserr.i &ErrorNumber="265"
                                            &ErrorType="EMS"
                                            &ErrorParameters= RETURN-VALUE} 
            end. /* if rowObject.val-desp = 0 then do: */
        END.

        /* Verifica se o Incoterm de rateio esta disponivel no Cad. de Incoterms */
        if  rowObject.cod-incoterm-rat <> "" then do:
            for first inco-cx fields (cod-incoterm)
                where inco-cx.cod-incoterm = rowObject.cod-incoterm-rat no-lock: end.
            if  avail inco-cx then do:
                for first desp-incoterm fields (cod-desp)
                    where desp-incoterm.cod-incoterm = inco-cx.cod-incoterm
                    and   desp-incoterm.cod-desp     = rowObject.cdn-despes no-lock: end.
                if  avail desp-incoterm then do:
                    /* A incoterm de rateio informada nao deve conter em sua 
                       parametrizacao a propria despesa a ser rateada        */
    
                    ASSIGN c-erro = inco-cx.cod-incoterm + "~~" + string(rowObject.cdn-despes).
    
                    {method/svc/errors/inserr.i &ErrorNumber="30164"
                                                &ErrorType="EMS"
                                                &ErrorParameters= c-erro} 
                end. /* if  avail desp-incoterm then do: */
            end. /* if  avail inco-cx then do: */
            else do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-incoterm AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Incoterm" *}
                ASSIGN c-lbl-liter-incoterm = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                      &ErrorNumber="2"
                      &ErrorType="EMS"
                      &ErrorParameters="c-lbl-liter-incoterm"} 
            end. /* else do: */
        end. /* if  rowObject.cod-incoterm-rat <> "" then do: */
    END. /* IF  pType <> "DELETE" THEN DO: */
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateUpdate DBOProgram 
PROCEDURE pi-validateUpdate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.


    FIND FIRST decla-import NO-LOCK
        WHERE decla-import.num-di-ems = RowObject.num-di-ems 
          AND decla-import.cdd-siscomex-dts = RowObject.cdd-siscomex-dts NO-ERROR.
    FIND FIRST param-imp NO-LOCK
            WHERE param-imp.cod-estabel = decla-import.cod-estab NO-ERROR.
    
    &IF '{&BF_MAT_VERSAO_EMS}' >= '2.07' &THEN
        ASSIGN i-cdn-despes-siscomex = param-imp.cdn-despes-siscomex.
    &ELSE
        ASSIGN i-cdn-despes-siscomex = INTEGER(SUBSTRING(param-imp.char-1,91,5)).
    &ENDIF
    
    IF i-cdn-despes-siscomex = RowObject.cdn-despes AND
       RowObject.val-despes < 1 
        AND NOT l-automatico THEN DO:
       {method/svc/errors/inserr.i &ErrorNumber="33677"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR" 
                                   &ErrorParameters="''"}
    END.
    
    run pi-validateFields (INPUT pType).
   
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piContaRegistro DBOProgram 
PROCEDURE piContaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    
    def  input param pnum-di-ems    like bf{&TableName}.num-di-ems no-undo.
    def  input param pnum-adic      like bf{&TableName}.num-adic   no-undo.
    DEF  INPUT PARAM pcdd-siscomex-dts LIKE bf{&TableName}.cdd-siscomex-dts NO-UNDO.
    def output param pnum-registros as   integer no-undo.

    def var i-conta as integer no-undo.

    assign i-conta = 0.

    for each  bf{&TABLENAME} no-lock 
        where bf{&TABLENAME}.num-di-ems = pnum-di-ems
        AND   bf{&TABLENAME}.num-adic   = pnum-adic
        AND   bf{&TABLENAME}.cdd-siscomex-dts = pcdd-siscomex-dts:
        assign i-conta = i-conta + 1.
    end. /* for each  decla-import-ord */

    assign pnum-registros = i-conta.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDadosDI DBOProgram 
PROCEDURE piRetornaDadosDI :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/

    DEF  INPUT PARAM pnum-di-ems        LIKE bf{&TableName}.num-di-ems    NO-UNDO.
    DEF  INPUT PARAM pcdd-siscomex-dts  LIKE bf{&TableName}.cdd-siscomex-dts NO-UNDO.
    def output param pc_cod-di-siscomex LIKE decla-import.cod-di-siscomex NO-UNDO.
    def output param pi_num-seq-retif   LIKE decla-import.num-seq-retif   NO-UNDO.
    def output param pc_cod-estab       LIKE decla-import.cod-estab       NO-UNDO.
    def output param pd_dat-di          LIKE decla-import.dat-di          NO-UNDO.
    
    FOR FIRST bf_decla-import NO-LOCK
        WHERE bf_decla-import.num-di-ems = pnum-di-ems
          AND bf_decla-import.cdd-siscomex-dts = pcdd-siscomex-dts:
        ASSIGN pc_cod-di-siscomex = bf_decla-import.cod-di-siscomex
               pi_num-seq-retif   = bf_decla-import.num-seq-retif   
               pc_cod-estab       = bf_decla-import.cod-estab       
               pd_dat-di          = bf_decla-import.dat-di.
    END. /* FOR FIRST bf_decla-import */

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByDI DBOProgram 
PROCEDURE setConstraintByDI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms       LIKE {&TABLENAME}.num-di-ems       NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&TABLENAME}.cdd-siscomex-dts NO-UNDO.

ASSIGN inum-di-ems = pNumDiEms
       dcdd-siscomex-dts = pCddSiscomexDts.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintByNumDIEMS DBOProgram 
PROCEDURE setConstraintByNumDIEMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNumDiEms LIKE {&tablename}.num-di-ems NO-UNDO.
DEF INPUT PARAM pNumAdic  LIKE {&tablename}.num-adic   NO-UNDO.
DEF INPUT PARAM pCddSiscomexDts LIKE {&tablename}.cdd-siscomex-dts NO-UNDO.

ASSIGN inum-di-ems = pNumDiEms
       inum-adic   = pNumAdic
       dcdd-siscomex-dts = pCddSiscomexDts.

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
    
    IF pType = "CREATE" THEN RUN pi-validateCreate(INPUT pType).
    IF pType = "UPDATE" THEN RUN pi-validateUpdate(INPUT pType).
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

