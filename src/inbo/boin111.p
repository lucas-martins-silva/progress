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
{include/i-prgvrs.i BOIN111 2.00.00.017 } /*** "010017" 03/01/2024 14:59:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin111 MUT}
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
&GLOBAL-DEFINE DBOName estrutura
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName estrutura
&GLOBAL-DEFINE TableLabel estrutura
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini»’o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret½rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¼ntico ao nome do DBO mas com
      extens’o .i ---*/
{inbo/boin111.i RowObject}

{inbo/boin111.i tt-estrutura}

/*--- Include com defini»’o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera»’o da defini»’o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini»’o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/****************** Variÿveis utilizadas na open-query (locais) *************************/
define var de-quant-usada       like estrutura.quant-usada   no-undo.
define var de-quant-liq         as decimal                   no-undo.
define var c-refer-es           like ref-item.cod-refer      no-undo.
define var l-refer-incluida     as logical                   no-undo.
define var c-comp               as char format "x(1)"        no-undo.
define var c-fabr               as char format "x(1)"        no-undo.    
define var c-alt                as char format "x(1)"        no-undo.
define var c-refer              like ref-item.cod-refer      no-undo.
define var i-seq                as integer                   no-undo.
define var i-nivel              as integer                   no-undo.
define var c-it-codigo          like item.it-codigo          no-undo.

/********* defini»„es de variÿveis que vem tela de par³metro - wen0805a  - ************/
define var de-quantidade     as decimal                      no-undo.
define var i-niveis          as integer                      no-undo.
define var da-data-corte     as date                         no-undo. 
define var c-format          as char                         no-undo.

DEFINE BUFFER  b-item  FOR   item.

/*********************   Fim defini»’o wen0805  *********************/

{cdp/cdcfgman.i} /*Miniflexibiliza‡Æo. Utilizado no EMS 2.02 - NÇO ELIMINAR
                 * Vari vel preprocessador bf_man_sfc_lc */

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



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:   Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters:ipar1: c-it-codigo:Item
             ipar2: i-sequencia:Sequˆncia 
             ipar3: c-es-codigo:Componente
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-it-codigo as char no-undo.
    def input parameter i-sequencia as inte no-undo.
    def input parameter c-es-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input c-it-codigo,
                 input i-sequencia,
                 input c-es-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOnde_se_usa DBOProgram 
PROCEDURE findOnde_se_usa :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters:ipar1: c-es-codigo:Componente
             ipar2: c-it-codigo:Item
             ipar3: i-sequencia:Sequˆncia 
             
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter c-es-codigo as char no-undo.
    def input parameter c-it-codigo as char no-undo.
    def input parameter i-sequencia as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToOndeSeUsa (input c-es-codigo,
                       input c-it-codigo,
                       input i-sequencia).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo n’o acha o registro */
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "es-codigo":U THEN ASSIGN pFieldValue = RowObject.es-codigo.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "local-montag":U THEN ASSIGN pFieldValue = RowObject.local-montag.
        WHEN "observacao":U THEN ASSIGN pFieldValue = RowObject.observacao.
        WHEN "posicao":U THEN ASSIGN pFieldValue = RowObject.posicao.
        WHEN "revisao":U THEN ASSIGN pFieldValue = RowObject.revisao.
        WHEN "serie-final":U THEN ASSIGN pFieldValue = RowObject.serie-final.
        WHEN "serie-inicia":U THEN ASSIGN pFieldValue = RowObject.serie-inicia.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterGetRecord DBOProgram 
PROCEDURE afterGetRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output parameter table for RowObject.

    def var i-cont as int no-undo. 
    assign i-cont = 0.
    RUN montaEstrutura.
    
