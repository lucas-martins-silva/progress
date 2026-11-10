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
{include/i-prgvrs.i BOIN311 2.00.01.031 } /*** "010131" 27/05/2025 14:43:41 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin311 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName pl-it-prod
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName pl-it-prod
&GLOBAL-DEFINE TableLabel pl-it-prod
&GLOBAL-DEFINE QueryName qr{&TableName}

&GLOBAL-DEFINE KeyField1  cd-plano    /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
&GLOBAL-DEFINE KeyField2  cod-estabel
&GLOBAL-DEFINE KeyField3  it-codigo
&GLOBAL-DEFINE KeyField4  cod-refer
&GLOBAL-DEFINE KeyField5  ano
&GLOBAL-DEFINE KeyField6  periodo 
&GLOBAL-DEFINE KeyField7  nome-abrev 
&GLOBAL-DEFINE KeyField8  nr-pedcli 
&GLOBAL-DEFINE KeyField9  nr-sequencia 
&GLOBAL-DEFINE KeyField10 cod-gr-cli 

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES
/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin311.i RowObject}
{java/boRest.i}

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/* variÿveis usadas nos setconstraints e open-query */

def var i-cd-plano like pl-it-prod.cd-plano no-undo.

/**** Variÿveis utilizadas na setConstraintAdvancedSearch ****/
def var c-it-codigo-ini   like pl-it-prod.it-codigo   no-undo.
def var c-it-codigo-fin   like pl-it-prod.it-codigo   no-undo.
def var i-cod-gr-cli-ini  like pl-it-prod.cod-gr-cli  no-undo.
def var i-cod-gr-cli-fin  like pl-it-prod.cod-gr-cli  no-undo.
def var c-cod-estabel-ini like pl-it-prod.cod-estabel no-undo.
def var c-cod-estabel-fin like pl-it-prod.cod-estabel no-undo.

/**** Variÿveis utilizadas na setConstraint2 ****/
define variable pos1         as integer               no-undo.
define variable pos2         as integer               no-undo.
define variable v-ano1       as integer format "9999" no-undo.
define variable v-ano2       as integer format "9999" no-undo.
define variable v-periodo1   as integer format ">>9"  no-undo.
define variable v-periodo2   as integer format ">>9"  no-undo.
DEFINE NEW GLOBAL SHARED var dData as date NO-UNDO.
DEF TEMP-TABLE tt-pl-it-prod-aux NO-UNDO
    FIELD cd-plano     LIKE pl-it-prod.cd-plano 
    FIELD it-codigo    LIKE pl-it-prod.it-codigo
    FIELD cod-estabel  LIKE pl-it-prod.cod-estabel
    FIELD cod-refer    LIKE pl-it-prod.cod-refer
    FIELD ano          LIKE pl-it-prod.ano
    FIELD periodo      LIKE pl-it-prod.periodo
    FIELD nome-abrev   LIKE pl-it-prod.nome-abrev
    FIELD nr-pedcli    LIKE pl-it-prod.nr-pedcli
    FIELD nr-sequencia LIKE pl-it-prod.nr-sequencia
    FIELD cod-gr-cli   LIKE pl-it-prod.cod-gr-cli
    INDEX unico IS PRIMARY 
          cd-plano
          it-codigo
          cod-estabel
          cod-refer
          ano
          periodo
          nome-abrev
          nr-pedcli
          nr-sequencia
          cod-gr-cli.

def temp-table tt-planilha NO-UNDO
    field it-codigo    like item.it-codigo
    field un           like item.un
    field quant        as decimal format ">>,>>>,>>>,>>9.99" extent 50 label "":U
    field itens        as integer extent 50 initial 0
    field elim         as logical initial no
    field cod-refer    like pl-it-prod.cod-refer
    field nome-abrev   like pl-it-prod.nome-abrev
    field nr-pedcli    like pl-it-prod.nr-pedcli
    field nr-sequencia like pl-it-prod.nr-sequencia
    field cod-gr-cli   like pl-it-prod.cod-gr-cli
    field iAcao        as int initial 0 /*** 1- cria, 2 - modifica, 3 - copia, 4 - elimina ****/
    index id is primary it-codigo
    index cd-ref it-codigo cod-refer.

def temp-table tt-coluna NO-UNDO
    field ano       as integer
    field periodo   as integer
    field nr-coluna as integer
    index codigo is primary unique ano periodo
    index coluna nr-coluna.

def temp-table tt-valores NO-UNDO
    field c-periodo-ano  as char format "999/9999"   extent 50
    field c-ano-periodo  as char format "9999999"    extent 50
    field da-dt-termino  as date format "99/99/9999" extent 50
    field c-ano-grava    as char format "9999999"    extent 50.

def temp-table tt2-pl-it-prod NO-UNDO LIKE pl-it-prod 
    field rw-periodo  as rowid
    field qt-anterior as decimal
    field dt-anterior as date
    index codigo ano periodo dt-termino.
    
def temp-table tt-before NO-UNDO LIKE RowObject.
    
def new global shared var gr-pl-it-prod as rowid no-undo.
def buffer b-pl-it-prod for pl-it-prod.
def buffer bfped-item for ped-item.
def buffer bfped-venda for ped-venda.

def var h-boin172      as handle  no-undo.
def var h-boin375      as handle  no-undo.
def var h-boin299      as handle  no-undo.
def var h-boin318      as handle  no-undo.
def var h-boin684      as handle  no-undo.
def var h-boad098      as handle  no-undo.
def var h-boad107      as handle  no-undo.
def var h-boad129      as handle  no-undo.
def var i-contr-plan   as int     no-undo.
def var i-tipo-con-est as int     no-undo.
def var i-compr-fabric as int     no-undo.
def var i-cod-obsoleto as int     no-undo.
def var i-demanda      as int     no-undo.
def var i-tipo-contr   as int     no-undo.
def var i-cod-gr-cli   as int     no-undo.
def var i-cd-tipo      as int     no-undo.
def var i-ano-ini      as int     no-undo.
def var i-per-ini      as int     no-undo.
def var i-ano-fim      as int     no-undo.
def var i-per-fim      as int     no-undo.
def var i-nr-sequencia as int     no-undo.
def var c-return       as char    no-undo.
def var l-modulo       as log     no-undo.
def var l-erro-periodo as log     no-undo.
def var c-cod-refer    as char    no-undo.
def var c-nr-pedcli    as char    no-undo.
def var l-multi-estabel as log    no-undo.
def var c-cod-estabel  as char    no-undo.

def buffer b-RowObject for RowObject.

{cdp/cdcfgman.i}

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
         HEIGHT             = 17.83
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignQuantItem DBOProgram 
PROCEDURE assignQuantItem :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza a quantidade do item do plano
  Parameters:  input = quantidade nova.
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param p-quant like RowObject.quantidade no-undo.
    
    
    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.
            
    assign RowObject.quantidade = p-quant.      
    
    find first pl-it-prod
         where rowid(pl-it-prod) = RowObject.r-rowid exclusive-lock no-error.
    if avail pl-it-prod then
       assign pl-it-prod.quantidade = p-quant.
       
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarRegistro DBOProgram 
PROCEDURE atualizarRegistro :
/*------------------------------------------------------------------------------
  Purpose:     Atualizar os Itens do Plano 
  Parameters:  Input/Output = temp-table para pl-it-prod.
  Notes:       
------------------------------------------------------------------------------*/
    def input-output param table for tt2-pl-it-prod.

    for each tt2-pl-it-prod no-lock,
        each b-pl-it-prod where rowid(b-pl-it-prod) = tt2-pl-it-prod.rw-periodo:

        if tt2-pl-it-prod.quantidade = 0 then do:
           delete b-pl-it-prod.
           delete tt2-pl-it-prod.           
        end.
        else       
            assign b-pl-it-prod.quantidade = tt2-pl-it-prod.quantidade
                   b-pl-it-prod.dt-termino = tt2-pl-it-prod.dt-termino.
    end.

    for each tt2-pl-it-prod no-lock where 
             tt2-pl-it-prod.rw-periodo = ?:
        if  tt2-pl-it-prod.quantidade > 0 then do:
            create b-pl-it-prod.
            buffer-copy tt2-pl-it-prod to b-pl-it-prod.
            
            assign tt2-pl-it-prod.rw-periodo = rowid(b-pl-it-prod).
        end.
        else delete tt2-pl-it-prod.
    end.

    find first tt2-pl-it-prod no-lock no-error.
    if avail tt2-pl-it-prod then
    find first b-pl-it-prod where rowid(b-pl-it-prod) = tt2-pl-it-prod.rw-periodo no-lock no-error.
  
   if avail b-pl-it-prod then 
       run goToKeyRowid in this-procedure (input rowid(b-pl-it-prod)).

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarTransferencia DBOProgram 
PROCEDURE atualizarTransferencia :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para fazer transferˆncia de quantidades de itens
               entre um per¡odo e outro
  Parameters:  Release anterior 2.03= i/o = temp-table antes da transferˆncia
               i - rowid do registro anterior que foi alterado
               i - c¢digo do plano
               i - ano
               i - per¡odo
               i - nome cliente
               i - n£mero pedido
               i - sequencia
               i - grupo de cliente
               i - data de t‚rmino
               i - quantidade destino
               Releases 2.03 em diante = todos os par³metros acima mais o c¢digo
               do estabelecimento
  Notes:       
------------------------------------------------------------------------------*/
  
    def input-output param table for tt-before.
    def input param r-before as rowid.
    def input param p-cd-plano as integer.
    def input param p-estabel  as char.
    def input param p-ano      as int.
    def input param p-periodo  as int.
    def input param p-nome-abrev as char.
    def input param p-nr-pedcli  as char.
    def input param p-sequencia  as int.
    def input param p-cod-gr-cli as int.
    def input param p-dt-trans   as date.
    def input param p-quant-dest as dec.

    find first tt-before
         where tt-before.r-rowid = r-before exclusive-lock no-error.

    find b-pl-it-prod use-index codigo where
         b-pl-it-prod.cd-plano     = p-cd-plano and
         b-pl-it-prod.cod-estabel  = p-estabel  and
         b-pl-it-prod.it-codigo    = tt-before.it-codigo and
         b-pl-it-prod.cod-refer    = tt-before.cod-refer and
         b-pl-it-prod.ano          = p-ano and
         b-pl-it-prod.periodo      = p-periodo and
         b-pl-it-prod.nome-abrev   = p-nome-abrev and
         b-pl-it-prod.nr-pedcli    = p-nr-pedcli and
         b-pl-it-prod.nr-sequencia = p-sequencia and
         b-pl-it-prod.cod-gr-cli   = p-cod-gr-cli
         exclusive-lock no-error.
  
    if  not avail b-pl-it-prod then do:
        create b-pl-it-prod.
        assign b-pl-it-prod.cd-plano     = p-cd-plano
               b-pl-it-prod.cod-estabel  = p-estabel
               b-pl-it-prod.ano          = p-ano
               b-pl-it-prod.periodo      = p-periodo
               b-pl-it-prod.dt-termino   = p-dt-trans
               b-pl-it-prod.it-codigo    = tt-before.it-codigo
               b-pl-it-prod.cod-refer    = tt-before.cod-refer
               b-pl-it-prod.nome-abrev   = p-nome-abrev
               b-pl-it-prod.nr-pedcli    = p-nr-pedcli
               b-pl-it-prod.nr-sequencia = p-sequencia
               b-pl-it-prod.cod-gr-cli   = p-cod-gr-cli
               b-pl-it-prod.quantidade   = 0.
    end.
  
    assign b-pl-it-prod.quantidade = b-pl-it-prod.quantidade + p-quant-dest
           tt-before.quantidade    = tt-before.quantidade    - p-quant-dest.
    
    find first pl-it-prod
        where rowid(pl-it-prod) = tt-before.r-rowid exclusive-lock no-error.
    if  avail pl-it-prod then
        assign pl-it-prod.quantidade = tt-before.quantidade.
  
    find first RowObject
         where RowObject.r-rowid = tt-before.r-rowid exclusive-lock no-error.
    if  avail RowObject then
        assign RowObject.quantidade = tt-before.quantidade.
     
    RETURN "OK":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItemPlano DBOProgram 
