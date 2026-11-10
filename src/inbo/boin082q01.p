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
{include/i-prgvrs.i BOIN082Q01 2.00.00.013 } /*** "010013" 23/11/2023 16:19:42  ***/
/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ≤ um programa PROGRESS
                 que cont≤m a lΩgica de negΩcio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiªío ---*/
&GLOBAL-DEFINE DBOName cotacao-item
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-cotacao-item
&GLOBAL-DEFINE TableLabel tt-cotacao-item
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin082.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com definiªío da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diretΩrio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idºntico ao nome do DBO mas com
      extensío .i ---*/
      
{inbo/boin082q01.i tt-cotacao-item}
{inbo/boin082q01.i RowObject}

/*--- Include com definiªío da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraªío da definiªío da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiªío
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


def var rOrdemCompra as rowid no-undo.
def var iContador    as int no-undo.
def var iCont        as int no-undo format "99999".

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
         HEIGHT             = 16.51
         WIDTH              = 55.86.
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


/*procedure RetornaEntregaOrdem:
 *     /*
 *     Retorna a data de entrega da ordem conforme ordem selecionada.
 *     
 *     ipar1: p-ordem   : numero ordem
 *     opor2: p-entrega : retorna prazo-compra.data-entrega ou "Parcelada".
 *     
 *     */
 *     def input  param p-ordem   as int.
 *     def output param p-entrega as char.
 *     
 *     def var i-contador         as int.
 * 
 *     assign p-entrega = "".
 *     assign i-contador = 0.
 *     for each prazo-compra where prazo-compra.numero-ordem = p-ordem:
 *         assign i-contador = i-contador + 1.
 *     end.
 *     if i-contador > 1 then
 *         assign p-entrega = "Parcelada".
 *     else do:
 *         find first prazo-compra 
 *              where prazo-compra.numero-ordem = p-ordem no-lock no-error.
 *         if avail prazo-compra then 
 *             assign p-entrega = string(prazo-compra.data-entrega,"99/99/9999").
 *     end.      
 * end procedure.*/

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
        /*--- Erro 11: N∆o foi poss°vel reposicionar a query ---*/
        {method/svc/errors/inserr.i &ErrorNumber="11"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}
        
        RETURN "NOK":U.
    END.
    
    /*--- ê necess†rio para o correto funcionamento do reposicionamento ---*/
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaCotacaoItem DBOProgram 
PROCEDURE carregaCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:  Carrega a temp-table tt-cotacao-item conforme ordem-compra. 
            Mesmo que n∆o exista uma cotaá∆o-item para a ordem-compra, 
            um registro Ç criado na temp-table com alguns dados de ordem-compra e 
            outros campos v∆o zerados.   
  Parameters: 
            ipar1: piNrProcesso     : proc-fornec.nr-processo(N£mero do processo  pai)
            ipar2: piCodEmitente    : proc-fornec.cod-emitente(Fornecedor  pai)
            ipar3: pcCodComprado    : proc-fornec.cod-comprado(Comprador pai) 
            ipar4: piNumeroOrdemIni : param ordem inicial da tela de seleá∆o
            ipar5: piNumeroOrdemFim : param ordem final da tela de seleá∆o
            ipar6: pcItCodigoIni    : param item inicial da tela de seleá∆o
            ipar7: pcItCodigoFim    : param item final da tela de seleá∆o
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param piNrProcesso     as inte no-undo.
    def input param piCodEmitente    as inte no-undo.
    def input param pcCodComprado    as char no-undo.
    def input param piNumeroOrdemIni as char no-undo.
    def input param piNumeroOrdemFim as char no-undo.
    def input param pcItCodigoIni    as char no-undo.
    def input param pcItCodigoFim    as char no-undo.
    def input param piSitCot         as inte no-undo.
    def input param plOrdemNConf     as logi no-undo.
    def input param plOrdemConf      as logi no-undo.
    def input param plOrdemCotada    as logi no-undo.
    def input param plOrdemElimin    as logi no-undo.
    def input param plOrdemEmCot     as logi no-undo.
    def input param plOrdemRecebida  as logi no-undo.     
    
    for each tt-cotacao-item:
     delete tt-cotacao-item.
    end.
    assign iCont = 0.
    for each ordem-compra no-lock where 
             ordem-compra.nr-processo  = piNrProcesso and 
             ordem-compra.nr-processo  <> 0           /*and
 *              ordem-compra.cod-comprado = pcCodComprado*/ :

        if  ordem-compra.numero-ordem < int(piNumeroOrdemIni) or
            ordem-compra.numero-ordem > int(piNumeroOrdemFim) or
            ordem-compra.it-codigo    < pcItCodigoIni         or
            ordem-compra.it-codigo    > pcItCodigoFim       then
            next.
        
        if (ordem-compra.situacao = 1 and plOrdemNConf    = no) or
           (ordem-compra.situacao = 2 and plOrdemConf     = no) or
           (ordem-compra.situacao = 3 and plOrdemCotada   = no) or
           (ordem-compra.situacao = 4 and plOrdemElimin   = no) or 
           (ordem-compra.situacao = 5 and plOrdemEmCot    = no) or
           (ordem-compra.situacao = 6 and plOrdemRecebida = no) then next. 
        
        if  not can-find(first cotacao-item where cotacao-item.numero-ordem = ordem-compra.numero-ordem
            and cotacao-item.cod-emitente = piCodEmitente
            and cotacao-item.data-cotacao <> &if "{&ems_dbtype}":u = "mss":u &then 01/01/1800 &else 11/11/1111 &endif) 
            then do: /* se n∆o existir cotacao-item para a ordem-compra, Ç adicionado o registro com alguns dados
                        da ordem-compra e outros zerados, se existir ele atribui os valores da tabela.*/
            
            find first cotacao-item where cotacao-item.numero-ordem = ordem-compra.numero-ordem
            and cotacao-item.cod-emitente = piCodEmitente
            and cotacao-item.data-cotacao = &if "{&ems_dbtype}":u = "mss":u &then 01/01/1800 &else 11/11/1111 &endif no-lock no-error.
            
            assign iCont = iCont + 1.
            
            create tt-cotacao-item.
            assign tt-cotacao-item.chave-seq = iCont
                   tt-cotacao-item.situacao      = ordem-compra.situacao
                   tt-cotacao-item.numero-ordem  = ordem-compra.numero-ordem
                   tt-cotacao-item.it-codigo     = ordem-compra.it-codigo
                   tt-cotacao-item.cod-emitente  = piCodEmitente
                   tt-cotacao-item.qt-acum-nec   = ordem-compra.qt-acum-nec
                   tt-cotacao-item.seq-cotac     = if avail cotacao-item then cotacao-item.seq-cotac else 0                   
                   tt-cotacao-item.data-cotacao  = if avail cotacao-item then cotacao-item.data-cotacao else ?
                   tt-cotacao-item.narrativa     = substr(ordem-compra.narrativa,1,80)
                   tt-cotacao-item.preco-fornec  = 0
                   tt-cotacao-item.aliquota-ipi  = 0
                   tt-cotacao-item.aliquota-icm  = 0
                   tt-cotacao-item.preco-unit    = 0
                   tt-cotacao-item.pre-unit-for  = 0
                   tt-cotacao-item.log-2         = no
                   tt-cotacao-item.r-rowid       = to-rowid("0x0" + string(iCont,"99999")). /*to-rowid("cot-rowid" + string(iCont)).*/
                             
            assign tt-cotacao-item.entrega = "".
            assign iContador = 0.
            for each prazo-compra field (numero-ordem)
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                assign iContador = iContador + 1.
            end.
            
            for first prazo-compra field (numero-ordem data-entrega un)
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem 
                no-lock: end.
            
            if  iContador > 1 then do:
                assign tt-cotacao-item.entrega = "Parcelada".
            end.
            else
                assign tt-cotacao-item.entrega = if avail prazo-compra then string(prazo-compra.data-entrega,"99/99/9999")
                                                 else ?.
            if  avail prazo-compra then 
                assign tt-cotacao-item.un = prazo-compra.un.
            find first item where 
                       item.it-codigo = ordem-compra.it-codigo no-lock no-error.
            assign tt-cotacao-item.descricao = if  avail item then item.desc-item else "".
        end.
        else do:
            if piSitCot = 2 then do:
                for each cotacao-item 
                    where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                    and   cotacao-item.cod-emitente = piCodEmitente no-lock:
                    assign iCont = iCont + 1.
                    create tt-cotacao-item.
                    assign tt-cotacao-item.chave-seq = iCont
                           tt-cotacao-item.data-cotacao  = cotacao-item.data-cotacao
                           tt-cotacao-item.numero-ordem  = ordem-compra.numero-ordem
                           tt-cotacao-item.it-codigo     = ordem-compra.it-codigo
                           tt-cotacao-item.situacao      = ordem-compra.situacao
                           tt-cotacao-item.cod-emitente  = cotacao-item.cod-emitente
                           tt-cotacao-item.seq-cotac     = cotacao-item.seq-cotac
                           tt-cotacao-item.un            = cotacao-item.un
                           tt-cotacao-item.qt-acum-nec   = ordem-compra.qt-acum-nec
                           tt-cotacao-item.preco-fornec  = cotacao-item.preco-fornec
                           tt-cotacao-item.aliquota-ipi  = cotacao-item.aliquota-ipi
                           tt-cotacao-item.aliquota-icm  = cotacao-item.aliquota-icm
                           tt-cotacao-item.preco-unit    = cotacao-item.preco-unit
                           tt-cotacao-item.pre-unit-for  = cotacao-item.pre-unit-for
                           tt-cotacao-item.log-2         = cotacao-item.log-2
                           tt-cotacao-item.narrativa     = substring(ordem-compra.narrativa,1,80)
                           tt-cotacao-item.r-rowid       = to-rowid("0x0" + string(iCont,"99999")).
                    assign tt-cotacao-item.entrega = "".
                    assign iContador = 0. 
                    for each prazo-compra field (numero-ordem)
                        where prazo-compra.numero-ordem = cotacao-item.numero-ordem NO-LOCK:
                        assign iContador = iContador + 1.
                    end.
                    if iContador > 1 then
                        assign tt-cotacao-item.entrega = "Parcelada".
                    else do:
                        for first prazo-compra field (numero-ordem data-entrega un)
                            where prazo-compra.numero-ordem = cotacao-item.numero-ordem 
                            no-lock: end.
                        assign tt-cotacao-item.entrega = if avail prazo-compra then string(prazo-compra.data-entrega,"99/99/9999")
                                                         else ?.
                    end.
                    find first item where 
                               item.it-codigo = ordem-compra.it-codigo no-lock no-error.
                    assign tt-cotacao-item.descricao = if  avail item then item.desc-item else "".
                end. 
            end.            
        end.
    end.           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregarTempTableCotacaoItem DBOProgram 
