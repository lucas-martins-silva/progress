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
{include/i-prgvrs.i BOCX310A 2.00.00.016 } /*** "010016" 07/10/2024 16:59:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOCX310A MUT}
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
&GLOBAL-DEFINE DBOName BOCX310
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName desp-embarque
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
{cxbo/bocx310a.i RowObject}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

{cdp/cdcfgmat.i} /*Definiá∆o de prÇ-processadores*/

{cxbo/bocx220h.i tt-selecao-embarque} /*Definiá∆o da temp-table com os embarques selecionados*/
{cxbo/bocx310a.i tt-desp-embarque}    /*Definiá∆o da temp-table com as despesas que ir∆o estar dispon°veis*/

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
         HEIGHT             = 9.17
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
  Notes: ***RowObject customizada***       
------------------------------------------------------------------------------*/
    /*DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "embarque":U THEN ASSIGN pFieldValue = RowObject.embarque.
        OTHERWISE RETURN "NOK":U.
    END CASE.*/

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
  Notes:***RowObject customizada***       
------------------------------------------------------------------------------*/
    /*DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.*/

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
  Notes: ***RowObject customizada***      
------------------------------------------------------------------------------*/
    /*DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "val-desp":U THEN ASSIGN pFieldValue = RowObject.val-desp.
        OTHERWISE RETURN "NOK":U.
    END CASE.*/

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
  Notes:  ***RowObject customizada***     
------------------------------------------------------------------------------*/
   /* DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-desp":U THEN ASSIGN pFieldValue = RowObject.cod-desp.
        WHEN "cod-emitente-desp":U THEN ASSIGN pFieldValue = RowObject.cod-emitente-desp.
        WHEN "cod-itiner":U THEN ASSIGN pFieldValue = RowObject.cod-itiner.
        WHEN "cod-pto-contr":U THEN ASSIGN pFieldValue = RowObject.cod-pto-contr.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        OTHERWISE RETURN "NOK":U.
    END CASE.*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-estabel
               retorna valor do campo embarque
               retorna valor do campo cod-itiner
               retorna valor do campo cod-pto-contr
               retorna valor do campo cod-desp
               retorna valor do campo cod-emitente-desp
  Notes:     ***RowObject customizada***  
------------------------------------------------------------------------------*/
    /*DEFINE OUTPUT PARAMETER pcod-estabel LIKE desp-embarque.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pembarque LIKE desp-embarque.embarque NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-itiner LIKE desp-embarque.cod-itiner NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-pto-contr LIKE desp-embarque.cod-pto-contr NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-desp LIKE desp-embarque.cod-desp NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente-desp LIKE desp-embarque.cod-emitente-desp NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel
           pembarque = RowObject.embarque
           pcod-itiner = RowObject.cod-itiner
           pcod-pto-contr = RowObject.cod-pto-contr
           pcod-desp = RowObject.cod-desp
           pcod-emitente-desp = RowObject.cod-emitente-desp.*/

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
  Notes:  ***RowObject customizada***     
------------------------------------------------------------------------------*/
   /* DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.*/

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
               recebe valor do campo cod-estabel
               recebe valor do campo embarque
               recebe valor do campo cod-itiner
               recebe valor do campo cod-pto-contr
               recebe valor do campo cod-desp
               recebe valor do campo cod-emitente-desp
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE desp-embarque.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pembarque LIKE desp-embarque.embarque NO-UNDO.
    DEFINE INPUT PARAMETER pcod-itiner LIKE desp-embarque.cod-itiner NO-UNDO.
    DEFINE INPUT PARAMETER pcod-pto-contr LIKE desp-embarque.cod-pto-contr NO-UNDO.
    DEFINE INPUT PARAMETER pcod-desp LIKE desp-embarque.cod-desp NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente-desp LIKE desp-embarque.cod-emitente-desp NO-UNDO.

    FIND FIRST bfdesp-embarque WHERE 
        bfdesp-embarque.cod-estabel = pcod-estabel AND 
        bfdesp-embarque.embarque = pembarque AND 
        bfdesp-embarque.cod-itiner = pcod-itiner AND 
        bfdesp-embarque.cod-pto-contr = pcod-pto-contr AND 
        bfdesp-embarque.cod-desp = pcod-desp AND 
        bfdesp-embarque.cod-emitente-desp = pcod-emitente-desp NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdesp-embarque THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdesp-embarque)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    open query {&queryname} for each {&tablename} no-lock.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaSelecaoDespesa DBOProgram 
