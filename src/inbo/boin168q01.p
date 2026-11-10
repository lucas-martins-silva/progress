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
{include/i-prgvrs.i BOIN168Q01 2.00.00.025 } /*** "010025" 17/06/2025 16:40:46 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin168q01 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects)  um programa PROGRESS
                 que contm a l«gica de neg«cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini¯Êo ---*/
&GLOBAL-DEFINE DBOName it-requisicao
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-it-requisicao
&GLOBAL-DEFINE TableLabel tt-it-requisicao
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S½ a DBO principal (boin168.p) estÿ com as fun»„es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S… nela foram implementadas as triggers do dicionÿrio.
**  Para desabilitar as procedures foram usados os pr²-processadores abaixo.
**  A procedure validateRecord dessa DBO n’o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0


/*--- Include com defini¯Êo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret«rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¬ntico ao nome do DBO mas com
      extensÊo .i ---*/
{inbo/boin168q01.i tt-it-requisicao}      
{inbo/boin168q01.i RowObject}

{web/ccp/wcc0325.i}
{cdp/cdcfgmat.i}

def temp-table tt-row-solicit NO-UNDO
    field r-solicit as rowid
    field r-rowid   as rowid.

def var l-pendente    as logical no-undo.
def var i-tp-ressup   as integer no-undo.
def var i-estado-ini  as integer no-undo.
def var i-estado-fim  as integer no-undo.
def var r-documento   as rowid   no-undo.
def var i-tipo-doc    as integer no-undo.

{cdp/cdtradlist.i}

/*--- Include com defini¯Êo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera¯Êo da defini¯Êo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini¯Êo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTabelaTTRelaciona DBOProgram 
PROCEDURE carregaTabelaTTRelaciona :
/*------------------------------------------------------------------------------
  Purpose:     
    Tabela que cont²m os registros das compras 
    (parcelas das ordens) do comprador selecionado.
  Parameters:  
    i-par1 : r-ordem-compra : rowid da tabela ordem-compra
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter r-ordem-compra as rowid no-undo.

    def var de-total      as dec no-undo.
    def var c-lista-ordem as char no-undo.

    for first ordem-compra field (numero-ordem num-pedido)
        where rowid(ordem-compra) = r-ordem-compra
        no-lock: end.

    /* ZERA TEMP-TABLE */
    &IF integer(entry(1,proversion,".")) >= 9 &THEN
        empty temp-table tt-it-requisicao.
    &ELSE 
        for each tt-it-requisicao:
            delete tt-it-requisicao.
        end.
    &ENDIF

    assign c-lista-ordem  = {ininc/i02in274.i 03}.

    RUN piTradList(INPUT ',':U,
                   INPUT-OUTPUT c-lista-ordem).

    if  available ordem-compra then do:
        for each prazo-compra fields (numero-ordem parcela situacao quantidade data-entrega)
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem
            no-lock:

            create tt-it-requisicao.
            assign tt-it-requisicao.parcela         = prazo-compra.parcela 
                   tt-it-requisicao.situacao        = entry(prazo-compra.situacao,c-lista-ordem)
                   tt-it-requisicao.quantidade      = prazo-compra.quantidade
                   tt-it-requisicao.dt-entrega      = prazo-compra.data-entrega
                   tt-it-requisicao.r-rowid         = rowid(prazo-compra).

            assign de-total = 0.
            for each recebimento field (num-pedido numero-ordem parcela quant-receb)
                where recebimento.numero-ordem = ordem-compra.numero-ordem 
                and   recebimento.parcela      = prazo-compra.parcela 
                no-lock:
                   assign de-total = de-total + recebimento.quant-receb.
            end.
            assign tt-it-requisicao.qtd-rec = de-total.                                   
        end.                                   
    end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTempTable DBOProgram 
