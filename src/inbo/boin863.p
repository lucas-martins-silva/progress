/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN863 2.00.00.006 } /*** "010006" 01/12/2023 10:51:03  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin863 MUT}
&ENDIF

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

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN863
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName estab-mater-cenar
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
{inbo/boin863.i RowObject}
{btb/btb009za.i}
/*Temp-table EMS5 - Retorna cen†rios cont†beis v†lidos*/
def temp-table tt_cenar_ctbl_ems5 no-undo
         field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen†rio Cont†bil" column-label "Cen†rio Cont†bil"
         field tta_des_cenar_ctbl               as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o"
         field tta_log_cenar_ifrs               as logical format "Sim/N∆o" initial no label "Cen†rio IFRS" column-label "Cen†rio IFRS"
         field tta_log_cenar_fisc               as logical format "Sim/N∆o" initial no label "Cen†rio Fiscal" column-label "Cen†rio Fiscal"
         field ttv_log_permis_cenar_usuar       as logical format "Sim/N∆o" initial no
        .
def temp-table tt_erro_fgl no-undo
         field ttv_num_erro_fgl                 as integer format "9999999"
         field ttv_des_erro_fgl                 as character format "x(100)"
         field ttv_des_arq_erro                 as character format "x(100)"
         field ttv_log_ctbz                     as logical format "Sim/N∆o" initial yes label "Contabiliza Movto" column-label "Contabiliza Movto".

DEFINE TEMP-TABLE ttestab-mater-cenar NO-UNDO LIKE estab-mater-cenar
       field des_cenar_ctbl as CHARACTER
       field r-rowid as rowid.

DEF NEW GLOBAL SHARED VAR i-ep-codigo-usuario LIKE empresa.ep-codigo NO-UNDO.
/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}

/* Variaveis necessarias aos setConstraint's */
DEF VAR c-cod-ini       AS CHAR NO-UNDO.
DEF VAR c-cod-fim       AS CHAR NO-UNDO.
DEF VAR c-desc-ini      AS CHAR NO-UNDO.
DEF VAR c-desc-fim      AS CHAR NO-UNDO.

DEF VAR l-conectou-ems5 AS LOG  NO-UNDO.
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
        WHEN "cod-cenar-ctbl":U THEN ASSIGN pFieldValue = RowObject.cod-cenar-ctbl.
        WHEN "cod-estab":U THEN ASSIGN pFieldValue = RowObject.cod-estab.
        WHEN "cod-livre-1":U THEN ASSIGN pFieldValue = RowObject.cod-livre-1.
        WHEN "cod-livre-2":U THEN ASSIGN pFieldValue = RowObject.cod-livre-2.
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
        WHEN "contab-ate":U THEN ASSIGN pFieldValue = RowObject.contab-ate.
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
        WHEN "cdn-moeda":U THEN ASSIGN pFieldValue = RowObject.cdn-moeda.
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
  Purpose:     Retorna valores dos campos do °ndice estab-cenar
  Parameters:  
               retorna valor do campo cod-estab
               retorna valor do campo cod-cenar-ctbl
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estab LIKE estab-mater-cenar.cod-estab NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-cenar-ctbl LIKE estab-mater-cenar.cod-cenar-ctbl NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-estab = RowObject.cod-estab
           pcod-cenar-ctbl = RowObject.cod-cenar-ctbl.

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
        WHEN "log-cenar-fisc":U THEN ASSIGN pFieldValue = RowObject.log-cenar-fisc.
        WHEN "log-cenar-ifrs":U THEN ASSIGN pFieldValue = RowObject.log-cenar-ifrs.
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram  
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal da BO.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   OPEN QUERY {&QueryName} FOR EACH estab-mater-cenar NO-LOCK INDEXED-REPOSITION.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram  
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice estab-cenar
  Parameters:  
               recebe valor do campo cod-estab
               recebe valor do campo cod-cenar-ctbl
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estab LIKE estab-mater-cenar.cod-estab NO-UNDO.
    DEFINE INPUT PARAMETER pcod-cenar-ctbl LIKE estab-mater-cenar.cod-cenar-ctbl NO-UNDO.

    FIND FIRST bfestab-mater-cenar WHERE 
        bfestab-mater-cenar.cod-estab = pcod-estab AND 
        bfestab-mater-cenar.cod-cenar-ctbl = pcod-cenar-ctbl NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfestab-mater-cenar THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfestab-mater-cenar)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroCodigo DBOProgram 