PROCEDURE createItemPlano :
/*------------------------------------------------------------------------------
  Purpose:     Cria um novo registro de item do plano
  Parameters:  input = tt-planilha, c¢digo do plano, ano, per¡odo, data de t‚rmino, quantidade
               output = rowid do novo registro
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param table for tt-planilha.
    def input param p-it-codigo as char.
    def input param p-cod-refer as char.
    def input param p-cd-plano  as int.
    def input param p-ano       as int.
    def input param p-periodo   as int.
    def input param p-termino   as date.
    def input param p-quant     as decimal.
    def input param p-cod-estabel as char.
    def output param p-rowid    as rowid.

    find first tt-planilha use-index cd-ref
         where tt-planilha.it-codigo = p-it-codigo
         and   tt-planilha.cod-refer = p-cod-refer no-lock no-error.   
    
    for FIRST pl-it-prod  fields (cd-plano cod-estabel it-codigo cod-refer 
                                    ano periodo nome-abrev nr-pedcli nr-sequencia cod-gr-cli  dt-termino quantidade ) use-index codigo 
               where pl-it-prod.cd-plano     = p-cd-plano         AND
               pl-it-prod.cod-estabel  = p-cod-estabel            AND
               pl-it-prod.it-codigo    = tt-planilha.it-codigo    AND
               pl-it-prod.cod-refer    = tt-planilha.cod-refer    AND
               pl-it-prod.ano          = p-ano                    AND
               pl-it-prod.periodo      = p-periodo                AND
               pl-it-prod.nome-abrev   = tt-planilha.nome-abrev   AND
               pl-it-prod.nr-pedcli    = tt-planilha.nr-pedcli    AND
               pl-it-prod.nr-sequencia = tt-planilha.nr-sequencia AND
               pl-it-prod.cod-gr-cli   = tt-planilha.cod-gr-cli no-lock:
    end.

    if  not avail pl-it-prod then do: 
        create pl-it-prod.
        buffer-copy tt-planilha to pl-it-prod
        assign pl-it-prod.cd-plano    = p-cd-plano
               pl-it-prod.cod-estabel = p-cod-estabel
               pl-it-prod.ano         = p-ano
               pl-it-prod.periodo     = p-periodo
               pl-it-prod.dt-termino  = p-termino
               pl-it-prod.quantidade  = p-quant
               p-rowid                = rowid(pl-it-prod).

        create RowObject.
        buffer-copy pl-it-prod to RowObject
        assign RowObject.r-rowid = rowid(pl-it-prod).
    end.
    else assign p-rowid = rowid(pl-it-prod).

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteCurrentItem DBOProgram 
PROCEDURE deleteCurrentItem :
/*------------------------------------------------------------------------------
  Purpose:     Elimina o registro corrente
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    find first pl-it-prod
         where rowid(pl-it-prod) = RowObject.r-rowid exclusive-lock no-error.

    if avail pl-it-prod then 
       delete pl-it-prod.

    delete RowObject.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRowidItemPlano DBOProgram 
PROCEDURE deleteRowidItemPlano :
/*------------------------------------------------------------------------------
  Purpose:     Elimina o item do plano em fun‡Æo do rowid informado.
  Parameters:  input = rowid do item
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-rowid as rowid no-undo.
    find first RowObject
         where RowObject.r-rowid = p-rowid exclusive-lock no-error.
    if avail RowObject then
       delete RowObject.

    find first pl-it-prod
         where rowid(pl-it-prod) = p-rowid exclusive-lock no-error.
         
    if avail pl-it-prod then 
       delete pl-it-prod.

    else return "NOK":U.         
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminarTransferencia DBOProgram 
PROCEDURE eliminarTransferencia :
/*------------------------------------------------------------------------------
  Purpose:     Utilizado para eliminar o registro de Itens do Plano
               caso na transferˆncia tenha sido transferida toda a quantidade do registro e o
               mesmo ter ficado com quantidade zero.
  Parameters:  i - temp-table do registro transferido
               i - rowid do registro
  Notes:       
------------------------------------------------------------------------------*/
    def input param table for tt-before.
    def input param r-before as rowid.

    find first tt-before
         where tt-before.r-rowid = r-before no-lock no-error.
    find first pl-it-prod
         where rowid(pl-it-prod) = tt-before.r-rowid exclusive-lock no-error.
    if avail pl-it-prod then
       delete pl-it-prod.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Procura pelo ¡ndice, caso nÆo ache, retorna
                mensagem de erro padrÆo do  EMS
  Parameters: ipar1:i-cd-plano: Plano
              ipar2:c-it-codigo:   Item
              ipar3:c-cod-refer:   Referˆncia
              ipar4:i-ano:         Ano
              ipar5:i-periodo:     Per¡odo
              ipar6:c-nome-abrev:  Nome Abreviado
              ipar7:c-nr-pedcli:   Pedido Cliente
              ipar8:i-nr-sequencia:Sequˆncia
              ipar9:i-cod-gr-cli:  Grupo Cliente
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter i-cd-plano as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def input parameter c-cod-refer as char no-undo.
    def input parameter i-ano as inte no-undo.
    def input parameter i-periodo as inte no-undo.
    def input parameter c-nome-abrev as char no-undo.
    def input parameter c-nr-pedcli as char no-undo.
    def input parameter i-nr-sequencia as inte no-undo.
    def input parameter i-cod-gr-cli as inte no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToKey (input i-cd-plano,
                 input c-it-codigo,
                 input c-cod-refer,
                 input i-ano,
                 input i-periodo,
                 input c-nome-abrev,
                 input c-nr-pedcli,
                 input i-nr-sequencia,
                 input i-cod-gr-cli).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i mgind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findParamGlobal DBOProgram 
PROCEDURE findParamGlobal :
/*------------------------------------------------------------------------------
  Purpose:     Procura os Par³metros Globais e Retorna o M¢dulo 
  Parameters:  Recebe o m¢dulo solicitado
               Retorna valor se o m¢dulo estÿ implantado ou nÆo
  Notes:       
------------------------------------------------------------------------------*/

def input  param c-modulo  as char.
def output param l-implant as logical.

find first param-global no-lock no-error.
if avail param-global then 
   if c-modulo = "modulo-pd":U then 
      assign l-implant = param-global.modulo-pd.
else return "NOK":U.

RETURN "OK":U.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPedItem DBOProgram 
PROCEDURE findPedItem :
/*------------------------------------------------------------------------------
  Purpose: Este procedimento tem por objetivo localizar o ped-item e retornar
           un "OK" caso encontre ou "NOK" caso nÆo encontre.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev     LIKE ped-item.nome-abrev   NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli      LIKE ped-item.nr-pedcli    NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia   LIKE ped-item.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo      LIKE ped-item.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer      LIKE ped-item.cod-refer    NO-UNDO.

    FIND FIRST bfped-item WHERE 
               bfped-item.nome-abrev   = pnome-abrev   AND 
               bfped-item.nr-pedcli    = pnr-pedcli    AND 
               bfped-item.nr-sequencia = pnr-sequencia AND 
               bfped-item.it-codigo    = pit-codigo    AND 
               bfped-item.cod-refer    = pcod-refer NO-LOCK NO-ERROR.
    if avail bfped-item then
       RETURN "OK".
    else
       RETURN "NOK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPedVenda DBOProgram 
PROCEDURE findPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ðndice ch-pedido
  Parameters:  recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnome-abrev LIKE ped-venda.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli  LIKE ped-venda.nr-pedcli NO-UNDO.

    FIND FIRST bfped-venda WHERE 
        bfped-venda.nome-abrev = pnome-abrev AND 
        bfped-venda.nr-pedcli  = pnr-pedcli NO-LOCK NO-ERROR.
    if avail bfped-venda then
        RETURN "OK":U.
    else
        RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarBrowsePeriodo DBOProgram 
PROCEDURE gerarBrowsePeriodo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  i - rowid do registro atual
               i - referˆncia do registro atual
               i/o - temp-table .
  Notes:       
------------------------------------------------------------------------------*/

define input parameter p-cd-plano    as integer   no-undo.
define input parameter p-cod-estabel as character no-undo.
define input parameter p-it-codigo   as character no-undo.
define input parameter p-cod-refer   as character no-undo.
define input-output parameter table for tt2-pl-it-prod.


define variable c-cod-estabel-ini as character init "" no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
define variable c-cod-estabel-fim as character init "ZZZZZ" no-undo.
&ELSE
define variable c-cod-estabel-fim as character init "ZZZ" no-undo.
&ENDIF

if p-cod-estabel <> "" then
   assign c-cod-estabel-ini = p-cod-estabel
          c-cod-estabel-fim = p-cod-estabel.

for each tt2-pl-it-prod:
    delete tt2-pl-it-prod.
end.

find first pl-prod where pl-prod.cd-plano = p-cd-plano no-lock no-error.
if avail pl-prod then do:

   if p-cod-estabel = "" and pl-prod.log-multi-estabel then do:
      
       for each b-pl-it-prod 
          where b-pl-it-prod.cd-plano  = pl-prod.cd-plano
            
           and b-pl-it-prod.cod-estabel >= c-cod-estabel-ini
           and b-pl-it-prod.cod-estabel <= c-cod-estabel-fim
           and   b-pl-it-prod.it-codigo = p-it-codigo
           and   b-pl-it-prod.cod-refer = p-cod-refer no-lock:
     
             create tt2-pl-it-prod.
             buffer-copy b-pl-it-prod to tt2-pl-it-prod
             assign tt2-pl-it-prod.rw-periodo  = rowid(b-pl-it-prod)
                    tt2-pl-it-prod.qt-anterior = b-pl-it-prod.quantidade
                    tt2-pl-it-prod.dt-anterior = b-pl-it-prod.dt-termino.
       end.
    
    end.
    else do:

       for each b-pl-it-prod 
          where b-pl-it-prod.cd-plano  = pl-prod.cd-plano
            and b-pl-it-prod.cod-estabel = p-cod-estabel
            and b-pl-it-prod.it-codigo = p-it-codigo
            and b-pl-it-prod.cod-refer = p-cod-refer no-lock:
     
             create tt2-pl-it-prod.
             buffer-copy b-pl-it-prod to tt2-pl-it-prod
             assign tt2-pl-it-prod.rw-periodo  = rowid(b-pl-it-prod)
                    tt2-pl-it-prod.qt-anterior = b-pl-it-prod.quantidade
                    tt2-pl-it-prod.dt-anterior = b-pl-it-prod.dt-termino.
       end.
    
    end.     
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarColuna DBOProgram 
PROCEDURE gerarColuna :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  input: tipo per¡odo, ano inicial, ano final, per¡odo inicial, per¡odo final, flag
               output: per¡odo, ano, ano e per¡odo, data de termino, tt-coluna
  Notes:       
