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
{include/i-prgvrs.i BOCX359 2.00.00.024 } /*** "010024" 15/10/2025 07:56:43 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bocx359 MUT}
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
&GLOBAL-DEFINE DBOName BOCX359
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-it-nota-desp
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
{cxbo/bocx359.i RowObject}

DEFINE TEMP-TABLE tt-proc-it-nota-desp NO-UNDO LIKE proc-it-nota-desp
    FIELD r-rowid        AS   ROWID
    FIELD de-tot-desp-nf LIKE proc-it-nota-desp.val-despes-nf.

/*Definiá∆o da temp-table respons†vel pelo rateio de Seguro e Embalagem realizado no XML,
definiá∆o igual Ös temp-tables tt-rateio-seguro e tt-rateio-vOutro (axsep017extradeclarations.i))
Caso as mesmas sejam alteradas na include acima, a definiá∆o dever† ser replicada a esta (tt-rateio-despesas-xml) */
DEFINE TEMP-TABLE tt-rateio-despesas-xml NO-UNDO
    FIELD nr-seq-fat LIKE it-nota-fisc.nr-seq-fat
    FIELD it-codigo  LIKE it-nota-fisc.it-codigo
    FIELD percentual AS DEC
    FIELD valor      AS DEC.

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
{cdp/cdcfgmat.i}
define variable c-cod-est-proc like nota-fiscal.cod-estabel no-undo. /*tatiana*/

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nr-nota-fis":U THEN ASSIGN pFieldValue = RowObject.nr-nota-fis.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "serie":U THEN ASSIGN pFieldValue = RowObject.serie.
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
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "cod-itiner":U THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        WHEN "cod-pto-contr":U THEN ASSIGN pFieldValue = RowObject.cod-pto-contr.
        WHEN "idi-busca-despes-export":U THEN ASSIGN pFieldValue = RowObject.idi-busca-despes-export.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-seq-fat":U THEN ASSIGN pFieldValue = RowObject.nr-seq-fat.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
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
  Purpose:     Retorna valores dos campos do °ndice prcstmna-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo serie
               retorna valor do campo nr-nota-fis
               retorna valor do campo nr-seq-fat
               retorna valor do campo it-codigo
               retorna valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proc-it-nota-desp.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proc-it-nota-desp.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estab-faturam LIKE proc-it-nota-desp.cod-estab-faturam NO-UNDO.
    DEFINE OUTPUT PARAMETER pserie LIKE proc-it-nota-desp.serie NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-nota-fis LIKE proc-it-nota-desp.nr-nota-fis NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-seq-fat LIKE proc-it-nota-desp.nr-seq-fat NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE proc-it-nota-desp.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcdn-despes LIKE proc-it-nota-desp.cdn-despes NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pcod-estab-faturam = RowObject.cod-estab-faturam
           pserie = RowObject.serie
           pnr-nota-fis = RowObject.nr-nota-fis
           pnr-seq-fat = RowObject.nr-seq-fat
           pit-codigo = RowObject.it-codigo
           pcdn-despes = RowObject.cdn-despes.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice prcstmna-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo serie
               recebe valor do campo nr-nota-fis
               recebe valor do campo nr-seq-fat
               recebe valor do campo it-codigo
               recebe valor do campo cdn-despes
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proc-it-nota-desp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proc-it-nota-desp.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estab-faturam LIKE proc-it-nota-desp.cod-estab-faturam NO-UNDO.
    DEFINE INPUT PARAMETER pserie LIKE proc-it-nota-desp.serie NO-UNDO.
    DEFINE INPUT PARAMETER pnr-nota-fis LIKE proc-it-nota-desp.nr-nota-fis NO-UNDO.
    DEFINE INPUT PARAMETER pnr-seq-fat LIKE proc-it-nota-desp.nr-seq-fat NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE proc-it-nota-desp.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-despes LIKE proc-it-nota-desp.cdn-despes NO-UNDO.

    FIND FIRST bfproc-it-nota-desp WHERE 
        bfproc-it-nota-desp.cod-estabel = pcod-estabel AND 
        bfproc-it-nota-desp.nr-proc-exp = pnr-proc-exp AND 
        bfproc-it-nota-desp.cod-estab-faturam = pcod-estab-faturam AND 
        bfproc-it-nota-desp.serie = pserie AND 
        bfproc-it-nota-desp.nr-nota-fis = pnr-nota-fis AND 
        bfproc-it-nota-desp.nr-seq-fat = pnr-seq-fat AND 
        bfproc-it-nota-desp.it-codigo = pit-codigo AND 
        bfproc-it-nota-desp.cdn-despes = pcdn-despes NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-it-nota-desp THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-it-nota-desp)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiCriaProcItNotaDesp DBOProgram 
