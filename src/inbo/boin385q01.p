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
{include/i-prgvrs.i BOIN385Q01 2.00.00.011} /*** "010011" 24/11/2023 13:25:23  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin385q01 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ² um programa PROGRESS
                 que cont²m a l½gica de neg½cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini»’o ---*/
&GLOBAL-DEFINE DBOName tt-solicitacao
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&scoped-define FIRST-TABLE-IN-QUERY tt-solicitacao
&GLOBAL-DEFINE TableName tt-solicitacao
&GLOBAL-DEFINE TableLabel tt-solicitacao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin385.p) est  com as fun‡äes de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque Sà nela foram implementadas as triggers do dicion rio.
**  Para desabilitar as procedures foram usados os pr‚-processadores abaixo.
**  A procedure validateRecord dessa DBO nÆo deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{include/boini.i}
{inbo/boin385q01.i tt-solicitacao}
{inbo/boin385q01.i RowObject}


/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram



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
         HEIGHT             = 2.01
         WIDTH              = 60.43.
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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    assign rowobject.r-rowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRowid DBOProgram 
PROCEDURE afterGetRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE input-output PARAMETER pRowid  AS ROWID NO-UNDO.

    ASSIGN pRowid = {&TableName}.r-rowid.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeRepositionRecord DBOProgram 
PROCEDURE beforeRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona query
  Parameters:  recebe rowid da tabela {&TableName}
  Notes:       Atualiza temptable RowObject (_copyBuffer2TT)
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    find {&TableName} where {&TableName}.r-rowid = pRowid no-lock no-error.
    
    assign pRowid = rowid({&TableName}).
    
    /*--- Reposiciona query ---*/
    REPOSITION {&QueryName} TO ROWID pRowid NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
        /*--- Erro 11: NÆo foi poss¡vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*---  necess rio para o correto funcionamento do reposicionamento ---*/
    GET NEXT {&QueryName} NO-LOCK.
    
    /*--- Seta flag indicando que o registro atual foi reposicionado ---*/
    &IF "{&DBType}" = "ORACLE":U &THEN
        ASSIGN lRepositioned = YES.
    &ENDIF
    
    /*--- Atualiza temptable RowObject ---*/
    RUN _copyBuffer2TT IN THIS-PROCEDURE.
    
    
    RETURN "NOK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraSolicitacoesPendenciasComprador DBOProgram 
PROCEDURE geraSolicitacoesPendenciasComprador :
/*------------------------------------------------------------------------------
  Purpose:     
    Gera solicita‡äes para a consulta de pendˆncias do 
    comprador do m¢dulo de compras.
  Parameters: 
    ipar1  : p-cod-comprado      : C¢digo do comprador
    ipar2  : p-nr-requisicao-ini : Nr da requisi‡Æo inicial
    ipar3  : p-nr-requisicao-fim : Nr da requisi‡Æo final
    ipar4  : p-cod-estabel-ini   : C¢d do estab. inicial
    ipar5  : p-cod-estabel-fim   : C¢d do estab. final
    ipar6  : p-dt-requisicao-ini : Data da requisi‡Æo inicial
    ipar7  : p-dt-requisicao-fim : Data da requisi‡Æo final
    ipar8  : p-it-codigo-ini     : C¢digo do item inicial
    ipar9  : p-it-codigo-fim     : C¢digo do item final 
    ipar10 : p-dt-previsao-ini   : Data da previsao de entrega inicial
    ipar11 : p-dt-previsao-fim   : Data da previsao de entrega final
    ipar12 : p-familia-ini       : C¢digo da familia inicial
    ipar13 : p-familia-fim       : C¢digo da familia final     
    ipar12 : p-nome-abrev-ini    : Requisitante inicial
    ipar13 : p-nome-abrev-fim    : Requisitante final         
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-cod-comprado as char.
    def input param p-nr-requisicao-ini as int  no-undo.
    def input param p-nr-requisicao-fim as int  no-undo.
    def input param p-cod-estabel-ini   as char no-undo.
    def input param p-cod-estabel-fim   as char no-undo.
    def input param p-dt-requisicao-ini as date no-undo.
    def input param p-dt-requisicao-fim as date no-undo.
    def input param p-it-codigo-ini     as char no-undo.
    def input param p-it-codigo-fim     as char no-undo.
    def input param p-dt-previsao-ini   as date no-undo.
    def input param p-dt-previsao-fim   as date no-undo.
    def input param p-familia-ini       as char no-undo.
    def input param p-familia-fim       as char no-undo.
    def input param p-nome-abrev-ini    as char no-undo.
    def input param p-nome-abrev-fim    as char no-undo.

    def var i-cont as integer no-undo format "99999".
    
    for each tt-solicitacao:
        delete tt-solicitacao.
    end.

    assign i-cont = 0.
   
    FOR EACH requisicao WHERE 
        (requisicao.tp-requis         = 2 or requisicao.tp-requis      = 3)
        AND requisicao.situacao       = 1
        AND requisicao.estado         = 1
        AND requisicao.nr-requisicao >= p-nr-requisicao-ini
        AND requisicao.nr-requisicao <= p-nr-requisicao-fim
        AND requisicao.cod-estabel   >= p-cod-estabel-ini
        AND requisicao.cod-estabel   <= p-cod-estabel-fim     
        AND requisicao.dt-requisicao >= p-dt-requisicao-ini
        AND requisicao.dt-requisicao <= p-dt-requisicao-fim
        AND requisicao.nome-abrev    >= p-nome-abrev-ini
        AND requisicao.nome-abrev    <= p-nome-abrev-fim        
        no-lock:
     
        for each it-requisicao 
            where it-requisicao.nr-requisicao = requisicao.nr-requisicao
              and it-requisicao.it-codigo  >= p-it-codigo-ini
              and it-requisicao.it-codigo  <= p-it-codigo-fim
              and it-requisicao.situacao   <> 4 
              and it-requisicao.dt-entrega >= p-dt-previsao-ini
              and it-requisicao.dt-entrega <= p-dt-previsao-fim
              no-lock:
           
            find item where item.it-codigo = it-requisicao.it-codigo no-lock no-error.
            
            if substring(it-requisicao.char-1,2,12) <> "" then do:
                find comprador where  
                     comprador.cod-comprado = substring(it-requisicao.char-1,2,12)
                     no-lock no-error.
                if avail comprador and comprador.cod-comprado <> p-cod-comprado then next.
                if substring(it-requisicao.char-1,2,12) <> p-cod-comprado then next.
            end.         
            else do:
                if  avail item 
                and item.cod-comprado <> p-cod-comprado then next.
            end.
                
            for each familia where 
                     familia.fm-codigo  = item.fm-codigo and
                     familia.fm-codigo >= p-familia-ini  and
                     familia.fm-codigo <= p-familia-fim no-lock :
            
                assign i-cont = i-cont + 1.
                create tt-solicitacao.
                assign tt-solicitacao.nr-requisicao  = it-requisicao.nr-requisicao
                       tt-solicitacao.cod-estabel    = requisicao.cod-estabel
                       tt-solicitacao.it-codigo      = it-requisicao.it-codigo
                       tt-solicitacao.cod-depos      = it-requisicao.cod-depos
                       tt-solicitacao.loc-entrega    = requisicao.loc-entrega
                       tt-solicitacao.qt-requisitada = it-requisicao.qt-requisitada
                       tt-solicitacao.qt-atendida    = it-requisicao.qt-atendida
                       tt-solicitacao.qt-devolvida   = it-requisicao.qt-devolvida
                       tt-solicitacao.dt-requisicao  = requisicao.dt-requisicao
                       tt-solicitacao.dt-atend       = it-requisicao.dt-atend
                       tt-solicitacao.dt-devol       = requisicao.dt-devol
                       tt-solicitacao.narrativa      = it-requisicao.narrativa
                       tt-solicitacao.item-narrat    = item.narrativa
                       tt-solicitacao.r-it-requis    = rowid(it-requisicao)
                       tt-solicitacao.r-rowid        = to-rowid("0x0" + string(i-cont,"99999")).

                if avail item then do:
                    if item.it-codigo = "" and item.tipo-contr = 4  /* debito direto */
                    then assign tt-solicitacao.desc-item = substr(it-requisicao.narrativa,1,60).
                    else assign tt-solicitacao.desc-item = item.desc-item.
                end.

