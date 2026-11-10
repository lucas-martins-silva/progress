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
{include/i-prgvrs.i BOIN274Q02 2.00.00.047 } /*** "010047" 23/11/2023 16:19:45  ***/
/*--------------------------------------------------------------------------
    File       : 
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
&GLOBAL-DEFINE DBOName tt-ordem-compra
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName tt-ordem-compra
&GLOBAL-DEFINE TableLabel tt-ordem-compra
&GLOBAL-DEFINE QueryName qr{&TableName}

/*********************************************************************************
**  S¢ a DBO principal (boin274.p) est† com as funá‰es de inclui (createRecord), 
**  modifica (updateRecord) e elimina (deleteRecord) habilitadas, 
**  porque S‡ nela foram implementadas as triggers do dicion†rio.
**  Para desabilitar as procedures foram usados os prÇ-processadores abaixo.
**  A procedure validateRecord dessa DBO n∆o deve ser usada.
*********************************************************************************/
&GLOBAL-DEFINE EXCLUDE-createRecord 0
&GLOBAL-DEFINE EXCLUDE-updateRecord 0
&GLOBAL-DEFINE EXCLUDE-deleteRecord 0
&GLOBAL-DEFINE EXCLUDE-getRowid

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin274q02.i tt-ordem-compra}
{inbo/boin274q02.i RowObject}


def temp-table rowsOrdem NO-UNDO
    field i-seq        AS INT 
    field r-ordem      as ROWID
    field r-prazo      as ROWID.

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.
DEFINE BUFFER bfordem-compra FOR ordem-compra.

{ccp/cc9019.i1}
/*---------- Include de PrÇ-Processadores -------------*/
{cdp/cdcfgmat.i}

/* Definiá∆o tt-param e tt-raw-digita */

{ccp/cc0311.i3}

define temp-table tt-digita
    field marca          as char format "x(01)"  COLUMN-LABEL ""
    field numero-ordem   like ordem-compra.numero-ordem
    field it-codigo      like ordem-compra.it-codigo
    field cod-emitente   like ordem-compra.cod-emitente
    field cod-estabel    like ordem-compra.cod-estabel
    field cod-comprado   like ordem-compra.cod-comprado
    field nr-processo    like ordem-compra.nr-processo
    field num-pedido     like ordem-compra.num-pedido
    field natureza       like ordem-compra.natureza
    field cod-transp     like ordem-compra.cod-transp
    field data-cotacao   like ordem-compra.data-cotacao
    field cod-cond-pag   like ordem-compra.cod-cond-pag
    index id is primary unique numero-ordem.

def temp-table tt-row-pedido NO-UNDO
    field r-pedido as rowid
    field r-rowid   as rowid.

DEF VAR i-cont2 AS INT NO-UNDO.

/*----------  -------------*/
def var  c-nome-abrev   as char    no-undo.
def var  c-descricao    as char    no-undo.
def var  h-boin274na    as handle  no-undo.
def var  l-aberto       as logical no-undo.
def var  l-aprovado     as logical no-undo.
def var  l-nao-aprovado as logical no-undo.
def var  l-fechado      as logical no-undo.
def var  l-pendente     as logical no-undo.
def var  l-ordem        as logical no-undo.
def var  l-existeOrdem  as logical no-undo initial no.


def var  de-total       as dec     no-undo.

def var c-naveg   as char  no-undo.
def var r-ord-compra as ROWID no-undo.

def var r-first   as ROWID no-undo.
def var r-last    as ROWID no-undo.
def var r-aux-pri as ROWID no-undo.

def var linha-aux  as int no-undo.
def var i-nrlinhas as int no-undo.

/*--Definiá∆o variaveis usadas nas procedures--*/
def var i-nr-processo as int no-undo.

def var c-lista-situacao     as char no-undo.
def var c-lista-natureza     as char no-undo.


/* Procedure de traduá∆o */
{cdp/cdtradlist.i}

assign c-lista-situacao = {ininc/i02in274.i 03} 
       c-lista-natureza = {ininc/i01in274.i 03}.

RUN piTradList(INPUT ',':U,
               INPUT-OUTPUT c-lista-situacao).

RUN piTradList(INPUT ',':U,
               INPUT-OUTPUT c-lista-natureza).

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
         HEIGHT             = 2.13
         WIDTH              = 40.86.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterRepositionRecord DBOProgram 
PROCEDURE afterRepositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param prChave as rowid no-undo.

    find {&TABLENAME} where
         {&TABLENAME}.r-rowid = prChave no-lock no-error.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTDigitaOrdemCompra DBOProgram 
PROCEDURE carregaTTDigitaOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
              ipar1 : pCriaNovos   :
              ipar2 : pCodComprado :
              ipar3 : pOrdemIni    :
              ipar4 : pOrdemFim    :
              ipar5 : pItemIni     :
              ipar6 : pItemFim     :
              ipar7 : pDataIni     :
              ipar8 : pDataFim     :
              ipar9 : tt-param     : temp-table com parÉmetros/seleá∆o informada pelo 
                                     usu†rio na interface.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCriaNovos   AS LOGICAL                     NO-UNDO.
    DEFINE INPUT PARAMETER pOrdemIni    LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pOrdemFim    LIKE ordem-compra.numero-ordem NO-UNDO.
    DEFINE INPUT PARAMETER pItemIni     LIKE ordem-compra.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pItemFim     LIKE ordem-compra.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pDataIni     LIKE ordem-compra.data-cotacao NO-UNDO.
    DEFINE INPUT PARAMETER pDataFim     LIKE ordem-compra.data-cotacao NO-UNDO.
    DEFINE INPUT PARAMETER table for tt-param.

    find first tt-param no-lock no-error.
    if pCriaNovos then do:
        &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
            EMPTY TEMP-TABLE tt-ordem-compra.
        &ELSE                                                  
            FOR EACH tt-ordem-compra:
                DELETE tt-ordem-compra.
            END.
        &ENDIF
    end.


    for each  estabelec field (cod-estabel) no-lock
        where estabelec.cod-estabel >= tt-param.c-estabel-ini  
        and   estabelec.cod-estabel <= tt-param.c-estabel-fim,
        each  ordem-compra fields (numero-ordem it-codigo cod-emitente cod-estabel 
                                   cod-comprado nr-processo num-pedido natureza 
                                   cod-transp data-cotacao cod-cond-pag)
        where ordem-compra.numero-ordem >= pOrdemIni               
          and ordem-compra.numero-ordem <= pOrdemFim               
          and ordem-compra.situacao      = 3                       
          and ordem-compra.cod-estabel   = estabelec.cod-estabel
          and ordem-compra.num-pedido    = 0                       
          and ordem-compra.cod-cond-pag >= 0                       
          and ordem-compra.cod-emitente >= tt-param.i-forn-ini     
          and ordem-compra.cod-emitente <= tt-param.i-forn-fim     
          and ordem-compra.cod-comprado >= tt-param.c-comp-ini     
          and ordem-compra.cod-comprado <= tt-param.c-comp-fim     
          and ordem-compra.nr-processo  >= tt-param.i-processo-ini 
          and ordem-compra.nr-processo  <= tt-param.i-processo-fim 
          and ordem-compra.it-codigo    >= pItemIni                
          and ordem-compra.it-codigo    <= pItemFim                
          and ordem-compra.data-cotacao >= pDataIni                
          and ordem-compra.data-cotacao <= pDataFim                
          and ordem-compra.expectativa   = no no-lock:
            find first tt-ordem-compra
                 where tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem no-error.
             if avail tt-ordem-compra then
                 next.
             else do:
                 create tt-ordem-compra.
                 assign tt-ordem-compra.numero-ordem   = ordem-compra.numero-ordem                              
                        tt-ordem-compra.it-codigo      = ordem-compra.it-codigo
                        tt-ordem-compra.cod-emitente   = ordem-compra.cod-emitente
                        tt-ordem-compra.cod-estabel    = ordem-compra.cod-estabel
                        tt-ordem-compra.cod-comprado   = ordem-compra.cod-comprado
                        tt-ordem-compra.nr-processo    = ordem-compra.nr-processo
                        tt-ordem-compra.num-pedido     = ordem-compra.num-pedido
                        tt-ordem-compra.natureza       = string(ordem-compra.natureza)
                        tt-ordem-compra.cod-transp     = ordem-compra.cod-transp
                        tt-ordem-compra.data-cotacao   = ordem-compra.data-cotacao
                        tt-ordem-compra.cod-cond-pag   = ordem-compra.cod-cond-pag
                        tt-ordem-compra.r-rowid        = rowid(ordem-compra)
                        tt-ordem-compra.c-rowid        = string(rowid(ordem-compra)).
             end.
    end.

    assign pCriaNovos = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTDigitaOrdemCompra2 DBOProgram 
PROCEDURE carregaTTDigitaOrdemCompra2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-row-pedido.

    FOR EACH tt-row-pedido,
        FIRST ordem-compra FIELDS( numero-ordem it-codigo cod-emitente cod-estabel 
                                   cod-comprado nr-processo num-pedido natureza 
                                   cod-transp data-cotacao cod-cond-pag )
        WHERE ROWID(ordem-compra) = tt-row-pedido.r-pedido NO-LOCK:
            CREATE tt-ordem-compra.
            ASSIGN tt-ordem-compra.numero-ordem  = ordem-compra.numero-ordem
                   tt-ordem-compra.it-codigo     = ordem-compra.it-codigo
                   tt-ordem-compra.cod-emitente  = ordem-compra.cod-emitente
                   tt-ordem-compra.cod-estabel   = ordem-compra.cod-estabel
                   tt-ordem-compra.cod-comprado  = ordem-compra.cod-comprado
                   tt-ordem-compra.nr-processo   = ordem-compra.nr-processo
                   tt-ordem-compra.num-pedido    = ordem-compra.num-pedido
                   tt-ordem-compra.natureza      = STRING(ordem-compra.natureza)
                   tt-ordem-compra.cod-transp    = ordem-compra.cod-transp
                   tt-ordem-compra.data-cotacao  = ordem-compra.data-cotacao
                   tt-ordem-compra.cod-cond-pag  = ordem-compra.cod-cond-pag
                   tt-ordem-compra.r-rowid       = ROWID(ordem-compra)
                   tt-ordem-compra.c-rowid       = STRING(ROWID(ordem-compra)).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraComPedido DBOProgram 