------------------------------------------------------------------------------*/
  def input param i-cd-tipo       as int.
  def input param i-ano-i         as int.
  def input param i-ano-f         as int.
  def input param i-periodo-i     as int.
  def input param i-periodo-f     as int.
  def input param i-flag          as int.
  def output param i-nr-periodo   as int.
  def output param table   for tt-coluna.
  def output param table   for tt-valores.
  
  def var i-cont-per   as int no-undo.

  &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
          EMPTY TEMP-TABLE tt-valores. 
          EMPTY TEMP-TABLE tt-coluna.  
    &ELSE
          for each tt-valores  exclusive: delete tt-valores.   end.
          for each tt-coluna   exclusive: delete tt-coluna.    end.
    &ENDIF

  
  create tt-valores.
    
  assign i-nr-periodo = 0.

  do  i-cont-per = 1 to 50:
      assign tt-valores.c-periodo-ano[i-cont-per] = ""
             tt-valores.c-ano-periodo[i-cont-per] = "".
  end.

  periodo:
  for each periodo fields (cd-tipo   ano   nr-periodo   dt-inicio   dt-termino) use-index codigo
      where periodo.cd-tipo = i-cd-tipo no-lock:
        if periodo.ano    < i-ano-i
        or periodo.ano    > i-ano-f then next. 
      
      if periodo.ano * 1000 + periodo.nr-periodo < i-ano-i * 1000 + i-periodo-i or
         periodo.ano * 1000 + periodo.nr-periodo > i-ano-f * 1000 + i-periodo-f then next.

      assign i-nr-periodo = i-nr-periodo + 1.

      if  i-nr-periodo > 50 then do:
          assign i-nr-periodo = 50.
          leave periodo.
      end.

      find first tt-coluna
           where tt-coluna.nr-coluna = i-nr-periodo no-error.
      if avail tt-coluna then 
          next.
      
      create tt-coluna.
      assign tt-coluna.ano       = periodo.ano
             tt-coluna.periodo   = periodo.nr-periodo
             tt-coluna.nr-coluna = i-nr-periodo.
             
      case i-flag:
           when 1 then do:       
                assign tt-valores.c-periodo-ano[i-nr-periodo] = string(periodo.dt-inicio,"99/99/9999")
                       tt-valores.c-ano-periodo[i-nr-periodo] = string(periodo.dt-inicio,"99/99/9999")
                       tt-valores.c-ano-grava[i-nr-periodo]   = string(periodo.ano,"9999") + 
                                                                string(periodo.nr-periodo,"999")
                       tt-valores.da-dt-termino[i-nr-periodo] = periodo.dt-termino.
           end.
           when 2 then do:
                assign tt-valores.c-periodo-ano[i-nr-periodo] = string(periodo.nr-periodo,"999") + "/" + 
                                                                string(periodo.ano,"9999")
                       tt-valores.c-ano-periodo[i-nr-periodo] = string(periodo.ano,"9999") + 
                                                                string(periodo.nr-periodo,"999")
                       tt-valores.da-dt-termino[i-nr-periodo] = periodo.dt-termino
                       tt-valores.c-ano-grava[i-nr-periodo]   = string(periodo.ano,"9999") + 
                                                                string(periodo.nr-periodo,"999").
           end.
      end.
  end.
  
  if i-nr-periodo = 0 then
     delete tt-valores.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarItensPlano DBOProgram 
PROCEDURE gerarItensPlano :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  output temp-table RowObject.
  Notes:       
------------------------------------------------------------------------------*/
def output param table for RowObject.

EMPTY TEMP-TABLE rowobject.
EMPTY TEMP-TABLE tt-pl-it-prod-aux.

DEF VAR cont-reg AS INT.
/*                       */
/* for each RowObject:   */
/*     delete RowObject. */
/* end.                  */

for each  bfpl-it-prod no-lock
    where bfpl-it-prod.cd-plano = i-cd-plano
    BREAK BY bfpl-it-prod.cd-plano
          BY bfpl-it-prod.cod-estabel
          BY bfpl-it-prod.it-codigo
          BY bfpl-it-prod.cod-refer
          BY bfpl-it-prod.ano
          BY bfpl-it-prod.periodo :

    IF FIRST-OF(bfpl-it-prod.it-codigo) THEN
       ASSIGN cont-reg = cont-reg + 1.

    IF cont-reg > 40 THEN LEAVE.
    
    IF FIRST-OF(bfpl-it-prod.cd-plano) OR
       FIRST-OF(bfpl-it-prod.cod-estabel) OR
       FIRST-OF(bfpl-it-prod.it-codigo) OR
       FIRST-OF(bfpl-it-prod.cod-refer) OR
       FIRST-OF(bfpl-it-prod.ano) OR
       FIRST-OF(bfpl-it-prod.periodo) THEN DO:

       create RowObject.
       ASSIGN rowobject.ano         = bfpl-it-prod.ano
              rowobject.cd-plano    = bfpl-it-prod.cd-plano
              rowobject.char-1      = bfpl-it-prod.char-1
              rowobject.char-2      = bfpl-it-prod.char-2
              rowobject.check-sum   = bfpl-it-prod.check-sum
              rowobject.cod-estabel = bfpl-it-prod.cod-estabel
              rowobject.cod-gr-cli  = bfpl-it-prod.cod-gr-cli
              rowobject.cod-refer   = bfpl-it-prod.cod-refer
              rowobject.data-1      = bfpl-it-prod.data-1
              rowobject.data-2      = bfpl-it-prod.data-2
              rowobject.dec-1       = bfpl-it-prod.dec-1
              rowobject.dec-2       = bfpl-it-prod.dec-2
              rowobject.dt-termino  = bfpl-it-prod.dt-termino
              rowobject.int-1       = bfpl-it-prod.int-1
              rowobject.int-2       = bfpl-it-prod.int-2
              rowobject.it-codigo   = bfpl-it-prod.it-codigo
              rowobject.log-1       = bfpl-it-prod.log-1
              rowobject.log-2       = bfpl-it-prod.log-2
              rowobject.nome-abrev  = bfpl-it-prod.nome-abrev
              rowobject.nr-entrega  = bfpl-it-prod.nr-entrega
              rowobject.nr-estrut   = bfpl-it-prod.nr-estrut
              rowobject.nr-pedcli   = bfpl-it-prod.nr-pedcli
              rowobject.nr-sequencia = bfpl-it-prod.nr-sequencia
              rowobject.origem      = bfpl-it-prod.origem
              rowobject.periodo     = bfpl-it-prod.periodo
              rowobject.qt-confirm  = bfpl-it-prod.qt-confirm
              rowobject.quantidade  = bfpl-it-prod.quantidade
              RowObject.r-rowid = rowid(bfpl-it-prod).

       create tt-pl-it-prod-aux.
       ASSIGN tt-pl-it-prod-aux.cd-plano     = bfpl-it-prod.cd-plano
              tt-pl-it-prod-aux.it-codigo    = bfpl-it-prod.it-codigo
              tt-pl-it-prod-aux.cod-estabel  = bfpl-it-prod.cod-estabel
              tt-pl-it-prod-aux.cod-refer    = bfpl-it-prod.cod-refer
              tt-pl-it-prod-aux.ano          = bfpl-it-prod.ano
              tt-pl-it-prod-aux.periodo      = bfpl-it-prod.periodo
              tt-pl-it-prod-aux.nome-abrev   = bfpl-it-prod.nome-abrev
              tt-pl-it-prod-aux.nr-pedcli    = bfpl-it-prod.nr-pedcli
              tt-pl-it-prod-aux.nr-sequencia = bfpl-it-prod.nr-sequencia
              tt-pl-it-prod-aux.cod-gr-cli   = bfpl-it-prod.cod-gr-cli.

    END.
    ELSE
    IF NOT CAN-find(FIRST tt-pl-it-prod-aux USE-INDEX unico WHERE
        tt-pl-it-prod-aux.cd-plano     = bfpl-it-prod.cd-plano  AND
        tt-pl-it-prod-aux.it-codigo    = bfpl-it-prod.it-codigo AND
        tt-pl-it-prod-aux.cod-estabel  = bfpl-it-prod.cod-estabel AND
        tt-pl-it-prod-aux.cod-refer    = bfpl-it-prod.cod-refer AND
        tt-pl-it-prod-aux.ano          = bfpl-it-prod.ano       AND
        tt-pl-it-prod-aux.periodo      = bfpl-it-prod.periodo   AND
        tt-pl-it-prod-aux.nome-abrev   = bfpl-it-prod.nome-abrev AND
        tt-pl-it-prod-aux.nr-pedcli    = bfpl-it-prod.nr-pedcli  AND
        tt-pl-it-prod-aux.nr-sequencia = bfpl-it-prod.nr-sequencia AND
        tt-pl-it-prod-aux.cod-gr-cli   = bfpl-it-prod.cod-gr-cli) THEN DO:

        create RowObject.
        ASSIGN rowobject.ano         = bfpl-it-prod.ano
              rowobject.cd-plano    = bfpl-it-prod.cd-plano
              rowobject.char-1      = bfpl-it-prod.char-1
              rowobject.char-2      = bfpl-it-prod.char-2
              rowobject.check-sum   = bfpl-it-prod.check-sum
              rowobject.cod-estabel = bfpl-it-prod.cod-estabel
              rowobject.cod-gr-cli  = bfpl-it-prod.cod-gr-cli
              rowobject.cod-refer   = bfpl-it-prod.cod-refer
              rowobject.data-1      = bfpl-it-prod.data-1
              rowobject.data-2      = bfpl-it-prod.data-2
              rowobject.dec-1       = bfpl-it-prod.dec-1
              rowobject.dec-2       = bfpl-it-prod.dec-2
              rowobject.dt-termino  = bfpl-it-prod.dt-termino
              rowobject.int-1       = bfpl-it-prod.int-1
              rowobject.int-2       = bfpl-it-prod.int-2
              rowobject.it-codigo   = bfpl-it-prod.it-codigo
              rowobject.log-1       = bfpl-it-prod.log-1
              rowobject.log-2       = bfpl-it-prod.log-2
              rowobject.nome-abrev  = bfpl-it-prod.nome-abrev
              rowobject.nr-entrega  = bfpl-it-prod.nr-entrega
              rowobject.nr-estrut   = bfpl-it-prod.nr-estrut
              rowobject.nr-pedcli   = bfpl-it-prod.nr-pedcli
              rowobject.nr-sequencia = bfpl-it-prod.nr-sequencia
              rowobject.origem      = bfpl-it-prod.origem
              rowobject.periodo     = bfpl-it-prod.periodo
              rowobject.qt-confirm  = bfpl-it-prod.qt-confirm
              rowobject.quantidade  = bfpl-it-prod.quantidade
              RowObject.r-rowid = rowid(bfpl-it-prod).
        create tt-pl-it-prod-aux.
        ASSIGN tt-pl-it-prod-aux.cd-plano     = bfpl-it-prod.cd-plano
               tt-pl-it-prod-aux.it-codigo    = bfpl-it-prod.it-codigo
               tt-pl-it-prod-aux.cod-estabel  = bfpl-it-prod.cod-estabel
               tt-pl-it-prod-aux.cod-refer    = bfpl-it-prod.cod-refer
               tt-pl-it-prod-aux.ano          = bfpl-it-prod.ano
               tt-pl-it-prod-aux.periodo      = bfpl-it-prod.periodo
               tt-pl-it-prod-aux.nome-abrev   = bfpl-it-prod.nome-abrev
               tt-pl-it-prod-aux.nr-pedcli    = bfpl-it-prod.nr-pedcli
               tt-pl-it-prod-aux.nr-sequencia = bfpl-it-prod.nr-sequencia
               tt-pl-it-prod-aux.cod-gr-cli   = bfpl-it-prod.cod-gr-cli.

    end.
end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarItensPlano-menos40 DBOProgram 
PROCEDURE gerarItensPlano-menos40 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  output temp-table RowObject.
  Notes:       
------------------------------------------------------------------------------*/

def output param table for RowObject.
def input param c-it-codigo   like item.it-codigo         no-undo.
def input param c-cod-estabel like pl-it-prod.cod-estabel no-undo.
def input param c-cod-refer   like pl-it-prod.cod-refer   no-undo.

def var cont-reg as int  no-undo.
def var c-it-aux as char no-undo.

EMPTY TEMP-TABLE rowobject.
EMPTY TEMP-TABLE tt-pl-it-prod-aux.

/*                       */
/* for each RowObject:   */
/*     delete RowObject. */
/* end.                  */