PROCEDURE carregarTempTableCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose: Carrega tem-table tt-cotacao-item com cotaá‰es n∆o pendentes,
           de acordo com a ordem de compra atual e um processo do fornecedor
           relacionado.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM prOrdemCompra AS ROWID NO-UNDO.

    assign rOrdemCompra = prOrdemCompra.

    FOR FIRST ordem-compra WHERE 
        ROWID(ordem-compra) = rOrdemCompra NO-LOCK,
        EACH cotacao-item WHERE 
             cotacao-item.numero-ordem = ordem-compra.numero-ordem AND 
             cotacao-item.data-cotacao <> &if "{&ems_dbtype}":u = "mss":u &then 01/01/1800 &else 11/11/1111 &endif AND
             today <= (cotacao-item.data-cotacao + cotacao-item.dias-validade) NO-LOCK,
             EACH proc-fornec WHERE 
                  proc-fornec.cod-emitente = cotacao-item.cod-emitente AND 
                  proc-fornec.nr-processo = ordem-compra.nr-processo NO-LOCK:

        find first moeda where moeda.mo-codigo = cotacao-item.mo-codigo no-lock no-error.
        find first cond-pagto where cond-pagto.cod-cond-pag = cotacao-item.cod-cond-pag no-lock no-error.
        
        create tt-cotacao-item.
        assign 
                tt-cotacao-item.cod-emitente  = cotacao-item.cod-emitente
                tt-cotacao-item.pre-unit-for  = cotacao-item.pre-unit-for
                tt-cotacao-item.preco-fornec  = cotacao-item.preco-fornec
                tt-cotacao-item.cod-cond-pag  = cotacao-item.cod-cond-pag
                tt-cotacao-item.cond-pag-desc = if avail cond-pagto then cond-pagto.descricao else ""
                tt-cotacao-item.mo-codigo     = cotacao-item.mo-codigo
                tt-cotacao-item.mo-desc       = if avail moeda then moeda.descricao else ""
                tt-cotacao-item.perc-descto   = cotacao-item.perc-descto
                tt-cotacao-item.valor-descto  = cotacao-item.valor-descto
                tt-cotacao-item.frete         = cotacao-item.frete
                tt-cotacao-item.valor-frete   = cotacao-item.valor-frete
                tt-cotacao-item.dias-validade = cotacao-item.dias-validade
                tt-cotacao-item.prazo-entreg  = cotacao-item.prazo-entreg
                tt-cotacao-item.data-cotacao  = cotacao-item.data-cotacao
                tt-cotacao-item.aliquota-icm  = cotacao-item.aliquota-icm
                tt-cotacao-item.aliquota-ipi  = cotacao-item.aliquota-ipi
                tt-cotacao-item.aliquota-iss  = cotacao-item.aliquota-iss
                tt-cotacao-item.codigo-icm    = cotacao-item.codigo-icm 
                tt-cotacao-item.codigo-ipi    = cotacao-item.codigo-ipi     
                tt-cotacao-item.taxa-financ   = cotacao-item.taxa-financ
                tt-cotacao-item.valor-taxa    = cotacao-item.valor-taxa       
                tt-cotacao-item.nr-dias-taxa  = cotacao-item.nr-dias-taxa
                tt-cotacao-item.r-rowid       = rowid(cotacao-item).
    
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCotacaoItem DBOProgram 
PROCEDURE findCotacaoItem :
/*------------------------------------------------------------------------------
  Purpose:   Acha a tt-cotacao-item de acordo com a chave do registro que Ç 
             um sequencial autom†tico incrementado de acordo com a quanidade de
             registros criados para essa tem-table .
             
  Parameters:  
             ipar1 : piChaveSeq : Chave do registro da tem-table   
             opar2 : pcReturn   : Status do processo
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piChaveSeq  as int  no-undo.
    def output param pcReturn    as char no-undo.
    
    find tt-cotacao-item where 
         tt-cotacao-item.chave-seq = piChaveSeq
         no-lock no-error.
    if not avail tt-cotacao-item then do:
        pcReturn = "NOK".
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "un":U        THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "mo-desc":U   THEN ASSIGN pFieldValue = RowObject.mo-desc.
        WHEN "entrega":U   THEN ASSIGN pFieldValue = RowObject.entrega.
        WHEN "descricao":U   THEN ASSIGN pFieldValue = RowObject.descricao.
        WHEN "narrativa":U   THEN ASSIGN pFieldValue = RowObject.narrativa.        
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "perc-descto":U THEN ASSIGN pFieldValue = RowObject.perc-descto.
        WHEN "pre-unit-for":U THEN ASSIGN pFieldValue = RowObject.pre-unit-for.
        WHEN "preco-fornec":U THEN ASSIGN pFieldValue = RowObject.preco-fornec.
        WHEN "preco-unit":U THEN ASSIGN pFieldValue = RowObject.preco-unit.
        WHEN "valor-descto":U THEN ASSIGN pFieldValue = RowObject.valor-descto.
        WHEN "valor-frete":U THEN ASSIGN pFieldValue = RowObject.valor-frete.
        WHEN "valor-taxa":U THEN ASSIGN pFieldValue = RowObject.valor-taxa.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "aliquota-ipi":U THEN ASSIGN pFieldValue = RowObject.aliquota-ipi.
        WHEN "aliquota-iss":U THEN ASSIGN pFieldValue = RowObject.aliquota-iss.
        WHEN "qt-acum-nec":U THEN ASSIGN pFieldValue = RowObject.qt-acum-nec.
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "mo-codigo":U     THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-dias-taxa":U  THEN ASSIGN pFieldValue = RowObject.nr-dias-taxa.
        WHEN "numero-ordem":U  THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prazo-entreg":U  THEN ASSIGN pFieldValue = RowObject.prazo-entreg.
        WHEN "seq-cotac":U     THEN ASSIGN pFieldValue = RowObject.seq-cotac.
        WHEN "cod-cond-pag":U  THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U  THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "codigo-icm":U    THEN ASSIGN pFieldValue = RowObject.codigo-icm.
        WHEN "dias-validade":U THEN ASSIGN pFieldValue = RowObject.dias-validade.
        WHEN "situacao":U      THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "chave-seq":U     THEN ASSIGN pFieldValue = RowObject.chave-seq.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ≠ndice COTACAO
  Parameters:
               retorna valor dos campos do ≠ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnumero-ordem = RowObject.numero-ordem.
    ASSIGN pcod-emitente = RowObject.cod-emitente.
    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pseq-cotac = RowObject.seq-cotac.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo lΩgico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "taxa-financ":U THEN ASSIGN pFieldValue = RowObject.taxa-financ.
        WHEN "codigo-ipi":U THEN ASSIGN pFieldValue = RowObject.codigo-ipi.
        WHEN "frete":U THEN ASSIGN pFieldValue = RowObject.frete.
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

    /*--- Verifica se temptable RowObject estˇ dispon≠vel, caso nío esteja serˇ
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
  Purpose:     Reposiciona registro com base no ≠ndice COTACAO
  Parameters:
               recebe valor dos campos do ≠ndice COTACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnumero-ordem LIKE cotacao-item.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE cotacao-item.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE cotacao-item.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pseq-cotac LIKE cotacao-item.seq-cotac NO-UNDO.

    FIND FIRST tt-cotacao-item WHERE
        tt-cotacao-item.numero-ordem = pnumero-ordem AND
        tt-cotacao-item.cod-emitente = pcod-emitente AND
        tt-cotacao-item.it-codigo    = pit-codigo AND
        tt-cotacao-item.seq-cotac    = pseq-cotac
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serˇ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE tt-cotacao-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav≤s de rowid e verifica a ocorrºncia de erros, caso
          existam erros serˇ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(tt-cotacao-item)).
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
    OPEN QUERY {&QueryName} FOR EACH tt-cotacao-item NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */ 
    
    DEF INPUT PARAM prOrdemCompra AS ROWID NO-UNDO.
    
    RUN setConstraintMain (input prOrdemCompra).


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:   Posiciona o buffer na ordem de compra atual.
  Parameters: 
             ipar1 : prOrdemCompra : Rowid da Ordem-Compra corrente
  Notes:       
------------------------------------------------------------------------------*/
        
    def input parameter prOrdemCompra as rowid no-undo.

    assign rOrdemCompra = prOrdemCompra.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


