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
{include/i-prgvrs.i BOCX355 2.00.00.024 } /*** "010024" 11/12/2023 10:13:26 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX355 MUT}
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
&GLOBAL-DEFINE DBOName BOCX355
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName proces-acond
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
{cxbo/bocx355.i RowObject}

{cxbo/bocx356.i tt-proces-acond-volum}
{cxbo/bocx352.i tt-proces-embal-resum}
{cxbo/bocx353.i tt-proces-embal-volum-aux}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* Definiá∆o de Vari†veis Locais */
DEFINE VARIABLE h-bocx354    AS HANDLE                     NO-UNDO.  /*---  proces-acond-item ---*/
DEFINE VARIABLE h-bocx356    AS HANDLE                     NO-UNDO.  /*---  proces-acond-volum ---*/
DEFINE VARIABLE h-bocx352    AS HANDLE                     NO-UNDO.  /*---  proces-embal-resum ---*/
DEFINE VARIABLE h-bocx353    AS HANDLE                     NO-UNDO.  /*---  proces-embal-volum ---*/
define variable cCodAcondIni like {&TableName}.cod-acond   no-undo.
define variable cCodAcondFim like {&TableName}.cod-acond   no-undo.
define variable cCodEstabel  like {&TableName}.cod-estabel no-undo.
define variable cNrProcExp   like {&TableName}.nr-proc-exp no-undo.

DEFINE VARIABLE c-cod-estabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nr-proc-exp AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-num-volum-embal    AS INTEGER  NO-UNDO.
DEFINE VARIABLE r-proc-exp-sub      AS ROWID NO-UNDO.
DEFINE VARIABLE r-proc-exp-orig     AS ROWID NO-UNDO.

def var i-cont as int no-undo.

DEFINE BUFFER bf-processo-exp-sub     FOR processo-exp.
DEFINE BUFFER bf-proces-acond         FOR proces-acond.
DEFINE BUFFER bf-proces-acond-2       FOR proces-acond.
DEFINE BUFFER bf-proces-acond-volum   FOR proces-acond-volum.
DEFINE BUFFER bf-proces-acond-volum-2 FOR proces-acond-volum.
DEFINE BUFFER bf-proces-embal-resum   FOR proces-embal-resum.
DEFINE BUFFER bf-proces-embal-resum-2 FOR proces-embal-resum.
DEFINE BUFFER bf-proces-embal-volum   FOR proces-embal-volum.

DEFINE TEMP-TABLE tt-proces-acond LIKE RowObject.

DEFINE TEMP-TABLE tt-itens-proc-exp NO-UNDO
    FIELD cod-estabel  LIKE proc-ped-ent.cod-estabel
    FIELD nr-proc-exp  LIKE proc-ped-ent.nr-proc-exp
    FIELD nr-sequencia LIKE proc-ped-ent.nr-sequencia 
    FIELD it-codigo    LIKE proc-ped-ent.it-codigo    
    FIELD cod-refer    LIKE proc-ped-ent.cod-refer    
    FIELD quantidade   LIKE proc-ped-ent.quantidade[1]
    FIELD qtd-embal    LIKE proc-ped-ent.quantidade[1]              
    FIELD qt-embalar   LIKE proc-ped-ent.quantidade[1]             
    FIELD nome-abrev   LIKE proc-ped-ent.nome-abrev   
    FIELD nr-pedcli    LIKE proc-ped-ent.nr-pedcli    
    FIELD nr-entrega   LIKE proc-ped-ent.nr-entrega.

DEFINE TEMP-TABLE tt-embarque-acond NO-UNDO
       FIELD cdd-embarq   LIKE embarque.cdd-embarq
       FIELD nr-proc-exp  LIKE embarque.nr-proc-exp
       FIELD situacao     LIKE embarque.situacao
       FIELD cod-estabel  LIKE embarque.cod-estabel
       FIELD dt-embarque  LIKE embarque.dt-embarque
       FIELD identific    LIKE embarque.identific
       field cod-estab-nf like nota-fiscal.cod-estabel
       field serie        like nota-fiscal.serie
       field nr-nota-fis  like nota-fiscal.nr-nota-fis
       field marcar       as character
       field r-rowid      as rowid.