PROCEDURE carregaTTOrdemCompraComPedido :
/*------------------------------------------------------------------------------
  Purpose:     CarregaTempTableOrdemCompra02
    Carrega a temp-table tt-ordem-compra com base no n£mero do pedido informado
  Parameters:
    ipar1: pi-num-pedido  : n£mero do pedido
    ipar2: tt-ordem-rowid : rowid das ordens cadastradas e q n∆o devem ser incluidas na temp-table
  Notes:   
------------------------------------------------------------------------------*/

    def input param pi-num-pedido as int  no-undo.
    def input param table for tt-ordem-rowid.

    for each ordem-compra fields(num-pedido numero-ordem it-codigo)
              where ordem-compra.num-pedido = pi-num-pedido no-lock:
              create tt-ordem-compra.
              assign tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem
                     tt-ordem-compra.it-codigo    = ordem-compra.it-codigo
                     tt-ordem-compra.r-rowid      = rowid(ordem-compra).
    end.

    for each tt-ordem-rowid no-lock:
        find tt-ordem-compra where
             tt-ordem-compra.r-rowid = tt-ordem-rowid.r-rowid and
             tt-ordem-rowid.c-param  = "del" no-error.
        if avail tt-ordem-compra then do:
            delete tt-ordem-compra.
        end.
        else do:
            FOR FIRST ordem-compra FIELDS (numero-ordem it-codigo)
                WHERE ROWID(ordem-compra) = tt-ordem-rowid.r-rowid NO-LOCK: END.
            if avail ordem-compra then do:
                  create tt-ordem-compra.
                  assign tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem
                         tt-ordem-compra.it-codigo    = ordem-compra.it-codigo
                         tt-ordem-compra.r-rowid      = rowid(ordem-compra).
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraComSituacao DBOProgram 
PROCEDURE carregaTTOrdemCompraComSituacao :
/*------------------------------------------------------------------------------
  Purpose:    carregarTempTableOrdemCompra
    Carrega a temp table Ordem de compra quando situaá∆o igual 5 (em cotaá∆o) 
    ou igual a 1 (n∆o confirmada). 
  Parameters:
    ipar1: pi-nr-processo : n£mero do processo
  Notes:      
------------------------------------------------------------------------------*/
    DEF INPUT PARAMETER pi-nr-processo AS INT NO-UNDO.

    ASSIGN i-nr-processo = pi-nr-processo.

    FOR EACH tt-ordem-compra:
        DELETE tt-ordem-compra.
    END.

    FOR EACH ordem-compra FIELDS ( numero-ordem it-codigo nr-processo )
       WHERE ordem-compra.nr-processo = i-nr-processo 
         AND (ordem-compra.situacao = 5 OR ordem-compra.situacao = 1) NO-LOCK,
       FIRST cotacao-item FIELDS ( )
       WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem
         AND cotacao-item.data-cotacao <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 11/11/1111 &ENDIF 
         AND TODAY <= (cotacao-item.data-cotacao + cotacao-item.dias-validade) NO-LOCK:
            CREATE tt-ordem-compra.
            ASSIGN tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem
                   tt-ordem-compra.it-codigo    = ordem-compra.it-codigo
                   tt-ordem-compra.r-rowid      = ROWID(ordem-compra)
                   tt-ordem-compra.nr-processo  = ordem-compra.nr-processo. 
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraPorCodComprado DBOProgram 
PROCEDURE carregaTTOrdemCompraPorCodComprado :
/*------------------------------------------------------------------------------
  Purpose:     carregaTabelaTTOrdemCompra
    Carrega tabela de ordem-compra, abrindo a query de acordo com valores 
    parametrizados.Na criaá∆o da tabela ordem-compra ela recebe valores 
    das tabelas pedido-compr e cotacao-item.
  Parameters:  
    ipar1 : r-comprador    : rowid da tabela comprador
    ipar2 : da-emissao-ini : data de emissao inicial
    ipar3 : da-emissao-fim : data de emissao final
    ipar4 : c-estab-ini    : estabelecimento inicial
    ipar5 : c-estab-fim    : estabelecimento final
    ipar6 : c-nao-confir   : situacao do documento - Nao Confirmado
    ipar7 : c-confir       : situacao do documento - Confirmado
    ipar8 : c-cotada       : situacao do documento - Cotado
    ipar9 : c-elimin       : situacao do documento - Eliminado 
    ipar10: c-em-cotacao   : situacao do documento - Em Cotaá∆o
    ipar11: c-receb        : situacao do documento - Recebido 
    ipar12: c-compra       : natureza do documento - Compra
    ipar13: c-servico      : natureza do documento - Servico
    ipar14: c-benefi       : natureza do documento - Beneficiamento
    ipar15: i-apresentacao : n≠vel do documento - 1 = Ordem 2 = Cotacao 3 = Pedido 4 = Recebimento  
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-cod-comprado  AS CHAR  NO-UNDO.
DEF INPUT PARAM da-emissao-ini  AS DATE  NO-UNDO.
DEF INPUT PARAM da-emissao-fim  AS DATE  NO-UNDO. 
DEF INPUT PARAM c-estab-ini     AS CHAR  NO-UNDO.
DEF INPUT PARAM c-estab-fim     AS CHAR  NO-UNDO.
DEF INPUT PARAM c-naocon        AS CHAR  NO-UNDO.
DEF INPUT PARAM c-confir        AS CHAR  NO-UNDO.
DEF INPUT PARAM c-cotada        AS CHAR  NO-UNDO.
DEF INPUT PARAM c-elimin        AS CHAR  NO-UNDO.
DEF INPUT PARAM c-em-cotacao    AS CHAR  NO-UNDO.
DEF INPUT PARAM c-receb         AS CHAR  NO-UNDO.
DEF INPUT PARAM c-compra        AS CHAR  NO-UNDO.
DEF INPUT PARAM c-servico       AS CHAR  NO-UNDO.
DEF INPUT PARAM c-benefi        AS CHAR  NO-UNDO.
DEF INPUT PARAM i-apresentacao  AS INT   NO-UNDO.    
DEF INPUT PARAM p-navigation    AS CHAR  NO-UNDO.
DEF INPUT PARAM p-max-return    AS INT   NO-UNDO.                                                             
DEF INPUT PARAM l-change-father AS LOG   NO-UNDO.
DEF INPUT PARAM p-programa      AS CHAR  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-last-displayed  AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-first-displayed AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-first-base      AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-last-base       AS ROWID NO-UNDO.

DEF VAR i-count-records AS INT NO-UNDO.

def var l-ok                 as log  no-undo.
def var lg_nao_confirmada    as log  no-undo.
def var lg_confirmada        as log  no-undo.
def var lg_cotada            as log  no-undo. 
def var lg_eliminada         as log  no-undo.
def var lg_em_cotacao        as log  no-undo.
def var lg_recebida          as log  no-undo.
def var lg_compra            as log  no-undo. 
def var lg_servico           as log  no-undo.
def var lg_beneficiamento    as log  no-undo.
def var c-natureza           as char no-undo.
def var c-lista-natureza     as char no-undo.
def var c-lista-situacao     as char no-undo.
def var c-lista-pedido       as char no-undo.
def var de-total             as dec  no-undo.    

    assign    
        lg_nao_confirmada   = if c-naocon     = "yes" then YES else NO
        lg_confirmada       = if c-confir     = "yes" then YES else NO
        lg_cotada           = if c-cotada     = "yes" then YES else NO 
        lg_eliminada        = if c-elimin     = "yes" then YES else NO
        lg_em_cotacao       = if c-em-cotacao = "yes" then YES else NO
        lg_recebida         = if c-receb      = "yes" then YES else NO
        lg_compra           = if c-compra     = "yes" then YES else NO
        lg_servico          = if c-servico    = "yes" then YES else NO
        lg_beneficiamento   = if c-benefi     = "yes" then YES else NO .

    assign  c-lista-situacao = {ininc/i02in274.i 03} 
            c-lista-natureza = {ininc/i01in274.i 03}
            c-lista-pedido   = {ininc/i02in295.i 03} .

    /* O prÇ-processador abaixa testa a vers∆o do PROGRESS */
    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-ordem-compra.
    &ELSE                                                  
        FOR EACH tt-ordem-compra:
            DELETE tt-ordem-compra.
        END.
    &ENDIF

     /* Quando o primeiro e o £ltimo registro do browse forem desconhecidos, comeáa
       a pesquisa pelo primeiro registro que se encaixar na seleá∆o */
    IF  p-last-displayed = ? 
    AND p-first-displayed = ? THEN DO:
        ASSIGN p-navigation = "Next":U.
        FIND FIRST ordem-compra
             WHERE ordem-compra.cod-comprado = p-cod-comprado 
               AND ordem-compra.data-emissao >= da-emissao-ini 
               AND ordem-compra.data-emissao <= da-emissao-fim 
               AND ordem-compra.cod-estabel  >= c-estab-ini 
               AND ordem-compra.cod-estabel  <= c-estab-fim 
               AND (   (ordem-compra.situacao = 1 AND lg_nao_confirmada) 
                    OR (ordem-compra.situacao = 2 AND lg_confirmada) 
                    OR (ordem-compra.situacao = 3 AND lg_cotada) 
                    OR (ordem-compra.situacao = 4 AND lg_eliminada) 
                    OR (ordem-compra.situacao = 5 AND lg_em_cotacao) 
                    OR (ordem-compra.situacao = 6 AND lg_recebida)) 
               AND (   (ordem-compra.natureza = 1 AND lg_compra) 
                    OR (ordem-compra.natureza = 2 AND lg_servico) 
                    OR (ordem-compra.natureza = 3 AND lg_beneficiamento)) NO-LOCK NO-ERROR.

    END.
    ELSE DO:
        /* Sen∆o comeáa a pesquisa a partir do registro que contenha o rowid
           recebido como parÉmetro */
        IF  p-navigation = "Prev":U THEN DO:
            IF p-programa = "WProg.w" THEN
                FIND ordem-compra WHERE 
                    ROWID(ordem-compra) = p-first-displayed NO-LOCK NO-ERROR.
             ELSE DO:

                FIND ordem-compra WHERE 
                    ROWID(ordem-compra) = p-first-displayed NO-LOCK NO-ERROR.

                /* Quando a navegaá∆o for "Prev" posiciona no registro anterior ao
                   primeiro mostrado no browse */ 
                IF  AVAIL ordem-compra THEN
                    FIND PREV  ordem-compra USE-INDEX comprador
                         WHERE ordem-compra.cod-comprado = p-cod-comprado 
                           AND ordem-compra.data-emissao >= da-emissao-ini 
                           AND ordem-compra.data-emissao <= da-emissao-fim 
                           AND ordem-compra.cod-estabel  >= c-estab-ini 
                           AND ordem-compra.cod-estabel  <= c-estab-fim 
                           AND (   (ordem-compra.situacao = 1 AND lg_nao_confirmada) 
                                OR (ordem-compra.situacao = 2 AND lg_confirmada) 
                                OR (ordem-compra.situacao = 3 AND lg_cotada) 
                                OR (ordem-compra.situacao = 4 AND lg_eliminada) 
                                OR (ordem-compra.situacao = 5 AND lg_em_cotacao) 
                                OR (ordem-compra.situacao = 6 AND lg_recebida)) 
                           AND (   (ordem-compra.natureza = 1 AND lg_compra) 
                                OR (ordem-compra.natureza = 2 AND lg_servico) 
                                OR (ordem-compra.natureza = 3 AND lg_beneficiamento)) NO-LOCK NO-ERROR.
             END.
        END.
        ELSE IF p-navigation = "Next":U THEN DO:
            /* Quando a navegaá∆o for "Next" posiciona o browser baseado
                   no £ltimo mostrado no browse */
            IF p-programa = "WProg.W" THEN
                FIND ordem-compra WHERE
                    ROWID(ordem-compra) = p-last-displayed NO-LOCK NO-ERROR.
            ELSE DO:

                FIND ordem-compra WHERE 
                    ROWID(ordem-compra) = p-last-displayed NO-LOCK NO-ERROR.
                /* Quando a navegaá∆o for "Next" posiciona no "PR‡XIMO" registro baseado
                   no £ltimo mostrado no browse */
                IF  AVAIL ordem-compra THEN
                    FIND NEXT  ordem-compra USE-INDEX comprador
                         WHERE ordem-compra.cod-comprado = p-cod-comprado 
                           AND ordem-compra.data-emissao >= da-emissao-ini 
                           AND ordem-compra.data-emissao <= da-emissao-fim 
                           AND ordem-compra.cod-estabel  >= c-estab-ini 
                           AND ordem-compra.cod-estabel  <= c-estab-fim 
                           AND (   (ordem-compra.situacao = 1 AND lg_nao_confirmada) 
                                OR (ordem-compra.situacao = 2 AND lg_confirmada) 
                                OR (ordem-compra.situacao = 3 AND lg_cotada) 
                                OR (ordem-compra.situacao = 4 AND lg_eliminada) 
                                OR (ordem-compra.situacao = 5 AND lg_em_cotacao) 
                                OR (ordem-compra.situacao = 6 AND lg_recebida)) 
                           AND (   (ordem-compra.natureza = 1 AND lg_compra) 
                                OR (ordem-compra.natureza = 2 AND lg_servico) 
                                OR (ordem-compra.natureza = 3 AND lg_beneficiamento)) NO-LOCK NO-ERROR.
            END.
        END.
    END.

    /* Se existir pelo menos um registro dispon°vel, entra no bloco de repetiá∆o que
       efetivamente criar† a temp-table que ser† retornada para ser mostrada no browse */
    IF  AVAIL ordem-compra THEN REPEAT ON ERROR UNDO, RETURN "NOK":U:

      ASSIGN l-ok = NO.         

      FOR FIRST prazo-compra FIELDS()
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK: END.


         find first cotacao-item where
                cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                cotacao-item.cot-aprovada = yes
                no-lock no-error.

         find pedido-compr where
                pedido-compr.num-pedido = ordem-compra.num-pedido
                no-lock no-error.

            if i-apresentacao = 1 then 
                assign l-ok = yes.

            if i-apresentacao = 2 and
               available cotacao-item then 
                    assign l-ok = yes.

            if available pedido-compr then do:
                if i-apresentacao = 3 then 
                    assign l-ok = yes.

                 FOR FIRST recebimento FIELDS()
                     WHERE recebimento.num-pedido   = pedido-compr.num-pedido 
                       AND recebimento.numero-ordem = ordem-compra.numero-ordem 
                       AND recebimento.qtd-rec > 0 NO-LOCK: END.

                   IF AVAIL recebimento 
                   AND i-apresentacao = 4 THEN
                       ASSIGN l-ok = YES.
            end.        

        IF l-ok THEN DO:
            CREATE tt-ordem-compra.
            ASSIGN tt-ordem-compra.numero-ordem    = ordem-compra.numero-ordem
                   tt-ordem-compra.it-codigo       = ordem-compra.it-codigo
                   tt-ordem-compra.situacao        = ENTRY(ordem-compra.situacao, c-lista-situacao)
                   tt-ordem-compra.natureza        = ENTRY(ordem-compra.natureza, c-lista-natureza)
                   tt-ordem-compra.data-emissao    = ordem-compra.data-emissao
                   tt-ordem-compra.cod-emitente    = ( IF AVAILABLE cotacao-item THEN
                                                       cotacao-item.cod-emitente ELSE 0 )
                   tt-ordem-compra.num-pedido      = ( IF AVAILABLE pedido-compr THEN
                                                       pedido-compr.num-pedido ELSE 0 )
                   tt-ordem-compra.situacao-pedido = ( IF AVAILABLE pedido-compr THEN
                                                       ENTRY(pedido-compr.situacao,c-lista-pedido) ELSE "" )
                   tt-ordem-compra.sequencia       = i-count-records
                   tt-ordem-compra.r-rowid         = ROWID(ordem-compra). 

                   RUN retornaDescricaoItem (OUTPUT c-descricao).
                   ASSIGN tt-ordem-compra.desc-item = c-descricao.

            /* Conta os registros criados */
            ASSIGN i-count-records  = i-count-records + 1.

        END.

        /* Verifica se o nr de registros criados na temp-table Ç maior ou igual ao 
           nr m†ximo que deve ser retornado  */
        IF  i-count-records >= p-max-return THEN DO:

            /* Abre a query de acordo com a navegaá∆o no browser */
            IF p-navigation = "prev" THEN 
                RUN OpenQueryStatic ("BySeqDecrescente":U).
            ELSE
                RUN OpenQueryStatic ("BySeq":U).

            /* Posiciona no primeiro registro da temp-table */
            GET FIRST {&queryName}.
            IF  AVAIL tt-ordem-compra THEN DO:
                 /* Quando o rowid do primeiro da base for desconhecido armazena
                    o primeiro da temp-table como sendo o primeiro da base. */
                IF  p-first-base = ? THEN
                    ASSIGN p-first-base = tt-ordem-compra.r-rowid.

                /* Se o primeiro registro do browse for igual ao primeiro da base 
                   zera a vari†vel para n∆o mostrar bot∆o de anterior em tela */
                IF  tt-ordem-compra.r-rowid = p-first-base THEN
                    ASSIGN p-first-displayed = ?.
                ELSE
                    ASSIGN p-first-displayed = tt-ordem-compra.r-rowid.

            END.

            /* Posiciona no £ltimo registro da temp-table */
            GET LAST {&queryName}.
            IF  AVAIL tt-ordem-compra THEN DO:

                /* Se o rowid do £ltimo registro for desconhecido, ent∆o 
                   busca o £ltimo registro da base para armazenar o rowid */
                IF  p-last-base = ? THEN DO:
                    FIND LAST  bfordem-compra USE-INDEX comprador
                         WHERE bfordem-compra.cod-comprado = p-cod-comprado 
                           AND bfordem-compra.data-emissao >= da-emissao-ini 
                           AND bfordem-compra.data-emissao <= da-emissao-fim 
                           AND bfordem-compra.cod-estabel  >= c-estab-ini 
                           AND bfordem-compra.cod-estabel  <= c-estab-fim 
                           AND (   (bfordem-compra.situacao = 1 AND lg_nao_confirmada) 
                                OR (bfordem-compra.situacao = 2 AND lg_confirmada) 
                                OR (bfordem-compra.situacao = 3 AND lg_cotada) 
                                OR (bfordem-compra.situacao = 4 AND lg_eliminada) 
                                OR (bfordem-compra.situacao = 5 AND lg_em_cotacao) 
                                OR (bfordem-compra.situacao = 6 AND lg_recebida)) 
                           AND (   (bfordem-compra.natureza = 1 AND lg_compra) 
                                OR (bfordem-compra.natureza = 2 AND lg_servico) 
                                OR (bfordem-compra.natureza = 3 AND lg_beneficiamento)) NO-LOCK NO-ERROR.

                    IF  AVAIL bfordem-compra THEN
                        ASSIGN p-last-base = ROWID(bfordem-compra).
                END.

                /* Se o £ltimo registro do browse for igual ao £ltimo da base 
                   zera a vari†vel para n∆o mostrar bot∆o de pr¢ximo em tela */
                IF  tt-ordem-compra.r-rowid = p-last-base THEN
                    ASSIGN p-last-displayed = ?.
                ELSE
                    ASSIGN p-last-displayed = tt-ordem-compra.r-rowid.
            END.

            /* Sai do repeat */ 
            LEAVE.
        END.

        /* Posiciona no anterior/pr¢ximo registro, conforme o tipo da navegaá∆o do browse */
        IF  p-navigation = "Prev":U THEN
            FIND PREV  ordem-compra USE-INDEX comprador
                 WHERE ordem-compra.cod-comprado = p-cod-comprado 
                   AND ordem-compra.data-emissao >= da-emissao-ini 
                   AND ordem-compra.data-emissao <= da-emissao-fim 
                   AND ordem-compra.cod-estabel  >= c-estab-ini 
                   AND ordem-compra.cod-estabel  <= c-estab-fim 
                   AND (   (ordem-compra.situacao = 1 AND lg_nao_confirmada) 
                        OR (ordem-compra.situacao = 2 AND lg_confirmada) 
                        OR (ordem-compra.situacao = 3 AND lg_cotada) 
                        OR (ordem-compra.situacao = 4 AND lg_eliminada) 
                        OR (ordem-compra.situacao = 5 AND lg_em_cotacao) 
                        OR (ordem-compra.situacao = 6 AND lg_recebida)) 
                   AND (   (ordem-compra.natureza = 1 AND lg_compra) 
                        OR (ordem-compra.natureza = 2 AND lg_servico) 
                        OR (ordem-compra.natureza = 3 AND lg_beneficiamento)) NO-LOCK NO-ERROR.
        ELSE
            FIND NEXT  ordem-compra USE-INDEX comprador
                 WHERE ordem-compra.cod-comprado = p-cod-comprado 
                   AND ordem-compra.data-emissao >= da-emissao-ini 
                   AND ordem-compra.data-emissao <= da-emissao-fim 
                   AND ordem-compra.cod-estabel  >= c-estab-ini 
                   AND ordem-compra.cod-estabel  <= c-estab-fim 
                   AND (   (ordem-compra.situacao = 1 AND lg_nao_confirmada) 
                        OR (ordem-compra.situacao = 2 AND lg_confirmada) 
                        OR (ordem-compra.situacao = 3 AND lg_cotada) 
                        OR (ordem-compra.situacao = 4 AND lg_eliminada) 
                        OR (ordem-compra.situacao = 5 AND lg_em_cotacao) 
                        OR (ordem-compra.situacao = 6 AND lg_recebida)) 
                   AND (   (ordem-compra.natureza = 1 AND lg_compra) 
                        OR (ordem-compra.natureza = 2 AND lg_servico) 
                        OR (ordem-compra.natureza = 3 AND lg_beneficiamento)) NO-LOCK NO-ERROR.

        /* Se n∆o encontrar mais registros para a seleá∆o,
           ser† finalizado o bloco de repetiá∆o */
        IF  NOT AVAIL ordem-compra THEN DO:

            IF  p-navigation = "Next":U THEN DO:
               /* Abre a query qndo navegaá∆o -> pr¢xima p†gina do browser */
               RUN OpenQueryStatic ("BySeq":U).

                /* Quando a navegaá∆o for "next", zera a vari†vel que contÇm o rowid do £ltimo
                   registro mostrado no browse para que n∆o mostre o bot∆o de pr¢ximo na tela */
                ASSIGN p-last-displayed  = ?.

                /* Busca o £ltimo registro da query */
                GET LAST {&queryName}.
                IF  AVAIL tt-ordem-compra THEN
                    /* Armazena o rowid do £ltimo registro da temp-table como sendo
                       o £ltimo da base */ 
                    ASSIGN p-last-base = tt-ordem-compra.r-rowid.

                /* Quando mudar o registro da tabela pai zera a vari†vel que contÇm o primeiro 
                   registro do browse, para n∆o mostrar o bot∆o de anterior na tela*/    
                IF  l-change-father THEN
                    ASSIGN p-first-displayed = ?.
                ELSE DO:
                    /* Sen∆o, armazena o rowid do primeiro registro do browse, se este rowid
                       for desconhecido n∆o ir† mostrar o bot∆o anterior na navegaá∆o do browse */
                    GET FIRST {&queryName}.
                    IF  AVAIL tt-ordem-compra THEN DO:
                        FIND FIRST bfordem-compra USE-INDEX comprador
                             WHERE bfordem-compra.cod-comprado = p-cod-comprado 
                               AND bfordem-compra.data-emissao >= da-emissao-ini 
                               AND bfordem-compra.data-emissao <= da-emissao-fim 
                               AND bfordem-compra.cod-estabel  >= c-estab-ini 
                               AND bfordem-compra.cod-estabel  <= c-estab-fim 
                               AND (   (bfordem-compra.situacao = 1 AND lg_nao_confirmada) 
                                    OR (bfordem-compra.situacao = 2 AND lg_confirmada) 
                                    OR (bfordem-compra.situacao = 3 AND lg_cotada) 
                                    OR (bfordem-compra.situacao = 4 AND lg_eliminada) 
                                    OR (bfordem-compra.situacao = 5 AND lg_em_cotacao) 
                                    OR (bfordem-compra.situacao = 6 AND lg_recebida)) 
                               AND (   (bfordem-compra.natureza = 1 AND lg_compra) 
                                    OR (bfordem-compra.natureza = 2 AND lg_servico) 
                                    OR (bfordem-compra.natureza = 3 AND lg_beneficiamento)) NO-LOCK NO-ERROR.
                        /* Se o primeiro da base for igual ao primeiro da temp-table n∆o mostra o
                           bot∆o de anterior */
                        IF  ROWID(bfordem-compra) = tt-ordem-compra.r-rowid THEN
                            ASSIGN p-first-displayed = ?.
                        ELSE
                        /* Sen∆o carrega o primeiro rowid do browse */
                            ASSIGN p-first-displayed = tt-ordem-compra.r-rowid.
                    END.
                    ELSE
                        ASSIGN p-first-displayed = ?.
                END.
            END.
            ELSE 
            IF  p-navigation = "Prev":U THEN DO:

                /* Abre a query qndo navegaá∆o -> p†gina anterior do browser */
                RUN OpenQueryStatic ("BySeqDecrescente":U).

                /* Quando a navegaá∆o for "prev", zera a vari†vel que contÇm o rowid do primeiro
                   registro mostrado no browse para que n∆o mostre o bot∆o de anterior na tela */
                ASSIGN p-first-displayed = ?.

                /* Busca o primeiro registro da query */
                GET FIRST {&queryName}.
                IF  AVAIL tt-ordem-compra THEN
                    /* Armazena o rowid do £ltimo registro da temp-table como sendo
                       o £ltimo da base */                 
                    ASSIGN p-first-base = tt-ordem-compra.r-rowid.

                /* Quando mudar o registro da tabela pai zera a vari†vel que contÇm o £ltimo
                   registro do browse, para n∆o mostrar o bot∆o de pr¢ximo na tela*/    
                IF  l-change-father THEN
                    ASSIGN p-last-displayed = ?.
                ELSE DO:
                    /* Sen∆o, armazena o rowid do primeiro registro do browse */
                    GET LAST {&queryName}.
                    IF  AVAIL tt-ordem-compra THEN DO:
                        FIND LAST  bfordem-compra USE-INDEX comprador
                             WHERE bfordem-compra.cod-comprado = p-cod-comprado 
                               AND bfordem-compra.data-emissao >= da-emissao-ini 
                               AND bfordem-compra.data-emissao <= da-emissao-fim 
                               AND bfordem-compra.cod-estabel  >= c-estab-ini 
                               AND bfordem-compra.cod-estabel  <= c-estab-fim 
                               AND (   (bfordem-compra.situacao = 1 AND lg_nao_confirmada) 
                                    OR (bfordem-compra.situacao = 2 AND lg_confirmada) 
                                    OR (bfordem-compra.situacao = 3 AND lg_cotada) 
                                    OR (bfordem-compra.situacao = 4 AND lg_eliminada) 
                                    OR (bfordem-compra.situacao = 5 AND lg_em_cotacao) 
                                    OR (bfordem-compra.situacao = 6 AND lg_recebida)) 
                               AND (   (bfordem-compra.natureza = 1 AND lg_compra) 
                                    OR (bfordem-compra.natureza = 2 AND lg_servico) 
                                    OR (bfordem-compra.natureza = 3 AND lg_beneficiamento)) NO-LOCK NO-ERROR.
                        /* Se o £ltimo da base for igual ao £ltimo da temp-table n∆o mostra o
                           bot∆o de pr¢ximo */
                        IF  ROWID(bfordem-compra) = tt-ordem-compra.r-rowid THEN
                            ASSIGN p-last-displayed = ?.
                        ELSE
                        /* Sen∆o armazena o rowid do £ltimo mostrado no browse */
                            ASSIGN p-last-displayed = tt-ordem-compra.r-rowid.
                    END.
                    ELSE
                        ASSIGN p-last-displayed = ?.
                END.
            END.

            /* Sai do repeat */
            LEAVE.        
        END. /* IF NOT AVAIL ORDEM-COMPRA... */
    END. /*  REPEAT... */    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraPorComprador DBOProgram 
