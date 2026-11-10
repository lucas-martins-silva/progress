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
{include/i-prgvrs.i BOCX367 2.00.00.065 } /*** "010065" 14/11/2025 13:37:39 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx367 MUT}
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
&GLOBAL-DEFINE DBOName BOCX367
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName wt-docto-despes
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
{cxbo/bocx367.i rowobject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF TEMP-TABLE tt-{&TableName}-aux NO-UNDO
    LIKE rowObject.

DEF TEMP-TABLE tt-param-nota-proc NO-UNDO
    FIELD cod-emitente-desp      AS CHAR FORMAT "X(10)"     
    FIELD cod-cond-pagto         AS CHAR FORMAT "X(10)"        
    FIELD cod-itiner             AS CHAR FORMAT "X(10)"          
    FIELD cod-pto-contr          AS CHAR FORMAT "X(10)"       
    FIELD mo-codigo              AS CHAR FORMAT "X(10)"           
    FIELD dat-base-cobr-despes   AS CHAR FORMAT "X(10)"
    FIELD log-forma-preco        AS CHAR FORMAT "X(10)"     
    FIELD log-despes-integr-ap   AS CHAR FORMAT "X(10)"
    FIELD cdn-classif-despes     AS CHAR FORMAT "X(10)".   
        
/**** Temp-tables e vari†veis tela MD - Projeto Drawback Integrado *****/
DEFINE VARIABLE hTable       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cQuery       AS CHARACTER NO-UNDO.
DEFINE VARIABLE iInitialPage AS INTEGER   NO-UNDO.
DEFINE VARIABLE hTTReturn    AS HANDLE    NO-UNDO.
DEFINE VARIABLE hbTTReturn   AS HANDLE    NO-UNDO.
DEFINE VARIABLE iPageSize    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iCurrentPage AS INTEGER   NO-UNDO.
DEFINE VARIABLE h-cdapi050   AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx200    AS HANDLE    NO-UNDO.
DEFINE VARIABLE d-date       AS DATE      NO-UNDO.


DEFINE TEMP-TABLE ttEmbarquesDespExp NO-UNDO
    FIELD embarque   AS DECIMAL
    FIELD codEstabel AS CHARACTER
    FIELD dtEmbarque AS DATE.

DEFINE TEMP-TABLE ttResumosDespExp NO-UNDO
    FIELD resumo AS INTEGER LABEL "Resumo".

DEFINE TEMP-TABLE ttDespesasExp NO-UNDO
    FIELD codEmitenteDesp   AS INTEGER   LABEL "Fornecedor"
    FIELD cdnDespes         AS INTEGER   LABEL "Despesa"
    FIELD descDespes        AS CHARACTER LABEL "Descriá∆o"
    FIELD codPtoContr       AS INTEGER   LABEL "Ponto Controle"
    FIELD moCodigo          AS INTEGER   LABEL "Moeda"
    FIELD valMoedaDesp      AS DECIMAL   LABEL "Vl Mo Despesa"
    FIELD valDespesPed      AS DECIMAL   LABEL "Vl Mo Pedido"
    FIELD datPagto          AS DATE      LABEL "Data Pagamento"
    FIELD integraAp         AS LOGICAL   LABEL "AP"
    FIELD formaPreco        AS LOGICAL   LABEL "Forma Preáo"
    FIELD descClassDespes   AS CHARACTER LABEL "Classificaá∆o"
    FIELD comisAgentes      AS LOGICAL   LABEL "Comis. Agente"
    FIELD classDespes       AS INTEGER   LABEL "C¢digo Classificaá∆o"
    FIELD codCondPagto      AS INTEGER   LABEL "Cond. Pagamento"
    FIELD codItiner         AS INTEGER   LABEL "Itiner†rio"
    FIELD seqWtDocto        AS INTEGER   LABEL "Seq Documento"
    FIELD seqWtDoctoDespes  AS INTEGER   LABEL "Seq Despesa"
    FIELD log_dest_desp     AS LOGICAL   LABEL "Dest Despesa"
    FIELD log_desp_incl     AS LOGICAL   LABEL "Desp Inclusas"
    FIELD log_val_tot_fat   AS LOGICAL   LABEL "Val Total Fat Parcial".

DEFINE TEMP-TABLE ttHabilitaCampos NO-UNDO
    FIELD campo AS CHARACTER
    FIELD habilita AS LOGICAL.

DEFINE TEMP-TABLE ttRetornoEmbarquesDespExp NO-UNDO LIKE ttEmbarquesDespExp.
DEFINE TEMP-TABLE ttRetornoResumosDespExp   NO-UNDO LIKE ttResumosDespExp.
DEFINE TEMP-TABLE ttRetornoDespesasExp      NO-UNDO LIKE ttDespesasExp.
DEFINE TEMP-TABLE tt-wt-it-docto            NO-UNDO LIKE wt-it-docto.

{fch/fchmat/fchmatverifyexpenses.i ttVerifyExpensesVO}
{fch/fchmat/fchmatverifyexpenses.i ttVerifyExpensesVO2} 
/**********************************************************************/        
      
DEFINE VARIABLE c-return                AS   CHARACTER                          NO-UNDO.
DEFINE VARIABLE i-seq-wt-docto          LIKE wt-docto.seq-wt-docto              NO-UNDO.
DEFINE VARIABLE l-spp-vl-tot-fatur-parc AS   LOGICAL  INITIAL NO                NO-UNDO.
DEFINE VARIABLE de-valor-despes         AS   DECIMAL FORMAT "->>>,>>>,>>9.99":U NO-UNDO.

DEFINE BUFFER bfwt-it-docto-despes  FOR wt-it-docto-despes.
DEFINE BUFFER b-proc-ped-ent-desp   FOR proc-ped-ent-desp.

/*Verifica se funá∆o "Considera Valor Total Despesa no Faturamento Parcial"*/
ASSIGN l-spp-vl-tot-fatur-parc = CAN-FIND(funcao NO-LOCK WHERE funcao.cd-funcao = "spp-considera-tot-despesa":U AND funcao.ativo).

{exp/exapi015.i}

{include/i-getEntryField.i}

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
         WIDTH              = 42.14.
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

    /*Grava Tabela Siscoserv*/
    RUN pi-grava-siscoserv.

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

    /*Grava Tabela Siscoserv*/
    RUN pi-grava-siscoserv.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Criar o registro na tabela de extens∆o do Siscoserv*/
    FOR FIRST wt-docto NO-LOCK
        WHERE wt-docto.seq-wt-docto = rowObject.seq-wt-docto:
        /*
        Inicio - Siscoserv
        */
        IF NOT VALID-HANDLE(h-cdapi050) THEN DO:
           RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.
        END.
        RUN pi-siscoserv-ativo IN h-cdapi050.
        IF RETURN-VALUE = "OK":U THEN
            RUN pi-apaga-despes-export-sis IN h-cdapi050 (INPUT wt-docto.cod-estabel,
                                                          INPUT wt-docto.nr-proc-exp,
                                                          INPUT RowObject.cod-itiner,
                                                          INPUT RowObject.cod-pto-contr,
                                                          INPUT RowObject.cdn-despes,
                                                          INPUT RowObject.cod-emitente-desp,
                                                          INPUT RowObject.sequencia).
        IF VALID-HANDLE(h-cdapi050) THEN DO:
            DELETE PROCEDURE h-cdapi050.
            ASSIGN h-cdapi050 = ?.
        END.
        
        /*
            Fim - Siscoserv
        */
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaInfoDespesa DBOProgram 
PROCEDURE buscaInfoDespesa :
    DEFINE INPUT  PARAMETER pi-seq-wt-docto         AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER pi-seq-wt-docto-despes  AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttDespesasExp.
    DEFINE OUTPUT PARAMETER TABLE FOR ttHabilitaCampos.

    DEFINE VARIABLE i-mo-codigo       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-desc-mo-codigo  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-cod-itiner      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-desc-cod-itiner AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDescDespes       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cAction           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-situacao        AS INTEGER   NO-UNDO.

    ASSIGN cAction = IF pi-seq-wt-docto-despes = 0 THEN "create":U ELSE "update":U.

    IF cAction = "create":U THEN DO: /*Inclus∆o*/
        RUN piRetornaDados (INPUT  pi-seq-wt-docto,
                            OUTPUT i-mo-codigo,
                            OUTPUT i-desc-mo-codigo,
                            OUTPUT i-cod-itiner,
                            OUTPUT i-desc-cod-itiner).
        
        CREATE ttDespesasExp.
        ASSIGN ttDespesasExp.codItiner        = i-cod-itiner
               ttDespesasExp.codPtoContr      = 0
               ttDespesasExp.cdnDespes        = 0
               ttDespesasExp.codEmitenteDesp  = 0
               ttDespesasExp.moCodigo         = i-mo-codigo
               ttDespesasExp.codCondPagto     = 0
               ttDespesasExp.classDespes      = 1
               ttDespesasExp.datPagto         = TODAY
               ttDespesasExp.comisAgentes     = NO
               ttDespesasExp.formaPreco       = NO
               ttDespesasExp.integraAp        = YES
               ttDespesasExp.valMoedaDesp     = 0
               ttDespesasExp.valDespesPed     = 0
               ttDespesasExp.seqWtDocto       = pi-seq-wt-docto
               ttDespesasExp.seqWtDoctoDespes = 0
               ttDespesasExp.log_dest_desp    = TRUE
               ttDespesasExp.log_desp_incl    = FALSE
               ttDespesasExp.log_val_tot_fat  = FALSE.

    END.
    ELSE DO: /*Alteraá∆o*/
        RUN openQueryStatic (INPUT "Main":U).
        RUN  goToKey (INPUT pi-seq-wt-docto,
                      INPUT pi-seq-wt-docto-despes).
        FOR EACH rowobject:
            CREATE ttDespesasExp.
            ASSIGN ttDespesasExp.codItiner        = rowobject.cod-itiner
                   ttDespesasExp.codPtoContr      = rowobject.cod-pto-contr
                   ttDespesasExp.cdnDespes        = rowobject.cdn-despes
                   ttDespesasExp.codEmitenteDesp  = rowobject.cod-emitente-desp
                   ttDespesasExp.moCodigo         = rowobject.mo-codigo
                   ttDespesasExp.codCondPagto     = rowobject.cod-cond-pagto
                   ttDespesasExp.classDespes      = rowobject.cdn-classif-despes
                   ttDespesasExp.datPagto         = rowobject.dat-base-cobr-despes
                   ttDespesasExp.comisAgentes     = rowobject.log-comis-agent
                   ttDespesasExp.formaPreco       = rowobject.log-forma-preco
                   ttDespesasExp.integraAp        = rowobject.log-despes-integr-ap
                   ttDespesasExp.valMoedaDesp     = rowobject.val-despes
                   ttDespesasExp.valDespesPed     = rowobject.val-despes-ped
                   ttDespesasExp.seqWtDocto       = rowobject.seq-wt-docto
                   ttDespesasExp.seqWtDoctoDespes = rowobject.seq-wt-docto-despes
                   ttDespesasExp.log_desp_incl    = IF SUBSTRING(rowobject.cod-livre-1,1,1) = "1" THEN TRUE ELSE FALSE
                   ttDespesasExp.log_dest_desp    = IF SUBSTRING(rowobject.cod-livre-1,2,1) <> "2" THEN TRUE ELSE FALSE
                   ttDespesasExp.log_val_tot_fat  = IF SUBSTRING(rowobject.cod-livre-1,3,1) = "1" THEN TRUE ELSE FALSE.
    
            RUN piRetornaDescricaoDespesa (INPUT pi-seq-wt-docto,
                                           INPUT ttDespesasExp.cdnDespes,
                                           OUTPUT ttDespesasExp.descDespes).
        END.
    END.

    CREATE ttHabilitaCampos.
    ASSIGN ttHabilitaCampos.campo = "cod-itiner"
           ttHabilitaCampos.habilita = FALSE.

    CREATE ttHabilitaCampos.
    ASSIGN ttHabilitaCampos.campo = "cdn-despes"
           ttHabilitaCampos.habilita = IF cAction = "update":U THEN FALSE ELSE TRUE.


    FOR FIRST wt-docto FIELDS (seq-wt-docto cod-estab-proces-export)
        WHERE wt-docto.seq-wt-docto = pi-seq-wt-docto NO-LOCK:
        RUN piRetornaSituacaoMoeda (INPUT wt-docto.cod-estab-proces-export,
                                    OUTPUT i-situacao).
    END.

    CREATE ttHabilitaCampos.
    ASSIGN ttHabilitaCampos.campo = "val-despes"
           ttHabilitaCampos.habilita = i-situacao = 2.

    CREATE ttHabilitaCampos.
    ASSIGN ttHabilitaCampos.campo = "val-despes-ped"
           ttHabilitaCampos.habilita = i-situacao = 1.

    CREATE ttHabilitaCampos.
    ASSIGN ttHabilitaCampos.campo = "log_val_tot_fat"
           ttHabilitaCampos.habilita = l-spp-vl-tot-fatur-parc.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaListaClassif DBOProgram
PROCEDURE buscaListaClassif :
    DEFINE OUTPUT PARAMETER pcListaClassif AS CHARACTER NO-UNDO.

    ASSIGN pcListaClassif = {cxinc/i01cx205.i 03}.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE corrigeRowErrors DBOProgram 
PROCEDURE corrigeRowErrors :
/********************************************************************
    Elimina erros internos disparados pelo template da BO
    3 - Tabela  n∆o dispon°vel
    8 - Query est† vazia
    10 - Query est† posicionada no £ltimo registro
********************************************************************/
    FOR EACH RowErrors 
       WHERE RowErrors.ErrorType = "INTERNAL":U
         AND (RowErrors.ErrorNumber = 3 OR 
              RowErrors.ErrorNumber = 8 OR 
              RowErrors.ErrorNumber = 10):
        DELETE RowErrors.
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminarDespesas DBOProgram 
PROCEDURE eliminarDespesas :
    DEFINE INPUT  PARAMETER pi-seq-wt-docto         AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER pi-seq-wt-docto-despes  AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
   
    ASSIGN i-seq-wt-docto = pi-seq-wt-docto.
    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "WtDocto":U).
    RUN goToKey         IN THIS-PROCEDURE (INPUT pi-seq-wt-docto,
                                           INPUT pi-seq-wt-docto-despes).
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN deleteRecord IN THIS-PROCEDURE.
    END.
    RUN corrigeRowErrors.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarDespesas DBOProgram 
