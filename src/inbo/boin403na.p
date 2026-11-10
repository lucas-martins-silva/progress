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
{include/i-prgvrs.i BOIN403NA 2.00.00.007 } /*** "010007" 02/06/2026 09:06:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin403na MUT}
&ENDIF

/*--------------------------------------------------------------------------
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

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN403
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName saldo-estoq
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE XMLReceiver YES  
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES







/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin403.i RowObject}




/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}


/** Temp-table Saldo de Estoque do Magnus **/
{utp/ut-glob.i}
{btb/btb008za.i0}
{cdp/cdcfgmnt.i}  /* PrÇ-processadores de vers‰es da Manutená∆o Industrial */
{cdp/cdcfgmat.i}  /* PrÇ-processadores de vers‰es de Materias */
{cdp/cdcfgman.i}  /* PrÇ-processadores de vers‰es da Manufatura */

def temp-table tt-saldo-magnus
    field char-1          as character       format 'x(255)'
    field char-2          as character       format 'x(255)'
    field cod-depos       as character       format 'x(3)'
&IF "{&mguni_version}" >= "2.071" &THEN
    field cod-estabel     as character       format "x(05)"
&ELSE
    field cod-estabel     as character       format 'x(3)'
&ENDIF
    field cod-refer       as character       format 'x(8)'
    field concentracao    as decimal         format '>>>9,9999'
    field data-ult-ent    as date            format '99/99/9999'
    field dec-1           as decimal         format '->>>>>>>>>>>9.99999999'
    field dec-2           as decimal         format '->>>>>>>>>>>9.99999999'
    field dt-ul-contag    as date            format '99/99/9999'
    field dt-vali-lote    as date            format '99/99/9999'
    field int-1           as integer         format '->>>>>>>>>9'
    field int-2           as integer         format '->>>>>>>>>9'
    field it-codigo       as character       format 'x(16)'
    field localizacao     as character       format 'x(10)'
    field log-1           as logical         format 'Sim/Nao'
    field log-2           as logical         format 'Sim/Nao'    
    field lote            as character       format 'x(10)'
    field qt-aloc-ped     as decimal         format '>>>>,>>9.9999'
    field qt-aloc-prod    as decimal         format '>>>>,>>9.9999'
    field qt-alocada      as decimal         format '>>>>,>>9.9999'
    field qtidade-atu     as decimal         format '->>>,>>>,>>9.9999'
    field qtidade-fin     as decimal         format '->>>,>>>,>>9.9999'
    field qtidade-ini     as decimal         format '->>>,>>>,>>9.9999'
    field rendimento      as decimal         format '>>>9,9999'
    field u-char-1        as character       format 'x(255)'
    field u-char-2        as character       format 'x(255)'
    field l-data          as logical
    field l-saldo-estoq   as logical
    field i-funcao        as integer
    field de-quant-req    as decimal
    field rw-saldo-estoq  as rowid
   INDEX deposito   cod-depos
                    cod-estabel
                    it-codigo.

DEFINE TEMP-TABLE tt-saldo LIKE saldo-estoq.

DEFINE TEMP-TABLE RowObjectExtra NO-UNDO
    FIELD r-Rowid         AS ROWID
    FIELD desc-depos      AS CHAR
    FIELD desc-localiz    AS CHAR
    FIELD saldoDisponivel AS DECIMAL.



/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def var c-lote like saldo-estoq.lote no-undo.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  def var h-ceapi030      as handle no-undo.
  def var l-retorno       as log    no-undo.
  def var l-lote-avancado as log    no-undo.

  {cep/ceapi030.i}
  {cdp/cd0666.i}

  def temp-table tt-saldo-estoq no-undo like rowObject
      field de-saldo like saldo-estoq.qtidade-atu.
