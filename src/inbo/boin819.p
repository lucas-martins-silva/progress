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
{include/i-prgvrs.i BOIN819 2.00.00.005 } /*** "010005" 25/10/2023 14:45:49  ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN819
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fda-lote-avancad
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
{inbo/boin819.i RowObject}
{inbo/boin819.i tt-fda-lote-avancad}
{cdp/cd0666.i}  /* Definicao da temp-table de erro                */

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

DEFINE NEW GLOBAL SHARED VARIABLE hbTT       AS HANDLE NO-UNDO.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-lote like fda-lote-avancad.nr-lote no-undo.
DEFINE VARIABLE hTable       AS HANDLE      NO-UNDO.

def temp-table tt-lote no-undo
    field nr-lote like fda-lote-avancad.nr-lote
    index id nr-lote.

DEFINE TEMP-TABLE tt-fda-lote-avancad-aux NO-UNDO LIKE fda-lote-avancad.

/********Temp-table utilizadas no Metadados***********/
define temp-table ttAlteraSituacaoLote NO-UNDO
	    field codEstabel as character
	    field itCodigo   as character    
   	    field nrLote     as character
        field cStatus    as CHARACTER.
		
define temp-table ttReturnAlteraSituacaoLote NO-UNDO like ttAlteraSituacaoLote.

def temp-table ttErro NO-UNDO
    field i-sequen as int             
    field cd-erro  as int
    field mensagem as char.

def temp-table tt-fda-lote-avancad-aux2 no-undo like fda-lote-avancad
    field i-tipo-estado-inicial as int
    field r-rowid               as rowid
    field i-seq                 as integer
    field nr-trans              like movto-estoq.nr-trans
    field l-atualizado          as log.

def temp-table tt-fda-lote-histor-aux2 no-undo like fda-lote-histor
    field l-atualizado as log
    field r-rowid      as rowid
    field i-seq        as integer.


/****************************************************/

DEFINE TEMP-TABLE tt-saldo-estoq NO-UNDO LIKE saldo-estoq
    FIELD isSelected AS LOG
    FIELD fm-codigo LIKE ITEM.fm-codigo
    FIELD r-Rowid AS ROWID.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaLotes DBOProgram 
PROCEDURE carregaLotes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param table for tt-lote.

for each fda-lote-avancad:

    if not can-find(first tt-lote where tt-lote.nr-lote = fda-lote-avancad.nr-lote) then do:
        create tt-lote.
        assign tt-lote.nr-lote = fda-lote-avancad.nr-lote.
    end.

end.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDataValidade DBOProgram 
PROCEDURE atualizaDataValidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-dt-validade AS DATE NO-UNDO.
    DEFINE INPUT PARAMETER p-rowid-fla   AS ROWID NO-UNDO.

    FIND FIRST fda-lote-avancad WHERE ROWID(fda-lote-avancad) = p-rowid-fla EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL fda-lote-avancad THEN
        ASSIGN fda-lote-avancad.dt-validade = p-dt-validade.

    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaSaldoEstoq DBOProgram 
PROCEDURE carregaSaldoEstoq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER TABLE FOR tt-fda-lote-avancad-aux.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-saldo-estoq.

    /*FAZER for each saldo estoq somento por lote. eliminar finds lote-avancad*/

    EMPTY TEMP-TABLE tt-saldo-estoq.

    FOR EACH saldo-estoq NO-LOCK
       WHERE saldo-estoq.lote = fda-lote-avancad.nr-lote:

        RUN criaTTSaldoEstoq.

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTSaldoEstoq DBOProgram 
PROCEDURE criaTTSaldoEstoq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  NOT AVAIL ITEM THEN
        FIND FIRST ITEM WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.
                                     
    CREATE tt-saldo-estoq.
    BUFFER-COPY saldo-estoq TO tt-saldo-estoq
    ASSIGN tt-saldo-estoq.r-rowid = ROWID(saldo-estoq)
           tt-saldo-estoq.fm-codigo = ITEM.fm-codigo.

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
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-lote-fabrican":U THEN ASSIGN pFieldValue = RowObject.cod-lote-fabrican.
        WHEN "cod-lote-ser":U THEN ASSIGN pFieldValue = RowObject.cod-lote-ser.
        WHEN "cod-lote-ser-dest":U THEN ASSIGN pFieldValue = RowObject.cod-lote-ser-dest.
        WHEN "cod-status":U THEN ASSIGN pFieldValue = RowObject.cod-status.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nr-lote":U THEN ASSIGN pFieldValue = RowObject.nr-lote.
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
        WHEN "dat-valid-lote-fabrican":U THEN ASSIGN pFieldValue = RowObject.dat-valid-lote-fabrican.
        WHEN "dt-fabric":U THEN ASSIGN pFieldValue = RowObject.dt-fabric.
        WHEN "dt-validade":U THEN ASSIGN pFieldValue = RowObject.dt-validade.
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
  Purpose:     Retorna valores dos campos do °ndice id
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo fm-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo nr-lote
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE fda-lote-avancad.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pfm-codigo LIKE fda-lote-avancad.fm-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE fda-lote-avancad.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-lote LIKE fda-lote-avancad.nr-lote NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pfm-codigo = RowObject.fm-codigo
           pcod-estabel = RowObject.cod-estabel
           pnr-lote = RowObject.nr-lote.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getNextLote DBOProgram 