ASSIGN cont-reg = 0.


find last bfpl-it-prod use-index codigo no-lock where
          bfpl-it-prod.cd-plano    = i-cd-plano    and
          bfpl-it-prod.it-codigo   = c-it-codigo   and
          bfpl-it-prod.cod-estabel = c-cod-estabel and
          bfpl-it-prod.cod-refer   = c-cod-refer no-error.

if avail bfpl-it-prod then
    assign c-it-aux = bfpl-it-prod.it-codigo
           cont-reg = 1.

do while avail bfpl-it-prod and cont-reg <= 40:

    if not can-find (first tt-pl-it-prod-aux use-index unico where
                           tt-pl-it-prod-aux.cd-plano     = bfpl-it-prod.cd-plano     and
                           tt-pl-it-prod-aux.it-codigo    = bfpl-it-prod.it-codigo    and
                           tt-pl-it-prod-aux.cod-estabel  = bfpl-it-prod.cod-estabel  and
                           tt-pl-it-prod-aux.cod-refer    = bfpl-it-prod.cod-refer    and
                           tt-pl-it-prod-aux.ano          = bfpl-it-prod.ano          and
                           tt-pl-it-prod-aux.periodo      = bfpl-it-prod.periodo      and
                           tt-pl-it-prod-aux.nome-abrev   = bfpl-it-prod.nome-abrev   and
                           tt-pl-it-prod-aux.nr-pedcli    = bfpl-it-prod.nr-pedcli    and
                           tt-pl-it-prod-aux.nr-sequencia = bfpl-it-prod.nr-sequencia AND
                           tt-pl-it-prod-aux.cod-gr-cli   = bfpl-it-prod.cod-gr-cli) then do:

        create RowObject.
        assign rowobject.ano          = bfpl-it-prod.ano
               rowobject.cd-plano     = bfpl-it-prod.cd-plano
               rowobject.char-1       = bfpl-it-prod.char-1
               rowobject.char-2       = bfpl-it-prod.char-2
               rowobject.check-sum    = bfpl-it-prod.check-sum
               rowobject.cod-estabel  = bfpl-it-prod.cod-estabel
               rowobject.cod-gr-cli   = bfpl-it-prod.cod-gr-cli
               rowobject.cod-refer    = bfpl-it-prod.cod-refer
               rowobject.data-1       = bfpl-it-prod.data-1
               rowobject.data-2       = bfpl-it-prod.data-2
               rowobject.dec-1        = bfpl-it-prod.dec-1
               rowobject.dec-2        = bfpl-it-prod.dec-2
               rowobject.dt-termino   = bfpl-it-prod.dt-termino
               rowobject.int-1        = bfpl-it-prod.int-1
               rowobject.int-2        = bfpl-it-prod.int-2
               rowobject.it-codigo    = bfpl-it-prod.it-codigo
               rowobject.log-1        = bfpl-it-prod.log-1
               rowobject.log-2        = bfpl-it-prod.log-2
               rowobject.nome-abrev   = bfpl-it-prod.nome-abrev
               rowobject.nr-entrega   = bfpl-it-prod.nr-entrega
               rowobject.nr-estrut    = bfpl-it-prod.nr-estrut
               rowobject.nr-pedcli    = bfpl-it-prod.nr-pedcli
               rowobject.nr-sequencia = bfpl-it-prod.nr-sequencia
               rowobject.origem       = bfpl-it-prod.origem
               rowobject.periodo      = bfpl-it-prod.periodo
               rowobject.qt-confirm   = bfpl-it-prod.qt-confirm
               rowobject.quantidade   = bfpl-it-prod.quantidade
               RowObject.r-rowid      = rowid(bfpl-it-prod).

        create tt-pl-it-prod-aux.
        assign tt-pl-it-prod-aux.cd-plano     = bfpl-it-prod.cd-plano
               tt-pl-it-prod-aux.it-codigo    = bfpl-it-prod.it-codigo
               tt-pl-it-prod-aux.cod-estabel  = bfpl-it-prod.cod-estabel
               tt-pl-it-prod-aux.cod-refer    = bfpl-it-prod.cod-refer
               tt-pl-it-prod-aux.ano          = bfpl-it-prod.ano
               tt-pl-it-prod-aux.periodo      = bfpl-it-prod.periodo
               tt-pl-it-prod-aux.nome-abrev   = bfpl-it-prod.nome-abrev
               tt-pl-it-prod-aux.nr-pedcli    = bfpl-it-prod.nr-pedcli
               tt-pl-it-prod-aux.nr-sequencia = bfpl-it-prod.nr-sequencia
               tt-pl-it-prod-aux.cod-gr-cli   = bfpl-it-prod.cod-gr-cli.

    end.
    
    find prev bfpl-it-prod use-index codigo no-lock where
              bfpl-it-prod.cd-plano = i-cd-plano no-error.
    if avail bfpl-it-prod and
       c-it-aux <> bfpl-it-prod.it-codigo then
        assign c-it-aux = bfpl-it-prod.it-codigo
               cont-reg = cont-reg + 1.

    

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarItensPlano-posicionar DBOProgram 
PROCEDURE gerarItensPlano-posicionar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  output temp-table RowObject.
  Notes:       
------------------------------------------------------------------------------*/

def output param table for RowObject.
def input param c-it-codigo   like item.it-codigo         no-undo.
def input param c-cod-estabel like pl-it-prod.cod-estabel no-undo.
def input param c-cod-refer   like pl-it-prod.cod-refer   no-undo.

def var cont-reg as int  no-undo.
def var c-it-aux as char no-undo.

EMPTY TEMP-TABLE rowobject.
EMPTY TEMP-TABLE tt-pl-it-prod-aux.


/*                       */
/* for each RowObject:   */
/*     delete RowObject. */
/* end.                  */

ASSIGN cont-reg = 0.

find first bfpl-it-prod use-index codigo no-lock where
           bfpl-it-prod.cd-plano     = i-cd-plano    and
           bfpl-it-prod.it-codigo   >= c-it-codigo   and
           bfpl-it-prod.cod-estabel >= c-cod-estabel and
           bfpl-it-prod.cod-refer   >= c-cod-refer no-error.

if avail bfpl-it-prod then
    assign c-it-aux = bfpl-it-prod.it-codigo
           cont-reg = 1.

