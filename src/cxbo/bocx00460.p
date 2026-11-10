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
{include/i-prgvrs.i BOCX00460 2.00.00.074 } /*** "010074" 21/09/2026 08:57:01 ***/
/* ***************************  Definitions  ***************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOCX00460
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName due-item
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

{include/i-epc200.i bocx00460} /*include para customizaá‰es via EPC*/

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{cxbo/bocx00460.i RowObject}
{cxbo/bocx00460.i tt-due-item-create}
DEFINE TEMP-TABLE tt-erro-nota NO-UNDO
    FIELD cod-estabel LIKE nota-fiscal.cod-estabel
    FIELD serie       LIKE nota-fiscal.serie
    FIELD nr-nota-fis LIKE nota-fiscal.nr-nota-fis
    FIELD seq-erro    AS   INTEGER.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*Definiá∆o de Vari†veis*/
DEFINE VARIABLE de-cdd-due-ems           LIKE due-item.cdd-due-ems             NO-UNDO.
DEFINE VARIABLE i-num-seq-it-due-ini     LIKE due-item.num-seq-it-due          NO-UNDO.
DEFINE VARIABLE i-num-seq-it-due-fim     LIKE due-item.num-seq-it-due          NO-UNDO.
DEFINE VARIABLE c-cod-estab-nf-ini       LIKE due-item.cod-estabel-nf          NO-UNDO.
DEFINE VARIABLE c-cod-estab-nf-fim       LIKE due-item.cod-estabel-nf          NO-UNDO.
DEFINE VARIABLE c-cod-serie-nf-ini       LIKE due-item.cod-serie-nf            NO-UNDO.
DEFINE VARIABLE c-cod-serie-nf-fim       LIKE due-item.cod-serie-nf            NO-UNDO.
DEFINE VARIABLE c-nr-nota-ini            LIKE due-item.cod-nota-fisc           NO-UNDO.
DEFINE VARIABLE c-nr-nota-fim            LIKE due-item.cod-nota-fisc           NO-UNDO.
DEFINE VARIABLE i-num-seq-fat-ini        LIKE due-item.num-seq-faturam         NO-UNDO.
DEFINE VARIABLE i-num-seq-fat-fim        LIKE due-item.num-seq-faturam         NO-UNDO.
DEFINE VARIABLE c-it-codigo-ini          LIKE due-item.cod-item                NO-UNDO.
DEFINE VARIABLE c-it-codigo-fim          LIKE due-item.cod-item                NO-UNDO.
DEFINE VARIABLE c-cod-estab-proc-exp-ini LIKE due-item.cod-estab-proces-export NO-UNDO.
DEFINE VARIABLE c-cod-estab-proc-exp-fim LIKE due-item.cod-estab-proces-export NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp-ini        LIKE due-item.cod-proces-export       NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp-fim        LIKE due-item.cod-proces-export       NO-UNDO.
DEFINE VARIABLE i-num-versao-due         LIKE due-item.num-versao-due          NO-UNDO.
DEFINE VARIABLE c-lb-seq-item            AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-lbl-destaq             AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-lbl-help               AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-lbl-help2              AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE c-lbl-help3              AS   CHARACTER                        NO-UNDO.
DEFINE VARIABLE h-exapi030               AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx00463              AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx00466              AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx00469              AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx00472              AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE h-bocx00458              AS   HANDLE                           NO-UNDO.
DEFINE VARIABLE l-fn-due-v3              AS   LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-fn-due-atributo        AS   LOGICAL                          NO-UNDO.
DEFINE VARIABLE l-fn-cidade-cif          AS   LOGICAL                          NO-UNDO.
DEFINE VARIABLE de-val-cond-vda          LIKE due-item.val-cond-vda            NO-UNDO.
DEFINE VARIABLE de-val-local-embarq      LIKE due-item.val-local-embarq        NO-UNDO.
DEFINE VARIABLE i-idi-sit-siscomex       LIKE due-siscomex.idi-sit-siscomex    NO-UNDO.

{utp/ut-liter.i "o_item_com_sequància" *}
ASSIGN c-lb-seq-item = RETURN-VALUE.

{cdp/cdapi1004.i1} /* Variaveis usadas na API de Log */

ASSIGN l-fn-due-v3       = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-due-v3":U            AND funcao.ativo)
       l-fn-due-atributo = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-due-atrib-classif":U AND funcao.ativo)
       l-fn-cidade-cif   = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-cidade-cif-due":U    AND funcao.ativo).

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
        WHEN "cod-estabel-nf":U THEN ASSIGN pFieldValue = RowObject.cod-estabel-nf.
        WHEN "cod-estab-proces-export":U THEN ASSIGN pFieldValue = RowObject.cod-estab-proces-export.
        WHEN "cod-incoterm":U THEN ASSIGN pFieldValue = RowObject.cod-incoterm.
        WHEN "cod-item":U THEN ASSIGN pFieldValue = RowObject.cod-item.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-nota-fisc":U THEN ASSIGN pFieldValue = RowObject.cod-nota-fisc.
        WHEN "cod-pais-dest-final":U THEN ASSIGN pFieldValue = RowObject.cod-pais-dest-final.
        WHEN "cod-proces":U THEN ASSIGN pFieldValue = RowObject.cod-proces.
        WHEN "cod-proces-export":U THEN ASSIGN pFieldValue = RowObject.cod-proces-export.
        WHEN "cod-serie-nf":U THEN ASSIGN pFieldValue = RowObject.cod-serie-nf.
        WHEN "cod-un-estatis":U THEN ASSIGN pFieldValue = RowObject.cod-un-estatis.
        WHEN "des-compl-item":U THEN ASSIGN pFieldValue = RowObject.des-compl-item.
        WHEN "des-justif-valores":U THEN ASSIGN pFieldValue = RowObject.des-justif-valores.
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
        WHEN "cdd-due-ems":U THEN ASSIGN pFieldValue = RowObject.cdd-due-ems.
        WHEN "qtd-dias":U THEN ASSIGN pFieldValue = RowObject.qtd-dias.
        WHEN "qtd-estatis":U THEN ASSIGN pFieldValue = RowObject.qtd-estatis.
        WHEN "qtd-estatis-pais-dest":U THEN ASSIGN pFieldValue = RowObject.qtd-estatis-pais-dest.
        WHEN "val-cond-vda":U THEN ASSIGN pFieldValue = RowObject.val-cond-vda.
        WHEN "val-livre-1":U THEN ASSIGN pFieldValue = RowObject.val-livre-1.
        WHEN "val-livre-2":U THEN ASSIGN pFieldValue = RowObject.val-livre-2.
        WHEN "val-local-embarq":U THEN ASSIGN pFieldValue = RowObject.val-local-embarq.
        WHEN "val-perc-comis-agent":U THEN ASSIGN pFieldValue = RowObject.val-perc-comis-agent.
        WHEN "val-peso-liq-item":U THEN ASSIGN pFieldValue = RowObject.val-peso-liq-item.
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
        WHEN "cdn-destaque":U THEN ASSIGN pFieldValue = RowObject.cdn-destaque.
        WHEN "cdn-emitente":U THEN ASSIGN pFieldValue = RowObject.cdn-emitente.
        WHEN "cod-enquad-1":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-1.
        WHEN "cod-enquad-2":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-2.
        WHEN "cod-enquad-3":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-3.
        WHEN "cod-enquad-4":U THEN ASSIGN pFieldValue = RowObject.cod-enquad-4.
        WHEN "idi-tratam-priorit":U THEN ASSIGN pFieldValue = RowObject.idi-tratam-priorit.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-seq-faturam":U THEN ASSIGN pFieldValue = RowObject.num-seq-faturam.
        WHEN "num-seq-it-due":U THEN ASSIGN pFieldValue = RowObject.num-seq-it-due.
        WHEN "num-versao-due":U THEN ASSIGN pFieldValue = RowObject.num-versao-due.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice dueitnf_id2
  Parameters:  
               retorna valor do campo cdd-due-ems
               retorna valor do campo num-seq-it-due
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcdd-due-ems LIKE due-item.cdd-due-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq-it-due LIKE due-item.num-seq-it-due NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcdd-due-ems = RowObject.cdd-due-ems
           pnum-seq-it-due = RowObject.num-seq-it-due.

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
        WHEN "log-draw-integr-siscomex" THEN ASSIGN pFieldValue = RowObject.log-draw-integr-siscomex.
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
  Purpose:     Reposiciona registro com base no °ndice dueitnf_id2
  Parameters:  
               recebe valor do campo cdd-due-ems
               recebe valor do campo num-seq-it-due
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems LIKE due-item.cdd-due-ems NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-due LIKE due-item.num-seq-it-due NO-UNDO.

    FIND FIRST bfdue-item WHERE 
        bfdue-item.cdd-due-ems = pcdd-due-ems AND 
        bfdue-item.num-seq-it-due = pnum-seq-it-due NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdue-item THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdue-item)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItemNF DBOProgram 
PROCEDURE openQueryByItemNF :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query dos registros dos itens de acordo com a DU-E selecionada,
               realizando a ordenaá∆o pela nota fiscal
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems = de-cdd-due-ems NO-LOCK 
                                BY {&TABLENAME}.cdd-due-ems
                                BY {&TABLENAME}.num-seq-it-due
                                BY {&TABLENAME}.cod-item
                                BY {&TABLENAME}.cod-estabel-nf
                                BY {&TABLENAME}.cod-serie-nf
                                BY {&TABLENAME}.cod-nota-fisc
                                BY {&TABLENAME}.num-seq-faturam INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByItemProcExp DBOProgram 
PROCEDURE openQueryByItemProcExp :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query dos registros dos itens de acordo com a DU-E selecionada,
               realizando a ordenaá∆o pelo Processo de Exportaá∆o
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems = de-cdd-due-ems NO-LOCK 
                                BY {&TABLENAME}.cdd-due-ems
                                BY {&TABLENAME}.num-seq-it-due
                                BY {&TABLENAME}.cod-item
                                BY {&TABLENAME}.cod-estab-proces-export
                                BY {&TABLENAME}.cod-proces-export
                                BY {&TABLENAME}.cod-estabel-nf
                                BY {&TABLENAME}.cod-serie-nf
                                BY {&TABLENAME}.cod-nota-fisc
                                BY {&TABLENAME}.num-seq-faturam INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemNF DBOProgram 
PROCEDURE openQueryItemNF :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da Query utilizada no programa de de pesquisa 
               da Manutená∆o dos Itens da DU-E, folder "Notas Fiscais"
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems     =  de-cdd-due-ems 
                                 AND {&TABLENAME}.num-seq-it-due  >= i-num-seq-it-due-ini
                                 AND {&TABLENAME}.num-seq-it-due  <= i-num-seq-it-due-fim
                                 AND {&TABLENAME}.cod-estabel-nf  >= c-cod-estab-nf-ini  
                                 AND {&TABLENAME}.cod-estabel-nf  <= c-cod-estab-nf-fim  
                                 AND {&TABLENAME}.cod-serie-nf    >= c-cod-serie-nf-ini  
                                 AND {&TABLENAME}.cod-serie-nf    <= c-cod-serie-nf-fim  
                                 AND {&TABLENAME}.cod-nota-fisc   >= c-nr-nota-ini       
                                 AND {&TABLENAME}.cod-nota-fisc   <= c-nr-nota-fim       
                                 AND {&TABLENAME}.num-seq-faturam >= i-num-seq-fat-ini 
                                 AND {&TABLENAME}.num-seq-faturam <= i-num-seq-fat-fim 
                                 AND {&TABLENAME}.cod-item        >= c-it-codigo-ini     
                                 AND {&TABLENAME}.cod-item        <= c-it-codigo-fim  NO-LOCK 
                                BY {&TABLENAME}.cdd-due-ems
                                BY {&TABLENAME}.num-seq-it-due
                                BY {&TABLENAME}.cod-item       
                                BY {&TABLENAME}.cod-estabel-nf                         
                                BY {&TABLENAME}.cod-serie-nf    
                                BY {&TABLENAME}.cod-nota-fisc  
                                BY {&TABLENAME}.num-seq-faturam
                                INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItemProcExp DBOProgram 