/*    for each RowObject no-lock:
        assign i-cont = i-cont + 1.
        message "Contador -->" i-cont " componente = " RowObject.es-codigo " Sequencia  = " RowObject.sequencia.
        message  .
    end.   */

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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-inicio":U THEN ASSIGN pFieldValue = RowObject.data-inicio.
        WHEN "data-termino":U THEN ASSIGN pFieldValue = RowObject.data-termino.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "fator-perda":U THEN ASSIGN pFieldValue = RowObject.fator-perda.
        WHEN "proporcao":U THEN ASSIGN pFieldValue = RowObject.proporcao.
        WHEN "qtd-item":U THEN ASSIGN pFieldValue = RowObject.qtd-item.
        WHEN "quant-liquid":U THEN ASSIGN pFieldValue = RowObject.quant-liquid.
        WHEN "quant-usada":U THEN ASSIGN pFieldValue = RowObject.quant-usada.
        WHEN "rendimento":U THEN ASSIGN pFieldValue = RowObject.rendimento.
        WHEN "var-propor":U THEN ASSIGN pFieldValue = RowObject.var-propor.
        WHEN "conc-max":U THEN ASSIGN pFieldValue = RowObject.conc-max.
        WHEN "conc-min":U THEN ASSIGN pFieldValue = RowObject.conc-min.
        WHEN "concentracao":U THEN ASSIGN pFieldValue = RowObject.concentracao.
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

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "eng-resp":U THEN ASSIGN pFieldValue = RowObject.eng-resp.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tempo-reserv":U THEN ASSIGN pFieldValue = RowObject.tempo-reserv.
        WHEN "tipo-sobra":U THEN ASSIGN pFieldValue = RowObject.tipo-sobra.
        WHEN "variacao-qt":U THEN ASSIGN pFieldValue = RowObject.variacao-qt.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ­ndice CODIGO
  Parameters:
               retorna valor dos campos do ­ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pit-codigo LIKE estrutura.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE estrutura.sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pes-codigo LIKE estrutura.es-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN psequencia = RowObject.sequencia.
    ASSIGN pes-codigo = RowObject.es-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l½gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "fantasma":U THEN ASSIGN pFieldValue = RowObject.fantasma.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-atualiz-via-mmp":U THEN ASSIGN pFieldValue = RowObject.log-atualiz-via-mmp.
        WHEN "log-ref-estrut-disponivel":U THEN ASSIGN pFieldValue = RowObject.log-ref-estrut-disponivel.
        WHEN "log-todas-ref-item":U THEN ASSIGN pFieldValue = RowObject.log-todas-ref-item.
        WHEN "reap-desmont":U THEN ASSIGN pFieldValue = RowObject.reap-desmont.
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon­vel, caso n’o esteja serÿ
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
  Purpose:     Reposiciona registro com base no ­ndice CODIGO
  Parameters:
               recebe valor dos campos do ­ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE estrutura.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE estrutura.sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pes-codigo LIKE estrutura.es-codigo NO-UNDO.

    FIND FIRST bfestrutura WHERE
        bfestrutura.it-codigo = pit-codigo AND
        bfestrutura.sequencia = psequencia AND
        bfestrutura.es-codigo = pes-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfestrutura THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfestrutura)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToOndeSeUsa DBOProgram 
PROCEDURE goToOndeSeUsa :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters:ipar1: pes-codigo:Componente
             ipar2: pit-codigo:Item
             ipar3: psequencia:Sequˆncia 
------------------------------------------------------------------------------*/
    def input parameter pes-codigo as char no-undo.
    def input parameter pit-codigo as char no-undo.
    def input parameter psequencia as inte no-undo.
    
    FIND FIRST bfestrutura WHERE
        bfestrutura.es-codigo = pes-codigo AND
        bfestrutura.it-codigo = pit-codigo AND
        bfestrutura.sequencia = psequencia 
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfestrutura THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav²s de rowid e verifica a ocorr¼ncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfestrutura)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE limpaTempEstrutura DBOProgram 
PROCEDURE limpaTempEstrutura :
/*------------------------------------------------------------------------------
  Purpose:    Elimina registros da temp-table de estrutura e da RowObject 
        
------------------------------------------------------------------------------*/
    for each tt-estrutura:
        delete tt-estrutura.
    end.
    for each RowObject:
        delete RowObject.
    end.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE montaEstrutura DBOProgram 