&endif

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
         HEIGHT             = 2.08
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT :
    FIND FIRST deposito NO-LOCK WHERE deposito.cod-depos = {&TableName}.cod-depos NO-ERROR.
   FIND FIRST localizacao NO-LOCK 
         WHERE localizacao.cod-estabel = {&TableName}.cod-estabel
           AND localizacao.cod-localiz = {&TableName}.cod-localiz
           AND localizacao.cod-depos   = deposito.cod-depos NO-ERROR.
           
           
    CREATE RowObjectExtra.
    ASSIGN RowObjectExtra.r-Rowid = ROWID({&TableName})
           RowObjectExtra.saldoDisponivel   = saldo-estoq.qtidade-atu  -
                                              saldo-estoq.qt-alocada   -
                                              saldo-estoq.qt-aloc-prod -
                                              saldo-estoq.qt-aloc-ped 
           RowObjectExtra.desc-depos = deposito.nome
           RowObjectExtra.desc-localiz = localizacao.descricao
         .
 
   
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
    DEFINE INPUT PARAMETER p-rowid-se AS ROWID NO-UNDO.

    FIND FIRST saldo-estoq WHERE ROWID(saldo-estoq) = p-rowid-se EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL saldo-estoq THEN
        ASSIGN saldo-estoq.dt-vali-lote = p-dt-validade.
    
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
        WHEN "cd-referencia":U THEN ASSIGN pFieldValue = RowObject.cd-referencia.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
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
        WHEN "data-ult-ent":U THEN ASSIGN pFieldValue = RowObject.data-ult-ent.
        WHEN "dt-fabric":U THEN ASSIGN pFieldValue = RowObject.dt-fabric.
        WHEN "dt-ul-contag":U THEN ASSIGN pFieldValue = RowObject.dt-ul-contag.
        WHEN "dt-vali-lote":U THEN ASSIGN pFieldValue = RowObject.dt-vali-lote.
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
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qt-aloc-ped":U THEN ASSIGN pFieldValue = RowObject.qt-aloc-ped.
        WHEN "qt-aloc-prod":U THEN ASSIGN pFieldValue = RowObject.qt-aloc-prod.
        WHEN "qt-alocada":U THEN ASSIGN pFieldValue = RowObject.qt-alocada.
        WHEN "qtidade-atu":U THEN ASSIGN pFieldValue = RowObject.qtidade-atu.
        WHEN "qtidade-fin":U THEN ASSIGN pFieldValue = RowObject.qtidade-fin.
        WHEN "qtidade-ini":U THEN ASSIGN pFieldValue = RowObject.qtidade-ini.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
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
        WHEN "num-id-saldo-estoq":U THEN ASSIGN pFieldValue = RowObject.num-id-saldo-estoq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice item
  Parameters:  
               retorna valor do campo it-codigo
               retorna valor do campo cod-estabel
               retorna valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE saldo-estoq.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE saldo-estoq.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE saldo-estoq.cod-refer NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo
           pcod-estabel = RowObject.cod-estabel
           pcod-refer = RowObject.cod-refer.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowObjectExtra DBOProgram 
PROCEDURE getRowObjectExtra :
DEFINE OUTPUT PARAMETER TABLE FOR RowObjectExtra.
        
        
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice item
  Parameters:  
               recebe valor do campo it-codigo
               recebe valor do campo cod-estabel
               recebe valor do campo cod-refer
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE saldo-estoq.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-estabel LIKE saldo-estoq.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE saldo-estoq.cod-refer NO-UNDO.

    FIND FIRST bfsaldo-estoq WHERE 
        bfsaldo-estoq.it-codigo = pit-codigo AND 
        bfsaldo-estoq.cod-estabel = pcod-estabel AND 
        bfsaldo-estoq.cod-refer = pcod-refer NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfsaldo-estoq THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfsaldo-estoq)).
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
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/


    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK 
        where {&TableName}.lote = c-lote INDEXED-REPOSITION.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaSaldo DBOProgram 
PROCEDURE piRetornaSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if '{&bf_lote_avancado_liberado}' = 'yes' &then

def input param p-it-codigo         like item.it-codigo          no-undo.
def input param p-cod-estabel       like estabelec.cod-estabel   no-undo.
def input param p-retorno-vl-zerado as log                       no-undo.
def output param p-quantidade       like saldo-estoq.qtidade-atu no-undo.
def output param table for tt-saldo-estoq.

if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                         funcao.ativo) then do:

    assign l-lote-avancado = yes.

    if not valid-handle(h-ceapi030) then
        run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                      output table tt-valores,
                                                      output table tt-erro).
end.

empty temp-table tt-saldo-estoq.

assign p-quantidade = 0.

for each saldo-estoq use-index item where saldo-estoq.it-codigo   = p-it-codigo and
                                          saldo-estoq.cod-estabel = p-cod-estabel no-lock,
    first item where item.it-codigo = saldo-estoq.it-codigo no-lock,
    first deposito fields (cod-depos cons-saldo)
    where deposito.cod-depos = saldo-estoq.cod-depos and
          deposito.cons-saldo no-lock:
    
    if saldo-estoq.dt-vali-lote <> ? and 
       saldo-estoq.dt-vali-lote < today then 
        next.    

    create tt-saldo-estoq.
    buffer-copy saldo-estoq to tt-saldo-estoq.

    if l-lote-avancado and
       item.tipo-con-est > 2 then do:

        run pi-identifica-saldo in h-ceapi030 (input 1,
                                               input saldo-estoq.it-codigo,
                                               input saldo-estoq.cod-estabel,
                                               input saldo-estoq.lote,
                                               input 0,
                                               output l-retorno,
                                               output table tt-valores2,
                                               output table tt-erro).

        if return-value = "nok":u or
          (return-value = "ok":u and
           not l-retorno ) then
            assign tt-saldo-estoq.de-saldo = 0.
        else
            assign tt-saldo-estoq.de-saldo = saldo-estoq.qtidade-atu - (tt-saldo-estoq.qt-alocada   +
                                                                        tt-saldo-estoq.qt-aloc-prod +
                                                                        tt-saldo-estoq.qt-aloc-ped).
    end.
    else
        assign tt-saldo-estoq.de-saldo = saldo-estoq.qtidade-atu - (tt-saldo-estoq.qt-alocada   +
                                                                    tt-saldo-estoq.qt-aloc-prod +
                                                                    tt-saldo-estoq.qt-aloc-ped).

    if not p-retorno-vl-zerado and
       tt-saldo-estoq.de-saldo = 0 then
        delete tt-saldo-estoq.
    else
        assign p-quantidade = p-quantidade + tt-saldo-estoq.de-saldo.