{dibo/bodi135.i tt-nota-fiscal-acond}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT VALID-HANDLE(h-bocx356) THEN RUN cxbo/bocx356.p persistent set h-bocx356.

    empty temp-table tt-proces-acond-volum.
    empty temp-table RowErrors.
    
    create tt-proces-acond-volum.
    assign tt-proces-acond-volum.cod-estabel     = RowObject.cod-estabel
           tt-proces-acond-volum.nr-proc-exp     = RowObject.nr-proc-exp
           tt-proces-acond-volum.cod-acond       = RowObject.cod-acond
           tt-proces-acond-volum.num-volum-acond = 0
           tt-proces-acond-volum.sigla-emb-pai   = RowObject.sigla-emb.

    run openQueryStatic in h-bocx356 (input "Main":U).
    run setRecord in h-bocx356 (input table tt-proces-acond-volum).
    run createRecord in h-bocx356.
    EMPTY TEMP-TABLE tt-proces-acond-volum.
    run getRowErrors in h-bocx356 (output table RowErrors).
    FOR EACH RowErrors 
       WHERE RowErrors.ErrorType = "INTERNAL":U:
       DELETE RowErrors.
    END.        
    if  can-find(first RowErrors) then
        return "NOK":U.
    
    return "OK":U.

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
    DEFINE VARIABLE h-bocx354 AS HANDLE     NO-UNDO.  /*---  proces-acond-item ---*/
    DEFINE VARIABLE h-bocx356 AS HANDLE     NO-UNDO.  /*---  proces-acond-volum ---*/
    DEFINE VARIABLE h-bocx352 AS HANDLE     NO-UNDO.  /*---  proces-embal-resum ---*/
    DEFINE VARIABLE h-bocx353 AS HANDLE     NO-UNDO.  /*---  proces-embal-volum ---*/

    IF NOT VALID-HANDLE(h-bocx354) THEN RUN cxbo/bocx354.p persistent set h-bocx354.
    IF NOT VALID-HANDLE(h-bocx356) THEN RUN cxbo/bocx356.p persistent set h-bocx356.
    IF NOT VALID-HANDLE(h-bocx352) THEN RUN cxbo/bocx352.p persistent set h-bocx352.
    IF NOT VALID-HANDLE(h-bocx353) THEN RUN cxbo/bocx353.p persistent set h-bocx353.

    /*--- Limpa RowErrors ---*/      
    RUN emptyRowErrors IN h-bocx354.
    RUN emptyRowErrors IN h-bocx356.
    RUN emptyRowErrors IN h-bocx352.
    RUN emptyRowErrors IN h-bocx353.

    DO TRANS ON ERROR UNDO:

        /*--- Elimina proces-embal-volum -----------------------------------------------*/
        RUN openQueryStatic IN h-bocx353 (INPUT "Main":U).
        FOR EACH proces-embal-volum
           WHERE proces-embal-volum.cod-estabel = RowObject.cod-estabel
             AND proces-embal-volum.nr-proc-exp = RowObject.nr-proc-exp
             AND proces-embal-volum.cod-acond   = RowObject.cod-acond NO-LOCK:
             RUN emptyRowObject   IN h-bocx353.
             RUN repositionRecord IN h-bocx353 (ROWID(proces-embal-volum)).
             RUN deleteRecord     IN h-bocx353.
    
             IF RETURN-VALUE <> 'OK':U THEN DO:
                RUN getRowErrors IN h-bocx353 (OUTPUT TABLE rowErrors APPEND).
                /*--- Elimina da tabela de erros , os erros internos ---*/
                FOR EACH RowErrors 
                   WHERE RowErrors.ErrorType = "INTERNAL":U:
                   DELETE RowErrors.
                END.
             END.
        END.              
        IF VALID-HANDLE(h-bocx353) THEN RUN destroy IN h-bocx353.

        /*--- Elimina proces-embal-resum -----------------------------------------------*/
        RUN openQueryStatic IN h-bocx352 (INPUT "Main":U).
        FOR EACH proces-embal-resum
           WHERE proces-embal-resum.cod-estabel = RowObject.cod-estabel
             AND proces-embal-resum.nr-proc-exp = RowObject.nr-proc-exp
             AND proces-embal-resum.cod-acond   = RowObject.cod-acond   NO-LOCK:
    
             RUN emptyRowObject   IN h-bocx352.
             RUN repositionRecord IN h-bocx352 (ROWID(proces-embal-resum)).
             RUN deleteRecord     IN h-bocx352.
    
             IF RETURN-VALUE <> 'OK':U THEN DO:
                RUN getRowErrors IN h-bocx352 (OUTPUT TABLE rowErrors APPEND).
                /*--- Elimina da tabela de erros , os erros internos ---*/
                FOR EACH RowErrors 
                   WHERE RowErrors.ErrorType = "INTERNAL":U:
                   DELETE RowErrors.
                END.
             END.
        END.              
        IF VALID-HANDLE(h-bocx352) THEN RUN destroy IN h-bocx352.

        /*--- Elimina proces-acond-item -----------------------------------------------*/
        RUN openQueryStatic IN h-bocx354 (INPUT "Main":U).
        FOR EACH proces-acond-item
           WHERE proces-acond-item.cod-estabel = RowObject.cod-estabel
             AND proces-acond-item.nr-proc-exp = RowObject.nr-proc-exp
             AND proces-acond-item.cod-acond   = RowObject.cod-acond   NO-LOCK:
    
             RUN emptyRowObject   IN h-bocx354.
             RUN repositionRecord IN h-bocx354 (ROWID(proces-acond-item)).
             RUN deleteRecord     IN h-bocx354.
    
             IF RETURN-VALUE <> 'OK':U THEN DO:
                RUN getRowErrors IN h-bocx354 (OUTPUT TABLE rowErrors APPEND).
                /*--- Elimina da tabela de erros , os erros internos ---*/
                FOR EACH RowErrors 
                   WHERE RowErrors.ErrorType = "INTERNAL":U:
                   DELETE RowErrors.
                END.
             END.
        END.              
        IF VALID-HANDLE(h-bocx354) THEN RUN destroy IN h-bocx354.
    
        /*--- Elimina proces-acond-volum -----------------------------------------------*/
        RUN openQueryStatic IN h-bocx356 (INPUT "Main":U).
        FOR EACH proces-acond-volum
           WHERE proces-acond-volum.cod-estabel = RowObject.cod-estabel
             AND proces-acond-volum.nr-proc-exp = RowObject.nr-proc-exp
             AND proces-acond-volum.cod-acond   = RowObject.cod-acond   NO-LOCK:

             RUN emptyRowObject   IN h-bocx356.
             RUN repositionRecord IN h-bocx356 (ROWID(proces-acond-volum)).
             RUN deleteRecord     IN h-bocx356.
             
             IF RETURN-VALUE <> 'OK':U THEN DO:
                RUN getRowErrors IN h-bocx356 (OUTPUT TABLE rowErrors APPEND).
               
                /*--- Elimina da tabela de erros , os erros internos ---*/
                FOR EACH RowErrors 
                   WHERE RowErrors.ErrorType = "INTERNAL":U:
                   DELETE RowErrors.
                END.
             END.
        END.              
        IF VALID-HANDLE(h-bocx356) THEN RUN destroy IN h-bocx356.

        IF CAN-FIND(FIRST RowErrors 
            WHERE RowErrors.ErrorSubType =  "ERROR":U
              AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
            UNDO,LEAVE.
    END.
    /*---------------------------------------------------------------------------------*/

    IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType =  "ERROR":U
                  AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
        RETURN "NOK":U.
    ELSE
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminaEmbalagens DBOProgram 
PROCEDURE eliminaEmbalagens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-estabel LIKE proces-acond.cod-estabel  NO-UNDO.
DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-acond.nr-proc-exp  NO-UNDO.

FOR EACH proces-embal-volum
   WHERE proces-embal-volum.cod-estabel = pcod-estabel
     AND proces-embal-volum.nr-proc-exp = pnr-proc-exp EXCLUSIVE-LOCK:
      DELETE proces-embal-volum.
END.              

FOR EACH proces-embal-resum
   WHERE proces-embal-resum.cod-estabel = pcod-estabel
     AND proces-embal-resum.nr-proc-exp = pnr-proc-exp EXCLUSIVE-LOCK:
      DELETE proces-embal-resum.
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
        WHEN "cod-acond":U THEN ASSIGN pFieldValue = RowObject.cod-acond.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "des-acond":U THEN ASSIGN pFieldValue = RowObject.des-acond.
        WHEN "lacre":U THEN ASSIGN pFieldValue = RowObject.lacre.
        WHEN "nr-proc-exp":U THEN ASSIGN pFieldValue = RowObject.nr-proc-exp.
        WHEN "selo":U THEN ASSIGN pFieldValue = RowObject.selo.
        WHEN "sigla-emb":U THEN ASSIGN pFieldValue = RowObject.sigla-emb.
        WHEN "tamanho":U THEN ASSIGN pFieldValue = RowObject.tamanho.
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
        WHEN "tara":U THEN ASSIGN pFieldValue = RowObject.tara.
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
  Purpose:     Retorna valores dos campos do °ndice prcscnd-id
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo nr-proc-exp
               retorna valor do campo cod-acond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE proces-acond.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-proc-exp LIKE proces-acond.nr-proc-exp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-acond LIKE proces-acond.cod-acond NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pnr-proc-exp = RowObject.nr-proc-exp
           pcod-acond = RowObject.cod-acond.

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
  Purpose:     Reposiciona registro com base no °ndice prcscnd-id
  Parameters:  
               recebe valor do campo cod-estabel
               recebe valor do campo nr-proc-exp
               recebe valor do campo cod-acond
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE proces-acond.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-acond.nr-proc-exp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-acond LIKE proces-acond.cod-acond NO-UNDO.

    FIND FIRST bfproces-acond WHERE 
        bfproces-acond.cod-estabel = pcod-estabel AND 
        bfproces-acond.nr-proc-exp = pnr-proc-exp AND 
        bfproces-acond.cod-acond = pcod-acond NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfproces-acond THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfproces-acond)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToProcesso-exp DBOProgram 
PROCEDURE linkToProcesso-exp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hp_Parent AS HANDLE NO-UNDO.

ASSIGN c-cod-estabel = ""
       c-nr-proc-exp = "".

if  valid-handle(hp_Parent) then do:
    run getCharField in hp_Parent (input "cod-estabel":U, output c-cod-estabel).
    run getCharField in hp_Parent (input "nr-proc-exp":U, output c-nr-proc-exp).
end.

RETURN "OK".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcessoExp DBOProgram 
PROCEDURE openQueryProcessoExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&queryname} FOR EACH {&tablename} NO-LOCK
     WHERE {&tablename}.cod-estabel = c-cod-estabel
       AND {&tablename}.nr-proc-exp = c-nr-proc-exp
       INDEXED-REPOSITION .

RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryProcExp DBOProgram 
PROCEDURE openQueryProcExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 OPEN QUERY {&QueryName} FOR EACH  {&TableName} NO-LOCK
                             where {&TableName}.cod-estabel = cCodEstabel
                               and {&TableName}.nr-proc-exp = cNrProcExp
                                and {&TableName}.cod-acond >= cCodAcondIni
                                and {&TableName}.cod-acond <= cCodAcondFim.
 
 RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintProcExp DBOProgram 
PROCEDURE setConstraintProcExp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param pcCodEstabel like {&TableName}.cod-estabel no-undo.
    def input param pcNrProcExp  like {&TableName}.nr-proc-exp no-undo.
    def input param pcCodAcondIni like {&TableName}.cod-acond no-undo.
    def input param pcCodAcondFim like {&TableName}.cod-acond no-undo.
    
    assign cCodEstabel  = pcCodEstabel
           cNrProcExp   = pcNrProcExp
           cCodAcondIni = pcCodAcondIni
           cCodAcondFim = pcCodAcondFim.

    return "OK":U.

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

    case pType:
        when "Create":U then do:
            if can-find(first bf{&TableName} no-lock
                        where bf{&TableName}.cod-estabel = RowObject.cod-estabel
                          and bf{&TableName}.nr-proc-exp = RowObject.nr-proc-exp
                          and bf{&TableName}.cod-acond   = RowObject.cod-acond) then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-acondicionamento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Acondicionamento" *}
                ASSIGN c-lbl-liter-acondicionamento = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i &ErrorNumber="1" 
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="c-lbl-liter-acondicionamento"}
            end.

            if  RowObject.cod-acond = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-acondicionamento-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Acondicionamento" *}
                ASSIGN c-lbl-liter-acondicionamento-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i 
                              &ErrorNumber="17394"
                              &ErrorType="EMS":U
                              &ErrorParameters="c-lbl-liter-acondicionamento-2"}  
            end.

            if RowObject.sigla-emb = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-sigla-acond AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Sigla_Acond" *}
                ASSIGN c-lbl-liter-sigla-acond = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i 
                              &ErrorNumber="17394"
                              &ErrorType="EMS":U
                              &ErrorParameters="c-lbl-liter-sigla-acond"}  
            end.
            else
                if  not can-find (first embalag no-lock
                                 where embalag.sigla-emb = RowObject.sigla-emb) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-embalagem AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Embalagem" *}
                    ASSIGN c-lbl-liter-embalagem = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="2" 
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-liter-embalagem"}
                end.            
        end.

        when "Update":U then do:
            if RowObject.sigla-emb = "" then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-sigla-acond-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Sigla_Acond" *}
                ASSIGN c-lbl-liter-sigla-acond-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i 
                              &ErrorNumber="17394"
                              &ErrorType="EMS":U
                              &ErrorParameters="c-lbl-liter-sigla-acond-2"}  
            end.
            else
                if  not can-find (first embalag no-lock
                                 where embalag.sigla-emb = RowObject.sigla-emb) then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-embalagem-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Embalagem" *}
                    ASSIGN c-lbl-liter-embalagem-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i &ErrorNumber="2" 
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR"
                                                &ErrorParameters="c-lbl-liter-embalagem-2"}
                end.            
        end.

        when "Delete":U then do:
        end.                    
    end case.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U
                  AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaGeracaoEmbal DBOProgram 
