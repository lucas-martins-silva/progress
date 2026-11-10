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
{include/i-prgvrs.i BOIN822 2.00.00.002 } /*** "010002" 25/10/2023 14:45:49  ***/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN822
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName fda-lote-histor
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

/*:T Pre-processadores necess†rios para utilizar o DBO no MetaDados*/                                        
&GLOBAL-DEFINE KeyField1             cod-lote-ser /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE KeyField2             num-serie /*:T Informar os campos da chave da tabela, quando o Progress n∆o conseguir resolver find {&TableName} OF RowObject.*/
&GLOBAL-DEFINE XMLReceiver           YES           /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message)*/
/* &GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES */          

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
{inbo/boin822.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}



/**********DEFINIÄÂES DA TELA DE ANµLISE DO LOTE **************/
DEFINE TEMP-TABLE ttHistorico NO-UNDO
    FIELD itCodigo AS CHARACTER
    FIELD nrLote   AS CHARACTER
    FIELD usuario  AS CHARACTER
    FIELD data AS CHARACTER
    FIELD hora AS CHARACTER 
    FIELD estado AS CHARACTER
    FIELD descricao as character.

DEFINE TEMP-TABLE ttRoteiros NO-UNDO
    FIELD nrFicha AS INTEGER LABEL "Roteiro"
    FIELD situacao AS character LABEL "Situaá∆o"
    FIELD loteAmostra AS CHARACTER LABEL "Lote Amostra".

DEFINE BUFFER bf-fda-lote-avancad FOR fda-lote-avancad.
DEFINE BUFFER bf-ficha-cq         FOR ficha-cq.

/**********FIM - DEFINIÄÂES DA TELA DE ANµLISE DO LOTE **********/


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
         HEIGHT             = 11.58
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
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
        WHEN "cod-lote-ser":U THEN ASSIGN pFieldValue = RowObject.cod-lote-ser.
        WHEN "cod-lote-ser-dest":U THEN ASSIGN pFieldValue = RowObject.cod-lote-ser-dest.
        WHEN "cod-status":U THEN ASSIGN pFieldValue = RowObject.cod-status.
        WHEN "des-alter[1]":U THEN ASSIGN pFieldValue = RowObject.des-alter[1].
        WHEN "des-alter[2]":U THEN ASSIGN pFieldValue = RowObject.des-alter[2].
        WHEN "des-alter[3]":U THEN ASSIGN pFieldValue = RowObject.des-alter[3].
        WHEN "des-alter[4]":U THEN ASSIGN pFieldValue = RowObject.des-alter[4].
        WHEN "des-alter[5]":U THEN ASSIGN pFieldValue = RowObject.des-alter[5].
        WHEN "des-alter[6]":U THEN ASSIGN pFieldValue = RowObject.des-alter[6].
        WHEN "des-alter[7]":U THEN ASSIGN pFieldValue = RowObject.des-alter[7].
        WHEN "des-alter[8]":U THEN ASSIGN pFieldValue = RowObject.des-alter[8].
        WHEN "des-alter[9]":U THEN ASSIGN pFieldValue = RowObject.des-alter[9].
        WHEN "des-alter[10]":U THEN ASSIGN pFieldValue = RowObject.des-alter[10].
        WHEN "hra-alter":U THEN ASSIGN pFieldValue = RowObject.hra-alter.
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
        WHEN "dat-alter":U THEN ASSIGN pFieldValue = RowObject.dat-alter.
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
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "num-livre-1":U THEN ASSIGN pFieldValue = RowObject.num-livre-1.
        WHEN "num-livre-2":U THEN ASSIGN pFieldValue = RowObject.num-livre-2.
        WHEN "num-serie":U THEN ASSIGN pFieldValue = RowObject.num-serie.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram  
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice lthstr-id
  Parameters:  
               retorna valor do campo cod-lote-ser
               retorna valor do campo num-serie
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-lote-ser LIKE fda-lote-histor.cod-lote-ser NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-serie LIKE fda-lote-histor.num-serie NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-lote-ser = RowObject.cod-lote-ser
           pnum-serie = RowObject.num-serie.

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
  Purpose:     Reposiciona registro com base no °ndice lthstr-id
  Parameters:  
               recebe valor do campo cod-lote-ser
               recebe valor do campo num-serie
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-lote-ser LIKE fda-lote-histor.cod-lote-ser NO-UNDO.
    DEFINE INPUT PARAMETER pnum-serie LIKE fda-lote-histor.num-serie NO-UNDO.

    FIND FIRST bffda-lote-histor WHERE 
        bffda-lote-histor.cod-lote-ser = pcod-lote-ser AND 
        bffda-lote-histor.num-serie = pnum-serie NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bffda-lote-histor THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bffda-lote-histor)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
