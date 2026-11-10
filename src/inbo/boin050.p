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
{include/i-prgvrs.i BOIN050 2.00.01.005 } /*** "010105" 25/10/2023 14:45:47  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN050 MUT}
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
&GLOBAL-DEFINE DBOName BOIN050
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName comp-exame
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

{cdp/cdcfgmat.i}

&GLOBAL-DEFINE KeyField1 cod-exame /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2 cod-comp /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
	&GLOBAL-DEFINE KeyField3 cdn-versao /*:T Informar os campos da chave quando o Progress nío conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m≤todo Receive Message) */
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

*/
/* DBO-XML-END */

/*:T--- Include com definiá∆o da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin050.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
DEFINE NEW GLOBAL SHARED VARIABLE hbTT       AS HANDLE NO-UNDO.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE VARIABLE hTable       AS HANDLE      NO-UNDO.

/* Definiá∆o TEMP-TABLE tt-compExameReturn, utilizada na procedure pi-returnCompByExame */
DEFINE TEMP-TABLE tt-comp NO-UNDO
    FIELD codComp  AS INTEGER.   

DEFINE TEMP-TABLE tt-compExameReturn NO-UNDO
    FIELD codComp  AS INTEGER LABEL "Componente".  

DEFINE TEMP-TABLE tt-todosComp NO-UNDO
    FIELD codComp AS INT.

DEFINE TEMP-TABLE tt-todosCompAux NO-UNDO LIKE tt-todosComp.

DEFINE TEMP-TABLE tt-returnCompPag NO-UNDO
    FIELD codComp  AS INTEGER LABEL "Componente" 
    FIELD descricao AS CHARACTER LABEL "Descriá∆o".

DEFINE TEMP-TABLE tt-exames NO-UNDO
    FIELD codExame  AS INTEGER LABEL "Exame".

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
         HEIGHT             = 13.33
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose: 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*FOR FIRST exame
        WHERE exame.cod-exame    = RowObject.cod-exame
        AND   exame.cdn-sit-vers = RowObject.int-1 NO-LOCK:

        ASSIGN RowObject.int-1 = exame.cdn-versao.

    END.*/

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaSitVersao DBOProgram 
PROCEDURE buscaSitVersao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER codExame             AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER cdnVersao            AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER isSituacaoPendente   AS LOGICAL NO-UNDO.

FOR FIRST exame
        WHERE exame.cod-exame = codExame
        AND   exame.cdn-versao = cdnVersao NO-LOCK:

        IF exame.cdn-sit-vers = 1 THEN DO:
                ASSIGN isSituacaoPendente = TRUE.
        END.
        ELSE DO:
                ASSIGN isSituacaoPendente = FALSE.
        END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copiaCompExame DBOProgram 