PROCEDURE gerarDespesas :
    DEFINE INPUT  PARAMETER p-seq-wt-docto AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-resumo    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.

    EMPTY TEMP-TABLE RowErrors.

    RUN piGeraDespesas (INPUT p-seq-wt-docto,
                        INPUT p-nr-resumo,
                        OUTPUT TABLE rowErrors).

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
        WHEN "dat-base-cobr-despes":U THEN ASSIGN pFieldValue = RowObject.dat-base-cobr-despes.
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
        WHEN "val-despes":U THEN ASSIGN pFieldValue = RowObject.val-despes.
        WHEN "val-despes-nf":U THEN ASSIGN pFieldValue = RowObject.val-despes-nf.
        WHEN "val-despes-ped":U THEN ASSIGN pFieldValue = RowObject.val-despes-ped.
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
        WHEN "cdn-classif-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-classif-despes.
        WHEN "cdn-despes":U THEN ASSIGN pFieldValue = RowObject.cdn-despes.
        WHEN "cod-cond-pagto":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pagto.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "cod-itiner":U THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        WHEN "cod-pto-contr":U THEN ASSIGN pFieldValue = RowObject.cod-pto-contr.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "seq-wt-docto":U THEN ASSIGN pFieldValue = RowObject.seq-wt-docto.
        WHEN "seq-wt-docto-despes":U THEN ASSIGN pFieldValue = RowObject.seq-wt-docto-despes.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice wtdctdsp-id
  Parameters:  
               retorna valor do campo seq-wt-docto
               retorna valor do campo seq-wt-docto-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pseq-wt-docto LIKE wt-docto-despes.seq-wt-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-wt-docto-despes LIKE wt-docto-despes.seq-wt-docto-despes NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pseq-wt-docto = RowObject.seq-wt-docto
           pseq-wt-docto-despes = RowObject.seq-wt-docto-despes.

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
        WHEN "log-comis-agent":U THEN ASSIGN pFieldValue = RowObject.log-comis-agent.
        WHEN "log-despes-integr-ap":U THEN ASSIGN pFieldValue = RowObject.log-despes-integr-ap.
        WHEN "log-forma-preco":U THEN ASSIGN pFieldValue = RowObject.log-forma-preco.
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getVerifyExpenses DBOProgram 
PROCEDURE getVerifyExpenses :
    DEFINE INPUT  PARAMETER seqWtDocto AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttVerifyExpensesVO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.
    
    def var l_achou_despesa as logical initial yes no-undo.
    find first param-global no-lock no-error.
    if  param-global.modulo-ex THEN DO:
        for first wt-docto where wt-docto.seq-wt-docto = seqWtDocto no-lock:
                find first emitente where emitente.cod-emitente = wt-docto.cod-emitente no-lock no-error.
                if avail emitente and (emitente.natureza = 3 or emitente.natureza = 4) THEN DO:

        RUN piVerificaDespesas (INPUT  wt-docto.seq-wt-docto,
                                OUTPUT l_achou_despesa).                        
                        
                end.
        end.
    end.
    create ttVerifyExpensesVO.
    assign ttVerifyExpensesVO.foundExpenses = l_achou_despesa.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getVerifyExpensesList DBOProgram 
PROCEDURE getVerifyExpensesList :
    DEFINE INPUT  PARAMETER TABLE FOR ttVerifyExpensesVO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttVerifyExpensesVO2.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    def var l_achou_despesa as logical initial yes no-undo.
    DEF BUFFER bf-ttVerifyExpensesVO2 FOR ttVerifyExpensesVO2.
    
    find first param-global no-lock no-error.

    FOR EACH ttVerifyExpensesVO:
        ASSIGN l_achou_despesa = YES.
        if  param-global.modulo-ex THEN DO:
            for first wt-docto where wt-docto.seq-wt-docto = ttVerifyExpensesVO.seqWtDocto no-lock:
                    find first emitente where emitente.cod-emitente = wt-docto.cod-emitente no-lock no-error.
                    if avail emitente and (emitente.natureza = 3 or emitente.natureza = 4) THEN DO:
        
                RUN piVerificaDespesas (INPUT  wt-docto.seq-wt-docto,
                                        OUTPUT l_achou_despesa).                    
                            
                    end.
            end.
        end.
        create ttVerifyExpensesVO2.
        assign ttVerifyExpensesVO2.foundExpenses  = l_achou_despesa
               ttVerifyExpensesVO2.seqWtDocto     = ttVerifyExpensesVO.seqWtDocto   
               ttVerifyExpensesVO2.shipmentNumber = ttVerifyExpensesVO.shipmentNumber
               ttVerifyExpensesVO2.summaryNumber  = ttVerifyExpensesVO.summaryNumber.

    END.

    /*Quando n∆o acha despesas para uma wt-docto replica o valor do foundExpenses 
    para todos os wt-doctos do mesmo embarque*/
    FOR EACH ttVerifyExpensesVO2:
        IF CAN-FIND (FIRST bf-ttVerifyExpensesVO2 
                     WHERE bf-ttVerifyExpensesVO2.shipmentNumber = ttVerifyExpensesVO2.shipmentNumber
                       AND NOT bf-ttVerifyExpensesVO2.foundExpenses) THEN
            ASSIGN ttVerifyExpensesVO2.foundExpenses = NO.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice wtdctdsp-id
  Parameters:  
               recebe valor do campo seq-wt-docto
               recebe valor do campo seq-wt-docto-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pseq-wt-docto LIKE wt-docto-despes.seq-wt-docto NO-UNDO.
    DEFINE INPUT PARAMETER pseq-wt-docto-despes LIKE wt-docto-despes.seq-wt-docto-despes NO-UNDO.

    FIND FIRST bfwt-docto-despes WHERE 
        bfwt-docto-despes.seq-wt-docto = pseq-wt-docto AND 
        bfwt-docto-despes.seq-wt-docto-despes = pseq-wt-docto-despes NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfwt-docto-despes THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfwt-docto-despes)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCodDespes DBOProgram 
PROCEDURE leaveCodDespes :
    DEFINE INPUT  PARAMETER pcCodDespes       AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER piCodEmitenteDesp AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER piClassifDesp     AS INTEGER    NO-UNDO.
    DEFINE OUTPUT PARAMETER piCodCondPagto    AS INTEGER    NO-UNDO.

    DEFINE VARIABLE h-bocx095       AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-boad098na     AS HANDLE     NO-UNDO.
    DEFINE VARIABLE c-return        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE l-desp-frete    AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-desp-seguro   AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-desp-embal    AS LOGICAL    NO-UNDO.

    
    IF pcCodDespes <> "" AND pcCodDespes <> "0" THEN DO:
        /* Sempre busca o fornecedor da despesa na inclusao, independente se o usuˇrio 
           jˇ informou. Na modificaªío nao terˇ problema pois o campo fica desabilitado */
        RUN cxbo/bocx095.p PERSISTENT SET h-bocx095.
        RUN findCodigo IN h-bocx095 (INPUT integer(pcCodDespes),
                                     OUTPUT c-return).
        IF c-return = "":U THEN DO:
            RUN GetIntField IN h-bocx095 (INPUT "cod-emitente":U,   OUTPUT piCodEmitenteDesp).
            RUN getLogField IN h-bocx095 (INPUT "inc-val-frete":U,  OUTPUT l-desp-frete).
            RUN getLogField IN h-bocx095 (INPUT "inc-val-seguro":U, OUTPUT l-desp-seguro).
            RUN getLogField IN h-bocx095 (INPUT "inc-val-embal":U,  OUTPUT l-desp-embal).
        
            IF l-desp-frete THEN
               ASSIGN piClassifDesp = 2. /*Frete*/
            ELSE
            IF l-desp-seguro THEN
               ASSIGN piClassifDesp = 3. /*Seguro*/
            ELSE
            IF l-desp-embal THEN
               ASSIGN piClassifDesp = 4. /*Embalagem*/
            ELSE
               ASSIGN piClassifDesp = 1. /*Nenhuma*/
        END.
    
        /* Busca Condiªío de Pagamento */
        IF piCodEmitenteDesp <> 0 THEN DO:
            RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
            RUN goToKey IN h-boad098na (INPUT piCodEmitenteDesp).
            IF RETURN-VALUE = "OK":U THEN DO:
               RUN getIntField IN h-boad098na (INPUT "cod-cond-pag":U, OUTPUT piCodCondPagto).
            END.
        END.
    END.
    ELSE DO:
        ASSIGN piCodEmitenteDesp = 0
               piCodCondPagto = 0
               piClassifDesp = 1.
    END.

    DELETE PROCEDURE h-bocx095.
    ASSIGN h-bocx095 = ?.

    DELETE PROCEDURE h-boad098na.
    ASSIGN h-boad098na = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveCodEmitenteDespes DBOProgram 
PROCEDURE leaveCodEmitenteDespes :
    DEFINE INPUT  PARAMETER pcCodEmitente AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER piCondPagto   AS INTEGER    NO-UNDO.

    DEFINE VARIABLE h-boad098na AS HANDLE NO-UNDO.

    IF  pcCodEmitente <> "" AND pcCodEmitente <> "0" THEN DO:
        RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
        RUN goToKey IN h-boad098na (INPUT INTEGER(pcCodEmitente)).
        IF RETURN-VALUE = "OK":U THEN DO:
           RUN getIntField IN h-boad098na (INPUT "cod-cond-pag":U, OUTPUT piCondPagto).
        END.
    END.
    ELSE 
        ASSIGN piCondPagto = 0.

    DELETE PROCEDURE h-boad098na.
    ASSIGN h-boad098na = ?.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveValorDespesa DBOProgram 
PROCEDURE leaveValorDespesa :
    DEFINE INPUT  PARAMETER piSeqWtDocto    AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER piMoeda         AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER pdeValDespes    AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeValDespesPed AS DECIMAL NO-UNDO.

    DEFINE VARIABLE i-moeda-padrao   AS INTEGER NO-UNDO.
    DEFINE VARIABLE de-taxa-exp      AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-val-despes-ped AS DECIMAL NO-UNDO.
    
    RUN piRetornaMoeda (INPUT  piSeqWtDocto,
                        OUTPUT i-moeda-padrao).

    FOR FIRST wt-docto FIELD (vl-taxa-exp) 
        WHERE wt-docto.seq-wt-docto = piSeqWtDocto NO-LOCK:
        ASSIGN de-taxa-exp = wt-docto.vl-taxa-exp.
    END.

    ASSIGN d-val-despes-ped = 0.

    IF  (i-moeda-padrao <> 0 AND piMoeda <> 0)
    AND (i-moeda-padrao <> piMoeda) THEN DO:
        RUN cdp/cd0812.p (input piMoeda,
                          INPUT 0,
                          INPUT pdeValDespes,
                          INPUT TODAY,
                          OUTPUT d-val-despes-ped).
        
        ASSIGN d-val-despes-ped = d-val-despes-ped / de-taxa-exp.
    END.
    ELSE
        IF  i-moeda-padrao  <> 0
        AND piMoeda = 0 THEN
            ASSIGN d-val-despes-ped = pdeValDespes * de-taxa-exp.
        ELSE
            ASSIGN d-val-despes-ped = pdeValDespes.

    ASSIGN pdeValDespesPed = d-val-despes-ped.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveValorDespesaMet DBOProgram 