PROCEDURE openQueryItemProcExp :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da Query utilizada no programa de de pesquisa 
               da Manutená∆o dos Itens da DU-E, folder "Processo Exp" 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems              =  de-cdd-due-ems 
                                 AND {&TABLENAME}.num-seq-it-due          >= i-num-seq-it-due-ini
                                 AND {&TABLENAME}.num-seq-it-due          <= i-num-seq-it-due-fim
                                 AND {&TABLENAME}.cod-estab-proces-export >= c-cod-estab-proc-exp-ini  
                                 AND {&TABLENAME}.cod-estab-proces-export <= c-cod-estab-proc-exp-fim  
                                 AND {&TABLENAME}.cod-proces-export       >= c-nr-proc-exp-ini         
                                 AND {&TABLENAME}.cod-proces-export       <= c-nr-proc-exp-fim NO-LOCK
                                    BY {&TABLENAME}.cdd-due-ems
                                    BY {&TABLENAME}.num-seq-it-due 
                                    BY {&TABLENAME}.cod-item       
                                    BY {&TABLENAME}.cod-estab-proces-export
                                    BY {&TABLENAME}.cod-proces-export
                                    BY {&TABLENAME}.cod-estabel-nf                         
                                    BY {&TABLENAME}.cod-serie-nf    
                                    BY {&TABLENAME}.cod-nota-fisc  
                                    BY {&TABLENAME}.num-seq-faturam INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Realiza abertura da query com todos os registros da tabela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDU-E DBOProgram 