PROCEDURE carregaTTOrdemCompraPorComprador :
/*-------------------------- ----------------------------------------------------
  Purpose:     carregaTabelaTTOrdemCompra7
    Carrega temp-table tt-ordem-compra, abrindo a query de acordo com valores 
    parametrizados. Na criacao da tt-ordem-compra, a temp-table recebe valores 
    das tabelas prazo-compra e item.
    O programa que utiliza esse metodo, tem faixa/selecao de comprador e faz restricao por fornecedor.
  Parameters:  
    ipar1 : pc-comprador-ini : codigo do comprador inicial
    ipar2 : pc-comprador-fim : codigo do comprador final
    ipar3 : pi-cod-for-ini   : codigo do fornecedor inicial
    ipar4 : pi-cod-for-fim   : codigo do fornecedor final
    ipar5 : pda-emissao-ini  : data de emissao inicial 
    ipar6 : pda-emissao-fim  : data de emissao final
    ipar7 : piSituacao       : situacao da parcela
    ipar8 : pd-entrega-ini   : data de entrega inicial 
    ipar9 : pd-entrega-fim   : data de entrega final     
    ipar10: pc-estabel-ini   : codigo do estabelecimento inicial 
    ipar11: pc-estabel-fim   : codigo do estabelecimento final       
  Notes:       
------------------------------------------------------------------------------*/

def input param pc-comprador-ini as char no-undo.
def input param pc-comprador-fim as char no-undo.
def input param pi-cod-for-ini   as int  no-undo.
def input param pi-cod-for-fim   as int  no-undo.
def input param pda-emissao-ini  as date no-undo.
def input param pda-emissao-fim  as date no-undo.
def input param piSituacao       as int  no-undo.
def input param pd-entrega-ini   as date no-undo.
def input param pd-entrega-fim   as date no-undo.
def input param pc-estabel-ini   as char no-undo.
def input param pc-estabel-fim   as char no-undo.  
def input param pcDepIni         as char no-undo.
def input param pcDepFim         as char no-undo.

    DEF VAR c-row-ord AS CHAR NO-UNDO.
    ASSIGN i-cont2 = 0.

    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.

    ASSIGN r-first = ?.

    /* n∆o incrementa o n£mero de acessos porque t† usando o °ndice. 
       Esses testes serve para evitar incrementar os acessos qdo n∆o h† registros que se encaixem na faixa */
    IF CAN-FIND (FIRST ordem-compra where  
                 ordem-compra.cod-estabel >= pc-estabel-ini and
                 ordem-compra.cod-estabel <= pc-estabel-fim
                 use-index estabel) then do:
       /* n∆o incrementa o n£mero de acessos porque t† usando o °ndice */
       IF CAN-FIND (FIRST ordem-compra where  
                    ordem-compra.data-emissao >= pda-emissao-ini and
                    ordem-compra.data-emissao <= pda-emissao-fim
                    use-index data-emissao) then do:
          /* n∆o incrementa o n£mero de acessos porque t† usando o °ndice */
          IF CAN-FIND (FIRST ordem-compra where  
                       ordem-compra.cod-emitente >= pi-cod-for-ini   and
                       ordem-compra.cod-emitente <= pi-cod-for-fim
                       use-index emitente) then do:
                    FIND FIRST ordem-compra where  
                               ordem-compra.cod-comprado >= pc-comprador-ini and
                               ordem-compra.cod-comprado <= pc-comprador-fim and
                               ordem-compra.cod-emitente >= pi-cod-for-ini   and
                               ordem-compra.cod-emitente <= pi-cod-for-fim   and
                               ordem-compra.data-emissao >= pda-emissao-ini  and
                               ordem-compra.data-emissao <= pda-emissao-fim  and
                               ordem-compra.cod-estabel  >= pc-estabel-ini   and
                               ordem-compra.cod-estabel  <= pc-estabel-fim   AND
                               ordem-compra.dep-almoxar  >= pcDepIni         and
                               ordem-compra.dep-almoxar  <= pcDepFim NO-LOCK NO-ERROR.

                    IF AVAIL ordem-compra THEN assign l-existeOrdem = yes.
          END.
       END.
    END.

    IF l-existeOrdem THEN DO:
        ASSIGN r-aux-pri = ROWID(ordem-compra).
        IF r-ord-compra <> ? THEN DO:
            /* FIND prazo-compra WHERE ROWID(prazo-compra) = r-ord-compra NO-LOCK NO-ERROR.
            FIND ordem-compra where  
                 ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK NO-ERROR.*/
            /* Testa pois se a faixa foi alterada na tela o rowid que vem na navegaá∆o deve ser ignorado */
            FIND bfordem-compra WHERE ROWID(bfordem-compra) = r-ord-compra NO-LOCK NO-ERROR.
            IF AVAIL bfordem-compra AND bfordem-compra.cod-comprado >= pc-comprador-ini
                                    AND bfordem-compra.cod-comprado <= pc-comprador-fim THEN DO:
               FIND ordem-compra WHERE ROWID(ordem-compra) = r-ord-compra NO-LOCK NO-ERROR.
               ASSIGN r-first = r-ord-compra.
            END.
        END.

        DO WHILE i-cont2 <= (i-nrlinhas):
            IF piSituacao = 7 THEN DO:
                FOR each prazo-compra fields (numero-ordem situacao data-entrega) WHERE
                         prazo-compra.numero-ordem  = ordem-compra.numero-ordem and 
                         prazo-compra.data-entrega >= pd-entrega-ini           and
                         prazo-compra.data-entrega <= pd-entrega-fim      NO-LOCK :
    
                        ASSIGN i-cont2 = i-cont2 + 1.
                        CREATE rowsOrdem.
                        ASSIGN rowsOrdem.i-seq   = i-cont2
                               rowsOrdem.r-ordem = ROWID(ordem-compra)
                               rowsOrdem.r-prazo = ROWID(prazo-compra).
                        IF c-naveg = "ant" THEN ASSIGN rowsOrdem.i-seq = (9999999 - i-cont2). /* Para deixar a ordenaá∆o correta */
                END.
            END.
            ELSE DO:
                FOR each prazo-compra fields (numero-ordem situacao data-entrega) WHERE
                         prazo-compra.numero-ordem  = ordem-compra.numero-ordem and 
                         prazo-compra.situacao      = piSituacao                and 
                         prazo-compra.data-entrega >= pd-entrega-ini            and
                         prazo-compra.data-entrega <= pd-entrega-fim       NO-LOCK :
    
                        ASSIGN i-cont2 = i-cont2 + 1.
                        CREATE rowsOrdem.
                        ASSIGN rowsOrdem.i-seq   = i-cont2
                               rowsOrdem.r-ordem = ROWID(ordem-compra)
                               rowsOrdem.r-prazo = ROWID(prazo-compra).
                        IF c-naveg = "ant" THEN ASSIGN rowsOrdem.i-seq = (9999999 - i-cont2). /* Para deixar a ordenaá∆o correta */
                END.
            END.

            IF c-naveg = "ant" then do:
                IF ROWID(ordem-compra) <> r-aux-pri THEN DO:
                    ASSIGN r-first = ROWID(ordem-compra).
                    FIND PREV ordem-compra where  
                             ordem-compra.cod-comprado >= pc-comprador-ini and
                             ordem-compra.cod-comprado <= pc-comprador-fim and            
                             ordem-compra.cod-emitente >= pi-cod-for-ini   and
                             ordem-compra.cod-emitente <= pi-cod-for-fim   and
                             ordem-compra.data-emissao >= pda-emissao-ini  and
                             ordem-compra.data-emissao <= pda-emissao-fim  and
                             ordem-compra.cod-estabel  >= pc-estabel-ini   and
                             ordem-compra.cod-estabel  <= pc-estabel-fim   AND
                             ordem-compra.dep-almoxar  >= pcDepIni         and
                             ordem-compra.dep-almoxar  <= pcDepFim NO-LOCK NO-ERROR.
                END.
                ELSE DO:
                   ASSIGN r-first = ?.
                   FOR EACH rowsOrdem EXCLUSIVE-LOCK:
                       DELETE rowsOrdem.
                   END.
                   ASSIGN i-cont2 = 0.
                   ASSIGN c-naveg = "pro".
                   FIND ordem-compra WHERE ROWID(ordem-compra) = r-aux-pri NO-LOCK NO-ERROR.
                END.
            END.
            ELSE DO:
                FIND NEXT ordem-compra where  
                         ordem-compra.cod-comprado >= pc-comprador-ini and
                         ordem-compra.cod-comprado <= pc-comprador-fim and            
                         ordem-compra.cod-emitente >= pi-cod-for-ini   and
                         ordem-compra.cod-emitente <= pi-cod-for-fim   and
                         ordem-compra.data-emissao >= pda-emissao-ini  and
                         ordem-compra.data-emissao <= pda-emissao-fim  and
                         ordem-compra.cod-estabel  >= pc-estabel-ini   and
                         ordem-compra.cod-estabel  <= pc-estabel-fim   AND
                         ordem-compra.dep-almoxar  >= pcDepIni         and
                         ordem-compra.dep-almoxar  <= pcDepFim  NO-LOCK NO-ERROR.

                IF NOT AVAIL ordem-compra THEN ASSIGN i-cont2 = i-nrlinhas + 1.
            END.
        END.   
    END.

    FOR EACH rowsOrdem NO-LOCK BY rowsOrdem.i-seq :
        FIND FIRST ordem-compra WHERE rowid(ordem-compra) = rowsOrdem.r-ordem      NO-LOCK NO-ERROR.
        ASSIGN r-last = rowsOrdem.r-ordem.
        FIND FIRST item         WHERE item.it-codigo      = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        FOR EACH prazo-compra WHERE rowid(prazo-compra) = rowsOrdem.r-prazo NO-LOCK:
            run createTTOrdemCompra.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraPorDataEmissao DBOProgram 
PROCEDURE carregaTTOrdemCompraPorDataEmissao :
/*------------------------------------------------------------------------------
  Purpose:     carregaTabelaTTOrdemCompra2
    Carrega temp-table tt-ordem-compra, abrindo a query de acordo com valores 
    parametrizados.Na criacao da tt-ordem-compra, a temp-table recebe valores 
    das tabelas pedido-compr e cotacao-item.  
  Parameters:  
    ipar2 : pda-emissao-ini : data de emissío inicial
    ipar3 : pda-emissao-fim : data de emissío final
    ipar4 : c-nao-confir   : situacao do documento - N∆o Confirmado
    ipar5 : pc-confir       : situacao do documento - Confirmado
    ipar6 : pc-cotada       : situacao do documento - Cotado
    ipar7 : pc-elimin       : situacao do documento - Eliminado 
    ipar8 : pc-em-cotacao   : situacao do documento - Em Cotaªío
    ipar9 : pc-receb        : situacao do documento - Recebido 
    ipar10: pc-compra       : natureza do documento - Compra
    ipar11: pc-servico      : natureza do documento - Servico
    ipar12: pc-benefi       : natureza do documento - Beneficiamento
    ipar13: pi-apresentacao : nivel do documento - 1 = Ordem 2 = Cotacao 3 = Pedido 4 = Recebimento  
  Notes:       
------------------------------------------------------------------------------*/

def input param pda-emissao-ini     as date no-undo.
def input param pda-emissao-fim     as date no-undo. 
def input param pc-naocon           as char no-undo.
def input param pc-confir           as char no-undo.
def input param pc-cotada           as char no-undo.
def input param pc-elimin           as char no-undo.
def input param pc-em-cotacao       as char no-undo.
def input param pc-receb            as char no-undo.
def input param pc-compra           as char no-undo.
def input param pc-servico          as char no-undo.
def input param pc-benefi           as char no-undo.
def input param pi-apresentacao     as int  no-undo. 
def input param pc-solicit          as char no-undo. 
def input param pc-ord-com          as char no-undo.
def input param pc-cotac            as char no-undo.       
def input param pc-pedido           as char no-undo.  
def input param pc-it-ini           as char no-undo.
def input param pc-it-fim           as char no-undo.
def input param pi-req-ini          as int  no-undo.
def input param pi-req-fim          as int  no-undo.
def input param pc-cod-comprado-ini as char no-undo.
def input param pc-cod-comprado-fim as char no-undo.
def input param pc-sc-codigo-ini    as char no-undo.
def input param pc-sc-codigo-fim    as char no-undo.
def input param pc-fm-ini           as char no-undo. 
def input param pc-fm-fim           as char no-undo.
DEF INPUT PARAM p-max-return        AS INT   NO-UNDO.
DEF INPUT PARAM p-navigation        AS CHAR  NO-UNDO.
DEF INPUT PARAM p-programa          AS CHAR  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-first-displayed  AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-last-displayed   AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-first-base       AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-last-base        AS ROWID NO-UNDO.