PROCEDURE leaveValorDespesaMet :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para chamar as procedures leaveValorDespesa ou o 
                leaveValorDespesaPed do Metadados, pois n∆o passa decimal
  Parameters:  piSeqWtDocto   -> N£mero da Sequància do Documento
               piMoeda        -> Moeda
               pcValDespes    -> Valor da Despesa
               pcValDespesPed -> Retorna Valor Convertido
               pcPedido       -> Se Chama a procedure do pedido ou n∆o
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER piSeqWtDocto     AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER piMoeda          AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcValDespes      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcValDespesCalc  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pcPedido         AS CHARACTER NO-UNDO.

    /*Vari†vel de Convers∆o*/
    DEFINE VARIABLE deValDespes     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deValDespesCalc AS DECIMAL     NO-UNDO.

    ASSIGN pcValDespes = REPLACE(pcValDespes,".",",").

    ASSIGN deValDespes = DECIMAL(pcValDespes).

    IF pcPedido = "pedido":U THEN
        RUN leaveValorDespPed (input piSeqWtDocto,
                               input piMoeda,
                               input deValDespes,
                               output deValDespesCalc).
    ELSE
       RUN leaveValorDespesa (input piSeqWtDocto,
                              input piMoeda,
                              input deValDespes,
                              output deValDespesCalc).

    ASSIGN pcValDespesCalc = STRING(deValDespesCalc).
    ASSIGN pcValDespesCalc = REPLACE(pcValDespesCalc,",",".").
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE leaveValorDespPed DBOProgram 
PROCEDURE leaveValorDespPed :
    DEFINE INPUT  PARAMETER piSeqWtDocto    AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER piMoeda         AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER pdeValDespesPed AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pdeValDespes    AS DECIMAL NO-UNDO.

    DEFINE VARIABLE i-moeda-padrao  AS INTEGER NO-UNDO.
    DEFINE VARIABLE de-taxa-exp     AS DECIMAL NO-UNDO.
    DEFINE VARIABLE d-val-despes    AS DECIMAL NO-UNDO.

    RUN piRetornaMoeda (INPUT  piSeqWtDocto,
                        OUTPUT i-moeda-padrao).

    FOR FIRST wt-docto FIELD (vl-taxa-exp) 
        WHERE wt-docto.seq-wt-docto = piSeqWtDocto NO-LOCK:
        ASSIGN de-taxa-exp = wt-docto.vl-taxa-exp.
    END.

    ASSIGN d-val-despes = 0.

    IF  (i-moeda-padrao <> 0 AND piMoeda <> 0)
    AND (i-moeda-padrao <> piMoeda) THEN DO:

        RUN cdp/cd0812.p (input piMoeda,
                          INPUT 0,
                          INPUT pdeValDespesPed,
                          INPUT TODAY,
                          OUTPUT d-val-despes).
        
            ASSIGN d-val-despes = d-val-despes / de-taxa-exp.
    END.
    ELSE
        IF  i-moeda-padrao  <> 0
        AND piMoeda = 0 THEN DO:
            IF i-pais-impto-usuario <> 1 THEN
                ASSIGN d-val-despes = d-val-despes * de-taxa-exp.
            ELSE
                ASSIGN d-val-despes = d-val-despes / de-taxa-exp.

        END.
        ELSE
            ASSIGN d-val-despes = pdeValDespesPed.

    ASSIGN pdeValDespes = d-val-despes.

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

    OPEN QUERY qr{&TableName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryWtDocto DBOProgram 
PROCEDURE openQueryWtDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY qr{&TableName} FOR EACH {&TableName} NO-LOCK
                                 WHERE {&TableName}.seq-wt-docto = i-seq-wt-docto INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-vl-despesas DBOProgram 
PROCEDURE pi-calcula-vl-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-seq-wt-docto LIKE wt-docto.seq-wt-docto         NO-UNDO.
    DEFINE OUTPUT PARAMETER p-total-despes AS DEC FORMAT "->>,>>>,>>>,>>9.99" NO-UNDO.

    DEF VAR d-vl-despesa AS DEC NO-UNDO.

    FOR EACH wt-docto-despes NO-LOCK
       WHERE wt-docto-despes.seq-wt-docto = p-seq-wt-docto
         AND wt-docto-despes.log-forma-preco
         AND wt-docto-despes.log-comis-agent:

        ASSIGN p-total-despes = p-total-despes
                              + wt-docto-despes.val-despes-ped.
        
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-grava-siscoserv DBOProgram 
PROCEDURE pi-grava-siscoserv :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para a gravaá∆o da tabela Extens∆o do Siscoserv
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*
        Inicio Siscoserv
        Grava as informaá‰es na tabela de extens∆o para depois enviar para o siscoserv
    */
    IF NOT VALID-HANDLE(h-bocx200) THEN DO:
       RUN cxbo/bocx200.p PERSISTENT SET h-bocx200.
    END.

    IF NOT VALID-HANDLE(h-cdapi050) THEN DO:
       RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.
    END.
    RUN pi-siscoserv-ativo IN h-cdapi050.

    IF RETURN-VALUE = "OK":U THEN DO:    
        FOR FIRST wt-docto NO-LOCK
            WHERE wt-docto.seq-wt-docto = RowObject.seq-wt-docto:
    
            IF CAN-FIND (FIRST emitente
                     WHERE emitente.cod-emitente = RowObject.cod-emitente-desp
                     AND UPPER(emitente.pais) <> "BRASIL":U) THEN DO:
            
                RUN findPk_proc_pto IN h-bocx200 (INPUT wt-docto.cod-estab-proces-export,
                                                  INPUT wt-docto.nr-proc-exp,
                                                  INPUT RowObject.cod-itiner,
                                                  INPUT RowObject.sequencia,
                                                  OUTPUT c-return).
                IF c-return = "":U THEN DO:
                    RUN getDateField IN h-bocx200 (INPUT "dt-previsao":U,
                                                   OUTPUT d-date).
                    
                    RUN pi-grava-despes-export-sis IN h-cdapi050 (INPUT wt-docto.cod-estab-proces-export,
                                                                  INPUT wt-docto.nr-proc-exp,
                                                                  INPUT RowObject.cod-itiner,   
                                                                  INPUT RowObject.cod-pto-contr,
                                                                  INPUT RowObject.cdn-despes,
                                                                  INPUT RowObject.cod-emitente-desp,
                                                                  INPUT RowObject.sequencia,
                                                                  INPUT d-date).
                END.
            END.
        END.
    END.
    IF VALID-HANDLE(h-bocx200) THEN DO:
       DELETE PROCEDURE h-bocx200.
       ASSIGN h-bocx200 = ?.
    END.

    IF VALID-HANDLE(h-cdapi050) THEN DO:
       DELETE PROCEDURE h-cdapi050.
       ASSIGN h-cdapi050 = ?.
    END.
    /*
        Fim - Siscoserv
    */
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-total-despesas DBOProgram 
PROCEDURE pi-total-despesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-seq-wt-docto LIKE wt-docto.seq-wt-docto             NO-UNDO.
    DEFINE OUTPUT PARAMETER p-vl-despes    AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" NO-UNDO.
    
    DEF VAR d-valor-convertido LIKE wt-docto-despes.val-despes NO-UNDO.

    FOR EACH wt-docto-despes NO-LOCK
       WHERE wt-docto-despes.seq-wt-docto = p-seq-wt-docto
         AND wt-docto-despes.log-forma-preco
         AND wt-docto-despes.log-comis-agent:

        ASSIGN d-valor-convertido = wt-docto-despes.val-despes.

        FOR FIRST wt-docto FIELDS(dt-emis-nota) 
            WHERE wt-docto.seq-wt-docto = wt-docto-despes.seq-wt-docto NO-LOCK: END.
        IF AVAIL wt-docto AND wt-docto-despes.mo-codigo <> 0 THEN DO:
           RUN cdp/cd0812.p (input wt-docto-despes.mo-codigo,
                             INPUT 0,
                             INPUT wt-docto-despes.val-despes,
                             INPUT wt-docto.dt-emis-nota,
                             OUTPUT d-valor-convertido).
           
        END.
        ASSIGN p-vl-despes = p-vl-despes
                             + d-valor-convertido.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaDtEmissao wWindow 
PROCEDURE piAtualizaDtEmissao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-seq-wt-docto LIKE wt-docto.seq-wt-docto NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-emis-nota LIKE wt-docto.dt-emis-nota NO-UNDO.

    DEFINE VARIABLE de-vl-taxa-exp-ant    LIKE wt-docto.vl-taxa-exp  NO-UNDO.

    FOR FIRST wt-docto EXCLUSIVE-LOCK
        WHERE wt-docto.seq-wt-docto = p-seq-wt-docto:
        
        IF  wt-docto.mo-codigo    <> 0 
        AND wt-docto.dt-emis-nota <> p-dt-emis-nota THEN DO:

            ASSIGN de-vl-taxa-exp-ant = wt-docto.vl-taxa-exp.
            {pdp/pd9100.i "wt-docto.mo-codigo" 
                          "p-dt-emis-nota"
                          "wt-docto.vl-taxa-exp"}
            IF  wt-docto.vl-taxa-exp = ? THEN
                ASSIGN wt-docto.vl-taxa-exp = de-vl-taxa-exp-ant.

            ASSIGN wt-docto.dt-emis-nota = p-dt-emis-nota.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaWtDocto DBOProgram 
PROCEDURE piAtualizaWtDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-seq-wt-docto LIKE wt-docto.seq-wt-docto NO-UNDO.
    DEFINE INPUT PARAMETER p-vl-frete     LIKE wt-docto.vl-frete     NO-UNDO.
    DEFINE INPUT PARAMETER p-vl-seguro    LIKE wt-docto.vl-seguro    NO-UNDO.
    DEFINE INPUT PARAMETER p-vl-embalagem LIKE wt-docto.vl-embalagem NO-UNDO.

    FOR FIRST wt-docto EXCLUSIVE-LOCK
        WHERE wt-docto.seq-wt-docto = p-seq-wt-docto:

        ASSIGN wt-docto.vl-frete-inf     = p-vl-frete
               wt-docto.vl-seguro-inf    = p-vl-seguro
               wt-docto.vl-embalagem-inf = p-vl-embalagem.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaSequencia DBOProgram 
PROCEDURE piBuscaSequencia :
/*------------------------------------------------------------------------------
  Purpose:     Busca a sequància da wt-docto atravÇs do pedido
  Parameters:  p-nr-pedcli -> N£mero do pedido do cliente.
               p-seq-wt-docto -> Sequància da wt-docto
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nr-pedcli     LIKE wt-docto.nr-pedcli     NO-UNDO.
    DEFINE OUTPUT PARAMETER p-seq-wt-docto  LIKE wt-docto.seq-wt-docto  NO-UNDO.
    
    FIND FIRST wt-docto NO-LOCK
        WHERE wt-docto.nr-pedcli = p-nr-pedcli NO-ERROR.
    IF AVAIL wt-docto THEN
        ASSIGN p-seq-wt-docto = wt-docto.seq-wt-docto.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piComparaDespesas DBOProgram 
PROCEDURE piComparaDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-seq-wt-docto LIKE wt-docto.seq-wt-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER p-return       AS LOGICAL                 NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-param-nota-proc.

    ASSIGN p-return = YES.
    FOR EACH tt-param-nota-proc:
        DELETE tt-param-nota-proc.
    END.

    {utp/ut-field.i mgcex wt-docto-despes log-forma-preco 4}
    ASSIGN c-return = RETURN-VALUE.

    FOR FIRST wt-docto NO-LOCK
        WHERE wt-docto.seq-wt-docto = p-seq-wt-docto
          AND wt-docto.nr-proc-exp <> "":
        
        FOR EACH wt-docto-despes NO-LOCK
           WHERE wt-docto-despes.seq-wt-docto = wt-docto.seq-wt-docto:
             
            FOR FIRST proc-desp-itiner NO-LOCK
                WHERE proc-desp-itiner.cod-estabel = wt-docto.cod-estab-proces-export
                  AND proc-desp-itiner.nr-proc-exp = wt-docto.nr-proc-exp
                  AND proc-desp-itiner.cod-desp    = wt-docto-despes.cdn-despes:
                
                IF  wt-docto-despes.cod-emitente-desp    <> proc-desp-itiner.cod-emitente-desp    OR
                    wt-docto-despes.cod-cond-pagto       <> proc-desp-itiner.cod-cond-pag         OR
                    wt-docto-despes.cod-itiner           <> proc-desp-itiner.cod-itiner           OR
                    wt-docto-despes.cod-pto-contr        <> proc-desp-itiner.cod-pto-contr        OR
                    wt-docto-despes.mo-codigo            <> proc-desp-itiner.mo-codigo            OR
                    wt-docto-despes.dat-base-cobr-despes <> proc-desp-itiner.dat-base-cobr-despes OR
                    wt-docto-despes.log-forma-preco      <> proc-desp-itiner.l-forma-preco        OR
                    wt-docto-despes.log-despes-integr-ap <> proc-desp-itiner.log-despes-integr-ap OR
                    wt-docto-despes.cdn-classif-despes   <> proc-desp-itiner.classif-despesa   THEN DO:

                    CREATE tt-param-nota-proc.
                    ASSIGN tt-param-nota-proc.cod-emitente-desp    = string(wt-docto-despes.cod-emitente-desp)             + " / " + string(proc-desp-itiner.cod-emitente-desp)
                           tt-param-nota-proc.cod-cond-pagto       = string(wt-docto-despes.cod-cond-pagto)                + " / " + string(proc-desp-itiner.cod-cond-pag) 
                           tt-param-nota-proc.cod-itiner           = string(wt-docto-despes.cod-itiner)                    + " / " + string(proc-desp-itiner.cod-itiner)
                           tt-param-nota-proc.cod-pto-contr        = string(wt-docto-despes.cod-pto-contr)                 + " / " + string(proc-desp-itiner.cod-pto-contr)
                           tt-param-nota-proc.mo-codigo            = string(wt-docto-despes.mo-codigo)                     + " / " + string(proc-desp-itiner.mo-codigo)
                           tt-param-nota-proc.dat-base-cobr-despes = string(wt-docto-despes.dat-base-cobr-despes)          + " / " + string(proc-desp-itiner.dat-base-cobr-despes)
                           tt-param-nota-proc.log-forma-preco      = STRING(wt-docto-despes.log-forma-preco,c-return)      + " / " + string(proc-desp-itiner.l-forma-preco,c-return)
                           tt-param-nota-proc.log-despes-integr-ap = string(wt-docto-despes.log-despes-integr-ap,c-return) + " / " + string(proc-desp-itiner.log-despes-integr-ap,c-return)
                           tt-param-nota-proc.cdn-classif-despes   = string(wt-docto-despes.cdn-classif-despes)            + " / " + string(proc-desp-itiner.classif-despesa).
                    
                    ASSIGN p-return = NO.
                END.
            END.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiEliminaWorkTablesExportacao DBOProgram 
PROCEDURE PiEliminaWorkTablesExportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-i-seq-wt-docto LIKE wt-docto.seq-wt-docto.

    FOR EACH wt-it-docto-despes EXCLUSIVE-LOCK
       WHERE wt-it-docto-despes.seq-wt-docto = p-i-seq-wt-docto:
        DELETE wt-it-docto-despes.
    END.
    
    FOR EACH wt-docto-despes EXCLUSIVE-LOCK
       WHERE wt-docto-despes.seq-wt-docto = p-i-seq-wt-docto:
        DELETE wt-docto-despes.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraDespesas DBOProgram 
PROCEDURE piGeraDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER p-seq-wt-docto AS INTEGER NO-UNDO.
    DEFINE INPUT  PARAMETER p-nr-resumo    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR rowErrors.
    
    DEFINE VARIABLE de-tot-vl-faturada  LIKE proc-it-nota-desp.val-despes     NO-UNDO.
    DEFINE VARIABLE i-seq-pto-embarque  LIKE pto-itiner.sequencia             NO-UNDO.
    DEFINE VARIABLE de-tot-qt-faturada  AS   DECIMAL FORMAT ">>>>,>>9.9999"   NO-UNDO.
    DEFINE VARIABLE i-seq               AS   INTEGER                          NO-UNDO.
    DEFINE VARIABLE i-tip-base-comis    AS   INTEGER                          NO-UNDO.
    DEFINE VARIABLE de-saldo-quantidade AS   DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE de-saldo-valor      AS   DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE de-saldo-a-faturar  AS   DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE d-val-despes-ped    AS   DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE d-val-despes-nf     AS   DECIMAL FORMAT "->>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE l-exite-it          AS   LOGICAL INITIAL TRUE             NO-UNDO.   
    DEFINE VARIABLE l-siscoserv-ativo   AS   LOGICAL INITIAL FALSE            NO-UNDO.
    DEFINE VARIABLE c-cod-estabelec     AS   CHARACTER                        NO-UNDO.


    EMPTY TEMP-TABLE RowErrors.

    DEF VAR d-total-despesa     LIKE tt-{&TableName}-aux.val-despes NO-UNDO.
    DEF VAR d-total-despesa-ped LIKE tt-{&TableName}-aux.val-despes-ped NO-UNDO.
    DEF VAR d-total-despesa-nf  LIKE tt-{&TableName}-aux.val-despes-ped NO-UNDO.

    DEFINE VARIABLE d-val-despes-ped-it     LIKE wt-it-docto.vl-despes-it NO-UNDO.
    DEFINE VARIABLE d-val-despes-ped-it-tot LIKE wt-it-docto.vl-despes-it NO-UNDO.

    /*Verifica se funá∆o "Considera Valor Total Despesa no Faturamento Parcial"*/
    ASSIGN l-spp-vl-tot-fatur-parc = CAN-FIND(funcao NO-LOCK WHERE funcao.cd-funcao = "spp-considera-tot-despesa":U AND funcao.ativo).

    /*Gera Despesas*/
    IF  p-nr-resumo <> 0 THEN DO:
        /*Embarque*/
        /*Verificando se existe a wt-it-docto, se n«úo existir executar a proceduro
           piGeraTT-wt-it-docto para gerar os dados para processamento*/
        FIND FIRST wt-it-docto
            WHERE  wt-it-docto.seq-wt-docto = p-seq-wt-docto NO-LOCK NO-ERROR.
        IF NOT AVAIL wt-it-docto THEN
            ASSIGN l-exite-it = FALSE.

        FOR EACH wt-docto NO-LOCK
           WHERE wt-docto.seq-wt-docto = p-seq-wt-docto and
                 wt-docto.nr-resumo    = p-nr-resumo:
            IF l-exite-it = FALSE  THEN
                RUN piGeraTT-wt-it-docto (INPUT  wt-docto.cdd-embarq,
                                          INPUT  wt-docto.nr-resumo,
                                          INPUT  p-seq-wt-docto).

            IF l-exite-it THEN DO:
                {cxbo/bocx367.i1 wt-it-docto }
            END.
            ELSE DO: 
                {cxbo/bocx367.i1 tt-wt-it-docto}
            END.
        END.
    END.
    ELSE DO:
        FOR FIRST wt-docto NO-LOCK
            WHERE wt-docto.seq-wt-docto = p-seq-wt-docto:
            {cxbo/bocx367.i1 wt-it-docto }
        END.
    END.
    /*Inicio Siscoserv*/
    IF NOT VALID-HANDLE(h-bocx200) THEN DO:
       RUN cxbo/bocx200.p PERSISTENT SET h-bocx200.
    END.

    IF NOT VALID-HANDLE(h-cdapi050) THEN DO:
       RUN cdp/cdapi050.p PERSISTENT SET h-cdapi050.
    END.
    RUN pi-siscoserv-ativo IN h-cdapi050.
    IF RETURN-VALUE = "OK":U THEN
        ASSIGN l-siscoserv-ativo = TRUE.
    /*Fim Siscoserv*/

    /*Converte Valores, Efetiva Despesas*/
    FOR EACH tt-{&TableName}-aux 
       WHERE tt-{&TableName}-aux.val-despes > 0
        BREAK BY tt-{&TableName}-aux.seq-wt-docto  /* Sirlei */
              BY tt-{&TableName}-aux.cdn-despes  :

        IF  FIRST-OF(tt-{&TableName}-aux.cdn-despes) THEN
            ASSIGN d-total-despesa         = 0
                   d-total-despesa-ped     = 0
                   d-total-despesa-nf      = 0 
                   d-val-despes-ped-it-tot = 0.

        FOR FIRST wt-docto NO-LOCK
            WHERE wt-docto.seq-wt-docto = tt-{&TableName}-aux.seq-wt-docto:

            /* Andrea */        
            &if "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                IF tt-{&TableName}-aux.log-val-tot-faturam 
            &else
                IF substring(tt-{&TableName}-aux.cod-livre-1,3,1) = "1"
            &endif
            THEN DO:
                /*
                Quando marcado para despesa o parametro "Valor Total no Faturamento Parcial":
                Na primeira nota, verificar se tem alguma entrega/item/quantidade que nao pertence a nenhum embarque se sim pegar 
                os valores das despesas que foram rateadas para ele e jogar para a primeira nota 
                */
                ASSIGN de-valor-despes = 0.
                IF NOT CAN-FIND(FIRST proc-nota-fiscal
                                WHERE proc-nota-fiscal.cod-estabel = wt-docto.cod-estab-proces-export 
                                  AND proc-nota-fiscal.nr-proc-exp = wt-docto.nr-proc-exp) THEN DO:

                    IF  LAST-OF(tt-{&TableName}-aux.cdn-despes) THEN  /* Sirlei */
                        FOR EACH proc-ped-ent NO-LOCK
                           WHERE proc-ped-ent.nr-proc-exp = wt-docto.nr-proc-exp
                             AND proc-ped-ent.cod-estabel  = wt-docto.cod-estab-proces-export:
                           IF CAN-FIND(FIRST it-pre-fat 
                                       WHERE it-pre-fat.nome-abrev   = proc-ped-ent.nome-abrev
                                         AND it-pre-fat.nr-pedcli    = proc-ped-ent.nr-pedcli
                                         AND it-pre-fat.nr-sequencia = proc-ped-ent.nr-sequencia
                                         AND it-pre-fat.it-codigo    = proc-ped-ent.it-codigo
                                         AND it-pre-fat.cod-refer    = proc-ped-ent.cod-refer
                                         AND it-pre-fat.nr-entrega   = proc-ped-ent.nr-entrega) THEN
                               NEXT.
    
                           FOR EACH b-proc-ped-ent-desp NO-LOCK
                              WHERE b-proc-ped-ent-desp.cod-estabel  = proc-ped-ent.cod-estabel
                                AND b-proc-ped-ent-desp.nr-proc-exp  = proc-ped-ent.nr-proc-exp
                                AND b-proc-ped-ent-desp.nr-sequencia = proc-ped-ent.nr-sequencia
                                AND b-proc-ped-ent-desp.it-codigo    = proc-ped-ent.it-codigo
                                AND b-proc-ped-ent-desp.cod-refer    = proc-ped-ent.cod-refer
                                AND b-proc-ped-ent-desp.nome-abrev   = proc-ped-ent.nome-abrev
                                AND b-proc-ped-ent-desp.nr-pedcli    = proc-ped-ent.nr-pedcli
                                AND b-proc-ped-ent-desp.nr-entrega   = proc-ped-ent.nr-entrega
                                AND b-proc-ped-ent-desp.cdn-despes   = tt-{&TableName}-aux.cdn-despes:
                               
                               ASSIGN de-valor-despes = de-valor-despes + b-proc-ped-ent-desp.val-despes.   
                           END.
                        END.
                END.
                                            
                FOR EACH b-proc-ped-ent-desp NO-LOCK 
                   WHERE b-proc-ped-ent-desp.cod-estabel  = wt-docto.cod-estab-proces-export 
                     AND b-proc-ped-ent-desp.nr-pedcli    = wt-docto.nr-pedcli
                     AND b-proc-ped-ent-desp.nr-proc-exp  = wt-docto.nr-proc-exp               
                     AND b-proc-ped-ent-desp.nr-sequencia = tt-{&TableName}-aux.num-livre-1 /* numero da sequencia do item gravado na bocx367.i1 */
                     AND b-proc-ped-ent-desp.cdn-despes   = tt-{&TableName}-aux.cdn-despes:
                    
                    IF NOT CAN-FIND(FIRST it-pre-fat NO-LOCK
                                    WHERE it-pre-fat.nome-abrev   = b-proc-ped-ent-desp.nome-abrev
                                      AND it-pre-fat.nr-pedcli    = b-proc-ped-ent-desp.nr-pedcli
                                      AND it-pre-fat.nr-sequencia = b-proc-ped-ent-desp.nr-sequencia
                                      AND it-pre-fat.it-codigo    = b-proc-ped-ent-desp.it-codigo
                                      AND it-pre-fat.cod-refer    = b-proc-ped-ent-desp.cod-refer
                                      AND it-pre-fat.nr-entrega   = b-proc-ped-ent-desp.nr-entrega
                                      AND it-pre-fat.cdd-embarq   = wt-docto.cdd-embarq) THEN NEXT.

                     ASSIGN de-valor-despes = de-valor-despes + b-proc-ped-ent-desp.val-despes.
                END.   
                IF tt-{&TableName}-aux.val-despes > 0 THEN
                   ASSIGN tt-{&TableName}-aux.val-despes = de-valor-despes.             
            END.                            
            /* Andrea */

            FOR FIRST ped-venda NO-LOCK
                WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                  AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli:

                ASSIGN d-val-despes-ped    = 0
                       d-val-despes-ped-it = 0.

                IF  (ped-venda.mo-codigo <> 0 AND tt-{&tablename}-aux.mo-codigo <> 0)
                AND (ped-venda.mo-codigo <> tt-{&tablename}-aux.mo-codigo) THEN DO:

                    RUN cdp/cd0812.p (input tt-{&tablename}-aux.mo-codigo,
                                      INPUT 0,
                                      INPUT tt-{&TableName}-aux.val-despes,
                                      INPUT wt-docto.dt-emis-nota,
                                      OUTPUT d-val-despes-ped).

                    ASSIGN d-val-despes-ped = d-val-despes-ped / wt-docto.vl-taxa-exp.

                END.
                ELSE DO:
                
                    IF  ped-venda.mo-codigo          <> 0
                    AND tt-{&tablename}-aux.mo-codigo = 0 THEN DO:

                        IF i-pais-impto-usuario <> 1 THEN DO:
                            RUN cdp/cd0812a.p (INPUT  tt-{&tablename}-aux.mo-codigo,
                                               INPUT  ped-venda.mo-codigo,
                                               INPUT  tt-{&TableName}-aux.val-despes,
                                               INPUT  wt-docto.vl-taxa-exp,
                                               OUTPUT d-val-despes-ped).
                                               
                            ASSIGN d-val-despes-ped-it = d-val-despes-ped.
                        END.
                        ELSE 
                            ASSIGN d-val-despes-ped    = tt-{&TableName}-aux.val-despes / wt-docto.vl-taxa-exp
                                   d-val-despes-ped-it = tt-{&TableName}-aux.val-despes / wt-docto.vl-taxa-exp.                                                
                    END.
                    ELSE
                        ASSIGN d-val-despes-ped    = tt-{&TableName}-aux.val-despes
                               d-val-despes-ped-it = tt-{&TableName}-aux.val-despes.
                    
                END.
                
                ASSIGN tt-{&TableName}-aux.val-despes-ped = d-val-despes-ped
                       d-val-despes-ped-it-tot            = d-val-despes-ped-it-tot + d-val-despes-ped-it.

            END.

            ASSIGN d-val-despes-nf = 0.

            IF  wt-docto.mo-codigo <> 0 THEN
                ASSIGN d-val-despes-nf = tt-{&TableName}-aux.val-despes-ped * wt-docto.vl-taxa-exp.
            ELSE 
                ASSIGN d-val-despes-nf = tt-{&TableName}-aux.val-despes-ped.

            ASSIGN tt-{&TableName}-aux.val-despes-nf  = d-val-despes-nf
                   tt-{&TableName}-aux.val-despes-ped = ROUND(tt-{&TableName}-aux.val-despes-ped,2)
                   tt-{&TableName}-aux.val-despes-nf  = ROUND(tt-{&TableName}-aux.val-despes-nf,2).

            ASSIGN d-total-despesa     = d-total-despesa + tt-{&TableName}-aux.val-despes
                   d-total-despesa-ped = d-total-despesa-ped + tt-{&TableName}-aux.val-despes-ped
                   d-total-despesa-nf  = d-total-despesa-nf + tt-{&TableName}-aux.val-despes-nf.

        END.
        /*Efetivando*/

        FOR LAST bf{&TableName} NO-LOCK
           WHERE bf{&TableName}.seq-wt-docto = wt-docto.seq-wt-docto:
            ASSIGN i-seq = bf{&TableName}.seq-wt-docto-despes.
        END.

        FIND FIRST {&TableName} EXCLUSIVE-LOCK
             WHERE {&TableName}.seq-wt-docto = wt-docto.seq-wt-docto
               AND {&TableName}.cdn-despes   = tt-{&TableName}-aux.cdn-despes NO-ERROR.

        IF  NOT AVAIL {&TableName} THEN DO:
            CREATE {&TableName}.
            BUFFER-COPY tt-{&TableName}-aux EXCEPT seq-wt-docto-despes TO {&TableName}.
            ASSIGN {&TableName}.seq-wt-docto-despes = i-seq + 1.
        END.
        ELSE DO:
            ASSIGN {&TableName}.val-despes     = {&TableName}.val-despes
                                               + tt-{&TableName}-aux.val-despes
                   {&TableName}.val-despes-ped = {&TableName}.val-despes-ped
                                               + tt-{&TableName}-aux.val-despes-ped
                   {&TableName}.val-despes-nf  = {&TableName}.val-despes-nf
                                               + tt-{&TableName}-aux.val-despes-nf.
        END.

        /*Acerto de res°duo*/
        IF  LAST-OF(tt-{&TableName}-aux.cdn-despes) THEN DO:

            FOR FIRST ped-venda NO-LOCK
                WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
                  AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli:

                ASSIGN d-val-despes-ped-it-tot = 0.
                IF  (ped-venda.mo-codigo <> 0 AND tt-{&tablename}-aux.mo-codigo <> 0)
                AND (ped-venda.mo-codigo <> tt-{&tablename}-aux.mo-codigo) THEN DO:

                    RUN cdp/cd0812.p (input tt-{&tablename}-aux.mo-codigo,
                                      INPUT 0,
                                      INPUT d-total-despesa,
                                      INPUT wt-docto.dt-emis-nota,
                                      OUTPUT d-val-despes-ped-it-tot).

                    ASSIGN d-val-despes-ped-it-tot = d-val-despes-ped-it-tot / wt-docto.vl-taxa-exp.

                END.
                ELSE DO:
                    IF  ped-venda.mo-codigo          <> 0
                    AND tt-{&tablename}-aux.mo-codigo = 0 THEN DO:

                        IF i-pais-impto-usuario <> 1 THEN DO:
                            RUN cdp/cd0812a.p (INPUT  tt-{&tablename}-aux.mo-codigo,
                                               INPUT  ped-venda.mo-codigo,
                                               INPUT  d-total-despesa,
                                               INPUT  wt-docto.vl-taxa-exp,
                                               OUTPUT d-val-despes-ped-it-tot).
                        END.                       
                        ELSE 
                            ASSIGN d-val-despes-ped-it-tot = d-total-despesa / wt-docto.vl-taxa-exp.
                    END.
                    ELSE
                        ASSIGN d-val-despes-ped-it-tot = d-total-despesa.
                    
                END.

                IF  ROUND(d-val-despes-ped-it-tot,2) <> d-total-despesa-ped THEN
                    ASSIGN {&TableName}.val-despes-ped = {&TableName}.val-despes-ped + ( ROUND(d-val-despes-ped-it-tot,2) - d-total-despesa-ped) .

            END.

            IF  {&TableName}.mo-codigo = 0 THEN DO:
                IF  {&TableName}.val-despes-nf <> {&TableName}.val-despes THEN
                    ASSIGN {&TableName}.val-despes-nf = {&TableName}.val-despes.
            END.
            ELSE DO:
                IF  wt-docto.mo-codigo <> 0 THEN
                    ASSIGN d-val-despes-nf = {&TableName}.val-despes-ped * wt-docto.vl-taxa-exp.
                ELSE 
                    ASSIGN d-val-despes-nf = {&TableName}.val-despes-ped.

                ASSIGN {&TableName}.val-despes-nf  = ROUND(d-val-despes-nf,2).
            END.

        END.

        /*
            Inicio Siscoserv
            Grava as informaá‰es na tabela de extens∆o para depois enviar para o siscoserv
        */

        IF l-siscoserv-ativo = TRUE THEN DO:
            IF CAN-FIND (FIRST emitente
                     WHERE emitente.cod-emitente = {&TableName}.cod-emitente-desp
                     AND UPPER(emitente.pais) <> "BRASIL":U) THEN DO:
            
                RUN findPk_proc_pto IN h-bocx200 (INPUT wt-docto.cod-estab-proces-export,
                                                  INPUT wt-docto.nr-proc-exp,
                                                  INPUT {&TableName}.cod-itiner,
                                                  INPUT {&TableName}.sequencia,
                                                  OUTPUT c-return).
                IF c-return = "":U THEN DO:
                    RUN getDateField IN h-bocx200 (INPUT "dt-previsao":U,
                                                   OUTPUT d-date).
                    
                    RUN pi-grava-despes-export-sis IN h-cdapi050 (INPUT wt-docto.cod-estab-proces-export,
                                                                  INPUT wt-docto.nr-proc-exp,
                                                                  INPUT {&TableName}.cod-itiner,   
                                                                  INPUT {&TableName}.cod-pto-contr,
                                                                  INPUT {&TableName}.cdn-despes,
                                                                  INPUT {&TableName}.cod-emitente-desp,
                                                                  INPUT {&TableName}.sequencia,
                                                                  INPUT d-date).
                END.
            END.
        END.
        /*
            Fim - Siscoserv
        */
    END.
        
    /*Inicio Siscoserv*/
    IF VALID-HANDLE(h-bocx200) THEN DO:
       DELETE PROCEDURE h-bocx200.
       ASSIGN h-bocx200 = ?.
    END.

    IF VALID-HANDLE(h-cdapi050) THEN DO:
       DELETE PROCEDURE h-cdapi050.
       ASSIGN h-cdapi050 = ?.
    END.
    /*Fim - Siscoserv*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraTT-wt-it-docto DBOProgram 
PROCEDURE piGeraTT-wt-it-docto :
/*------------------------------------------------------------------------------
  Purpose:     Gerar a tt-wt-it-docto
  Parameters:  p-ccd-embarq - c¢digo do embarque 
               p-nr-resumo  - n£mero do embauque
               p-seq-wt-docto - n£mero da Sequància
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-embarq LIKE wt-docto.cdd-embarq NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-resumo  LIKE wt-docto.nr-resumo  NO-UNDO.
    DEFINE INPUT PARAMETER p-seq-wt-docto LIKE wt-docto.seq-wt-docto NO-UNDO.
    
    
    FOR EACH it-pre-fat NO-LOCK
       WHERE it-pre-fat.cdd-embarq   = p-cdd-embarq
         AND it-pre-fat.nr-resumo    = p-nr-resumo:
    
        CREATE  tt-wt-it-docto.
        ASSIGN  tt-wt-it-docto.nr-pedcli     = it-pre-fat.nr-pedcli
                tt-wt-it-docto.nr-sequencia  = it-pre-fat.nr-sequencia
                tt-wt-it-docto.it-codigo     = it-pre-fat.it-codigo
                tt-wt-it-docto.nr-entrega    = it-pre-fat.nr-entrega
                tt-wt-it-docto.cod-refer     = it-pre-fat.cod-refer
                tt-wt-it-docto.quantidade[1] = it-pre-fat.qt-alocada
                tt-wt-it-docto.seq-wt-docto  = p-seq-wt-docto
                tt-wt-it-docto.calcula       = yes.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piNaturezaEmitente DBOProgram 
PROCEDURE piNaturezaEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-nome-abrev LIKE emitente.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER p-natu-emite AS   LOGICAL             NO-UNDO.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.nome-abrev = p-nome-abrev:

        IF  emitente.natureza = 3 OR
            emitente.natureza = 4 THEN
            ASSIGN p-natu-emite = YES.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiRateioDespesasExportacao DBOProgram 
PROCEDURE PiRateioDespesasExportacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER p-seq-wt-docto LIKE wt-docto.seq-wt-docto.

    DEF VAR h-exapi015             AS   HANDLE                           NO-UNDO.
    DEF VAR i-seq-despes           AS   INTEGER                          NO-UNDO.
    DEF VAR d-vl-despesa           LIKE wt-it-docto-despes.val-despes-nf NO-UNDO.
    DEF VAR d-tot-vl-frete         LIKE wt-docto-despes.val-despes-nf    NO-UNDO.
    DEF VAR d-tot-vl-segur         LIKE wt-docto-despes.val-despes-nf    NO-UNDO.
    DEF VAR d-tot-vl-embal         LIKE wt-docto-despes.val-despes-nf    NO-UNDO.
    DEF VAR d-tot-vl-frete-ped-me  LIKE wt-docto-despes.val-despes       NO-UNDO.
    DEF VAR d-tot-vl-segur-ped-me  LIKE wt-docto-despes.val-despes       NO-UNDO.
    DEF VAR d-tot-vl-embal-ped-me  LIKE wt-docto-despes.val-despes       NO-UNDO.
    DEF VAR d-vl-frete             LIKE wt-it-docto-despes.val-despes-nf NO-UNDO.
    DEF VAR d-vl-segur             LIKE wt-it-docto-despes.val-despes-nf NO-UNDO.
    DEF VAR d-vl-embal             LIKE wt-it-docto-despes.val-despes-nf NO-UNDO.
    DEF VAR d-vl-frete-me          LIKE wt-it-docto-despes.val-despes    NO-UNDO.
    DEF VAR d-vl-segur-me          LIKE wt-it-docto-despes.val-despes    NO-UNDO.
    DEF VAR d-vl-embal-me          LIKE wt-it-docto-despes.val-despes    NO-UNDO.
    DEF VAR d-vl-frete-ped-me      LIKE wt-it-docto-despes.val-despes    NO-UNDO.
    DEF VAR d-vl-segur-ped-me      LIKE wt-it-docto-despes.val-despes    NO-UNDO.
    DEF VAR d-vl-embal-ped-me      LIKE wt-it-docto-despes.val-despes    NO-UNDO.
    DEF VAR da-dt-emis-nota        LIKE wt-docto.dt-emis-nota            NO-UNDO.

    IF  NOT VALID-HANDLE(h-exapi015) THEN
        RUN exp/exapi015.p persistent set h-exapi015.

    DEFINE VARIABLE de-fator-conver AS   DECIMAL INITIAL 1                  NO-UNDO.

    /*Convers∆o do valor do volume do item*/
    FOR FIRST para-dis NO-LOCK:
        /*Unidade de Medida da Convers∆o 1 = Cent°metros 2 = Metros*/
        IF para-dis.int-1 = 1 THEN
                ASSIGN de-fator-conver = 0.000001.
        ELSE
                ASSIGN de-fator-conver = 1.
    END.
    find first para-fat no-lock no-error.
     
    EMPTY TEMP-TABLE tt-entrega.
    EMPTY TEMP-TABLE tt-despes-entr.
    EMPTY TEMP-TABLE tt-despes-entr-me.

    FOR FIRST wt-docto FIELDS(dt-emis-nota) 
        WHERE wt-docto.seq-wt-docto = p-seq-wt-docto NO-LOCK:
    END.
    IF AVAIL wt-docto THEN
        ASSIGN da-dt-emis-nota = wt-docto.dt-emis-nota.

    FOR FIRST ped-venda
        WHERE ped-venda.nr-pedcli  = wt-docto.nr-pedcli
          AND ped-venda.nome-abrev = wt-docto.nome-abrev NO-LOCK:
    END.
        
    FOR EACH wt-it-docto EXCLUSIVE-LOCK
       WHERE wt-it-docto.seq-wt-docto = p-seq-wt-docto
       AND   wt-it-docto.calcula
       AND   wt-it-docto.ind-componen <> 3:

        CREATE tt-entrega.
        ASSIGN tt-entrega.nr-sequencia = wt-it-docto.seq-wt-it-docto
               tt-entrega.it-codigo    = wt-it-docto.it-codigo
               tt-entrega.cod-refer    = wt-it-docto.cod-refer
               tt-entrega.nr-entrega   = wt-it-docto.nr-entrega
               tt-entrega.quantidade   = wt-it-docto.quantidade[1]
               tt-entrega.valor        = wt-it-docto.vl-preuni
               tt-entrega.peso-liquido = wt-it-docto.peso-liq-it.
               
        FOR FIRST item FIELDS(it-codigo largura comprim altura) NO-LOCK
            WHERE item.it-codigo = wt-it-docto.it-codigo:
    
            ASSIGN tt-entrega.volume = (item.largura
                                     * item.comprim
                                     * item.altura)
                                     * de-fator-conver.
        END.
        
        //Ignorar itens vinculados a despesas
        FIND FIRST wt-item-docto-internac NO-LOCK
             WHERE wt-item-docto-internac.seq-wt-docto    = wt-it-docto.seq-wt-docto
               AND wt-item-docto-internac.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
               AND wt-item-docto-internac.cod-param       = "TaxExpense":U NO-ERROR.
        IF AVAIL wt-item-docto-internac THEN
            ASSIGN tt-entrega.log-desp-it = YES.
     END.

     EMPTY TEMP-TABLE tt-despesa.
     EMPTY TEMP-TABLE tt-despesa-me.

     blkDesp:
     FOR EACH wt-docto-despes NO-LOCK
        WHERE wt-docto-despes.seq-wt-docto = p-seq-wt-docto:

        /* Faturamento outra Moeda - Internacional */
        IF  para-fat.ind-legislacao = 1 THEN DO:
            /* Se moeda da despesa Ç a mesma do pedido, usa o pr¢prio valor da despesa */
            if  wt-docto-despes.mo-codigo = ped-venda.mo-codigo then
                ASSIGN d-vl-despesa = wt-docto-despes.val-despes.
            else do:
                /* Sen∆o forem moedas iguais, busca cotacao para conversao do cadastro de cotaá‰es (cd0103) */
                /* Converte Valores para moeda da fatura */
                RUN cdp/cd0812.p (input wt-docto-despes.mo-codigo,
                                  INPUT ped-venda.mo-codigo,
                                  INPUT wt-docto-despes.val-despes,
                                  INPUT da-dt-emis-nota,
                                  OUTPUT d-vl-despesa).
            end.
        end.
        ELSE DO:
            /* Se a moeda da despesa Ç a mesma do pedido, converte despesas utilizando cotacao do cabeáalho da nota*/
            IF  wt-docto-despes.mo-codigo = ped-venda.mo-codigo THEN
                ASSIGN d-vl-despesa = wt-docto-despes.val-despes * wt-docto.vl-taxa-exp.
            ELSE DO:
                /* Sen∆o forem moedas iguais, busca cotacao para conversao do cadastro de cotaá‰es (cd0103) */
                /* Converte Valores para moeda Padrao */
                RUN cdp/cd0812.p (input wt-docto-despes.mo-codigo,
                                  INPUT 0,
                                  INPUT wt-docto-despes.val-despes,
                                  INPUT da-dt-emis-nota,
                                  OUTPUT d-vl-despesa).
            END.
        END.

        /*cria a tt-despesa com o valor em reais*/
        CREATE tt-despesa.
        ASSIGN tt-despesa.cdn-despes = wt-docto-despes.cdn-despes
               tt-despesa.val-despes = ROUND(d-vl-despesa,2)
               tt-despesa.mo-codigo  = wt-docto-despes.mo-codigo.

        /*cria a tt-despesa com o valor na moeda da despesa*/
        CREATE tt-despesa-me.
        ASSIGN tt-despesa-me.cdn-despes = wt-docto-despes.cdn-despes
               tt-despesa-me.val-despes = wt-docto-despes.val-despes
               tt-despesa-me.mo-codigo  = wt-docto-despes.mo-codigo.

        /*cria a tt-despesa com o valor na moeda do pedido*/
        CREATE tt-despesa-ped-me.
        ASSIGN tt-despesa-ped-me.cdn-despes = wt-docto-despes.cdn-despes
               tt-despesa-ped-me.val-despes = wt-docto-despes.val-despes-ped
               tt-despesa-ped-me.mo-codigo  = wt-docto-despes.mo-codigo.
     END.   

     /*realiza o rateio das despesas em reais*/
     RUN geraTTPedEntDesp IN h-exapi015 (INPUT  TABLE tt-entrega,
                                         INPUT  TABLE tt-despesa,
                                         INPUT  TABLE tt-param,
                                         OUTPUT TABLE tt-despes-entr).

     /*realiza o rateio das despesas na moeda da despesa*/
     RUN geraTTPedEntDesp IN h-exapi015 (INPUT  TABLE tt-entrega,
                                         INPUT  TABLE tt-despesa-me,
                                         INPUT  TABLE tt-param,
                                         OUTPUT TABLE tt-despes-entr-me).

     /*realiza o rateio das despesas na moeda do pedido*/
     RUN geraTTPedEntDesp IN h-exapi015 (INPUT  TABLE tt-entrega,
                                         INPUT  TABLE tt-despesa-ped-me,
                                         INPUT  TABLE tt-param,
                                         OUTPUT TABLE tt-despes-entr-ped-me).

     /*Sugere nova sequencia*/
     ASSIGN i-seq-despes = 1.

     FOR EACH tt-despes-entr:
         FOR LAST bfwt-it-docto-despes NO-LOCK
            WHERE bfwt-it-docto-despes.seq-wt-docto    = p-seq-wt-docto
              AND bfwt-it-docto-despes.seq-wt-it-docto = tt-despes-entr.nr-sequencia:
        
             ASSIGN i-seq-despes = bfwt-it-docto-despes.seq-wt-docto-despes + 1.
         END.

        FIND FIRST wt-docto-despes 
             WHERE wt-docto-despes.seq-wt-docto = p-seq-wt-docto 
             AND   wt-docto-despes.cdn-despes   = tt-despes-entr.cdn-despes NO-LOCK NO-ERROR.
        IF AVAIL wt-docto-despes THEN DO:
    
            FIND FIRST despesa NO-LOCK
                 WHERE despesa.cod-despesa = STRING(tt-despes-entr.cdn-despes) NO-ERROR.    
            FIND FIRST ITEM NO-LOCK
                 WHERE ITEM.it-codigo  = GetEntryField(1,despesa.cod-livre-2,";") 
                   AND ITEM.it-codigo <> "" NO-ERROR.
            IF AVAIL despesa AND AVAIL ITEM THEN DO:
    
                //Cria apenas se o item for o da despesa
                FIND FIRST wt-item-docto-internac NO-LOCK
                     WHERE wt-item-docto-internac.seq-wt-docto    = p-seq-wt-docto
                       AND wt-item-docto-internac.seq-wt-it-docto = tt-despes-entr.nr-sequencia
                       AND wt-item-docto-internac.cod-param       = "TaxExpense":U NO-ERROR.
                IF NOT AVAIL wt-item-docto-internac THEN
                    NEXT.
            END.
            ELSE DO:
                //Cria apenas se o item n∆o for de despesa
                FIND FIRST wt-item-docto-internac NO-LOCK
                     WHERE wt-item-docto-internac.seq-wt-docto    = p-seq-wt-docto
                       AND wt-item-docto-internac.seq-wt-it-docto = tt-despes-entr.nr-sequencia
                       AND wt-item-docto-internac.cod-param       = "TaxExpense":U NO-ERROR.
                IF AVAIL wt-item-docto-internac THEN
                    NEXT.
            END.
    
            CREATE wt-it-docto-despes.
            ASSIGN wt-it-docto-despes.cdn-classif-despes   = wt-docto-despes.cdn-classif-despes
                   wt-it-docto-despes.cod-cond-pagto       = wt-docto-despes.cod-cond-pagto
                   wt-it-docto-despes.cod-emitente-desp    = wt-docto-despes.cod-emitente-desp
                   wt-it-docto-despes.cod-itiner           = wt-docto-despes.cod-itiner
                   wt-it-docto-despes.cod-pto-contr        = wt-docto-despes.cod-pto-contr
                   wt-it-docto-despes.dat-base-cobr-despes = wt-docto-despes.dat-base-cobr-despes
                   wt-it-docto-despes.log-comis-agent      = wt-docto-despes.log-comis-agent
                   wt-it-docto-despes.log-despes-integr-ap = wt-docto-despes.log-despes-integr-ap
                   wt-it-docto-despes.log-forma-preco      = wt-docto-despes.log-forma-preco
                   wt-it-docto-despes.mo-codigo            = wt-docto-despes.mo-codigo
                   wt-it-docto-despes.seq-wt-docto         = wt-docto-despes.seq-wt-docto
                   wt-it-docto-despes.seq-wt-it-docto      = tt-despes-entr.nr-sequencia
                   wt-it-docto-despes.cdn-despes           = tt-despes-entr.cdn-despes 
                   wt-it-docto-despes.sequencia            = tt-despes-entr.nr-sequencia
                   /*wt-it-docto-despes.val-despes           = tt-despes-entr.val-despes */
                   wt-it-docto-despes.val-despes-nf        = tt-despes-entr.val-despes
                   wt-it-docto-despes.val-despes-ped       = 0
                   wt-it-docto-despes.seq-wt-docto-despes  = i-seq-despes
                   &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                       wt-it-docto-despes.log-despes-inclusa = wt-docto-despes.log-despes-inclusa
                       wt-it-docto-despes.log-destaca-despes = wt-docto-despes.log-destaca-despes
                   &ELSE
                       overlay(wt-it-docto-despes.cod-livre-1,1,1) = trim(substring(wt-docto-despes.cod-livre-1,1,1))
                       overlay(wt-it-docto-despes.cod-livre-1,2,1) = trim(substring(wt-docto-despes.cod-livre-1,2,1))
                   &ENDIF
                   .
            
            /*grava o valor rateado na moeda da despesa*/
            FIND tt-despes-entr-me WHERE 
                 tt-despes-entr-me.nome-abrev    =  tt-despes-entr.nome-abrev   AND
                 tt-despes-entr-me.nr-pedcli     =  tt-despes-entr.nr-pedcli    AND
                 tt-despes-entr-me.nr-sequencia  =  tt-despes-entr.nr-sequencia AND
                 tt-despes-entr-me.it-codigo     =  tt-despes-entr.it-codigo    AND
                 tt-despes-entr-me.cod-refer     =  tt-despes-entr.cod-refer    AND
                 tt-despes-entr-me.nr-entrega    =  tt-despes-entr.nr-entrega   AND
                 tt-despes-entr-me.cdn-despes    =  tt-despes-entr.cdn-despes  NO-ERROR.
            IF AVAIL tt-despes-entr-me THEN
                ASSIGN wt-it-docto-despes.val-despes = tt-despes-entr-me.val-despes.

            /*grava o valor rateado na moeda do pedido*/
            FIND tt-despes-entr-ped-me WHERE 
                 tt-despes-entr-ped-me.nome-abrev    =  tt-despes-entr.nome-abrev   AND
                 tt-despes-entr-ped-me.nr-pedcli     =  tt-despes-entr.nr-pedcli    AND
                 tt-despes-entr-ped-me.nr-sequencia  =  tt-despes-entr.nr-sequencia AND
                 tt-despes-entr-ped-me.it-codigo     =  tt-despes-entr.it-codigo    AND
                 tt-despes-entr-ped-me.cod-refer     =  tt-despes-entr.cod-refer    AND
                 tt-despes-entr-ped-me.nr-entrega    =  tt-despes-entr.nr-entrega   AND
                 tt-despes-entr-ped-me.cdn-despes    =  tt-despes-entr.cdn-despes  NO-ERROR.
            IF AVAIL tt-despes-entr-ped-me THEN
                ASSIGN wt-it-docto-despes.val-despes-ped = tt-despes-entr-ped-me.val-despes.
                
            IF AVAIL despesa AND AVAIL ITEM THEN
                ASSIGN OVERLAY(wt-it-docto-despes.cod-livre-1,3,16) = ITEM.it-codigo.
        END.
     END.

     ASSIGN d-tot-vl-frete        = 0
            d-tot-vl-segur        = 0
            d-tot-vl-embal        = 0
            d-tot-vl-frete-ped-me = 0 
            d-tot-vl-segur-ped-me = 0 
            d-tot-vl-embal-ped-me = 0.
    
    FIND FIRST wt-docto WHERE wt-docto.seq-wt-docto = p-seq-wt-docto EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL wt-docto THEN DO:

        FOR EACH wt-it-docto EXCLUSIVE-LOCK
           WHERE wt-it-docto.seq-wt-docto = p-seq-wt-docto:
        
            //N∆o considera itens vinculados a despesas
            FIND FIRST wt-item-docto-internac NO-LOCK
                 WHERE wt-item-docto-internac.seq-wt-docto    = wt-docto.seq-wt-docto
                   AND wt-item-docto-internac.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto
                   AND wt-item-docto-internac.cod-param       = "TaxExpense":U NO-ERROR.
            IF AVAIL wt-item-docto-internac THEN
                NEXT.
        
            ASSIGN d-vl-frete        = 0
                   d-vl-segur        = 0
                   d-vl-embal        = 0
                   d-vl-frete-ped-me = 0
                   d-vl-segur-ped-me = 0
                   d-vl-embal-ped-me = 0.
        
            FOR EACH wt-it-docto-despes NO-LOCK
               WHERE wt-it-docto-despes.seq-wt-docto    = wt-it-docto.seq-wt-docto
                 AND wt-it-docto-despes.seq-wt-it-docto = wt-it-docto.seq-wt-it-docto:

                IF  NOT wt-it-docto-despes.log-forma-preco THEN NEXT.
                
                //N∆o considera itens vinculados a despesas
                FIND FIRST despesa NO-LOCK
                     WHERE despesa.cod-despesa = STRING(wt-it-docto-despes.cdn-despes) NO-ERROR.    
                FIND FIRST ITEM NO-LOCK
                     WHERE ITEM.it-codigo  = GetEntryField(1,despesa.cod-livre-2,";") 
                       AND ITEM.it-codigo <> "" NO-ERROR.
                IF AVAIL despesa AND AVAIL ITEM THEN
                    NEXT.
                
                CASE wt-it-docto-despes.cdn-classif-despes:
                    WHEN 2 THEN
                        ASSIGN d-vl-frete        = d-vl-frete
                                                 + wt-it-docto-despes.val-despes-nf
                               d-vl-frete-ped-me = d-vl-frete-ped-me 
                                                 + wt-it-docto-despes.val-despes-ped.
                    WHEN 3 THEN
                        ASSIGN d-vl-segur        = d-vl-segur
                                                 + wt-it-docto-despes.val-despes-nf
                               d-vl-segur-ped-me = d-vl-segur-ped-me 
                                                 + wt-it-docto-despes.val-despes-ped.
                    WHEN 4 THEN
                        ASSIGN d-vl-embal        = d-vl-embal
                                                 + wt-it-docto-despes.val-despes-nf
                               d-vl-embal-ped-me = d-vl-embal-ped-me 
                                                 + wt-it-docto-despes.val-despes-ped.

                END CASE.
            END.

            ASSIGN wt-it-docto.vl-frete           = round(d-vl-frete,2)
                   wt-it-docto.vl-seguro          = round(d-vl-segur,2)
                   wt-it-docto.vl-embalagem       = round(d-vl-embal,2)
                   wt-it-docto.vl-frete-inf       = round(d-vl-frete-ped-me,2) 
                   wt-it-docto.vl-seguro-inf      = round(d-vl-segur-ped-me,2) 
                   wt-it-docto.vl-embalagem-inf   = round(d-vl-embal-ped-me,2) 
                   wt-it-docto.vl-despes-it       = wt-it-docto.vl-frete
                                                  + wt-it-docto.vl-seguro 
                                                  + wt-it-docto.vl-embalagem   
                   wt-it-docto.vl-despes-it-inf   = wt-it-docto.vl-frete-inf    
                                                  + wt-it-docto.vl-seguro-inf
                                                  + wt-it-docto.vl-embalagem-inf 
                   wt-it-docto.despes-moeda-forte = wt-it-docto.vl-despes-it-inf. 

            ASSIGN d-tot-vl-frete        = d-tot-vl-frete
                                         + wt-it-docto.vl-frete
                   d-tot-vl-segur        = d-tot-vl-segur
                                         + wt-it-docto.vl-seguro
                   d-tot-vl-embal        = d-tot-vl-embal
                                         + wt-it-docto.vl-embalagem
                   d-tot-vl-frete-ped-me = d-tot-vl-frete-ped-me
                                         + wt-it-docto.vl-frete-inf    
                   d-tot-vl-segur-ped-me = d-tot-vl-segur-ped-me
                                         + wt-it-docto.vl-seguro-inf 
                   d-tot-vl-embal-ped-me = d-tot-vl-embal-ped-me
                                         + wt-it-docto.vl-embalagem-inf.
        END.

        /*Atualiza valores da wt-docto*/
        ASSIGN wt-docto.vl-frete         = d-tot-vl-frete
               wt-docto.vl-seguro        = d-tot-vl-segur
               wt-docto.vl-embalagem     = d-tot-vl-embal
               wt-docto.vl-frete-inf     = d-tot-vl-frete-ped-me
               wt-docto.vl-seguro-inf    = d-tot-vl-segur-ped-me
               wt-docto.vl-embalagem-inf = d-tot-vl-embal-ped-me.
    END.
    IF VALID-HANDLE(h-exapi015) THEN DO:
        DELETE PROCEDURE h-exapi015.
        ASSIGN h-exapi015 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDados DBOProgram 
PROCEDURE piRetornaDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-seq-wt-docto    LIKE wt-docto.seq-wt-docto    NO-UNDO.
    DEF OUTPUT PARAM p-mo-codigo       LIKE ped-venda.mo-codigo      NO-UNDO.
    DEF OUTPUT PARAM p-desc-mo-codigo  LIKE moeda.descricao          NO-UNDO.
    DEF OUTPUT PARAM p-cod-itiner      LIKE ped-venda-cex.cod-itiner NO-UNDO.
    DEF OUTPUT PARAM p-desc-cod-itiner LIKE itinerario.descricao     NO-UNDO.
    
    FOR FIRST wt-docto NO-LOCK
        WHERE wt-docto.seq-wt-docto = p-seq-wt-docto:

        FOR FIRST ped-venda NO-LOCK
            WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
              AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli:

            ASSIGN p-mo-codigo = ped-venda.mo-codigo.

            RUN piRetornaDescMoeda IN THIS-PROCEDURE (INPUT  p-mo-codigo,
                                                      OUTPUT p-desc-mo-codigo).
            FIND FIRST param-exp NO-LOCK
                 WHERE param-exp.cod-estabel = IF wt-docto.cod-estab-proces-export = "" THEN wt-docto.cod-estabel ELSE wt-docto.cod-estab-proces-export NO-ERROR.

            IF  NOT AVAIL param-exp THEN
                RETURN "NOK":U.

            IF param-exp.idi-busca-despes-export = 2 THEN DO:
                FIND FIRST processo-exp NO-LOCK
                     WHERE processo-exp.cod-emitente = wt-docto.cod-emitente
                       AND processo-exp.nr-proc-exp  = wt-docto.nr-proc-exp NO-ERROR.
                IF AVAIL processo-exp THEN
                    
                    ASSIGN p-cod-itiner = processo-exp.cod-itiner.
                ELSE DO:
                    FOR FIRST ped-venda-cex NO-LOCK
                        WHERE ped-venda-cex.nome-abrev = ped-venda.nome-abrev
                          AND ped-venda-cex.nr-pedcli  = ped-venda.nr-pedcli:
                    
                        ASSIGN p-cod-itiner = ped-venda-cex.cod-itiner.
                   
                    END.
                END.
            END.
            ELSE DO:
                FOR FIRST ped-venda-cex NO-LOCK
                    WHERE ped-venda-cex.nome-abrev = ped-venda.nome-abrev
                      AND ped-venda-cex.nr-pedcli  = ped-venda.nr-pedcli:
                    
                    ASSIGN p-cod-itiner = ped-venda-cex.cod-itiner.
                   
                END.
            END.
            RUN piRetornaDescItiner IN THIS-PROCEDURE (INPUT  p-cod-itiner,
                                                       OUTPUT p-desc-cod-itiner).
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDescDespes DBOProgram 
PROCEDURE piRetornaDescDespes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-cod-desp      LIKE desp-imp.cod-desp  NO-UNDO.
    DEF OUTPUT PARAM p-desc-cod-desp LIKE desp-imp.descricao NO-UNDO.

    FOR FIRST desp-imp NO-LOCK
        WHERE desp-imp.cod-desp = p-cod-desp:

        ASSIGN p-desc-cod-desp = desp-imp.descricao.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDescEmitente DBOProgram 
PROCEDURE piRetornaDescEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-cod-emitente LIKE emitente.cod-emitente NO-UNDO.
    DEF OUTPUT PARAM p-nome-abrev   LIKE emitente.nome-abrev   NO-UNDO.

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = p-cod-emitente:

        ASSIGN p-nome-abrev = emitente.nome-abrev.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDescItiner DBOProgram 
PROCEDURE piRetornaDescItiner :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-cod-itiner LIKE itinerario.cod-itiner NO-UNDO.
    DEF OUTPUT PARAM p-descricao  LIKE itinerario.descricao  NO-UNDO.

    FOR FIRST itinerario NO-LOCK
        WHERE itinerario.cod-itiner = p-cod-itiner:

        ASSIGN p-descricao = itinerario.descricao.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDescMoeda DBOProgram 
PROCEDURE piRetornaDescMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-mo-codigo      LIKE moeda.mo-codigo NO-UNDO.
    DEF OUTPUT PARAM p-desc-mo-codigo LIKE moeda.descricao NO-UNDO.

    FOR FIRST moeda NO-LOCK
        WHERE moeda.mo-codigo = p-mo-codigo:

        ASSIGN p-desc-mo-codigo = moeda.descricao.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDespesasInclusas DBOProgram 
PROCEDURE piRetornaDespesasInclusas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-seq-wt-docto     LIKE wt-docto.seq-wt-docto         NO-UNDO.
    DEFINE INPUT  PARAM p-seq-wt-it-docto  LIKE wt-it-docto.seq-wt-it-docto   NO-UNDO.
    DEFINE OUTPUT PARAM pl-desp-exportacao AS   LOGICAL                       NO-UNDO.
    DEFINE OUTPUT PARAM p-vl-despesas      LIKE wt-it-docto.vl-frete-inf      NO-UNDO.
    
    DEFINE VARIABLE de-desp-tot     LIKE wt-docto-despes.val-despes-ped     NO-UNDO.
    DEFINE VARIABLE de-desp-tot-it  LIKE wt-it-docto-despes.val-despes-ped  NO-UNDO.

    FOR EACH wt-it-docto-despes NO-LOCK
       WHERE wt-it-docto-despes.seq-wt-docto    = p-seq-wt-docto
         AND wt-it-docto-despes.seq-wt-it-docto = p-seq-wt-it-docto:

       IF NOT wt-it-docto-despes.log-forma-preco THEN NEXT.

       &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN 
           IF wt-it-docto-despes.log-despes-inclusa THEN DO:
       &ELSE
           IF trim(substring(wt-it-docto-despes.cod-livre-1,1,1)) = "1":U THEN DO:
       &ENDIF
              ASSIGN p-vl-despesas      = p-vl-despesas + wt-it-docto-despes.val-despes-ped
                     pl-desp-exportacao = YES.
           END.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDespesasInclusasCabecalho DBOProgram 
PROCEDURE piRetornaDespesasInclusasCabecalho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-seq-wt-docto     LIKE wt-docto.seq-wt-docto         NO-UNDO.
    DEF OUTPUT PARAM pl-desp-exportacao AS   LOGICAL                       NO-UNDO.
    
    FOR EACH wt-docto-despes NO-LOCK
       WHERE wt-docto-despes.seq-wt-docto    = p-seq-wt-docto:

       IF NOT wt-docto-despes.log-forma-preco THEN NEXT.
       &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN 
           IF wt-docto-despes.log-despes-inclusa THEN DO:
       &ELSE
           IF trim(substring(wt-docto-despes.cod-livre-1,1,1)) = "1":U THEN DO:
       &ENDIF
              ASSIGN pl-desp-exportacao = YES.
           END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaMoeda DBOProgram 
PROCEDURE piRetornaMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-seq-wt-docto    LIKE wt-docto.seq-wt-docto    NO-UNDO.
    DEF OUTPUT PARAM p-mo-codigo       LIKE ped-venda.mo-codigo      NO-UNDO.
    
    FOR FIRST wt-docto NO-LOCK
        WHERE wt-docto.seq-wt-docto = p-seq-wt-docto:

        FOR FIRST ped-venda NO-LOCK
            WHERE ped-venda.nome-abrev = wt-docto.nome-abrev
              AND ped-venda.nr-pedcli  = wt-docto.nr-pedcli:

            ASSIGN p-mo-codigo = ped-venda.mo-codigo.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaProxSequencia DBOProgram 
PROCEDURE piRetornaProxSequencia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-seq-wt-docto LIKE wt-docto.seq-wt-docto NO-UNDO.
    DEF OUTPUT PARAM p-new-seq      AS INTEGER                 NO-UNDO.

    ASSIGN p-new-seq = 1.

    FOR LAST bf{&TableName} NO-LOCK
       WHERE bf{&TableName}.seq-wt-docto = p-seq-wt-docto:

        ASSIGN p-new-seq = bf{&TableName}.seq-wt-docto-despes + 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaSituacaoMoeda DBOProgram 
PROCEDURE piRetornaSituacaoMoeda :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.
    DEF OUTPUT PARAM p-situacao    AS INT                     NO-UNDO.

    FOR FIRST param-exp NO-LOCK
        WHERE param-exp.cod-estabel = p-cod-estabel:

        ASSIGN p-situacao = param-exp.idi-moed-despes-export.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaComex DBOProgram 
PROCEDURE piVerificaComex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM p-l-bt-despesa AS LOGICAL NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF  AVAIL param-global AND
        param-global.modulo-ex THEN
        ASSIGN p-l-bt-despesa = YES.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaDespesas DBOProgram 
PROCEDURE piVerificaDespesas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT  PARAM p-seq-wt-docto LIKE wt-docto.seq-wt-docto NO-UNDO.
    DEF OUTPUT PARAM p-return       AS LOGICAL                 NO-UNDO.

    ASSIGN p-return = YES.

    IF  NOT CAN-FIND(FIRST wt-docto-despes
                     WHERE wt-docto-despes.seq-wt-docto = p-seq-wt-docto) THEN DO:

        ASSIGN p-return = NO.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RetornaDescPtoControle DBOProgram 
PROCEDURE RetornaDescPtoControle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM p-seq-wt-docto AS INTEGER                      NO-UNDO.
    DEFINE INPUT  PARAM p-pto-controle LIKE {&TableName}.cod-pto-contr NO-UNDO.
    DEFINE OUTPUT PARAM c-descricao    AS CHARACTER                    NO-UNDO.

    FOR FIRST wt-docto 
        WHERE wt-docto.seq-wt-docto = p-seq-wt-docto NO-LOCK:

        FOR FIRST processo-exp 
            WHERE processo-exp.cod-estabel = wt-docto.cod-estab-proces-export
              AND processo-exp.nr-proc-exp = wt-docto.nr-proc-exp NO-LOCK:

            FOR FIRST historico-proc-exp NO-LOCK
                WHERE historico-proc-exp.cod-estabel   = processo-exp.cod-estabel
                  AND historico-proc-exp.nr-proc-exp   = processo-exp.nr-proc-exp
                  AND historico-proc-exp.cod-itiner    = processo-exp.cod-itiner
                  AND historico-proc-exp.cod-pto-contr = p-pto-controle:
                ASSIGN c-descricao = historico-proc-exp.descricao.
            END.
        END.

        IF c-descricao = "":U THEN DO:
            FOR FIRST pto-contr NO-LOCK
                WHERE pto-contr.cod-pto-contr = p-pto-controle: 
                ASSIGN c-descricao = pto-contr.descricao.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDespesas DBOProgram 
PROCEDURE retornaDespesas :

    DEFINE INPUT PARAM pi-seq-wt-docto   AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM pi-pageSize       AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM pi-current-page   AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAM pi-totRecords    AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR ttRetornoDespesasExp.

    DEFINE VARIABLE cDescDespes AS CHARACTER NO-UNDO.
  
    RUN setConstraintWtDocto (INPUT pi-seq-wt-docto).
    RUN openQueryStatic      (INPUT "WtDocto":U).

    /*--- Retorna faixa de registro do DBO Filho ---*/
    RUN getBatchRecords (INPUT ?,
                         INPUT NO,
                         INPUT ?,
                         OUTPUT pi-totRecords,
                         OUTPUT TABLE rowobject).
   
    FOR EACH rowobject:
        CREATE ttDespesasExp.
        ASSIGN ttDespesasExp.codItiner        = rowobject.cod-itiner
               ttDespesasExp.codPtoContr      = rowobject.cod-pto-contr
               ttDespesasExp.cdnDespes        = rowobject.cdn-despes
               ttDespesasExp.codEmitenteDesp  = rowobject.cod-emitente-desp
               ttDespesasExp.moCodigo         = rowobject.mo-codigo
               ttDespesasExp.codCondPagto     = rowobject.cod-cond-pagto
               ttDespesasExp.classDespes      = rowobject.cdn-classif-despes
               ttDespesasExp.datPagto         = rowobject.dat-base-cobr-despes
               ttDespesasExp.comisAgentes     = rowobject.log-comis-agent
               ttDespesasExp.formaPreco       = rowobject.log-forma-preco
               ttDespesasExp.IntegraAp        = rowobject.log-despes-integr-ap
               ttDespesasExp.valMoedaDesp     = rowobject.val-despes
               ttDespesasExp.valDespesPed     = rowobject.val-despes-ped
               ttDespesasExp.seqWtDocto       = rowobject.seq-wt-docto
               ttDespesasExp.seqWtDoctoDespes = rowobject.seq-wt-docto-despes
               ttDespesasExp.descClassDespes  = {cxinc/i01cx205.i 04 rowobject.cdn-classif-despes}
               ttDespesasExp.log_desp_incl = IF SUBSTRING(rowobject.cod-livre-1,1,1) = "1"  THEN TRUE ELSE FALSE /*branco ou 2 = desmarcado/ 1 = marcado despesa inclusa*/
               ttDespesasExp.log_dest_desp = IF SUBSTRING(rowobject.cod-livre-1,2,1) <> "2" THEN TRUE ELSE FALSE.
               IF l-spp-vl-tot-fatur-parc THEN
                  ASSIGN  ttDespesasExp.log_val_tot_fat = IF SUBSTRING(rowobject.cod-livre-1,3,1) = '1' THEN TRUE ELSE FALSE.
                ELSE
                  ASSIGN  ttDespesasExp.log_val_tot_fat = FALSE.

        RUN piRetornaDescricaoDespesa (INPUT pi-seq-wt-docto,
                                       INPUT ttDespesasExp.cdnDespes,
                                       OUTPUT ttDespesasExp.descDespes).
             
    END.
    
    assign iPageSize     = pi-pageSize
           iCurrentPage  = pi-current-page.
    ASSIGN hTable = BUFFER ttDespesasExp:HANDLE
           cQuery = "FOR EACH ttDespesasExp"
           hTTReturn  = TEMP-TABLE ttRetornoDespesasExp:HANDLE
           hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistro IN THIS-PROCEDURE. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDespesasEmb DBOProgram 
PROCEDURE retornaDespesasEmb :
    DEFINE INPUT  PARAM pi-embarque     AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAM pi-resumo       AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAM pi-seq-wt-docto AS INTEGER NO-UNDO.
    
    FIND FIRST wt-docto 
         WHERE wt-docto.cdd-embarq = pi-embarque
           AND wt-docto.nr-resumo = pi-resumo NO-LOCK NO-ERROR.
    IF AVAIL wt-docto THEN
        ASSIGN pi-seq-wt-docto = wt-docto.seq-wt-docto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDespesasPed DBOProgram 
PROCEDURE retornaDespesasPed :
    DEFINE INPUT  PARAM pc-pedido       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pi-seq-wt-docto AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE c-label-export AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lcomex AS LOGICAL NO-UNDO.
     /*Verifica se m¢dulo de esportaá∆o est† implantado*/
    RUN piVerificaComex (OUTPUT lcomex).
    IF NOT lcomex THEN DO:
        {utp/ut-liter.i "Exportaá∆o"}
        ASSIGN c-label-export = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2082,
                           INPUT c-label-export).

        CREATE RowErrors.
        ASSIGN RowErrors.ErrorNumber = 2082
               RowErrors.ErrorDescription = RETURN-VALUE.
        RUN utp/ut-msgs.p (INPUT "help":U,
                           INPUT 2082,
                           INPUT c-label-export).
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE
               RowErrors.ErrorSubType = "ERROR":U.

        RETURN "NOK":U.
    END.
   
    FIND FIRST wt-docto 
         WHERE wt-docto.nr-pedcli = pc-pedido NO-LOCK NO-ERROR.
    IF AVAIL wt-docto THEN DO:
        IF NOT CAN-FIND (FIRST emitente 
                         WHERE emitente.cod-emitente = wt-docto.cod-emitente
                          AND (emitente.natureza = 3 OR emitente.natureza = 4)) THEN DO:
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 47033,
                               INPUT "").
            CREATE RowErrors.
            ASSIGN RowErrors.ErrorNumber = 47033
                   RowErrors.ErrorDescription = RETURN-VALUE.
            {utp/ut-liter.i "O cliente do pedido n∆o Ç estrangeiro."}
            ASSIGN RowErrors.ErrorHelp = RETURN-VALUE
                   RowErrors.ErrorSubType = "ERROR":U.
        END.
        ELSE
            ASSIGN pi-seq-wt-docto = wt-docto.seq-wt-docto.
    END.
       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaEmbarques DBOProgram 