PROCEDURE copiaCompExame :
/*------------------------------------------------------------------------------
  Purpose: Procedure que realiza a c¢pia dos componentes para v†rios exames    
  Parameters: Recebe iCodExameOrigem com o c¢digo do exame de origem
              Recebe tt-comp com o c¢digo dos componentes do exame origem.
              Recebe tt-exames com o c¢digo dos exames selecionados.
               
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-comp.
    DEFINE INPUT PARAMETER TABLE FOR tt-exames.
    DEFINE INPUT PARAM iCodExameOrigem AS INTEGER.

    DEFINE BUFFER bf-comp-exame FOR comp-exame.
    
   


    FOR EACH tt-comp:

        FIND FIRST comp-exame 
             WHERE comp-exame.cod-exame = iCodExameOrigem
               AND comp-exame.cod-comp = tt-comp.codComp NO-LOCK NO-ERROR.  
        IF AVAIL comp-exame THEN DO:

            FOR EACH tt-exames:

                FIND FIRST exame WHERE exame.cod-exame = tt-exames.codExame NO-LOCK NO-ERROR.
                IF AVAIL exame THEN DO:

                    IF NOT CAN-FIND(bf-comp-exame 
                          WHERE bf-comp-exame.cod-exame = exame.cod-exame 
                            AND bf-comp-exame.cod-comp = tt-comp.codcomp) THEN DO:

                            CREATE bf-comp-exame.
                            ASSIGN bf-comp-exame.cod-exame = exame.cod-exame.
                            BUFFER-COPY comp-exame EXCEPT cod-exame TO bf-comp-exame.

                    END.

                END.

            END.

        END.

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
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "compl-res":U THEN ASSIGN pFieldValue = RowObject.compl-res.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "inst-equip":U THEN ASSIGN pFieldValue = RowObject.inst-equip.
        WHEN "metodo":U THEN ASSIGN pFieldValue = RowObject.metodo.
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
        WHEN "refer-tec":U THEN ASSIGN pFieldValue = RowObject.refer-tec.
        WHEN "unidade":U THEN ASSIGN pFieldValue = RowObject.unidade.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "result-max":U THEN ASSIGN pFieldValue = RowObject.result-max.
        WHEN "result-min":U THEN ASSIGN pFieldValue = RowObject.result-min.
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
        WHEN "certificado":U THEN ASSIGN pFieldValue = RowObject.certificado.
        WHEN "cod-comp":U THEN ASSIGN pFieldValue = RowObject.cod-comp.
        WHEN "cod-exame":U THEN ASSIGN pFieldValue = RowObject.cod-exame.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "local-cq":U THEN ASSIGN pFieldValue = RowObject.local-cq.
        WHEN "nr-decimais":U THEN ASSIGN pFieldValue = RowObject.nr-decimais.
        WHEN "nr-horas":U THEN ASSIGN pFieldValue = RowObject.nr-horas.
        WHEN "nr-tabela":U THEN ASSIGN pFieldValue = RowObject.nr-tabela.
        WHEN "tipo-result":U THEN ASSIGN pFieldValue = RowObject.tipo-result.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-exame
               retorna valor do campo cod-comp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-exame LIKE comp-exame.cod-exame NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-comp LIKE comp-exame.cod-comp NO-UNDO.
		DEFINE OUTPUT PARAMETER pcdn-versao LIKE comp-exame.cdn-versao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-exame = RowObject.cod-exame
           pcod-comp = RowObject.cod-comp
           pcdn-versao = RowObject.cdn-versao.  
               

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
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-exame
               recebe valor do campo cod-comp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-exame LIKE comp-exame.cod-exame NO-UNDO.
    DEFINE INPUT PARAMETER pcod-comp LIKE comp-exame.cod-comp NO-UNDO.
    DEFINE INPUT PARAMETER pcdn-versao LIKE comp-exame.cdn-versao NO-UNDO.

	
    FIND FIRST bfcomp-exame WHERE 
            bfcomp-exame.cod-exame = pcod-exame AND 
            bfcomp-exame.cdn-versao = pcdn-versao AND
            bfcomp-exame.cod-comp = pcod-comp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfcomp-exame THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfcomp-exame)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDefault DBOProgram 
PROCEDURE openQueryDefault :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populaTempTable DBOProgram 
PROCEDURE populaTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /*N£mero de registros mostrados por p ginas no grid (Pagina?∆o)*/
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
    
    /*Atualizar a temp-table rec?m criada com os dados do buffer de registros, atualizando a nova coluna com o n£mero da p gina que conter  o registro.*/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistros DBOProgram 
PROCEDURE retornaRegistros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /*P gina atual do grid*/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaRegistrosCompExame DBOProgram 
PROCEDURE retornaRegistrosCompExame :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* MESSAGE '----------------------retornaRegistrosdocumentosMovimentacao----------------------------'.*/
    DEFINE INPUT PARAM currentPage   AS INTEGER.
    DEFINE OUTPUT PARAM TABLE FOR tt-compExameReturn.
   
    DEFINE VARIABLE hTTReturn  AS HANDLE NO-UNDO. 
    DEFINE VARIABLE hbTTReturn AS HANDLE NO-UNDO. 

    ASSIGN hTTReturn = TEMP-TABLE tt-compExameReturn:HANDLE.
    hbTTReturn = hTTReturn:DEFAULT-BUFFER-HANDLE.

    RUN retornaRegistros(INPUT currentPage, INPUT hbTTReturn, INPUT hTTReturn ).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnCompByExamDest DBOProgram 
PROCEDURE returnCompByExamDest :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAM i-codExame AS INTEGER.
DEFINE OUTPUT PARAMETER TABLE FOR tt-compExame.


 EMPTY TEMP-TABLE tt-compExame NO-ERROR.
  
FOR EACH exame WHERE cod-exame = i-codExame NO-LOCK:
    FOR EACH comp-exame WHERE comp-exame.cod-exame = exame.cod-exame  NO-LOCK:
        CREATE tt-compExame.
        ASSIGN tt-compExame.codComp   = comp-exame.cod-comp
               tt-compExame.descricao = comp-exame.descricao.               
    END.
END.

RETURN "OK":U.

END PROCEDURE.


