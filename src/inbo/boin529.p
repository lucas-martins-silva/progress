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
{include/i-prgvrs.i BOIN529 2.00.00.013 } /*** "010013" 21/11/2023 17:01:03 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin529 MUT}
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
&GLOBAL-DEFINE DBOName BOMF529
&GLOBAL-DEFINE DBOVersion 2.0
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName man-progda-ctrab
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
{inbo/boin529.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE VARIABLE i-nr-ord-produ AS INTEGER INIT ? NO-UNDO.
DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INIT NO NO-UNDO.

{mfbo/bomf626.i tt-manut-progda-ctrab-mi}

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
         HEIGHT             = 18.46
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

{sfc/sf9002.i} /* pi-converte-data-segs-valor */

{inbo/boin530.i2} /* pi-sfc-reporte-tempo */

{sfc/sf9999.i}
ASSIGN l-mudancas-sfc = l-glob-novo-sfc.

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
RUN atualizaExtMI.

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
RUN atualizaExtMI.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDadosAuxiliares DBOProgram 
PROCEDURE atualizaDadosAuxiliares :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*Atualiza demais campos da parada programada*/
    run pi-converte-data-segs-valor (Input RowObject.dat-progda-inic,
                                     Input RowObject.qtd-segs-progda-inic,
                                     output RowObject.val-refer-inic-parada).

    run pi-converte-data-segs-valor (Input RowObject.dat-progda-fim,
                                     Input RowObject.qtd-segs-progda-fim,
                                     output RowObject.val-refer-fim-parada).

    run pi-sfc-reporte-tempo (input RowObject.cod-ctrab, 
                              input RowObject.dat-progda-fim,
                              input RowObject.qtd-segs-progda-fim,
                              input RowObject.dat-progda-inic,
                              input RowObject.qtd-segs-progda-inic,
                              output RowObject.qtd-tempo-maq,
                              output RowObject.qtd-tempo-ext,
                              output RowObject.cod-model-turno,
                              output RowObject.num-turno).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaExtMI DBOProgram 
PROCEDURE atualizaExtMI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF BUFFER bf-ord-manut FOR ord-manut.

    DEFINE VARIABLE h-bomf626 AS HANDLE     NO-UNDO.
    DEFINE VARIABLE l-modif AS LOGICAL  INIT NO  NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    IF i-nr-ord-produ <> ? AND param-global.modulo-mi AND l-mudancas-sfc AND AVAIL rowObject THEN DO:

        EMPTY TEMP-TABLE tt-manut-progda-ctrab-mi.

        RUN mfbo/bomf626.p PERSISTENT SET h-bomf626.

        RUN emptyRowErrors IN h-bomf626.
        EMPTY TEMP-TABLE RowErrors.

        RUN openQueryStatic IN h-bomf626 (INPUT "Main":U).

        RUN goToKey IN h-bomf626 (INPUT rowObject.cod-ctrab,
                                  INPUT rowObject.num-om-progda).

        IF RETURN-VALUE = "NOK":U THEN DO:
            CREATE tt-manut-progda-ctrab-mi.
            ASSIGN tt-manut-progda-ctrab-mi.cod-ctrab     = rowObject.cod-ctrab
                   tt-manut-progda-ctrab-mi.num-om-progda = rowObject.num-om-progda
                   l-modif = NO.
        END.
        ELSE DO:
            RUN getRecord IN h-bomf626(OUTPUT TABLE tt-manut-progda-ctrab-mi).
            FIND FIRST tt-manut-progda-ctrab-mi NO-ERROR.
            ASSIGN l-modif = YES.
        END.
       
        ASSIGN tt-manut-progda-ctrab-mi.num-ord-produc = i-nr-ord-produ.

        RUN setRecord IN h-bomf626(INPUT TABLE tt-manut-progda-ctrab-mi).
        RUN emptyRowErrors IN h-bomf626.

        IF l-modif THEN
            RUN updateRecord IN h-bomf626.
        ELSE
            RUN createRecord IN h-bomf626.

        IF RETURN-VALUE = "NOK":U THEN DO:
            EMPTY TEMP-TABLE rowErrors.
            RUN getRowErrors IN h-bomf626(OUTPUT TABLE rowErrors).
            DELETE PROCEDURE h-bomf626.
            RETURN "NOK":U.
        END.
        ELSE DO:
            FIND FIRST bf-ord-manut EXCLUSIVE-LOCK
                 WHERE bf-ord-manut.nr-ord-produ = i-nr-ord-produ NO-ERROR.
            IF AVAIL bf-ord-manut 
                AND bf-ord-manut.dt-manut <> rowObject.dat-progda-inic 
                AND bf-ord-manut.estado < 7 THEN
                ASSIGN bf-ord-manut.dt-manut      = rowObject.dat-progda-inic
                       bf-ord-manut.dt-prev-manut = rowObject.dat-progda-inic
                       bf-ord-manut.dt-prev       = rowObject.dat-progda-inic + bf-ord-manut.dur-man - 1.
            RELEASE bf-ord-manut.
        END.

        DELETE PROCEDURE h-bomf626.
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE i-num-om-progda AS INTEGER    NO-UNDO.

    IF AVAIL RowObject THEN DO:

        /* Incrementa a chave sequencial, caso esteja duplicada ou zerada*/
        IF RowObject.num-om-progda = 0 OR
           CAN-FIND(FIRST bf{&TableName} 
                    WHERE bf{&TableName}.cod-ctrab     = RowObject.cod-ctrab
                    AND   bf{&TableName}.num-om-progda = RowObject.num-om-progda) THEN DO:

            FOR LAST bfMan-progda-ctrab NO-LOCK
                WHERE bfMan-progda-ctrab.cod-ctrab = RowObject.cod-ctrab USE-INDEX id:

                ASSIGN i-num-om-progda = bfMan-progda-ctrab.num-om-progda.

            END.
            ASSIGN RowObject.num-om-progda = i-num-om-progda + 1.
        END.

        RUN atualizaDadosAuxiliares.
    END.

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