PROCEDURE retornaEmbarques :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna os embarques a serem consultados respeitando a paginaá∆o
  Parameters:  cEmbarques: Lista de c¢digos de embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input  PARAM cEmbarques          AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAM pi-pageSize         AS INTEGER      NO-UNDO.
    DEFINE INPUT  PARAM pi-current-page     AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAM pi-totRecords       AS INTEGER      NO-UNDO.
    DEFINE OUTPUT PARAM table for ttRetornoEmbarquesDespExp.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE de-embarq   AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cont       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lcomex     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE lEstrangeiro AS LOGICAL   NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.

    /*Verifica se m¢dulo de esportaá∆o est† implantado*/
    RUN piVerificaComex (OUTPUT lcomex).
    IF NOT lcomex THEN DO:
        
        {utp/ut-liter.i "M¢dulo de Exportaá∆o n∆o est† implantado."}
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.
        RETURN "NOK":U.
    END.

    REPEAT:
        ASSIGN cont = cont + 1
               de-embarq = DEC(ENTRY(cont,cEmbarques,",")).

        FOR FIRST embarque 
            WHERE embarque.cdd-embarq = de-embarq NO-LOCK:
            
            /*Verifica se existe ao menos um resumo para fornecedor estrangeiro*/
            FOR EACH res-cli FIELDS (cdd-embarq nome-abrev)
                 WHERE res-cli.cdd-embarq = embarque.cdd-embarq NO-LOCK:
                IF CAN-FIND (FIRST emitente 
                             WHERE emitente.nome-abrev = res-cli.nome-abrev
                               AND (emitente.natureza = 3 OR emitente.natureza = 4)) THEN DO:
                    ASSIGN lEstrangeiro = YES.
                    LEAVE.
                END.

            END.

            /*Se existir resumo para fornecedor estrangeiro cria a temp-table*/
            IF lEstrangeiro THEN DO:
                CREATE ttEmbarquesDespExp.
                ASSIGN ttEmbarquesDespExp.embarque   = embarque.cdd-embarq
                       ttEmbarquesDespExp.codEstabel = embarque.cod-estabel
                       ttEmbarquesDespExp.dtEmbarque = embarque.dt-embarque.
                ASSIGN pi-totRecords = pi-totRecords + 1
                       lEstrangeiro = NO.
            END.
        END.
        
        IF cont = NUM-ENTRIES(cEmbarques) THEN LEAVE.
    END.

    IF CAN-FIND(FIRST ttEmbarquesDespExp) THEN DO:

        assign iPageSize     = pi-pageSize
               iCurrentPage  = pi-current-page.
        ASSIGN hTable = BUFFER ttEmbarquesDespExp:HANDLE
               cQuery = "FOR EACH ttEmbarquesDespExp"
               hTTReturn  = TEMP-TABLE ttRetornoEmbarquesDespExp:HANDLE
               hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.
    
        RUN retornaRegistro IN THIS-PROCEDURE.  
    END.
    ELSE DO: /*Quado n∆o existir nenhum resumos para fornecedor estrangeiro nos embarques selecionados*/
        {utp/ut-liter.i "Os embarques selecionados n∆o possuem resumos de fornecedores estrangeiros."}
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorDescription = RETURN-VALUE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistro DBOProgram 
PROCEDURE retornaRegistro :
    DEFINE VARIABLE qhTeste    AS HANDLE  NO-UNDO.
    DEFINE VARIABLE i          AS INTEGER NO-UNDO.
    
    /* Verifica qual serˇ o primeiro registro da prΩxima pagina*/
    ASSIGN iInitialPage = 1 + (iCurrentPage - 1) * iPageSize.

    CREATE QUERY qhTeste.
    qhTeste:SET-BUFFERS(hTable). 
    qhTeste:QUERY-PREPARE(cQuery).
    qhTeste:QUERY-OPEN().

    
        /*Posiciona no registro previamente calculado */
    qhTeste:REPOSITION-TO-ROW(iInitialPage).
      
    REPEAT i = 1 TO iPageSize:
        qhTeste:GET-NEXT().
        IF qhTeste:QUERY-OFF-END THEN LEAVE.
        
        hbTTReturn:BUFFER-CREATE().
        hbTTReturn:BUFFER-COPY(hTable).
        hbTTReturn:BUFFER-RELEASE().
    END.

    qhTeste:QUERY-CLOSE().
    DELETE OBJECT qhTeste. 

    IF VALID-HANDLE(qhTeste) THEN
            DELETE OBJECT qhTeste.
    IF VALID-HANDLE(hTTReturn) THEN
            DELETE OBJECT hTTReturn.
    IF VALID-HANDLE(hTable) THEN
            DELETE OBJECT hTable.
    IF VALID-HANDLE(hbTTReturn) THEN
            DELETE OBJECT hbTTReturn.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaResumos DBOProgram 