DEF VAR i-count-records      AS INT  NO-UNDO.
def var l-ok                 as log  no-undo.
def var lg_nao_confirmada    as log  no-undo.
def var lg_confirmada        as log  no-undo.
def var lg_cotada            as log  no-undo. 
def var lg_eliminada         as log  no-undo.
def var lg_em_cotacao        as log  no-undo.
def var lg_recebida          as log  no-undo.
def var lg_compra            as log  no-undo. 
def var lg_servico           as log  no-undo.
def var lg_beneficiamento    as log  no-undo.
def var c-natureza           as char no-undo.
def var c-lista-natureza     as char no-undo.
def var c-lista-situacao     as char no-undo.
def var c-lista-pedido       as char no-undo.
def var de-total             as dec  no-undo.    
def var lg_solicitacao       as log  no-undo.
def var lg_ordem             as log  no-undo.
def var lg_cotacao           as log  no-undo.
def var lg_pedido            as log  no-undo.
def var c-indice             as char no-undo.



    assign    
        lg_nao_confirmada   = if pc-naocon     = "yes" then YES else NO
        lg_confirmada       = if pc-confir     = "yes" then YES else NO
        lg_cotada           = if pc-cotada     = "yes" then YES else NO 
        lg_eliminada        = if pc-elimin     = "yes" then YES else NO
        lg_em_cotacao       = if pc-em-cotacao = "yes" then YES else NO
        lg_recebida         = if pc-receb      = "yes" then YES else NO
        lg_compra           = if pc-compra     = "yes" then YES else NO
        lg_servico          = if pc-servico    = "yes" then YES else NO
        lg_beneficiamento   = if pc-benefi     = "yes" then YES else NO 
        lg_solicitacao      = if pc-solicit    = "yes" then YES else NO 
        lg_ordem            = if pc-ord-com    = "yes" then YES else NO 
        lg_cotacao          = if pc-cotac      = "yes" then YES else NO 
        lg_pedido           = if pc-pedido     = "yes" then YES else NO        
        c-lista-situacao    = {ininc/i02in274.i 03} 
        c-lista-natureza    = {ininc/i01in274.i 03}
        c-lista-pedido      = {ininc/i02in295.i 03}.

    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-ordem-compra.
    &ELSE                                                  
        FOR EACH tt-ordem-compra:
            DELETE tt-ordem-compra.
        END.
    &ENDIF

     /* Quando o primeiro e o £ltimo registro do browse forem desconhecidos, comeáa
       a pesquisa pelo primeiro registro que se encaixar na seleá∆o */
    IF  p-last-displayed = ? 
    AND p-first-displayed = ? THEN DO:
        ASSIGN p-navigation = "Next":U.

        /*****************************************************************
        ** o codigo abaixo foi implementado com o intuito de otimizar a **
        ** leitura dos registros conforme as selecoes utilizadas pelo   **
        ** usuario                                                      **
        *****************************************************************/
        if pda-emissao-fim - pda-emissao-ini <= 90 then 
            FIND first ordem-compra USE-INDEX data-emissao   
            {inbo/boin274q02.i1 "ordem-compra"} 
        else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
            FIND first ordem-compra USE-INDEX comprador
            {inbo/boin274q02.i1 "ordem-compra" }
        else if pi-req-ini <> 0 then 
            FIND first ordem-compra USE-INDEX requis
            {inbo/boin274q02.i1 "ordem-compra" }
        else if pc-it-ini <> "" then 
            FIND first ordem-compra USE-INDEX item
            {inbo/boin274q02.i1 "ordem-compra" }
        else 
            FIND first ordem-compra USE-INDEX ordem
            {inbo/boin274q02.i1 "ordem-compra" }


    END.
    ELSE DO:
        /* Sen∆o comeáa a pesquisa a partir do registro que contenha o rowid
           recebido como parÉmetro */
        IF  p-navigation = "Prev":U THEN DO:
            IF p-programa = "WProg.w" THEN
                FIND ordem-compra WHERE 
                    ROWID(ordem-compra) = p-first-displayed NO-LOCK NO-ERROR.

             ELSE DO:
             FIND ordem-compra WHERE 
                ROWID(ordem-compra) = p-first-displayed NO-LOCK NO-ERROR.
                /* Quando a navegaá∆o for "Prev" posiciona no registro anterior ao
                   primeiro mostrado no browse */ 
                IF  AVAIL ordem-compra THEN

                    /*****************************************************************
                    ** o codigo abaixo foi implementado com o intuito de otimizar a **
                    ** leitura dos registros conforme as selecoes utilizadas pelo   **
                    ** usuario                                                      **
                    *****************************************************************/
                    if pda-emissao-fim - pda-emissao-ini <= 90 then 
                        FIND prev ordem-compra USE-INDEX data-emissao   
                        {inbo/boin274q02.i1 "ordem-compra" } 
                    else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                        FIND prev ordem-compra
                        {inbo/boin274q02.i1 "ordem-compra" }
                    else if pi-req-ini <> 0 then 
                        FIND prev ordem-compra USE-INDEX requis
                        {inbo/boin274q02.i1 "ordem-compra" }
                    else if pc-it-ini <> "" then 
                        FIND prev ordem-compra USE-INDEX item
                        {inbo/boin274q02.i1 "ordem-compra" }
                    else 
                        FIND prev ordem-compra USE-INDEX ordem
                        {inbo/boin274q02.i1 "ordem-compra" }

             END.
        END.
        ELSE IF p-navigation = "Next":U THEN DO:

            IF p-programa = "WProg.W" THEN

                FIND ordem-compra WHERE
                    ROWID(ordem-compra) = p-last-displayed NO-LOCK NO-ERROR.
            ELSE DO:

                FIND ordem-compra WHERE 
                    ROWID(ordem-compra) = p-last-displayed NO-LOCK NO-ERROR.
                /* Quando a navegaá∆o for "Next" posiciona no pr¢ximo registro baseado
                   no £ltimo mostrado no browse */
                IF  AVAIL ordem-compra THEN  
                    /*****************************************************************
                    ** o codigo abaixo foi implementado com o intuito de otimizar a **
                    ** leitura dos registros conforme as selecoes utilizadas pelo   **
                    ** usuario                                                      **
                    *****************************************************************/
                    if pda-emissao-fim - pda-emissao-ini <= 90 then 
                        FIND next ordem-compra USE-INDEX data-emissao   
                        {inbo/boin274q02.i1 "ordem-compra" } 
                    else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                        FIND next ordem-compra
                        {inbo/boin274q02.i1 "ordem-compra" }
                    else if pi-req-ini <> 0 then 
                        FIND next ordem-compra USE-INDEX requis
                        {inbo/boin274q02.i1 "ordem-compra" }
                    else if pc-it-ini <> "" then 
                        FIND next ordem-compra USE-INDEX item
                        {inbo/boin274q02.i1 "ordem-compra" }
                    else 
                        FIND next ordem-compra USE-INDEX ordem
                        {inbo/boin274q02.i1 "ordem-compra" }

            END.
        END.
    END.

    /* A procedure a seguir foi criada para contornar o problema de estouro do tamanho maximo de 63Kb da procedure original,
       acusado quando da compilaá∆o do programa no EMS 2.05 */
    RUN carregaTTOrdemCompraPorDataEmissao-aux ( INPUT pda-emissao-ini,     INPUT pda-emissao-fim,      INPUT pi-req-ini, 
                                                 INPUT pi-req-fim,          INPUT pi-apresentacao,      INPUT pc-cod-comprado-ini,  
                                                 INPUT pc-cod-comprado-fim, INPUT pc-fm-ini,            INPUT pc-fm-fim,            
                                                 INPUT pc-it-ini,           INPUT pc-it-fim,            INPUT pc-sc-codigo-ini,
                                                 INPUT pc-sc-codigo-fim,    INPUT p-navigation,         INPUT-OUTPUT p-first-displayed,
                                                 INPUT-OUTPUT p-last-displayed, INPUT-OUTPUT p-last-base, INPUT-OUTPUT p-first-base,
                                                 INPUT  lg_solicitacao,     INPUT lg_ordem,             INPUT lg_cotacao,
                                                 INPUT lg_pedido,           INPUT lg_confirmada,        INPUT lg_nao_confirmada,
                                                 INPUT lg_cotada,           INPUT lg_eliminada,         INPUT lg_em_cotacao,
                                                 INPUT lg_recebida,         INPUT lg_compra,            INPUT lg_servico,
                                                 INPUT lg_beneficiamento,   INPUT c-lista-pedido,       INPUT p-max-return).
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraPorDataEmissao-aux DBOProgram 
PROCEDURE carregaTTOrdemCompraPorDataEmissao-aux :
/*------------------------------------------------------------------------------
  Purpose: Esta procedure foi criada para contornar o problema de estouro do tamanho maximo de 63Kb da procedure original,
           acusado quando da compilaá∆o do programa no EMS 2.05 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pda-emissao-ini     as date no-undo.
def input param pda-emissao-fim     as date no-undo.
def input param pi-req-ini          as int  no-undo.
def input param pi-req-fim          as int  no-undo.
def input param pi-apresentacao     as int  no-undo. 
def input param pc-cod-comprado-ini as char no-undo.
def input param pc-cod-comprado-fim as char no-undo.
def input param pc-fm-ini           as char no-undo. 
def input param pc-fm-fim           as char no-undo.
def input param pc-it-ini           as char no-undo.
def input param pc-it-fim           as char no-undo.
def input param pc-sc-codigo-ini    as char no-undo.
def input param pc-sc-codigo-fim    as char no-undo.
DEF INPUT PARAM p-navigation        AS CHAR  NO-UNDO.
DEF INPUT-OUTPUT PARAM p-first-displayed  AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-last-displayed   AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-last-base        AS ROWID NO-UNDO.
DEF INPUT-OUTPUT PARAM p-first-base       AS ROWID NO-UNDO.

def INPUT PARAM lg_solicitacao       as log  no-undo.
def INPUT PARAM lg_ordem             as log  no-undo.
def INPUT PARAM lg_cotacao           as log  no-undo.
def INPUT PARAM lg_pedido            as log  no-undo.
def INPUT PARAM lg_confirmada        as log  no-undo.
def INPUT PARAM lg_nao_confirmada    as log  no-undo.
def INPUT PARAM lg_cotada            as log  no-undo. 
def INPUT PARAM lg_eliminada         as log  no-undo.
def INPUT PARAM lg_em_cotacao        as log  no-undo.
def INPUT PARAM lg_recebida          as log  no-undo.
def INPUT PARAM lg_compra            as log  no-undo.
def INPUT PARAM lg_servico           as log  no-undo.
def INPUT PARAM lg_beneficiamento    as log  no-undo.
def INPUT PARAM c-lista-pedido       as char no-undo.
DEF INPUT PARAM p-max-return        AS INT   NO-UNDO.

def var l-ok                 as log  no-undo.
DEF VAR i-count-records      AS INT  NO-UNDO.


/* Se existir pelo menos um registro dispon°vel, entra no bloco de repetiá∆o que
       efetivamente criar† a temp-table que ser† retornada para ser mostrada no browse */
    
    REPEAT while avail ordem-compra:

        IF  (NOT lg_solicitacao 
             AND INT(ordem-compra.situacao) = 1 
             AND ordem-compra.nr-requisicao > 0)                 or 
            (NOT lg_ordem  
             AND INT(ordem-compra.situacao) = 2 
             AND ordem-compra.num-pedido = 0 
             AND ordem-compra.nr-requisicao = 0)    or
            (NOT lg_ordem 
             AND INT(ordem-compra.situacao) = 1 
             AND ordem-compra.nr-requisicao = 0)                 or
            (NOT lg_pedido 
             AND INT(ordem-compra.situacao) = 2 
             AND ordem-compra.num-pedido > 0)       or
            (NOT lg_cotacao 
             AND (INT(ordem-compra.situacao) = 3 OR 
             INT(ordem-compra.situacao) = 5))       or
            not can-find(FIRST ITEM WHERE 
                               ITEM.it-codigo  = ordem-compra.it-codigo and
                               ITEM.fm-codigo >= pc-fm-ini              and
                               ITEM.fm-codigo <= pc-fm-fim) then do:


            IF  p-navigation = "Prev":U THEN 

                /*****************************************************************
                ** o codigo abaixo foi implementado com o intuito de otimizar a **
                ** leitura dos registros conforme as selecoes utilizadas pelo   **
                ** usuario                                                      **
                *****************************************************************/
                if pda-emissao-fim - pda-emissao-ini <= 90 then 
                    FIND prev ordem-compra USE-INDEX data-emissao   
                    {inbo/boin274q02.i1 "ordem-compra" } 
                else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                    FIND prev ordem-compra
                    {inbo/boin274q02.i1 "ordem-compra" }
                else if pi-req-ini <> 0 then 
                    FIND prev ordem-compra USE-INDEX requis
                    {inbo/boin274q02.i1 "ordem-compra" }
                else if pc-it-ini <> "" then 
                    FIND prev ordem-compra USE-INDEX item
                    {inbo/boin274q02.i1 "ordem-compra" }
                else 
                    FIND prev ordem-compra USE-INDEX ordem
                    {inbo/boin274q02.i1 "ordem-compra" }

            ELSE
                /*****************************************************************
                ** o codigo abaixo foi implementado com o intuito de otimizar a **
                ** leitura dos registros conforme as selecoes utilizadas pelo   **
                ** usuario                                                      **
                *****************************************************************/
                if pda-emissao-fim - pda-emissao-ini <= 90 then 
                    FIND next ordem-compra USE-INDEX data-emissao   
                    {inbo/boin274q02.i1 "ordem-compra" } 
                else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                    FIND next ordem-compra
                    {inbo/boin274q02.i1 "ordem-compra" }
                else if pi-req-ini <> 0 then 
                    FIND next ordem-compra USE-INDEX requis
                    {inbo/boin274q02.i1 "ordem-compra" }
                else if pc-it-ini <> "" then 
                    FIND next ordem-compra USE-INDEX item
                    {inbo/boin274q02.i1 "ordem-compra" }
                else 
                    FIND next ordem-compra USE-INDEX ordem
                    {inbo/boin274q02.i1 "ordem-compra" }

                    if not avail ordem-compra then do:
                        find last tt-ordem-compra no-error.
                        if avail tt-ordem-compra then 
                           assign p-last-displayed = ?
                                  p-last-base = tt-ordem-compra.r-rowid.
                        leave.
                    end.
            NEXT .
        end.

        
        ASSIGN l-ok = NO.         

        FOR EACH  prazo-compra FIELDS()
            WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:

            IF  pi-apresentacao = 1 THEN 
                ASSIGN l-ok = YES.

            FOR FIRST cotacao-item FIELDS(cod-emitente)
                WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                  AND cotacao-item.cot-aprovada NO-LOCK: END.

            IF  AVAILABLE cotacao-item 
            AND pi-apresentacao = 2 THEN 
                ASSIGN l-ok = YES.

            FOR FIRST pedido-compr FIELDS(num-pedido situacao)
                WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK: END.

            IF  AVAILABLE pedido-compr THEN DO:

                IF  pi-apresentacao = 3 THEN  
                    ASSIGN l-ok = YES.

                FOR FIRST recebimento FIELDS()
                    WHERE recebimento.num-pedido   = pedido-compr.num-pedido 
                      AND recebimento.numero-ordem = ordem-compra.numero-ordem 
                      AND recebimento.quant-receb  > 0 NO-LOCK: END.

                IF  AVAIL recebimento 
                AND pi-apresentacao = 4 THEN 
                    ASSIGN l-ok = YES.
            END.        
        END.

        IF  l-ok THEN DO:

            CREATE tt-ordem-compra.
            ASSIGN tt-ordem-compra.numero-ordem    = ordem-compra.numero-ordem
                   tt-ordem-compra.cod-comprado    = ordem-compra.cod-comprado
                   tt-ordem-compra.it-codigo       = ordem-compra.it-codigo
                   tt-ordem-compra.situacao        = ENTRY(ordem-compra.situacao, c-lista-situacao)
                   tt-ordem-compra.natureza        = ENTRY(ordem-compra.natureza, c-lista-natureza)
                   tt-ordem-compra.data-emissao    = ordem-compra.data-emissao
                   tt-ordem-compra.cod-emitente    = ( IF AVAILABLE cotacao-item THEN
                                                      cotacao-item.cod-emitente ELSE 0 )
                   tt-ordem-compra.num-pedido      = ( IF AVAILABLE pedido-compr THEN
                                                      pedido-compr.num-pedido ELSE 0 )
                   tt-ordem-compra.sequencia       =  i-count-records
                   tt-ordem-compra.situacao-pedido = ( IF AVAILABLE pedido-compr THEN
                                                       ENTRY(pedido-compr.situacao,c-lista-pedido) ELSE "":U )
                   tt-ordem-compra.r-rowid         = ROWID(ordem-compra). 


            CASE ordem-compra.situacao:
                WHEN 1 THEN
                    ASSIGN tt-ordem-compra.documento = IF ordem-compra.nr-requisicao > 0
                                                       THEN "Solicitacao"
                                                       ELSE "Ordem Compra".
                WHEN 2 THEN
                    ASSIGN tt-ordem-compra.documento = IF ordem-compra.num-pedido > 0
                                                       THEN "Pedido"
                                                       ELSE IF ordem-compra.nr-requisicao = 0
                                                            THEN "Ordem Compra"
                                                            ELSE "Confirmada".
                WHEN 3 THEN
                    ASSIGN tt-ordem-compra.documento = "Cotada".
                WHEN 4 THEN
                    ASSIGN tt-ordem-compra.documento = "Eliminada".
                WHEN 5 THEN
                    ASSIGN tt-ordem-compra.documento = "Em cotaá∆o".
                WHEN 6 THEN
                    ASSIGN tt-ordem-compra.documento = "Recebida".
                OTHERWISE
                    ASSIGN tt-ordem-compra.documento = "Indefinido".
            END CASE.
            /* Conta o nr. de registros criados na temp-table */
            ASSIGN i-count-records = i-count-records + 1.
        END.

        /* Verifica se o nr de registros criados na temp-table Ç maior ou igual ao 
           nr m†ximo que deve ser retornado  */
        IF  i-count-records >= p-max-return THEN DO:

            IF p-navigation = "prev" THEN 
                RUN OpenQueryStatic ("BySeqDecrescente":U).
            ELSE
                RUN OpenQueryStatic ("BySeq":U).

            /* Posiciona no primeiro registro da temp-table */
            GET FIRST {&queryName}.
            IF  AVAIL tt-ordem-compra THEN DO:
                 /* Quando o rowid do primeiro da base for desconhecido armazena
                    o primeiro da temp-table como sendo o primeiro da base. */
                IF  p-first-base = ? THEN
                    ASSIGN p-first-base = tt-ordem-compra.r-rowid.

                /* Se o primeiro registro do browse for igual ao primeiro da base 
                   zera a vari†vel para n∆o mostrar bot∆o de anterior em tela */
                IF  tt-ordem-compra.r-rowid = p-first-base THEN
                    ASSIGN p-first-displayed = ?.
                ELSE
                    ASSIGN p-first-displayed = tt-ordem-compra.r-rowid.
            END.

            /* Posiciona no £ltimo registro da temp-table */
            GET LAST {&queryName}.
            IF  AVAIL tt-ordem-compra THEN DO:

                /* Se o rowid do £ltimo registro for desconhecido, ent∆o 
                   busca o £ltimo registro da base para armazenar o rowid */
                IF  p-last-base = ? THEN DO:
                    /*****************************************************************
                    ** o codigo abaixo foi implementado com o intuito de otimizar a **
                    ** leitura dos registros conforme as selecoes utilizadas pelo   **
                    ** usuario                                                      **
                    *****************************************************************/
                    if pda-emissao-fim - pda-emissao-ini <= 90 then 
                        FIND last bfordem-compra USE-INDEX data-emissao   
                        {inbo/boin274q02.i1 "bfordem-compra" } 
                    else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                        FIND last bfordem-compra USE-INDEX comprador
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else if pi-req-ini <> 0 then 
                        FIND last bfordem-compra USE-INDEX requis
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else if pc-it-ini <> "" then 
                        FIND last bfordem-compra USE-INDEX item
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else 
                        FIND last bfordem-compra USE-INDEX ordem
                        {inbo/boin274q02.i1 "bfordem-compra" }

                    IF  AVAIL bfordem-compra THEN
                        ASSIGN p-last-base = ROWID(bfordem-compra).
                END.

                /* Se o £ltimo registro do browse for igual ao £ltimo da base 
                   zera a vari†vel para n∆o mostrar bot∆o de pr¢ximo em tela */
                IF  tt-ordem-compra.r-rowid = p-last-base THEN
                    ASSIGN p-last-displayed = ?.
                ELSE
                    ASSIGN p-last-displayed = tt-ordem-compra.r-rowid.
            END. /* if avail tt-ordem-compra...*/

            /* Sai do repeat */ 
            LEAVE.
        END.

        /* Posiciona no anterior/pr¢ximo registro, conforme o tipo da navegaá∆o do browse */
        IF  p-navigation = "Prev":U THEN 

            /*****************************************************************
            ** o codigo abaixo foi implementado com o intuito de otimizar a **
            ** leitura dos registros conforme as selecoes utilizadas pelo   **
            ** usuario                                                      **
            *****************************************************************/
            if pda-emissao-fim - pda-emissao-ini <= 90 then 
                FIND prev ordem-compra USE-INDEX data-emissao   
                {inbo/boin274q02.i1 "ordem-compra" } 
            else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                FIND prev ordem-compra USE-INDEX comprador
                {inbo/boin274q02.i1 "ordem-compra" }
            else if pi-req-ini <> 0 then 
                FIND prev ordem-compra USE-INDEX requis
                {inbo/boin274q02.i1 "ordem-compra" }
            else if pc-it-ini <> "" then 
                FIND prev ordem-compra USE-INDEX item
                {inbo/boin274q02.i1 "ordem-compra" }
            else 
                FIND prev ordem-compra USE-INDEX ordem
                {inbo/boin274q02.i1 "ordem-compra" }

        ELSE
            /*****************************************************************
            ** o codigo abaixo foi implementado com o intuito de otimizar a **
            ** leitura dos registros conforme as selecoes utilizadas pelo   **
            ** usuario                                                      **
            *****************************************************************/
            if pda-emissao-fim - pda-emissao-ini <= 90 then 
                FIND next ordem-compra USE-INDEX data-emissao   
                {inbo/boin274q02.i1 "ordem-compra" } 
            else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                FIND next ordem-compra USE-INDEX comprador
                {inbo/boin274q02.i1 "ordem-compra" }
            else if pi-req-ini <> 0 then 
                FIND next ordem-compra USE-INDEX requis
                {inbo/boin274q02.i1 "ordem-compra" }
            else if pc-it-ini <> "" then 
                FIND next ordem-compra USE-INDEX item
                {inbo/boin274q02.i1 "ordem-compra" }
            else 
                FIND next ordem-compra USE-INDEX ordem
                {inbo/boin274q02.i1 "ordem-compra" }


        /* Se n∆o encontrar mais registros para a seleá∆o,
           ser† finalizado o bloco de repetiá∆o */
        IF  NOT AVAIL ordem-compra THEN DO:

            IF  p-navigation = "Next":U THEN DO:

                RUN OpenQueryStatic ("BySeq":U).

                /* Quando a navegaá∆o for "next", zera a vari†vel que contÇm o rowid do £ltimo
                   registro mostrado no browse para que n∆o mostre o bot∆o de pr¢ximo na tela */
                ASSIGN p-last-displayed  = ?.

                /* Busca o £ltimo registro da query */
                GET LAST {&queryName}.
                IF  AVAIL tt-ordem-compra THEN
                    /* Armazena o rowid do £ltimo registro da temp-table como sendo
                       o £ltimo da base */ 
                    ASSIGN p-last-base = tt-ordem-compra.r-rowid.

                /* Armazena o rowid do primeiro registro do browse, se este rowid
                   for desconhecido n∆o ir† mostrar o bot∆o anterior na navegaá∆o do browse */
                GET FIRST {&queryName}.
                IF  AVAIL tt-ordem-compra THEN DO:
                    /*****************************************************************
                    ** o codigo abaixo foi implementado com o intuito de otimizar a **
                    ** leitura dos registros conforme as selecoes utilizadas pelo   **
                    ** usuario                                                      **
                    *****************************************************************/
                    if pda-emissao-fim - pda-emissao-ini <= 90 then 
                        FIND first bfordem-compra USE-INDEX data-emissao   
                        {inbo/boin274q02.i1 "bfordem-compra" } 
                    else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                        FIND first bfordem-compra USE-INDEX comprador
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else if pi-req-ini <> 0 then 
                        FIND first bfordem-compra USE-INDEX requis
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else if pc-it-ini <> "" then 
                        FIND first bfordem-compra USE-INDEX item
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else 
                        FIND first bfordem-compra USE-INDEX ordem
                        {inbo/boin274q02.i1 "bfordem-compra" }

                    /* Se o primeiro da base for igual ao primeiro da temp-table n∆o mostra o
                       bot∆o de anterior */
                    IF  ROWID(bfordem-compra) = tt-ordem-compra.r-rowid THEN
                        ASSIGN p-first-displayed = ?.
                    ELSE
                    /* Sen∆o carrega o primeiro rowid do browse */
                        ASSIGN p-first-displayed = tt-ordem-compra.r-rowid.
                END.
            END.
            ELSE 
            IF  p-navigation = "Prev":U THEN DO:

                RUN OpenQueryStatic ("BySeqDecrescente":U).

                /* Quando a navegaá∆o for "prev", zera a vari†vel que contÇm o rowid do primeiro
                   registro mostrado no browse para que n∆o mostre o bot∆o de anterior na tela */
                ASSIGN p-first-displayed = ?.

                /* Busca o primeiro registro da query */
                GET FIRST {&queryName}.
                IF  AVAIL tt-ordem-compra THEN
                    /* Armazena o rowid do £ltimo registro da temp-table como sendo
                       o £ltimo da base */                 
                    ASSIGN p-first-base = tt-ordem-compra.r-rowid.

                /* Armazena o rowid do primeiro registro do browse */
                GET LAST {&queryName}.
                IF  AVAIL tt-ordem-compra THEN DO:
                    /*****************************************************************
                    ** o codigo abaixo foi implementado com o intuito de otimizar a **
                    ** leitura dos registros conforme as selecoes utilizadas pelo   **
                    ** usuario                                                      **
                    *****************************************************************/
                    if pda-emissao-fim - pda-emissao-ini <= 90 then 
                        FIND last bfordem-compra USE-INDEX data-emissao   
                        {inbo/boin274q02.i1 "bfordem-compra" } 
                    else if pc-cod-comprado-ini = pc-cod-comprado-fim then 
                        FIND last bfordem-compra USE-INDEX comprador
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else if pi-req-ini <> 0 then 
                        FIND last bfordem-compra USE-INDEX requis
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else if pc-it-ini <> "" then 
                        FIND last bfordem-compra USE-INDEX item
                        {inbo/boin274q02.i1 "bfordem-compra" }
                    else 
                        FIND last bfordem-compra USE-INDEX ordem
                        {inbo/boin274q02.i1 "bfordem-compra" }

                    /* Se o £ltimo da base for igual ao £ltimo da temp-table n∆o mostra o
                       bot∆o de pr¢ximo */
                    IF  ROWID(bfordem-compra) = tt-ordem-compra.r-rowid THEN
                        ASSIGN p-last-displayed = ?.
                    ELSE
                    /* Sen∆o armazena o rowid do £ltimo mostrado no browse */
                        ASSIGN p-last-displayed = tt-ordem-compra.r-rowid.
                END.
            END.
            

            /* Sai do repeat */
            LEAVE.        
        END. /* IF NOT AVAIL ORDEM-COMPRA... */
    END. /* REPEAT... */
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraPorFornecedor DBOProgram 
PROCEDURE carregaTTOrdemCompraPorFornecedor :
/*------------------------------------------------------------------------------
  Purpose:     carregaTabelaTTOrdemCompra5
    Carrega temp-table tt-ordem-compra, abrindo a query de acordo com valores 
    parametrizados. Na criacao da tt-ordem-compra, a temp-table recebe valores 
    das tabelas prazo-compra e item.
    O programa que utiliza esse metodo, tem faixa/selecao de fornecedor e faz restricao por fornecedor.
  Parameters:
    ipar1 : pi-cod-for-ini   : codigo do fornecedor inicial
    ipar2 : pi-cod-for-fim   : codigo do fornecedor final
    ipar3 : pda-emissao-ini  : data de emissao inicial 
    ipar4 : pda-emissao-fim  : data de emissao final
    ipar5 : piSituacao       : situacao da parcela 
    ipar6 : pd-entrega-ini   : data de entrega inicial 
    ipar7 : pd-entrega-fim   : data de entrega final     
    ipar8 : pc-estabel-ini   : codigo do estabelecimento inicial 
    ipar9 : pc-estabel-fim   : codigo do estabelecimento final       
    ipar10 : pc-dep-ini      : codigo do deposito inicial 
    ipar11 : pc-dep-fim      : codigo do deposito final       
  Notes:       
------------------------------------------------------------------------------*/
def input param pi-cod-for-ini   as int  no-undo.
def input param pi-cod-for-fim   as int  no-undo.
def input param pda-emissao-ini  as date no-undo.
def input param pda-emissao-fim  as date no-undo.
def input param piSituacao       as int  no-undo.
def input param pd-entrega-ini   as date no-undo.
def input param pd-entrega-fim   as date no-undo.
def input param pc-estabel-ini   as char no-undo.
def input param pc-estabel-fim   as char no-undo. 
def input param pcDepIni         as char no-undo.
def input param pcDepFim         as char no-undo.