IF AVAIL rowObject THEN DO:
    RUN atualizaDadosAuxiliares.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE executarAssignTabela DBOProgram 
PROCEDURE executarAssignTabela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param rw-man-progda-ctrab as rowid.
    
    find man-progda-ctrab
        where rowid(man-progda-ctrab) = rw-man-progda-ctrab exclusive no-error.

    run pi-converte-data-segs-valor (Input man-progda-ctrab.dat-progda-inic,
                                     Input man-progda-ctrab.qtd-segs-progda-inic,
                                     output man-progda-ctrab.val-refer-inic-parada).
    
    run pi-converte-data-segs-valor (Input man-progda-ctrab.dat-progda-fim,
                                     Input man-progda-ctrab.qtd-segs-progda-fim,
                                     output man-progda-ctrab.val-refer-fim-parada).
    
    run pi-sfc-reporte-tempo (input man-progda-ctrab.cod-ctrab, 
                              input man-progda-ctrab.dat-progda-fim,
                              input man-progda-ctrab.qtd-segs-progda-fim,
                              input man-progda-ctrab.dat-progda-inic,
                              input man-progda-ctrab.qtd-segs-progda-inic,
                              output man-progda-ctrab.qtd-tempo-maq,
                              output man-progda-ctrab.qtd-tempo-ext,
                              output man-progda-ctrab.cod-model-turno,
                              output man-progda-ctrab.num-turno).

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
        WHEN "cod-ctrab":U THEN ASSIGN pFieldValue = RowObject.cod-ctrab.
        WHEN "cod-model-turno":U THEN ASSIGN pFieldValue = RowObject.cod-model-turno.
        WHEN "cod-parada":U THEN ASSIGN pFieldValue = RowObject.cod-parada.
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
        WHEN "dat-progda-fim":U THEN ASSIGN pFieldValue = RowObject.dat-progda-fim.
        WHEN "dat-progda-inic":U THEN ASSIGN pFieldValue = RowObject.dat-progda-inic.
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
        WHEN "qtd-segs-progda-fim":U THEN ASSIGN pFieldValue = RowObject.qtd-segs-progda-fim.
        WHEN "qtd-segs-progda-inic":U THEN ASSIGN pFieldValue = RowObject.qtd-segs-progda-inic.
        WHEN "qtd-tempo-ext":U THEN ASSIGN pFieldValue = RowObject.qtd-tempo-ext.
        WHEN "qtd-tempo-maq":U THEN ASSIGN pFieldValue = RowObject.qtd-tempo-maq.
        WHEN "val-refer-fim-parada":U THEN ASSIGN pFieldValue = RowObject.val-refer-fim-parada.
        WHEN "val-refer-inic-parada":U THEN ASSIGN pFieldValue = RowObject.val-refer-inic-parada.
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
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "num-om-progda":U THEN ASSIGN pFieldValue = RowObject.num-om-progda.
        WHEN "num-turno":U THEN ASSIGN pFieldValue = RowObject.num-turno.
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
               retorna valor do campo cod-ctrab
               retorna valor do campo num-om-progda
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-ctrab LIKE man-progda-ctrab.cod-ctrab NO-UNDO.
    DEFINE OUTPUT PARAMETER pnum-om-progda LIKE man-progda-ctrab.num-om-progda NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-ctrab = RowObject.cod-ctrab
           pnum-om-progda = RowObject.num-om-progda.

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
        WHEN "log-man-ativa":U THEN ASSIGN pFieldValue = RowObject.log-man-ativa.
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
  Purpose:     Reposiciona registro com base no °ndice id
  Parameters:  
               recebe valor do campo cod-ctrab
               recebe valor do campo num-om-progda
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-ctrab     LIKE man-progda-ctrab.cod-ctrab NO-UNDO.
    DEFINE INPUT PARAMETER pnum-om-progda LIKE man-progda-ctrab.num-om-progda NO-UNDO.

    FIND FIRST bfman-progda-ctrab WHERE 
        bfman-progda-ctrab.cod-ctrab = pcod-ctrab AND 
        bfman-progda-ctrab.num-om-progda = pnum-om-progda NO-LOCK NO-ERROR.


    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfman-progda-ctrab THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfman-progda-ctrab)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-sobreposicao DBOProgram 