PROCEDURE carregaTempTable :
/*------------------------------------------------------------------------------
  Purpose:
    Carrega Temp-Table dos itens da requisi»’o, 
    da requisi»’o selecionada.
  Parameters:  
    ipar1 : p-requisicao : nœmero da requisi»’o 
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-requisicao as rowid   no-undo.

    def var   de-total               as decimal no-undo.

    find requisicao where rowid(requisicao) = p-requisicao no-lock no-error.

    /* ZERA TEMP-TABLE */
    &IF integer(entry(1,proversion,".")) >= 9 &THEN
        empty temp-table tt-it-requisicao.
    &ELSE 
        for each tt-it-requisicao:
            delete tt-it-requisicao.
        end.
    &ENDIF

    if  available requisicao then do:
        for each it-requisicao 
            where it-requisicao.nr-requisicao = requisicao.nr-requisicao 
            no-lock:

            if  it-requisicao.numero-ordem > 0 then do:
                for each ordem-compra fields (nr-requisicao sequencia it-codigo situacao num-pedido
                                              narrativa     cod-emitente numero-ordem)
                   where ordem-compra.nr-requisicao = it-requisicao.nr-requisicao
                     and ordem-compra.sequencia     = it-requisicao.sequencia
                     no-lock:

                    if (avail item and item.it-codigo <> ordem-compra.it-codigo)
                    or  not avail item then
                    for first item field (it-codigo desc-item tipo-contr)
                        where item.it-codigo = ordem-compra.it-codigo no-lock: end.
                    FOR FIRST item-mat WHERE
                              ITEM-mat.it-codigo = ITEM.it-codigo NO-LOCK: END.                  
                    FOR FIRST item-fornec WHERE
                              item-fornec.it-codigo = ITEM.it-codigo NO-LOCK: END.
                    create tt-it-requisicao.
                    assign tt-it-requisicao.numero-ordem   = ordem-compra.numero-ordem
                           tt-it-requisicao.sequen         = ordem-compra.sequencia
                           tt-it-requisicao.it-codigo      = ordem-compra.it-codigo
                           tt-it-requisicao.qt-requisitada = it-requisicao.qt-requisitada
                           tt-it-requisicao.r-rowid        = rowid(it-requisicao)
                           tt-it-requisicao.c-rowid        = STRING(rowid(it-requisicao))
                           tt-it-requisicao.descricao      = IF (ITEM.tipo-contr = 4 AND AVAIL item-mat AND item-mat.log-1 AND NOT AVAIL item-fornec) THEN SUBSTRING(ordem-compra.narrativa,1,60)
                                                             ELSE ITEM.desc-item
                           tt-it-requisicao.situacao-ordem = entry(ordem-compra.situacao,{ininc/i02in274.i 03}).

                    if  ordem-compra.cod-emitente > 0 and
                        ordem-compra.num-pedido   > 0 then do:

                        assign tt-it-requisicao.cod-emitente = ordem-compra.cod-emitente.

                        for first pedido-compr field (num-pedido situacao)
                            where pedido-compr.num-pedido = ordem-compra.num-pedido 
                            no-lock: end.

                        if  available pedido-compr then do:
                            assign tt-it-requisicao.num-pedido      = pedido-compr.num-pedido
                                   tt-it-requisicao.situacao-pedido = entry(pedido-compr.situacao,{ininc/i02in295.i 03})
                                   de-total = 0.                            

                            for each recebimento fields (numero-ordem quant-receb)
                                where recebimento.numero-ordem = ordem-compra.numero-ordem no-lock :
                                assign de-total = de-total + recebimento.quant-receb.
                            end.
                            assign tt-it-requisicao.quant-receb = de-total.                                                               
                        end.                                   
                    end.
                end.
            end.
            else do:
                for first item fields (it-codigo desc-item tipo-contr)
                    where item.it-codigo = it-requisicao.it-codigo no-lock: end.
                FOR FIRST item-mat WHERE
                          ITEM-mat.it-codigo = ITEM.it-codigo NO-LOCK: END.
                FOR FIRST item-fornec WHERE
                          item-fornec.it-codigo = ITEM.it-codigo NO-LOCK: END.
                create tt-it-requisicao.
                assign tt-it-requisicao.it-codigo      = it-requisicao.it-codigo
                       tt-it-requisicao.qt-requisitada = it-requisicao.qt-requisitada
                       tt-it-requisicao.r-rowid        = rowid(it-requisicao)
                       tt-it-requisicao.descricao      = IF (ITEM.tipo-contr = 4 AND AVAIL item-mat AND item-mat.log-1 AND NOT AVAIL item-fornec) THEN SUBSTRING(it-requisicao.narrativa,1,60)
                                                         ELSE ITEM.desc-item.
            end.
        end.            
    end.  
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

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÊo esteja ser˜
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
  Purpose:     Reposiciona registro com base no ðndice ITEM-REQ
  Parameters:
               recebe valor dos campos do ðndice ITEM-REQ
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE it-requisicao.it-codigo NO-UNDO.

    FIND FIRST bftt-it-requisicao WHERE
        bftt-it-requisicao.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser˜ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-it-requisicao THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravýs de rowid e verifica a ocorr¬ncia de erros, caso
          existam erros ser˜ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-it-requisicao)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE habilitaBotaoBrowserTTRelaciona DBOProgram 
