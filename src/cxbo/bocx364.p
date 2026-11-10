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
{include/i-prgvrs.i BOCX364 2.00.00.003} /*** "010003" 11/12/2023 10:13:27 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX364 MUT}
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
&GLOBAL-DEFINE DBOName BOCX364
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proc-export-atualiz-msg
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
{cxbo/bocx364.i RowObject}
{cxbo/bocx364.i tt-proc-export-atualiz-msg}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Definiá∆o Vari†veis Locais */
DEFINE VARIABLE c-cod-estabel    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dt-dat-gerac     AS DATE       NO-UNDO.
DEFINE VARIABLE c-hra-gerac      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-idi-tip-proces AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-idi-tip-operac AS INTEGER    NO-UNDO.
DEFINE VARIABLE dt-dat-exec      AS DATE       NO-UNDO.
DEFINE VARIABLE c-hra-exec       AS CHARACTER  NO-UNDO.

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
        WHEN "des-msg":U THEN ASSIGN pFieldValue = RowObject.des-msg.
        WHEN "dsl-help-msg":U THEN ASSIGN pFieldValue = RowObject.dsl-help-msg.
        WHEN "hra-exec":U THEN ASSIGN pFieldValue = RowObject.hra-exec.
        WHEN "hra-gerac":U THEN ASSIGN pFieldValue = RowObject.hra-gerac.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
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
        WHEN "dat-exec":U THEN ASSIGN pFieldValue = RowObject.dat-exec.
        WHEN "dat-gerac":U THEN ASSIGN pFieldValue = RowObject.dat-gerac.
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
        WHEN "cdn-msg":U THEN ASSIGN pFieldValue = RowObject.cdn-msg.
        WHEN "idi-tip-msg":U THEN ASSIGN pFieldValue = RowObject.idi-tip-msg.
        WHEN "idi-tip-operac":U THEN ASSIGN pFieldValue = RowObject.idi-tip-operac.
        WHEN "idi-tip-proces":U THEN ASSIGN pFieldValue = RowObject.idi-tip-proces.
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
  Purpose:     Retorna valores dos campos do °ndice prcsxprc-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo dat-gerac
               retorna valor do campo hra-gerac
               retorna valor do campo idi-tip-proces
               retorna valor do campo idi-tip-operac
               retorna valor do campo dat-exec
               retorna valor do campo hra-exec
               retorna valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proc-export-atualiz-msg.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proc-export-atualiz-msg.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-gerac LIKE proc-export-atualiz-msg.dat-gerac NO-UNDO.
    DEFINE OUTPUT PARAMETER phra-gerac LIKE proc-export-atualiz-msg.hra-gerac NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-proces LIKE proc-export-atualiz-msg.idi-tip-proces NO-UNDO.
    DEFINE OUTPUT PARAMETER pidi-tip-operac LIKE proc-export-atualiz-msg.idi-tip-operac NO-UNDO.
    DEFINE OUTPUT PARAMETER pdat-exec LIKE proc-export-atualiz-msg.dat-exec NO-UNDO.
    DEFINE OUTPUT PARAMETER phra-exec LIKE proc-export-atualiz-msg.hra-exec NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq LIKE proc-export-atualiz-msg.num-seq NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pdat-gerac = RowObject.dat-gerac
           phra-gerac = RowObject.hra-gerac
           pidi-tip-proces = RowObject.idi-tip-proces
           pidi-tip-operac = RowObject.idi-tip-operac
           pdat-exec = RowObject.dat-exec
           phra-exec = RowObject.hra-exec
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraProcessoExpAtualizacaoMsg DBOProgram 
PROCEDURE geraProcessoExpAtualizacaoMsg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcod-estabel    LIKE proc-export-atualiz-msg.cod-estabel    NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-proc-exp    LIKE proc-export-atualiz-msg.nr-proc-exp    NO-UNDO.
    DEFINE INPUT  PARAMETER pdat-gerac      LIKE proc-export-atualiz-msg.dat-gerac      NO-UNDO.
    DEFINE INPUT  PARAMETER phra-gerac      LIKE proc-export-atualiz-msg.hra-gerac      NO-UNDO.
    DEFINE INPUT  PARAMETER pidi-tip-proces LIKE proc-export-atualiz-msg.idi-tip-proces NO-UNDO.
    DEFINE INPUT  PARAMETER pidi-tip-operac LIKE proc-export-atualiz-msg.idi-tip-operac NO-UNDO.
    DEFINE INPUT  PARAMETER pdat-exec       LIKE proc-export-atualiz-msg.dat-exec       NO-UNDO.
    DEFINE INPUT  PARAMETER phra-exec       LIKE proc-export-atualiz-msg.hra-exec       NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-seq        LIKE proc-export-atualiz-msg.num-seq        NO-UNDO.
    
    
      for last bfproc-export-atualiz-msg fields( num-seq ) no-lock where
               bfproc-export-atualiz-msg.cod-estabel    = pcod-estabel    and
               bfproc-export-atualiz-msg.nr-proc-exp    = pnr-proc-exp    and
               bfproc-export-atualiz-msg.dat-gerac      = pdat-gerac      and
               bfproc-export-atualiz-msg.hra-gerac      = phra-gerac       and
               bfproc-export-atualiz-msg.idi-tip-proces = pidi-tip-proces and
               bfproc-export-atualiz-msg.idi-tip-operac = pidi-tip-operac and
               bfproc-export-atualiz-msg.dat-exec       = pdat-exec       and
               bfproc-export-atualiz-msg.hra-exec       = phra-exec        by bfproc-export-atualiz-msg.num-seq :
          assign pnum-seq  = bfproc-export-atualiz-msg.num-seq + 1.
      end.

      IF  pnum-seq = 0 THEN
          ASSIGN pnum-seq = 1.

      run utp/ut-msgs.p (input "msg":U, input 31377, input "").

      create bfproc-export-atualiz-msg.
      assign bfproc-export-atualiz-msg.num-seq        = pnum-seq
             bfproc-export-atualiz-msg.cod-estabel    = pcod-estabel    
             bfproc-export-atualiz-msg.nr-proc-exp    = pnr-proc-exp    
             bfproc-export-atualiz-msg.dat-gerac      = pdat-gerac      
             bfproc-export-atualiz-msg.hra-gerac      = phra-gerac       
             bfproc-export-atualiz-msg.idi-tip-proces = pidi-tip-proces 
             bfproc-export-atualiz-msg.idi-tip-operac = pidi-tip-operac 
             bfproc-export-atualiz-msg.dat-exec       = pdat-exec              
             bfproc-export-atualiz-msg.hra-exec       = phra-exec      
             bfproc-export-atualiz-msg.idi-tip-msg    = 1 
             bfproc-export-atualiz-msg.cdn-msg        = 31377
             bfproc-export-atualiz-msg.des-msg        = return-value
             /*bfproc-export-atualiz-msg.dsl-help-msg = */ .

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice prcsxprc-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo dat-gerac
               recebe valor do campo hra-gerac
               recebe valor do campo idi-tip-proces
               recebe valor do campo idi-tip-operac
               recebe valor do campo dat-exec
               recebe valor do campo hra-exec
               recebe valor do campo num-seq
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proc-export-atualiz-msg.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proc-export-atualiz-msg.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pdat-gerac LIKE proc-export-atualiz-msg.dat-gerac NO-UNDO.
    DEFINE INPUT PARAMETER phra-gerac LIKE proc-export-atualiz-msg.hra-gerac NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-proces LIKE proc-export-atualiz-msg.idi-tip-proces NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-operac LIKE proc-export-atualiz-msg.idi-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pdat-exec LIKE proc-export-atualiz-msg.dat-exec NO-UNDO.
    DEFINE INPUT PARAMETER phra-exec LIKE proc-export-atualiz-msg.hra-exec NO-UNDO.
    DEFINE INPUT PARAMETER pnum-seq LIKE proc-export-atualiz-msg.num-seq NO-UNDO.

    FIND FIRST bfproc-export-atualiz-msg WHERE 
        bfproc-export-atualiz-msg.cod-estabel = pcod-estabel AND 
        bfproc-export-atualiz-msg.nr-proc-exp = pnr-proc-exp AND 
        bfproc-export-atualiz-msg.dat-gerac = pdat-gerac AND 
        bfproc-export-atualiz-msg.hra-gerac = phra-gerac AND 
        bfproc-export-atualiz-msg.idi-tip-proces = pidi-tip-proces AND 
        bfproc-export-atualiz-msg.idi-tip-operac = pidi-tip-operac AND 
        bfproc-export-atualiz-msg.dat-exec = pdat-exec AND 
        bfproc-export-atualiz-msg.hra-exec = phra-exec AND 
        bfproc-export-atualiz-msg.num-seq = pnum-seq NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproc-export-atualiz-msg THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproc-export-atualiz-msg)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryControlExec DBOProgram 