PROCEDURE openQueryOfDU-E :
/*------------------------------------------------------------------------------
  Purpose:     Abre a query dos registros dos itens de acordo com a DU-E selecionada
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} FOR EACH {&TABLENAME} 
                               WHERE {&TABLENAME}.cdd-due-ems    = de-cdd-due-ems 
                                 AND {&TABLENAME}.num-versao-due = i-num-versao-due NO-LOCK 
                                BY {&TABLENAME}.cdd-due-ems
                                BY {&TABLENAME}.num-seq-it-due INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaInfoItensDue DBOProgram 
PROCEDURE piAtualizaInfoItensDue :
/*------------------------------------------------------------------------------
  Purpose: Atualiza as informaá‰es de tratamento priorit†rio e enquadramentos nos 
           itens da DU-e.    
  Parameters: pi-cdd-due-ems        (input - integer): N£mero interno da DU-e
              pi-idi-tratam-priorit (input - integer): Tratamento priorit†rio a ser atualizado nos itens
              pc-cod-enquad-1       (input - integer): Primeiro Enquadamento a ser atualizado nos itens 
              pc-cod-enquad-2       (input - integer): Segundo Enquadamento a ser atualizado nos itens 
              pc-cod-enquad-3       (input - integer): Terceiro Enquadamento a ser atualizado nos itens 
              pc-cod-enquad-4       (input - integer): Quarto Enquadamento a ser atualizado nos itens 
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-cdd-due-ems        LIKE due-siscomex.cdd-due-ems     NO-UNDO.
    DEFINE INPUT PARAMETER pi-idi-tratam-priorit LIKE due-item.idi-tratam-priorit NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-enquad-1       LIKE due-item.cod-enquad-1       NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-enquad-2       LIKE due-item.cod-enquad-2       NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-enquad-3       LIKE due-item.cod-enquad-3       NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-enquad-4       LIKE due-item.cod-enquad-4       NO-UNDO.

    FOR EACH due-item FIELDS (idi-tratam-priorit cod-enquad-1 cod-enquad-2 cod-enquad-3 cod-enquad-4) 
       WHERE due-item.cdd-due-ems = pi-cdd-due-ems EXCLUSIVE-LOCK:
        ASSIGN due-item.idi-tratam-priorit = pi-idi-tratam-priorit
               due-item.cod-enquad-1       = pc-cod-enquad-1      
               due-item.cod-enquad-2       = pc-cod-enquad-2      
               due-item.cod-enquad-3       = pc-cod-enquad-3      
               due-item.cod-enquad-4       = pc-cod-enquad-4.      
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaValorFinanciamento DBOProgram 
PROCEDURE piAtualizaValorFinanciamento :
/*------------------------------------------------------------------------------
  Purpose: Limpa a informaá∆o do Valor de Financiamento nos Itens da DU-E
  Parameters: p-cdd-due-ems    : N£mero interno da DU-E - (input)(integer)
              p-num-versao-due : N£mero da vers∆o da DU-E - (input)(integer)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems    LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER p-num-versao-due LIKE due-item.num-versao-due NO-UNDO.

    FOR EACH bfdue-item FIELDS (cod-livre-1)
       WHERE bfdue-item.cdd-due-ems    = p-cdd-due-ems
         AND bfdue-item.num-versao-due = p-num-versao-due EXCLUSIVE-LOCK:
        ASSIGN OVERLAY(bfdue-item.cod-livre-1,2,21)  = "":U.
    END.
    RELEASE bfdue-item.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTTDueItem DBOProgram 
PROCEDURE piCriaTTDueItem :
/*------------------------------------------------------------------------------
  Purpose:     Cria os Itens da DU-E no momento da vinculaá∆o da Nota Fiscal
  Parameters:  pde-cdd-due-ems (decimal): N£mero Interno da DU-E (entrada)
               pc-cod-estab-nf (character): Estabelecimento da Nota do Item da DU-e (entrada)
               pc-cod-serie    (character): SÇrie da Nota do Item da DU-e  (entrada)
               pc-nr-nota-fis  (character): N£mero da Nota do Item da DU-e  (entrada)
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-cdd-due-ems LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estab-nf LIKE due-item.cod-estabel-nf NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-serie    LIKE due-item.cod-seri       NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-nota-fis  LIKE due-item.cod-nota-fisc  NO-UNDO.
                                          
    DEFINE VARIABLE i-num-seq-it-due   AS   INTEGER INITIAL 1                 NO-UNDO.
    DEFINE VARIABLE i-num-seq-siscomex AS   INTEGER INITIAL 1                 NO-UNDO.
    DEFINE VARIABLE i-count-destaq     AS   INTEGER                           NO-UNDO.
    DEFINE VARIABLE de-perc-comis-com  LIKE due-item.val-perc-comis-agent     NO-UNDO.
    DEFINE VARIABLE de-perc-comis-ncm  LIKE due-item.val-perc-comis-agent     NO-UNDO.
    DEFINE VARIABLE c-desc-compl       LIKE due-item.des-compl-item           NO-UNDO.

    DEFINE VARIABLE c-arq-log     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE l-log-negocio AS LOGICAL     NO-UNDO.
    ASSIGN c-arq-log     = "LOG_NEGOCIO_due_":U + STRING(pde-cdd-due-ems) + ".txt":U
           l-log-negocio = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-log-negocio":U AND funcao.ativo).

    IF l-log-negocio THEN DO:
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="2" &iType="1" &cMessage="'CRIANDO ITEM DA DU-E':U"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pde-cdd-due-ems = ':U + STRING(pde-cdd-due-ems)"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pc-cod-estab-nf = ':U + STRING(pc-cod-estab-nf)"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pc-cod-serie = ':U + STRING(pc-cod-serie)"}
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'pc-nr-nota-fis = ':U + STRING(pc-nr-nota-fis)"}
    END.

    RUN exp/exapi030.p   PERSISTENT SET h-exapi030.
    RUN cxbo/bocx00466.p PERSISTENT SET h-bocx00466.

    RUN openQueryStatic IN h-bocx00466 (INPUT "Main":U).

    RUN emptyRowErrors  IN THIS-PROCEDURE.
    RUN emptyRowObject  IN THIS-PROCEDURE.

    FOR LAST bfdue-item FIELDS(num-seq-it-due num-livre-2) NO-LOCK
       WHERE bfdue-item.cdd-due-ems = pde-cdd-due-ems:

        ASSIGN i-num-seq-it-due = bfdue-item.num-seq-it-due + 1
               i-num-seq-siscomex = bfdue-item.num-livre-2 + 1.
    END.

    FOR EACH it-nota-fisc 
       WHERE it-nota-fisc.cod-estabel = pc-cod-estab-nf                
         AND it-nota-fisc.serie       = pc-cod-serie                      
         AND it-nota-fisc.nr-nota-fis = pc-nr-nota-fis EXCLUSIVE-LOCK:

        RUN goToKey IN THIS-PROCEDURE (INPUT pde-cdd-due-ems, 
                                       INPUT i-num-seq-it-due).

        IF RETURN-VALUE = "NOK":U THEN DO:
            FOR FIRST nota-fiscal FIELDS (cod-estab-proces-export nr-proc-exp pais nome-ab-cli nr-pedcli)
                WHERE nota-fiscal.cod-estabel = it-nota-fisc.cod-estabel
                  AND nota-fiscal.serie       = it-nota-fisc.serie      
                  AND nota-fiscal.nr-nota-fis = it-nota-fisc.nr-nota-fis NO-LOCK:
            END.

            RUN piDescricaoMercadoria IN THIS-PROCEDURE (INPUT  it-nota-fisc.cod-estabel,
                                                         INPUT  it-nota-fisc.serie,      
                                                         INPUT  it-nota-fisc.nr-nota-fis,
                                                         INPUT  it-nota-fisc.nr-seq-fat,
                                                         INPUT  it-nota-fisc.it-codigo,
                                                         OUTPUT c-desc-compl).
            CREATE tt-due-item-create.
            ASSIGN tt-due-item-create.cdd-due-ems             = pde-cdd-due-ems
                   tt-due-item-create.num-seq-it-due          = i-num-seq-it-due
                   tt-due-item-create.num-livre-2             = i-num-seq-siscomex
                   tt-due-item-create.cod-estabel-nf          = it-nota-fisc.cod-estabel
                   tt-due-item-create.cod-serie-nf            = it-nota-fisc.serie
                   tt-due-item-create.cod-nota-fisc           = it-nota-fisc.nr-nota-fis
                   tt-due-item-create.num-seq-faturam         = it-nota-fisc.nr-seq-fat
                   tt-due-item-create.cod-item                = it-nota-fisc.it-codigo
                   tt-due-item-create.cdn-emitente            = it-nota-fisc.cd-emitente
                    tt-due-item-create.qtd-estatis             = IF DEC(SUBSTRING(it-nota-fisc.char-1,421,20)) <> 0 THEN 
                                                                    DEC(SUBSTRING(it-nota-fisc.char-1,421,20)) 
                                                                ELSE it-nota-fisc.qt-faturada[1] 
                   tt-due-item-create.qtd-estatis-pais-dest   = tt-due-item-create.qtd-estatis
                   tt-due-item-create.cod-estab-proces-export = IF AVAIL nota-fiscal THEN nota-fiscal.cod-estab-proces-export ELSE "":U
                   tt-due-item-create.cod-proces-export       = IF AVAIL nota-fiscal THEN nota-fiscal.nr-proc-exp             ELSE "":U
                   tt-due-item-create.des-compl-item          = c-desc-compl.


           /*Informaá‰es da DU-E - ParÉmetros*/
           FOR FIRST due-siscomex FIELDS(num-versao-due idi-tratam-priorit cod-enquad-1 
                                         cod-enquad-2 cod-enquad-3 cod-enquad-4) NO-LOCK 
               WHERE due-siscomex.cdd-due-ems = pde-cdd-due-ems:
                ASSIGN tt-due-item-create.num-versao-due     = due-siscomex.num-versao-due
                       tt-due-item-create.idi-tratam-priorit = due-siscomex.idi-tratam-priorit
                       tt-due-item-create.cod-enquad-1       = due-siscomex.cod-enquad-1
                       tt-due-item-create.cod-enquad-2       = due-siscomex.cod-enquad-2
                       tt-due-item-create.cod-enquad-3       = due-siscomex.cod-enquad-3
                       tt-due-item-create.cod-enquad-4       = due-siscomex.cod-enquad-4.
            END.

            /*Comiss∆o do agente e peso l°quido do item*/
            FOR FIRST classif-fisc FIELD(char-2 class-fiscal val-repas-max-comis) NO-LOCK
                WHERE classif-fisc.class-fiscal = it-nota-fisc.class-fiscal:

                ASSIGN de-perc-comis-ncm = classif-fisc.val-repas-max-comis.

                /*Peso do item - N∆o Ç necess†rio converter pois na nota j† Ç gravado o peso em KG*/
                ASSIGN tt-due-item-create.val-peso-liq-item = it-nota-fisc.peso-liq-fat.
            END.

            /*Atualiza percentual de comiss∆o do agente: atualiza com 
              o primeiro representante do pedido*/
            FOR FIRST ped-repre FIELDS(perc-comis) NO-LOCK
                WHERE ped-repre.nr-pedido   = it-nota-fisc.nr-pedido 
                  AND ped-repre.nome-ab-rep = it-nota-fisc.nome-ab-cli:
                ASSIGN de-perc-comis-com = ped-repre.perc-comis.
            END.

            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-perc-comis-ncm = ':U + STRING(de-perc-comis-ncm)"}
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-perc-comis-com = ':U + STRING(de-perc-comis-com)"}
            END.

            IF de-perc-comis-ncm <= de-perc-comis-com THEN
               ASSIGN tt-due-item-create.val-perc-comis-agent = de-perc-comis-ncm.
            ELSE
               ASSIGN tt-due-item-create.val-perc-comis-agent = de-perc-comis-com.

            /*pa°s ISO 3166-2*/
            FOR FIRST pais FIELDS(char-1 cod-pais) NO-LOCK 
                WHERE pais.nome-pais = nota-fiscal.pais:
                ASSIGN tt-due-item-create.cod-pais-dest-final = TRIM(SUBSTRING(pais.char-1,23,2)).
                       tt-due-item-create.num-livre-1         = pais.cod-pais. 
            END.

            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'UM estat°stica tribut†vel (it-nota-fisc.char-1,419,2) = ':U + STRING(TRIM(SUBSTRING(it-nota-fisc.char-1,419,2)))"}
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'UM estat°stica faturamento (it-nota-fisc.un-fatur[1]) = ':U + STRING(it-nota-fisc.un-fatur[1])"}
            END.
            /*Unidade de medida estat°stica*/
            IF  TRIM(SUBSTRING(it-nota-fisc.char-1,419,2)) <> "":U
            AND TRIM(SUBSTRING(it-nota-fisc.char-1,419,2)) <> ? THEN DO:
                ASSIGN tt-due-item-create.cod-un-estatis = TRIM(SUBSTRING(it-nota-fisc.char-1,419,2)).

                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'UM estat°stica utilizada: it-nota-fisc.char-1,419,2':U"}
                END.
            END.
            ELSE DO:
                ASSIGN tt-due-item-create.cod-un-estatis =  it-nota-fisc.un-fatur[1].
                IF l-log-negocio THEN DO:
                    {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'UM estat°stica utilizada: it-nota-fisc.un-fatur[1] = ':U + STRING(it-nota-fisc.un-fatur[1])"}
                END.
                FOR FIRST tab-unidade FIELDS(char-2) NO-LOCK
                    WHERE tab-unidade.un = it-nota-fisc.un-fatur[1]:

                    IF l-log-negocio THEN DO:
                        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'UM estat°stica (tab-unidade.char-2,1,10) = ':U + STRING(TRIM(SUBSTRING(tab-unidade.char-2,1,10)))"}
                    END.

                    IF TRIM(SUBSTRING(tab-unidade.char-2,1,10)) <> "":U THEN DO:
                        ASSIGN tt-due-item-create.cod-un-estatis =  TRIM(SUBSTRING(tab-unidade.char-2,1,10)).
                        IF l-log-negocio THEN DO:
                            {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'UM estat°stica utilizada: tab-unidade.char-2,1,10':U"}
                        END.
                    END.
                END.
            END.

            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'nota-fiscal.nr-proc-exp = ':U + STRING(nota-fiscal.nr-proc-exp)"}
            END.
            
            /*Atualiza condiá∆o de venda*/
            IF nota-fiscal.nr-proc-exp <> "":U THEN DO:
                FOR FIRST processo-exp FIELDS(cod-incoterm) NO-LOCK 
                    WHERE processo-exp.cod-estabel = nota-fiscal.cod-estab-proces-export
                      AND processo-exp.nr-proc-exp = nota-fiscal.nr-proc-exp:
                    ASSIGN tt-due-item-create.cod-incoterm = processo-exp.cod-incoterm. 
                END.
            END.
            ELSE DO:
                FOR FIRST ped-venda-cex FIELDS(cod-incoterm) NO-LOCK 
                    WHERE ped-venda-cex.nome-abrev = nota-fiscal.nome-ab-cli
                      AND ped-venda-cex.nr-pedcli  = nota-fiscal.nr-pedcli:

                    ASSIGN tt-due-item-create.cod-incoterm = ped-venda-cex.cod-incoterm. 
                END.
            END.

            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="1" &cMessage="'Atualizando valores na condiá∆o de venda e valores no local de embarque':U"}
            END.
            /*Atualiza valores na condiá∆o de venda e valores no local de embarque*/
            IF VALID-HANDLE (h-exapi030) THEN DO:
               RUN setArquivoDueLog IN h-exapi030 ( INPUT c-arq-log).
                
               RUN calculaDespItemNF IN h-exapi030 ( INPUT it-nota-fisc.cod-estabel,
                                                     INPUT it-nota-fisc.serie,
                                                     INPUT it-nota-fisc.nr-nota-fis,
                                                     INPUT it-nota-fisc.nr-seq-fat,
                                                     INPUT it-nota-fisc.it-codigo,
                                                     INPUT "VMCV":U, 
                                                     OUTPUT de-val-cond-vda).

               ASSIGN tt-due-item-create.val-cond-vda =  it-nota-fisc.vl-mercliq-e[1] + de-val-cond-vda.
                
               RUN calculaDespItemNF IN h-exapi030 ( INPUT it-nota-fisc.cod-estabel,
                                                     INPUT it-nota-fisc.serie,
                                                     INPUT it-nota-fisc.nr-nota-fis,
                                                     INPUT it-nota-fisc.nr-seq-fat,
                                                     INPUT it-nota-fisc.it-codigo,
                                                     INPUT "VMLE":U, 
                                                     OUTPUT de-val-local-embarq).
                                                     
                IF l-fn-cidade-cif AND nota-fiscal.cidade-cif <> "":U THEN 
                    ASSIGN tt-due-item-create.val-local-embarq = it-nota-fisc.vl-mercliq-e[1].
                ELSE 
                    ASSIGN tt-due-item-create.val-local-embarq = it-nota-fisc.vl-mercliq-e[1] + de-val-local-embarq.

            END.

            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'it-nota-fisc.vl-mercliq-e[1] = ':U + STRING(it-nota-fisc.vl-mercliq-e[1])"}
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-val-cond-vda = ':U + STRING(de-val-cond-vda)"}
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="0" &cMessage="'de-val-local-embarq = ':U + STRING(de-val-local-embarq)"}
            END.


            /*Com funá∆o ativa, atualiza o item da DU-E sempre com o primeiro destaque cadastrado pra classificaá∆o fiscal */
            IF l-fn-due-atributo THEN DO:
                FOR FIRST classif-destaq FIELDS(class-fiscal cod-destaq) NO-LOCK 
                    WHERE classif-destaq.class-fiscal = it-nota-fisc.class-fiscal:
                    ASSIGN tt-due-item-create.cdn-destaque = classif-destaq.cod-destaq.
                END.
            END.
            ELSE DO:
                /*Atualiza se existir somente um destaque cadastrado para a classificaá∆o fiscal*/
                ASSIGN i-count-destaq = 0.
                bloco_destaq:
                FOR EACH classif-destaq FIELDS(class-fiscal cod-destaq) NO-LOCK 
                   WHERE classif-destaq.class-fiscal = it-nota-fisc.class-fiscal 
                BREAK BY classif-destaq.class-fiscal:
    
                    ASSIGN i-count-destaq = i-count-destaq + 1.
                    IF  LAST-OF(classif-destaq.class-fiscal) AND i-count-destaq = 1 THEN DO:
                        ASSIGN tt-due-item-create.cdn-destaque = classif-destaq.cod-destaq.
                        LEAVE bloco_destaq.
                    END.
                END.
            END.

            RUN setRecord    IN THIS-PROCEDURE (INPUT TABLE tt-due-item-create).
            RUN createRecord IN THIS-PROCEDURE.
            IF l-log-negocio THEN DO:
                {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="3" &iType="1" &cMessage="'SALVAR ITEM DA DU-E. RETORNO = ':U + STRING(RETURN-VALUE)"}
            END.
            IF RETURN-VALUE = "OK":U THEN DO:
                /* - Criaá∆o dos registros das Notas Fiscais Referenciadas (exportaá∆o indireta)
                   - Notas informadas no programa CD4035 - Controle de Exportaá∆o por Item*/
                RUN piCriaDueItemNFRefer IN h-bocx00466 (INPUT ROWID(it-nota-fisc)).
            END.

            /*************************** Chamada EPC *****************************/
            IF  c-nom-prog-dpc-mg97  <> "":U 
            OR  c-nom-prog-appc-mg97 <> "":U 
            OR  c-nom-prog-upc-mg97  <> "":U THEN DO:
        
                EMPTY TEMP-TABLE tt-epc.

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "afterCreateDueItem":U
                       tt-epc.cod-parameter = "Rowid_DueItem":U
                       tt-epc.val-parameter = STRING(ROWID(due-item)).
                                              
                {include/i-epc201.i "afterCreateDueItem"}
            
                FOR EACH tt-epc 
                   WHERE tt-epc.cod-event = "afterCreateDueItem":U:
                    DELETE tt-epc.
                END.
            END.
            /**********************************************************************/

            ASSIGN i-num-seq-it-due = i-num-seq-it-due + 1
                   i-num-seq-siscomex = i-num-seq-siscomex + 1.
            DELETE tt-due-item-create.
        END.
    END.
    
    IF VALID-HANDLE (h-exapi030) THEN DO:
       DELETE PROCEDURE h-exapi030.
       ASSIGN h-exapi030 = ?.
    END.

    IF VALID-HANDLE (h-bocx00466) THEN DO:
       DELETE PROCEDURE h-bocx00466.
       ASSIGN h-bocx00466 = ?.
    END.

    IF l-log-negocio THEN DO:
        {cdp/cdapi1004.i &cFile="c-arq-log" &iMode="4" &iType="1" &cMessage="'FIM piCriaTTDueItem':U"}
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDescricaoMercadoria DBOProgram 
PROCEDURE piDescricaoMercadoria :
/*------------------------------------------------------------------------------
  Purpose:     Pesquisa a descriá∆o do produto. L¢gica retirada do programa FT0513F.p
               Impressor do Danfe/NF
  Parameters:  pc-cod-estab-nf (character): Estabelecimento da Nota do Item da DU-e (entrada)
               pc-cod-serie    (character): SÇrie da Nota do Item da DU-e  (entrada)
               pc-nr-nota-fis  (character): N£mero da Nota do Item da DU-e  (entrada)
               pi-num-seq-fat  (integer): Sequencia do Item faturado na Nota do Item da DU-e  (entrada)
               pc-it-codigo    (character): Item da DU-e  (entrada)
               pc-desc-prod    (character): Descriá∆o do produto (Sa°da)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER  pc-cod-estab-nf LIKE due-item.cod-estabel-nf    NO-UNDO.
    DEFINE INPUT PARAMETER  pc-cod-serie    LIKE due-item.cod-serie         NO-UNDO.
    DEFINE INPUT PARAMETER  pc-nr-nota-fis  LIKE due-item.cod-nota-fisc     NO-UNDO.
    DEFINE INPUT PARAMETER  pi-num-seq-fat  LIKE due-item.num-seq-faturam   NO-UNDO.
    DEFINE INPUT PARAMETER  pc-it-codigo    LIKE due-item.cod-item          NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-desc-prod    AS   CHARACTER FORMAT "x(63)":U NO-UNDO.

    FIND FIRST it-nota-fisc
         WHERE it-nota-fisc.cod-estabel = pc-cod-estab-nf
           AND it-nota-fisc.serie       = pc-cod-serie   
           AND it-nota-fisc.nr-nota-fis = pc-nr-nota-fis 
           AND it-nota-fisc.nr-seq-fat  = pi-num-seq-fat 
           AND it-nota-fisc.it-codigo   = pc-it-codigo   NO-LOCK NO-ERROR.
    IF AVAIL it-nota-fisc THEN DO:
        FIND FIRST ITEM
            WHERE ITEM.it-codigo = pc-it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            find narrativa of item no-lock no-error.
            if  item.ind-imp-desc = 1 then assign pc-desc-prod = item.desc-item.
        
            if  item.ind-imp-desc =  8 then do:
                find item-cli where item-cli.nome-abrev = nota-fiscal.nome-ab-cli
                              and   item-cli.it-codigo  = it-nota-fisc.it-codigo no-lock no-error.
                  assign pc-desc-prod = item.desc-item + " " + if avail item-cli then
                                                        trim(substring(item-cli.narrativa,1,27))
                                                                              else "".
            end.
        
            if  item.ind-imp-desc = 9 then do:
                find nar-it-nota where nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel
                                 and   nar-it-nota.serie        = it-nota-fisc.serie
                                 and   nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                                 and   nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
                                 and   nar-it-nota.it-codigo    = it-nota-fisc.it-codigo no-lock no-error.
        
                 assign pc-desc-prod = item.desc-item + " "
                                    + if  avail nar-it-nota then
                                          trim(substring(nar-it-nota.narrativa,1,27))
                                      else "".
            end.
        
            if  item.ind-imp-desc = 10 then
                assign pc-desc-prod = item.desc-item + " "
                                   + if  avail narrativa then
                                         trim(substring(narrativa.descricao,1,27))
                                     else "".
        
            if  (item.ind-imp-desc = 2 or item.ind-imp-desc = 5 or item.ind-imp-desc = 6)
                and avail narrativa then do:
                    assign pc-desc-prod = if  item.ind-imp-desc = 2 then
                                             item.desc-item + " " + trim(substring(narrativa.descricao,1,38))
                                         else if item.ind-imp-desc = 5 then 
                                                  trim(substring(narrativa.descricao,1,38))
                                              else if item.ind-imp-desc = 6 then
                                                          trim(entry(1,substring(narrativa.descricao,1,76),chr(10)))
                                                   else "".
            end.
        
            if  item.ind-imp-desc = 3 then do:
                find item-cli where item-cli.nome-abrev = nota-fiscal.nome-ab-cli
                     and   item-cli.it-codigo  = it-nota-fisc.it-codigo
                     no-lock no-error.
                assign pc-desc-prod = item.desc-item + " " + if  avail item-cli then
                                         trim(substring(item-cli.narrativa,1,380))
                                     else "".
            end.
        
            if  item.ind-imp-desc = 4
            or  item.ind-imp-desc = 7 then do:
                find nar-it-nota where nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel
                           and   nar-it-nota.serie        = it-nota-fisc.serie
                     and   nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis
                     and   nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
                     and   nar-it-nota.it-codigo    = it-nota-fisc.it-codigo
                     no-lock no-error.
        
                if item.ind-imp-desc = 4 then 
                   assign pc-desc-prod = item.desc-item + " " + if  avail nar-it-nota then
                                              trim(substring(nar-it-nota.narrativa,1,380))
                                          else "".
        
                if item.ind-imp-desc = 7 then
                   assign pc-desc-prod =  if  avail nar-it-nota then
                                             trim(substring
                                             (nar-it-nota.narrativa,1,380))
                                         else "".
            end.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piDesvinculaItemDUE DBOProgram 
PROCEDURE piDesvinculaItemDUE :
/*:T------------------------------------------------------------------------------
  Purpose:     Elimina os registros dos Itens quando desvincula a NF da DU-E 
  Parameters:  p-cdd-due-ems    : N£mero interno da DU-E - (input)(integer)
               p-num-versao-due : N£mero da vers∆o da DU-E - (input)(integer)
               pc-cod-estabel-nf: Estabelecimento da NF do Item da DU-e - (input character)
               pc-cod-serie-nf  : SÇrie da NF do Item da DU-e - (input character)
               pc-cod-nota-fisc : N£mero da NF do Item da DU-e - (input character)
       
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems     LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER p-num-versao-due  LIKE due-item.num-versao-due NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estabel-nf LIKE due-item.cod-estabel-nf NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-serie-nf   LIKE due-item.cod-serie-nf   NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-nota-fisc  LIKE due-item.cod-nota-fisc  NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx00463) THEN DO:
        RUN cxbo/bocx00463.p PERSISTENT SET h-bocx00463.
    END.

    RUN openQueryStatic IN h-bocx00463 (INPUT "main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bocx00466) THEN DO:
        RUN cxbo/bocx00466.p PERSISTENT SET h-bocx00466.
    END.

    RUN openQueryStatic IN h-bocx00466 (INPUT "main":U) NO-ERROR.

    IF NOT VALID-HANDLE(h-bocx00469) THEN DO:
        RUN cxbo/bocx00469.p PERSISTENT SET h-bocx00469.
    END.

    IF l-fn-due-v3 THEN DO:
        IF NOT VALID-HANDLE(h-bocx00472) THEN
            RUN cxbo/bocx00472.p PERSISTENT SET h-bocx00472.
    END.

    RUN openQueryStatic IN h-bocx00469 (INPUT "main":U) NO-ERROR.

    FOR EACH bfdue-item
       WHERE bfdue-item.cdd-due-ems    = p-cdd-due-ems 
         AND bfdue-item.num-versao-due = p-num-versao-due
         AND bfdue-item.cod-estabel-nf = pc-cod-estabel-nf
         AND bfdue-item.cod-serie-nf   = pc-cod-serie-nf  
         AND bfdue-item.cod-nota-fisc  = pc-cod-nota-fisc EXCLUSIVE-LOCK:

        RUN piDesvinculaItemDrawDUE IN h-bocx00463 (INPUT bfdue-item.cdd-due-ems,
                                                    INPUT bfdue-item.num-versao-due,
                                                    INPUT bfdue-item.num-seq-it-due).

        RUN piDesvinculaItemNfRefer IN h-bocx00466 (INPUT bfdue-item.cdd-due-ems,
                                                    INPUT bfdue-item.num-versao-due,
                                                    INPUT bfdue-item.num-seq-it-due).

        RUN piDesvinculaItemLpco    IN h-bocx00469 (INPUT bfdue-item.cdd-due-ems,
                                                    INPUT bfdue-item.num-versao-due,
                                                    INPUT bfdue-item.num-seq-it-due).

        IF l-fn-due-v3 THEN 
            RUN piDesvinculaItemCertif  IN h-bocx00472 (INPUT bfdue-item.cdd-due-ems,
                                                        INPUT bfdue-item.num-versao-due,
                                                        INPUT bfdue-item.num-seq-it-due).

        DELETE bfdue-item.
    END.

    RUN resequenciaItensDue IN THIS-PROCEDURE (INPUT p-cdd-due-ems,
                                               INPUT p-num-versao-due).

    IF VALID-HANDLE(h-bocx00463) THEN DO:
        DELETE PROCEDURE h-bocx00463.
        ASSIGN h-bocx00463 = ?.
    END.

    IF VALID-HANDLE(h-bocx00466) THEN DO:
        DELETE PROCEDURE h-bocx00466.
        ASSIGN h-bocx00466 = ?.
    END.

    IF VALID-HANDLE(h-bocx00469) THEN DO:
        DELETE PROCEDURE h-bocx00469.
        ASSIGN h-bocx00469 = ?.
    END.

    IF l-fn-due-v3 THEN DO:
        IF VALID-HANDLE(h-bocx00472) THEN DO:
            DELETE PROCEDURE h-bocx00472.
            ASSIGN h-bocx00472 = ?.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaItensDueEnvio DBOProgram 
PROCEDURE piValidaItensDueEnvio :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida informaá‰es dos itens da DU-E antes do envio para Siscomex
  Parameters:  p-cdd-due-ems: N£mero interno da DU-E - (input)(integer)
               RowErrors: Temp-table de erros - (output)(temp-table)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cdd-due-ems LIKE due-siscomex.cdd-due-ems NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE c-lb-item         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-enquad-drawback AS LOGICAL   NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx00463) THEN DO:
        RUN cxbo/bocx00463.p PERSISTENT SET h-bocx00463.
    END.

    IF NOT CAN-FIND(FIRST bfdue-item
                    WHERE bfdue-item.cdd-due-ems = p-cdd-due-ems) THEN DO:
        {utp/ut-liter.i "Item" *}
         ASSIGN c-lb-item = RETURN-VALUE.
        {utp/ut-liter.i "a_DU-E" *}
        {method/svc/errors/inserr.i
                    &ErrorNumber="16381"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lb-item + '~~~~' + RETURN-VALUE + ': ' + string(p-cdd-due-ems)"}
    END.
    ELSE DO:
        FOR EACH bfdue-item
            WHERE bfdue-item.cdd-due-ems = p-cdd-due-ems NO-LOCK:

            /*Verifica se a condiá∆o de venda foi informada*/
            IF bfdue-item.cod-incoterm = "":U THEN DO:
                {utp/ut-liter.i "Condiá∆o_de_Venda" *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-seq-item + ' ' + string(bfdue-item.num-seq-it-due)"}
            END.
    
            /*Verifica se o valor na condiá∆o de venda foi informado*/
            IF bfdue-item.val-cond-vda = 0 THEN DO:
                {utp/ut-liter.i "Valor_na_condiá∆o_de_venda" *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-seq-item + ' ' + string(bfdue-item.num-seq-it-due)"}
    
            END.
    
            /*Verifica se o valor no local de embarque foi informado*/
            IF bfdue-item.val-local-embarq = 0 THEN DO:
                {utp/ut-liter.i "Valor_no_local_de_embarque" *}
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-seq-item + ' ' + string(bfdue-item.num-seq-it-due)"}
    
            END.

            /*Verifica se foi informado atributo do destaque para a NCM*/
            IF bfdue-item.cdn-destaque <> 0 THEN DO:
                FOR FIRST it-nota-fisc FIELDS(class-fiscal)
                    WHERE it-nota-fisc.cod-estabel = bfdue-item.cod-estabel-nf 
                      AND it-nota-fisc.serie       = bfdue-item.cod-serie-nf      
                      AND it-nota-fisc.nr-nota-fis = bfdue-item.cod-nota-fisc  
                      AND it-nota-fisc.nr-seq-fat  = bfdue-item.num-seq-faturam
                      AND it-nota-fisc.it-codigo   = bfdue-item.cod-item           NO-LOCK:
        
                    FOR FIRST classif-destaq FIELDS(cod-livre-1)
                        WHERE classif-destaq.class-fiscal = it-nota-fisc.class-fiscal
                          AND classif-destaq.cod-destaq   = bfdue-item.cdn-destaque  NO-LOCK:
                    END.
                    IF NOT AVAIL classif-destaq THEN DO:
                        {utp/ut-liter.i "Destaque_informado_inexistente_para_a_NCM_(CD0603)." *}
                        ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i "Ao_informar_o_destaque,_o_atributo_Ç_obrigat¢rio_ser_informado_no_CD0603" *}
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="56058"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-help + '~~~~' + c-lb-seq-item + ' ' + string(bfdue-item.num-seq-it-due) + ' ' + RETURN-VALUE"}
                    END.
                    ELSE DO:
                        IF TRIM(SUBSTRING(classif-destaq.cod-livre-1,1,10)) = "":U THEN DO: 
                            {utp/ut-liter.i "Atributo_da_NCM" *}
                            ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
                            {utp/ut-liter.i "Deve_ser_informado_o_Atributo_deste_destaque_na_Classificaá∆o_Fiscal_(CD0603)" *}
                            {method/svc/errors/inserr.i
                                        &ErrorNumber="55925"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="c-lbl-help + '~~~~' + c-lb-seq-item + ' ' + string(bfdue-item.num-seq-it-due) + ' ' + RETURN-VALUE"}
                        END.
                    END.
                END.
            END.

            /*Verifica se foi informado o Primeiro Enquadramento*/
            IF bfdue-item.cod-enquad-1 = 0 THEN DO:
                {utp/ut-liter.i Primeiro_Enquadramento * }
                {method/svc/errors/inserr.i
                            &ErrorNumber="55925"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"
                            &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-seq-item + ' ' + string(bfdue-item.num-seq-it-due)"}
            END.

            RUN piVerificaEnquadrDrawback (INPUT  bfdue-item.cdd-due-ems,
                                           INPUT  bfdue-item.num-versao-due,
                                           INPUT  bfdue-item.num-seq-it-due,
                                           OUTPUT l-enquad-drawback).
            
            IF l-enquad-drawback THEN DO:
                RUN piValidaDrawbackDueEnvio IN h-bocx00463(INPUT  bfdue-item.cdd-due-ems,  
                                                            INPUT  bfdue-item.num-versao-due,   
                                                            INPUT  bfdue-item.num-seq-it-due,
                                                            OUTPUT TABLE RowErrors APPEND).
            END.

            IF l-fn-due-v3 THEN DO:
                IF ((bfdue-item.cod-enquad-1 = 81501 OR bfdue-item.cod-enquad-1 = 81502 OR bfdue-item.cod-enquad-1 = 81503)
                OR  (bfdue-item.cod-enquad-2 = 81501 OR bfdue-item.cod-enquad-2 = 81502 OR bfdue-item.cod-enquad-2 = 81503)
                OR  (bfdue-item.cod-enquad-3 = 81501 OR bfdue-item.cod-enquad-3 = 81502 OR bfdue-item.cod-enquad-3 = 81503)
                OR  (bfdue-item.cod-enquad-4 = 81501 OR bfdue-item.cod-enquad-4 = 81502 OR bfdue-item.cod-enquad-4 = 81503))
                AND DEC(SUBSTRING(bfdue-item.cod-livre-1,2,21)) = 0 THEN DO:
                    {utp/ut-liter.i Valor_de_Financiamento *}
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="55925"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-seq-item + ' ' + string(bfdue-item.num-seq-it-due)"}
                END.
                /*Verifica se o Item possui os certificados informados caso esteja marcado como CCPTC ou CCROM */
                IF SUBSTRING(bfdue-item.cod-livre-1,1,1) = "2":U OR SUBSTRING(bfdue-item.cod-livre-1,1,1) = "3":U THEN DO:
                    IF NOT CAN-FIND(FIRST due-item-certif
                                    WHERE due-item-certif.cdd-due-ems    = bfdue-item.cdd-due-ems
                                      AND due-item-certif.num-versao-due = bfdue-item.num-versao-due
                                      AND due-item-certif.num-seq-it-due = bfdue-item.num-seq-it-due  ) THEN DO:
                        {utp/ut-liter.i Certificado *}
                        {method/svc/errors/inserr.i
                                        &ErrorNumber="55925"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE + '~~~~' + c-lb-seq-item + ' ' + string(bfdue-item.num-seq-it-due)"}
                    END.
                END.
            END.
        END.
    END.

    IF VALID-HANDLE(h-bocx00463) THEN DO:
        DELETE PROCEDURE h-bocx00463.
        ASSIGN h-bocx00463 = ?.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaEnquadrDrawback DBOProgram 
PROCEDURE piVerificaEnquadrDrawback :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se item da DU-E possui enquadramento de Drawback.
  Parameters:  pcdd-due-ems (Entrada): N£mero da DU-E (decimal).
               pi-num-versao (Entrada): N£mero da vers∆o da DU-E (Inteiro).
               pi-num-seq-it-due (Entrada): N£mero da sequencia do item da DU-E (Inteiro).
               pl-enquad-drawback (Sa°da): Indica se possui enquadramento de drawback (L¢gico).
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcdd-due-ems       LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-versao      LIKE due-item.num-versao-due NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-seq-it-due  LIKE due-item.num-seq-it-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-enquad-drawback AS LOGICAL                   NO-UNDO.

    DEFINE VARIABLE c-lista-enquad-draw AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-enquad-current    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont              AS INTEGER     NO-UNDO.

    ASSIGN c-lista-enquad-draw = "81101":U.

    IF NOT AVAIL bfdue-item THEN DO:
        FOR FIRST bfdue-item FIELDS(cod-enquad-1 cod-enquad-2 cod-enquad-3 cod-enquad-4)
            WHERE bfdue-item.cdd-due-ems    = pcdd-due-ems
              AND bfdue-item.num-versao-due = pi-num-versao
              AND bfdue-item.num-seq-it-due = pi-num-seq-it-due NO-LOCK: END.
    END.

    IF AVAIL bfdue-item THEN DO:

        DO i-cont = 1 TO NUM-ENTRIES(c-lista-enquad-draw,",":U):
            ASSIGN i-enquad-current = INT(ENTRY(i-cont, c-lista-enquad-draw, ",":U)).
            IF bfdue-item.cod-enquad-1 = i-enquad-current OR
               bfdue-item.cod-enquad-2 = i-enquad-current OR
               bfdue-item.cod-enquad-3 = i-enquad-current OR
               bfdue-item.cod-enquad-4 = i-enquad-current THEN DO:
                ASSIGN pl-enquad-drawback = YES.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaEnquadrDrawbackSuspIsencao DBOProgram 
PROCEDURE piVerificaEnquadrDrawbackSuspIsencao :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se item da DU-E possui enquadramento de Drawback Suspens∆o e/ou Isená∆o.
  Parameters:  pcdd-due-ems (Entrada): N£mero da DU-E (decimal).
               pi-num-versao (Entrada): N£mero da vers∆o da DU-E (Inteiro).
               pi-num-seq-it-due (Entrada): N£mero da sequencia do item da DU-E (Inteiro).
               pi-cod-enquadramento (Sa°da): Retorna o Enquadramento anterior 
               pl-enquad-draw-cur   (Sa°da): Indica se possui enquadramento de drawback no registro corrente (L¢gico).
               pl-enquad-draw-ant   (Sa°da): Indica se possui enquadramento de drawback no registro antes da alteraá∆o (L¢gico).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcdd-due-ems         LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-versao        LIKE due-item.num-versao     NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-seq-it-due    LIKE due-item.num-seq-it-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-cod-enquadramento AS   INTEGER                 NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-enquad-draw-cur   AS   LOGICAL                 NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-enquad-draw-ant   AS   LOGICAL                 NO-UNDO.

    DEFINE VARIABLE c-lista-enquad-draw AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-enquad-current    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-enquad-anterior   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont              AS INTEGER     NO-UNDO.

    ASSIGN c-lista-enquad-draw = "81101":U + "," + "81105":U.

    DO i-cont = 1 TO NUM-ENTRIES(c-lista-enquad-draw,",":U):
        ASSIGN i-enquad-current = INT(ENTRY(i-cont, c-lista-enquad-draw, ",":U)).
        IF rowObject.cod-enquad-1 = i-enquad-current OR
           rowObject.cod-enquad-2 = i-enquad-current OR
           rowObject.cod-enquad-3 = i-enquad-current OR
           rowObject.cod-enquad-4 = i-enquad-current THEN DO:
            ASSIGN pl-enquad-draw-cur  = YES.
            LEAVE.
        END.
        ELSE
            ASSIGN pl-enquad-draw-cur = NO.
    END.

    FOR FIRST bf{&TableName}
        WHERE bf{&TableName}.cdd-due-ems    = rowObject.cdd-due-ems
          AND bf{&TableName}.num-versao-due = rowObject.num-versao-due 
          AND bf{&TableName}.num-seq-it-due = rowObject.num-seq-it-due  NO-LOCK:
    END.

    IF AVAIL bf{&TableName} THEN DO:
        DO i-cont = 1 TO NUM-ENTRIES(c-lista-enquad-draw,",":U):
            ASSIGN i-enquad-anterior = INT(ENTRY(i-cont, c-lista-enquad-draw, ",":U)).
            IF bf{&TableName}.cod-enquad-1 = i-enquad-anterior OR
               bf{&TableName}.cod-enquad-2 = i-enquad-anterior OR
               bf{&TableName}.cod-enquad-3 = i-enquad-anterior OR
               bf{&TableName}.cod-enquad-4 = i-enquad-anterior THEN DO:
                ASSIGN pl-enquad-draw-ant = YES.

                IF bf{&TableName}.cod-enquad-1 = i-enquad-anterior THEN 
                    ASSIGN pi-cod-enquadramento = bf{&TableName}.cod-enquad-1.
                IF bf{&TableName}.cod-enquad-2 = i-enquad-anterior THEN 
                    ASSIGN pi-cod-enquadramento = bf{&TableName}.cod-enquad-2.
                IF bf{&TableName}.cod-enquad-3 = i-enquad-anterior THEN 
                    ASSIGN pi-cod-enquadramento = bf{&TableName}.cod-enquad-3.
                IF bf{&TableName}.cod-enquad-4 = i-enquad-anterior THEN 
                    ASSIGN pi-cod-enquadramento = bf{&TableName}.cod-enquad-4.
                LEAVE.
            END.
            ELSE
                ASSIGN pl-enquad-draw-ant   = NO
                       pi-cod-enquadramento = 0.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaEnquadrDrawbackSuspIsencaoDU-E DBOProgram 
PROCEDURE piVerificaEnquadrDrawbackSuspIsencaoDU-E :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se item da DU-E possui enquadramento de Drawback Suspens∆o e/ou Isená∆o.
  Parameters:  pcdd-due-ems (Entrada): N£mero da DU-E (decimal).
               pi-num-versao (Entrada): N£mero da vers∆o da DU-E (Inteiro).
               pl-enquad-draw-cur   (Sa°da): Indica se possui enquadramento de drawback no registro corrente (L¢gico).
               pl-enquad-draw-ant   (Sa°da): Indica se possui enquadramento de drawback no registro antes da alteraá∆o (L¢gico).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcdd-due-ems         LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT  PARAMETER pi-num-versao        LIKE due-item.num-versao-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-enquad-draw-cur   AS   LOGICAL                 NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-enquad-draw-ant   AS   LOGICAL                 NO-UNDO.

    DEFINE VARIABLE c-lista-enquad-draw AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-enquad-current    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-enquad-anterior   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont              AS INTEGER     NO-UNDO.

    ASSIGN c-lista-enquad-draw = "81101":U + "," + "81105":U.

    FOR FIRST due-siscomex
        WHERE due-siscomex.cdd-due-ems    = pcdd-due-ems
          AND due-siscomex.num-versao-due = pi-num-versao NO-LOCK:
    END.

    DO i-cont = 1 TO NUM-ENTRIES(c-lista-enquad-draw,",":U):
        ASSIGN i-enquad-current = INT(ENTRY(i-cont, c-lista-enquad-draw, ",":U)).
        IF due-siscomex.cod-enquad-1 = i-enquad-current OR
           due-siscomex.cod-enquad-2 = i-enquad-current OR
           due-siscomex.cod-enquad-3 = i-enquad-current OR
           due-siscomex.cod-enquad-4 = i-enquad-current THEN DO:
            ASSIGN pl-enquad-draw-cur  = YES.
            LEAVE.
        END.
        ELSE
            ASSIGN pl-enquad-draw-cur = NO.
    END.

    FOR EACH due-item 
       WHERE due-item.cdd-due-ems    = pcdd-due-ems
         AND due-item.num-versao-due = pi-num-versao NO-LOCK:

        DO i-cont = 1 TO NUM-ENTRIES(c-lista-enquad-draw,",":U):
            ASSIGN i-enquad-anterior = INT(ENTRY(i-cont, c-lista-enquad-draw, ",":U)).
            IF due-item.cod-enquad-1 = i-enquad-anterior OR
               due-item.cod-enquad-2 = i-enquad-anterior OR
               due-item.cod-enquad-3 = i-enquad-anterior OR
               due-item.cod-enquad-4 = i-enquad-anterior THEN DO:
                ASSIGN pl-enquad-draw-ant = YES.
                LEAVE.
            END.
            ELSE
                ASSIGN pl-enquad-draw-ant = NO.
        END.
    END.



    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaNotaDUE DBOProgram 
PROCEDURE piValidaNotaDUE :
/*------------------------------------------------------------------------------
  Purpose:     Valida algumas informaá‰es para a nota ser vinculada Ö DU-E
  Parameters:  pcdd-due-ems: N£mero da DU-E o qual o item da nota est† sendo vinculado (decimal) Entrada
               pc-cod-estabel: Estabelecimento da Nota a ser vinculada (character) Entrada
               pc-serie      : SÇrie da Nota a ser vinculada (character) Entrada
               pc-nr-nota-fis: N£mero da Nota a ser vinculada (character) Entrada
               RowErrors    : Sa°da (temp-table de erros)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcdd-due-ems      LIKE due-siscomex.cdd-due-ems NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-estabel    LIKE nota-fiscal.cod-estabel  NO-UNDO.
    DEFINE INPUT  PARAMETER pc-serie          LIKE nota-fiscal.serie        NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-nota-fis    LIKE nota-fiscal.nr-nota-fis  NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro-nota.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR RowErrors.

    DEFINE VARIABLE i-cont-item-due AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cont-item-nf  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-seq-erro      AS INTEGER     NO-UNDO.
    
    EMPTY TEMP-TABLE tt-erro-nota.

    FOR EACH due-item FIELDS()
        WHERE due-item.cdd-due-ems = pcdd-due-ems:
        ASSIGN i-cont-item-due = i-cont-item-due + 1.               
    END.

    FOR EACH it-nota-fisc FIELDS()
       WHERE it-nota-fisc.cod-estabel = pc-cod-estabel                
         AND it-nota-fisc.serie       = pc-serie                      
         AND it-nota-fisc.nr-nota-fis = pc-nr-nota-fis EXCLUSIVE-LOCK:
        ASSIGN i-cont-item-nf = i-cont-item-nf + 1.
    END.

    /* Nota fiscal n∆o pìde ser vinculada Ö DU-E - Ultrapassou quantidade m†xima de 999 itens */
    IF (i-cont-item-nf + i-cont-item-due) > 999 THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-erro-nota.
        ASSIGN tt-erro-nota.cod-estabel = pc-cod-estabel 
               tt-erro-nota.serie       = pc-serie       
               tt-erro-nota.nr-nota-fis = pc-nr-nota-fis
               tt-erro-nota.seq-erro    = i-seq-erro.
        {method/svc/errors/inserr.i
                &ErrorNumber="55934"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="pc-nr-nota-fis + '~~~~' + pc-serie + '~~~~' + pc-cod-estabel"}
        LEAVE.
    END.

    FOR FIRST nota-fiscal
        WHERE nota-fiscal.cod-estabel = pc-cod-estabel
          AND nota-fiscal.serie       = pc-serie
          AND nota-fiscal.nr-nota-fis = pc-nr-nota-fis NO-LOCK:

        FIND FIRST pais WHERE pais.nome-pais = nota-fiscal.pais NO-LOCK NO-ERROR.
        IF NOT AVAIL pais THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            CREATE tt-erro-nota.
            ASSIGN tt-erro-nota.cod-estabel = pc-cod-estabel 
                   tt-erro-nota.serie       = pc-serie       
                   tt-erro-nota.nr-nota-fis = pc-nr-nota-fis
                   tt-erro-nota.seq-erro    = i-seq-erro.
            {utp/ut-liter.i "Pa°s " *}
            ASSIGN c-lbl-help = TRIM(RETURN-VALUE) + " (":U + nota-fiscal.pais + " - ":U.
            {utp/ut-liter.i "Dados da Nota: " *}
            ASSIGN c-lbl-help2 = TRIM(RETURN-VALUE) + nota-fiscal.cod-estabel + ", ":U + nota-fiscal.serie + ", ":U + nota-fiscal.nr-nota-fis + ")":U.
            ASSIGN c-lbl-help3 = c-lbl-help + " ":U + c-lbl-help2.
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-help3"}
        END.
        ELSE DO:
            IF TRIM(SUBSTRING(pais.char-1,23,2)) = "":U THEN DO:
                ASSIGN i-seq-erro = i-seq-erro + 1.
                CREATE tt-erro-nota.
                ASSIGN tt-erro-nota.cod-estabel = pc-cod-estabel 
                       tt-erro-nota.serie       = pc-serie       
                       tt-erro-nota.nr-nota-fis = pc-nr-nota-fis
                       tt-erro-nota.seq-erro    = i-seq-erro.
                {utp/ut-liter.i "Verifique se foi informado Pa°s ISO 3166-2(CD0181) para o Pa°s da Nota Fiscal " *}
                ASSIGN c-lbl-help = TRIM(RETURN-VALUE) + "(":U + nota-fiscal.pais + ")":U.
                {utp/ut-liter.i "Dados da Nota: " * }
                ASSIGN c-lbl-help2 = TRIM(RETURN-VALUE) +  nota-fiscal.cod-estabel + ", ":U + nota-fiscal.serie + ", ":U + nota-fiscal.nr-nota-fis.
                {utp/ut-liter.i Pa°s_ISO_3166-2 * }
                ASSIGN c-lbl-help3 = c-lbl-help + " ":U + c-lbl-help2.
                {method/svc/errors/inserr.i
                        &ErrorNumber="5561"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE + '~~~~' + c-lbl-help3"}
            END.
        END.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaItemValorFinanc DBOProgram 
PROCEDURE piVerificaItemValorFinanc :
/*------------------------------------------------------------------------------
  Purpose:     Verifica se ao menos um item da DU-E possui Valor de Financiamento
               Procedure utilizada no facilitador de preenchimento de dados da DU-E (EX7000c)
  Parameters:  pde-cdd-due-ems (decimal): N£mero Interno da DU-E   (entrada)
               pnum-versao-due (integer): N£mero da Vers∆o da DU-E (entrada)
               pl-dados-financ (logical): Identifica se existe Valor de Financiamento 
                                          informado para algum item da DU-E (sa°da)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pcdd-due-ems     LIKE due-item-draw.cdd-due-ems    NO-UNDO.
    DEFINE INPUT  PARAMETER pnum-versao-due  LIKE due-item-draw.num-versao-due NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-dados-financ  AS   LOGICAL                      NO-UNDO.

    bloco:
    FOR EACH due-item
       WHERE due-item.cdd-due-ems    = pcdd-due-ems
         AND due-item.num-versao-due = pnum-versao-due NO-LOCK:

        IF DEC(SUBSTRING(due-item.cod-livre-1,2,21)) <> 0 THEN DO:
            ASSIGN pl-dados-financ = YES.
            LEAVE bloco.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemNF DBOProgram 
PROCEDURE setConstraintItemNF :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da Query "ItemNF"
  Parameters:  Entrada: pde-cdd-due-ems (decimal): N£mero Interno da DU-E pesquisada
               Entrada: pnum-seq-it-due-ini (integer): Sequància Inicial do Item da DU-E
               Entrada: pnum-seq-it-due-fim (integer): Sequància Final do Item da DU-E
               Entrada: pc-cod-estab-nf-ini (character): Estabelecimento Inicial da NF da DU-E
               Entrada: pc-cod-estab-nf-fim (character): Estabelecimento Final da NF da DU-E
               Entrada: pc-cod-serie-nf-ini (character): SÇrie Inicial da NF da DU-E
               Entrada: pc-cod-serie-nf-fim (character): SÇrie Final da NF da DU-E
               Entrada: pc-nr-nota-ini (character): N£mero Inicial da NF da DU-E
               Entrada: pc-nr-nota-fim (character): N£mero Final da NF da DU-E
               Entrada: pc-it-codigo-ini (character): Item Inicial da NF da DU-E
               Entrada: pc-it-codigo-ini (character): Item Final da NF da DU-E
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pde-cdd-due-ems      LIKE due-item.cdd-due-ems     NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-due-ini  LIKE due-item.num-seq-it-due  NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-due-fim  LIKE due-item.num-seq-it-due  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estab-nf-ini  LIKE due-item.cod-estabel-nf  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estab-nf-fim  LIKE due-item.cod-estabel-nf  NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-serie-nf-ini  LIKE due-item.cod-serie-nf    NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-serie-nf-fim  LIKE due-item.cod-serie-nf    NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-nota-ini       LIKE due-item.cod-nota-fisc   NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-nota-fim       LIKE due-item.cod-nota-fisc   NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-seq-fat-ini   LIKE due-item.num-seq-faturam NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-seq-fat-fim   LIKE due-item.num-seq-faturam NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo-ini     LIKE due-item.cod-item        NO-UNDO.
    DEFINE INPUT PARAMETER pc-it-codigo-fim     LIKE due-item.cod-item        NO-UNDO.

    ASSIGN de-cdd-due-ems       = pde-cdd-due-ems
           i-num-seq-it-due-ini = pnum-seq-it-due-ini
           i-num-seq-it-due-fim = pnum-seq-it-due-fim
           c-cod-estab-nf-ini   = pc-cod-estab-nf-ini
           c-cod-estab-nf-fim   = pc-cod-estab-nf-fim
           c-cod-serie-nf-ini   = pc-cod-serie-nf-ini
           c-cod-serie-nf-fim   = pc-cod-serie-nf-fim
           c-nr-nota-ini        = pc-nr-nota-ini
           c-nr-nota-fim        = pc-nr-nota-fim
           i-num-seq-fat-ini    = pi-num-seq-fat-ini 
           i-num-seq-fat-fim    = pi-num-seq-fat-fim 
           c-it-codigo-ini      = pc-it-codigo-ini
           c-it-codigo-fim      = pc-it-codigo-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItemProcExp DBOProgram 
PROCEDURE setConstraintItemProcExp :
/*------------------------------------------------------------------------------
  Purpose:     Recebe os parÉmetros para abertura da Query "ItemProcExp"
  Parameters:  Entrada: pde-cdd-due-ems (decimal): N£mero Interno da DU-E pesquisada
               Entrada: pnum-seq-it-due-ini (integer): Sequància Inicial do Item da DU-E
               Entrada: pnum-seq-it-due-fim (integer): Sequància Final do Item da DU-E
               Entrada: pc-cod-estab-proc-exp-ini (character): Estabelecimento Inicial do ProcExp da NF da DU-E
               Entrada: pc-cod-estab-proc-exp-fim (character): Estabelecimento Final do ProcExp da NF da DU-E
               Entrada: pc-nr-proc-exp-ini        (character): Processo de Exportaá∆o Inicial da NF da DU-E
               Entrada: pc-nr-proc-exp-fim        (character): Processo de Exportaá∆o Final da NF da DU-E
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pde-cdd-due-ems           LIKE due-item.cdd-due-ems             NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-due-ini       LIKE due-item.num-seq-it-due          NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq-it-due-fim       LIKE due-item.num-seq-it-due          NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estab-proc-exp-ini LIKE due-item.cod-estab-proces-export NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-estab-proc-exp-fim LIKE due-item.cod-estab-proces-export NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-proc-exp-ini        LIKE due-item.cod-proces-export       NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-proc-exp-fim        LIKE due-item.cod-proces-export       NO-UNDO.

    ASSIGN de-cdd-due-ems           = pde-cdd-due-ems
           i-num-seq-it-due-ini     = pnum-seq-it-due-ini
           i-num-seq-it-due-fim     = pnum-seq-it-due-fim
           c-cod-estab-proc-exp-ini = pc-cod-estab-proc-exp-ini
           c-cod-estab-proc-exp-fim = pc-cod-estab-proc-exp-fim
           c-nr-proc-exp-ini        = pc-nr-proc-exp-ini
           c-nr-proc-exp-fim        = pc-nr-proc-exp-fim.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDU-E DBOProgram 
PROCEDURE setConstraintOfDU-E :
/*------------------------------------------------------------------------------
  Purpose:     Seta a vari†vel "de-cdd-due-ems" e "i-num-versao-due" 
               para utilizaá∆o na query "openQueryOfDU-E"
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-cdd-due-ems   LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-versao-due LIKE due-item.num-versao-due NO-UNDO.

    ASSIGN de-cdd-due-ems   = pde-cdd-due-ems
           i-num-versao-due = pi-num-versao-due.

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

    /*Validaá‰es realizadas somente nas alteraá‰es dos registros*/ 
    IF pType = "Update":U THEN DO:

        IF rowObject.val-peso-liq-item = 0 THEN DO:
            {utp/ut-liter.i O_campo_Peso_L°quido_(KG)_Ç_obrigat¢rio,_portanto_deve_possuir_um_valor_para_o_item * }
            {method/svc/errors/inserr.i
                            &ErrorNumber="34691"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U
                            &ErrorParameters="trim(return-value)"}

        END.

        IF rowObject.cod-incoterm = "":U THEN DO:
            {utp/ut-liter.i Condiá∆o_de_Venda * }
            {method/svc/errors/inserr.i
                            &ErrorNumber="55939"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U
                            &ErrorParameters="trim(return-value)"}
        END.

        IF NOT CAN-FIND(FIRST inco-cx 
                        WHERE inco-cx.cod-incoterm = rowObject.cod-incoterm) THEN DO:
            {utp/ut-liter.i Condiá∆o_de_Venda}
            {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS":U
                        &ErrorSubType="ERROR":U
                        &ErrorParameters="trim(return-value)"}
        END.

        IF rowObject.val-cond-vda = 0 THEN DO:
            {utp/ut-liter.i Valor_da_Mercadoria_na_Condiá∆o_de_Venda_(VMCV) * }
            {method/svc/errors/inserr.i
                            &ErrorNumber="55939"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U
                            &ErrorParameters="trim(return-value)"}

        END.

        IF rowObject.val-local-embarq = 0 THEN DO:
            {utp/ut-liter.i Valor_da_Mercadoria_no_Local_de_Embarque_(VMLE) * }
            {method/svc/errors/inserr.i
                            &ErrorNumber="55939"
                            &ErrorType="EMS":U
                            &ErrorSubType="ERROR":U
                            &ErrorParameters="trim(return-value)"}

        END.

        IF rowObject.cdn-destaque <> 0 THEN DO:
            FOR FIRST it-nota-fisc FIELDS(class-fiscal)
                WHERE it-nota-fisc.cod-estabel = rowObject.cod-estabel-nf 
                  AND it-nota-fisc.serie       = rowObject.cod-serie-nf      
                  AND it-nota-fisc.nr-nota-fis = rowObject.cod-nota-fisc  
                  AND it-nota-fisc.nr-seq-fat  = rowObject.num-seq-faturam
                  AND it-nota-fisc.it-codigo   = rowObject.cod-item           NO-LOCK:
        
                FOR FIRST classif-destaq
                    WHERE classif-destaq.class-fiscal = it-nota-fisc.class-fiscal
                      AND classif-destaq.cod-destaq   = rowObject.cdn-destaque  NO-LOCK:
                END.
                IF NOT AVAIL classif-destaq THEN DO:
                    {utp/ut-liter.i Destaque_da_NCM * }
                    ASSIGN c-lbl-destaq = TRIM(RETURN-VALUE).
                    {utp/ut-liter.i NCM_deste_Item * }
                    {method/svc/errors/inserr.i
                                    &ErrorNumber="31926"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR"
                                    &ErrorParameters="c-lbl-destaq + '~~~~' + trim(return-value)"}
                END.
                ELSE DO:
                    IF  TRIM(SUBSTRING(classif-destaq.cod-livre-1,1,10)) = "":U THEN DO:
                        {utp/ut-liter.i "Verifique_se_foi_informado_o_Atributo_deste_Destaque_na_Classificaá∆o_Fiscal_(CD0603)" *}
                        ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
                        {utp/ut-liter.i "Atributo_da_NCM" *}
                        {method/svc/errors/inserr.i
                                        &ErrorNumber="5561"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="RETURN-VALUE + '~~~~' + c-lbl-help"}
                    END.
                END.
            END.
        END.
    
        IF rowObject.cod-enquad-1 = 0 THEN DO:
            {method/svc/errors/inserr.i
            &ErrorNumber="55945"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"}
        END.
        ELSE DO:
            IF NOT CAN-FIND(FIRST enquad-oper 
                            where enquad-oper.cod-enquad = rowObject.cod-enquad-1) THEN DO:
                {utp/ut-liter.i Enquadramento_Operaá∆o*}
                {method/svc/errors/inserr.i
                        &ErrorNumber="2"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE"}
            END.
        END.
    
        IF rowObject.cod-enquad-2 > 0
        AND NOT CAN-FIND(FIRST enquad-oper 
                        where enquad-oper.cod-enquad = rowObject.cod-enquad-2) THEN DO:
            {utp/ut-liter.i Enquadramento_Operaá∆o*}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    
        IF rowObject.cod-enquad-3 > 0
        AND NOT CAN-FIND(FIRST enquad-oper 
                        where enquad-oper.cod-enquad = rowObject.cod-enquad-3) THEN DO:
            {utp/ut-liter.i Enquadramento_Operaá∆o*}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
    
        IF rowObject.cod-enquad-4 > 0
        AND NOT CAN-FIND(FIRST enquad-oper 
                         WHERE enquad-oper.cod-enquad = rowObject.cod-enquad-4) THEN DO:
            {utp/ut-liter.i Enquadramento_Operaá∆o*}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        
        IF rowObject.num-livre-1 = 0
        OR NOT CAN-FIND(FIRST pais
                        WHERE pais.cod-pais = rowObject.num-livre-1) THEN DO:
            {utp/ut-liter.i Pa°s *}
            {method/svc/errors/inserr.i
                    &ErrorNumber="2"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"
                    &ErrorParameters="RETURN-VALUE"}
        END.
        ELSE DO:
            IF rowObject.cod-pais-dest-final = "" THEN DO:
                {utp/ut-liter.i Verifique_se_foi_informado_Pa°s_(ISO_3166-2)_para_o_Pa°s_correspondente_no_Cadastro_de_Pa°s_(CD0181) *}
                ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Pa°s_ISO * }
                {method/svc/errors/inserr.i
                        &ErrorNumber="5561"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="RETURN-VALUE + '~~~~' + c-lbl-help"}
            END.
        END.
        
        IF ((rowObject.cod-enquad-1 = 90001 OR rowObject.cod-enquad-1 = 90003 OR rowObject.cod-enquad-1 = 90005 OR rowObject.cod-enquad-1 = 90099 OR rowObject.cod-enquad-1 = 90115)
        OR  (rowObject.cod-enquad-2 = 90001 OR rowObject.cod-enquad-2 = 90003 OR rowObject.cod-enquad-2 = 90005 OR rowObject.cod-enquad-2 = 90099 OR rowObject.cod-enquad-2 = 90115)
        OR  (rowObject.cod-enquad-3 = 90001 OR rowObject.cod-enquad-3 = 90003 OR rowObject.cod-enquad-3 = 90005 OR rowObject.cod-enquad-3 = 90099 OR rowObject.cod-enquad-3 = 90115)
        OR  (rowObject.cod-enquad-4 = 90001 OR rowObject.cod-enquad-4 = 90003 OR rowObject.cod-enquad-4 = 90005 OR rowObject.cod-enquad-4 = 90099 OR rowObject.cod-enquad-4 = 90115))
        AND (rowObject.cod-proces = "" OR  rowObject.qtd-dias = 0) THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="55946"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
        END.

        IF l-fn-due-v3 THEN DO:
            IF ((rowObject.cod-enquad-1 = 81501 OR rowObject.cod-enquad-1 = 81502 OR rowObject.cod-enquad-1 = 81503)
            OR  (rowObject.cod-enquad-2 = 81501 OR rowObject.cod-enquad-2 = 81502 OR rowObject.cod-enquad-2 = 81503)
            OR  (rowObject.cod-enquad-3 = 81501 OR rowObject.cod-enquad-3 = 81502 OR rowObject.cod-enquad-3 = 81503)
            OR  (rowObject.cod-enquad-4 = 81501 OR rowObject.cod-enquad-4 = 81502 OR rowObject.cod-enquad-4 = 81503))
            AND DEC(SUBSTRING(rowObject.cod-livre-1,2,21)) = 0 THEN DO:
                {utp/ut-liter.i Valor_de_Financiamento_do_Item *}
                ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Foi_informado_Enquadramento_de_Operaá∆o_de_Financiamento,_o_Valor_do_Financiamento_do_Item_deve_ser_Informado *}
                {method/svc/errors/inserr.i
                        &ErrorNumber="56116"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-lbl-help + '~~~~' + RETURN-VALUE"}
    
            END.
        END.
        /*Validaá‰es Drawback Isená∆o */
        RUN piValidaDrawbackIsencao.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resequenciaItensDue DBOProgram 
PROCEDURE resequenciaItensDue :
/*:T------------------------------------------------------------------------------
  Purpose:     Resequenciar os itens da DU-E no campo Sequància do Siscomex
  Parameters:  pcdd-due-ems (Entrada): N£mero da DU-E (decimal).
               pi-num-versao (Entrada): N£mero da vers∆o da DU-E (Inteiro).
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcdd-due-ems  LIKE due-item.cdd-due-ems    NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-versao LIKE due-item.num-versao-due NO-UNDO.

    DEFINE VARIABLE i-num-seq-siscomex AS INTEGER NO-UNDO.

    FOR EACH bfdue-item FIELDS(num-livre-2)
       WHERE bfdue-item.cdd-due-ems     = pcdd-due-ems
         AND bfdue-item.num-versao-due  = pi-num-versao EXCLUSIVE-LOCK
         BREAK BY bfdue-item.num-seq-it-due:
        ASSIGN i-num-seq-siscomex     = i-num-seq-siscomex + 1
               bfdue-item.num-livre-2 = i-num-seq-siscomex.

    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaDrawbackIsencao DBOProgram 
PROCEDURE piValidaDrawbackIsencao :
/*:T------------------------------------------------------------------------------
  Purpose:     Validar enquadramento Drawback Isencao
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-tipo-dado                AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i-cod-enquad-anterior      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-enquad-drawback-current  AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-enquad-drawback-anterior AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-dados-draw               AS LOGICAL     NO-UNDO.
    
    IF NOT VALID-HANDLE(h-bocx00463) THEN
        RUN cxbo/bocx00463.p PERSISTENT SET h-bocx00463.

    FOR FIRST due-siscomex
        WHERE due-siscomex.cdd-due-ems    = rowObject.cdd-due-ems
          AND due-siscomex.num-versao-due = rowObject.num-versao-due NO-LOCK:
    END.

    RUN piVerificaEnquadrDrawbackSuspIsencao IN THIS-PROCEDURE (INPUT rowObject.cdd-due-ems,   
                                                                INPUT rowObject.num-versao-due,
                                                                INPUT rowObject.num-seq-it-due,
                                                                OUTPUT i-cod-enquad-anterior,
                                                                OUTPUT l-enquad-drawback-current,
                                                                OUTPUT l-enquad-drawback-anterior).

    IF  l-enquad-drawback-anterior
    AND NOT l-enquad-drawback-current
    AND CAN-FIND(FIRST due-item-draw
                 WHERE due-item-draw.cdd-due-ems    = rowObject.cdd-due-ems
                   AND due-item-draw.num-versao-due = rowObject.num-versao-due
                   AND due-item-draw.num-seq-it-due = rowObject.num-seq-it-due) THEN DO:

         {utp/ut-liter.i Enquadramento *}
         ASSIGN c-lbl-help = TRIM(RETURN-VALUE) + " ":U + "(" + STRING(i-cod-enquad-anterior) + ")" + " ":U.
         {utp/ut-liter.i Existem_informaá‰es_de_Drawback_informadas_para_o_Item_da_DU-E._Para_atualizar_esta_informaá∆o,_estes_dados_dever∆o_ser_primeiramente_eliminados *}
         {method/svc/errors/inserr.i       
                 &ErrorNumber="6057"
                 &ErrorType="EMS"          
                 &ErrorSubType="ERROR"
                 &ErrorParameters="c-lbl-help + '~~~~' + RETURN-VALUE"}
        
    END.
    ELSE DO:
        RUN piValidaItemRelacionamento IN h-bocx00463 (INPUT rowObject.r-rowid,
                                                       INPUT rowObject.cod-enquad-1,
                                                       INPUT rowObject.cod-enquad-2,
                                                       INPUT rowObject.cod-enquad-3,
                                                       INPUT rowObject.cod-enquad-4,
                                                       OUTPUT l-dados-draw,
                                                       OUTPUT c-tipo-dado).

        IF l-dados-draw THEN DO:
            {utp/ut-liter.i Enquadramento *}
            ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
    
            {utp/ut-liter.i Existem_informaá‰es_de_Drawback * }
            ASSIGN c-lbl-help2 = TRIM(RETURN-VALUE) + " ":U + c-tipo-dado.
    
            {utp/ut-liter.i informadas_para_o_Item_da_DU-E._Para_atualizar_esta_informaá∆o,_estes_dados_dever∆o_ser_primeiramente_eliminados *}
            ASSIGN c-lbl-help2 = c-lbl-help2 + " ":U + TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i       
                    &ErrorNumber="6057"
                    &ErrorType="EMS"          
                    &ErrorSubType="ERROR"
                    &ErrorParameters="c-lbl-help + '~~~~' + c-lbl-help2"}
        END.

    END.

    /*Validaá‰es Drawback Isená∆o DU-E Averbada*/
    IF due-siscomex.idi-sit-siscomex = 12 THEN DO:

        IF  (RowObject.cod-enquad-1 = 0 OR RowObject.cod-enquad-1 = 81105)
        AND (RowObject.cod-enquad-2 = 0 OR RowObject.cod-enquad-2 = 81105)
        AND (RowObject.cod-enquad-3 = 0 OR RowObject.cod-enquad-3 = 81105)
        AND (RowObject.cod-enquad-4 = 0 OR RowObject.cod-enquad-4 = 81105) THEN DO:
            /*Para Retificaá∆o com Drawback Isená∆o, deve ser mantido tambÇm o Enquadramento Original do Item*/

            {utp/ut-liter.i Para_Retificaá∆o_com_Drawback_Isená∆o,_tambÇm_deve_ser_mantido_o_Enquadramento_Original_do_Item *}
            ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
            {utp/ut-liter.i Foi_informado_apenas_Enquadramentos_de_operaá∆o_de_Drawback_Isená∆o._ *}
            ASSIGN c-lbl-help2 = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i       
                     &ErrorNumber="28110"
                     &ErrorType="EMS"          
                     &ErrorSubType="ERROR"
                     &ErrorParameters="c-lbl-help + '~~~~' + c-lbl-help2 + '~~~~' + c-lbl-help"}
        END.

        IF (rowObject.cod-enquad-1 = 81101
        OR  rowObject.cod-enquad-2 = 81101
        OR  rowObject.cod-enquad-3 = 81101
        OR  rowObject.cod-enquad-4 = 81101) AND
           (rowObject.cod-enquad-1 = 81105
        OR  rowObject.cod-enquad-2 = 81105
        OR  rowObject.cod-enquad-3 = 81105
        OR  rowObject.cod-enquad-4 = 81105) THEN DO:

            {utp/ut-liter.i Enquadramento *}
            ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
            {utp/ut-liter.i N∆o_Ç_permitido_informar_um_enquadramento_de_Drawback_Isená∆o/Suspens∆o_quando_j†_existe_um_outro_tipo_de_Enquadramento_de_Drawback_informado. *}
            ASSIGN c-lbl-help2 = TRIM(RETURN-VALUE).

            {method/svc/errors/inserr.i
                &ErrorNumber="31743"
                &ErrorType="EMS"
                &ErrorSubType="ERROR"
                &ErrorParameters="c-lbl-help + '~~~~' + c-lbl-help2"}

        END.
        ELSE DO:
            /*Integridade das informaá‰es: 
                - Enquadramento Isená∆o (81105) deve possuir Tipo de Ato Concess¢rio somente Isená∆o e/ou Isená∆o Intermedi†rio*/
            IF (   rowObject.cod-enquad-1 = 81105
                OR rowObject.cod-enquad-2 = 81105
                OR rowObject.cod-enquad-3 = 81105
                OR rowObject.cod-enquad-4 = 81105
               )
            AND CAN-FIND(FIRST due-item-draw
                         WHERE due-item-draw.cdd-due-ems    = rowObject.cdd-due-ems
                           AND due-item-draw.num-versao-due = rowObject.num-versao-due
                           AND due-item-draw.num-seq-it-due = rowObject.num-seq-it-due
                           AND (due-item-draw.idi-tip-ato-concessor <> 9 AND due-item-draw.idi-tip-ato-concessor <> 10) ) THEN DO:
    
                {utp/ut-liter.i Enquadramento *}
                ASSIGN c-lbl-help = TRIM(RETURN-VALUE).
                {utp/ut-liter.i Existem_informaá‰es_para_Ato_Concess¢rio_do_tipo_Suspens∆o_informados_para_o_item._Para_alterar_o_enquadramento,_essas_informaá‰es_dever∆o_ser_eliminadas *}
                {method/svc/errors/inserr.i       
                         &ErrorNumber="31743"
                         &ErrorType="EMS"          
                         &ErrorSubType="ERROR"
                         &ErrorParameters="c-lbl-help + '~~~~' + RETURN-VALUE"}
            END.
        END.
    END.
    ELSE DO:
        /*Somente Ç poss°vel informar enquadramento drawback isená∆o quando a DU-E estiver Averbada*/
        IF rowObject.cod-enquad-1 = 81105
        OR rowObject.cod-enquad-2 = 81105
        OR rowObject.cod-enquad-3 = 81105 
        OR rowObject.cod-enquad-4 = 81105 THEN DO:
            {method/svc/errors/inserr.i
                    &ErrorNumber="56424"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR"}
        END.
    END.

    IF VALID-HANDLE(h-bocx00463) THEN DO:
        DELETE PROCEDURE h-bocx00463.
        ASSIGN h-bocx00463 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