/*:T------------------------------------------------------------------------------
  Purpose: Procedure obrigat¢ria para execuá∆o via MetaDados
  Parameters:  <none>
  Notes: Para execuá∆o do DBO via Metadados Ç necess†rio que o DBO utilize a Procedure openQueryDefault para abrir a query principal do DBO.
         Esta Procedure pode ser customizada conforme necessidade do usu†rio.
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDadosAnaliseLote DBOProgram 
PROCEDURE buscaDadosAnaliseLote :
/*:T------------------------------------------------------------------------------
  Purpose:     Buscar o £ltimo hist¢rico de movimentaá∆o e outros roteiros do lote 
               com base em uma ficha cq
  Parameters:  n£mero da ficha cq (Roteiro de Inspeá∆o)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pi-nr-ficha AS INTEGER NO-UNDO.
    define output parameter TABLE FOR ttHistorico.
    define output parameter TABLE FOR ttRoteiros.
    define output parameter TABLE FOR RowErrors.

    DEFINE VARIABLE c-cod-lote-ser AS CHARACTER NO-UNDO.

    FIND FIRST ficha-cq WHERE ficha-cq.nr-ficha = pi-nr-ficha NO-LOCK NO-ERROR.
    IF AVAIL ficha-cq THEN DO:
        FOR FIRST fda-lote-avancad 
            WHERE fda-lote-avancad.it-codigo = ficha-cq.it-codigo 
              AND fda-lote-avancad.nr-lote   = ficha-cq.lote
              AND fda-lote-avancad.cod-estabel = ficha-cq.cod-estabel NO-LOCK:
            /*se for amostra busca informaá‰es do lote pai*/
            IF fda-lote-avancad.cod-lote-ser-dest <> "" THEN DO:
                FOR FIRST bf-fda-lote-avancad 
                    WHERE bf-fda-lote-avancad.cod-lote-ser = fda-lote-avancad.cod-lote-ser-dest NO-LOCK:
                    ASSIGN c-cod-lote-ser = bf-fda-lote-avancad.cod-lote-ser.
                END.
            END.
            ELSE
                ASSIGN c-cod-lote-ser = fda-lote-avancad.cod-lote-ser.
        END.
/*Consulta £ltimo hist¢rico do lote*/
        FIND LAST fda-lote-histor 
            WHERE fda-lote-histor.cod-lote-ser = c-cod-lote-ser NO-LOCK NO-ERROR.
        IF AVAIL fda-lote-histor THEN DO:
            CREATE ttHistorico.
            ASSIGN ttHistorico.itCodigo  = ficha-cq.it-codigo
                   ttHistorico.nrLote    = ficha-cq.lote
                   ttHistorico.data      = string(fda-lote-histor.dat-alter)
                   ttHistorico.hora      = string(fda-lote-histor.hra-alter)
                   ttHistorico.descricao = fda-lote-histor.des-alter[1].


            /* IMPORTANTE: N∆o Ç necess†rio incluir o preprocess abaixo, porÇm deve-se lembrar que para a release 11.5.6 o 
               usu†rio dever† ser buscado do campo livre cod-livre-1 e para a vers∆o 12 dever† ser buscado do campo novo FDA-lote-histor.usuar-alter */

                /*&IF "{&bf_mat_versao_ems}" < "2.09" &then*/
                    assign ttHistorico.usuario = substring(fda-lote-histor.cod-livre-1,1,12).
                /*&else 
                    assign ttHistorico.usuario = fda-lote-histor.usuar-alter.
                &ENDIF.*/

            FOR FIRST fda-lote-estado 
                WHERE fda-lote-estado.cod-status = fda-lote-histor.cod-status NO-LOCK:
                ASSIGN ttHistorico.estado = fda-lote-estado.cod-status + " - " + fda-lote-estado.des-estado-lote.
            END.
        END.

        /*Pesquisa todos os sub-lotes do lote origem e verifica se tem outros roteiros*/
        FOR EACH fda-lote-avancad WHERE fda-lote-avancad.cod-lote-ser-dest = c-cod-lote-ser NO-LOCK:
            FOR FIRST bf-ficha-cq 
                WHERE bf-ficha-cq.it-codigo = fda-lote-avancad.it-codigo 
                  AND bf-ficha-cq.lote = fda-lote-avancad.nr-lote 
                  AND bf-ficha-cq.nr-ficha <> ficha-cq.nr-ficha NO-LOCK:
                
                CREATE ttRoteiros.
                ASSIGN ttRoteiros.nrFicha = bf-ficha-cq.nr-ficha
                       ttRoteiros.situacao = {ininc/i03in124.i 04 bf-ficha-cq.situacao}
                       ttRoteiros.loteAmostra = bf-ficha-cq.lote.
            END.
        END.

    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.