PROCEDURE habilitaBotaoBrowserTTRelaciona :
/*------------------------------------------------------------------------------
  Purpose:     
    Verifica se o bot’o clicado estÿ dispon­vel para o registro 
    selecionado. E encontra o rowid de tabelas relacionadas a temp-table 
    tt-it-requisicao para abrir consultas relacionadas.
  Parameters:  
    ipar1 : r-prazo-compra : rowid da tabela tt-it-requisicao (prazo-compra)
    ipar2 : r-ordem-compra : rowid da tabela ordem-compra
    opar3 : r-recebim      : rowid da tabela recebimento
    opar4 : c-recebim      : retorna "yes" ou "no" dependendo da condi»’o
                             para habilitar o bot’o da consulta de recebimento
  Notes:       
------------------------------------------------------------------------------*/
    def input  param r-prazo-compra as rowid no-undo.
    def input  param r-ordem-compra as rowid no-undo.
    def output param r-recebim      as rowid no-undo.
    def output param c-recebim      as char  no-undo.

    def var de-total as  dec no-undo.

    for first prazo-compra fields (numero-ordem parcela)
        where rowid(prazo-compra) = r-prazo-compra
        no-lock: end.

    if  avail prazo-compra and
        can-find (first recebimento 
                  where recebimento.numero-ordem = prazo-compra.numero-ordem 
                  and   recebimento.parcela      = prazo-compra.parcela) then 
        assign c-recebim = "yes".
    else
        assign c-recebim = "no".

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
    OPEN QUERY {&QueryName} FOR EACH tt-it-requisicao NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByOrdem DBOProgram 
PROCEDURE openQueryByOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK
                                  BY {&TableName}.numero-ordem
                                  BY {&TableName}.sequen INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCopyBuffer2TT DBOProgram 