do while avail bfpl-it-prod and cont-reg <= 40:

    if not can-find (first tt-pl-it-prod-aux use-index unico where
                           tt-pl-it-prod-aux.cd-plano     = bfpl-it-prod.cd-plano     and
                           tt-pl-it-prod-aux.it-codigo    = bfpl-it-prod.it-codigo    and
                           tt-pl-it-prod-aux.cod-estabel  = bfpl-it-prod.cod-estabel  and
                           tt-pl-it-prod-aux.cod-refer    = bfpl-it-prod.cod-refer    and
                           tt-pl-it-prod-aux.ano          = bfpl-it-prod.ano          and
                           tt-pl-it-prod-aux.periodo      = bfpl-it-prod.periodo      and
                           tt-pl-it-prod-aux.nome-abrev   = bfpl-it-prod.nome-abrev   and
                           tt-pl-it-prod-aux.nr-pedcli    = bfpl-it-prod.nr-pedcli    and
                           tt-pl-it-prod-aux.nr-sequencia = bfpl-it-prod.nr-sequencia AND
                           tt-pl-it-prod-aux.cod-gr-cli   = bfpl-it-prod.cod-gr-cli) then do:

        create RowObject.
        assign rowobject.ano          = bfpl-it-prod.ano
               rowobject.cd-plano     = bfpl-it-prod.cd-plano
               rowobject.char-1       = bfpl-it-prod.char-1
               rowobject.char-2       = bfpl-it-prod.char-2
               rowobject.check-sum    = bfpl-it-prod.check-sum
               rowobject.cod-estabel  = bfpl-it-prod.cod-estabel
               rowobject.cod-gr-cli   = bfpl-it-prod.cod-gr-cli
               rowobject.cod-refer    = bfpl-it-prod.cod-refer
               rowobject.data-1       = bfpl-it-prod.data-1
               rowobject.data-2       = bfpl-it-prod.data-2
               rowobject.dec-1        = bfpl-it-prod.dec-1
               rowobject.dec-2        = bfpl-it-prod.dec-2
               rowobject.dt-termino   = bfpl-it-prod.dt-termino
               rowobject.int-1        = bfpl-it-prod.int-1
               rowobject.int-2        = bfpl-it-prod.int-2
               rowobject.it-codigo    = bfpl-it-prod.it-codigo
               rowobject.log-1        = bfpl-it-prod.log-1
               rowobject.log-2        = bfpl-it-prod.log-2
               rowobject.nome-abrev   = bfpl-it-prod.nome-abrev
               rowobject.nr-entrega   = bfpl-it-prod.nr-entrega
               rowobject.nr-estrut    = bfpl-it-prod.nr-estrut
               rowobject.nr-pedcli    = bfpl-it-prod.nr-pedcli
               rowobject.nr-sequencia = bfpl-it-prod.nr-sequencia
               rowobject.origem       = bfpl-it-prod.origem
               rowobject.periodo      = bfpl-it-prod.periodo
               rowobject.qt-confirm   = bfpl-it-prod.qt-confirm
               rowobject.quantidade   = bfpl-it-prod.quantidade
               RowObject.r-rowid      = rowid(bfpl-it-prod).

        create tt-pl-it-prod-aux.
        assign tt-pl-it-prod-aux.cd-plano     = bfpl-it-prod.cd-plano
               tt-pl-it-prod-aux.it-codigo    = bfpl-it-prod.it-codigo
               tt-pl-it-prod-aux.cod-estabel  = bfpl-it-prod.cod-estabel
               tt-pl-it-prod-aux.cod-refer    = bfpl-it-prod.cod-refer
               tt-pl-it-prod-aux.ano          = bfpl-it-prod.ano
               tt-pl-it-prod-aux.periodo      = bfpl-it-prod.periodo
               tt-pl-it-prod-aux.nome-abrev   = bfpl-it-prod.nome-abrev
               tt-pl-it-prod-aux.nr-pedcli    = bfpl-it-prod.nr-pedcli
               tt-pl-it-prod-aux.nr-sequencia = bfpl-it-prod.nr-sequencia
               tt-pl-it-prod-aux.cod-gr-cli   = bfpl-it-prod.cod-gr-cli.

    end.
    
    find next bfpl-it-prod use-index codigo no-lock where
              bfpl-it-prod.cd-plano = i-cd-plano no-error.

    
    
    if avail bfpl-it-prod and
       c-it-aux <> bfpl-it-prod.it-codigo then
        assign c-it-aux = bfpl-it-prod.it-codigo
               cont-reg = cont-reg + 1.

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerarPlanilha DBOProgram 
PROCEDURE gerarPlanilha :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  i - tipo per¡odo
               i/o - tt-planilha
               i/o - tt-coluna
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-cd-tipo     as int no-undo.
    def input param i-ano-i       as int no-undo.
    def input param i-ano-f       as int no-undo.
    def input param i-periodo-i   as int no-undo.
    def input param i-periodo-f   as int no-undo.
    def input param c-it-codigo-i as char no-undo.
    def input param c-it-codigo-f as char no-undo.  
    
    def input param c-cod-refer-i as char no-undo.
    def input param c-cod-refer-f as char no-undo.
    
    def input param c-fm-codigo-i as char no-undo.
    def input param c-fm-codigo-f as char no-undo.
    def input param i-ge-codigo-i as int  no-undo.
    def input param i-ge-codigo-f as int  no-undo.
    def input param c-cd-planej-i as char no-undo.
    def input param c-cd-planej-f as char no-undo.
    def input-output param table  for tt-planilha.
    def input-output param table  for tt-coluna.
    def output       param table  for tt-valores.
    def output       param i-nr-periodo as int no-undo.
    def input param c-cod-estabel as char no-undo.
    def var i-cont-per     as integer format "999" no-undo.
    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 9 &THEN
          EMPTY TEMP-TABLE tt-planilha.
          EMPTY TEMP-TABLE tt-valores. 
          EMPTY TEMP-TABLE tt-coluna.  
    &ELSE
          for each tt-planilha exclusive: delete tt-planilha.  end.
          for each tt-valores  exclusive: delete tt-valores.   end.
          for each tt-coluna   exclusive: delete tt-coluna.    end.
    &ENDIF

      
    
  
    create tt-valores.
    
    assign i-nr-periodo = 0.

    do  i-cont-per = 1 to 50:
        assign tt-valores.c-periodo-ano[i-cont-per] = ""
               tt-valores.c-ano-periodo[i-cont-per] = "".
    end.

    periodo:
    for each periodo fields (cd-tipo   ano   nr-periodo   dt-inicio   dt-termino) use-index codigo
        where periodo.cd-tipo        = i-cd-tipo  no-lock:

        if periodo.ano           < i-ano-i
           or periodo.ano           > i-ano-f  then next.

        if periodo.ano * 1000 + periodo.nr-periodo < i-ano-i * 1000 + i-periodo-i
           or periodo.ano * 1000 + periodo.nr-periodo > i-ano-f * 1000 + i-periodo-f then next.

        assign i-nr-periodo                           = i-nr-periodo + 1.
        create tt-coluna.
        assign tt-coluna.ano                          = periodo.ano
               tt-coluna.periodo                      = periodo.nr-periodo
               tt-coluna.nr-coluna                    = i-nr-periodo
               tt-valores.c-periodo-ano[i-nr-periodo] = string(periodo.nr-periodo,"999") + "/" + string(periodo.ano,"9999")
               tt-valores.c-ano-periodo[i-nr-periodo] = string(periodo.ano,"9999") + string(periodo.nr-periodo,"999")
               tt-valores.da-dt-termino[i-nr-periodo] = periodo.dt-termino
               tt-valores.c-ano-grava[i-nr-periodo]   = string(periodo.ano,"9999") + string(periodo.nr-periodo,"999").

       /************* T¡tulo data inicial ***************
        assign tt-valores.c-periodo-ano[i-nr-periodo] = string(periodo.dt-inicio)
               tt-valores.c-ano-periodo[i-nr-periodo] = string(periodo.dt-inicio)
               tt-valores.da-dt-termino[i-nr-periodo] = periodo.dt-termino.
       **************************************************/
  
        if  i-nr-periodo + 1 > 50 then leave periodo. 
    end.

    for each  pl-it-prod fields (it-codigo   cod-refer ano   periodo   quantidade
                                 nome-abrev  nr-pedcli   nr-sequencia dt-termino
                                 cod-gr-cli) use-index ch-item
        where pl-it-prod.cd-plano     = i-cd-plano
          and pl-it-prod.it-codigo   >= c-it-codigo-i
          and pl-it-prod.it-codigo   <= c-it-codigo-f
          and pl-it-prod.cod-refer   >= c-cod-refer-i
          and pl-it-prod.cod-refer   <= c-cod-refer-f
          and  pl-it-prod.dt-termino <= dData
          and pl-it-prod.cod-estabel  = c-cod-estabel no-lock,
          first item fields (it-codigo fm-codigo ge-codigo cd-planejado un) 
           where item.it-codigo  = pl-it-prod.it-codigo no-lock:


          if   pl-it-prod.ano          < i-ano-i 
            or pl-it-prod.ano           > i-ano-f       then next.

          if pl-it-prod.ano * 1000 + pl-it-prod.periodo < i-ano-i * 1000 + i-periodo-i
             or pl-it-prod.ano * 1000 + pl-it-prod.periodo > i-ano-f * 1000 + i-periodo-f then next.

          if item.fm-codigo        <  c-fm-codigo-i   
             or item.fm-codigo     >  c-fm-codigo-f then next.

          if  item.ge-codigo       <  i-ge-codigo-i 
             or  item.ge-codigo    >  i-ge-codigo-f then next.

          if  item.cd-planejado    <  c-cd-planej-i
             or  item.cd-planejado >  c-cd-planej-f then next.

            for first  tt-planilha fields (it-codigo cod-refer  ano periodo quantidade nome-abrev nr-pedcli
                                           nr-sequencia cod-gr-cli un elim quant itens ) use-index cd-ref
                      where  tt-planilha.it-codigo = pl-it-prod.it-codigo 
                      and    tt-planilha.cod-refer = pl-it-prod.cod-refer exclusive-lock:
            end.
            if not avail tt-planilha then do:
               create tt-planilha.
               buffer-copy pl-it-prod using it-codigo
                                            cod-refer
                                            ano
                                            periodo
                                            quantidade
                                            nome-abrev
                                            nr-pedcli
                                            nr-sequencia
                                            cod-gr-cli to tt-planilha
               assign tt-planilha.un    = item.un
                      tt-planilha.elim  = no
                      tt-planilha.iAcao = 2 /**** Alterar - Se a planilha ‚ criada entÆo o registro jÿ existe e vai ser modificado**/
                      i-cont-per        = 1.
               for first  tt-coluna fields (ano periodo nr-coluna) use-index codigo
                    where tt-coluna.ano     = pl-it-prod.ano 
                    and   tt-coluna.periodo = pl-it-prod.periodo no-lock:
               end.
               if avail tt-coluna then do:
                  assign tt-planilha.quant[tt-coluna.nr-coluna] = pl-it-prod.quantidade
                         tt-planilha.itens[tt-coluna.nr-coluna] = 1.
               end.
            end.
            else do:
                 for first  tt-coluna fields (ano periodo nr-coluna) use-index codigo
                     where tt-coluna.ano     = pl-it-prod.ano 
                     and   tt-coluna.periodo = pl-it-prod.periodo no-lock:
                 end.
                 if avail tt-coluna then do:
                    assign tt-planilha.quant[tt-coluna.nr-coluna] = tt-planilha.quant[tt-coluna.nr-coluna] + pl-it-prod.quantidade
                           tt-planilha.itens[tt-coluna.nr-coluna] = tt-planilha.itens[tt-coluna.nr-coluna] + 1.
                 end.
            end.
    end.
    
    if i-nr-periodo = 0 then
       delete tt-valores.
    
    RETURN "OK":U.
  
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "nome-abrev":U THEN ASSIGN pFieldValue = RowObject.nome-abrev.
        WHEN "nr-pedcli":U THEN ASSIGN pFieldValue = RowObject.nr-pedcli.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-termino":U THEN ASSIGN pFieldValue = RowObject.dt-termino.
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "qt-confirm":U THEN ASSIGN pFieldValue = RowObject.qt-confirm.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-entrega":U THEN ASSIGN pFieldValue = RowObject.nr-entrega.
        WHEN "nr-estrut":U THEN ASSIGN pFieldValue = RowObject.nr-estrut.
        WHEN "nr-sequencia":U THEN ASSIGN pFieldValue = RowObject.nr-sequencia.
        WHEN "periodo":U THEN ASSIGN pFieldValue = RowObject.periodo.
        WHEN "ano":U THEN ASSIGN pFieldValue = RowObject.ano.
        WHEN "cd-plano":U THEN ASSIGN pFieldValue = RowObject.cd-plano.
        WHEN "cod-gr-cli":U THEN ASSIGN pFieldValue = RowObject.cod-gr-cli.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CODIGO
  Parameters:
               retorna valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcd-plano LIKE pl-it-prod.cd-plano NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE pl-it-prod.it-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-refer LIKE pl-it-prod.cod-refer NO-UNDO.
    DEFINE OUTPUT PARAMETER pano LIKE pl-it-prod.ano NO-UNDO.
    DEFINE OUTPUT PARAMETER pperiodo LIKE pl-it-prod.periodo NO-UNDO.
    DEFINE OUTPUT PARAMETER pnome-abrev LIKE pl-it-prod.nome-abrev NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedcli LIKE pl-it-prod.nr-pedcli NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-sequencia LIKE pl-it-prod.nr-sequencia NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-gr-cli LIKE pl-it-prod.cod-gr-cli NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcd-plano = RowObject.cd-plano.
    ASSIGN pit-codigo = RowObject.it-codigo.
    ASSIGN pcod-refer = RowObject.cod-refer.
    ASSIGN pano = RowObject.ano.
    ASSIGN pperiodo = RowObject.periodo.
    ASSIGN pnome-abrev = RowObject.nome-abrev.
    ASSIGN pnr-pedcli = RowObject.nr-pedcli.
    ASSIGN pnr-sequencia = RowObject.nr-sequencia.
    ASSIGN pcod-gr-cli = RowObject.cod-gr-cli.

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

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
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
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecidField DBOProgram 
PROCEDURE getRecidField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo recid
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RECID NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRowidItem DBOProgram 
PROCEDURE getRowidItem :
/*------------------------------------------------------------------------------
  Purpose:     Retorna o rowid do registro onde a query estÿ posicionada
  Parameters:  output rowid do registro.
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER prowid AS ROWID NO-UNDO.

    /*--- Verifica se temptable RowObject estÿ dispon¡vel, caso nÆo esteja serÿ
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.
 
    assign prowid = RowObject.r-rowid.
 
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToItemPlanoEstab DBOProgram 
PROCEDURE goToItemPlanoEstab :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base nos par³metros passados
  Parameters:  i-par01 = Plano de Produ‡Æo
               i-par02 = Item
               i-par03 = Estabelecimento /* A partir da versÆo 2.03 */
               retorna "OK" ou "NOK"
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-plano  LIKE pl-it-prod.cd-plano  NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE pl-it-prod.it-codigo NO-UNDO.
    
    DEFINE INPUT PARAMETER pcod-estabel LIKE pl-it-prod.cod-estabel NO-UNDO.
    

    FIND FIRST bfpl-it-prod WHERE
        bfpl-it-prod.cd-plano = pcd-plano and
        bfpl-it-prod.it-codigo = pit-codigo
        
        and bfpl-it-prod.cod-estabel = pcod-estabel
        
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-prod THEN
        RETURN "NOK":U.
    
    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CODIGO
  Parameters:
               recebe valor dos campos do ¡ndice CODIGO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-plano LIKE pl-it-prod.cd-plano NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE pl-it-prod.it-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pcod-refer LIKE pl-it-prod.cod-refer NO-UNDO.
    DEFINE INPUT PARAMETER pano LIKE pl-it-prod.ano NO-UNDO.
    DEFINE INPUT PARAMETER pperiodo LIKE pl-it-prod.periodo NO-UNDO.
    DEFINE INPUT PARAMETER pnome-abrev LIKE pl-it-prod.nome-abrev NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedcli LIKE pl-it-prod.nr-pedcli NO-UNDO.
    DEFINE INPUT PARAMETER pnr-sequencia LIKE pl-it-prod.nr-sequencia NO-UNDO.
    DEFINE INPUT PARAMETER pcod-gr-cli LIKE pl-it-prod.cod-gr-cli NO-UNDO.
    
    DEFINE INPUT PARAMETER pcod-estabel LIKE pl-it-prod.cod-estabel NO-UNDO.    
    
    
    
    FIND FIRST bfpl-it-prod WHERE
        bfpl-it-prod.cd-plano = pcd-plano AND
        bfpl-it-prod.cod-estabel = pcod-estabel AND
        bfpl-it-prod.it-codigo = pit-codigo AND
        bfpl-it-prod.cod-refer = pcod-refer AND
        bfpl-it-prod.ano = pano AND
        bfpl-it-prod.periodo = pperiodo AND
        bfpl-it-prod.nome-abrev = pnome-abrev AND
        bfpl-it-prod.nr-pedcli = pnr-pedcli AND
        bfpl-it-prod.nr-sequencia = pnr-sequencia AND
        bfpl-it-prod.cod-gr-cli = pcod-gr-cli
        NO-LOCK NO-ERROR.
    
    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-prod THEN
        RETURN "NOK":U.
    
    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyCdPlano DBOProgram 