PROCEDURE PiCriaProcItNotaDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER p-seq-wt-docto    LIKE wt-it-docto.seq-wt-docto    NO-UNDO.
DEF INPUT PARAMETER p-seq-wt-it-docto LIKE wt-it-docto.seq-wt-it-docto NO-UNDO.
DEF INPUT PARAMETER r-rowid           AS   ROWID                       NO-UNDO.
DEF INPUT PARAMETER pi-nr-seq-fat     LIKE it-nota-fisc.nr-seq-fat     NO-UNDO.

    FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = r-rowid NO-LOCK NO-ERROR.

    &IF "{&bf_mat_versao_ems}":U <= "2.07":U &THEN
    assign c-cod-est-proc = substring(nota-fiscal.char-1,124,3).
    &else
    assign c-cod-est-proc = nota-fiscal.cod-estab-proces-export.
    &ENDIF

    FIND FIRST param-exp NO-LOCK
         WHERE param-exp.cod-estabel = c-cod-est-proc NO-ERROR.

    FOR EACH wt-it-docto-despes NO-LOCK
       WHERE wt-it-docto-despes.seq-wt-docto    = p-seq-wt-docto
         AND wt-it-docto-despes.seq-wt-it-docto = p-seq-wt-it-docto:

        FIND FIRST wt-it-docto 
             WHERE wt-it-docto.seq-wt-docto = wt-it-docto-despes.seq-wt-docto 
             AND   wt-it-docto.seq-wt-it-docto = wt-it-docto-despes.seq-wt-it-docto NO-LOCK NO-ERROR.

        IF AVAIL wt-it-docto THEN DO:

            CREATE proc-it-nota-desp.
            ASSIGN proc-it-nota-desp.nr-proc-exp             = nota-fiscal.nr-proc-exp
                   proc-it-nota-desp.cod-estabel             = c-cod-est-proc
                   proc-it-nota-desp.cod-estab-faturam       = nota-fiscal.cod-estabel
                   proc-it-nota-desp.serie                   = nota-fiscal.serie
                   proc-it-nota-desp.nr-nota-fis             = nota-fiscal.nr-nota-fis
                   proc-it-nota-desp.nr-seq-fat              = pi-nr-seq-fat
                   proc-it-nota-desp.it-codigo               = wt-it-docto.it-codigo
                   proc-it-nota-desp.cod-itiner              = wt-it-docto-despes.cod-itiner
                   proc-it-nota-desp.cod-pto-contr           = wt-it-docto-despes.cod-pto-contr
                   proc-it-nota-desp.cod-emitente-desp       = wt-it-docto-despes.cod-emitente-desp
                   proc-it-nota-desp.cod-cond-pag            = wt-it-docto-despes.cod-cond-pagto
                   proc-it-nota-desp.cdn-classif-despes      = wt-it-docto-despes.cdn-classif-despes
                   proc-it-nota-desp.cdn-despes              = wt-it-docto-despes.cdn-despes
                   proc-it-nota-desp.val-despes              = wt-it-docto-despes.val-despes
                   proc-it-nota-desp.val-despes-nf           = wt-it-docto-despes.val-despes-nf
                   proc-it-nota-desp.mo-codigo               = wt-it-docto-despes.mo-codigo
                   proc-it-nota-desp.log-forma-preco         = wt-it-docto-despes.log-forma-preco
                   proc-it-nota-desp.log-despes-integr-ap    = wt-it-docto-despes.log-despes-integr-ap
                   proc-it-nota-desp.log-comis-agent         = wt-it-docto-despes.log-comis-agent
                   proc-it-nota-desp.dat-base-cobr-despes    = wt-it-docto-despes.dat-base-cobr-despes
                   proc-it-nota-desp.idi-busca-despes-export = IF  AVAIL param-exp THEN param-exp.idi-busca-despes-export
                                                               ELSE 1
                   &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                       proc-it-nota-desp.log-despes-inclusa = wt-it-docto-despes.log-despes-inclusa
                       proc-it-nota-desp.log-destaca-despes = wt-it-docto-despes.log-destaca-despes
                   &ELSE
                       overlay(proc-it-nota-desp.cod-livre-1,1,1) = trim(substring(wt-it-docto-despes.cod-livre-1,1,1))
                       overlay(proc-it-nota-desp.cod-livre-1,2,1) = trim(substring(wt-it-docto-despes.cod-livre-1,2,1))
                   &ENDIF
                   
                   OVERLAY(proc-it-nota-desp.cod-livre-1,3,16) = TRIM(SUBSTRING(wt-it-docto-despes.cod-livre-1,3,16))
                   .
        END.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaDespesaInclusa DBOProgram 