DEF VAR c-row-ord AS CHAR NO-UNDO.
ASSIGN i-cont2 = 0.
assign l-existeOrdem = no.

    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.

    ASSIGN r-first = ?.

    /* n∆o incrementa o n£mero de acessos porque t† usando o °ndice. 
       Esses testes serve para evitar incrementar os acessos qdo n∆o h† registros que se encaixem na faixa */
    IF CAN-FIND (FIRST ordem-compra where  
                 ordem-compra.cod-estabel >= pc-estabel-ini and
                 ordem-compra.cod-estabel <= pc-estabel-fim
                 use-index estabel) then do:
       /* n∆o incrementa o n£mero de acessos porque t† usando o °ndice */
       IF CAN-FIND (FIRST ordem-compra where  
                    ordem-compra.data-emissao >= pda-emissao-ini and
                    ordem-compra.data-emissao <= pda-emissao-fim
                    use-index data-emissao) then do:
                FIND FIRST ordem-compra where  
                           ordem-compra.cod-emitente >= pi-cod-for-ini  and
                           ordem-compra.cod-emitente <= pi-cod-for-fim  AND
                           ordem-compra.data-emissao >= pda-emissao-ini and
                           ordem-compra.data-emissao <= pda-emissao-fim and 
                           ordem-compra.cod-estabel  >= pc-estabel-ini  and
                           ordem-compra.cod-estabel  <= pc-estabel-fim  AND
                           ordem-compra.dep-almoxar  >= pcDepIni        and
                           ordem-compra.dep-almoxar  <= pcDepFim NO-LOCK NO-ERROR.
                IF AVAIL ordem-compra THEN assign l-existeOrdem = yes.
       END.
    END.

    IF l-existeOrdem THEN DO:
        ASSIGN r-aux-pri = ROWID(ordem-compra).
        IF r-ord-compra <> ? THEN DO:
            /* FIND prazo-compra WHERE ROWID(prazo-compra) = r-ord-compra NO-LOCK NO-ERROR.
            FIND ordem-compra where  
                 ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK NO-ERROR.*/
            /* Testa pois se a faixa foi alterada na tela o rowid que vem na navegaá∆o deve ser ignorado */
            FIND bfordem-compra WHERE ROWID(bfordem-compra) = r-ord-compra NO-LOCK NO-ERROR.
            IF AVAIL bfordem-compra AND bfordem-compra.cod-emitente >= pi-cod-for-ini 
                                    AND bfordem-compra.cod-emitente <= pi-cod-for-fim THEN DO:
               FIND ordem-compra WHERE ROWID(ordem-compra) = r-ord-compra NO-LOCK NO-ERROR.
               ASSIGN r-first = r-ord-compra.
            END.
        END.

        DO WHILE i-cont2 <= (i-nrlinhas):
            IF piSituacao = 7 THEN DO:
                FOR each prazo-compra fields (numero-ordem situacao data-entrega) WHERE 
                         prazo-compra.numero-ordem  = ordem-compra.numero-ordem and 
                         prazo-compra.data-entrega >= pd-entrega-ini            and
                         prazo-compra.data-entrega <= pd-entrega-fim      NO-LOCK :
    
                        ASSIGN i-cont2 = i-cont2 + 1.
                        CREATE rowsOrdem.
                        ASSIGN rowsOrdem.i-seq   = i-cont2
                               rowsOrdem.r-ordem = ROWID(ordem-compra)
                               rowsOrdem.r-prazo = ROWID(prazo-compra).
                        IF c-naveg = "ant" THEN ASSIGN rowsOrdem.i-seq = (9999999 - i-cont2). /* Para deixar a ordenaá∆o correta */
    
                END.
            END.
            ELSE DO:
                FOR each prazo-compra fields (numero-ordem situacao data-entrega) WHERE 
                         prazo-compra.numero-ordem  = ordem-compra.numero-ordem and 
                         prazo-compra.situacao      = piSituacao                and 
                         prazo-compra.data-entrega >= pd-entrega-ini            and
                         prazo-compra.data-entrega <= pd-entrega-fim      NO-LOCK :
    
                        ASSIGN i-cont2 = i-cont2 + 1.
                        CREATE rowsOrdem.
                        ASSIGN rowsOrdem.i-seq   = i-cont2
                               rowsOrdem.r-ordem = ROWID(ordem-compra)
                               rowsOrdem.r-prazo = ROWID(prazo-compra).
                        IF c-naveg = "ant" THEN ASSIGN rowsOrdem.i-seq = (9999999 - i-cont2). /* Para deixar a ordenaá∆o correta */
    
                END.
            END.

            IF c-naveg = "ant" then do:
                IF ROWID(ordem-compra) <> r-aux-pri THEN DO:
                   ASSIGN r-first = ROWID(ordem-compra).
                   FIND PREV ordem-compra where  
                             ordem-compra.cod-emitente >= pi-cod-for-ini  and
                             ordem-compra.cod-emitente <= pi-cod-for-fim  AND
                             ordem-compra.data-emissao >= pda-emissao-ini and
                             ordem-compra.data-emissao <= pda-emissao-fim and
                             ordem-compra.cod-estabel  >= pc-estabel-ini  and
                             ordem-compra.cod-estabel  <= pc-estabel-fim  AND
                             ordem-compra.dep-almoxar  >= pcDepIni        and
                             ordem-compra.dep-almoxar  <= pcDepFim NO-LOCK NO-ERROR.
                END.
                ELSE DO:
                   ASSIGN r-first = ?.
                   FOR EACH rowsOrdem EXCLUSIVE-LOCK:
                       DELETE rowsOrdem.
                   END.
                   ASSIGN i-cont2 = 0.
                   ASSIGN c-naveg = "pro".
                   FIND ordem-compra WHERE ROWID(ordem-compra) = r-aux-pri NO-LOCK NO-ERROR.
                END.
            END.
            ELSE DO:
                FIND NEXT ordem-compra where  
                         ordem-compra.cod-emitente >= pi-cod-for-ini  and
                         ordem-compra.cod-emitente <= pi-cod-for-fim  AND
                         ordem-compra.data-emissao >= pda-emissao-ini and
                         ordem-compra.data-emissao <= pda-emissao-fim and
                         ordem-compra.cod-estabel  >= pc-estabel-ini  and
                         ordem-compra.cod-estabel  <= pc-estabel-fim  AND
                         ordem-compra.dep-almoxar  >= pcDepIni        and
                         ordem-compra.dep-almoxar  <= pcDepFim NO-LOCK NO-ERROR.

                IF NOT AVAIL ordem-compra THEN ASSIGN i-cont2 = i-nrlinhas + 1.
            END.
        END.   
    END.

    /* Como estou usando o rowid s¢ ir† dar uns 15 acessos a mais na ordem-compra */
    FOR EACH rowsOrdem NO-LOCK BY rowsOrdem.i-seq :
        FIND FIRST ordem-compra WHERE rowid(ordem-compra) = rowsOrdem.r-ordem      NO-LOCK NO-ERROR.
        ASSIGN r-last = rowsOrdem.r-ordem.
        FIND FIRST item         WHERE item.it-codigo      = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        FOR EACH prazo-compra WHERE rowid(prazo-compra) = rowsOrdem.r-prazo NO-LOCK:
            run createTTOrdemCompra.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraPorRequisitante DBOProgram 