PROCEDURE goToKeyCdPlano :
/*------------------------------------------------------------------------------
  Purpose:     posiciona o registro utilizando somente o Plano, o Ano e o Per¡odo
  Parameters:  c¢digo do plano, ano e per¡odo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-plano LIKE pl-it-prod.cd-plano NO-UNDO.
    DEFINE INPUT PARAMETER pano LIKE pl-it-prod.ano NO-UNDO.
    DEFINE INPUT PARAMETER pperiodo LIKE pl-it-prod.periodo NO-UNDO.

    FIND FIRST bfpl-it-prod WHERE
        bfpl-it-prod.cd-plano = pcd-plano AND
        bfpl-it-prod.ano      = pano AND
        bfpl-it-prod.periodo  = pperiodo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyPlano DBOProgram 
PROCEDURE goToKeyPlano :
/*------------------------------------------------------------------------------
  Purpose:     posiciona o registro utilizando somente o Plano
  Parameters:  c¢digo do plano
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcd-plano LIKE pl-it-prod.cd-plano NO-UNDO.

    FIND FIRST bfpl-it-prod WHERE
        bfpl-it-prod.cd-plano = pcd-plano
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyItem DBOProgram 
PROCEDURE goToKeyItem :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona o registro no primeiro que encontrar com o item informado
  Parameters:  recebe o C¢digo do Item
               retorna status do processo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pit-codigo LIKE pl-it-prod.it-codigo NO-UNDO.

    FIND FIRST bfpl-it-prod WHERE
         bfpl-it-prod.it-codigo = pit-codigo 
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-prod THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-prod)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyRowid DBOProgram 
PROCEDURE goToKeyRowid :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no rowid
  Parameters:
               recebe rowid do registro desejado
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER prowid as rowid NO-UNDO.

    FIND FIRST bfpl-it-prod WHERE
         rowid(bfpl-it-prod) = prowid
         NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro serÿ retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfpl-it-prod THEN
        RETURN "NOK":U.
    
    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros serÿ retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfpl-it-prod)).
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
            when 2 then
                RUN openQueryStatic (input "Plano":U). 
            when 3 then
                RUN openQueryStatic (input "Filtro":U). 
            when 4 then
                RUN openQueryStatic (input "AdvancedSearch":U). 

                                                                    
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltro DBOProgram 
PROCEDURE openQueryFiltro :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela pl-it-prod 
              contendo o plano, uma faixa do ano e do per¡odo. 
              ordena por item, referˆncia, ano e per¡odo.
      
  ------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where  
               {&TABLENAME}.cd-plano  = i-cd-plano
               and (({&TABLENAME}.ano > v-ano1
               and   {&TABLENAME}.ano < v-ano2)
                                        
               or  ({&TABLENAME}.ano     = v-ano1
               and   {&TABLENAME}.ano      = v-ano2
               and   {&TABLENAME}.periodo >= v-periodo1
               and   {&TABLENAME}.periodo <= v-periodo2)
               
               or  ({&TABLENAME}.ano      = v-ano1
               and   {&TABLENAME}.ano      < v-ano2
               and   {&TABLENAME}.periodo >= v-periodo1)
                              
               or  ({&TABLENAME}.ano      > v-ano1
               and   {&TABLENAME}.ano      = v-ano2
               and   {&TABLENAME}.periodo <= v-periodo2)) NO-LOCK
    
               by {&tablename}.it-codigo
               by {&TABLENAME}.cod-refer
               by {&TABLENAME}.ano
               by {&TABLENAME}.periodo  INDEXED-REPOSITION.

            
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
    OPEN QUERY {&QueryName} FOR EACH pl-it-prod NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPlano DBOProgram 
PROCEDURE openQueryPlano :
/*------------------------------------------------------------------------------
  Purpose:    Abre a query em fun‡Æo do c¢digo do plano  
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} 
         FOR EACH pl-it-prod 
            WHERE pl-it-prod.cd-plano = i-cd-plano NO-LOCK 
               BY pl-it-prod.it-codigo 
               BY pl-it-prod.cod-refer INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAdvancedSearch DBOProgram 
PROCEDURE openQueryAdvancedSearch :
/*------------------------------------------------------------------------------
  Purpose:      Abre a query em fun‡Æo do plano, da faixa de item, 
                grupo de estoque e estabelecimento
  Parameters:   
  Notes:        Utilizado na pesquisa avançada dos programas HTML
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} 
        FOR EACH pl-it-prod NO-LOCK
           WHERE pl-it-prod.cd-plano        = i-cd-plano
             AND pl-it-prod.cod-estabel    >= c-cod-estabel-ini
             AND pl-it-prod.cod-estabel    <= c-cod-estabel-fin
             AND pl-it-prod.it-codigo      >= c-it-codigo-ini
             AND pl-it-prod.it-codigo      <= c-it-codigo-fin
             AND pl-it-prod.cod-gr-cli     >= i-cod-gr-cli-ini
             AND pl-it-prod.cod-gr-cli     <= i-cod-gr-cli-fin INDEXED-REPOSITION.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PosicionarPlItProd DBOProgram 
PROCEDURE PosicionarPlItProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  i - C¢digo do Plano, 
               i - C¢digo do item, 
               i - Referencia do item,
               i - Estabelecimento, 
               i - ano inicial, 
               i - ano final, 
               i- Per¡odo inicial, 
               i - Per¡odo final, 
               o - Rowid do registro
  Notes:       
------------------------------------------------------------------------------*/

  def input  parameter pi-plano    as int   no-undo.
  def input  parameter pit-codigo  as char  no-undo.
  def input  parameter pcod-refer  as char  no-undo.
  
  def input  parameter p-cod-estab as char  no-undo.
  
  def input  parameter pi-ano-ini  as int   no-undo.
  def input  parameter pi-ano-fim  as int   no-undo.
  def input  parameter pi-per-ini  as int   no-undo.
  def input  parameter pi-per-fim  as int   no-undo.
  def output parameter r-rowid     as rowid no-undo.

  find first pl-it-prod
      where pl-it-prod.cd-plano    = pi-plano
      
      and   pl-it-prod.cod-estabel = p-cod-estab
      
      and   pl-it-prod.it-codigo >= pit-codigo
      and   pl-it-prod.cod-refer >= pcod-refer
      and ((pl-it-prod.ano        > pi-ano-ini
      and   pl-it-prod.ano        < pi-ano-fim)
       or  (pl-it-prod.ano        = pi-ano-ini
      and   pl-it-prod.ano        = pi-ano-fim
      and   pl-it-prod.periodo   >= pi-per-ini
      and   pl-it-prod.periodo   <= pi-per-fim)
       or  (pl-it-prod.ano        = pi-ano-ini
      and   pl-it-prod.ano        < pi-ano-fim
      and   pl-it-prod.periodo   >= pi-per-ini)
       or  (pl-it-prod.ano        > pi-ano-ini
      and   pl-it-prod.ano        = pi-ano-fim
      and   pl-it-prod.periodo   <= pi-per-fim))
      no-lock no-error.
      
  if  not avail pl-it-prod then 
      find first pl-it-prod
           where pl-it-prod.cd-plano  = pi-plano 
           
           and   pl-it-prod.cod-estabel = p-cod-estab
           
           and  ((pl-it-prod.ano      > pi-ano-ini
           and    pl-it-prod.ano      < pi-ano-fim)
            or   (pl-it-prod.ano      = pi-ano-ini
           and    pl-it-prod.ano      = pi-ano-fim
           and    pl-it-prod.periodo >= pi-per-ini
           and    pl-it-prod.periodo <= pi-per-fim)
            or   (pl-it-prod.ano      = pi-ano-ini
           and    pl-it-prod.ano      < pi-ano-fim
           and    pl-it-prod.periodo >= pi-per-ini)
            or   (pl-it-prod.ano      > pi-ano-ini
           and    pl-it-prod.ano      = pi-ano-fim
           and    pl-it-prod.periodo <= pi-per-fim))
           no-lock no-error.

  if  avail pl-it-prod then
      assign r-rowid = rowid(pl-it-prod).
  else 
      assign r-rowid = ?.
        
  RETURN "OK":U.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaPedItem DBOProgram 
PROCEDURE retornaPedItem :
/*-----------------------------------------------------------------------------
  Purpose: Este procedimento tem por objetivo localizar o ped-item e retornar
           a Quantidade Pedida, a Quantidade Atendida, a Quantidade Pendente
           e uma variÿvel que retorna um erro caso nÆo encontre o registro.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnome-abrev    LIKE ped-item.nome-abrev     NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-pedcli     LIKE ped-item.nr-pedcli      NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-sequencia  LIKE ped-item.nr-sequencia   NO-UNDO.
    DEFINE INPUT  PARAMETER pit-codigo     LIKE ped-item.it-codigo      NO-UNDO.
    DEFINE INPUT  PARAMETER pcod-refer     LIKE ped-item.cod-refer      NO-UNDO.
    DEFINE OUTPUT PARAMETER de-qt-pedida   LIKE ped-item.qt-pedida      NO-UNDO.
    DEFINE OUTPUT PARAMETER de-qt-atendida LIKE ped-item.qt-atendida NO-UNDO.
    DEFINE OUTPUT PARAMETER de-qt-pendente LIKE ped-item.qt-pendente NO-UNDO.
    DEFINE OUTPUT PARAMETER l-erro         AS LOGICAL INIT YES          NO-UNDO.

    FIND FIRST bfped-item WHERE 
               bfped-item.nome-abrev   = pnome-abrev   AND 
               bfped-item.nr-pedcli    = pnr-pedcli    AND 
               bfped-item.nr-sequencia = pnr-sequencia AND 
               bfped-item.it-codigo    = pit-codigo    AND 
               bfped-item.cod-refer    = pcod-refer NO-LOCK NO-ERROR.
    if avail bfped-item then do:
       assign de-qt-pedida   = bfped-item.qt-pedida
              de-qt-atendida = bfped-item.qt-pedida
              de-qt-pendente = bfped-item.qt-pendente
              l-erro = no.
    end.
    else
       assign l-erro = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaPedVenda DBOProgram 
PROCEDURE retornaPedVenda :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice e retorna o
               estabelecimento do mesmo.
  Parameters:  recebe valor do campo nome-abrev
               recebe valor do campo nr-pedcli
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnome-abrev  LIKE ped-venda.nome-abrev  NO-UNDO.
    DEFINE INPUT  PARAMETER pnr-pedcli   LIKE ped-venda.nr-pedcli   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE ped-venda.cod-estabel NO-UNDO.

    FIND FIRST bfped-venda WHERE 
        bfped-venda.nome-abrev = pnome-abrev AND 
        bfped-venda.nr-pedcli  = pnr-pedcli NO-LOCK NO-ERROR.
    if avail bfped-venda then
       assign pcod-estabel = bfped-venda.cod-estabel.
    else
       RETURN "NOK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaLimites DBOProgram 
PROCEDURE setaLimites :
/*------------------------------------------------------------------------------
  Purpose:     Este procedimento tem por objetivo devolver quais sÆo os 40
               pr¢ximos registros da tabela pl-it-prod, caso o campo
               p-it-codigo-ini-informa for diferente de ?. SenÆo este retornarÿ
               os 40 registros anteriores da tabela pl-it-prod.
  Parameters:  
                p-cd-plano              -> Plano de Produ‡Æo
                p-it-codigo-ini-informa -> Item Inicial Informado ou nÆo
                p-it-codigo-fim-informa -> Item Final Informado ou nÆo
                p-cod-refer-ini-informa -> Referencia Inicial Informada ou nÆo
                p-cod-refer-fim-informa -> Referencia Final Informada ou nÆo
                p-cod-estabel-ini       -> Estabelecimento Inicial informado (Dispon¡vel a partir da versÆo 2.03)
                p-cod-estabel-fim       -> Estabelecimento Final informado (Dispon¡vel a partir da versÆo 2.03)
                p-per-ini               -> Per¡odo Inicial informado
                p-per-fim               -> Per¡odo Final informado
                p-ano-ini               -> Ano Inicial informado
                p-ano-fim               -> Ano Final informado
                p-it-codigo-ini-devolve -> Item Inicial Devolvido
                p-it-codigo-fim-devolve -> Item Final Devolvido
  Notes:       
------------------------------------------------------------------------------*/
define input  parameter p-cd-plano              like pl-it-prod.cd-plano    no-undo.
define input  parameter p-it-codigo-ini-informa like pl-it-prod.it-codigo   no-undo.
define input  parameter p-it-codigo-fim-informa like pl-it-prod.it-codigo   no-undo.
define input  parameter p-cod-refer-ini-informa like pl-it-prod.cod-refer   no-undo.
define input  parameter p-cod-refer-fim-informa like pl-it-prod.cod-refer   no-undo.
define input  parameter p-cod-estabel-ini       like pl-it-prod.cod-estabel no-undo.
define input  parameter p-cod-estabel-fim       like pl-it-prod.cod-estabel no-undo.
define input  parameter p-per-ini               like pl-it-prod.periodo     no-undo.
define input  parameter p-per-fim               like pl-it-prod.periodo     no-undo.
define input  parameter p-ano-ini               like pl-it-prod.ano         no-undo.
define input  parameter p-ano-fim               like pl-it-prod.ano         no-undo.
define output parameter p-it-codigo-ini-devolve like pl-it-prod.it-codigo   no-undo.
define output parameter p-it-codigo-fim-devolve like pl-it-prod.it-codigo   no-undo.
define output parameter p-cod-refer-ini-devolve like pl-it-prod.cod-refer   no-undo.
define output parameter p-cod-refer-fim-devolve like pl-it-prod.cod-refer   no-undo.
define variable i-cont as integer no-undo.
define buffer bpl-it-prod for pl-it-prod.