PROCEDURE openQueryControlExec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
         WHERE {&TableName}.cod-estabel    = c-cod-estabel   
           AND {&TableName}.nr-proc-exp    = c-nr-proc-exp   
           AND {&TableName}.dat-gerac      = dt-dat-gerac    
           AND {&TableName}.hra-gerac      = c-hra-gerac     
           AND {&tablename}.idi-tip-proces = i-idi-tip-proces
           AND {&tablename}.idi-tip-operac = i-idi-tip-operac
           AND {&TableName}.dat-exec       = dt-dat-exec
           AND {&TableName}.hra-exec       = c-hra-exec INDEXED-REPOSITION.
    
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
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaMsg DBOProgram 
PROCEDURE retornaMsg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pr-msg AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-proc-export-atualiz-msg.

    FIND bfproc-export-atualiz-msg WHERE ROWID(bfproc-export-atualiz-msg) = pr-msg NO-LOCK NO-ERROR.
    IF AVAIL bfproc-export-atualiz-msg THEN DO:
        EMPTY TEMP-TABLE tt-proc-export-atualiz-msg.
        CREATE tt-proc-export-atualiz-msg.
        BUFFER-COPY bfproc-export-atualiz-msg TO tt-proc-export-atualiz-msg.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintControlExec DBOProgram 