PROCEDURE piRetornaDespesaInclusa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-cod-estabel     LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nr-proc-exp     LIKE processo-exp.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-despesa-inclusa AS   LOGICAL                  NO-UNDO.

    ASSIGN pl-despesa-inclusa = NO.

    FIND FIRST proc-ped-venda
         WHERE proc-ped-venda.cod-estabel = pc-cod-estabel
           AND proc-ped-venda.nr-proc-exp = pc-nr-proc-exp NO-LOCK NO-ERROR.
                   
    IF AVAIL proc-ped-venda THEN DO:

                ASSIGN pl-despesa-inclusa = NO.
                
                FOR EACH proc-it-nota-desp NO-LOCK
                   WHERE proc-it-nota-desp.cod-estabel = proc-ped-venda.cod-estabel
                         AND proc-it-nota-desp.nr-proc-exp = proc-ped-venda.nr-proc-exp:

                        IF &IF "{&bf_dis_versao_ems}" >= "2.09":U &THEN
                                   proc-it-nota-desp.log-despes-inclusa
                           &ELSE
                                   trim(substring(proc-it-nota-desp.cod-livre-1,1,1)) = "1"
                           &ENDIF
                        THEN DO:
                                ASSIGN pl-despesa-inclusa = YES.
                                LEAVE.
                        END.                    
                END.            
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaDespesaFaturada DBOProgram 
PROCEDURE VerificaDespesaFaturada :
/*------------------------------------------------------------------------------
  Purpose:  Verifica se existe alguam despesa faturada para o ponto de controle/despesa no processo.
  Parameters:  <none>
  Notes:    Se o parÉmetro pi-cod-desp n∆o estiver informado (?)  n∆o considera na busca.
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  pc-cod-estabel   LIKE historico-proc-exp.cod-estabel   NO-UNDO.
    DEFINE INPUT PARAMETER  pc-nr-proc-exp   LIKE historico-proc-exp.nr-proc-exp   NO-UNDO.
    DEFINE INPUT PARAMETER  pi-cod-itiner    LIKE historico-proc-exp.cod-itiner    NO-UNDO.
    DEFINE INPUT PARAMETER  pi-cod-pto-contr LIKE historico-proc-exp.cod-pto-contr NO-UNDO.
    DEFINE INPUT PARAMETER  pi-cod-desp      LIKE proc-desp-itiner.cod-desp        NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-existe        AS LOGICAL                            NO-UNDO.

    ASSIGN pl-existe = CAN-FIND(FIRST proc-it-nota-desp
                                WHERE proc-it-nota-desp.cod-estabel   = pc-cod-estabel
                                  AND proc-it-nota-desp.nr-proc-exp   = pc-nr-proc-exp
                                  AND proc-it-nota-desp.cod-itiner    = pi-cod-itiner
                                  AND proc-it-nota-desp.cod-pto-contr = pi-cod-pto-contr
                                  AND ((pi-cod-desp <> ? AND proc-it-nota-desp.cdn-despes = pi-cod-desp)
                                       OR pi-cod-desp = ?)).
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRateioDespesasExportacaoXML DBOProgram 
PROCEDURE piRateioDespesasExportacaoXML :
/*------------------------------------------------------------------------------
  Purpose:  Realiza a busca das despesas a serem geradas nas tag's vSeg e vOutro
            do XML da NF-e
  Parameters:  <none>
  Notes:    MÇtodo executado pelas includes axsep037upsert.i5 e axsep037upsert.i6
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-rowid-nf       AS ROWID    NO-UNDO.
    DEFINE INPUT  PARAMETER pi-classif-desp   AS INTEGER  NO-UNDO. /*3 - Seguro, 4 - Embalagem*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt-rateio-despesas-xml.

    DEFINE VARIABLE v-tot-vl-rateio-desp LIKE nota-fiscal.vl-seguro NO-UNDO.

    EMPTY TEMP-TABLE tt-proc-it-nota-desp.
    EMPTY TEMP-TABLE tt-rateio-despesas-xml.

    ASSIGN v-tot-vl-rateio-desp = 0.

    FOR FIRST nota-fiscal
        WHERE ROWID(nota-fiscal) = pr-rowid-nf NO-LOCK:

        FOR EACH it-nota-fisc NO-LOCK
           WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel                                                              
             AND it-nota-fisc.serie       = nota-fiscal.serie
             AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
            BREAK BY it-nota-fisc.cod-estabel
                  BY it-nota-fisc.serie
                  BY it-nota-fisc.nr-nota-fis:

            FOR EACH proc-it-nota-desp 
               WHERE proc-it-nota-desp.cod-estab-faturam = it-nota-fisc.cod-estabel
                 AND proc-it-nota-desp.serie             = it-nota-fisc.serie      
                 AND proc-it-nota-desp.nr-nota-fis       = it-nota-fisc.nr-nota-fis
                 AND proc-it-nota-desp.nr-seq-fat        = it-nota-fisc.nr-seq-fat
                 AND proc-it-nota-desp.it-codigo         = it-nota-fisc.it-codigo NO-LOCK
                BREAK BY proc-it-nota-desp.cdn-classif-despes:

                IF proc-it-nota-desp.cdn-classif-despes <> pi-classif-desp THEN NEXT.

                FOR FIRST tt-rateio-despesas-xml
                    WHERE tt-rateio-despesas-xml.nr-seq-fat = proc-it-nota-desp.nr-seq-fat                                                   
                      AND tt-rateio-despesas-xml.it-codigo  = proc-it-nota-desp.it-codigo NO-LOCK:
                END.
                IF NOT AVAIL tt-rateio-despesas-xml THEN DO:
                    CREATE tt-rateio-despesas-xml.                                                                                       
                    ASSIGN tt-rateio-despesas-xml.nr-seq-fat = proc-it-nota-desp.nr-seq-fat                                                   
                           tt-rateio-despesas-xml.it-codigo  = proc-it-nota-desp.it-codigo.
                END.
                ASSIGN tt-rateio-despesas-xml.valor   = tt-rateio-despesas-xml.valor 
                                                      + proc-it-nota-desp.val-despes-nf
                       v-tot-vl-rateio-desp           = v-tot-vl-rateio-desp 
                                                      + tt-rateio-despesas-xml.valor.


                /*Acerto de res°duos*/
                IF pi-classif-desp = 3 THEN DO: /*Seguro*/
                    IF v-tot-vl-rateio-desp < nota-fiscal.vl-seguro THEN DO:                                                            
                        IF  LAST-OF(it-nota-fisc.cod-estabel) THEN DO:                                                                
                            IF  v-tot-vl-rateio-desp <> nota-fiscal.vl-seguro THEN                                                      
                                ASSIGN tt-rateio-despesas-xml.valor = tt-rateio-despesas-xml.valor 
                                                                    + (nota-fiscal.vl-seguro - v-tot-vl-rateio-desp).
                        END.                                                                                                           
                    END.                                                                                                               
                END.

                /*Acerto de res°duos*/
                IF pi-classif-desp = 4 THEN DO: /*Embalagem*/
                    IF v-tot-vl-rateio-desp < nota-fiscal.vl-embalagem THEN DO:                                                            
                        IF  LAST-OF(it-nota-fisc.cod-estabel) THEN DO:                                                                
                            IF  v-tot-vl-rateio-desp <> nota-fiscal.vl-embalagem THEN                                                      
                                ASSIGN tt-rateio-despesas-xml.valor = tt-rateio-despesas-xml.valor 
                                                                    + (nota-fiscal.vl-embalagem - v-tot-vl-rateio-desp).
                        END.                                                                                                           
                    END.         
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