*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnCompPag DBOProgram 
PROCEDURE returnCompPag :
/*------------------------------------------------------------------------------
  Purpose:  Retornar todos componentes .   
  Parameters:  <none> Recebe como parametro o c°digo do exame(pi-cod-exame) e
              retorna  a temp-table(tt-compExameReturn) com os componentes do exame.
  Notes: /* PROCEDURE CRIADA PARA TELA METADADOS */
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pi-current-page  AS INTEGER.
  DEFINE INPUT  PARAMETER pi-page-size     AS INTEGER.
  DEFINE INPUT  PARAMETER TABLE FOR tt-todosComp. 
  DEFINE INPUT  PARAMETER iCodExame     AS INTEGER.
  DEFINE OUTPUT PARAMETER pi-total-record  AS INTEGER.
  DEFINE OUTPUT PARAMETER TABLE FOR tt-returnCompPag.

  EMPTY TEMP-TABLE tt-returnCompPag NO-ERROR.
  ASSIGN hTable     = BUFFER tt-todosComp:HANDLE.
  RUN populaTempTable(INPUT pi-page-size, INPUT "tt-todosComp", OUTPUT pi-total-record).
  RUN retornaRegistrosCompExame(input pi-current-page, output table tt-todosComp).

  FOR EACH tt-todosComp:
     FOR EACH comp-exame FIELDS(cod-comp descricao) WHERE comp-exame.cod-exame = iCodExame AND comp-exame.cod-comp = tt-todosComp.codComp  NO-LOCK:
          CREATE tt-returnCompPag.
          ASSIGN tt-returnCompPag.codComp   = comp-exame.cod-comp
                 tt-returnCompPag.descricao = comp-exame.descricao.
      END.
  END.







  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTodosComp DBOProgram 
PROCEDURE returnTodosComp :
/*------------------------------------------------------------------------------
  Purpose: retorna todos os componentes do exame    
  Parameters:  <none>
  Notes:  Procedure criada pra a tela Metadados.     
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pi-codExame      AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-todosComp.

    FOR EACH comp-exame FIELDS(cod-comp) WHERE cod-exame = pi-codExame NO-LOCK:
        CREATE tt-todosComp.
        ASSIGN tt-todosComp.codComp = comp-exame.cod-comp.
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
	
	define variable l-lote-avancado as logical initial no no-undo.
	DEFINE VARIABLE c-aux-liter-1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-aux-liter-2 AS CHARACTER NO-UNDO.
	
	if can-find(first funcao where funcao.cd-funcao = "lote-avancado":u and
							   funcao.ativo) then
	assign l-lote-avancado = yes.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

	if  pType = "CREATE" then do:
		IF CAN-FIND(comp-exame WHERE comp-exame.cod-comp = RowObject.cod-comp 
					and comp-exame.cod-exame = RowObject.cod-exame and comp-exame.cdn-versao = RowObject.cdn-versao) THEN DO:
            {utp/ut-liter.i Componente_do_Exame}
            {method/svc/errors/inserr.i
               &ErrorNumber="7" 
               &ErrorType="EMS"
               &ErrorParameters=RETURN-VALUE}
        END.
	
	end.
	
	/* Esta validaá∆o ser† implementada no 1221-2 */	
	/*
    IF  pType = "CREATE" OR pType = "UPDATE" THEN DO:
      IF CAN-FIND(FIRST param-cq WHERE log-valid-eqpto-inspec = TRUE) THEN DO:
          IF NOT CAN-FIND(FIRST equipto WHERE cd-equipto = RowObject.inst-equip 
                                          AND situacao = 1) THEN DO:
                  {method/svc/errors/inserr.i
                           &ErrorNumber="35904" 
                           &ErrorType="EMS"}
          END.
      END.
    END. */
    
               
      if l-lote-avancado then do:		
        if pType = "DELETE":U then do :
            for first exame 
                    where exame.cod-exame = RowObject.cod-exame 
                    and exame.cdn-versao = RowObject.cdn-versao no-lock:
                    if exame.cdn-sit-vers = 2 or exame.cdn-sit-vers = 3 then do:
                       {utp/ut-liter.i Somente_versoes_pendentes_poderao_ser_eliminadas}
                       {method/svc/errors/inserr.i
                                    &ErrorNumber="17006"
                                    &ErrorType="EMS"
                                    &ErrorParameters=RETURN-VALUE}
                    end.
            end.            
       end.
            if can-find(FIRST res-fic-cq where
                    res-fic-cq.cod-exame = RowObject.cod-exame and
                    res-fic-cq.cod-comp  = RowObject.cod-comp) then do:                
                {utp/ut-liter.i comp-exame}
                ASSIGN c-aux-liter-1 = RETURN-VALUE.                    
                {utp/ut-liter.i res-fic-cq}
                ASSIGN c-aux-liter-2 = RETURN-VALUE.    
                {method/svc/errors/inserr.i
                            &ErrorNumber="5"
                            &ErrorType="EMS"
                            &ErrorParameters = c-aux-liter-1 ~~ c-aux-liter-2}
            end. 
        end.    
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