find item where item.it-codigo = p-it-codigo-ini-informa no-lock no-error.

if p-it-codigo-ini-informa <> ? then do:

   if item.tipo-con-est <> 4 then
      assign p-cod-refer-ini-informa = " "
             p-cod-refer-fim-informa = "ZZZZZZZZ". 
   
   find first bpl-it-prod 
        where bpl-it-prod.cd-plano   = p-cd-plano
          and bpl-it-prod.it-codigo >= p-it-codigo-ini-informa
          and bpl-it-prod.cod-refer >= p-cod-refer-ini-informa 
          
          and bpl-it-prod.cod-estabel >= p-cod-estabel-ini
          and bpl-it-prod.cod-estabel <= p-cod-estabel-fim
          
          and ((bpl-it-prod.ano    > p-ano-ini
          and bpl-it-prod.ano      < p-ano-fim)
           or (bpl-it-prod.ano     = p-ano-ini
          and bpl-it-prod.ano      = p-ano-fim
          and bpl-it-prod.periodo >= p-per-ini
          and bpl-it-prod.periodo <= p-per-fim)
           or (bpl-it-prod.ano     = p-ano-ini
          and bpl-it-prod.ano      < p-ano-fim
          and bpl-it-prod.periodo >= p-per-ini)
           or (bpl-it-prod.ano     > p-ano-ini
          and bpl-it-prod.ano      = p-ano-fim
          and bpl-it-prod.periodo <= p-per-fim)) no-error.
   if avail bpl-it-prod then
      assign p-it-codigo-ini-devolve = bpl-it-prod.it-codigo 
             p-it-codigo-fim-devolve = "ZZZZZZZZZZZZZZZZ"
             p-cod-refer-ini-devolve = bpl-it-prod.cod-refer  
             p-cod-refer-fim-devolve = "ZZZZZZZZ".

   repeat:
        assign i-cont = i-cont + 1.

        if i-cont > 40 or not avail bpl-it-prod then
           leave.

        find next bpl-it-prod
             where bpl-it-prod.cd-plano   = p-cd-plano
               and bpl-it-prod.it-codigo >= p-it-codigo-ini-devolve  
               and bpl-it-prod.cod-refer >= p-cod-refer-ini-devolve   
               
               and bpl-it-prod.cod-estabel >= p-cod-estabel-ini
               and bpl-it-prod.cod-estabel <= p-cod-estabel-fim
               
               and ((bpl-it-prod.ano    > p-ano-ini
               and bpl-it-prod.ano      < p-ano-fim)
                or (bpl-it-prod.ano     = p-ano-ini
               and bpl-it-prod.ano      = p-ano-fim
               and bpl-it-prod.periodo >= p-per-ini
               and bpl-it-prod.periodo <= p-per-fim)
                or (bpl-it-prod.ano     = p-ano-ini
               and bpl-it-prod.ano      < p-ano-fim
               and bpl-it-prod.periodo >= p-per-ini)
                or (bpl-it-prod.ano     > p-ano-ini
               and bpl-it-prod.ano      = p-ano-fim
               and bpl-it-prod.periodo <= p-per-fim)) no-error.
        if avail bpl-it-prod then   /*
           assign p-it-codigo-fim-devolve = bpl-it-prod.it-codigo
                  p-cod-refer-fim-devolve = bpl-it-prod.cod-refer.   */
                  
   end.
end.
else do:

   if item.tipo-con-est <> 4 then 
      assign p-cod-refer-ini-informa = " "
             p-cod-refer-fim-informa = "ZZZZZZZZ".
   
   find  last bpl-it-prod
        where bpl-it-prod.cd-plano   = p-cd-plano
          and bpl-it-prod.it-codigo <= p-it-codigo-fim-informa
          and bpl-it-prod.cod-refer <= p-cod-refer-fim-informa 
          
          and bpl-it-prod.cod-estabel >= p-cod-estabel-ini
          and bpl-it-prod.cod-estabel <= p-cod-estabel-fim
          
          and ((bpl-it-prod.ano    > p-ano-ini
          and bpl-it-prod.ano      < p-ano-fim)
           or (bpl-it-prod.ano     = p-ano-ini
          and bpl-it-prod.ano      = p-ano-fim
          and bpl-it-prod.periodo >= p-per-ini
          and bpl-it-prod.periodo <= p-per-fim)
           or (bpl-it-prod.ano     = p-ano-ini
          and bpl-it-prod.ano      < p-ano-fim
          and bpl-it-prod.periodo >= p-per-ini)
           or (bpl-it-prod.ano     > p-ano-ini
          and bpl-it-prod.ano      = p-ano-fim
          and bpl-it-prod.periodo <= p-per-fim)) no-error.
   if avail bpl-it-prod then
      assign p-it-codigo-ini-devolve = bpl-it-prod.it-codigo 
             p-it-codigo-fim-devolve = "ZZZZZZZZZZZZZZZZ"
             p-cod-refer-ini-devolve = bpl-it-prod.cod-refer
             p-cod-refer-fim-devolve = "ZZZZZZZZ". 


   repeat:
        assign i-cont = i-cont + 1.

        if i-cont > 40 or not avail bpl-it-prod then
           leave.

        find prev bpl-it-prod
             where bpl-it-prod.cd-plano   = p-cd-plano
               and bpl-it-prod.it-codigo <= p-it-codigo-ini-devolve 
               and bpl-it-prod.cod-refer <= p-cod-refer-ini-devolve 
               
               and bpl-it-prod.cod-estabel >= p-cod-estabel-ini
               and bpl-it-prod.cod-estabel <= p-cod-estabel-fim
               
               and ((bpl-it-prod.ano    > p-ano-ini
               and bpl-it-prod.ano      < p-ano-fim)
                or (bpl-it-prod.ano     = p-ano-ini
               and bpl-it-prod.ano      = p-ano-fim
               and bpl-it-prod.periodo >= p-per-ini
               and bpl-it-prod.periodo <= p-per-fim)
                or (bpl-it-prod.ano     = p-ano-ini
               and bpl-it-prod.ano      < p-ano-fim
               and bpl-it-prod.periodo >= p-per-ini)
                or (bpl-it-prod.ano     > p-ano-ini
               and bpl-it-prod.ano      = p-ano-fim
               and bpl-it-prod.periodo <= p-per-fim)) no-error.
        if avail bpl-it-prod then    /*
           assign p-it-codigo-ini-devolve = bpl-it-prod.it-codigo
                  p-cod-refer-ini-devolve = bpl-it-prod.cod-refer. */
   end.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variÿveis de controle para queries contendo 
              o n£mero do plano.  
  Parameters: ipar:p-cd-plano: Nr Plano  
------------------------------------------------------------------------------*/
    /* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-cd-plano as character no-undo.
        
    run setConstraintPlano (p-cd-plano).
    
    RETURN "OK":U.

       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variÿveis de controle para queries contendo 
              o n£mero do plano, per¡odo inicial e final.  
  Parameters: ipar1:p-cd-plano:  Nr Plano  
              ipar2:p-i-per-ini: Per¡odo Inicial
              ipar3:p-i-per-fim: Per¡odo Final  
     
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter p-cd-plano  as character no-undo.
    define input parameter p-i-per-ini as character no-undo.
    define input parameter p-i-per-fim as character no-undo.

        
    run setConstraintPlanoPeriodo (p-cd-plano,
                                   p-i-per-ini,
                                   p-i-per-fim).
    
    RETURN "OK":U.

                   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPlano DBOProgram 
PROCEDURE setConstraintPlano :
/*------------------------------------------------------------------------------
  Purpose:     atualiza o plano corrente para a abertura da query
  Parameters:  c¢digo do plano
  Notes:       
------------------------------------------------------------------------------*/

def input param pcd-plano like pl-it-prod.cd-plano no-undo.

assign i-cd-plano = pcd-plano.

RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPlanoPeriodo DBOProgram 
PROCEDURE setConstraintPlanoPeriodo :
/*------------------------------------------------------------------------------
  Purpose:     Seta as variÿveis de controle para queries contendo 
              o n£mero do plano, per¡odo inicial e final.  
  Parameters: ipar1:pcd-plano:  Nr Plano  
              ipar2:pi-per-ini: Per¡odo Inicial
              ipar3:pi-per-fim: Per¡odo Final  
------------------------------------------------------------------------------*/
    define input parameter pcd-plano  as character no-undo.
    define input parameter pi-per-ini as character no-undo.
    define input parameter pi-per-fim as character no-undo.

    assign i-cd-plano = integer(pcd-plano)
           pos1       = index(pi-per-ini, "/")
           v-periodo1 = integer (substring(string(pi-per-ini),1,pos1 - 1,"char"))
           v-ano1     = integer (substring(string(pi-per-ini),pos1 + 1,8,"char"))
           pos2       = index(pi-per-fim, "/")
           v-periodo2 = integer (substring(string(pi-per-fim),1,pos2 - 1,"char"))
           v-ano2     = integer (substring(string(pi-per-fim),pos2 + 1,8,"char")).

RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAdvancedSearch DBOProgram 
PROCEDURE setConstraintAdvancedSearch :
/*------------------------------------------------------------------------------
  Purpose:     atualiza o plano corrente para a abertura da query
  Parameters:  c¢digo do plano
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-i-cd-plano      LIKE pl-it-prod.cd-plano    NO-UNDO.
DEF INPUT PARAM p-it-codigo-ini   LIKE pl-it-prod.it-codigo   NO-UNDO.
DEF INPUT PARAM p-it-codigo-fin   LIKE pl-it-prod.it-codigo   NO-UNDO.
DEF INPUT PARAM p-cod-gr-cli-ini  LIKE pl-it-prod.cod-gr-cli  NO-UNDO.
DEF INPUT PARAM p-cod-gr-cli-fin  LIKE pl-it-prod.cod-gr-cli  NO-UNDO.
DEF INPUT PARAM p-cod-estabel-ini LIKE pl-it-prod.cod-estabel NO-UNDO.
DEF INPUT PARAM p-cod-estabel-fin LIKE pl-it-prod.cod-estabel NO-UNDO.

ASSIGN i-cd-plano        = p-i-cd-plano
       c-it-codigo-ini   = p-it-codigo-ini
       c-it-codigo-fin   = p-it-codigo-fin
       i-cod-gr-cli-ini  = p-cod-gr-cli-ini
       i-cod-gr-cli-fin  = p-cod-gr-cli-fin
       c-cod-estabel-ini = p-cod-estabel-ini
       c-cod-estabel-fin = p-cod-estabel-fin.

RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    def var c-tipo-plano   as char no-undo.
    def var i-niv-mais-bai as int  no-undo.
    DEFINE VARIABLE i-cod-obsoleto AS INTEGER     NO-UNDO.

    /*--- Utilize o par³metro pType para identificar quais as valida‡„es a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o par³metro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡„es ---*/

    if  pType = "Create" then do:
        for first item fields(contr-plan cod-obsoleto tipo-contr tipo-con-est) 
            where item.it-codigo = RowObject.it-codigo no-lock:
        end.
        
        for first pl-prod fields(cd-tipo log-multi-estabel ano-per-ini 
                                 nr-per-ini ano-per-fim nr-per-fim) 
            where pl-prod.cd-plano = RowObject.cd-plano no-lock:
        end.
        
        for first ref-item fields() 
            where ref-item.cod-refer = RowObject.cod-refer
              and ref-item.it-codigo = RowObject.it-codigo no-lock:
        end.
        
        assign i-cd-tipo = if avail pl-prod then pl-prod.cd-tipo
                           else 0.
        
        for first periodo fields()
            where periodo.cd-tipo    = i-cd-tipo
              and periodo.ano        = RowObject.ano
              and periodo.nr-periodo = RowObject.periodo no-lock:
        end.
        
        for first emitente fields()
            where emitente.nome-abrev = RowObject.nome-abrev no-lock:
        end.
        
        for first gr-cli fields(cod-gr-cli)
            where gr-cli.cod-gr-cli = RowObject.cod-gr-cli no-lock:
        end.

        find first pl-it-prod exclusive-lock
             where pl-it-prod.cd-plano     = RowObject.cd-plano
               and pl-it-prod.it-codigo    = RowObject.it-codigo
               
               and pl-it-prod.cod-estabel  = RowObject.cod-estabel
               
               and pl-it-prod.cod-refer    = RowObject.cod-refer
               and pl-it-prod.ano          = RowObject.ano
               and pl-it-prod.periodo      = RowObject.periodo
               and pl-it-prod.nome-abrev   = RowObject.nome-abrev
               and pl-it-prod.nr-pedcli    = RowObject.nr-pedcli
               and pl-it-prod.nr-sequencia = RowObject.nr-sequencia
               and pl-it-prod.cod-gr-cli   = RowObject.cod-gr-cli
               and rowid(pl-it-prod)      <> RowObject.r-rowid no-error.
        

        if  avail pl-it-prod then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-necessidades-do-plano AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Necessidades_do_Plano" *}
            ASSIGN c-lbl-liter-necessidades-do-plano = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i  &ErrorNumber="1"
                                         &ErrorType="EMS"
                                         &ErrorParameters="c-lbl-liter-necessidades-do-plano"}
        end.

        if not avail item then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item" *}
            ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i  &ErrorNumber="56"
                                         &ErrorType="EMS"
                                         &ErrorParameters="c-lbl-liter-item"}
        end.
        else do:
            assign i-tipo-con-est = item.tipo-con-est.
            
            if  RowObject.it-codigo = "":U then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-item-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Item" *}
                ASSIGN c-lbl-liter-item-2 = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i  &ErrorNumber="5622"
                                             &ErrorType="EMS"
                                             &ErrorParameters="c-lbl-liter-item-2"}
            end.
        end.

        if avail item and item.contr-plan = 2 then do:
            {method/svc/errors/inserr.i  &ErrorNumber="559"
                                         &ErrorType="EMS"
                                         &ErrorParameters="''"}
        end.

        if avail item and item.cod-obsoleto > 1 then do:
            {method/svc/errors/inserr.i  &ErrorNumber="563"
                                         &ErrorType="EMS"
                                         &ErrorParameters="item.it-codigo"}
        end.
        
        
        if avail pl-prod and pl-prod.log-multi-estabel then do:
            run adbo/boad107na.p persistent set h-boad107.
            run openQueryStatic in h-boad107 (input "Main":U).
            run goToKey in h-boad107 (input RowObject.cod-estabel).
            if  return-value = "NOK":U
            or  RowObject.cod-estabel = "":U then do:
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Estabelecimento" *}
               ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
               {method/svc/errors/inserr.i  &ErrorNumber="47"
                                            &ErrorType="EMS"
                                            &ErrorParameters="c-lbl-liter-estabelecimento"}
            end.
            
            /* Consiste que o item exista na tabela item-uni-estab e 
               se a demanda ‚ dependente */
               
            run inbo/boin684.p persistent set h-boin684.  
            run openQueryStatic in h-boin684 (input "Main":U). 
            run goToKey in h-boin684 (input rowObject.it-codigo,
                                      input rowObject.cod-estabel).
            if  return-value = "NOK":U then do:
                {method/svc/errors/inserr.i  &ErrorNumber="5101"
                                             &ErrorType="EMS"
                                             &ErrorParameters="''"}
            end.
            
            run getIntField in h-boin684 (input "demanda":U, output i-demanda).

            if  i-demanda = 2 then do:
                {method/svc/errors/inserr.i  &ErrorNumber="564"
                                             &ErrorType="EMS"
                                             &ErrorParameters="''"}
            end.
            
            run getIntField in h-boin684 (input "cod-obsoleto":U, output i-cod-obsoleto).

            if  i-cod-obsoleto > 1 then do:
                {method/svc/errors/inserr.i  &ErrorNumber="25983"
                                             &ErrorType="EMS"
                                             &ErrorParameters="rowObject.it-codigo + '~~~~' + rowObject.cod-estabel"}
            end.
            
            delete procedure h-boad107.
            delete procedure h-boin684.
        end.

        if avail item and item.tipo-contr = 4 /*D‚bito*/ then do:
            {method/svc/errors/inserr.i  &ErrorNumber="565"
                                         &ErrorType="EMS"
                                         &ErrorParameters="''"}
        end.

        if avail item and item.tipo-con-est = 4 then do:
            if not avail ref-item then do:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-referencia-do-item AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Referˆncia_do_Item" *}
                ASSIGN c-lbl-liter-referencia-do-item = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i  &ErrorNumber="47"
                                             &ErrorType="EMS"
                                             &ErrorParameters="c-lbl-liter-referencia-do-item"}
            end.
        end.
        
        if not avail emitente and RowObject.nome-abrev <> "":U then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nome-abreviado AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Nome_Abreviado" *}
            ASSIGN c-lbl-liter-nome-abreviado = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i  &ErrorNumber="895"
                                         &ErrorType="EMS"
                                         &ErrorParameters="c-lbl-liter-nome-abreviado"}
        end.
        
        if  not avail gr-cli and RowObject.cod-gr-cli <> 0 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-grupo-de-cliente AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Grupo_de_cliente" *}
            ASSIGN c-lbl-liter-grupo-de-cliente = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i  &ErrorNumber="47"
                                         &ErrorType="EMS"
                                         &ErrorParameters="c-lbl-liter-grupo-de-cliente"}
        end.
  
        run findParamGlobal (input "modulo-pd":U, output l-modulo).
        if  return-value = "OK":U 
        and l-modulo 
        and RowObject.nr-pedcli <> "" then do:
            run findPedVenda (input RowObject.nome-abrev,
                              input RowObject.nr-pedcli).
            if  return-value = "NOK":U then do:
                {method/svc/errors/inserr.i  &ErrorNumber="568"
                                             &ErrorType="EMS"
                                             &ErrorParameters="''"}
            end.
        end.

        if  l-modulo
        and i-tipo-con-est          = 4
        and RowObject.nr-pedcli    <> ""
        and RowObject.nr-sequencia <> 0 then do:
        
            run findPedItem (input RowObject.nome-abrev,
                             input RowObject.nr-pedcli,
                             input RowObject.nr-sequencia,
                             input RowObject.it-codigo,
                             input RowObject.cod-refer).

            if return-value = "NOK" then do:
               {method/svc/errors/inserr.i  &ErrorNumber="569"
                                            &ErrorType="EMS"
                                            &ErrorParameters="''"}
            end.
            else do:
                if avail pl-prod and pl-prod.log-multi-estabel then do:
                    run findPedVenda (input RowObject.nome-abrev,
                                      input RowObject.nr-pedcli).
                    if  return-value = "OK":U then do:
                        if  bfped-venda.cod-estabel <> RowObject.cod-estabel then do:
                            {method/svc/errors/inserr.i  &ErrorNumber="569"
                                                         &ErrorType="EMS"
                                                         &ErrorParameters="''"}
                        end.
                    end.
                end.
            end.
        end.
        else 
            if  l-modulo
            and RowObject.nr-pedcli <> ""
            and RowObject.nr-sequencia <> 0 then do:
            
                run findPedItem (input RowObject.nome-abrev,
                                 input RowObject.nr-pedcli,
                                 input RowObject.nr-sequencia,
                                 input RowObject.it-codigo,
                                 input "").
                if return-value = "NOK" then do:
                   {method/svc/errors/inserr.i  &ErrorNumber="569"
                                                &ErrorType="EMS"
                                                &ErrorParameters="''"}
                end.
                else do:
                    if avail pl-prod and pl-prod.log-multi-estabel = yes then do:
                        run findPedVenda (input RowObject.nome-abrev,
                                          input RowObject.nr-pedcli).
                        if  return-value = "OK":U then do:
                            if  bfped-venda.cod-estabel <> RowObject.cod-estabel then do:
                                {method/svc/errors/inserr.i  &ErrorNumber="569"
                                                             &ErrorType="EMS"
                                                             &ErrorParameters="''"}
                            end.
                        end.
                    end.
                end.
            end.
        
        if not avail periodo then do:
            assign l-erro-periodo = yes.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-ano AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Ano" *}
            ASSIGN c-lbl-liter-ano = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i  &ErrorNumber="56"
                                         &ErrorType="EMS"
                                         &ErrorParameters="c-lbl-liter-ano"}
        end.

        assign l-erro-periodo = no.

        if avail pl-prod and
           (RowObject.ano     < pl-prod.ano-per-ini
        or (RowObject.ano     = pl-prod.ano-per-ini
        and RowObject.periodo < pl-prod.nr-per-ini)) then
            assign l-erro-periodo = yes.
         
        if avail pl-prod and
           (RowObject.ano     > pl-prod.ano-per-fim 
        or (RowObject.ano     = pl-prod.ano-per-fim 
        and RowObject.periodo > pl-prod.nr-per-fim)) then 
            assign l-erro-periodo = yes.

        if  l-erro-periodo = yes then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-nr-periodo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Nr_Per¡odo" *}
            ASSIGN c-lbl-liter-nr-periodo = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i  &ErrorNumber="6588"
                                         &ErrorType="EMS"
                                         &ErrorParameters="c-lbl-liter-nr-periodo"}
        end.
    end.

    if  RowObject.quantidade <= 0 then do:
        {method/svc/errors/inserr.i  &ErrorNumber="1368"
                                     &ErrorType="EMS"
                                     &ErrorParameters="''"}
    end.

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