PROCEDURE montaEstrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  
------------------------------------------------------------------------------*/
 find first {&tablename} WHERE {&TABLENAME}.it-codigo = c-it-codigo NO-LOCK no-error.

    find first item WHERE item.it-codigo = c-it-codigo NO-LOCK no-error.

    IF  AVAIL {&TABLENAME}                          and
        ({&TABLENAME}.data-inicio  <= da-data-corte and
        {&TABLENAME}.data-termino > da-data-corte)  or da-data-corte = ? THEN DO:
        
        for first b-item fields (it-codigo tipo-con-est compr-fabric) where 
                  b-item.it-codigo = {&tablename}.es-codigo no-lock: 
        end.
        
        if not avail b-item then next.
        else 
        /* D_MAN002 - Quantidade fixa para componentes de engenharia */
        assign de-quant-usada = if {&TABLENAME}.log-quant-fix then {&TABLENAME}.quant-usada 
                                else {&TABLENAME}.quant-usada * de-quantidade * ({&TABLENAME}.proporcao / 100)
               de-quant-liq   = if {&TABLENAME}.log-quant-fix then {&TABLENAME}.quant-usada 
                                else ({&TABLENAME}.quant-usada * de-quantidade * {&TABLENAME}.proporcao / 100) * (1 - ({&TABLENAME}.fator-perda / 100)).
        
        if b-item.tipo-con-est = 4 or item.tipo-con-est = 4 then do:
                        
            find first ref-estrut where ref-estrut.it-codigo  = {&tablename}.it-codigo   and  
                                        ref-estrut.es-codigo  = {&TABLENAME}.es-codigo   and
                                        ref-estrut.sequencia  = {&TABLENAME}.sequencia   no-lock no-error.
            if not available ref-estrut then
                 assign c-refer-es       = ""
                        l-refer-incluida = yes.
            else do:
 
                 find first ref-estrut where ref-estrut.it-codigo  = {&tablename}.it-codigo and  
                            ref-estrut.cod-ref-it = c-refer                                  and  
                            ref-estrut.es-codigo  = {&TABLENAME}.es-codigo                  and
                            ref-estrut.sequencia  = {&TABLENAME}.sequencia                  no-lock no-error.
                 if available ref-estrut then          
                    assign c-refer-es       = ref-estrut.cod-ref-es
                           l-refer-incluida = yes.
                 else          
                    assign l-refer-incluida = no.
              end.         
        end.
        else
           assign l-refer-incluida = yes
                  c-refer-es       = "".

       IF l-refer-incluida THEN DO:  
          create tt-estrutura.
          assign tt-estrutura.sequencia     = i-seq
                 tt-estrutura.cod-refer     = c-refer-es
                 tt-estrutura.r-rowid       = rowid({&TABLENAME})
                 tt-estrutura.quant-usada   = de-quant-usada
                 tt-estrutura.quant-liquid  = de-quant-liq
                 tt-estrutura.char-1        = string(i-nivel)
                 i-seq                      = i-seq + 1.

          if {&TABLENAME}.fantasma then 
             assign tt-estrutura.char-2 = '#'.
          else
             assign tt-estrutura.char-2 = ' '.
         
          if b-item.compr-fabric = 1 then           
             assign tt-estrutura.char-2 = tt-estrutura.char-2 +  c-comp.
          else     
             assign tt-estrutura.char-2 = tt-estrutura.char-2 +  c-fabr.
                
          find first alternativo where 
                     alternativo.es-codigo = {&TABLENAME}.es-codigo and
                     alternativo.it-codigo = {&tablename}.it-codigo and
                     alternativo.sequencia = {&TABLENAME}.sequencia no-lock no-error.
          if available alternativo then
             assign tt-estrutura.char-2 = tt-estrutura.char-2 +  c-alt.
          else   
             assign tt-estrutura.char-2 = tt-estrutura.char-2 +  ' '.
       
          if today >= {&TABLENAME}.data-termino or today < {&TABLENAME}.data-inicio then
             assign tt-estrutura.char-2 = tt-estrutura.char-2 +  '?'.
          
          assign tt-estrutura.char-1 = string('1','x(12)') + tt-estrutura.char-2.    

          if avail tt-estrutura then do:                    
              create RowObject.
              buffer-copy tt-estrutura to RowObject.
              assign rowObject.r-rowid = rowid(tt-estrutura).
          end.

          if i-niveis > i-nivel then 
              run pi-gera-tt-estrutura-filho(input rowid(b-item), 
                                             input c-refer-es, 
                                             input de-quant-usada, 
                                             input de-quant-liq, 
                                             input i-nivel).
       END.       
    END.

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
              
           when 2 then
              RUN openQueryStatic (input "ItCodigo":U).
           
           when 3 then
              RUN openQueryStatic (input "EsCodigo":U).
           
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryEsCodigo DBOProgram 
PROCEDURE openQueryEsCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela estrutura, conforme o 
              c¢digo do item, e dentro de uma faixa de componente e de fantasma.         
------------------------------------------------------------------------------*/
   open query {&QUERYNAME} for each {&TABLENAME} where 
                                    {&tablename}.it-codigo = c-it-codigo and
                                     substring({&TABLENAME}.es-codigo,1,3) = "emb" and  
                                    {&TABLENAME}.fantasma = yes
                                     no-lock INDEXED-REPOSITION.

                                    
    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigo DBOProgram 
PROCEDURE openQueryItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela estrutura, conforme
              o c¢digo do item. 
  
------------------------------------------------------------------------------*/
   open query {&QUERYNAME} for each {&TABLENAME} WHERE
                                    {&tablename}.it-codigo = c-it-codigo
                                     NO-LOCK INDEXED-REPOSITION.

                                          
    RETURN "OK":U.

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
    OPEN QUERY {&QueryName} FOR EACH estrutura NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-estrutura-filho DBOProgram 
PROCEDURE pi-gera-tt-estrutura-filho :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
 