PROCEDURE getNextLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-lote as char no-undo.

find next {&tableName} where {&tableName}.nr-lote <> c-lote no-lock no-error.
if avail {&tableName} then
    run repositionRecord (input rowid({&tableName})).
else
    return "nok":u.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPrevLote DBOProgram 
PROCEDURE getPrevLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param c-lote as char no-undo.

find prev {&tableName} where {&tableName}.nr-lote <> c-lote no-lock no-error.
if avail {&tableName} then
    run repositionRecord (input rowid({&tableName})).
else
    return "nok":u.

return "ok":u.
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
  Purpose:     Reposiciona registro com base no °ndice id
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo fm-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo nr-lote
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE fda-lote-avancad.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pfm-codigo LIKE fda-lote-avancad.fm-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE fda-lote-avancad.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-lote LIKE fda-lote-avancad.nr-lote NO-UNDO.

    FIND FIRST bffda-lote-avancad WHERE 
        bffda-lote-avancad.it-codigo   = pit-codigo AND 
        bffda-lote-avancad.fm-codigo   = pfm-codigo AND 
        bffda-lote-avancad.cod-estabel = pcod-estabel and
        bffda-lote-avancad.nr-lote     = pnr-lote NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffda-lote-avancad THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffda-lote-avancad)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryLote DBOProgram 
PROCEDURE openQueryLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
        where {&TableName}.nr-lote = c-lote.                                                

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
   OPEN QUERY {&QueryName} FOR EACH {&TableName} no-lock by {&TableName}.nr-lote.
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaLoteAvancado DBOProgram 
PROCEDURE retornaLoteAvancado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param table for tt-fda-lote-avancad.

    empty temp-table tt-fda-lote-avancad.

    for each bf{&TableName} where bf{&TableName}.nr-lote = c-lote no-lock:

        create tt-fda-lote-avancad.
        buffer-copy bf{&TableName} to tt-fda-lote-avancad.

    end.

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintLote DBOProgram 
PROCEDURE setConstraintLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input param p-lote like fda-lote-avancad.nr-lote no-undo.

   assign c-lote = p-lote.

   return "ok":u.
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