PROCEDURE afterCopyBuffer2TT:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTDigitaItRequisicao DBOProgram 
PROCEDURE carregaTTDigitaItRequisicao:
/*------------------------------------------------------------------------------
  Purpose:    

  Parameters:  
       ipar1 : pCriaNovos : 
       ipar2 : tt-param   : temp-table com par³metros/sele»’o informada pelo 
                            usuÿrio na interface.
       ipar3 : 
  Notes:       
------------------------------------------------------------------------------*/
    def input param pCriaNovos as logical no-undo.
    def input param table for tt-param.

    find first tt-param no-lock no-error.

    for first param-compra fields (log-1 int-2)
        no-lock: end.

    for first param-global fields (modulo-in)
        no-lock: end.

    if  pCriaNovos then do:
        for each tt-it-requisicao:
            delete tt-it-requisicao.
        end.
    end.

    for each requisicao 
        where requisicao.situacao       = 1 
        and   requisicao.nr-requisicao >= tt-param.i-requis-ini
        and   requisicao.nr-requisicao <= tt-param.i-requis-fim
        no-lock:

        /*  Requisicao Estoque */
        if  requisicao.tp-requis = 1 then next.

        for each it-requisicao no-lock where 
            it-requisicao.nr-requisicao = requisicao.nr-requisicao and
            it-requisicao.numero-ordem  = 0:

            /*  Aprovada */
            if  it-requisicao.estado = 2 
            or  it-requisicao.qt-atendida = it-requisicao.qt-requisitada 
            then next.

            /* Implementacao release 2.02 - Ressuprimento Manual */
            assign i-tp-ressup = 1.
            run cdp/cd1406a2.p (it-requisicao.it-codigo,
                                requisicao.cod-estabel,
                                output i-tp-ressup).
            if (it-requisicao.ct-codigo + it-requisicao.sc-codigo) = "" and i-tp-ressup <> 2 then
               next.   /* Verifica se utiliza classifica»’o contÿbil */

            /* Aprovacao Eletronica */
            assign l-pendente = no.
            if  avail it-requisicao then do:
                if  avail param-compra and param-compra.log-1 = yes then do:
                    assign r-documento = rowid(it-requisicao).
                    if requisicao.tp-requis = 1 then
                        assign i-tipo-doc = 2.
                    else if requisicao.tp-requis = 2 then
                        assign i-tipo-doc = 1.
                    else if requisicao.tp-requis = 3 then
                        assign i-tipo-doc = 5.
                    run cdp/cdapi172.p (input i-tipo-doc, input r-documento, output l-pendente).
                end.
            end.
            if l-pendente = yes then next.

            for first item fields (it-codigo char-2 cod-comprado cod-obsoleto tipo-contr ge-codigo
                                   fm-codigo tipo-contr) 
                where item.it-codigo = it-requisicao.it-codigo no-lock: end.
            if  not avail item then next.

            &if defined(bf_mat_uni_estab) &then /*vock*/ 
            if avail requisicao then
            for first item-uni-estab fields (it-codigo cod-estabel cod-grp-compra cod-comprado cod-obsoleto)
                where item-uni-estab.it-codigo   = item.it-codigo 
                and   item-uni-estab.cod-estabel = requisicao.cod-estabel 
                    no-lock:
                end.
            if  avail item-uni-estab then do:
                if  param-compra.int-2 = 1 then do:
                    if  not can-find (grupo-compra where 
                                      grupo-compra.cod-grp-compra = item-uni-estab.cod-grp-compra )
                    then next.
                end.
                else if param-compra.int-2 = 2 then do:
                    if  not can-find (comprador where 
                                      comprador.cod-comprado = item-uni-estab.cod-comprado )
                    then next.
                end.

                if  item-uni-estab.cod-obsoleto = 2
                or  item-uni-estab.cod-obsoleto = 3
                or  item-uni-estab.cod-obsoleto = 4 then next.
            end.
            else 
            &else
                &if defined(bf_mat_tipo_ressup) &then 
                    if avail requisicao THEN
                    find item-mat-estab where 
                         item-mat-estab.it-codigo = item.it-codigo and
                         item-mat-estab.cod-estabel = requisicao.cod-estabel no-lock no-error.
                    if  avail item-mat-estab then do:
                        if param-compra.int-2 = 1 then do:
                            find grupo-compra where 
                                 grupo-compra.cod-grp-compra = item-mat-estab.cod-grp-compra no-lock no-error.
                            if  not avail grupo-compra then next.
                        end.
                        else if param-compra.int-2 = 2 then do:
                            find comprador where 
                                 comprador.cod-comprado = item-mat-estab.cod-comprado no-lock no-error.
                            if  not avail comprador then next.
                        end.

                        if  item-mat-estab.cod-obsoleto = 2
                        or  item-mat-estab.cod-obsoleto = 3
                        or  item-mat-estab.cod-obsoleto = 4 then next.
                    end.
                    else
                &else
                &endif
            &endif
            do:
                if  param-compra.int-2 = 1 then do:
                    find grupo-compra where
                         &if "{&mgind_dbtype}" = "progress" &then
                         grupo-compra.cod-grp-compra = substr(item.char-2,188,12) no-lock no-error.
                         &else
                         grupo-compra.cod-grp-compra = substr(item.char-2,88,12) no-lock no-error.
                         &endif
                    if  not avail grupo-compra then next.
                end.
                else if param-compra.int-2 = 2 then do:
                    if  not can-find (comprador where 
                                      comprador.cod-comprado = item.cod-comprado )
                    then next.
                end.

                if  item.cod-obsoleto = 2
                or  item.cod-obsoleto = 3
                or  item.cod-obsoleto = 4 then next.
            end.

            if  (tt-param.l-agrup-itens and
                (item.tipo-contr = 4 or (it-requisicao.num-ord-inv <> 0 AND param-global.modulo-in))) then next.

            if  item.ge-codigo    >= tt-param.i-grup-estoq-ini
            and item.ge-codigo    <= tt-param.i-grup-estoq-fim
            and item.it-codigo    >= tt-param.c-item-ini
            and item.it-codigo    <= tt-param.c-item-fim
            and item.fm-codigo    >= tt-param.c-familia-ini
            and item.fm-codigo    <= tt-param.c-familia-fim
            and ((avail item-uni-estab and item-uni-estab.cod-comprado >= tt-param.c-comprador-ini
                                       and item-uni-estab.cod-comprado <= tt-param.c-comprador-fim) 
                  or (item.cod-comprado >= tt-param.c-comprador-ini and
                      item.cod-comprado <= tt-param.c-comprador-fim))
            then do:
                if  tt-param.l-agrup-itens then do:

                    find first tt-it-requisicao
                         where tt-it-requisicao.nr-requis      = it-requisicao.nr-requisicao
                         and   tt-it-requisicao.sequen         = it-requisicao.sequencia
                         and   tt-it-requisicao.it-codigo      = it-requisicao.it-codigo
                        no-error.
                    /* n’o deixa acumular quantidade ao executar sem selecionar */
                    if not avail tt-it-requisicao and pCriaNovos = no then do:
                        find first tt-it-requisicao
                            where tt-it-requisicao.nr-requis  = it-requisicao.nr-requisicao
                            and   tt-it-requisicao.it-codigo      = it-requisicao.it-codigo
                            no-error.
                    end.

                    /* n’o deixa duplicar */
                    if  avail tt-it-requisicao then
                        next.

                    find first tt-it-requisicao
                         where tt-it-requisicao.nr-requis      = it-requisicao.nr-requisicao
                           and tt-it-requisicao.it-codigo      = it-requisicao.it-codigo
                           and tt-it-requisicao.num-ord-inv    = it-requisicao.num-ord-inv
                           and tt-it-requisicao.cod-estabel    = it-requisicao.cod-estabel
                           and tt-it-requisicao.ct-codigo      = it-requisicao.ct-codigo 
                           and tt-it-requisicao.sc-codigo      = it-requisicao.sc-codigo no-error.
                    if not avail tt-it-requisicao then do:
                        create tt-it-requisicao.
                        assign tt-it-requisicao.nr-requis      = it-requisicao.nr-requisicao
                               tt-it-requisicao.sequen         = it-requisicao.sequencia
                               tt-it-requisicao.it-codigo      = it-requisicao.it-codigo
                               tt-it-requisicao.un             = it-requisicao.un
                               tt-it-requisicao.qt-requisitada = it-requisicao.qt-requisitada
                               tt-it-requisicao.dt-entrega     = if it-requisicao.dt-entrega >= today then it-requisicao.dt-entrega else today
                               tt-it-requisicao.num-ord-inv    = it-requisicao.num-ord-inv
                               tt-it-requisicao.cod-estabel    = it-requisicao.cod-estabel
                               tt-it-requisicao.ct-codigo      = it-requisicao.ct-codigo
                               tt-it-requisicao.sc-codigo      = it-requisicao.sc-codigo
                               tt-it-requisicao.urgente        = it-requisicao.log-1
                               tt-it-requisicao.homologa       = it-requisicao.log-2
                               tt-it-requisicao.r-rowid        = rowid(it-requisicao)
                               tt-it-requisicao.c-rowid        = string(rowid(it-requisicao))
                               tt-it-requisicao.afeta-qld      = if substring(it-requisicao.char-1,1,1,"character") = "Y" then yes else no.
                    end.
                    else
                        assign tt-it-requisicao.qt-requisitada = tt-it-requisicao.qt-requisitada + it-requisicao.qt-requisitada.
                end.
                else do:
                    find first tt-it-requisicao 
                         where tt-it-requisicao.nr-requis  = it-requisicao.nr-requisicao
                           and tt-it-requisicao.sequen     = it-requisicao.sequencia
                           and tt-it-requisicao.it-codigo  = it-requisicao.it-codigo no-error.
                    if not avail tt-it-requisicao then do:
                        create tt-it-requisicao.
                        assign tt-it-requisicao.nr-requis  = it-requisicao.nr-requisicao
                               tt-it-requisicao.sequen     = it-requisicao.sequencia
                               tt-it-requisicao.it-codigo  = it-requisicao.it-codigo
                               tt-it-requisicao.un         = it-requisicao.un.
                    end.
                    assign tt-it-requisicao.qt-requisitada = it-requisicao.qt-requisitada
                           tt-it-requisicao.dt-entrega     = if it-requisicao.dt-entrega >= today then it-requisicao.dt-entrega else today
                           tt-it-requisicao.num-ord-inv    = it-requisicao.num-ord-inv
                           tt-it-requisicao.cod-estabel    = it-requisicao.cod-estabel
                           tt-it-requisicao.ct-codigo      = it-requisicao.ct-codigo
                           tt-it-requisicao.sc-codigo      = it-requisicao.sc-codigo
                           tt-it-requisicao.urgente        = it-requisicao.log-1
                           tt-it-requisicao.homologa       = it-requisicao.log-2
                           tt-it-requisicao.r-rowid        = rowid(it-requisicao)
                           tt-it-requisicao.c-rowid        = string(rowid(it-requisicao))
                           tt-it-requisicao.afeta-qld      = if substring(it-requisicao.char-1,1,1,"character") = "Y" then yes else no.
                end.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTDigitaItRequisicao2 DBOProgram 