PROCEDURE setConstraintControlExec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel    LIKE proc-export-atualiz-exec.cod-estabel    NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp    LIKE proc-export-atualiz-exec.nr-proc-exp    NO-UNDO.
    DEFINE INPUT PARAMETER pdat-gerac      LIKE proc-export-atualiz-exec.dat-gerac      NO-UNDO.
    DEFINE INPUT PARAMETER phra-gerac      LIKE proc-export-atualiz-exec.hra-gerac      NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-proces LIKE proc-export-atualiz-exec.idi-tip-proces NO-UNDO.
    DEFINE INPUT PARAMETER pidi-tip-operac LIKE proc-export-atualiz-exec.idi-tip-operac NO-UNDO.
    DEFINE INPUT PARAMETER pdat-exec       LIKE proc-export-atualiz-exec.dat-exec       NO-UNDO.
    DEFINE INPUT PARAMETER phra-exec       LIKE proc-export-atualiz-exec.hra-exec       NO-UNDO.

    ASSIGN c-cod-estabel    = pcod-estabel   
           c-nr-proc-exp    = pnr-proc-exp   
           dt-dat-gerac     = pdat-gerac     
           c-hra-gerac      = phra-gerac     
           i-idi-tip-proces = pidi-tip-proces
           i-idi-tip-operac = pidi-tip-operac
           dt-dat-exec      = pdat-exec
           c-hra-exec       = phra-exec.

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