PROCEDURE piRetornaSelecaoDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input  param pl-agrupa-unico-fornec as logical                no-undo.
   def input  param pcod-emitente-desp     as int format ">>>>>>>>9" no-undo.
   def input  param pcod-desp-ini          as int format ">>,>>9"    no-undo.
   def input  param pcod-desp-fim          as int format ">>,>>9"    no-undo.
   def input  param pfornec-desp-ini       as int format ">>>>>>>>9" no-undo.
   def input  param pfornec-desp-fim       as int format ">>>>>>>>9" no-undo.
   def input  param pto-controle-ini       as int format ">>,>>9"    no-undo.
   def input  param pto-controle-fim       as int format ">>,>>9"    no-undo.
   def input  param table for tt-selecao-embarque.
   def output param table for tt-desp-embarque.
       
   def var seq-pto-desembarque like pto-itiner.sequencia no-undo.

   for each tt-desp-embarque:
       delete tt-desp-embarque.
   end. 

   /*Selecá∆o de embarques*/
   for each tt-selecao-embarque:
       /****** 
       Na tabela pto-itiner encontra sequencia do ponto de desembarque/Narionalizaá∆o
       for first pto-itiner no-lock
           where pto-itiner.cod-itiner    = itinerario.cod-itiner
           and   pto-itiner.cod-pto-contr = itinerario.pto-desembarque: 
       end.
       *****/

       FOR FIRST embarque-imp NO-LOCK
           WHERE embarque-imp.cod-estabel = tt-selecao-embarque.cod-estabel
             AND embarque-imp.embarque    = tt-selecao-embarque.embarque:
       END.

       FOR FIRST historico-embarque WHERE
                 historico-embarque.cod-estabel   = tt-selecao-embarque.cod-estabel AND
                 historico-embarque.embarque      = tt-selecao-embarque.embarque    AND
                 historico-embarque.cod-itiner    = tt-selecao-embarque.cod-itiner  AND
                 historico-embarque.cod-pto-contr = embarque-imp.cdn-pto-desembar   NO-LOCK:
       END.

       IF AVAIL historico-embarque THEN
           assign seq-pto-desembarque = historico-embarque.sequencia. /*Sequencia do ponto de Nacionalizaá∆o*/

       /*****
       if avail pto-itiner then
           assign seq-pto-desembarque = pto-itiner.sequencia. /*Sequencia do ponto de Nacionalizaá∆o*/
       *****/

       for each  historico-embarque no-lock
           where historico-embarque.cod-estabel   =  tt-selecao-embarque.cod-estabel
           and   historico-embarque.embarque      =  tt-selecao-embarque.embarque
           and   historico-embarque.cod-itiner    =  tt-selecao-embarque.cod-itiner
           and   historico-embarque.sequencia     >  seq-pto-desembarque /*Depois do ponto de nacionalizaá∆o*/
           and   historico-embarque.cod-pto-contr >= pto-controle-ini
           and   historico-embarque.cod-pto-contr <= pto-controle-fim
           and   historico-embarque.dt-efetiva    <> ? :     /*Despesas Efetivadas*/

           /*Somente aparecer∆o em tela as despesas do fornecedor informado em tela*/
           if  not pl-agrupa-unico-fornec then do: 
               
               for each  desp-embarque no-lock
                   where desp-embarque.cod-estabel       =  historico-embarque.cod-estabel
                   and   desp-embarque.embarque          =  historico-embarque.embarque
                   and   desp-embarque.cod-itiner        =  historico-embarque.cod-itiner
                   and   desp-embarque.cod-pto-contr     =  historico-embarque.cod-pto-contr
                   and   desp-embarque.cod-desp          >= pcod-desp-ini
                   and   desp-embarque.cod-desp          <= pcod-desp-fim
                   and   desp-embarque.cod-emitente-desp =  pcod-emitente-desp /*Ènico Fornecedor*/
                   and  
                   &if "{&bf_mat_versao_ems}" >= "2.04" and "{&bf_mat_versao_ems}" < "2.06" &then
                       desp-embarque.log-1 = no                       /*Despesa n∆o pode ser recebida*/
                   &elseif "{&bf_mat_versao_ems}" >= "2.06" &then
                       desp-embarque.log-despes-ja-recbda = no        /*Despesa n∆o pode ser recebida*/
                   &endif:
                   
                   /*Despesa deve incidir no valor de frete/seguro/embalagem/outras (pelo menos um dos campos tem que estar marcado)*/
                   for first desp-imp no-lock
                       where desp-imp.cod-desp = desp-embarque.cod-desp:
                   end.
                   if avail desp-imp                              
                       and desp-imp.inc-val-frete       = yes
                       or  desp-imp.inc-val-seguro      = yes
                       or  desp-imp.inc-val-embal       = yes
                       or  desp-imp.inc-val-outras-desp = yes then do:  
                            
                       /*Cria temp-table de despesa*/
                       create tt-desp-embarque.
                       assign tt-desp-embarque.cod-desp          = desp-embarque.cod-desp
                              tt-desp-embarque.desc-desp         = IF desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE IF AVAIL desp-imp THEN desp-imp.descricao ELSE "":U
                              tt-desp-embarque.cod-emitente-desp = desp-embarque.cod-emitente-desp
                              tt-desp-embarque.embarque          = desp-embarque.embarque
                              tt-desp-embarque.cod-pto-contr     = desp-embarque.cod-pto-contr
                              tt-desp-embarque.moeda             = desp-embarque.mo-codigo
                              tt-desp-embarque.cond-pagto        = desp-embarque.cod-cond-pag
                              tt-desp-embarque.val-desp          = desp-embarque.val-desp
                              tt-desp-embarque.r-rowid           = rowid(desp-embarque)
                              tt-desp-embarque.selecionado       = no
                              tt-desp-embarque.cod-estabel       = desp-embarque.cod-estabel
                              tt-desp-embarque.cod-itiner        = desp-embarque.cod-itiner.

                       /*Busca Nome-abrev do emitente*/
                       for first emitente fields (cod-emitente nome-abrev) no-lock
                           where emitente.cod-emitente = desp-embarque.cod-emitente-desp:
                       end.
                       if avail emitente then
                           assign tt-desp-embarque.nome-abrev = emitente.nome-abrev.

                       /*Busca descriá∆o do ponto de controle*/
                       for first pto-contr no-lock
                           where pto-contr.cod-pto-contr = desp-embarque.cod-pto-contr:
                       end.
                       assign tt-desp-embarque.desc-pto = IF historico-embarque.descricao <> "":U THEN historico-embarque.descricao ELSE pto-contr.descricao WHEN AVAIL pto-contr.
                   end.
               end.
           end.
           else do:
               for each  desp-embarque no-lock
                   where desp-embarque.cod-estabel       =  historico-embarque.cod-estabel
                   and   desp-embarque.embarque          =  historico-embarque.embarque
                   and   desp-embarque.cod-itiner        =  historico-embarque.cod-itiner
                   and   desp-embarque.cod-pto-contr     =  historico-embarque.cod-pto-contr
                   and   desp-embarque.cod-desp          >= pcod-desp-ini
                   and   desp-embarque.cod-desp          <= pcod-desp-fim
                   and   desp-embarque.cod-emitente-desp >= pfornec-desp-ini
                   and   desp-embarque.cod-emitente-desp <= pfornec-desp-fim
                   and  
                   &if "{&bf_mat_versao_ems}" >= "2.04" and "{&bf_mat_versao_ems}" < "2.06" &then
                       desp-embarque.log-1 = no                       /*Despesa n∆o pode ser recebida*/
                   &elseif "{&bf_mat_versao_ems}" >= "2.06" &then
                       desp-embarque.log-despes-ja-recbda = no        /*Despesa n∆o pode ser recebida*/
                   &endif:
                   
                   /*Despesa deve incidir no valor de frete/seguro/embalagem/outras (pelo menos um dos campos tem que estar marcado)*/
                   for first desp-imp no-lock
                       where desp-imp.cod-desp = desp-embarque.cod-desp:
                   end.
                   if avail desp-imp                              
                       and desp-imp.inc-val-frete       = yes
                       or  desp-imp.inc-val-seguro      = yes
                       or  desp-imp.inc-val-embal       = yes
                       or  desp-imp.inc-val-outras-desp = yes then do:  

                       /*Cria temp-table de despesa*/
                       create tt-desp-embarque.
                       assign tt-desp-embarque.cod-desp          = desp-embarque.cod-desp
                              tt-desp-embarque.desc-desp         = IF desp-embarque.descricao <> "":U THEN desp-embarque.descricao ELSE IF AVAIL desp-imp THEN desp-imp.descricao ELSE "":U
                              tt-desp-embarque.cod-emitente-desp = desp-embarque.cod-emitente-desp
                              tt-desp-embarque.embarque          = desp-embarque.embarque
                              tt-desp-embarque.cod-pto-contr     = desp-embarque.cod-pto-contr
                              tt-desp-embarque.moeda             = desp-embarque.mo-codigo
                              tt-desp-embarque.cond-pagto        = desp-embarque.cod-cond-pag
                              tt-desp-embarque.val-desp          = desp-embarque.val-desp
                              tt-desp-embarque.r-rowid           = rowid(desp-embarque)
                              tt-desp-embarque.selecionado       = no
                              tt-desp-embarque.cod-estabel       = desp-embarque.cod-estabel
                              tt-desp-embarque.cod-itiner        = desp-embarque.cod-itiner.
                         
                       /*Busca Nome-abrev do emitente*/
                       for first emitente fields (cod-emitente nome-abrev) no-lock
                           where emitente.cod-emitente = desp-embarque.cod-emitente-desp:
                       end.
                       if avail emitente then
                           assign tt-desp-embarque.nome-abrev = emitente.nome-abrev.

                       /*Busca descriá∆o do ponto de controle*/
                       for first pto-contr no-lock
                           where pto-contr.cod-pto-contr = desp-embarque.cod-pto-contr:
                       end.
                        
                       assign tt-desp-embarque.desc-pto = IF historico-embarque.descricao <> "":U THEN historico-embarque.descricao ELSE pto-contr.descricao WHEN AVAIL pto-contr.
                    end.
               end.
           end.
       end.
   end.

   
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