PROCEDURE carregaTTOrdemCompraPorRequisitante :
/*------------------------------------------------------------------------------
  Purpose:     carregaTabelaTTOrdemCompra8
    Carrega temp-table tt-ordem-compra, abrindo a query de acordo com valores 
    parametrizados. Na criacao da tt-ordem-compra, a temp-table recebe valores 
    das tabelas prazo-compra e item.
    O programa que utiliza esse metodo, tem faixa/selecao de requisitante e faz restricao por fornecedor.  
  Parameters: 
    ipar1 : c-requis-ini    : codigo do requisitante inicial
    ipar2 : c-requis-fim    : codigo do requisitante final
    ipar3 : i-cod-for-ini   : codigo do fornecedor inicial
    ipar4 : i-cod-for-fim   : codigo do fornecedor final
    ipar5 : da-emissao-ini  : data de emissao inicial 
    ipar6 : da-emissao-fim  : data de emissao final
    ipar7 : piSituacao      : situacao da parcela 
    ipar8 : d-entrega-ini   : data de entrega inicial 
    ipar9 : d-entrega-fim   : data de entrega final     
    ipar10: c-estabel-ini   : codigo do estabelecimento inicial 
    ipar11: c-estabel-fim   : codigo do estabelecimento final       
  Notes:       
------------------------------------------------------------------------------*/
def input param c-requis-ini     as char no-undo.
def input param c-requis-fim     as char no-undo.
def input param i-cod-for-ini    as int  no-undo.
def input param i-cod-for-fim    as int  no-undo.
def input param da-emissao-ini   as date no-undo.
def input param da-emissao-fim   as date no-undo.
def input param piSituacao       as int  no-undo.
def input param d-entrega-ini    as date no-undo.
def input param d-entrega-fim    as date no-undo.
def input param c-estabel-ini    as char no-undo.
def input param c-estabel-fim    as char no-undo.
def input param pcDepIni         as char no-undo.
def input param pcDepFim         as char no-undo.    

    DEF VAR c-row-ord AS CHAR NO-UNDO.
    ASSIGN i-cont2 = 0.

    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.

    ASSIGN r-first = ?.

    /* n∆o incrementa o n£mero de acessos porque t† usando o °ndice. 
       Esses testes serve para evitar incrementar os acessos qdo n∆o h† registros que se encaixem na faixa */
    IF CAN-FIND (FIRST ordem-compra where  
                 ordem-compra.cod-estabel >= c-estabel-ini and
                 ordem-compra.cod-estabel <= c-estabel-fim
                 use-index estabel) then do:
       /* n∆o incrementa o n£mero de acessos porque t† usando o °ndice */
       IF CAN-FIND (FIRST ordem-compra where  
                    ordem-compra.data-emissao >= da-emissao-ini and
                    ordem-compra.data-emissao <= da-emissao-fim
                    use-index data-emissao) then do:
          /* n∆o incrementa o n£mero de acessos porque t† usando o °ndice */
          IF CAN-FIND (FIRST ordem-compra where  
                       ordem-compra.cod-emitente >= i-cod-for-ini   and
                       ordem-compra.cod-emitente <= i-cod-for-fim
                       use-index emitente) then do:
                      FIND FIRST ordem-compra where  
                                 ordem-compra.requisitante >= c-requis-ini   and
                                 ordem-compra.requisitante <= c-requis-fim   and
                                 ordem-compra.data-emissao >= da-emissao-ini and
                                 ordem-compra.data-emissao <= da-emissao-fim and
                                 ordem-compra.cod-emitente >= i-cod-for-ini  and
                                 ordem-compra.cod-emitente <= i-cod-for-fim  and
                                 ordem-compra.cod-estabel  >= c-estabel-ini  and
                                 ordem-compra.cod-estabel  <= c-estabel-fim  AND
                                 ordem-compra.dep-almoxar  >= pcDepIni       and
                                 ordem-compra.dep-almoxar  <= pcDepFim
                                 use-index comp-requis NO-LOCK NO-ERROR.
                      IF AVAIL ordem-compra THEN assign l-existeOrdem = yes.
          END.
       END.
    END.

    IF l-existeOrdem THEN DO:
        ASSIGN r-aux-pri = ROWID(ordem-compra).
        IF r-ord-compra <> ? THEN DO:
            /* FIND prazo-compra WHERE ROWID(prazo-compra) = r-ord-compra NO-LOCK NO-ERROR.
            FIND ordem-compra where  
                 ordem-compra.numero-ordem = prazo-compra.numero-ordem NO-LOCK NO-ERROR.*/
            /* Testa pois se a faixa foi alterada na tela o rowid que vem na navegaá∆o deve ser ignorado */
            FIND bfordem-compra WHERE ROWID(bfordem-compra) = r-ord-compra NO-LOCK NO-ERROR.
            IF AVAIL bfordem-compra AND bfordem-compra.requisitante >= c-requis-ini
                                    AND bfordem-compra.requisitante <= c-requis-fim THEN DO:
               FIND ordem-compra WHERE ROWID(ordem-compra) = r-ord-compra NO-LOCK NO-ERROR.
               ASSIGN r-first = r-ord-compra.
            END.
        END.

        DO WHILE i-cont2 <= (i-nrlinhas):
            IF piSituacao = 7 THEN DO:
                FOR each prazo-compra fields(numero-ordem situacao data-entrega) WHERE 
                         prazo-compra.numero-ordem  = ordem-compra.numero-ordem and 
                         prazo-compra.data-entrega >= d-entrega-ini             and
                         prazo-compra.data-entrega <= d-entrega-fim NO-LOCK by prazo-compra.parcela :
    
                        ASSIGN i-cont2 = i-cont2 + 1.
                        CREATE rowsOrdem.
                        ASSIGN rowsOrdem.i-seq   = i-cont2
                               rowsOrdem.r-ordem = ROWID(ordem-compra)
                               rowsOrdem.r-prazo = ROWID(prazo-compra).
                        IF c-naveg = "ant" THEN ASSIGN rowsOrdem.i-seq = (9999999 - i-cont2). /* Para deixar a ordenaá∆o correta */
                END.
            END.
            ELSE DO:
                FOR each prazo-compra fields(numero-ordem situacao data-entrega) WHERE 
                         prazo-compra.numero-ordem  = ordem-compra.numero-ordem and 
                         prazo-compra.situacao      = piSituacao                and 
                         prazo-compra.data-entrega >= d-entrega-ini             and
                         prazo-compra.data-entrega <= d-entrega-fim NO-LOCK by prazo-compra.parcela :
    
                        ASSIGN i-cont2 = i-cont2 + 1.
                        CREATE rowsOrdem.
                        ASSIGN rowsOrdem.i-seq   = i-cont2
                               rowsOrdem.r-ordem = ROWID(ordem-compra)
                               rowsOrdem.r-prazo = ROWID(prazo-compra).
                        IF c-naveg = "ant" THEN ASSIGN rowsOrdem.i-seq = (9999999 - i-cont2). /* Para deixar a ordenaá∆o correta */
                END.
            END.

            IF c-naveg = "ant" then do:
                IF ROWID(ordem-compra) <> r-aux-pri THEN DO:
                    ASSIGN r-first = ROWID(ordem-compra).
                    FIND PREV ordem-compra where  
                        ordem-compra.requisitante >= c-requis-ini   and
                        ordem-compra.requisitante <= c-requis-fim   and            
                        ordem-compra.data-emissao >= da-emissao-ini and
                        ordem-compra.data-emissao <= da-emissao-fim and
                        ordem-compra.cod-emitente >= i-cod-for-ini  and
                        ordem-compra.cod-emitente <= i-cod-for-fim  and
                        ordem-compra.cod-estabel  >= c-estabel-ini  and
                        ordem-compra.cod-estabel  <= c-estabel-fim  AND
                        ordem-compra.dep-almoxar  >= pcDepIni       and
                        ordem-compra.dep-almoxar  <= pcDepFim
                        use-index comp-requis NO-LOCK NO-ERROR.
                END.
                ELSE DO:
                   ASSIGN r-first = ?.
                   FOR EACH rowsOrdem EXCLUSIVE-LOCK:
                       DELETE rowsOrdem.
                   END.
                   ASSIGN i-cont2 = 0.
                   ASSIGN c-naveg = "pro".
                   FIND ordem-compra WHERE ROWID(ordem-compra) = r-aux-pri NO-LOCK NO-ERROR.
                END.
            END.
            ELSE DO:
                FIND NEXT ordem-compra where  
                    ordem-compra.requisitante >= c-requis-ini   and
                    ordem-compra.requisitante <= c-requis-fim   and
                    ordem-compra.data-emissao >= da-emissao-ini and
                    ordem-compra.data-emissao <= da-emissao-fim and
                    ordem-compra.cod-emitente >= i-cod-for-ini  and
                    ordem-compra.cod-emitente <= i-cod-for-fim  and
                    ordem-compra.cod-estabel  >= c-estabel-ini  and
                    ordem-compra.cod-estabel  <= c-estabel-fim  AND
                    ordem-compra.dep-almoxar  >= pcDepIni        and
                    ordem-compra.dep-almoxar  <= pcDepFim
                    use-index comp-requis NO-LOCK NO-ERROR.

                IF NOT AVAIL ordem-compra THEN ASSIGN i-cont2 = i-nrlinhas + 1.
            END.
        END.   
    END.

    FOR EACH rowsOrdem NO-LOCK BY rowsOrdem.i-seq :
        FIND FIRST ordem-compra WHERE rowid(ordem-compra) = rowsOrdem.r-ordem      NO-LOCK NO-ERROR.
        ASSIGN r-last = rowsOrdem.r-ordem.
        FIND FIRST item         WHERE item.it-codigo      = ordem-compra.it-codigo NO-LOCK NO-ERROR.
        FOR EACH prazo-compra WHERE rowid(prazo-compra) = rowsOrdem.r-prazo NO-LOCK:
            run createTTOrdemCompra.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraPorRowidComprador DBOProgram 
PROCEDURE carregaTTOrdemCompraPorRowidComprador :
/*------------------------------------------------------------------------------
  Purpose:     carregaTabelaTTOrdemCompra
    Carrega tabela de ordem-compra, abrindo a query de acordo com valores 
    parametrizados.Na criaá∆o da tabela ordem-compra ela recebe valores 
    das tabelas pedido-compr e cotacao-item.
  Parameters:  
    ipar1 : r-comprador    : rowid da tabela comprador
    ipar2 : da-emissao-ini : data de emissao inicial
    ipar3 : da-emissao-fim : data de emissao final
    ipar4 : c-estab-ini    : estabelecimento inicial
    ipar5 : c-estab-fim    : estabelecimento final
    ipar6 : c-nao-confir   : situacao do documento - Nao Confirmado
    ipar7 : c-confir       : situacao do documento - Confirmado
    ipar8 : c-cotada       : situacao do documento - Cotado
    ipar9 : c-elimin       : situacao do documento - Eliminado 
    ipar10: c-em-cotacao   : situacao do documento - Em Cotaá∆o
    ipar11: c-receb        : situacao do documento - Recebido 
    ipar12: c-compra       : natureza do documento - Compra
    ipar13: c-servico      : natureza do documento - Servico
    ipar14: c-benefi       : natureza do documento - Beneficiamento
    ipar15: i-apresentacao : n≠vel do documento - 1 = Ordem 2 = Cotacao 3 = Pedido 4 = Recebimento  
  Notes:       
------------------------------------------------------------------------------*/

def input param r-comprador    as rowid no-undo.
def input param da-emissao-ini as date  no-undo.
def input param da-emissao-fim as date  no-undo. 
def input param c-estab-ini    as char  no-undo.
def input param c-estab-fim    as char  no-undo.
def input param c-naocon       as char  no-undo.
def input param c-confir       as char  no-undo.
def input param c-cotada       as char  no-undo.
def input param c-elimin       as char  no-undo.
def input param c-em-cotacao   as char  no-undo.
def input param c-receb        as char  no-undo.
def input param c-compra       as char  no-undo.
def input param c-servico      as char  no-undo.
def input param c-benefi       as char  no-undo.
def input param i-apresentacao as int   no-undo.    

def var l-ok                 as log  no-undo.
def var lg_nao_confirmada    as log  no-undo.
def var lg_confirmada        as log  no-undo.
def var lg_cotada            as log  no-undo. 
def var lg_eliminada         as log  no-undo.
def var lg_em_cotacao        as log  no-undo.
def var lg_recebida          as log  no-undo.
def var lg_compra            as log  no-undo. 
def var lg_servico           as log  no-undo.
def var lg_beneficiamento    as log  no-undo.
def var c-natureza           as char no-undo.
def var c-lista-natureza     as char no-undo.
def var c-lista-situacao     as char no-undo.
def var c-lista-pedido       as char no-undo.
def var de-total             as dec  no-undo.    

    assign    
        lg_nao_confirmada   = if c-naocon     = "yes":U then YES else NO
        lg_confirmada       = if c-confir     = "yes":U then YES else NO
        lg_cotada           = if c-cotada     = "yes":U then YES else NO 
        lg_eliminada        = if c-elimin     = "yes":U then YES else NO
        lg_em_cotacao       = if c-em-cotacao = "yes":U then YES else NO
        lg_recebida         = if c-receb      = "yes":U then YES else NO
        lg_compra           = if c-compra     = "yes":U then YES else NO
        lg_servico          = if c-servico    = "yes":U then YES else NO
        lg_beneficiamento   = if c-benefi     = "yes":U then YES else NO .

    assign  c-lista-situacao = {ininc/i02in274.i 03} 
            c-lista-natureza = {ininc/i01in274.i 03}
            c-lista-pedido   = {ininc/i02in295.i 03} .

    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.

    find comprador where
        rowid(comprador) = r-comprador
        no-lock no-error.
   
    for each ordem-compra where 
        ordem-compra.cod-comprado = comprador.cod-comprado and
        ordem-compra.data-emissao >= da-emissao-ini and
        ordem-compra.data-emissao <= da-emissao-fim and
        ordem-compra.cod-estabel  >= c-estab-ini and
        ordem-compra.cod-estabel  <= c-estab-fim and
        ((ordem-compra.situacao = 1 and lg_nao_confirmada) or
         (ordem-compra.situacao = 2 and lg_confirmada) or
         (ordem-compra.situacao = 3 and lg_cotada) or
         (ordem-compra.situacao = 4 and lg_eliminada) or
         (ordem-compra.situacao = 5 and lg_em_cotacao) or
         (ordem-compra.situacao = 6 and lg_recebida)) and
        ((ordem-compra.natureza = 1 and lg_compra) or
         (ordem-compra.natureza = 2 and lg_servico) or
         (ordem-compra.natureza = 3 and lg_beneficiamento))
         no-lock by ordem-compra.numero-ordem:

        RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido). 

    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraPorRowidComprador2 DBOProgram 