PROCEDURE retornaResumos :
/*:T------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcEmbarque       AS DECIMAL     NO-UNDO.
    DEFINE INPUT  PARAMETER pi-pageSize      AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pi-current-page  AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-totRecords    AS INTEGER     NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR ttRetornoResumosDespExp.
    
    FOR EACH res-cli FIELDS (cdd-embarq nr-resumo nome-abrev) 
       WHERE res-cli.cdd-embarq = pcEmbarque NO-LOCK:
        
        IF CAN-FIND (FIRST emitente 
                     WHERE emitente.nome-abrev = res-cli.nome-abrev
                      AND (emitente.natureza = 3 OR emitente.natureza = 4)) THEN DO:
            
            CREATE ttResumosDespExp.
            ASSIGN ttResumosDespExp.resumo = res-cli.nr-resumo.
            ASSIGN pi-totRecords = pi-totRecords + 1.
        END.
    END.

    assign iPageSize     = pi-pageSize
           iCurrentPage  = pi-current-page.

    ASSIGN hTable = BUFFER ttResumosDespExp:HANDLE
           cQuery = "FOR EACH ttResumosDespExp"
           hTTReturn  = TEMP-TABLE ttRetornoResumosDespExp:HANDLE
           hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistro IN THIS-PROCEDURE.      

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaSeqWtDocto DBOProgram 
PROCEDURE retornaSeqWtDocto :
/*------------------------------------------------------------------------------
  Purpose:    Retorna a sequància da wt-docto atravÇs do embarque
                 para gerar despesas
  Parameters: pdEmbarque  -> N£mero do Embarque
              pcSeqWtDocto -> Retorna a Sequància
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdEmbarque   LIKE embarque.cdd-embarq   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSeqWtDocto LIKE wt-docto.seq-wt-docto NO-UNDO.
    
    FIND FIRST embarque NO-LOCK
        WHERE embarque.cdd-embarq = pdEmbarque NO-ERROR.
    IF AVAIL embarque THEN DO:
        FIND FIRST wt-docto NO-LOCK
            WHERE wt-docto.nr-proc-exp = embarque.nr-proc-exp NO-ERROR.
        IF AVAIL wt-docto THEN
            ASSIGN pcSeqWtDocto = wt-docto.seq-wt-docto.
    END.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvarDespesas DBOProgram 
PROCEDURE salvarDespesas :
    DEFINE INPUT  PARAMETER TABLE FOR ttDespesasExp.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE cAction               AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-new-seq             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-seq-wt-docto-despes AS INTEGER   NO-UNDO.

    EMPTY TEMP-TABLE RowErrors.
    EMPTY TEMP-TABLE RowObject.

    FOR EACH ttDespesasExp:
        CREATE tt-wt-docto-despes-aux.
        ASSIGN tt-wt-docto-despes-aux.cod-itiner           = ttDespesasExp.codItiner
               tt-wt-docto-despes-aux.cod-pto-contr        = ttDespesasExp.codPtoContr
               tt-wt-docto-despes-aux.cdn-despes           = ttDespesasExp.cdnDespes
               tt-wt-docto-despes-aux.cod-emitente-desp    = ttDespesasExp.codEmitenteDesp
               tt-wt-docto-despes-aux.mo-codigo            = ttDespesasExp.moCodigo
               tt-wt-docto-despes-aux.cod-cond-pagto       = ttDespesasExp.codCondPagto
               tt-wt-docto-despes-aux.cdn-classif-despes   = ttDespesasExp.classDespes
               tt-wt-docto-despes-aux.dat-base-cobr-despes = ttDespesasExp.datPagto
               tt-wt-docto-despes-aux.log-comis-agent      = ttDespesasExp.comisAgentes
               tt-wt-docto-despes-aux.log-forma-preco      = ttDespesasExp.formaPreco
               tt-wt-docto-despes-aux.log-despes-integr-ap = ttDespesasExp.integraAp
               tt-wt-docto-despes-aux.val-despes           = ttDespesasExp.valMoedaDesp
               tt-wt-docto-despes-aux.val-despes-ped       = ttDespesasExp.valDespesPed
               tt-wt-docto-despes-aux.seq-wt-docto         = ttDespesasExp.seqWtDocto
               tt-wt-docto-despes-aux.seq-wt-docto-despes  = ttDespesasExp.seqWtDoctoDespes
               OVERLAY(tt-wt-docto-despes-aux.cod-livre-1,1,1)  = IF ttDespesasExp.log_desp_incl THEN "1" ELSE "2"
               OVERLAY(tt-wt-docto-despes-aux.cod-livre-1,2,1)  = IF ttDespesasExp.log_dest_desp THEN "1" ELSE "2"               
               OVERLAY(tt-wt-docto-despes-aux.cod-livre-1,3,1)  = IF ttDespesasExp.log_val_tot_fat THEN "1" ELSE "2".

        ASSIGN i-seq-wt-docto = ttDespesasExp.seqWtDocto
               i-seq-wt-docto-despes = ttDespesasExp.seqWtDoctoDespes
               cAction = IF ttDespesasExp.seqWtDoctoDespes = 0 THEN "create":U ELSE "update":U.
       
    END.

    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "WtDocto":U).
    RUN corrigeRowErrors.

    IF cAction = "create":U THEN DO:
        RUN piRetornaProxSequencia(INPUT i-seq-wt-docto,
                                   OUTPUT i-new-seq).
        FOR EACH tt-wt-docto-despes-aux:
            ASSIGN tt-wt-docto-despes-aux.seq-wt-docto-despes = i-new-seq.
        END.

        RUN setRecord      IN THIS-PROCEDURE(INPUT TABLE tt-wt-docto-despes-aux).
        RUN validateRecord IN THIS-PROCEDURE (INPUT "Create":U).
        IF RETURN-VALUE <> "NOK":U THEN DO:
            RUN createRecord IN THIS-PROCEDURE.
        END.
    END.
    ELSE DO:
         RUN goToKey IN THIS-PROCEDURE (INPUT i-seq-wt-docto,
                                        INPUT i-seq-wt-docto-despes).
        FIND FIRST tt-wt-docto-despes-aux NO-LOCK NO-ERROR.
        IF AVAIL tt-wt-docto-despes-aux THEN
            BUFFER-COPY tt-wt-docto-despes-aux TO rowObject NO-ERROR.
        RUN validateRecord IN THIS-PROCEDURE (INPUT "Update":U).
        IF RETURN-VALUE <> "NOK":U THEN DO:
            RUN updateRecord IN THIS-PROCEDURE.
        END.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintWtDocto DBOProgram 
PROCEDURE setConstraintWtDocto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM p-seq-wt-docto LIKE wt-docto.seq-wt-docto NO-UNDO.

    ASSIGN i-seq-wt-docto = p-seq-wt-docto.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setgetTotalDespesas DBOProgram 
PROCEDURE setgetTotalDespesas :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para passar parÉmetros em metadados
  Parameters:  pi-seq-wt-docto = Sequància
               pc-itinerario   = Itiner†rio
               pc-moeda        = Moeda
               pi-tot-frete    = Total do Frete
               pi-tot-seguro   = Total Seguro
               pi-tot-embal    = Total Embalagem
               pi-tot-comis    = Total Comiss∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pi-seq-wt-docto AS INTEGER  NO-UNDO.
    DEFINE OUTPUT PARAM pc-itinerario   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pc-moeda        AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pi-tot-frete    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pi-tot-seguro   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pi-tot-embal    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pi-tot-comis    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE de-tot-frete    AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-tot-seguro   AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-tot-embal    AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE de-tot-comis    AS DECIMAL  NO-UNDO.
    
    RUN totalizaDespesas (INPUT  pi-seq-wt-docto,
                          OUTPUT pc-itinerario,
                          OUTPUT pc-moeda,
                          OUTPUT de-tot-frete,
                          OUTPUT de-tot-seguro,
                          OUTPUT de-tot-embal,
                          OUTPUT de-tot-comis).
      
    ASSIGN pi-tot-frete     = STRING(de-tot-frete)
           pi-tot-seguro    = STRING(de-tot-seguro)
           pi-tot-embal     = STRING(de-tot-embal)
           pi-tot-comis     = STRING(de-tot-comis).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE totalizaDespesas DBOProgram 
PROCEDURE totalizaDespesas :
    DEFINE INPUT  PARAM pi-seq-wt-docto     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM pc-itinerario       AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pc-moeda            AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pi-tot-frete        AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAM pi-tot-seguro       AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAM pi-tot-embal        AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAM pi-tot-comis        AS DECIMAL   NO-UNDO.

    DEFINE VARIABLE i-mo-codigo       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-desc-mo-codigo  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-cod-itiner      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-desc-cod-itiner AS CHARACTER NO-UNDO.

    RUN piRetornaDados (INPUT  pi-seq-wt-docto,
                        OUTPUT i-mo-codigo,
                        OUTPUT i-desc-mo-codigo,
                        OUTPUT i-cod-itiner,
                        OUTPUT i-desc-cod-itiner).

    ASSIGN pc-itinerario = string(i-cod-itiner) + " - " + i-desc-cod-itiner
           pc-moeda      = string(i-mo-codigo) + " - " + i-desc-mo-codigo.

    ASSIGN pi-tot-frete  = 0
           pi-tot-seguro = 0
           pi-tot-embal  = 0
           pi-tot-comis  = 0.

    FOR EACH wt-docto-despes NO-LOCK
       WHERE wt-docto-despes.seq-wt-docto = pi-seq-wt-docto
         AND wt-docto-despes.log-forma-preco:

        CASE wt-docto-despes.cdn-classif-despes:
            /*Frete*/
            WHEN 2 THEN DO:
                ASSIGN pi-tot-frete = pi-tot-frete
                                    + wt-docto-despes.val-despes-ped.
            END.
            /*Seguro*/
            WHEN 3 THEN DO:
                ASSIGN pi-tot-seguro = pi-tot-seguro
                                     + wt-docto-despes.val-despes-ped.
            END.
            /*Embalagem*/
            WHEN 4 THEN DO:
                ASSIGN pi-tot-embal = pi-tot-embal
                                    + wt-docto-despes.val-despes-ped.
            END.
        END CASE.

        /*Comissío*/
        IF  wt-docto-despes.log-comis-agent THEN DO:
            ASSIGN pi-tot-comis = pi-tot-comis
                                + wt-docto-despes.val-despes-ped.
        END.
    END.
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
    
    DEFINE VAR c-erro AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    DEF VAR p-mo-codigo LIKE moeda.mo-codigo NO-UNDO.

    IF  pType = "Create":U THEN DO:

        IF CAN-FIND(FIRST bf{&TableName}
                    WHERE bf{&TableName}.seq-wt-docto = rowObject.seq-wt-docto
                      AND bf{&TableName}.cdn-despes   = rowObject.cdn-despes) THEN DO:

                
            {utp/ut-liter.i "Despesa Inv†lida"}
            ASSIGN c-erro = RETURN-VALUE + '~~'.
            {utp/ut-liter.i "A despesa"}
            ASSIGN c-erro = c-erro + RETURN-VALUE + ' ' + string(RowObject.cdn-despes).
            {utp/ut-liter.i "j† foi informada em outra sequencia deste documento"}
            ASSIGN c-erro = c-erro + ' ' + RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="17006"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=c-erro}
        END.
    END.

    IF  pType = "Create":U OR
        pType = "Update":U THEN DO:

        FIND FIRST pto-contr NO-LOCK
             WHERE pto-contr.cod-pto-contr = RowObject.cod-pto-contr NO-ERROR.
        IF  NOT AVAIL pto-contr THEN DO:

            {utp/ut-liter.i "Ponto de Controle"}
            ASSIGN c-erro = RETURN-VALUE.

            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=c-erro}
        END.
    
        FIND FIRST pto-itiner NO-LOCK
             WHERE pto-itiner.cod-itiner    = RowObject.cod-itiner
               AND pto-itiner.cod-pto-contr = RowObject.cod-pto-contr NO-ERROR.
        IF  NOT AVAIL pto-itiner THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="30785"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=" string(RowObject.cod-pto-contr) + '~~~~' + string(RowObject.cdn-despes) + '~~~~' + string(RowObject.cod-itiner)"}
        END.
    
        IF  RowObject.cod-emitente-desp = 0 THEN DO:

            {utp/ut-liter.i "Fornecedor Despesa"}
            ASSIGN c-erro = RETURN-VALUE.
           {method/svc/errors/inserr.i
                        &ErrorNumber="265"
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U
                        &ErrorParameters=c-erro}
        END.
        ELSE DO:
            FIND FIRST emitente NO-LOCK
                 WHERE emitente.cod-emitente = RowObject.cod-emitente-desp NO-ERROR.
            IF NOT AVAIL emitente THEN DO:
                 {utp/ut-liter.i "Fornecedor Despesa"}
                 ASSIGN c-erro = RETURN-VALUE.
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="Error":U
                                            &ErrorParameters=c-erro}
            END.
            ELSE IF emitente.identific = 1 THEN DO:
                   {utp/ut-liter.i "Emitente"}
                    ASSIGN c-erro = RETURN-VALUE.
                   {method/svc/errors/inserr.i &ErrorNumber="25370"  /* emitente n∆o Ç fornecedor */
                                               &ErrorType="EMS":U
                                               &ErrorSubType="Error":U
                                               &ErrorParameters=c-erro}
            END.
        END.
    
        FIND FIRST desp-imp NO-LOCK
             WHERE desp-imp.cod-desp = RowObject.cdn-despes NO-ERROR.
        IF  NOT AVAIL desp-imp THEN DO:

            {utp/ut-liter.i "Despesa de Exportaá∆o"}
            ASSIGN c-erro = RETURN-VALUE.
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=c-erro}
        END.
    
        FIND FIRST moeda NO-LOCK
             WHERE moeda.mo-codigo = RowObject.mo-codigo NO-ERROR.
        IF  NOT AVAIL moeda THEN DO:
            {utp/ut-liter.i "Moeda"}
            ASSIGN c-erro = RETURN-VALUE.
            {method/svc/errors/inserr.i &ErrorNumber="2"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=c-erro}
        END.
    
        IF  RowObject.cod-cond-pagto > 0 THEN
            IF  NOT CAN-FIND(FIRST cond-pagto
                             WHERE cond-pagto.cod-cond-pag = RowObject.cod-cond-pagto) THEN DO:
                {utp/ut-liter.i "Condiá∆o de Pagamento"}
                ASSIGN c-erro = RETURN-VALUE.
                {method/svc/errors/inserr.i &ErrorNumber="2"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="Error":U
                                            &ErrorParameters=c-erro}
            END.

        IF  RowObject.log-despes-integr-ap
        AND RowObject.cod-cond-pagto = 0 THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="2118"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters="''"}

        END.
            
        
        IF  RowObject.cdn-classif-despes < 1 OR
            RowObject.cdn-classif-despes > 4 THEN DO:
            
            {utp/ut-liter.i "Classificaá∆o da Despesa"}
            ASSIGN c-erro = RETURN-VALUE + '~~'.
            {utp/ut-liter.i "Nenhum"}
            ASSIGN c-erro = c-erro + "01=" + RETURN-VALUE + ", ".
            {utp/ut-liter.i "Frete"}
            ASSIGN c-erro = c-erro + "02=" + RETURN-VALUE + ", ".
            {utp/ut-liter.i "Seguro"}
            ASSIGN c-erro = c-erro + "03=" + RETURN-VALUE + ", ou ".
            {utp/ut-liter.i "Embalagem"}
            ASSIGN c-erro = c-erro + "04=" + RETURN-VALUE + ",".

            {method/svc/errors/inserr.i &ErrorNumber="17541"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=c-erro}
        END.
        
        IF  RowObject.val-despes <= 0 THEN DO:
            
            {utp/ut-liter.i "Valor da Despesa"}
            ASSIGN c-erro = RETURN-VALUE.
            {method/svc/errors/inserr.i &ErrorNumber="36"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=c-erro}
        END.
    
        IF  RowObject.log-forma-preco <> YES AND
            RowObject.log-forma-preco <> NO  THEN DO:

            {utp/ut-liter.i "Indicador Forma Preáo de Venda"}
             ASSIGN c-erro = RETURN-VALUE.
            {method/svc/errors/inserr.i &ErrorNumber="36"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=c-erro}
        END.

        IF  RowObject.val-despes = ? THEN DO:
            {method/svc/errors/inserr.i &ErrorNumber="1847"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters="STRING(rowObject.mo-codigo) + '~~~~' + STRING(TODAY)"}
        END.

        IF  RowObject.val-despes-ped = ? THEN DO:
            /* Moeda do Pedido */
            RUN piRetornaMoeda IN THIS-PROCEDURE (INPUT  rowObject.seq-wt-docto,
                                                  OUTPUT p-mo-codigo).
            {method/svc/errors/inserr.i &ErrorNumber="1847"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters="STRING(p-mo-codigo) + '~~~~' + STRING(TODAY)"}
        END.

        IF  RowObject.log-forma-preco    = YES 
        AND RowObject.cdn-classif-despes = 1 THEN DO: /*n∆o permite criaá∆o de despesa de exportaá∆o com classificaá∆o "nenhum"*/
            
             {utp/ut-liter.i "Classificaá∆o da Despesa"}
             ASSIGN c-erro = RETURN-VALUE.
            {method/svc/errors/inserr.i &ErrorNumber="33332"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="Error":U
                                        &ErrorParameters=c-erro}

        END.

    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaDespesaAFaturar DBOProgram 