PROCEDURE pi-verifica-sobreposicao :
/*------------------------------------------------------------------------------
  Purpose:     Chamada pelo validateRecord, para validar sobreposicao de paradas.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF PARAMETER BUFFER bRowObject FOR RowObject.
    DEF INPUT  PARAMETER pType      AS CHAR        NO-UNDO.
    DEF OUTPUT PARAMETER l-existe   AS LOG INIT NO NO-UNDO.

    DEF VAR de-val-refer LIKE RowObject.val-refer-inic-parada NO-UNDO.
    DEF VAR de-data      AS DATE                              NO-UNDO.
    DEF VAR i-rep        AS INTEGER                           NO-UNDO.

    ASSIGN de-data = (date(integer(SUBSTRING(STRING(bRowObject.val-refer-inic-parada),5,2)),
                           integer(SUBSTRING(STRING(bRowObject.val-refer-inic-parada),7,2)),
                           integer(SUBSTRING(STRING(bRowObject.val-refer-inic-parada),1,4))) - 60).
        
    run pi-converte-data-segs-valor (Input de-data,Input 0,output de-val-refer).

    b-busca:
    REPEAT i-rep = 1 TO 2:
        FOR EACH bf{&TableName} NO-LOCK USE-INDEX inicio
            where bf{&TableName}.cod-ctrab              = bRowObject.cod-ctrab
              AND bf{&TableName}.log-man-ativa          = IF i-rep = 1 THEN YES ELSE NO
              AND bf{&TableName}.val-refer-inic-parada >= de-val-refer:

           IF pType = "Update" AND bf{&TableName}.num-om-progda = bRowObject.num-om-progda THEN NEXT.

           IF bf{&tableName}.val-refer-fim-parada <= bRowObject.val-refer-inic-parada THEN NEXT.

           IF bf{&tableName}.val-refer-inic-parada < bRowObject.val-refer-fim-parada THEN DO:
               ASSIGN l-existe = YES.
               LEAVE b-busca.
           END.
        END.
    END.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaOrdManut DBOProgram 
PROCEDURE setaOrdManut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-nr-ord-produ AS INT NO-UNDO.

FIND FIRST param-global NO-LOCK NO-ERROR.

/*Se o novo Chao de Fabrica ou o MI nao estiverem implantados, retorna NOK.*/
IF param-global.modulo-mi = NO or l-mudancas-sfc = NO THEN
    RETURN "NOK":U.