PROCEDURE carregaTTOrdemCompraPorRowidComprador2 :
/*------------------------------------------------------------------------------
  Purpose: Carrega temp-table tt-ordem-compra de acordo com valores recebidos.  
  Parameters:  
    par1  : r-comprador            : INPUT : rowid da tabela comprador;        
    par2  : c-naocon               : INPUT : situacao do documento - Nao Confirmado;              
    par3  : c-confir               : INPUT : situacao do documento - Confirmado;   
    par4  : c-cotada               : INPUT : situacao do documento - Cotado;       
    par5  : c-elimin               : INPUT : situacao do documento - Eliminado;    
    par6  : c-em-cotacao           : INPUT : situacao do documento - Em Cotaá∆o;   
    par7  : c-receb                : INPUT : situacao do documento - Recebido;     
    par8  : c-compra               : INPUT : natureza do documento - Compra;       
    par9  : c-servico              : INPUT : natureza do documento - Servico;      
    par10 : c-benefi               : INPUT : natureza do documento - Beneficiamento;
    par11 : i-apresentacao         : INPUT : n°vel do documento;
        1 = Ordem; 
        2 = Cotacao; 
        3 = Pedido; 
        4 = Recebimento;
    par12 : c-estab-ini            : INPUT : estabelecimento inicial;
    par13 : c-estab-fim            : INPUT : estabelecimento final;        
    par14 : i-numero-ordem-ini     : INPUT : numero ordem inicial;
    par15 : i-numero-ordem-fim     : INPUT : numero ordem final;
    par16 : da-emissao-ini         : INPUT : data de emissao inicial;
    par17 : da-emissao-fim         : INPUT : data de emissao final;
    par18 : c-it-codigo-ini        : INPUT : c¢digo do item inicial;
    par19 : c-it-codigo-fim        : INPUT : c¢digo do item final;
    par20 : i-num-pedido-ini       : INPUT : numero do pedido inicial;
    par21 : i-num-pedido-fim       : INPUT : numero do pedido finalal;
    par22 : i-cod-emitente-ini     : INPUT : emitente inicial;
    par23 : i-cod-emitente-fim     : INPUT : emitente final;
    par24 : i-nr-processo-ini      : INPUT : processo inicial;
    par25 : i-nr-processo-fim      : INPUT : processo final;
    par26 : c-requisitante-ini     : INPUT : requisitante inicial;
    par27 : c-requisitante-fim     : INPUT : requisitante final;
    par28 : i-nr-requisicao-ini    : INPUT : numero requisiá∆o inicial;
    par29 : i-nr-requisicao-fim    : INPUT : numero requisiá∆o final;
    
  Notes: Na criaá∆o da temp-table tt-ordem-compra ela recebe valores das tabelas pedido-compr e cotacao-item.      
------------------------------------------------------------------------------*/
def input param r-comprador         as rowid no-undo.                               
def input param c-naocon            as char  no-undo.                               
def input param c-confir            as char  no-undo.                               
def input param c-cotada            as char  no-undo.                               
def input param c-elimin            as char  no-undo.                               
def input param c-em-cotacao        as char  no-undo.                               
def input param c-receb             as char  no-undo.                               
def input param c-compra            as char  no-undo.                               
def input param c-servico           as char  no-undo.                               
def input param c-benefi            as char  no-undo.                               
def input param i-apresentacao      as int   no-undo.                               
def input param c-estab-ini         as char  no-undo.                               
def input param c-estab-fim         as char  no-undo.                               
def input param i-numero-ordem-ini  as int   no-undo.                               
def input param i-numero-ordem-fim  as int   no-undo.                               
def input param da-emissao-ini      as date  format "99/99/9999":U  no-undo.       
def input param da-emissao-fim      as date  format "99/99/9999":U  no-undo.       
def input param c-it-codigo-ini     as char  no-undo.                            
def input param c-it-codigo-fim     as char  no-undo.                            
def input param i-num-pedido-ini    as int   no-undo.                            
def input param i-num-pedido-fim    as int   no-undo.                            
def input param i-cod-emitente-ini  as int   no-undo.                            
def input param i-cod-emitente-fim  as int   no-undo.                            
def input param i-nr-processo-ini   as int   no-undo.                            
def input param i-nr-processo-fim   as int   no-undo.                            
def input param c-requisitante-ini  as char  no-undo.                            
def input param c-requisitante-fim  as char  no-undo.                            
def input param i-nr-requisicao-ini as int   no-undo.
def input param i-nr-requisicao-fim as int   no-undo.

def var l-ok                 as log  no-undo.
def var lg_nao_confirmada    as log  no-undo.
def var lg_confirmada        as log  no-undo.
def var lg_cotada            as log  no-undo. 
def var lg_eliminada         as log  no-undo.
def var lg_em_cotacao        as log  no-undo.
def var lg_recebida          as log  no-undo.
def var lg_compra            as log  no-undo. 
def var lg_servico           as log  no-undo.
def var lg_beneficiamento    as log  no-undo.
def var c-natureza           as char no-undo.
def var c-lista-natureza     as char no-undo.
def var c-lista-situacao     as char no-undo.
def var c-lista-pedido       as char no-undo.
def var de-total             as dec  no-undo.    


    assign    
        lg_nao_confirmada   = if c-naocon     = "yes":U  then YES else NO
        lg_confirmada       = if c-confir     = "yes":U  then YES else NO
        lg_cotada           = if c-cotada     = "yes":U  then YES else NO 
        lg_eliminada        = if c-elimin     = "yes":U  then YES else NO
        lg_em_cotacao       = if c-em-cotacao = "yes":U  then YES else NO
        lg_recebida         = if c-receb      = "yes":U  then YES else NO
        lg_compra           = if c-compra     = "yes":U  then YES else NO
        lg_servico          = if c-servico    = "yes":U  then YES else NO
        lg_beneficiamento   = if c-benefi     = "yes":U  then YES else NO .

    assign  c-lista-situacao = {ininc/i02in274.i 03} 
            c-lista-natureza = {ininc/i01in274.i 03}
            c-lista-pedido   = {ininc/i02in295.i 03} .

    for each tt-ordem-compra:
        delete tt-ordem-compra.
    end.

    FIND FIRST comprador 
         WHERE ROWID(comprador) = r-comprador NO-LOCK NO-ERROR.
 
/* Criaá∆o ttOrdemCompra */

IF (da-emissao-fim - da-emissao-ini) < 30 THEN DO:

    FOR EACH ordem-compra NO-LOCK
       WHERE ordem-compra.cod-comprado = comprador.cod-comprado
         AND ordem-compra.data-emissao >= da-emissao-ini
         AND ordem-compra.data-emissao <= da-emissao-fim BY ordem-compra.numero-ordem:

        {inbo/boin274q02.i2}
        RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).
        
    END.
END.
ELSE DO:
    IF i-numero-ordem-ini <> 0 AND i-numero-ordem-fim <> 99999999 THEN DO:

        FOR EACH ordem-compra NO-LOCK
           WHERE ordem-compra.cod-comprado = comprador.cod-comprado
             AND ordem-compra.numero-ordem >= i-numero-ordem-ini
             AND ordem-compra.numero-ordem <= i-numero-ordem-fim BY ordem-compra.numero-ordem:  

            {inbo/boin274q02.i2}
            RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

        END.
    END.
    ELSE DO:

        IF i-num-pedido-ini <> 0 AND i-num-pedido-fim <> 99999999 THEN DO:

            IF c-it-codigo-ini <> "":U AND c-it-codigo-fim <> "ZZZZZZZZZZZZZZZZ":U THEN DO:

                FOR EACH ordem-compra NO-LOCK
                   WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                     AND ordem-compra.num-pedido >= i-num-pedido-ini
                     AND ordem-compra.num-pedido <= i-num-pedido-fim
                     AND ordem-compra.it-codigo  >= c-it-codigo-ini
                     AND ordem-compra.it-codigo  <= c-it-codigo-fim BY ordem-compra.numero-ordem:

                    {inbo/boin274q02.i2}
                    RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

                END.
            END.
            ELSE DO:

                FOR EACH ordem-compra NO-LOCK
                   WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                     AND ordem-compra.num-pedido >= i-num-pedido-ini
                     AND ordem-compra.num-pedido <= i-num-pedido-fim BY ordem-compra.numero-ordem:

                    {inbo/boin274q02.i2}
                    RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

                END.
            END.
        END.

        ELSE IF i-nr-processo-ini <> 0 AND i-nr-processo-fim <> 999999 THEN DO:

            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                 AND ordem-compra.nr-processo  >= i-nr-processo-ini
                 AND ordem-compra.nr-processo  <= i-nr-processo-fim
                 AND ordem-compra.numero-ordem >= i-numero-ordem-ini
                 AND ordem-compra.numero-ordem <= i-numero-ordem-fim BY ordem-compra.numero-ordem:

                {inbo/boin274q02.i2}
                RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

            END.
        END.
        ELSE IF i-nr-requisicao-ini <> 0 AND i-nr-requisicao-fim <> 999999999 THEN DO:

            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                 AND ordem-compra.nr-requisicao >= i-nr-requisicao-ini
                 AND ordem-compra.nr-requisicao <= i-nr-requisicao-fim BY ordem-compra.numero-ordem:

                {inbo/boin274q02.i2}
                RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

            END.
        END.

        ELSE IF i-cod-emitente-ini <> 0 AND i-cod-emitente-fim <> 9999999 THEN DO:

            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                 AND ordem-compra.cod-emitente >= i-cod-emitente-ini
                 AND ordem-compra.cod-emitente <= i-cod-emitente-fim
                 AND ordem-compra.numero-ordem >= i-numero-ordem-ini
                 AND ordem-compra.numero-ordem <= i-numero-ordem-fim BY ordem-compra.numero-ordem:

                {inbo/boin274q02.i2}
                RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

            END.
        END.

        ELSE IF c-requisitante-ini <> "":U AND c-requisitante-fim <> "ZZZZZZZZZZZZ":U THEN DO:

            IF da-emissao-ini <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF AND
               da-emissao-fim <> 12/31/9999 THEN DO:

                FOR EACH ordem-compra NO-LOCK
                   WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                     AND ordem-compra.requisitante >= c-requisitante-ini
                     AND ordem-compra.requisitante <= c-requisitante-fim
                     AND ordem-compra.data-emissao >= da-emissao-ini
                     AND ordem-compra.data-emissao <= da-emissao-fim BY ordem-compra.numero-ordem:

                    {inbo/boin274q02.i2}
                    RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

                END.
            END.
            ELSE DO:

                FOR EACH ordem-compra NO-LOCK
                   WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                     AND ordem-compra.requisitante >= c-requisitante-ini
                     AND ordem-compra.requisitante <= c-requisitante-fim BY ordem-compra.numero-ordem:

                    {inbo/boin274q02.i2}
                    RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

                END.
            END.
        END.

        ELSE IF da-emissao-ini <> &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF AND
                da-emissao-fim <> 12/31/9999 THEN DO:

            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                 AND ordem-compra.data-emissao >= da-emissao-ini
                 AND ordem-compra.data-emissao <= da-emissao-fim BY ordem-compra.numero-ordem:

                {inbo/boin274q02.i2}
                RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

            END.
        END.

        ELSE IF c-it-codigo-ini <> "":U AND c-it-codigo-fim <> "ZZZZZZZZZZZZZZZZ":U THEN DO:

            IF c-estab-ini <> "":U AND c-estab-fim <> "ZZZZZ":U THEN DO:

                FOR EACH ordem-compra NO-LOCK
                   WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                     AND ordem-compra.cod-estabel >= c-estab-ini
                     AND ordem-compra.cod-estabel <= c-estab-fim
                     AND ordem-compra.it-codigo   >= c-it-codigo-ini
                     AND ordem-compra.it-codigo   <= c-it-codigo-fim BY ordem-compra.numero-ordem:

                    {inbo/boin274q02.i2}
                    RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

                END.
            END.
            ELSE DO:
                FOR EACH ordem-compra NO-LOCK
                   WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                     AND ordem-compra.it-codigo >= c-it-codigo-ini
                     AND ordem-compra.it-codigo <= c-it-codigo-fim
                     AND ordem-compra.numero-ordem >= i-numero-ordem-ini
                     AND ordem-compra.numero-ordem <= i-numero-ordem-fim BY ordem-compra.numero-ordem:
    
                    {inbo/boin274q02.i2}
                    RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).
    
                END.
            END.
        END.

        ELSE IF c-estab-ini <> "":U AND c-estab-fim <> "ZZZZZ":U THEN DO:

            FOR EACH ordem-compra NO-LOCK
               WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                 AND ordem-compra.cod-estabel >= c-estab-ini
                 AND ordem-compra.cod-estabel <= c-estab-fim BY ordem-compra.numero-ordem:

                {inbo/boin274q02.i2}
                RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).

            END.
        END.

        ELSE DO:
            FOR EACH ordem-compra USE-INDEX comprador
               WHERE ordem-compra.cod-comprado = comprador.cod-comprado
                 AND ordem-compra.numero-ordem >= i-numero-ordem-ini
                 AND ordem-compra.numero-ordem <= i-numero-ordem-fim NO-LOCK:

                {inbo/boin274q02.i2}
                RUN pi-auxiliar-carrega-ttOrdemCompra (INPUT i-apresentacao ,INPUT c-lista-pedido).
            END.
        END.
    END.
END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraSemPedido DBOProgram 
PROCEDURE carregaTTOrdemCompraSemPedido :
/*------------------------------------------------------------------------------
  Purpose:     CarregaTempTableOrdemCompra
    Carrega a temp-table tt-ordem-compra para cada prazo-compra. Caso tenha alguma Ordem-Compra(Rowid)
    cadastrada no Contexto, esta ordem-compra n∆o ser† incluida na temp-table.
  Parameters:
    ipar1: pi-cod-emitente : codigo do emitente
    ipar2: pi-natureza     : natureza da operaá∆o
    ipar3: pi-cod-cond-pag : Condiá∆o pagamento
    ipar4: pi-nr-processo  : N£mero Processo
    ipar5: pi-cod-transp   : transportador
    ipar6: pi-ordem-ini    : Ordem Inicial
    ipar7: pi-ordem-fin    : Ordem Final
    ipar8: tt-ordem-rowid  : rowid das ordens cadastradas e q n∆o devem ser incluidas na temp-table
  Notes:
------------------------------------------------------------------------------*/

    def input param pi-cod-emitente as int  no-undo.
    def input param pi-natureza     as int  no-undo.
    def input param pi-cod-cond-pag as int  no-undo.
    def input param pi-nr-processo  as int  no-undo.
    def input param pi-cod-transp   as int  no-undo.
    def input param pi-ordem-ini    as int  no-undo.
    def input param pi-ordem-fin    as int  no-undo.  
    def input param table for tt-ordem-rowid .

    for each  ordem-compra fields(numero-ordem it-codigo)
        where ordem-compra.cod-emitente = pi-cod-emitente 
          and ordem-compra.natureza     = pi-natureza     
          and ordem-compra.cod-cond-pag = pi-cod-cond-pag 
          and ordem-compra.nr-processo  = pi-nr-processo  
          and ordem-compra.cod-transp   = pi-cod-transp   
          and ordem-compra.num-pedido   = 0  
          and ordem-compra.situacao     = 3  
          and ordem-compra.expectativa  = no no-lock:

        find  tt-ordem-rowid 
        where tt-ordem-rowid.r-rowid = rowid(ordem-compra) 
          and tt-ordem-rowid.c-param = "add":U no-lock no-error.
        if  avail tt-ordem-rowid then                        
            next.

        if  ordem-compra.numero-ordem < pi-ordem-ini   
        or  ordem-compra.numero-ordem > pi-ordem-fin then
            next.

        for each prazo-compra fields(numero-ordem it-codigo quantidade un data-entrega)
            where prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
            create tt-ordem-compra.
            assign tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem
                   tt-ordem-compra.it-codigo    = ordem-compra.it-codigo
                   tt-ordem-compra.quantidade   = prazo-compra.quantidade
                   tt-ordem-compra.un           = prazo-compra.un
                   tt-ordem-compra.data-entrega = prazo-compra.data-entrega
                   tt-ordem-compra.r-rowid      = rowid(ordem-compra).
        end.
    end.

    for each  tt-ordem-rowid 
        where tt-ordem-rowid.c-param = "del":U no-lock:
        for first ordem-compra fields (numero-ordem it-codigo)
            where rowid(ordem-compra) = tt-ordem-rowid.r-rowid no-lock: end.
        if  avail ordem-compra then do:
            for each  prazo-compra fields(numero-ordem it-codigo quantidade un data-entrega)
                where prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK:
                create tt-ordem-compra.
                assign tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem
                       tt-ordem-compra.it-codigo    = ordem-compra.it-codigo
                       tt-ordem-compra.quantidade   = prazo-compra.quantidade
                       tt-ordem-compra.un           = prazo-compra.un
                       tt-ordem-compra.data-entrega = prazo-compra.data-entrega
                       tt-ordem-compra.r-rowid      = rowid(ordem-compra).
            end.        
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTTOrdemCompraSemSituacao DBOProgram 
PROCEDURE carregaTTOrdemCompraSemSituacao :
/*------------------------------------------------------------------------------
  Purpose:    carregarTempTableOrdemCompra1
    Carrega a temp-table Ordem de compra parametrizado pelo n£mero do processo 
    independente da situaá∆o.
  Parameters:
    ipar1: pi-nr-processo : n£mero do processo
  Notes:     
------------------------------------------------------------------------------*/
def input parameter pi-nr-processo as int no-undo.