PROCEDURE verificaGeracaoEmbal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcod-estabel LIKE proces-acond.cod-estabel  NO-UNDO.
DEFINE INPUT PARAMETER pnr-proc-exp LIKE proces-acond.nr-proc-exp  NO-UNDO.

FOR FIRST proces-acond
    WHERE proces-acond.cod-estabel = pcod-estabel
      AND proces-acond.nr-proc-exp = pnr-proc-exp NO-LOCK:

    FOR EACH proc-ped-ent NO-LOCK
       WHERE proc-ped-ent.nr-proc-exp = proces-acond.nr-proc-exp
         AND proc-ped-ent.cod-estabel = proces-acond.cod-estabel
         AND proc-ped-ent.ind-componen <> 3:

        FOR FIRST proces-acond-item
            WHERE proces-acond-item.nome-abrev   = proc-ped-ent.nome-abrev  
              AND proces-acond-item.nr-pedcli    = proc-ped-ent.nr-pedcli   
              AND proces-acond-item.nr-sequencia = proc-ped-ent.nr-sequencia
              AND proces-acond-item.it-codigo    = proc-ped-ent.it-codigo   
              AND proces-acond-item.cod-refer    = proc-ped-ent.cod-refer   
              AND proces-acond-item.nr-entrega   = proc-ped-ent.nr-entrega  
              AND proces-acond-item.cod-estabel  = proc-ped-ent.cod-estabel 
              AND proces-acond-item.nr-proc-exp  = proc-ped-ent.nr-proc-exp NO-LOCK:
        END.
        IF NOT AVAIL proces-acond-item THEN
            RETURN "NOK":U.

    END.

END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaSigla DBOProgram 
PROCEDURE verificaSigla :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcod-estabel LIKE proces-acond.cod-estabel  NO-UNDO.
DEFINE INPUT  PARAMETER pnr-proc-exp LIKE proces-acond.nr-proc-exp  NO-UNDO.
define input  parameter psigla-emb   like proces-acond.sigla-emb    NO-UNDO.
define output parameter pult-sigla   as char                        no-undo.

find last proces-acond
    WHERE proces-acond.cod-estabel = pcod-estabel
      AND proces-acond.nr-proc-exp = pnr-proc-exp 
      AND proces-acond.sigla-emb begins psigla-emb
      no-lock no-error.

IF avail proces-acond THEN do:
   DO i-cont = 1 to length (proces-acond.cod-acond):
      IF substring(proces-acond.cod-acond,i-cont,1) = " " THEN
      assign pult-sigla = substring(proces-acond.cod-acond,i-cont + 1,3).
   END.
   return "OK":U.
END.
else
   return "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaAcondVolum DBOProgram 
PROCEDURE VerificaAcondVolum:

   DEF INPUT PARAM pcod-estabel LIKE proces-acond.cod-estabel     NO-UNDO.
   DEF INPUT PARAM pnr-proc-exp LIKE proces-acond.nr-proc-exp     NO-UNDO.
   DEF INPUT PARAM p-cod-acond  LIKE proces-acond-volum.cod-acond NO-UNDO.

   FOR first proces-acond-volum NO-LOCK
      where proces-acond-volum.cod-estabel     = pcod-estabel
        and proces-acond-volum.nr-proc-exp     = pnr-proc-exp
        and proces-acond-volum.cod-acond       = p-cod-acond
        and proces-acond-volum.num-volum-acond <> 0:
       return "NOK":U.
   END.

   for first proces-embal-resum NO-LOCK
       where proces-embal-resum.cod-estabel     = pcod-estabel
         and proces-embal-resum.nr-proc-exp     = pnr-proc-exp
         and proces-embal-resum.cod-acond       = p-cod-acond:
       return "NOK":U.
   END.

   return "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaRegistroByProcesso DBOProgram 
PROCEDURE piVerificaRegistroByProcesso:
/*------------------------------------------------------------------------------
  Purpose: Verifica se existe acondicionamentos para o processo de exportaá∆o   
  Parameters:  pcod-estabel - C¢digo do Estabelecimento
               pnr-proc-exp - N£mero do Processo de Exportaá∆o
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcod-estabel LIKE proces-acond.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pnr-proc-exp	LIKE proces-acond.nr-proc-exp NO-UNDO.

    IF NOT CAN-FIND (FIRST proces-acond
                     WHERE proces-acond.cod-estabel = pcod-estabel 
                       AND proces-acond.nr-proc-exp = pnr-proc-exp)THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetiraTodosVolumes DBOProgram 
PROCEDURE piRetiraTodosVolumes:
/*------------------------------------------------------------------------------
  Purpose: Elimina os volumes j† realizados para o Acondicionamento de Origem   
  Parameters:  pcod-estabel - C¢digo do estabelecimento
               pnr-proc-exp - N£mero do processo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcod-estabel LIKE proces-embal-volum.cod-estabel NO-UNDO.
    DEFINE INPUT PARAM pnr-proc-exp	LIKE proces-embal-volum.nr-proc-exp NO-UNDO.

    RUN emptyRowErrors IN h-bocx353.

    /*retira os volumes do Processo de Exportaá∆o de Origem para nova geraá∆o/atualizaá∆o*/

    FOR EACH proces-embal-volum 
       WHERE proces-embal-volum.cod-estabel = pcod-estabel
         AND proces-embal-volum.nr-proc-exp = pnr-proc-exp NO-LOCK:
        RUN emptyRowErrors  IN h-bocx353.
        RUN openQueryStatic IN h-bocx353 (INPUT "Main":U).
        RUN goToKey         IN h-bocx353 (INPUT proces-embal-volum.cod-estabel,
                                          INPUT proces-embal-volum.nr-proc-exp,
                                          INPUT proces-embal-volum.cod-acond,
                                          INPUT proces-embal-volum.num-volum-acond,
                                          INPUT proces-embal-volum.num-volum-embal,
                                          INPUT proces-embal-volum.sigla-emb,
                                          INPUT proces-embal-volum.nome-abrev,
                                          INPUT proces-embal-volum.nr-pedcli,
                                          INPUT proces-embal-volum.nr-sequencia,
                                          INPUT proces-embal-volum.it-codigo,
                                          INPUT proces-embal-volum.cod-refer,
                                          INPUT proces-embal-volum.nr-entrega).
        RUN validateRecord  IN h-bocx353 (INPUT 'Delete':U).
        RUN getRowErrors    IN h-bocx353 (OUTPUT TABLE RowErrors).       
        IF NOT CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorSubType =  "ERROR":U
                        AND   RowErrors.ErrorType    <> "INTERNAL":U) then do:
            for first proces-embal-resum 
                where proces-embal-resum.cod-estabel     = proces-embal-volum.cod-estabel    
                  and proces-embal-resum.nr-proc-exp     = proces-embal-volum.nr-proc-exp    
                  and proces-embal-resum.cod-acond       = proces-embal-volum.cod-acond      
                  and proces-embal-resum.num-volum-acond = proces-embal-volum.num-volum-acond
                  and proces-embal-resum.sigla-emb       = proces-embal-volum.sigla-emb EXCLUSIVE-LOCK:
                IF proces-embal-resum.qti-volum > 0 THEN
                    assign proces-embal-resum.qti-volum = proces-embal-resum.qti-volum - 1.

                RELEASE proces-embal-resum.
            end.
            RUN deleteRecord IN h-bocx353.
        end.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaCopiaAcond DBOProgram 