------------------------------------------------------------------------------*/
    define input parameter v-row-item     as rowid     no-undo.
    define input parameter p-refer        as char      no-undo.
    define input parameter p-quantidade   as decimal   no-undo.
    define input parameter p-quant-liq    as decimal   no-undo.
    define input parameter p-nivel        as integer   no-undo.
    
    define buffer b1-item for item.
    define buffer b2-item for item.
    define buffer b-estrutura for estrutura.
    
    define var   de-quant-usada      as decimal  no-undo.
    define var   i                   as integer  no-undo.
    define var   p-nivel-aux         as integer  no-undo.


    for first b1-item fields ( it-codigo tipo-con-est) where rowid(b1-item) = v-row-item no-lock: 
    end.

    assign p-nivel = p-nivel + 1.

    for each  b-estrutura fields (data-inicio data-termino es-codigo quant-usada proporcao fator-perda  
                                  it-codigo sequencia fantasma log-quant-fix )  of b1-item no-lock:
       if (b-estrutura.data-inicio  <= da-data-corte and
           b-estrutura.data-termino >  da-data-corte) or da-data-corte = ? then do:
           for first b2-item fields (it-codigo desc-item tipo-con-est compr-fabric) where 
                b2-item.it-codigo = b-estrutura.es-codigo no-lock: 
           end.
           if not avail b2-item then next.
           else
           /* D_MAN002 - Quantidade fixa para componentes de engenharia */
           assign de-quant-usada = if b-estrutura.log-quant-fix then b-estrutura.quant-usada
                                   else b-estrutura.quant-usada * p-quantidade * (b-estrutura.proporcao / 100)
                  de-quant-liq   = if b-estrutura.log-quant-fix then b-estrutura.quant-usada 
                                   else (b-estrutura.quant-usada * p-quantidade * b-estrutura.proporcao / 100) * (1 - (b-estrutura.fator-perda / 100)).

          if  b2-item.tipo-con-est = 4 or b1-item.tipo-con-est = 4 then do:
                find first ref-estrut where ref-estrut.it-codigo  = b-estrutura.it-codigo  and  
                                            ref-estrut.es-codigo  = b-estrutura.es-codigo  and
                                            ref-estrut.sequencia  = b-estrutura.sequencia  no-lock no-error.
                
                if  not available ref-estrut then
                    assign c-refer-es       = ""
                           l-refer-incluida = yes.
                else do:
                      find first ref-estrut where ref-estrut.it-codigo  = b-estrutura.it-codigo and  
                                                  ref-estrut.cod-ref-it = p-refer and  
                                                  ref-estrut.es-codigo  = b-estrutura.es-codigo and
                                                  ref-estrut.sequencia  = b-estrutura.sequencia no-lock no-error.
                      if available ref-estrut then
                         assign c-refer-es = ref-estrut.cod-ref-es
                                l-refer-incluida = yes.
                      else   
                          assign l-refer-incluida = no.
                end.          
          end.
          else
              assign l-refer-incluida = yes
                     c-refer-es       = "".

          if  l-refer-incluida then do:
              create tt-estrutura.  
              assign tt-estrutura.sequencia    = i-seq
                     tt-estrutura.cod-refer    = c-refer-es
                     tt-estrutura.r-rowid      = rowid(b-estrutura)
                     tt-estrutura.quant-usada  = de-quant-usada
                     tt-estrutura.quant-liquid = de-quant-liq
                     tt-estrutura.char-1       = string(p-nivel)
                     i-seq                     = i-seq + 1.

              if  b-estrutura.fantasma then 
                  assign tt-estrutura.char-2 = '#'.
              else
                  assign tt-estrutura.char-2 = ' '.
               
              if  b2-item.compr-fabric = 1 then           
                  assign tt-estrutura.char-2 = tt-estrutura.char-2 +  c-comp.
              else     
                  assign tt-estrutura.char-2 = tt-estrutura.char-2 +  c-fabr.
                      
              find first alternativo where 
                         alternativo.es-codigo = b-estrutura.es-codigo and
                         alternativo.it-codigo = b-estrutura.it-codigo and
                         alternativo.sequencia = b-estrutura.sequencia no-lock no-error.
              if  available alternativo then
                  assign tt-estrutura.char-2 = tt-estrutura.char-2 +  c-alt.
              else   
                  assign tt-estrutura.char-2 = tt-estrutura.char-2 +  ' '.
            
              if  today >= b-estrutura.data-termino or today < b-estrutura.data-inicio then
                  assign tt-estrutura.char-2 = tt-estrutura.char-2 +  '?'.
             
              assign tt-estrutura.char-1 = string(p-nivel, ">9").
              do i = 3 to p-nivel:
                   assign tt-estrutura.char-1 = ' ' + tt-estrutura.char-1.
                   if i = 10 then leave.  
              end.     
              assign tt-estrutura.char-1 = string(tt-estrutura.char-1, 'x(12)') + tt-estrutura.char-2.

              find first tt-estrutura no-lock no-error.
              if avail tt-estrutura then do:              
                  create RowObject.
                  buffer-copy tt-estrutura to RowObject.
                  assign rowObject.r-rowid = rowid(tt-estrutura).
              end.
               
              if  i-niveis > p-nivel then
                  run pi-gera-tt-estrutura-filho(input rowid(b2-item),
                                                 input c-refer-es, 
                                                 input de-quant-usada, 
                                                 input de-quant-liq, 
                                                 input p-nivel-aux).                                  
          end.          
       end.   
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*---------------PROCEDURE EM DESENVOLVIMENTO--------------------------------------------------------*/