PROCEDURE VerificaDespesaAFaturar :
/*------------------------------------------------------------------------------
  Purpose:  Verifica se existe alguma despesa a faturar para o ponto de controle no processo.    
  Parameters:  <none>
  Notes:    Se o parÉmetro pi-cod-desp n∆o estiver informado (?)  n∆o considera na busca.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-estabel LIKE historico-proc-exp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-proc-exp LIKE historico-proc-exp.nr-proc-exp NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-itiner  LIKE historico-proc-exp.cod-itiner  NO-UNDO.
    DEFINE INPUT  PARAMETER pi-sequencia   LIKE historico-proc-exp.sequencia   NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-desp    LIKE proc-desp-itiner.cod-desp      NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-existe      AS LOGICAL                          NO-UNDO.

    FOR EACH wt-docto NO-LOCK
       WHERE wt-docto.cod-estab-proces-export = pc-cod-estabel
         AND wt-docto.nr-proc-exp             = pc-nr-proc-exp:

        ASSIGN pl-existe = CAN-FIND(FIRST wt-docto-despes
                                    WHERE wt-docto-despes.seq-wt-docto = wt-docto.seq-wt-docto
                                      AND wt-docto-despes.cod-itiner   = pi-cod-itiner
                                      AND wt-docto-despes.sequencia    = pi-sequencia
                                      AND ((pi-cod-desp <> ? AND wt-docto-despes.cdn-despes = pi-cod-desp)
                                       OR pi-cod-desp = ?)).
        IF pl-existe THEN LEAVE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDescricaoDespesa DBOProgram 
PROCEDURE piRetornaDescricaoDespesa :
/*------------------------------------------------------------------------------
  Purpose:  Retorna descriá∆o da despesa.
  Parameters:  (input) pi-seq-wt-docto : Sequància do documento (integer)
               (input) pi-cod-desp     : C¢digo da despesa      (integer)
               (output) c-desc-despesa : Descriá∆o da despesa   (character)
  Notes:    Se o campo descriá∆o da tabela n∆o estiver vazio ("") retorna proc-desp-itiner.descricao
            sen∆o ir† retornar desp-imp.descricao.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pi-seq-wt-docto LIKE wt-docto.seq-wt-docto       NO-UNDO.
    DEFINE INPUT  PARAMETER pi-cod-desp     LIKE proc-desp-itiner.cod-desp   NO-UNDO.
    DEFINE OUTPUT PARAMETER c-desc-despesa  LIKE proc-desp-itiner.descricao  NO-UNDO.

    FOR FIRST wt-docto FIELDS(cod-estab-proces-export nr-proc-exp) 
        WHERE wt-docto.seq-wt-docto = pi-seq-wt-docto NO-LOCK:

        FOR FIRST processo-exp FIELDS(cod-estabel nr-proc-exp)
            WHERE processo-exp.nr-proc-exp = wt-docto.nr-proc-exp
              AND processo-exp.cod-estabel = wt-docto.cod-estab-proces-export:

            FOR FIRST proc-desp-itiner FIELDS(descricao)
                WHERE proc-desp-itiner.cod-estabel = processo-exp.cod-estabel
                  AND proc-desp-itiner.nr-proc-exp = processo-exp.nr-proc-exp
                  AND proc-desp-itiner.cod-desp    = pi-cod-desp NO-LOCK: 
    
                ASSIGN c-desc-despesa = proc-desp-itiner.descricao.
            END.
        END.

        IF c-desc-despesa = "":U THEN DO:
            FOR FIRST desp-imp FIELDS(descricao)
                WHERE desp-imp.cod-desp = pi-cod-desp NO-LOCK: 

                ASSIGN c-desc-despesa = desp-imp.descricao.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