assign i-nr-processo = pi-nr-processo.

    &IF INT (SUBSTRING (PROVERSION, 1, INDEX (PROVERSION, ".") - 1)) >= 9 &THEN          
        EMPTY TEMP-TABLE tt-ordem-compra.
    &ELSE                                                  
        FOR EACH tt-ordem-compra:
            DELETE tt-ordem-compra.
        END.
    &ENDIF.

    FOR EACH ordem-compra FIELDS( numero-ordem it-codigo nr-processo)
        WHERE ordem-compra.nr-processo = i-nr-processo NO-LOCK,
        FIRST cotacao-item FIELDS( )
        WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem NO-LOCK: 
            create tt-ordem-compra.
            assign
                tt-ordem-compra.numero-ordem = ordem-compra.numero-ordem
                tt-ordem-compra.it-codigo    = ordem-compra.it-codigo
                tt-ordem-compra.r-rowid      = rowid(ordem-compra)
                tt-ordem-compra.nr-processo  = ordem-compra.nr-processo. 
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTTOrdemCompra DBOProgram 
PROCEDURE createTTOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    create tt-ordem-compra.
    assign tt-ordem-compra.numero-ordem       = ordem-compra.numero-ordem
           tt-ordem-compra.natureza           = ENTRY(ordem-compra.natureza, c-lista-natureza)
           tt-ordem-compra.num-pedido         = ordem-compra.num-pedido
           tt-ordem-compra.cod-emitente       = ordem-compra.cod-emitente
           tt-ordem-compra.data-entrega       = prazo-compra.data-entrega
           tt-ordem-compra.parcela            = prazo-compra.parcela
           tt-ordem-compra.it-codigo          = ordem-compra.it-codigo
           tt-ordem-compra.un                 = prazo-compra.un
           tt-ordem-compra.situacao           = ENTRY(prazo-compra.situacao, c-lista-situacao)
           tt-ordem-compra.cod-comprado       = ordem-compra.cod-comprado  
           tt-ordem-compra.requisitante       = ordem-compra.requisitante
           tt-ordem-compra.quant-saldo        = prazo-compra.quant-saldo
           tt-ordem-compra.r-rowid            = rowid(ordem-compra). 

    RUN retornaDescricaoItem (output c-descricao).
    assign tt-ordem-compra.desc-item = c-descricao.

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-comprado":U THEN ASSIGN pFieldValue = RowObject.cod-comprado.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "estabelecimento":U THEN ASSIGN pFieldValue = RowObject.estabelecimento.
        WHEN "desc-item":U THEN ASSIGN pFieldValue = RowObject.desc-item.
        WHEN "natureza":U THEN ASSIGN pFieldValue = RowObject.natureza.
        WHEN "situacao-pedido":U THEN ASSIGN pFieldValue = RowObject.situacao-pedido.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-do-forn":U THEN ASSIGN pFieldValue = RowObject.item-do-forn.
        WHEN "emitente":U THEN ASSIGN pFieldValue = RowObject.emitente.
        WHEN "requisitante":U THEN ASSIGN pFieldValue = RowObject.requisitante.
        WHEN "situacao":U THEN ASSIGN pFieldValue = RowObject.situacao.
        WHEN "fm-codigo":U THEN ASSIGN pFieldValue = RowObject.fm-codigo.
        WHEN "documento":U THEN ASSIGN pFieldValue = RowObject.documento.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "c-rowid":U THEN ASSIGN pFieldValue = RowObject.c-rowid.        

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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-entrega":U THEN ASSIGN pFieldValue = RowObject.data-entrega.
        WHEN "data-cotacao":U THEN ASSIGN pFieldValue = RowObject.data-cotacao.
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
        WHEN "data-pedido":U THEN ASSIGN pFieldValue = RowObject.data-pedido.
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "preco-unit-mat":U THEN ASSIGN pFieldValue = RowObject.preco-unit-mat.
        WHEN "preco-unit-mat-ipi":U THEN ASSIGN pFieldValue = RowObject.preco-unit-mat-ipi.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "valor-ipi":U THEN ASSIGN pFieldValue = RowObject.valor-ipi.
        WHEN "quant-saldo":U THEN ASSIGN pFieldValue = RowObject.quant-saldo .       
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.


    CASE pFieldName:
        WHEN "parcela":U THEN ASSIGN pFieldValue = RowObject.parcela.
        WHEN "cod-cond-pag":U THEN ASSIGN pFieldValue = RowObject.cod-cond-pag.
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "cod-transp":U THEN ASSIGN pFieldValue = RowObject.cod-transp.
        WHEN "nr-processo":U THEN ASSIGN pFieldValue = RowObject.nr-processo.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice COMPRADOR
  Parameters:
               retorna valor dos campos do °ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.
    DEFINE OUTPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-comprado = RowObject.cod-comprado.
    ASSIGN pnumero-ordem = RowObject.numero-ordem.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowid DBOProgram 
PROCEDURE getRowid :
/*------------------------------------------------------------------------------
  Purpose:     Envia rowid do registro corrente da table {&Tablename}
  Parameters:  retorna rowid
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pRowid  AS ROWID NO-UNDO.

    IF NOT AVAILABLE {&TableName} THEN DO:
        /*--- Erro 3: Tabela {&TableLabel} nío dispon≠vel ---*/
        {method/svc/errors/inserr.i &ErrorNumber="3"
                                    &ErrorType="INTERNAL"
                                    &ErrorSubType="ERROR"}

        RETURN "NOK":U.
    END.

    ASSIGN pRowid = {&TableName}.r-rowid.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidFirstLast DBOProgram 
PROCEDURE getRowidFirstLast :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param r-chave-inform as rowid no-undo.
    def input  param c-nav          as char  no-undo.
    def input  param i-linhas       as int   no-undo.
    def output param pr-first        as rowid no-undo.
    def output param pr-last         as rowid no-undo.
    def var iAuxCont as int no-undo.

    if r-chave-inform <> ? then do:
       find bf{&TABLENAME} where 
            bf{&TABLENAME}.r-rowid = r-chave-inform
             no-lock no-error.

       if c-nav = "ant" then do:
            assign pr-last = bf{&TABLENAME}.r-rowid.
            assign linha-aux = i-linhas - 1.
            DO iAuxCont = 1 TO linha-aux:
              find prev bf{&TABLENAME} no-lock no-error.
              IF not avail bf{&TABLENAME} THEN DO:
                find first bf{&TABLENAME} no-lock no-error.
                ASSIGN iAuxCont = linha-aux + 1.
              END.
              if iAuxCont = linha-aux then do:
                 assign pr-first = bf{&TABLENAME}.r-rowid.
              end.
            END.
       end.

       if c-nav = "pro" or pr-first = ? then do:  /* se no "ant" pr-first = ? preciso achar pr-last */
            if c-nav = "pro" then assign pr-first = bf{&TABLENAME}.r-rowid.
            assign linha-aux = i-linhas - 1.
            DO iAuxCont = 1 TO linha-aux:
              find next bf{&TABLENAME} no-lock no-error.
              IF not avail bf{&TABLENAME} THEN DO:
                find last bf{&TABLENAME} no-lock no-error.
                ASSIGN iAuxCont = i-linhas + 1.
              END.
              if iAuxCont = linha-aux then do:
                 assign pr-last = bf{&TABLENAME}.r-rowid.
              end.
            END.
       end.
    end.

    find first bf{&TABLENAME} no-lock no-error.
    if bf{&TABLENAME}.r-rowid = pr-first then assign pr-first = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidFirstLastTT DBOProgram 
PROCEDURE getRowidFirstLastTT :
/*------------------------------------------------------------------------------
  Purpose:     Retorna os rowids iniciais e finais gravados qdo carregada a tt-ordem-compra
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param pr-first        as rowid no-undo.
    def output param pr-last         as rowid no-undo.

    ASSIGN pr-first = r-first
           pr-last  = r-last.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidOrdemCompra DBOProgram 
PROCEDURE getRowidOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:     
    Procura o rowid da tabela ordem-compra a partir do rowid da tabela
    temp-table da boin274q02.
  Parameters:  
    ipar1 : r-tt-ordem-compra  : rowid do registro corrente da boin274q02
    opar2 : r-ordem-compra     : rowid da tabela ordem-compra  
  Notes:       
------------------------------------------------------------------------------*/

    def input  param r-tt-ordem-compra as rowid no-undo.
    def output param r-ordem-compra    as rowid no-undo.    

    find first {&tablename} where
         rowid({&tablename}) = r-tt-ordem-compra 
         no-lock no-error.
    if avail {&tablename} then do:
        find first ordem-compra where
                   ordem-compra.numero-ordem = {&tablename}.numero-ordem and
                   ordem-compra.cod-estabel  = {&tablename}.cod-estabel
                   no-lock no-error.
         if avail ordem-compra then
            assign r-ordem-compra = rowid(ordem-compra).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice COMPRADOR
  Parameters:
               recebe valor dos campos do °ndice COMPRADOR
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-comprado LIKE ordem-compra.cod-comprado NO-UNDO.
    DEFINE INPUT PARAMETER pnumero-ordem LIKE ordem-compra.numero-ordem NO-UNDO.

    FIND FIRST bftt-ordem-compra WHERE
        bftt-ordem-compra.cod-comprado = pcod-comprado AND
        bftt-ordem-compra.numero-ordem = pnumero-ordem
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bftt-ordem-compra THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bftt-ordem-compra)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE informaNavegRowid DBOProgram 
PROCEDURE informaNavegRowid :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def INPUT PARAMETER pc-naveg   as char no-undo.
    def INPUT PARAMETER pc-ordem   as CHAR no-undo.
    def INPUT PARAMETER pi-linhas  as INT  no-undo.

    assign c-naveg       = pc-naveg
           r-ord-compra  = to-rowid(pc-ordem)
           i-nrlinhas    = pi-linhas.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByNumeroOrdem DBOProgram 
PROCEDURE openQueryByNumeroOrdem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} no-lock
                             by tt-ordem-compra.numero-ordem INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryByProcesso DBOProgram 
PROCEDURE openQueryByProcesso :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} no-lock
                                where {&TABLENAME}.nr-processo = i-nr-processo
                             by tt-ordem-compra.numero-ordem INDEXED-REPOSITION.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBySeq DBOProgram 
PROCEDURE openQueryBySeq :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
        FOR EACH tt-ordem-compra NO-LOCK 
            BY tt-ordem-compra.sequencia INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBySeqDecrescente DBOProgram 
PROCEDURE openQueryBySeqDecrescente :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} 
        FOR EACH tt-ordem-compra NO-LOCK 
            BY tt-ordem-compra.sequencia DESCENDING INDEXED-REPOSITION.

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
    OPEN QUERY {&QueryName} 
        FOR EACH tt-ordem-compra NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-auxiliar-carrega-ttOrdemCompra DBOProgram 
PROCEDURE pi-auxiliar-carrega-ttOrdemCompra :
/*------------------------------------------------------------------------------
  Purpose:    Respons†vel por criar a temp-table tt-ordem-compra.
  Parameters: i-apresentacao : INPUT : n°vel do documento;
                  1 = Ordem; 
                  2 = Cotacao; 
                  3 = Pedido; 
                  4 = Recebimento;
              c-lista-pedido : INPUT : Lista com as situaá‰es do pedido.
                  1 = Impresso
                  2 = N∆o Impresso
                  3 = Eliminado
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM i-apresentacao AS INT NO-UNDO.
    DEF INPUT PARAM c-lista-pedido AS CHAR NO-UNDO.

    DEFINE VARIABLE l-ok AS LOGICAL     NO-UNDO.

    assign l-ok = no.     
    
    FIND FIRST pedido-compr 
         WHERE pedido-compr.num-pedido = ordem-compra.num-pedido NO-LOCK NO-ERROR.
    IF NOT AVAIL pedido-compr THEN DO:
        IF i-apresentacao = 1 THEN
             ASSIGN l-ok = yes.
    
        IF i-apresentacao = 2 THEN DO:
            FIND FIRST prazo-compra 
                 WHERE prazo-compra.numero-ordem = ordem-compra.numero-ordem NO-LOCK NO-ERROR.
            IF  AVAIL prazo-compra THEN DO:
                FIND FIRST cotacao-item 
                     WHERE cotacao-item.numero-ordem = ordem-compra.numero-ordem 
                       AND cotacao-item.cot-aprovada = yes NO-LOCK NO-ERROR.
                IF AVAIL cotacao-item THEN
                    ASSIGN l-ok = YES.
            END.
        END.
    END.
    ELSE DO:
        IF i-apresentacao = 3 THEN 
                 ASSIGN l-ok = YES.

        IF i-apresentacao = 4 THEN DO:
                FIND FIRST recebimento 
                     WHERE recebimento.num-pedido   = pedido-compr.num-pedido 
                       AND recebimento.numero-ordem = ordem-compra.numero-ordem 
                       AND recebimento.quant-receb > 0  NO-LOCK NO-ERROR.
                IF AVAIL recebimento THEN
                    ASSIGN l-ok = YES.
        END.
    END.

    if  l-ok then do:

        create tt-ordem-compra.
        assign tt-ordem-compra.numero-ordem    = ordem-compra.numero-ordem
               tt-ordem-compra.it-codigo       = ordem-compra.it-codigo
               tt-ordem-compra.situacao        = ENTRY(ordem-compra.situacao, c-lista-situacao)
               tt-ordem-compra.natureza        = ENTRY(ordem-compra.natureza, c-lista-natureza)
               tt-ordem-compra.data-emissao    = ordem-compra.data-emissao
               tt-ordem-compra.nr-requisicao   = ordem-compra.nr-requisicao
               tt-ordem-compra.requisitante    = ordem-compra.requisitante
               tt-ordem-compra.nr-processo     = ordem-compra.nr-processo
               tt-ordem-compra.cod-emitente    = ordem-compra.cod-emitente                                              
               tt-ordem-compra.num-pedido      = ordem-compra.num-pedido                                     
               tt-ordem-compra.situacao-pedido = ( if available pedido-compr then
                                                   entry(pedido-compr.situacao,c-lista-pedido) else "" )
               tt-ordem-compra.r-rowid         = rowid(ordem-compra). 

                RUN retornaDescricaoItem (output c-descricao).
                assign tt-ordem-compra.desc-item = c-descricao.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescricaoItem DBOProgram 
PROCEDURE retornaDescricaoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       c¢pia da retornaDescricaoItem da boin274na
               foi feita para essa DBO para diminuir acessos ao banco no wcc0512.
------------------------------------------------------------------------------*/
    define output parameter pc-descricao as char  no-undo.

    if avail ordem-compra and not avail item then
       find first item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.

    if avail item then do:
        find first item-mat where item-mat.it-codigo = item.it-codigo no-lock no-error. 
        if avail item-mat and item-mat.log-1 = yes /*item GenÇrico*/ and item.tipo-contr = 4 /* dÇbito direto */ then do:
            /* busca descriá∆o da ordem-compra */
            if avail ordem-compra then
                assign pc-descricao = substring(ordem-compra.narrativa,1,60).
            else
                assign pc-descricao = item.desc-item.
        end.
        else
          assign pc-descricao = item.desc-item.
    end.

    return "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaGeracaoAutomaticaPedido DBOProgram 
PROCEDURE verificaGeracaoAutomaticaPedido :
/*------------------------------------------------------------------------------
  Purpose: Verifica se o m¢dulo de multiplanta est† implantado, se estiver o
           c¢digo do estabelecimento ficar† dispon°vel para alteraá‰es na 
           geraá∆o autom†tica de pedidos.

  Parameters:  ipar1 : lHabilitaEstabel : indica se o campo estabelecimento 
                                          ficar† dispon°vel.
  Notes:
------------------------------------------------------------------------------*/
    DEF OUTPUT PARAM lHabilitaEstabel AS LOG NO-UNDO.

     &if  DEFINED(bf_mat_contratos) &then
          FOR FIRST param-global FIELDS(modulo-mp) NO-LOCK: END.
          ASSIGN lHabilitaEstabel = param-global.modulo-mp.
      &else
          ASSIGN lHabilitaEstabel = NO.
      &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