/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaEstruturaDesmonte DBOProgram 
 * PROCEDURE processaEstruturaDesmonte :
 * /*------------------------------------------------------------------------------
 *   Purpose:     
 *   Parameters:  <none>
 *   Notes:       
 * ------------------------------------------------------------------------------*/
 *     def input param c-it-codigo             like item.it-codigo          no-undo.
 *     def input param c-cod-estabel           like saldo-estoq.cod-estabel no-undo.
 *     def input param c-lote                  like saldo-estoq.lote        no-undo.
 *     def input param de-percentual-acrescimo   as decimal                 no-undo.
 *     def input param l-consiste-valor-retorno  as logical                 no-undo.
 *     def input param da-validade               as date                    no-undo.
 *     def input table tt-deposito-cp0318.
 *     def output table tt-work.
 *     
 *      /* Esperando implementa‡Æo */  
 *     {inbo/boin111.i2}  /* temp-tables correspondentes a passagem de parƒmetros a serem processados para o CP0318 */
 * 
 *     def var i-retorno      as integer            no-undo.
 *     def var i-fator        as integer extent 20  no-undo.
 *     def var i-sequencia    as integer            no-undo.
 *     def var i-qtd          as decimal            no-undo.
 *     def var r-end-ret      as recid extent 20    no-undo.
 *     def var de-qtd-calc    as decimal            no-undo.
 *     def var c-item       like item.it-codigo     no-undo.
 *     def var de-medio-mat   as decimal            no-undo.
 *     def var de-medio-ggf   as decimal            no-undo.
 *     def var de-medio-mob   as decimal            no-undo.
 *         
 *     assign i-sequencia = 0
 *            i-fator[1]  = 1
 *            i-retorno   = 1
 *            c-item      = item.it-codigo.
 *     comeco:
 *     repeat:
 *         find first estrutura
 *              where estrutura.it-codigo    = c-item         and
 *                    estrutura.data-inicio <= fi-dt-validade and
 *                    estrutura.data-termino > fi-dt-validade
 *                    no-lock no-error.
 *         if  not available estrutura and i-retorno < 3 then leave.
 *         if  i-retorno = 1 then do:
 *             assign i-retorno = i-retorno + 1
 *                    r-end-ret[i-retorno] = recid(estrutura).
 *         end.
 *           
 *         &if defined (bf_man_sfc_lc) &then
 *               assign de-qtd-calc = estrutura.qtd-compon / estrutura.qtd-item.
 *         &else
 *               assign de-qtd-calc = estrutura.quant-usada.
 *         &endif
 *          
 *         repeat:
 *            if  available estrutura then do:
 *                find item where item.it-codigo = estrutura.es-codigo
 *                      no-lock no-error.
 *                i-fator[i-retorno] = i-fator[i-retorno - 1]
 *                                   * de-qtd-calc
 *                                   * estrutura.proporcao / 100.
 *                if  estrutura.fantasma = yes then do:
 *                    find first b-estrutura where
 *                               b-estrutura.it-codigo   =  estrutura.es-codigo and
 *                               b-estrutura.data-inicio <= fi-dt-validade      and
 *                               b-estrutura.data-termino > fi-dt-validade
 *                               no-lock no-error.
 *                    if not avail b-estrutura  and item.it-codigo <> "" then do:
 *                       /* GERA tt-work */
 *                       {inbo/boin111.i1}
 *                    end.
 *                    assign c-item               = estrutura.es-codigo
 *                           i-retorno            = i-retorno + 1
 *                           r-end-ret[i-retorno] = recid(estrutura).
 *                    next comeco.
 *                end.
 *                else
 *                    if item.it-codigo  <> "" and
 *                       de-qtd-calc > 0 then do:
 *                       /* GERA tt-work */
 *                       {inbo/boin111.i1}
 *                    end.
 *            end.
 *            else do:              
 *                if  i-retorno = 2 then 
 *                    leave comeco.
 *                else do:
 *                    find estrutura where
 *                         recid(estrutura) = r-end-ret[i-retorno] no-lock no-error.
 *                    assign c-item    = estrutura.it-codigo
 *                    i-retorno = i-retorno - 1.
 *                end.
 *            end.
 *            find next estrutura
 *                where estrutura.it-codigo    = c-item         and
 *                      estrutura.data-inicio <= fi-dt-validade and
 *                      estrutura.data-termino > fi-dt-validade
 *                      no-lock no-error.
 *         end.
 *     end.            
 * 
 * END PROCEDURE.*/

