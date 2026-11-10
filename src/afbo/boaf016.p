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
{include/i-prgvrs.i BOAF016 2.00.00.010 } /*** "010010" 29/05/2025 12:29:13 ***/
/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOAF016
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName af-periodo-aval
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
{afbo/boaf016.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{utp/ut-glob.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEF VAR i-ano-avaliacao-ini LIKE af-periodo-aval.ano-avaliacao NO-UNDO.
DEF VAR i-ano-avaliacao-fim LIKE af-periodo-aval.ano-avaliacao NO-UNDO.

{afbo/boaf016.i1}

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
         HEIGHT             = 8.92
         WIDTH              = 39.
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
        WHEN "des-periodo-aval[1]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[1].
        WHEN "des-periodo-aval[2]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[2].
        WHEN "des-periodo-aval[3]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[3].
        WHEN "des-periodo-aval[4]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[4].
        WHEN "des-periodo-aval[5]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[5].
        WHEN "des-periodo-aval[6]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[6].
        WHEN "des-periodo-aval[7]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[7].
        WHEN "des-periodo-aval[8]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[8].
        WHEN "des-periodo-aval[9]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[9].
        WHEN "des-periodo-aval[10]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[10].
        WHEN "des-periodo-aval[11]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[11].
        WHEN "des-periodo-aval[12]":U THEN ASSIGN pFieldValue = RowObject.des-periodo-aval[12].
        WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
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
        WHEN "dt-periodo-fim[1]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[1].
        WHEN "dt-periodo-fim[2]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[2].
        WHEN "dt-periodo-fim[3]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[3].
        WHEN "dt-periodo-fim[4]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[4].
        WHEN "dt-periodo-fim[5]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[5].
        WHEN "dt-periodo-fim[6]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[6].
        WHEN "dt-periodo-fim[7]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[7].
        WHEN "dt-periodo-fim[8]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[8].
        WHEN "dt-periodo-fim[9]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[9].
        WHEN "dt-periodo-fim[10]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[10].
        WHEN "dt-periodo-fim[11]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[11].
        WHEN "dt-periodo-fim[12]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-fim[12].
        WHEN "dt-periodo-ini[1]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[1].
        WHEN "dt-periodo-ini[2]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[2].
        WHEN "dt-periodo-ini[3]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[3].
        WHEN "dt-periodo-ini[4]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[4].
        WHEN "dt-periodo-ini[5]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[5].
        WHEN "dt-periodo-ini[6]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[6].
        WHEN "dt-periodo-ini[7]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[7].
        WHEN "dt-periodo-ini[8]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[8].
        WHEN "dt-periodo-ini[9]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[9].
        WHEN "dt-periodo-ini[10]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[10].
        WHEN "dt-periodo-ini[11]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[11].
        WHEN "dt-periodo-ini[12]":U THEN ASSIGN pFieldValue = RowObject.dt-periodo-ini[12].
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
        WHEN "ano-avaliacao":U THEN ASSIGN pFieldValue = RowObject.ano-avaliacao.
        WHEN "nr-periodos":U THEN ASSIGN pFieldValue = RowObject.nr-periodos.
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
               retorna valor do campo ano-avaliacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pano-avaliacao LIKE af-periodo-aval.ano-avaliacao NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pano-avaliacao = RowObject.ano-avaliacao.

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
        WHEN "log-fechado[1]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[1].
        WHEN "log-fechado[2]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[2].
        WHEN "log-fechado[3]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[3].
        WHEN "log-fechado[4]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[4].
        WHEN "log-fechado[5]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[5].
        WHEN "log-fechado[6]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[6].
        WHEN "log-fechado[7]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[7].
        WHEN "log-fechado[8]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[8].
        WHEN "log-fechado[9]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[9].
        WHEN "log-fechado[10]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[10].
        WHEN "log-fechado[11]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[11].
        WHEN "log-fechado[12]":U THEN ASSIGN pFieldValue = RowObject.log-fechado[12].
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
               recebe valor do campo ano-avaliacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pano-avaliacao LIKE af-periodo-aval.ano-avaliacao NO-UNDO.

    FIND FIRST bfaf-periodo-aval WHERE 
        bfaf-periodo-aval.ano-avaliacao = pano-avaliacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfaf-periodo-aval THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfaf-periodo-aval)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerybyAno DBOProgram 
PROCEDURE openQuerybyAno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                           WHERE {&TableName}.ep-codigo = i-ep-codigo-usuario
                             AND {&TableName}.ano-avaliacao >= i-ano-avaliacao-ini
                             AND {&TableName}.ano-avaliacao <= i-ano-avaliacao-fim NO-LOCK INDEXED-REPOSITION.


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

    OPEN QUERY {&QueryName} FOR EACH {&TableName} 
                               WHERE {&TableName}.ep-codigo = i-ep-codigo-usuario NO-LOCK INDEXED-REPOSITION.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-primeiro-ultimo-ano DBOProgram 
PROCEDURE pi-primeiro-ultimo-ano :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar o menor e o maior ano cadastrados
  Parameters:  pc-primeiro-ano = retorna o menor ano cadastrado
               pc-ultimo-ano = retorna p maior ano cadastrado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pi-primeiro-ano AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pi-ultimo-ano AS INTEGER   NO-UNDO.
    
    FOR EACH af-periodo-aval WHERE af-periodo-aval.ep-codigo = v_cdn_empres_usuar NO-LOCK
        BY af-periodo-aval.ano-avaliacao:
        ASSIGN pi-primeiro-ano = af-periodo-aval.ano-avaliacao.
        LEAVE.
    END.

    FOR EACH af-periodo-aval WHERE af-periodo-aval.ep-codigo = v_cdn_empres_usuar NO-LOCK
        BY af-periodo-aval.ano-avaliacao DESC:
        ASSIGN pi-ultimo-ano = af-periodo-aval.ano-avaliacao.
        LEAVE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ultimo-periodo DBOProgram 
PROCEDURE pi-ultimo-periodo :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o maior per°odo para o ano informado
  Parameters:  pi-ano = Ano para fazer o filtro
               pi-ultimo-periodo = Retorno o ultimo per°odo para o ano informado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pi-ano AS INTEGER   NO-UNDO. 
    DEFINE OUTPUT PARAMETER pi-ultimo-periodo AS INTEGER   NO-UNDO. 

    FIND FIRST af-periodo-aval NO-LOCK
        WHERE af-periodo-aval.ano-avaliacao = pi-ano        
        AND af-periodo-aval.ep-codigo = v_cdn_empres_usuar NO-ERROR.

    IF AVAIL af-periodo-aval THEN
        ASSIGN pi-ultimo-periodo = af-periodo-aval.nr-periodos.    
    
        RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaFaixaPeriodos DBOProgram 
PROCEDURE retornaFaixaPeriodos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-data       as   date                                no-undo.
def output param p-ano       LIKE af-periodo-aval.ano-avaliacao       no-undo.
def output param p-periodo   LIKE af-periodo-aval.des-periodo-aval[1] no-undo.

DEF VAR i-cont            AS INT NO-UNDO.
DEF BUFFER b-af-periodo-aval-aux FOR af-periodo-aval.

FOR EACH b-af-periodo-aval-aux
   WHERE b-af-periodo-aval-aux.ano-avaliacao = year(p-data) NO-LOCK:
     DO i-cont = 1 TO b-af-periodo-aval-aux.nr-periodos:
        IF p-data >= b-af-periodo-aval-aux.dt-periodo-ini[i-cont] and
           p-data <= b-af-periodo-aval-aux.dt-periodo-fim[i-cont] then do:
           assign p-ano = b-af-periodo-aval-aux.ano-avaliacao 
                  p-periodo = b-af-periodo-aval-aux.des-periodo-aval[i-cont].
           return.
        end.
     END.
END.

/* Se n∆o encontrou para o ano, procura para outro ano pois os per°odos n∆o necessariamente 
   precisam pertencer ao ano chave */
FOR EACH b-af-periodo-aval-aux NO-LOCK:
     DO i-cont = 1 TO b-af-periodo-aval-aux.nr-periodos:
        IF p-data >= b-af-periodo-aval-aux.dt-periodo-ini[i-cont] and
           p-data <= b-af-periodo-aval-aux.dt-periodo-fim[i-cont] then do:
           assign p-ano = b-af-periodo-aval-aux.ano-avaliacao 
                  p-periodo = b-af-periodo-aval-aux.des-periodo-aval[i-cont].
           return.
        end.
     END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaPeriodosFaixa DBOProgram 
PROCEDURE retornaPeriodosFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ano-ini          LIKE af-periodo-aval.ano-avaliacao       no-undo.
def input param p-periodo-ini      LIKE af-periodo-aval.des-periodo-aval[1] no-undo.
def input param p-ano-fim          LIKE af-periodo-aval.ano-avaliacao       no-undo.
def input param p-periodo-fim      LIKE af-periodo-aval.des-periodo-aval[1] no-undo.
DEF OUTPUT PARAM TABLE FOR tt-dt-periodo-aval.

DEF VAR i-cont            AS INT NO-UNDO.
DEF VAR l-passou-primeiro AS LOG NO-UNDO.
DEF BUFFER b-af-periodo-aval-aux FOR af-periodo-aval.

EMPTY TEMP-TABLE tt-dt-periodo-aval.

bk_periodo_aval:
FOR EACH b-af-periodo-aval-aux
   WHERE b-af-periodo-aval-aux.ano-avaliacao >= p-ano-ini
     AND b-af-periodo-aval-aux.ano-avaliacao <= p-ano-fim NO-LOCK:

     DO i-cont = 1 TO b-af-periodo-aval-aux.nr-periodos:

         IF b-af-periodo-aval-aux.ano-avaliacao = p-ano-ini AND
            b-af-periodo-aval-aux.des-periodo-aval[i-cont] <> p-periodo-ini AND
            NOT l-passou-primeiro THEN NEXT.

         ASSIGN l-passou-primeiro = YES.

         CREATE tt-dt-periodo-aval.
         ASSIGN tt-dt-periodo-aval.ano-avaliacao    = b-af-periodo-aval-aux.ano-avaliacao
                tt-dt-periodo-aval.des-periodo-aval = b-af-periodo-aval-aux.des-periodo-aval[i-cont]
                tt-dt-periodo-aval.dt-periodo-ini   = b-af-periodo-aval-aux.dt-periodo-ini[i-cont]
                tt-dt-periodo-aval.dt-periodo-fim   = b-af-periodo-aval-aux.dt-periodo-fim[i-cont]
                tt-dt-periodo-aval.log-fechado      = b-af-periodo-aval-aux.log-fechado[i-cont].
    
         IF b-af-periodo-aval-aux.ano-avaliacao = p-ano-fim AND
            b-af-periodo-aval-aux.des-periodo-aval[i-cont] = p-periodo-fim THEN LEAVE bk_periodo_aval.
     END.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaTodosPeriodosFaixa DBOProgram 
PROCEDURE retornaTodosPeriodosFaixa :
/*------------------------------------------------------------------------------
  Purpose:     Retorna todos os per°odos do intervalos passado.
  Parameters:  p-ano-ini - ano de in°cio
               p-ano-fim - ano de tÇrmino
               tt-dt-periodo-aval - TT com os valores
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ano-ini          LIKE af-periodo-aval.ano-avaliacao       no-undo.
def input param p-ano-fim          LIKE af-periodo-aval.ano-avaliacao       no-undo.
DEF OUTPUT PARAM TABLE FOR tt-dt-periodo-aval.

DEF VAR i-cont            AS INT NO-UNDO.
DEF BUFFER b-af-periodo-aval-aux FOR af-periodo-aval.

EMPTY TEMP-TABLE tt-dt-periodo-aval.

FOR EACH b-af-periodo-aval-aux
   WHERE b-af-periodo-aval-aux.ano-avaliacao >= p-ano-ini
     AND b-af-periodo-aval-aux.ano-avaliacao <= p-ano-fim NO-LOCK:

     DO i-cont = 1 TO b-af-periodo-aval-aux.nr-periodos:
   
         CREATE tt-dt-periodo-aval.
         ASSIGN tt-dt-periodo-aval.ano-avaliacao    = b-af-periodo-aval-aux.ano-avaliacao
                tt-dt-periodo-aval.des-periodo-aval = b-af-periodo-aval-aux.des-periodo-aval[i-cont]
                tt-dt-periodo-aval.dt-periodo-ini   = b-af-periodo-aval-aux.dt-periodo-ini[i-cont]
                tt-dt-periodo-aval.dt-periodo-fim   = b-af-periodo-aval-aux.dt-periodo-fim[i-cont]
                tt-dt-periodo-aval.log-fechado      = b-af-periodo-aval-aux.log-fechado[i-cont].
    
     END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAno DBOProgram 
PROCEDURE setConstraintAno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-ano-avaliacao-ini   LIKE af-periodo-aval.ano-avaliacao NO-UNDO.
    DEFINE INPUT PARAMETER p-ano-avaliacao-fim   LIKE af-periodo-aval.ano-avaliacao NO-UNDO.
   
    ASSIGN i-ano-avaliacao-ini = p-ano-avaliacao-ini
           i-ano-avaliacao-fim = p-ano-avaliacao-fim.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPeriodoFechado DBOProgram 
PROCEDURE validaPeriodoFechado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-dt-indice AS DATE NO-UNDO.
DEF INPUT PARAM TABLE FOR tt-dt-periodo-aval.
DEF OUTPUT PARAM p-fechado AS LOG NO-UNDO.

DEF BUFFER b-af-periodo-aval-aux FOR af-periodo-aval.
DEF VAR i-cont AS INT NO-UNDO.

/* Se a temp-table n∆o foi carregada pelo programa chamador, ent∆o verifica diretamente
   na tabela  */
IF NOT CAN-FIND (FIRST tt-dt-periodo-aval) THEN DO:
   FOR EACH b-af-periodo-aval-aux NO-LOCK:
     DO i-cont = 1 TO b-af-periodo-aval-aux.nr-periodos:
         IF p-dt-indice >= b-af-periodo-aval-aux.dt-periodo-ini[i-cont] AND
            p-dt-indice <= b-af-periodo-aval-aux.dt-periodo-fim[i-cont] THEN DO:
            ASSIGN p-fechado = b-af-periodo-aval-aux.log-fechado[i-cont].
            RETURN.
         END.
     END.
   END.
END.
ELSE DO:
   if can-find(first tt-dt-periodo-aval
               where tt-dt-periodo-aval.dt-periodo-ini >= p-dt-indice
                 and tt-dt-periodo-aval.dt-periodo-fim <= p-dt-indice) then 
      ASSIGN p-fechado = tt-dt-periodo-aval.log-fechado.
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

    DEF VAR i-cont     AS INT NO-UNDO.
    DEF VAR i-cont-aux AS INT NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /*:T--- Verifica ocorrància de erros ---*/

    IF pType = "CREATE" THEN DO:
        ASSIGN rowObject.ep-codigo = i-ep-codigo-usuario.

        FIND FIRST bf{&TableName}
             WHERE bf{&TableName}.ep-codigo = rowObject.ep-codigo and
                   bf{&TableName}.ano-avaliacao = rowObject.ano-avaliacao NO-LOCK NO-ERROR.

        IF AVAIL bf{&TableName} THEN
            /* Inicio -- Projeto Internacional */
            DO:
            DEFINE VARIABLE c-lbl-liter-periodo-avaliacao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Per°odo_avaliaá∆o" *}
            ASSIGN c-lbl-liter-periodo-avaliacao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                &ErrorNumber="1"
                &ErrorType="EMS"
                &ErrorSubType="Error"
                &ErrorParameters="c-lbl-liter-periodo-avaliacao"}
            END. 

    END.
    
    IF pType = "UPDATE" OR pType = "CREATE" THEN DO:

        IF rowobject.nr-periodos = 0 OR
           rowobject.nr-periodos > 12 THEN
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-numero-de-periodos AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "N£mero_de_per°odos" *}
                ASSIGN c-lbl-liter-numero-de-periodos = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-de-1-a-12 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "de_1_a_12" *}
                ASSIGN c-lbl-liter-de-1-a-12 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                    &ErrorNumber="17167"
                    &ErrorType="EMS"
                    &ErrorSubType="Error"
                    &ErrorParameters="c-lbl-liter-numero-de-periodos + '~~~~' +  c-lbl-liter-de-1-a-12"}
                END. 
        ELSE DO:        
            DO i-cont = 1 TO rowobject.nr-periodos:
               IF (rowobject.dt-periodo-ini[i-cont] = ? OR rowobject.dt-periodo-fim[i-cont] = ?) THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-periodo AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "per°odo" *}
                  ASSIGN c-lbl-liter-periodo = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                        &ErrorNumber="52869"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-periodo + ' ' + string(i-cont)"}
               END.
               ELSE DO:
                   IF day(rowobject.dt-periodo-ini[i-cont]) <> 1 THEN DO:
                      /* Inicio -- Projeto Internacional */
                      DEFINE VARIABLE c-lbl-liter-periodo-2 AS CHARACTER NO-UNDO.
                      {utp/ut-liter.i "per°odo" *}
                      ASSIGN c-lbl-liter-periodo-2 = TRIM(RETURN-VALUE).
                      {method/svc/errors/inserr.i
                            &ErrorNumber="52870"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"
                            &ErrorParameters="c-lbl-liter-periodo-2 + ' ' + string(i-cont)"}
                   END.
                   IF MONTH(rowobject.dt-periodo-fim[i-cont]) = MONTH(rowobject.dt-periodo-fim[i-cont] + 1) THEN DO:
                      /* Inicio -- Projeto Internacional */
                      DEFINE VARIABLE c-lbl-liter-periodo-3 AS CHARACTER NO-UNDO.
                      {utp/ut-liter.i "per°odo" *}
                      ASSIGN c-lbl-liter-periodo-3 = TRIM(RETURN-VALUE).
                      {method/svc/errors/inserr.i
                            &ErrorNumber="52871"
                            &ErrorType="EMS"
                            &ErrorSubType="Error"
                            &ErrorParameters="c-lbl-liter-periodo-3 + ' ' + string(i-cont)"}
                   END.
               END.
            END.
    
            DO i-cont = 1 TO rowobject.nr-periodos:
                IF rowobject.des-periodo-aval[i-cont] = "" THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-descricao-do-periodo AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "Descriá∆o_do_per°odo" *}
                  ASSIGN c-lbl-liter-descricao-do-periodo = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                        &ErrorNumber="27223"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-descricao-do-periodo + ' ' + string(i-cont)"}
                END.
                ELSE DO:
                     DO i-cont-aux = 1 TO rowobject.nr-periodos:
                        IF i-cont-aux <> i-cont THEN DO:
                            IF rowobject.des-periodo-aval[i-cont] = rowobject.des-periodo-aval[i-cont-aux] THEN DO:
                              /* Inicio -- Projeto Internacional */
                              DEFINE VARIABLE c-lbl-liter-descricao-dos-periodos AS CHARACTER NO-UNDO.
                              {utp/ut-liter.i "Descriá∆o_dos_per°odos" *}
                              ASSIGN c-lbl-liter-descricao-dos-periodos = TRIM(RETURN-VALUE).
                              DEFINE VARIABLE c-lbl-liter-repetida AS CHARACTER NO-UNDO.
                              {utp/ut-liter.i "Repetida" *}
                              ASSIGN c-lbl-liter-repetida = TRIM(RETURN-VALUE).
                              {method/svc/errors/inserr.i
                                    &ErrorNumber="7972"
                                    &ErrorType="EMS"
                                    &ErrorSubType="Error"
                                    &ErrorParameters="c-lbl-liter-descricao-dos-periodos + '~~~~' + c-lbl-liter-repetida"}
                            END.
                        END.
                    END.
                END.
            END.
    
            DO i-cont = 2 TO rowobject.nr-periodos:
               IF rowobject.dt-periodo-ini[i-cont] <> rowobject.dt-periodo-fim[i-cont - 1] + 1 THEN DO:
                  /* Inicio -- Projeto Internacional */
                  DEFINE VARIABLE c-lbl-liter-do-periodo AS CHARACTER NO-UNDO.
                  {utp/ut-liter.i "do_per°odo" *}
                  ASSIGN c-lbl-liter-do-periodo = TRIM(RETURN-VALUE).
                  {method/svc/errors/inserr.i
                        &ErrorNumber="52877"
                        &ErrorType="EMS"
                        &ErrorSubType="Error"
                        &ErrorParameters="c-lbl-liter-do-periodo + ' ' + string(i-cont)"}
               END.
            END.
    
            IF NOT CAN-FIND (FIRST funcao 
                         WHERE funcao.cd-funcao = "spp-nao-valida-ano-maf" 
                         AND   funcao.ativo     = YES) THEN DO:
    
                IF rowobject.nr-periodos <> 1 THEN DO:
                    IF YEAR(rowobject.dt-periodo-ini[1]) <> YEAR(rowobject.dt-periodo-fim[rowobject.nr-periodos]) THEN DO:
                          /* Inicio -- Projeto Internacional */
                          DEFINE VARIABLE c-lbl-liter-as-datas-informadas-devem-pert AS CHARACTER NO-UNDO.
                          {utp/ut-liter.i "As_datas_informadas_devem_pertencer_ao_ano_do_per°odo" *}
                          ASSIGN c-lbl-liter-as-datas-informadas-devem-pert = TRIM(RETURN-VALUE).
                          {method/svc/errors/inserr.i
                                &ErrorNumber="52882"
                                &ErrorType="EMS"
                                &ErrorSubType="Error"
                                &ErrorParameters="c-lbl-liter-as-datas-informadas-devem-pert + '.'"}
                    END.
                END.        
    
                IF rowobject.nr-periodos <> 1 THEN DO:              
                    IF month(rowobject.dt-periodo-ini[1]) <> month(rowobject.dt-periodo-fim[rowobject.nr-periodos] + 1) THEN DO:
                          /* Inicio -- Projeto Internacional */
                          DEFINE VARIABLE c-lbl-liter-os-periodos-informados-devem-c AS CHARACTER NO-UNDO.
                          {utp/ut-liter.i "Os_per°odos_informados_devem_contemplar_todo_o_ano" *}
                          ASSIGN c-lbl-liter-os-periodos-informados-devem-c = TRIM(RETURN-VALUE).
                          {method/svc/errors/inserr.i
                                &ErrorNumber="52881"
                                &ErrorType="EMS"
                                &ErrorSubType="Error"
                                &ErrorParameters="c-lbl-liter-os-periodos-informados-devem-c + '.'"}
                    END.
                END.
            END.
        END.
    END.
    ELSE DO:        
        IF CAN-FIND (FIRST af-versao-avaliacao NO-LOCK
                 WHERE af-versao-avaliacao.ep-codigo = RowObject.ep-codigo 
                 AND af-versao-avaliacao.ano-avaliacao = RowObject.ano-avaliacao) THEN
        /* Inicio -- Projeto Internacional */
        DO:
        DEFINE VARIABLE c-lbl-liter-periodo-de-avaliacao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Per°odo_de_Avaliaá∆o" *}
        ASSIGN c-lbl-liter-periodo-de-avaliacao = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-versao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Vers∆o" *}
        ASSIGN c-lbl-liter-versao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i &ErrorNumber="5"
            &ErrorType="EMS"
            &ErrorSubType="ERROR"
            &ErrorParameters="c-lbl-liter-periodo-de-avaliacao + '~~~~' + c-lbl-liter-versao"}
        END. 
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