PROCEDURE piCriaCopiaAcond:
/*------------------------------------------------------------------------------
  Purpose: Cria registros nas tabelas "Proces-acond" , "proces-acond-volm" e "proces-embal-resum"
  Parameters:  pi-identifc-nf-embarq - identifica se est† relacionando nota ou 
               embarque(1=nota fiscal, 2=Embarque)
               tt-nota-fiscal-acond - Temp-table com  notas fiscais transferidas
               tt-embarque-acond - Temp-table com embarques transferidos
               RowErrors - Temp-table de erro
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAM pi-identifc-nf-embarq  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR tt-nota-fiscal-acond.
    DEFINE INPUT PARAM TABLE FOR tt-embarque-acond.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE c-cod-estabel-de   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nr-proc-exp-de   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-cod-estabel-para AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nr-proc-exp-para AS CHARACTER   NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx353) THEN RUN cxbo/bocx353.p persistent set h-bocx353.
    IF NOT VALID-HANDLE(h-bocx356) THEN RUN cxbo/bocx356.p persistent set h-bocx356.
    IF NOT VALID-HANDLE(h-bocx352) THEN RUN cxbo/bocx352.p persistent set h-bocx352.

    /*Processo de origem*/
    FIND FIRST processo-exp 
         WHERE rowid(processo-exp) = r-proc-exp-orig NO-LOCK NO-ERROR.

    /*Sub-processo*/
    FIND FIRST bf-processo-exp-sub 
         WHERE rowid(bf-processo-exp-sub) = r-proc-exp-sub NO-LOCK NO-ERROR.

    IF AVAIL processo-exp AND AVAIL bf-processo-exp-sub THEN DO:
        IF pi-identifc-nf-embarq = 1 THEN /*Nota fiscal*/
            FOR EACH tt-nota-fiscal-acond NO-LOCK:
                RUN pi-busca-embal-a-transferir (INPUT pi-identifc-nf-embarq,
                                                 INPUT tt-nota-fiscal-acond.r-rowid,
                                                 INPUT 0).
            END.
        ELSE /*Embarque*/
            FOR EACH tt-embarque-acond NO-LOCK:
                RUN pi-busca-embal-a-transferir (INPUT pi-identifc-nf-embarq,
                                                 INPUT ?,
                                                 INPUT tt-embarque-acond.cdd-embarq).
            END.
       
        FOR EACH tt-itens-proc-exp NO-LOCK 
            BREAK BY tt-itens-proc-exp.nr-proc-exp:

            IF FIRST-OF(tt-itens-proc-exp.nr-proc-exp) THEN DO:

                /*L¢gica para saber qual processo est† saindo a nota e qual est† entrando. 
                Motivo:A nota/embarque pode ser transferido do processo de origem para o 
                subprocesso ou do subprocesso para o processo origem*/
                ASSIGN c-cod-estabel-de = tt-itens-proc-exp.cod-estabel
                       c-nr-proc-exp-de = tt-itens-proc-exp.nr-proc-exp.

                IF tt-itens-proc-exp.nr-proc-exp =  processo-exp.nr-proc-exp THEN
                    ASSIGN c-cod-estabel-para = bf-processo-exp-sub.cod-estabel
                           c-nr-proc-exp-para = bf-processo-exp-sub.nr-proc-exp.
                ELSE
                    ASSIGN c-cod-estabel-para = processo-exp.cod-estabel 
                           c-nr-proc-exp-para = processo-exp.nr-proc-exp.
        
                /******************************************************************/

                EMPTY TEMP-TABLE tt-proces-acond.
                EMPTY TEMP-TABLE tt-proces-acond-volum.
                EMPTY TEMP-TABLE tt-proces-embal-resum.
                
                /*Cria tt-proces-acond, tt-proces-acond-volum e tt-proces-embal-resum para 
                o processo destino com base no processo anterior*/
                FOR EACH bf-proces-acond 
                   WHERE bf-proces-acond.cod-estabel = c-cod-estabel-de
                     AND bf-proces-acond.nr-proc-exp = c-nr-proc-exp-de NO-LOCK:
                   
                    /*Copia "proces-acond" do processo anterior para o processo de destino, caso n∆o exista*/
                    IF NOT CAN-FIND (FIRST bf-proces-acond-2 
                                     WHERE bf-proces-acond-2.cod-estabel = c-cod-estabel-para 
                                       AND bf-proces-acond-2.nr-proc-exp = c-nr-proc-exp-para 
                                       AND bf-proces-acond-2.cod-acond = bf-proces-acond.cod-acond) THEN DO:
                        CREATE tt-proces-acond.
                        BUFFER-COPY bf-proces-acond TO tt-proces-acond NO-ERROR.
                        ASSIGN tt-proces-acond.cod-estabel = c-cod-estabel-para
                               tt-proces-acond.nr-proc-exp = c-nr-proc-exp-para.
            
                        RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).           
                        RUN emptyRowErrors  IN THIS-PROCEDURE.
                        RUN emptyRowObject  IN THIS-PROCEDURE.
                        RUN setRecord       IN THIS-PROCEDURE (INPUT TABLE tt-proces-acond).
                        RUN createRecord    IN THIS-PROCEDURE.
                       
                        EMPTY TEMP-TABLE tt-proces-acond.
                    END.
                    /*:T--- Verifica ocorrància de erros ---*/
                    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U
                                      AND RowErrors.ErrorType    <> "INTERNAL":U) THEN
                        RETURN "NOK":U.
        
                    FOR EACH bf-proces-acond-volum
                       WHERE bf-proces-acond-volum.cod-estabel = bf-proces-acond.cod-estabel
                         AND bf-proces-acond-volum.nr-proc-exp = bf-proces-acond.nr-proc-exp
                         AND bf-proces-acond-volum.cod-acond   = bf-proces-acond.cod-acond NO-LOCK:

                        /*Copia "proces-acond-volum" do processo anterior para o processo de destino, caso n∆o exista*/
                        IF bf-proces-acond-volum.num-volum-acond <> 0 THEN DO:
                            IF NOT CAN-FIND (FIRST bf-proces-acond-volum-2 
                                     WHERE bf-proces-acond-volum-2.cod-estabel = c-cod-estabel-para 
                                       AND bf-proces-acond-volum-2.nr-proc-exp = c-nr-proc-exp-para 
                                       AND bf-proces-acond-volum-2.cod-acond = bf-proces-acond.cod-acond
                                       AND bf-proces-acond-volum-2.num-volum-acond = bf-proces-acond-volum.num-volum-acond) THEN DO:
                                CREATE tt-proces-acond-volum.
                                BUFFER-COPY bf-proces-acond-volum TO tt-proces-acond-volum NO-ERROR.
                                ASSIGN tt-proces-acond-volum.cod-estabel = c-cod-estabel-para
                                       tt-proces-acond-volum.nr-proc-exp = c-nr-proc-exp-para.
                               
                                RUN openQueryStatic IN h-bocx356 (INPUT "Main":U).           
                                RUN emptyRowErrors  IN h-bocx356.
                                RUN emptyRowObject  IN h-bocx356.
                                RUN setRecord       IN h-bocx356 (INPUT TABLE tt-proces-acond-volum).
                                RUN createRecord    IN h-bocx356.
                                run getRowErrors    in h-bocx356 (output table RowErrors APPEND).
                                EMPTY TEMP-TABLE tt-proces-acond-volum.
                            END.
                        END.
        
                        /*Copia "proces-embal-resum" do processo anterior para o processo de destino, caso n∆o exista*/
                        FOR EACH bf-proces-embal-resum
                           WHERE bf-proces-embal-resum.cod-estabel     = bf-proces-acond-volum.cod-estabel
                             AND bf-proces-embal-resum.nr-proc-exp     = bf-proces-acond-volum.nr-proc-exp
                             AND bf-proces-embal-resum.cod-acond       = bf-proces-acond-volum.cod-acond
                             AND bf-proces-embal-resum.num-volum-acond = bf-proces-acond-volum.num-volum-acond NO-LOCK:
            
                            IF NOT CAN-FIND (FIRST bf-proces-embal-resum-2
                                 WHERE bf-proces-embal-resum-2.cod-estabel       = c-cod-estabel-para
                                   AND bf-proces-embal-resum-2.nr-proc-exp       = c-nr-proc-exp-para
                                   AND bf-proces-embal-resum-2.cod-acond         = bf-proces-embal-resum.cod-acond
                                   AND bf-proces-embal-resum-2.num-volum-acond   = bf-proces-embal-resum.num-volum-acond
                                   AND bf-proces-embal-resum-2.sigla-emb         = bf-proces-embal-resum.sigla-emb) THEN DO:
                                CREATE tt-proces-embal-resum.
                                BUFFER-COPY bf-proces-embal-resum TO tt-proces-embal-resum NO-ERROR.
                                ASSIGN tt-proces-embal-resum.cod-estabel     = c-cod-estabel-para 
                                       tt-proces-embal-resum.nr-proc-exp     = c-nr-proc-exp-para
                                       tt-proces-embal-resum.qti-volum       = 0.
                               
                                RUN emptyRowErrors  IN h-bocx352.
                                RUN emptyRowObject  IN h-bocx352.
                                RUN openQueryStatic IN h-bocx352 (INPUT "Main":U).
                                RUN setRecord       IN h-bocx352 (INPUT TABLE tt-proces-embal-resum).
                                RUN validateRecord  IN h-bocx352 (INPUT 'Create':U).
                                RUN getRowErrors    IN h-bocx352 (OUTPUT TABLE RowErrors).    
                                 
                                IF NOT CAN-FIND(FIRST RowErrors 
                                                WHERE RowErrors.ErrorSubType =  "ERROR":U
                                                AND   RowErrors.ErrorType    <> "INTERNAL":U) THEN
                                    RUN createRecord IN h-bocx352.
                                EMPTY TEMP-TABLE tt-proces-embal-resum.
                            END.
                        END.
                    END.
                END.
            END.
            RUN pi-cria-embalagens (INPUT c-cod-estabel-para,
                                    INPUT c-nr-proc-exp-para).
        END.

        /*Varre todos os volumes do processo de origem para eliminar os volumes e acondicionamentos que n∆o s∆o utilizados.*/
        FOR EACH bf-proces-acond-volum FIELDS(cod-estabel nr-proc-exp cod-acond num-volum-acond)
           WHERE bf-proces-acond-volum.cod-estabel = processo-exp.cod-estabel
             AND bf-proces-acond-volum.nr-proc-exp = processo-exp.nr-proc-exp NO-LOCK:

            RUN pi-elimina-volume-acond-nao-utilizados ( input bf-proces-acond-volum.cod-estabel,
                                                         input bf-proces-acond-volum.nr-proc-exp,
                                                         input bf-proces-acond-volum.cod-acond,
                                                         input bf-proces-acond-volum.num-volum-acond).
        END.

        /*Varre todos os volumes do subprocess para eliminar os volumes e acondicionamentos que n∆o s∆o utilizados.*/
        FOR EACH bf-proces-acond-volum FIELDS(cod-estabel nr-proc-exp cod-acond num-volum-acond)
           WHERE bf-proces-acond-volum.cod-estabel = bf-processo-exp-sub.cod-estabel
             AND bf-proces-acond-volum.nr-proc-exp = bf-processo-exp-sub.nr-proc-exp NO-LOCK:

            RUN pi-elimina-volume-acond-nao-utilizados ( input bf-proces-acond-volum.cod-estabel,
                                                         input bf-proces-acond-volum.nr-proc-exp,
                                                         input bf-proces-acond-volum.cod-acond,
                                                         input bf-proces-acond-volum.num-volum-acond).
        END.
    END.

    IF  VALID-HANDLE(h-bocx356) THEN DO:
        DELETE PROCEDURE h-bocx356.
        ASSIGN h-bocx356 = ?.
    END.
    IF  VALID-HANDLE(h-bocx353) THEN DO:
        DELETE PROCEDURE h-bocx353.
        ASSIGN h-bocx353 = ?.
    END.
    IF  VALID-HANDLE(h-bocx352) THEN DO:
        DELETE PROCEDURE h-bocx352.
        ASSIGN h-bocx352 = ?.
    END.
    /*acima ok*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-embalagens DBOProgram 
PROCEDURE pi-cria-embalagens:
/*------------------------------------------------------------------------------
  Purpose: Cria embalagens
  Parameters:  pc-cod-estabel - Codigo estabelecimento
               pc-nr-proc-exp - Numero do processo de exportacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.

    DEFINE VARIABLE de-qtd-embal AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-qtd-embalar AS DECIMAL NO-UNDO.
    
    DO TRANS ON ERROR UNDO:
        ASSIGN de-qtd-embal = 0.
        FOR EACH bf-proces-acond 
           WHERE bf-proces-acond.cod-estabel = pc-cod-estabel
             AND bf-proces-acond.nr-proc-exp = pc-nr-proc-exp NO-LOCK:
            
            FOR EACH bf-proces-acond-volum
               WHERE bf-proces-acond-volum.cod-estabel = bf-proces-acond.cod-estabel
                 AND bf-proces-acond-volum.nr-proc-exp = bf-proces-acond.nr-proc-exp
                 AND bf-proces-acond-volum.cod-acond   = bf-proces-acond.cod-acond NO-LOCK:

                EMPTY TEMP-TABLE tt-proces-embal-volum-aux.
                
                /*Consulta embalagens do processo de origem*/
                FOR EACH bf-proces-embal-volum NO-LOCK
                   WHERE bf-proces-embal-volum.cod-estabel     = tt-itens-proc-exp.cod-estabel          
                     AND bf-proces-embal-volum.nr-proc-exp     = tt-itens-proc-exp.nr-proc-exp
                     AND bf-proces-embal-volum.cod-acond       = bf-proces-acond-volum.cod-acond
                     AND bf-proces-embal-volum.num-volum-acond = bf-proces-acond-volum.num-volum-acond
                     AND bf-proces-embal-volum.nome-abrev      = tt-itens-proc-exp.nome-abrev 
                     AND bf-proces-embal-volum.nr-pedcli       = tt-itens-proc-exp.nr-pedcli   
                     AND bf-proces-embal-volum.nr-sequencia    = tt-itens-proc-exp.nr-sequencia 
                     AND bf-proces-embal-volum.it-codigo       = tt-itens-proc-exp.it-codigo   
                     AND bf-proces-embal-volum.cod-refer       = tt-itens-proc-exp.cod-refer   
                     AND bf-proces-embal-volum.nr-entrega      = tt-itens-proc-exp.nr-entrega
                     BY bf-proces-embal-volum.num-volum-embal DESC:
                    
                    RUN getNextVolum IN h-bocx353(INPUT bf-proces-acond-volum.cod-estabel,    
                                                  INPUT bf-proces-acond-volum.nr-proc-exp,    
                                                  INPUT bf-proces-acond-volum.cod-acond,      
                                                  INPUT bf-proces-acond-volum.num-volum-acond,
                                                  OUTPUT i-num-volum-embal).

                    /*Enquanto a quantidade embalada for menor que a quantidade faturada/alocada 
                     transfere o volume para o novo processo de exportaá∆o*/
                    IF de-qtd-embal <  tt-itens-proc-exp.quantidade THEN DO:
                        /*Se quantidade embalada no processo anterior for menor ou igual que o que falta embalar 
                          cria no novo processo e elimina do anterior*/
                       IF bf-proces-embal-volum.qtd-embal <= (tt-itens-proc-exp.quantidade - de-qtd-embal) THEN DO:
                            CREATE tt-proces-embal-volum-aux.
                            ASSIGN tt-proces-embal-volum-aux.cod-estabel     = bf-proces-acond-volum.cod-estabel    
                                   tt-proces-embal-volum-aux.nr-proc-exp     = bf-proces-acond-volum.nr-proc-exp    
                                   tt-proces-embal-volum-aux.cod-acond       = bf-proces-acond-volum.cod-acond      
                                   tt-proces-embal-volum-aux.num-volum-acond = bf-proces-acond-volum.num-volum-acond
                                   tt-proces-embal-volum-aux.num-volum-embal = i-num-volum-embal
                                   tt-proces-embal-volum-aux.sigla-emb       = bf-proces-embal-volum.sigla-emb
                                   tt-proces-embal-volum-aux.nome-abrev      = bf-proces-embal-volum.nome-abrev  
                                   tt-proces-embal-volum-aux.nr-pedcli       = bf-proces-embal-volum.nr-pedcli   
                                   tt-proces-embal-volum-aux.nr-sequencia    = bf-proces-embal-volum.nr-sequencia
                                   tt-proces-embal-volum-aux.it-codigo       = bf-proces-embal-volum.it-codigo   
                                   tt-proces-embal-volum-aux.cod-refer       = bf-proces-embal-volum.cod-refer   
                                   tt-proces-embal-volum-aux.nr-entrega      = bf-proces-embal-volum.nr-entrega
                                   tt-proces-embal-volum-aux.qtd-embal       = bf-proces-embal-volum.qtd-embal.

                            ASSIGN de-qtd-embal = de-qtd-embal + bf-proces-embal-volum.qtd-embal.

                            RUN pi-cria-embal-novo-proc-exp.

                            RUN pi-elimina-embal-proc-exp-anterior.

                            EMPTY TEMP-TABLE tt-proces-embal-volum-aux NO-ERROR.
                       END.
                       ELSE DO:
                            /*Se a quantidade embalada no processo anterior for maior que o que falta embalar 
                            deve criar no novo processo apenas com a diferenáa e alterar no processo anterior 
                            retirando essa diferenáa*/
                            ASSIGN de-qtd-embalar = tt-itens-proc-exp.quantidade - de-qtd-embal.

                            CREATE tt-proces-embal-volum-aux.
                            ASSIGN tt-proces-embal-volum-aux.cod-estabel     = bf-proces-acond-volum.cod-estabel    
                                   tt-proces-embal-volum-aux.nr-proc-exp     = bf-proces-acond-volum.nr-proc-exp    
                                   tt-proces-embal-volum-aux.cod-acond       = bf-proces-acond-volum.cod-acond      
                                   tt-proces-embal-volum-aux.num-volum-acond = bf-proces-acond-volum.num-volum-acond
                                   tt-proces-embal-volum-aux.num-volum-embal = i-num-volum-embal
                                   tt-proces-embal-volum-aux.sigla-emb       = bf-proces-embal-volum.sigla-emb
                                   tt-proces-embal-volum-aux.nome-abrev      = bf-proces-embal-volum.nome-abrev  
                                   tt-proces-embal-volum-aux.nr-pedcli       = bf-proces-embal-volum.nr-pedcli   
                                   tt-proces-embal-volum-aux.nr-sequencia    = bf-proces-embal-volum.nr-sequencia
                                   tt-proces-embal-volum-aux.it-codigo       = bf-proces-embal-volum.it-codigo   
                                   tt-proces-embal-volum-aux.cod-refer       = bf-proces-embal-volum.cod-refer   
                                   tt-proces-embal-volum-aux.nr-entrega      = bf-proces-embal-volum.nr-entrega
                                   tt-proces-embal-volum-aux.qtd-embal       = de-qtd-embalar.
                            
                            RUN pi-cria-embal-novo-proc-exp.
                            EMPTY TEMP-TABLE tt-proces-embal-volum-aux NO-ERROR.

                            RUN pi-altera-embal-proc-exp-anterior(INPUT de-qtd-embalar).
                            ASSIGN de-qtd-embal = de-qtd-embal + de-qtd-embalar.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-embal-novo-proc-exp DBOProgram 