/******MÇtodos Utilizados nas telas de Metadados**********************************/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loteAvancadoPorItemLote DBOProgram 
PROCEDURE loteAvancadoPorItemLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pc-lote LIKE fda-lote-avancad.nr-lote no-undo.
def input param pc-item LIKE fda-lote-avancad.it-codigo no-undo.
DEF INPUT PARAM i-pageSize       AS INTEGER NO-UNDO.
DEF INPUT PARAM i-current-page   AS INTEGER NO-UNDO.
DEF OUTPUT PARAM i-totRecords    AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR ttAlteraSituacaoLote.
 
   blockLoteAvancadoPorItemLote:
    DO  ON ERROR undo blockLoteAvancadoPorItemLote, LEAVE blockLoteAvancadoPorItemLote 
        ON STOP  undo blockLoteAvancadoPorItemLote, LEAVE blockLoteAvancadoPorItemLote
        ON QUIT  undo blockLoteAvancadoPorItemLote, LEAVE blockLoteAvancadoPorItemLote:   	
  
		empty temp-table ttAlteraSituacaoLote.
		if can-find(first bf{&TableName} 
					where bf{&TableName}.nr-lote   = pc-lote 
					  and bf{&TableName}.it-codigo = pc-item) then do:
			for each bf{&TableName} 
			   where bf{&TableName}.nr-lote   = pc-lote 
				 and bf{&TableName}.it-codigo = pc-item no-lock:

				create ttAlteraSituacaoLote.
                ASSIGN ttAlteraSituacaoLote.itCodigo   = bf{&TableName}.it-codigo
                       ttAlteraSituacaoLote.codEstabel = bf{&TableName}.cod-estabel
                       ttAlteraSituacaoLote.nrLote     = bf{&TableName}.nr-lote.
                FOR FIRST fda-lote-estado 
                    WHERE fda-lote-estado.cod-status = bf{&TableName}.cod-status NO-LOCK:
                    ASSIGN ttAlteraSituacaoLote.cStatus = fda-lote-estado.cod-status + " - " + fda-lote-estado.des-estado-lote.
                END.
			end.
		end.
	END.

    ASSIGN hTable = BUFFER ttAlteraSituacaoLote:HANDLE.
    RUN populaTempTable(INPUT i-pageSize, INPUT "ttAlteraSituacaoLote", OUTPUT i-totRecords).
	run retornaRegistrosLoteAvancado (input i-current-page, output table ttAlteraSituacaoLote).
return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alteraSituacaoLoteManual DBOProgram 
PROCEDURE alteraSituacaoLoteManual:
    DEFINE INPUT  PARAM pcCodStatus AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM plPropaga   AS Logical NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR ttAlteraSituacaoLote.
    DEFINE OUTPUT PARAM TABLE FOR ttErro.

    DEFINE VARIABLE h-ceapi028 AS HANDLE NO-UNDO.
    RUN cep/ceapi028.p PERSISTENT SET h-ceapi028 (INPUT TABLE tt-fda-lote-avancad-aux2,
                                                  INPUT TABLE tt-fda-lote-histor-aux2,
                                                  INPUT 51,
                                                  INPUT "Alteraá∆o Manual Situaá∆o do Lote",
                                                  OUTPUT TABLE tt-erro).

    FOR EACH ttAlteraSituacaoLote:
    
        RUN pi-atualiza-estado IN h-ceapi028(INPUT ttAlteraSituacaoLote.itCodigo,
                                             INPUT ttAlteraSituacaoLote.codEstabel,
                                             INPUT ttAlteraSituacaoLote.nrLote,
                                             INPUT 0,
                                             INPUT pcCodStatus,
                                             INPUT YES,
                                             INPUT plPropaga,
                                             INPUT 51,
                                             INPUT "Alteraá∆o Manual Situaá∆o do Lote",
                                             OUTPUT TABLE tt-erro).
        empty temp-table ttAlteraSituacaoLote.
        IF CAN-FIND (FIRST tt-erro) THEN DO:
            FOR EACH tt-erro:
                CREATE ttErro.
                BUFFER-COPY tt-erro TO ttErro NO-ERROR.
            END.
            RETURN "NOK":U.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*  ------------------------- Padr∆o METADADOS -------------------------
  Procedure respons†vel por popular a temp-table com todos os registros, separadas por p†ginas.