/* _UIB-CODE-BLOCK-END */
/*&ANALYZE-RESUME*/

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     Carrega vari veis utilizadas no prog. wen0812.w contendo a referˆncia
               do item, quantidade do item, n¡veis a serem mostrados, data do corte,
               formato de tela da quantidade e o c¢digo do item.
  Parameters:  ipar1: p-c-refer       : Referˆncia do Item            - combo-box
               ipar2: p-de-quantidade : Quantidade do item            - tela parametro
               ipar3: p-i-niveis      : N¡veis a serem mostrados      - tela parametro
               ipar4: p-da-data-corte : Data do Corte                 - tela parametro
               ipar5: p-c-format      : Formato de tela da Quantidade - tela parametro
               ipar6: p-cod-item      : codigo do Item 
 ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    DEFINE INPUT PARAMETER p-c-refer        LIKE ref-item.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER p-de-quantidade  AS char                 NO-UNDO.
    DEFINE INPUT PARAMETER p-i-niveis       AS char                 NO-UNDO.
    DEFINE INPUT PARAMETER p-da-data-corte  AS char                 NO-UNDO.
    DEFINE INPUT PARAMETER p-c-format       AS char                 NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-item       AS char                 NO-UNDO. 
    
    run setConstraintCodRefer (p-c-refer,
                               p-de-quantidade,
                               p-i-niveis,
                               p-da-data-corte,
                               p-c-format,
                               p-cod-item).
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o 
              c¢digo do item. 
  Parameters: ipar: p-it-codigo:Item         
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-it-codigo as char no-undo. 
        
    run setConstraintItCodigo (p-it-codigo).
                           
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodRefer DBOProgram 
PROCEDURE setConstraintCodRefer :
/*------------------------------------------------------------------------------
  Purpose:     Carrega vari veis utilizadas no prog. wen0812.w contendo a referˆncia
               do item, quantidade do item, n¡veis a serem mostrados, data do corte,
               formato de tela da quantidade e o c¢digo do item.
  Parameters:  ipar1: pc-refer       : Referˆncia do Item            - combo-box
               ipar2: pde-quantidade : Quantidade do item            - tela parametro
               ipar3: pi-niveis      : N¡veis a serem mostrados      - tela parametro
               ipar4: pda-data-corte : Data do Corte                 - tela parametro
               ipar5: pc-format      : Formato de tela da Quantidade - tela parametro
               ipar6: pcod-item      : codigo do Item 
      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-refer        LIKE ref-item.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pde-quantidade  AS char                 NO-UNDO.
    DEFINE INPUT PARAMETER pi-niveis       AS char                 NO-UNDO.
    DEFINE INPUT PARAMETER pda-data-corte  AS char                 NO-UNDO.
    DEFINE INPUT PARAMETER pc-format       AS char                 NO-UNDO.
    DEFINE INPUT PARAMETER pcod-item       AS char                 NO-UNDO. 

    assign c-refer         =  pc-refer
           c-refer-es      =  "".

    assign de-quantidade   = dec(pde-quantidade)
           i-niveis        = int(pi-niveis)
           da-data-corte   = date(pda-data-corte)
           c-format        = pc-format.

    assign i-seq            = 1
           i-nivel          = 1
           de-quant-liq     = 1
           l-refer-incluida = no.

    assign c-comp = substr({ininc/i01in172.i 04 1},1,1)
           c-fabr = substr({ininc/i01in172.i 04 2},1,1)
           c-alt  = "A".
    assign c-it-codigo = pcod-item .
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItCodigo DBOProgram 
PROCEDURE setConstraintItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari veis de controle para queries contendo o 
              c¢digo do item. 
  Parameters: ipar: pit-codigo:Item       
------------------------------------------------------------------------------*/
   define input parameter pit-codigo as char no-undo. 
   
    assign c-it-codigo = pit-codigo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaLooping DBOProgram 
PROCEDURE validaLooping :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-row-item  AS ROWID NO-UNDO.
DEFINE INPUT PARAMETER p-it-codigo AS CHAR  NO-UNDO.


DEFINE BUFFER b2-item       FOR ITEM.
DEFINE BUFFER b3-item       FOR ITEM.
DEFINE BUFFER b-estrutura   FOR estrutura.
DEFINE BUFFER b-modelo-cf   FOR modelo-cf.
DEFINE BUFFER b-alternativo FOR alternativo.
DEFINE BUFFER b-estr-mod-cf FOR estr-mod-cf.

FIND FIRST b2-item NO-LOCK
     WHERE ROWID(b2-item) = p-row-item NO-ERROR.