ASSIGN i-nr-ord-produ = p-nr-ord-produ.

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

    DEFINE VARIABLE i-num-om-progda AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-liter         AS CHAR        NO-UNDO.
    DEFINE VARIABLE l-existe        AS LOG INIT NO NO-UNDO.

    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/

    IF pType = "Create":U THEN DO:

        /* Incrementa a chave sequencial, caso esteja duplicada ou zerada*/
        IF RowObject.num-om-progda = 0 OR
           CAN-FIND(FIRST bf{&TableName} 
                    WHERE bf{&TableName}.cod-ctrab     = RowObject.cod-ctrab
                    AND   bf{&TableName}.num-om-progda = RowObject.num-om-progda) THEN DO:

            FOR LAST bfMan-progda-ctrab NO-LOCK
                WHERE bfMan-progda-ctrab.cod-ctrab = RowObject.cod-ctrab USE-INDEX id:

                ASSIGN i-num-om-progda = bfMan-progda-ctrab.num-om-progda.

            END.
            ASSIGN RowObject.num-om-progda = i-num-om-progda + 1.
        END.


        /* Valida chave duplicada */
        IF CAN-FIND(FIRST bf{&TableName} 
                    WHERE bf{&TableName}.cod-ctrab     = RowObject.cod-ctrab
                    AND   bf{&TableName}.num-om-progda = RowObject.num-om-progda) THEN DO:

            {utp/ut-table.i movmfg man-progda-ctrab 1}

            {method/svc/errors/inserr.i &ErrorNumber="8"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
                                        
        END.
    END.

    IF pType <> "Delete":U THEN
        RUN atualizaDadosAuxiliares.

    IF pType = "Create":U OR pType = "Update":U THEN DO:

        if rowObject.cod-ctrab = "":U then do:
            {utp/ut-liter.i Centro_de_Trabalho *}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        end.
        ELSE
            IF NOT CAN-FIND(FIRST ctrab WHERE ctrab.cod-ctrab = rowObject.cod-ctrab NO-LOCK) THEN DO:
                {utp/ut-liter.i Centro_de_Trabalho *}
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
            END.

        if rowObject.cod-parada = "":U then do:
            {utp/ut-liter.i Motivo_Parada *}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        end.
        ELSE DO:
       
            IF NOT CAN-FIND(FIRST motiv-parada where motiv-parada.cod-parada = RowObject.cod-parada no-lock) THEN DO:
                {utp/ut-liter.i Motivo_Parada *}
                {method/svc/errors/inserr.i &ErrorNumber="47"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"
                                            &ErrorParameters="return-value"}
            end.
            ELSE IF CAN-FIND(FIRST motiv-parada
                              WHERE motiv-parada.cod-parada = RowObject.cod-parada
                                AND NOT motiv-parada.log-ativo) THEN DO:

                {utp/ut-table.i mgmfg motiv-parada 01}
        
                {method/svc/errors/inserr.i
                        &ErrorNumber="29546"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="return-value + '~~~~' + RowObject.cod-parada"} 

            END.
        END.

        if rowObject.dat-progda-inic = ? then do:
            {utp/ut-liter.i Data_In°cio *}
            {utp/ut-field.i movmfg {&TABLE-NAME} dat-progda-inic 1}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        end.

        if rowObject.qtd-segs-progda-fim = ? then do:
            {utp/ut-liter.i Hora_In°cio *}
            {utp/ut-field.i movmfg {&TABLE-NAME} qtd-segs-progda-fim 1}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        end.

        if rowObject.dat-progda-fim = ? then do:
            {utp/ut-liter.i Data_Fim *}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        end.
     
        if rowObject.qtd-segs-progda-inic = ? then do:
            {utp/ut-liter.i Hora_Fim *}
            {method/svc/errors/inserr.i &ErrorNumber="265"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="return-value"}
        end.

        if  RowObject.dat-progda-inic > RowObject.dat-progda-fim then do:
            {method/svc/errors/inserr.i &ErrorNumber="198"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=" "}
        end.

        if  RowObject.dat-progda-inic = RowObject.dat-progda-fim and
            RowObject.qtd-segs-progda-fim <= RowObject.qtd-segs-progda-inic then do:
            {method/svc/errors/inserr.i &ErrorNumber="3074"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters=" "}
        end.

        IF pType = "Create":U AND (RowObject.dat-progda-inic < TODAY or RowObject.dat-progda-fim < today) OR
           pType = "Update":U AND (RowObject.dat-progda-inic < man-progda-ctrab.dat-progda-inic or 
                                   RowObject.dat-progda-fim < man-progda-ctrab.dat-progda-inic) then do:
            {method/svc/errors/inserr.i &ErrorNumber="16301"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR"
                                        &ErrorParameters="if pType = 'Create':U then
                                                             (string(today) + '~~~~' + string(date(12,31,9999)))
                                                          ELSE (string(man-progda-ctrab.dat-progda-inic) + '~~~~' + string(date(12,31,9999)))"}
        end.

        IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
            RETURN "NOK":U.

        RUN pi-verifica-sobreposicao(BUFFER RowObject,                  
                                     INPUT pType,
                                     OUTPUT l-existe). 

        IF l-existe = YES THEN DO:                                      
            {utp/ut-table.i movmfg man-progda-ctrab 1}                  
            {method/svc/errors/inserr.i &ErrorNumber="17557"            
                                        &ErrorType="EMS"                
                                        &ErrorSubType="ERROR"           
                                        &ErrorParameters="return-value"}
        END.     
    END.   

    IF pType = "Delete":U THEN DO:
        IF CAN-FIND(FIRST rep-parada-ctrab
                    WHERE rep-parada-ctrab.num-om-progda = RowObject.num-om-progda) THEN DO:
        {utp/ut-liter.i Parada_Programada *}
        ASSIGN c-liter = RETURN-VALUE.

        {utp/ut-table.i mgind rep-parada-ctrab 01}
        {method/svc/errors/inserr.i
                           &ErrorNumber="17"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"
                           &ErrorParameters="c-liter + '~~~~' + return-value"} 
        END.
    END.
    
    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