*/
PROCEDURE populaTempTable:
    
    /*N£mero de registros mostrados por p†ginas no grid (Paginaá∆o)*/
    DEFINE INPUT PARAM pageSize      AS INTEGER.
    DEFINE INPUT PARAM c-ttTableName AS CHARACTER.
    DEFINE OUTPUT PARAM totalRecords AS INTEGER.

    
    DEFINE VARIABLE hTT         AS HANDLE NO-UNDO.
    DEFINE VARIABLE qhTable     AS HANDLE NO-UNDO.
    DEFINE VARIABLE hField      AS HANDLE NO-UNDO.
    DEFINE VARIABLE cont        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iCount      AS INTEGER     NO-UNDO.
    
    /*Criada Temp-table com a mesma estrutura do buffer de registros, adicionando uma nova coluna do tipo INTEIRO*/
    CREATE TEMP-TABLE hTT.
    hTT:CREATE-LIKE(hTable).
    hTT:ADD-NEW-FIELD("numPag", "INT").
    hTT:TEMP-TABLE-PREPARE("ttPag").
    hbTT = hTT:DEFAULT-BUFFER-HANDLE.
    
    /*Atualizar a temp-table recÇm criada com os dados do buffer de registros, atualizando a nova coluna com o n£mero da p†gina que conter† o registro.*/
    CREATE QUERY qhTable.
    qhTable:SET-BUFFERS(hTable).
    qhTable:QUERY-PREPARE("PRESELECT EACH " + c-ttTableName + " INDEXED-REPOSITION").
    qhTable:QUERY-OPEN().

    /*Total de registros contido na tabela*/
    ASSIGN totalRecords = qhTable:NUM-RESULTS.
    
    ASSIGN cont = 0.
    IF qhTable:NUM-RESULTS > 0 THEN DO:
        ASSIGN cont = 1.
        REPEAT:
          qhTable:GET-NEXT().
          IF qhTable:QUERY-OFF-END THEN LEAVE.
    
          hbTT:BUFFER-CREATE().
          hbTT:BUFFER-COPY(hTable).
          IF iCount >= pageSize THEN DO:
            ASSIGN cont = cont + 1.
            ASSIGN iCount = 0.
          END.                
          ASSIGN hField = hbTT:BUFFER-FIELD('numPag')
                 hField:BUFFER-VALUE = cont.
          hbTT:BUFFER-RELEASE().
          ASSIGN iCount = iCount + 1.
        END.
    END.
    qhTable:QUERY-CLOSE().

    IF VALID-HANDLE(qhTable) THEN
        DELETE OBJECT qhTable.
    IF VALID-HANDLE(hTable) THEN
        DELETE OBJECT hTable.
    IF VALID-HANDLE(hField) THEN
        DELETE OBJECT hField.

END PROCEDURE.


PROCEDURE retornaRegistrosLoteAvancado:
   /* MESSAGE '----------------------retornaRegistrosdocumentosMovimentacao----------------------------'.*/
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE OUTPUT PARAM TABLE FOR ttReturnAlteraSituacaoLote.
   
    DEFINE VARIABLE hTTReturn  AS HANDLE NO-UNDO. 
    DEFINE VARIABLE hbTTReturn AS HANDLE NO-UNDO. 

    ASSIGN hTTReturn = TEMP-TABLE ttReturnAlteraSituacaoLote:HANDLE.
    hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistros(INPUT currentPage, INPUT hbTTReturn, INPUT hTTReturn ).
END PROCEDURE.

/*  ------------------------- Padr∆o METADADOS -------------------------
  PROCEDURE RESPONSµVEL POR RETORNAR OS REGISTROS DA PµGINA ATUAL, OU SEJA, OS REGISTROS PAGINADOS. 
  (USADOS NAS GRIDS COM PAGINACAO)
*/
PROCEDURE retornaRegistros:
    /*P†gina atual do grid*/
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE INPUT PARAM phbTTReturn    AS HANDLE.
    DEFINE INPUT PARAM phTTReturn     AS HANDLE.
    
    
    /*Retorna a temp-table com os registros paginados*/
    /*DEFINE OUTPUT PARAM TABLE FOR ttReturn. -- passado para o metodo que faz a chamada*/
    
    DEFINE VARIABLE hTT        AS HANDLE NO-UNDO.
    DEFINE VARIABLE qhTemp     AS HANDLE NO-UNDO.

    /* Mostrar resultado */
		CREATE QUERY qhTemp.
		qhTemp:SET-BUFFERS(hbTT).
		qhTemp:QUERY-PREPARE("PRESELECT EACH ttPag where numPag = " + STRING(currentPage) + " INDEXED-REPOSITION").
		qhTemp:QUERY-OPEN().
		if valid-handle(qhTemp) and valid-handle(hbTT) then do:
			REPEAT:
				qhTemp:GET-NEXT(). 
				IF qhTemp:QUERY-OFF-END THEN LEAVE.
			
				phbTTReturn:BUFFER-CREATE().
				phbTTReturn:BUFFER-COPY(hbTT).
				phbTTReturn:BUFFER-RELEASE().
			END.
			qhTemp:QUERY-CLOSE().
		end.

 
    IF VALID-HANDLE(qhTemp) THEN
        DELETE OBJECT qhTemp.
    IF VALID-HANDLE(hTT) THEN
        DELETE OBJECT hTT.
    IF VALID-HANDLE(phTTReturn) THEN
        DELETE OBJECT phTTReturn.
    IF VALID-HANDLE(phbTTReturn) THEN
        DELETE OBJECT phbTTReturn.

END PROCEDURE.