/*                find item where 
 *                      item.it-codigo = it-requisicao.it-codigo 
 *                      no-lock no-error.
 *                 if avail item then do:
 *                     find ordem-compra where 
 *                          ordem-compra.it-codigo = item.it-codigo 
 *                          no-lock no-error.
 *                     if avail ordem-compra and item.it-codigo = ""  
 *                     then assign tt-solicitacao.desc-item = substr(ordem-compra.narrativa,1,60).
 *                     else assign tt-solicitacao.desc-item = item.desc-item.
 *                 end.*/
            end.
        end.
    end.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.        
        WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "loc-entrega":U THEN ASSIGN pFieldValue = RowObject.loc-entrega.
        WHEN "narrativa":U THEN ASSIGN pFieldValue   = RowObject.narrativa.
        WHEN "item-narrat":U THEN ASSIGN pFieldValue   = RowObject.item-narrat.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-atend":U THEN ASSIGN pFieldValue = RowObject.dt-atend.
        WHEN "dt-devol":U THEN ASSIGN pFieldValue = RowObject.dt-devol.
        WHEN "dt-requisicao":U THEN ASSIGN pFieldValue = RowObject.dt-requisicao.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-requisitada":U THEN ASSIGN pFieldValue = RowObject.qt-requisitada.
        WHEN "qt-atendida":U THEN ASSIGN pFieldValue = RowObject.qt-atendida.
        WHEN "qt-devolvida":U THEN ASSIGN pFieldValue = RowObject.qt-devolvida.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice ESTAB-REQ
  Parameters:
               retorna valor dos campos do ­ndice ESTAB-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE requisicao.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pnr-requisicao = RowObject.nr-requisicao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidField DBOProgram 
PROCEDURE getRowidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo ROWID
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS ROWID NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "r-rowid":U THEN ASSIGN pFieldValue = RowObject.r-rowid.
        WHEN "r-it-requis":U THEN ASSIGN pFieldValue = RowObject.r-it-requis.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ­ndice ESTAB-REQ
  Parameters:
               recebe valor dos campos do ­ndice ESTAB-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE requisicao.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-requisicao LIKE requisicao.nr-requisicao NO-UNDO.

    FIND FIRST bftt-solicitacao WHERE
        bftt-solicitacao.cod-estabel = pcod-estabel AND
        bftt-solicitacao.nr-requisicao = pnr-requisicao
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-solicitacao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-solicitacao)).
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
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

 define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
           RUN openQueryStatic (input "Main":U).       
    end case.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH tt-solicitacao NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida»’o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