PROCEDURE pi-cria-embal-novo-proc-exp:
/*------------------------------------------------------------------------------
  Purpose: Efetiva criaá∆o das embalagens e atualiza o resumo no novo processo 
           da nota/embarque
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    RUN emptyRowErrors  IN h-bocx353.
    RUN openQueryStatic IN h-bocx353 (INPUT "Main":U).
    RUN setRecord       IN h-bocx353 (INPUT TABLE tt-proces-embal-volum-aux).
    RUN validateRecord  IN h-bocx353 (INPUT 'Create':U).
    RUN getRowErrors    IN h-bocx353 (OUTPUT TABLE RowErrors APPEND).       
    IF NOT CAN-FIND(FIRST RowErrors 
                    WHERE RowErrors.ErrorSubType =  "ERROR":U
                    AND   RowErrors.ErrorType    <> "INTERNAL":U) then do:
        
        RUN createRecord    IN h-bocx353.
        empty temp-table tt-proces-embal-resum.
        RUN emptyRowErrors  IN h-bocx352.
        RUN openQueryStatic IN h-bocx352 (INPUT "Main":U).
        run GotoKey         in h-bocx352 (input bf-proces-acond-volum.cod-estabel,     
                                          input bf-proces-acond-volum.nr-proc-exp,     
                                          input bf-proces-acond-volum.cod-acond,       
                                          input bf-proces-acond-volum.num-volum-acond, 
                                          input bf-proces-embal-volum.sigla-emb).
        if  return-value = "OK":U then do:
            run getRecord in h-bocx352 (output table tt-proces-embal-resum).
           
            for first tt-proces-embal-resum:
                assign tt-proces-embal-resum.qti-volum = tt-proces-embal-resum.qti-volum + 1.
                run repositionRecord in h-bocx352 (input tt-proces-embal-resum.r-rowid).
                run setRecord        in h-bocx352 (input table tt-proces-embal-resum).
                run UpdateRecord     in h-bocx352.
                RUN getRowErrors     IN h-bocx352 (OUTPUT TABLE RowErrors APPEND).  
            end.
        end.
    END.


 RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-embal-proc-exp-anterior DBOProgram 
PROCEDURE pi-elimina-embal-proc-exp-anterior:
/*------------------------------------------------------------------------------
  Purpose: Efetiva eliminaá∆o das embalagens e atualiza o resumo no processo anterior
           da nota/embarque
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-cod-estabel     LIKE proces-embal-volum.cod-estabel      NO-UNDO.
    DEFINE VARIABLE c-nr-proc-exp     LIKE proces-embal-volum.nr-proc-exp      NO-UNDO.
    DEFINE VARIABLE c-cod-acond       LIKE proces-embal-volum.cod-acond        NO-UNDO.
    DEFINE VARIABLE i-num-volum-acond LIKE proces-embal-volum.num-volum-acond  NO-UNDO.
    DEFINE VARIABLE c-sigla-emb       LIKE proces-embal-volum.sigla-emb        NO-UNDO.

    IF AVAIL bf-proces-embal-volum THEN DO:
        ASSIGN c-cod-estabel     = bf-proces-embal-volum.cod-estabel     
               c-nr-proc-exp     = bf-proces-embal-volum.nr-proc-exp    
               c-cod-acond       = bf-proces-embal-volum.cod-acond      
               i-num-volum-acond = bf-proces-embal-volum.num-volum-acond
               c-sigla-emb       = bf-proces-embal-volum.sigla-emb.
                                        
        RUN emptyRowErrors  IN h-bocx353.
        RUN openQueryStatic IN h-bocx353 (INPUT "Main":U).
        run GotoKey         in h-bocx353(input bf-proces-embal-volum.cod-estabel    ,
                                         input bf-proces-embal-volum.nr-proc-exp    ,
                                         input bf-proces-embal-volum.cod-acond      ,
                                         input bf-proces-embal-volum.num-volum-acond,
                                         input bf-proces-embal-volum.num-volum-embal,
                                         input bf-proces-embal-volum.sigla-emb      ,
                                         input bf-proces-embal-volum.nome-abrev     ,
                                         input bf-proces-embal-volum.nr-pedcli      ,
                                         input bf-proces-embal-volum.nr-sequencia   ,
                                         input bf-proces-embal-volum.it-codigo      ,
                                         input bf-proces-embal-volum.cod-refer      ,
                                         input bf-proces-embal-volum.nr-entrega).    
        if  return-value = "OK":U then do:
            RUN validateRecord  IN h-bocx353 (INPUT 'Delete':U).
            RUN getRowErrors    IN h-bocx353 (OUTPUT TABLE RowErrors APPEND).    
            IF NOT CAN-FIND(FIRST RowErrors 
                            WHERE RowErrors.ErrorSubType =  "ERROR":U
                            AND   RowErrors.ErrorType    <> "INTERNAL":U) then do:
                RUN deleteRecord IN h-bocx353.
                empty temp-table tt-proces-embal-resum.
                RUN emptyRowErrors  IN h-bocx352.
                RUN openQueryStatic IN h-bocx352 (INPUT "Main":U).
                run GotoKey         in h-bocx352 (input c-cod-estabel,     
                                                  input c-nr-proc-exp,     
                                                  input c-cod-acond,      
                                                  input i-num-volum-acond, 
                                                  input c-sigla-emb).      
                if  return-value = "OK":U then do:
                    run getRecord in h-bocx352 (output table tt-proces-embal-resum).
                   
                    for first tt-proces-embal-resum:
                        assign tt-proces-embal-resum.qti-volum = tt-proces-embal-resum.qti-volum - 1.
                        run repositionRecord in h-bocx352 (input tt-proces-embal-resum.r-rowid).
                        run setRecord        in h-bocx352 (input table tt-proces-embal-resum).
                        run UpdateRecord     in h-bocx352.
                        RUN getRowErrors     IN h-bocx352 (OUTPUT TABLE RowErrors APPEND).  
                    end.
                end.
            END.
        END.
    END.

     /*--- Elimina da tabela de erros , os erros internos ---*/
    FOR EACH RowErrors 
       WHERE RowErrors.ErrorType = "INTERNAL":U:
       DELETE RowErrors.
    END.
 
     RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE pi-elimina-volume-acond-nao-utilizados:
    /*------------------------------------------------------------------------------
      Purpose: Elimina os volumes e acondicionamentos que n∆o s∆o utilizados.
      Parameters:  pc-cod-estabel     - C¢digo do estabelecimento
                   pc-nr-proc-exp     - N£mero do processo de exportaá∆o
                   pc-cod-acond       - C¢digo de acondicionamento
                   pi-num-volum-acond - N£mero do volume do acondicionamento
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel     LIKE proces-embal-volum.cod-estabel     NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-proc-exp     LIKE proces-embal-volum.nr-proc-exp     NO-UNDO.
    DEFINE INPUT PARAMETER pc-cod-acond       LIKE proces-embal-volum.cod-acond       NO-UNDO.
    DEFINE INPUT PARAMETER pi-num-volum-acond LIKE proces-embal-volum.num-volum-acond NO-UNDO.

    /*Se n∆o existir embalagem para esse volume, elimina o volume*/
    IF NOT CAN-FIND (FIRST proces-embal-volum 
                     WHERE proces-embal-volum.cod-estabel     = pc-cod-estabel    
                       AND proces-embal-volum.nr-proc-exp     = pc-nr-proc-exp    
                       AND proces-embal-volum.cod-acond       = pc-cod-acond      
                       AND proces-embal-volum.num-volum-acond = pi-num-volum-acond) THEN DO:

        RUN emptyRowErrors  IN h-bocx356.
        RUN openQueryStatic IN h-bocx356 (INPUT "Main":U).
        run GotoKey         in h-bocx356(input pc-cod-estabel,
                                         input pc-nr-proc-exp,
                                         input pc-cod-acond ,
                                         input pi-num-volum-acond).    
        if  return-value = "OK":U then do:
            RUN validateRecord  IN h-bocx356 (INPUT 'Delete':U).
            RUN getRowErrors    IN h-bocx356 (OUTPUT TABLE RowErrors APPEND).    
            IF NOT CAN-FIND(FIRST RowErrors 
                            WHERE RowErrors.ErrorSubType =  "ERROR":U
                            AND   RowErrors.ErrorType    <> "INTERNAL":U) then do:
               
                RUN deleteRecord IN h-bocx356.

                /*Se n∆o houver volume para esse acondicionamento, elimina o acondicionamento*/
                IF NOT CAN-FIND (FIRST proces-acond-volum 
                                 WHERE proces-acond-volum.cod-estabel = pc-cod-estabel     
                                   AND proces-acond-volum.nr-proc-exp = pc-nr-proc-exp     
                                   AND proces-acond-volum.cod-acond   = pc-cod-acond) THEN DO:
                    RUN emptyRowObject  IN THIS-PROCEDURE.             
                    RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).
                    
                    RUN goToKey IN THIS-PROCEDURE (INPUT pc-cod-estabel,
                                                   INPUT pc-nr-proc-exp,
                                                   INPUT pc-cod-acond).
                    if  return-value = "OK":U then do:
                        RUN validateRecord  IN THIS-PROCEDURE (INPUT 'Delete':U).
                        
                        IF NOT CAN-FIND(FIRST RowErrors 
                                        WHERE RowErrors.ErrorSubType =  "ERROR":U
                                        AND   RowErrors.ErrorType    <> "INTERNAL":U) then do:
                            
                            RUN deleteRecord IN THIS-PROCEDURE.
                        end.
                    END.
                END.
            END.
        END.
    END.