end.
&endif

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaSaldoDisponivel DBOProgram 
PROCEDURE piRetornaSaldoDisponivel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if '{&bf_lote_avancado_liberado}' = 'yes' &then

def input param p-cod-estabel-ini   like estabelec.cod-estabel   no-undo.
def input param p-cod-estabel-fim   like estabelec.cod-estabel   no-undo.
def input param p-cod-depos-ini     like deposito.cod-depos      no-undo.
def input param p-cod-depos-fim     like deposito.cod-depos      no-undo.
def input param p-it-codigo-ini     like item.it-codigo          no-undo.
def input param p-it-codigo-fim     like item.it-codigo          no-undo.
def input param p-cod-refer-ini     like saldo-estoq.cod-refer   no-undo.
def input param p-cod-refer-fim     like saldo-estoq.cod-refer   no-undo.
def input param p-lote-ini          like saldo-estoq.lote        no-undo.
def input param p-lote-fim          like saldo-estoq.lote        no-undo.
def input param p-cod-localiz-ini   like saldo-estoq.cod-localiz no-undo.
def input param p-cod-localiz-fim   like saldo-estoq.cod-localiz no-undo.
def input param p-retorno-vl-zerado as log                       no-undo.
def output param p-quantidade       like saldo-estoq.qtidade-atu no-undo.
def output param table for tt-saldo-estoq.

if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                         funcao.ativo) then do:

    assign l-lote-avancado = yes.

    if not valid-handle(h-ceapi030) then
        run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                      output table tt-valores,
                                                      output table tt-erro).
end.

assign p-quantidade = 0.

empty temp-table tt-saldo-estoq.

for each saldo-estoq where saldo-estoq.cod-depos   >= p-cod-depos-ini and
                           saldo-estoq.cod-depos   <= p-cod-depos-fim and
                           saldo-estoq.cod-estabel >= p-cod-estabel-ini and
                           saldo-estoq.cod-estabel <= p-cod-estabel-fim and
                           saldo-estoq.cod-localiz >= p-cod-localiz-ini and
                           saldo-estoq.cod-localiz <= p-cod-localiz-fim and
                           saldo-estoq.lote        >= p-lote-ini and
                           saldo-estoq.lote        <= p-lote-fim and
                           saldo-estoq.it-codigo   >= p-it-codigo-ini and
                           saldo-estoq.it-codigo   <= p-it-codigo-fim and
                           saldo-estoq.cod-refer   >= p-cod-refer-ini and
                           saldo-estoq.cod-refer   <= p-cod-refer-fim NO-LOCK,
    first item where item.it-codigo = saldo-estoq.it-codigo NO-LOCK:

    create tt-saldo-estoq.
    buffer-copy saldo-estoq to tt-saldo-estoq.

    if l-lote-avancado and
       item.tipo-con-est > 2 then do:
    
        run pi-identifica-saldo in h-ceapi030 (input 1,
                                               input saldo-estoq.it-codigo,
                                               input saldo-estoq.cod-estabel,
                                               input saldo-estoq.lote,
                                               input 0,
                                               output l-retorno,
                                               output table tt-valores2,
                                               output table tt-erro).
        if return-value = "ok":u then do:
            if not l-retorno then
                assign tt-saldo-estoq.de-saldo = 0.
            else
                assign tt-saldo-estoq.de-saldo = tt-saldo-estoq.qtidade-atu - (tt-saldo-estoq.qt-alocada   +
                                                                               tt-saldo-estoq.qt-aloc-prod +
                                                                               tt-saldo-estoq.qt-aloc-ped).
        end.
    end.
    else
        assign tt-saldo-estoq.de-saldo = tt-saldo-estoq.qtidade-atu - (tt-saldo-estoq.qt-alocada   +
                                                                       tt-saldo-estoq.qt-aloc-prod +
                                                                       tt-saldo-estoq.qt-aloc-ped).

   if not p-retorno-vl-zerado and
      tt-saldo-estoq.de-saldo = 0 then
       delete tt-saldo-estoq.
   else
       assign p-quantidade = p-quantidade + tt-saldo-estoq.de-saldo.
       
end.

&endif

return "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintLote DBOProgram 
PROCEDURE setConstraintLote :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-lote like saldo-estoq.lote no-undo.

    assign c-lote = p-lote.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