PROCEDURE carregaTTDigitaItRequisicao2:
/*------------------------------------------------------------------------------
  Purpose:    

  Parameters:  
       ipar1 :  : 
       ipar2 : 
       ipar3 : 
  Notes:       
------------------------------------------------------------------------------*/
    def input param table for tt-row-solicit.

    for each tt-row-solicit:
        find first it-requisicao no-lock 
             where rowid(it-requisicao) = tt-row-solicit.r-solicit no-error.
        if avail it-requisicao then do:
            create tt-it-requisicao.
            assign tt-it-requisicao.nr-requis  = it-requisicao.nr-requisicao
                   tt-it-requisicao.sequen         = it-requisicao.sequencia
                   tt-it-requisicao.it-codigo      = it-requisicao.it-codigo
                   tt-it-requisicao.un             = it-requisicao.un
                   tt-it-requisicao.qt-requisitada = it-requisicao.qt-requisitada
                   tt-it-requisicao.dt-entrega     = if it-requisicao.dt-entrega >= today then it-requisicao.dt-entrega else today
                   tt-it-requisicao.num-ord-inv    = it-requisicao.num-ord-inv
                   tt-it-requisicao.cod-estabel    = it-requisicao.cod-estabel
                   tt-it-requisicao.ct-codigo      = it-requisicao.ct-codigo
                   tt-it-requisicao.sc-codigo      = it-requisicao.sc-codigo
                   tt-it-requisicao.urgente        = it-requisicao.log-1
                   tt-it-requisicao.homologa       = it-requisicao.log-2
                   tt-it-requisicao.r-rowid        = rowid(it-requisicao)
                   tt-it-requisicao.c-rowid        = string(rowid(it-requisicao))
                   tt-it-requisicao.afeta-qld      = if substring(it-requisicao.char-1,1,1,"character") = "Y" then yes else no.
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
    DEFINE OUTPUT PARAMETER pFieldValue AS CHAR NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÊo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "c-rowid" THEN pFieldValue = RowObject.c-rowid.    
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "descricao":U THEN ASSIGN pFieldValue = RowObject.descricao. 
        WHEN "situacao-ordem":U THEN ASSIGN pFieldValue = RowObject.situacao-ordem.                    
        WHEN "situacao-pedido":U THEN ASSIGN pFieldValue = RowObject.situacao-pedido.                            
        WHEN "ct-codigo":U THEN ASSIGN pFieldValue = RowObject.ct-codigo.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
        WHEN "c-rowid":U THEN ASSIGN pFieldValue = RowObject.c-rowid.        
    end Case.
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

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÊo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-requis":U THEN ASSIGN pFieldValue = RowObject.nr-requis.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.        
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.        
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.        
    END CASE.

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

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÊo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "qt-requisitada":U THEN ASSIGN pFieldValue = RowObject.qt-requisitada.
        WHEN "quant-receb":U THEN ASSIGN pFieldValue = RowObject.quant-receb.        
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

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÊo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dt-entrega":U THEN ASSIGN pFieldValue = RowObject.dt-entrega.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l«gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est˜ disponðvel, caso nÊo esteja ser˜
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "urgente":U THEN ASSIGN pFieldValue = RowObject.urgente.
        WHEN "homologa":U THEN ASSIGN pFieldValue = RowObject.homologa.
        WHEN "afeta-qld":U THEN ASSIGN pFieldValue = RowObject.afeta-qld.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