FOR EACH b-estrutura NO-LOCK
   WHERE b-estrutura.it-codigo = b2-item.it-codigo:

    IF b-estrutura.es-codigo = p-it-codigo THEN DO:
        /*Looping de estrutura*/
        {method/svc/errors/inserr.i
                           &ErrorNumber="2240"
                           &ErrorType="EMS"
                           &ErrorSubType="ERROR"}
        RETURN 'NOK':u.
    END.

    FIND FIRST b3-item NO-LOCK
         WHERE b3-item.it-codigo = b-estrutura.es-codigo NO-ERROR.

    IF AVAILABLE b3-item THEN DO:

        IF b3-item.niv-mais-bai <= b2-item.niv-mais-bai AND 
           b2-item.niv-mais-bai > 29 THEN DO:
            /*N¡vel mais baixo maior que 30*/
            {method/svc/errors/inserr.i
                               &ErrorNumber="126"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"} 
            RETURN 'NOK':u.
        END.

        

        run validaLooping(ROWID(b3-item), p-it-codigo).
        IF RETURN-VALUE <> 'OK' THEN DO:
            /*Retornou algum erro*/
            RETURN 'NOK':u.
        END.

        
    END.

    FOR EACH b-alternativo NO-LOCK
       WHERE b-alternativo.es-codigo = b-estrutura.es-codigo 
         AND b-alternativo.it-codigo = b-estrutura.it-codigo
         AND b-alternativo.sequencia = b-estrutura.sequencia:

        IF b-alternativo.al-codigo = p-it-codigo THEN DO:
            /*Looping de estrutura*/
            {method/svc/errors/inserr.i
                               &ErrorNumber="2240"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"} 
            RETURN 'NOK':u.
        END.

        FIND FIRST b3-item NO-LOCK
            WHERE b3-item.it-codigo = b-alternativo.al-codigo NO-ERROR.

        IF AVAILABLE b3-item THEN DO:

            IF b3-item.niv-mais-bai <= b2-item.niv-mais-bai AND
               b2-item.niv-mais-bai > 29 THEN DO:
                /*N¡vel mais baixo maior que 19*/
                {method/svc/errors/inserr.i
                                   &ErrorNumber="126"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"} 
                RETURN 'NOK':u.

            END.

            RUN validaLooping(ROWID(b3-item), p-it-codigo).
            IF RETURN-VALUE <> 'ok':U  THEN DO: 
                /*Retornou algum erro*/
                RETURN 'NOK':u.
            END.
        END.
    END.

END.

FIND FIRST b-modelo-cf NO-LOCK
    WHERE b-modelo-cf.item-criado = b2-item.it-codigo NO-ERROR.

IF AVAILABLE b-modelo-cf THEN DO:

    FOR EACH b-estr-mod-cf NO-LOCK
       WHERE b-estr-mod-cf.mo-codigo = b-modelo-cf.mo-codigo:

        IF b-estr-mod-cf.it-codigo = p-it-codigo THEN DO:
            /*Looping de estrutura*/
            {method/svc/errors/inserr.i
                               &ErrorNumber="2240"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"} 
            RETURN 'NOK':u.
        END.

        FIND FIRST b3-item NO-LOCK
            WHERE b3-item.it-codigo = b-estr-mod-cf.it-codigo NO-ERROR.

        IF AVAILABLE b3-item THEN DO: 
            IF b3-item.niv-mais-bai <= b2-item.niv-mais-bai AND
               b2-item.niv-mais-bai > 29 THEN DO:
                /*N¡vel mais baixo maior que 19*/
                {method/svc/errors/inserr.i
                                   &ErrorNumber="126"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"} 
                RETURN 'NOK':u.
            END.

            RUN validaLooping(ROWID(b3-item), p-it-codigo).

            IF RETURN-VALUE <> 'ok':U THEN DO:
                /*Significa que retornou algum tipo de erro*/   
                RETURN 'NOK':u.

            END.   
        END.
    END.
   RUN validaLooping(ROWID(b3-item), p-it-codigo).

END.

RETURN 'OK':u.

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

    DEFINE BUFFER b0-item     FOR ITEM.
    DEFINE BUFFER b1-item     FOR ITEM.

    DEFINE BUFFER b-estrutura FOR estrutura.

        

    /*--- Utilize o par³metro pType para identificar quais as valida»„es a serem
          executadas ---*/
    /*--- Os valores poss­veis para o par³metro s’o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav²s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida»„es ---*/
    
    /*As valida‡äes abaixo estavam na BOIN111.I1 que somente ‚ utilizada na trigger*/
    /*Colocamos neste ponto para que o m‚todo possa ser executado na boin480.p na cria‡Æo dos registros de estrutura*/

    IF pType = "CREATE" THEN DO:

        IF CAN-FIND(FIRST b-estrutura 
                    where b-estrutura.it-codigo = rowObject.it-codigo
                      and b-estrutura.es-codigo = rowObject.es-codigo  
                      and b-estrutura.sequencia = rowObject.sequencia) then do:

             {utp/ut-table.i mgind estrutura 1}
             {method/svc/errors/inserr.i
                        &ErrorNumber="1"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="return-value"} 
        END.
    END.

    IF pType = "CREATE" OR
       pType = "UPDATE" THEN DO:


        IF rowObject.it-codigo = "" THEN DO:
             {method/svc/errors/inserr.i
                                &ErrorNumber="1314"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"} 
        END.

        FOR FIRST b1-item NO-LOCK
            WHERE b1-item.it-codigo = rowObject.es-codigo :
        END.

        IF NOT AVAILABLE b1-item THEN DO:
             {utp/ut-field.i mgind estrutura es-codigo 1}
             {method/svc/errors/inserr.i
                                &ErrorNumber="56"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="return-value"} 
        END.
        ELSE DO:
            IF b1-item.it-codigo = "" THEN DO:
                {utp/ut-field.i mgind estrutura es-codigo 1}
                {method/svc/errors/inserr.i
                                   &ErrorNumber="164"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="return-value"} 
            END.
            IF b1-item.cod-obsoleto >= 3 THEN DO:
                {utp/ut-table.i mgind lista-compon 1}
                {method/svc/errors/inserr.i
                                   &ErrorNumber="2585"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"
                                   &ErrorParameters="b1-item.it-codigo + '~~~~' + return-value"} 
            END.
        END.

        IF rowObject.data-inicio > rowObject.data-termino THEN DO:
            {method/svc/errors/inserr.i
                               &ErrorNumber="1166"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"} 
        END.

        FOR FIRST b0-item NO-LOCK
            WHERE b0-item.it-codigo = rowObject.it-codigo :
        END.

        IF rowObject.tempo-reserv <> ? AND
           rowObject.tempo-reserv >= b0-item.ressup-fabri THEN DO:
            {method/svc/errors/inserr.i
                               &ErrorNumber="1326"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR"} 
        END.

        IF rowObject.cod-roteiro <> "" THEN DO:
            FIND FIRST rot-item NO-LOCK
                 WHERE rot-item.it-codigo = rowObject.it-codigo
                   AND rot-item.cod-roteiro = rowObject.cod-roteiro NO-ERROR.
            IF NOT AVAILABLE rot-item OR rot-item.data-termino < TODAY THEN DO:
                {method/svc/errors/inserr.i
                                   &ErrorNumber="436"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"} 
            END.

            IF rowObject.op-codigo <> 0 THEN DO:
                FIND FIRST operacao NO-LOCK
                     WHERE operacao.it-codigo = "" 
                       AND operacao.cod-roteiro = rowObject.cod-roteiro
                       AND operacao.op-codigo   = rowObject.op-codigo NO-ERROR.
                IF NOT AVAILABLE operacao THEN DO:
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="437"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"}
                END.
            END.
        END.   
        ELSE IF rowObject.op-codigo <> 0 THEN DO:
            FIND FIRST operacao NO-LOCK
              WHERE operacao.it-codigo = rowObject.it-codigo
                AND operacao.cod-roteiro = ""
                AND operacao.op-codigo   = rowObject.op-codigo NO-ERROR.
            IF NOT AVAILABLE operacao THEN DO:
                {method/svc/errors/inserr.i
                                   &ErrorNumber="437"
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"}
            END.
        END.
        
        IF b0-item.tipo-con-est = 4 THEN DO:
            if rowObject.cod-lista-compon = "" then
                if not can-find (first ref-estrut
                                 where ref-estrut.it-codigo = rowObject.it-codigo
                                   and ref-estrut.sequencia = rowObject.sequencia
                                   and ref-estrut.es-codigo = rowObject.es-codigo) then DO: 
                
                    {utp/ut-field.i mgind estrutura es-codigo 1}
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="1300"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"
                                       &ErrorParameters="return-value"}
                END.
        END.        

        FIND FIRST b-estrutura NO-LOCK
             WHERE rowid(b-estrutura) = rowObject.r-rowid NO-ERROR.

        IF pType = "CREATE" AND AVAIL b1-item OR
           (pType = "UPDATE" AND 
            AVAILABLE b-estrutura AND
            (b-estrutura.it-codigo <> rowObject.it-codigo OR
             b-estrutura.es-codigo <> rowObject.es-codigo)) THEN DO:

	    //ainda nao alterou nivel do b1-item, por isso somando mais 1 pra validar
            IF (b1-item.niv-mais-bai + 1) <= b0-item.niv-mais-bai THEN DO:

                IF b0-item.niv-mais-bai > 29 THEN DO:
                    {method/svc/errors/inserr.i
                                       &ErrorNumber="126"
                                       &ErrorType="EMS"
                                       &ErrorSubType="ERROR"}
                                       
                END.
                RUN validaLooping (INPUT ROWID(b1-item), rowObject.it-codigo).

            END.

        END.

    END.

    /*--- Verifica ocorr¼ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