END PROCEDURE.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-embal-proc-exp-anterior DBOProgram 
PROCEDURE pi-altera-embal-proc-exp-anterior:
/*------------------------------------------------------------------------------
  Purpose: Altera o registro da embalagem no processo anterior retirando o que 
            foi repassado para o novo processo
  Parameters:  pde-qtd-retirar - Quantidade a ser retirada da quantidade do 
               registro no processo anterior
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pde-qtd-retirar AS DECIMAL NO-UNDO.

    RUN emptyRowErrors  IN h-bocx353.
    RUN openQueryStatic IN h-bocx353 (INPUT "Main":U).
    EMPTY TEMP-TABLE tt-proces-embal-volum-aux NO-ERROR.
    run GotoKey         in h-bocx353(input bf-proces-embal-volum.cod-estabel    ,
                                     input bf-proces-embal-volum.nr-proc-exp    ,
                                     input bf-proces-embal-volum.cod-acond      ,
                                     input bf-proces-embal-volum.num-volum-acond,
                                     input bf-proces-embal-volum.num-volum-embal,
                                     input bf-proces-embal-volum.sigla-emb      ,
                                     input bf-proces-embal-volum.nome-abrev     ,
                                     input bf-proces-embal-volum.nr-pedcli      ,
                                     input bf-proces-embal-volum.nr-sequencia   ,
                                     input bf-proces-embal-volum.it-codigo      ,
                                     input bf-proces-embal-volum.cod-refer      ,
                                     input bf-proces-embal-volum.nr-entrega).    
    if  return-value = "OK":U then do:
        run getRecord in h-bocx353 (output table tt-proces-embal-volum-aux).
        FOR FIRST tt-proces-embal-volum-aux NO-LOCK:
            ASSIGN tt-proces-embal-volum-aux.qtd-embal = tt-proces-embal-volum-aux.qtd-embal - pde-qtd-retirar.
            run repositionRecord in h-bocx353 (input tt-proces-embal-volum-aux.r-rowid).
            run setRecord        in h-bocx353 (input table tt-proces-embal-volum-aux).
            run UpdateRecord     in h-bocx353.
            RUN getRowErrors     IN h-bocx353 (OUTPUT TABLE RowErrors APPEND). 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-elimina-acond-relac DBOProgram 
PROCEDURE pi-elimina-acond-relac:
/*------------------------------------------------------------------------------
  Purpose: Elimina o acondicionamento e seus relacionamentos
  Parameters:  pc-cod-estabel - Codigo estabelecimento
               pc-nr-proc-exp - Numero do processo de exportacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-estabel LIKE processo-exp.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pc-nr-proc-exp LIKE processo-exp.nr-proc-exp NO-UNDO.

    /*Elimina as embalagens*/
    RUN piRetiraTodosVolumes (INPUT pc-cod-estabel,
                              INPUT pc-nr-proc-exp).

    FOR EACH bf-proces-acond
       WHERE bf-proces-acond.cod-estabel = pc-cod-estabel
         AND bf-proces-acond.nr-proc-exp = pc-nr-proc-exp NO-LOCK:

        /*Elimina proces-acond*/
        RUN emptyRowErrors  IN THIS-PROCEDURE.
        RUN emptyRowObject  IN THIS-PROCEDURE.
        RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U).
        
        RUN goToKey IN THIS-PROCEDURE (INPUT bf-proces-acond.cod-estabel,
                                       INPUT bf-proces-acond.nr-proc-exp,
                                       INPUT bf-proces-acond.cod-acond).
        RUN validateRecord  IN THIS-PROCEDURE (INPUT 'Delete':U).
        
        IF NOT CAN-FIND(FIRST RowErrors 
                        WHERE RowErrors.ErrorSubType =  "ERROR":U
                        AND   RowErrors.ErrorType    <> "INTERNAL":U) then do:
            
            RUN deleteRecord IN THIS-PROCEDURE.
        end.
        ELSE
            RETURN "NOK":U.
        /*FIM - Elimina proces-acond*/
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-rowid-proces DBOProgram 
PROCEDURE pi-seta-rowid-proces:
/*------------------------------------------------------------------------------
  Purpose: Seta rowids do processo de origem e do subprocesso
  Parameters:  pr-proc-exp-orig - Rowid processo de origem
               pr-proc-exp-sub  - Rowid subprocesso
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-proc-exp-orig AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pr-proc-exp-sub  AS ROWID NO-UNDO.

    ASSIGN r-proc-exp-orig = pr-proc-exp-orig
           r-proc-exp-sub = pr-proc-exp-sub.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-embal-a-transferir DBOProgram 
PROCEDURE pi-busca-embal-a-transferir:
/*------------------------------------------------------------------------------
  Purpose: busca as embalagens que ser∆o atualizadas
  Parameters:  pi-identific-nf-embarq - identifica se est† transferindo nota ou embarque (1=Nota Fiscal, 2=Embarque)
               pr-nota-fiscal - Rowid nota fiscal
               pd-embarque    - C¢digo do embarque
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-identific-nf-embarq AS INTEGER NO-UNDO.
    DEFINE INPUT PARAMETER pr-nota-fiscal AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pd-embarque    AS DECIMAL NO-UNDO.

    DEFINE VARIABLE de-qtd-embal  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-qt-embalar AS DECIMAL NO-UNDO.
    DEFINE VARIABLE c-nr-proc-exp AS CHAR NO-UNDO.
    DEFINE VARIABLE c-cod-estabel AS CHAR NO-UNDO.

    /*Processo de origem*/
    FIND FIRST processo-exp 
         WHERE rowid(processo-exp) = r-proc-exp-orig NO-LOCK NO-ERROR.

    /*Sub-processo*/
    FIND FIRST bf-processo-exp-sub 
         WHERE rowid(bf-processo-exp-sub) = r-proc-exp-sub NO-LOCK NO-ERROR.
    
    /*Se NOTA FISCAL*/
    IF pi-identific-nf-embarq = 1 THEN DO:
        FIND FIRST nota-fiscal NO-LOCK
             WHERE rowid(nota-fiscal) = pr-nota-fiscal NO-ERROR.
        IF AVAIL nota-fiscal THEN
            /*Seta processo anterior, onde estava a nota para buscar a proces-embal-volum*/
            
            IF nota-fiscal.nr-proc-exp = processo-exp.nr-proc-exp THEN
                ASSIGN c-nr-proc-exp = bf-processo-exp-sub.nr-proc-exp
                       c-cod-estabel = bf-processo-exp-sub.cod-estabel.
            ELSE
                ASSIGN c-nr-proc-exp = processo-exp.nr-proc-exp
                       c-cod-estabel = processo-exp.cod-estabel.

            FOR EACH it-nota-fisc NO-LOCK
               WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                 AND it-nota-fisc.serie = nota-fiscal.serie
                 AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis:

                ASSIGN de-qtd-embal = 0.
                IF CAN-FIND(FIRST proces-embal-volum
                            WHERE proces-embal-volum.cod-estabel     = c-cod-estabel
                              AND proces-embal-volum.nr-proc-exp     = c-nr-proc-exp
                              AND proces-embal-volum.nome-abrev      = it-nota-fisc.nome-ab-cli 
                              AND proces-embal-volum.nr-pedcli       = it-nota-fisc.nr-pedcli  
                              AND proces-embal-volum.nr-sequencia    = it-nota-fisc.nr-seq-ped 
                              AND proces-embal-volum.it-codigo       = it-nota-fisc.it-codigo     
                              AND proces-embal-volum.cod-refer       = it-nota-fisc.cod-refer    
                              AND proces-embal-volum.nr-entrega      = it-nota-fisc.nr-entrega) THEN DO:

                    FOR EACH proces-embal-volum NO-LOCK
                       WHERE proces-embal-volum.cod-estabel     = c-cod-estabel          
                         AND proces-embal-volum.nr-proc-exp     = c-nr-proc-exp          
                         AND proces-embal-volum.nome-abrev      = it-nota-fisc.nome-ab-cli 
                         AND proces-embal-volum.nr-pedcli       = it-nota-fisc.nr-pedcli   
                         AND proces-embal-volum.nr-sequencia    = it-nota-fisc.nr-seq-ped 
                         AND proces-embal-volum.it-codigo       = it-nota-fisc.it-codigo   
                         AND proces-embal-volum.cod-refer       = it-nota-fisc.cod-refer   
                         AND proces-embal-volum.nr-entrega      = it-nota-fisc.nr-entrega
                         BREAK BY proces-embal-volum.num-volum-acond:
                        
                        ASSIGN de-qtd-embal = de-qtd-embal + proces-embal-volum.qtd-embal.
                    END.
        
                    IF it-nota-fisc.qt-faturada[1] < de-qtd-embal  THEN
                        ASSIGN de-qtd-embal = it-nota-fisc.qt-faturada[1]
                               de-qt-embalar = 0.
                    ELSE
                        ASSIGN de-qt-embalar = it-nota-fisc.qt-faturada[1] - de-qtd-embal.

        
                    IF de-qtd-embal > 0 THEN DO: 
                        CREATE tt-itens-proc-exp.
                        ASSIGN tt-itens-proc-exp.cod-estabel  = c-cod-estabel
                               tt-itens-proc-exp.nr-proc-exp  = c-nr-proc-exp
                               tt-itens-proc-exp.nr-sequencia = it-nota-fisc.nr-seq-ped 
                               tt-itens-proc-exp.it-codigo    = it-nota-fisc.it-codigo    
                               tt-itens-proc-exp.cod-refer    = it-nota-fisc.cod-refer   
                               tt-itens-proc-exp.quantidade   = it-nota-fisc.qt-faturada[1]
                               tt-itens-proc-exp.qtd-embal    = de-qtd-embal
                               tt-itens-proc-exp.qt-embalar   = de-qt-embalar
                               tt-itens-proc-exp.nome-abrev   = it-nota-fisc.nome-ab-cli
                               tt-itens-proc-exp.nr-pedcli    = it-nota-fisc.nr-pedcli
                               tt-itens-proc-exp.nr-entrega   = it-nota-fisc.nr-entrega.
                    END. 
                END.
            END.
    END.
    ELSE DO: /*Se embarque*/
        FIND FIRST embarque 
             WHERE embarque.cdd-embarq = pd-embarque NO-LOCK NO-ERROR.
        /*Seta processo anterior, onde estava o embarque, para buscar a proces-embal-volum*/
        IF embarque.nr-proc-exp = processo-exp.nr-proc-exp THEN
            ASSIGN c-nr-proc-exp = bf-processo-exp-sub.nr-proc-exp
                   c-cod-estabel = bf-processo-exp-sub.cod-estabel.
        ELSE
            ASSIGN c-nr-proc-exp = processo-exp.nr-proc-exp
                   c-cod-estabel = processo-exp.cod-estabel.

        FOR EACH it-pre-fat NO-LOCK
           WHERE it-pre-fat.cdd-embarq = embarque.cdd-embarq:
            ASSIGN de-qtd-embal = 0.
            IF CAN-FIND(FIRST proces-embal-volum
                        WHERE proces-embal-volum.cod-estabel     = c-cod-estabel
                          AND proces-embal-volum.nr-proc-exp     = c-nr-proc-exp
                          AND proces-embal-volum.nome-abrev      = it-pre-fat.nome-abrev   
                          AND proces-embal-volum.nr-pedcli       = it-pre-fat.nr-pedcli     
                          AND proces-embal-volum.nr-sequencia    = it-pre-fat.nr-sequencia 
                          AND proces-embal-volum.it-codigo       = it-pre-fat.it-codigo     
                          AND proces-embal-volum.cod-refer       = it-pre-fat.cod-refer    
                          AND proces-embal-volum.nr-entrega      = it-pre-fat.nr-entrega) THEN DO:
                FOR EACH proces-embal-volum NO-LOCK
                   WHERE proces-embal-volum.cod-estabel     = c-cod-estabel          
                     AND proces-embal-volum.nr-proc-exp     = c-nr-proc-exp          
                     AND proces-embal-volum.nome-abrev      = it-pre-fat.nome-abrev   
                     AND proces-embal-volum.nr-pedcli       = it-pre-fat.nr-pedcli      
                     AND proces-embal-volum.nr-sequencia    = it-pre-fat.nr-sequencia 
                     AND proces-embal-volum.it-codigo       = it-pre-fat.it-codigo   
                     AND proces-embal-volum.cod-refer       = it-pre-fat.cod-refer   
                     AND proces-embal-volum.nr-entrega      = it-pre-fat.nr-entrega
                     BREAK BY proces-embal-volum.num-volum-acond:
                    
                    ASSIGN de-qtd-embal = de-qtd-embal + proces-embal-volum.qtd-embal.
                END.
                IF it-pre-fat.qt-alocada < de-qtd-embal  THEN
                    ASSIGN de-qtd-embal = it-pre-fat.qt-alocada
                           de-qt-embalar = 0.
                ELSE
                    ASSIGN de-qt-embalar = it-pre-fat.qt-alocada - de-qtd-embal.
    
                IF de-qtd-embal > 0 THEN DO: 
                    CREATE tt-itens-proc-exp.
                    ASSIGN tt-itens-proc-exp.cod-estabel  = c-cod-estabel
                           tt-itens-proc-exp.nr-proc-exp  = c-nr-proc-exp
                           tt-itens-proc-exp.nr-sequencia = it-pre-fat.nr-sequencia 
                           tt-itens-proc-exp.it-codigo    = it-pre-fat.it-codigo    
                           tt-itens-proc-exp.cod-refer    = it-pre-fat.cod-refer   
                           tt-itens-proc-exp.quantidade   = it-pre-fat.qt-alocada
                           tt-itens-proc-exp.qtd-embal    = de-qtd-embal
                           tt-itens-proc-exp.qt-embalar   = de-qt-embalar
                           tt-itens-proc-exp.nome-abrev   = it-pre-fat.nome-abrev  
                           tt-itens-proc-exp.nr-pedcli    = it-pre-fat.nr-pedcli
                           tt-itens-proc-exp.nr-entrega   = it-pre-fat.nr-entrega.
                END. 
            END.
        END.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