PROCEDURE setConstraintFiltroCodigo :
/*------------------------------------------------------------------------------
 Purpose:    Seta as vari†veis de controle para queries contendo
              a unidade de medida inicial e final. 
  Parameters: ipar1:p-un-ini:Unid Medida Inicial
              ipar2:p-un-fim:Unid Medida Final
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter p-cod-ini as char no-undo.
   def input parameter p-cod-fim as char no-undo.
   
     assign c-cod-ini = p-cod-ini
            c-cod-fim = p-cod-fim.

   
   
   RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroDescricao DBOProgram 
PROCEDURE setConstraintFiltroDescricao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-desc-ini as char no-undo.
def input param p-desc-fim as char no-undo.

    assign c-desc-ini = p-desc-ini
           c-desc-fim = p-desc-fim.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTestab-mater-cenar DBOProgram 
PROCEDURE carregaTTestab-mater-cenar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:
  Notes:
------------------------------------------------------------------------------*/

    def input param pi-page-number as int no-undo.
    def output param table for ttestab-mater-cenar.
    DEFINE VARIABLE v_hdl_cenar AS HANDLE      NO-UNDO.

    Run  pi-conecta-ems50( 1). /*Conecta bancos EMS5*/
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "adm-error".
    ELSE DO:
        run prgfin/fgl/fgl920za.py persistent set v_hdl_cenar.
        run  pi_main_retorna_cenar_ctbl_empres_1 in v_hdl_cenar(input i-ep-codigo-usuario,
                                                             input today,
                                                             output table tt_cenar_ctbl_ems5,
                                                             output table tt_erro_fgl).
        DELETE PROCEDURE v_hdl_cenar.
        ASSIGN v_hdl_cenar = ?.
        EMPTY TEMP-TABLE ttestab-mater-cenar.
        IF pi-page-number = 1 THEN DO:
            FOR each tt_cenar_ctbl_ems5 
               WHERE tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl >= c-cod-ini 
                 AND tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl <= c-cod-fim:
    
                CREATE ttestab-mater-cenar.
                ASSIGN ttestab-mater-cenar.cod-cenar-ctbl = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl            
                       ttestab-mater-cenar.des_cenar_ctbl = tt_cenar_ctbl_ems5.tta_des_cenar_ctbl             
                       ttestab-mater-cenar.log-cenar-ifrs = tt_cenar_ctbl_ems5.tta_log_cenar_ifrs               
                       ttestab-mater-cenar.log-cenar-fisc = tt_cenar_ctbl_ems5.tta_log_cenar_fisc.               
            END.
        END.
        ELSE DO:
           FOR each tt_cenar_ctbl_ems5 
              WHERE tt_cenar_ctbl_ems5.tta_des_cenar_ctbl >= c-desc-ini 
                AND tt_cenar_ctbl_ems5.tta_des_cenar_ctbl <= c-desc-fim:
          
                CREATE ttestab-mater-cenar.
                ASSIGN ttestab-mater-cenar.cod-cenar-ctbl = tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl            
                       ttestab-mater-cenar.des_cenar_ctbl = tt_cenar_ctbl_ems5.tta_des_cenar_ctbl             
                       ttestab-mater-cenar.log-cenar-ifrs = tt_cenar_ctbl_ems5.tta_log_cenar_ifrs               
                       ttestab-mater-cenar.log-cenar-fisc = tt_cenar_ctbl_ems5.tta_log_cenar_fisc.  
           END.
        END.
    END.
    IF l-conectou-ems5 THEN
        Run  pi-conecta-ems50( 2). /*Desconecta bancos EMS5*/

   return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-conecta-ems50 DBOProgram 
Procedure Pi-conecta-ems50:
    def input param i-conect as integer no-undo.
    DEF VAR h-btb009za AS HANDLE NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    if not valid-handle (h-btb009za) or
       h-btb009za:TYPE <> "PROCEDURE":U or
       h-btb009za:FILE-NAME <> "btb/btb009za.p":U  then
       RUN btb/btb009za.p PERSISTENT SET h-btb009za.
    
    if i-conect = 1 then do:
       if not connected("emsbas") or 
          not connected("emsuni") or 
          not connected("emsfin") then do:          
         
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U then do:
               ASSIGN l-conectou-ems5 = YES.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.
        else
    end.
    else do:
        if connected("emsbas") or 
           connected("emsfin") or 
           connected("emsuni") then do:
           
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U then do:
               ASSIGN l-conectou-ems5 = NO.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.    
    end.
    
    if valid-handle(h-btb009za) then do:
        delete procedure h-btb009za no-error.
        assign h-btb009za = ?.
    end.
    if return-value <> "OK":U then do:
        FOR EACH tt_erros_conexao:
            CREATE RowErrors.
            assign RowErrors.ErrorNumber      = tt_erros_conexao.cd-erro
                   RowErrors.ErrorType        = "EMS":u
                   RowErrors.ErrorSubType     = "ERROR":u
                   ErrorParameters = tt_erros_conexao.param-1.

        END.
    end.    
    RETURN "OK":U.

End Procedure. /*Pi-conecta-ems50*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
