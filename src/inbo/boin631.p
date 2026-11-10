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
********************************************************************************/
{include/i-prgvrs.i BOIN631 2.00.00.031 } /*** "010031" 24/11/2023 13:25:25  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin631 MUT}
&ENDIF

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
&GLOBAL-DEFINE DBOName doc-pend-aprov
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName doc-pend-aprov
&GLOBAL-DEFINE TableLabel doc-pend-aprov
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com
      extens∆o .i ---*/
{inbo/boin631.i RowObject}
{include/i-epc200.i boin631}
/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName}     FOR {&TableName}.
DEFINE BUFFER b-aprovador        FOR aprovador.
DEFINE BUFFER b-doc-pend-aprov   FOR doc-pend-aprov.
DEFINE BUFFER bb-doc-pend-aprov  FOR doc-pend-aprov.

{cdp/cd1720.i10}

{utp/utapi009.i}

/* Include utilizada no prÇ-processor (bf_mat_contratos) */
{cdp/cdcfgmat.i}
/* Vari†veis Integracao Importacao */
{cdp/cdapi171.i2}
{cdp/cdapi171.i1}

/* Procedures Integracao Importacao */
{cdp/cdapi171.i3}

{ccp/cc9999.i}

def new global shared var gi-proxima-prioridade as integer no-undo.
def new global shared var gl-proxima-aprovacao  as logical no-undo.
def new global shared var gc-motivo-apr         as char    no-undo.
def new global shared var gi-atualiza-data      as integer no-undo.
def new global shared var gc-motivo-apr         as char    no-undo.

def var r-aprovador      as rowid no-undo.
def var i-moeda-destino  as int   no-undo.
def var de-valor-total   as dec   no-undo.
def var l-preco-bruto    as log   no-undo.
def var de-indice        as deci  no-undo.

    def new global shared var gl-proxima-aprovacao  as logical no-undo.
    def new global shared var gi-proxima-prioridade as integer no-undo.
    def new global shared var c-seg-usuario as char format "x(12)" no-undo.

def var da-atualiza      as date  no-undo.
def var i-atualiza      as integer no-undo.
def var i-dias-atualiza as decimal no-undo.
def var de-preco        as decimal no-undo.
def buffer b-cot-item     for cotacao-item.
def buffer b-cotacao-item for cotacao-item.

def var l-gera-pendencia as logical no-undo.

/* Execucao Orcamentaria - Financas */
{include/i_dbvers.i}
{cdp/cdcfgfin.i}
DEF VAR l-api-orcam    AS LOGICAL NO-UNDO INITIAL YES.
/* Execucao Orcamentaria - Financas */
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


{method/svc/autentic/autentic.i 	
            &vUserName="c-seg-usuario"}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovaListaDocumentos DBOProgram 
PROCEDURE aprovaListaDocumentos :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input param pRowDocPend   as rowid   no-undo.
    define input param pAprovador    as char    no-undo.
    define input param pTipTransacao as char    no-undo. /* tipo transaá∆o efetuada
                                                           (cd1720a/cd1720a1/cd1720b/cd1720b1/cd1720c/cd1720c1)*/
    def var cAprovAltern as char no-undo.
    def var cNarrativa   as char no-undo.
    
    FIND bb-doc-pend-aprov WHERE rowid(bb-doc-pend-aprov)  = pRowDocPend no-lock no-error.

    if  bb-doc-pend-aprov.sit-aprov = yes then do:
        if  bb-doc-pend-aprov.ind-tip-aprov = 2 then do:
            if  bb-doc-pend-aprov.ind-tip-doc = 1 or
                bb-doc-pend-aprov.ind-tip-doc = 2 or
                bb-doc-pend-aprov.ind-tip-doc = 5 or
                bb-doc-pend-aprov.ind-tip-doc = 9 then do:
                /** Solicitaá∆o/Requisiá∆o/Manutená∆o Industrial **/
                for each b-doc-pend-aprov where
                    b-doc-pend-aprov.nr-requisicao = bb-doc-pend-aprov.nr-requisicao and
                    b-doc-pend-aprov.it-codigo     = bb-doc-pend-aprov.it-codigo     and
                    b-doc-pend-aprov.sequencia     = bb-doc-pend-aprov.sequencia     and
                    b-doc-pend-aprov.ind-tip-aprov = bb-doc-pend-aprov.ind-tip-aprov and
                    b-doc-pend-aprov.cod-tip-aprov = bb-doc-pend-aprov.cod-tip-aprov and
                    b-doc-pend-aprov.ind-situacao  = 1 EXCLUSIVE-LOCK:
                    
                    assign b-doc-pend-aprov.narrativa-apr    = (if pTipTransacao = "cd1720a1":U or pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then
                                                                  (if bb-doc-pend-aprov.ind-tip-aprov = 1 then
                                                                      "Aprovaá∆o realizada pelo aprovador da lista"
                                                                  else 
                                                                      "Aprovaá∆o realizada pelo n£mero m°nimo de aprovaá‰es")
                                                               else
                                                                  "Aprovaá∆o realizada pelo aprovador da lista")
                           b-doc-pend-aprov.dt-aprova        = today
                           b-doc-pend-aprov.ind-situacao     = 2
                           b-doc-pend-aprov.sit-aprov        = yes
                           b-doc-pend-aprov.cod-aprov-altern = (if pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then pAprovador else
                                                                if b-doc-pend-aprov.cod-aprov <> pAprovador then pAprovador else "":U).
                    run pi-cria-envia-e-mail-int ( 2 , rowid(b-doc-pend-aprov) ).
                end.
            end.
            else if bb-doc-pend-aprov.ind-tip-doc = 3 then do:
                /** Cotaá∆o **/
                for each b-doc-pend-aprov where
                    b-doc-pend-aprov.numero-ordem  = bb-doc-pend-aprov.numero-ordem  and
                    b-doc-pend-aprov.it-codigo     = bb-doc-pend-aprov.it-codigo     and
                    b-doc-pend-aprov.cod-emitente  = bb-doc-pend-aprov.cod-emitente  and
                    b-doc-pend-aprov.sequencia     = bb-doc-pend-aprov.sequencia     and
                    b-doc-pend-aprov.ind-tip-aprov = bb-doc-pend-aprov.ind-tip-aprov and
                    b-doc-pend-aprov.cod-tip-aprov = bb-doc-pend-aprov.cod-tip-aprov and
                    b-doc-pend-aprov.ind-situacao  = 1 EXCLUSIVE-LOCK:
                    if pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then do:
                        if bb-doc-pend-aprov.ind-tip-aprov = 1 then 
                           assign cNarrativa = "Aprovaá∆o realizada pelo aprovador da lista".
                        else 
                           assign cNarrativa = "Aprovaá∆o realizada pelo n£mero m°nimo de aprovaá‰es".
                     end.
                     else
                        assign cNarrativa = "Aprovaá∆o realizada pelo aprovador da lista".
                    if pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then
                       assign cAprovAltern = pAprovador.
                    else
                      if b-doc-pend-aprov.cod-aprov <> pAprovador then
                         assign cAprovAltern = pAprovador .
                      else assign cAprovAltern = "":U.

                    assign b-doc-pend-aprov.narrativa-apr    = cNarrativa
                           b-doc-pend-aprov.dt-aprova        = today
                           b-doc-pend-aprov.ind-situacao     = 2
                           b-doc-pend-aprov.sit-aprov        = yes
                           b-doc-pend-aprov.cod-aprov-altern = cAprovAltern.
                    run pi-cria-envia-e-mail-int ( 2 , rowid(b-doc-pend-aprov) ).
                end.
            end.
            else if bb-doc-pend-aprov.ind-tip-doc = 4 or
                    bb-doc-pend-aprov.ind-tip-doc = 6 then do:
                /** Pedido **/
                for each b-doc-pend-aprov where
                    b-doc-pend-aprov.numero-ordem  = bb-doc-pend-aprov.numero-ordem and
                    b-doc-pend-aprov.num-pedido    = bb-doc-pend-aprov.num-pedido   and
                    b-doc-pend-aprov.ind-tip-aprov = bb-doc-pend-aprov.ind-tip-aprov and
                    b-doc-pend-aprov.cod-tip-aprov = bb-doc-pend-aprov.cod-tip-aprov and
                    b-doc-pend-aprov.ind-situacao  = 1 EXCLUSIVE-LOCK:
                    
                    assign b-doc-pend-aprov.narrativa-apr    = (if pTipTransacao = "cd1720a1":U or pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then
                                                                  if bb-doc-pend-aprov.ind-tip-aprov = 1 then 
                                                                      "Aprovaá∆o realizada pelo aprovador da lista"
                                                                  else 
                                                                      "Aprovaá∆o realizada pelo n£mero m°nimo de aprovaá‰es"
                                                               else
                                                                  "Aprovaá∆o realizada pelo aprovador da lista")
                           b-doc-pend-aprov.dt-aprova        = today
                           b-doc-pend-aprov.ind-situacao     = 2
                           b-doc-pend-aprov.sit-aprov        = yes
                           b-doc-pend-aprov.cod-aprov-altern = (if pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then pAprovador
                                                               else
                                                                  if b-doc-pend-aprov.cod-aprov <> pAprovador then
                                                                     pAprovador else "":U).
                    run pi-cria-envia-e-mail-int ( 2 , rowid(b-doc-pend-aprov) ).
                end.
            end.
            else if bb-doc-pend-aprov.ind-tip-doc = 7 then do:
                /** Processo **/
                for each b-doc-pend-aprov where
                    b-doc-pend-aprov.numero-ordem  = bb-doc-pend-aprov.numero-ordem  and
                    b-doc-pend-aprov.it-codigo     = bb-doc-pend-aprov.it-codigo     and
                    b-doc-pend-aprov.cod-emitente  = bb-doc-pend-aprov.cod-emitente  and
                    b-doc-pend-aprov.sequencia     = bb-doc-pend-aprov.sequencia     and
                    b-doc-pend-aprov.ind-tip-aprov = bb-doc-pend-aprov.ind-tip-aprov and
                    b-doc-pend-aprov.cod-tip-aprov = bb-doc-pend-aprov.cod-tip-aprov and
                    b-doc-pend-aprov.int-1         = bb-doc-pend-aprov.int-1         and
                    b-doc-pend-aprov.ind-situacao  = 1 EXCLUSIVE-LOCK:
                    
                    assign b-doc-pend-aprov.narrativa-apr    = (if pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then
                                                                  if bb-doc-pend-aprov.ind-tip-aprov = 1 then 
                                                                      "Aprovaá∆o realizada pelo aprovador da lista"
                                                                  else 
                                                                      "Aprovaá∆o realizada pelo n£mero m°nimo de aprovaá‰es"
                                                               else 
                                                                  "Aprovaá∆o realizada pelo aprovador da lista")
                           b-doc-pend-aprov.dt-aprova        = today
                           b-doc-pend-aprov.ind-situacao     = 2
                           b-doc-pend-aprov.sit-aprov        = yes
                           b-doc-pend-aprov.cod-aprov-altern = (if pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then pAprovador
                                                               else
                                                                  if b-doc-pend-aprov.cod-aprov <> pAprovador then
                                                                     pAprovador else "":U).
                    run pi-cria-envia-e-mail-int ( 2 , rowid(b-doc-pend-aprov) ).
                end.
            end.
            else if bb-doc-pend-aprov.ind-tip-doc = 8 then do:
                /** Contrato **/
                for each b-doc-pend-aprov where
                    b-doc-pend-aprov.numero-ordem  = bb-doc-pend-aprov.numero-ordem  and
                    b-doc-pend-aprov.it-codigo     = bb-doc-pend-aprov.it-codigo     and
                    b-doc-pend-aprov.cod-emitente  = bb-doc-pend-aprov.cod-emitente  and
                    b-doc-pend-aprov.sequencia     = bb-doc-pend-aprov.sequencia     and
                    b-doc-pend-aprov.ind-tip-aprov = bb-doc-pend-aprov.ind-tip-aprov and
                    b-doc-pend-aprov.cod-tip-aprov = bb-doc-pend-aprov.cod-tip-aprov and
                    b-doc-pend-aprov.char-1        = bb-doc-pend-aprov.char-1        and
                    b-doc-pend-aprov.ind-situacao  = 1 EXCLUSIVE-LOCK:
                    
                    assign b-doc-pend-aprov.narrativa-apr    = "Aprovaá∆o realizada pelo aprovador da lista"
                           b-doc-pend-aprov.dt-aprova        = today
                           b-doc-pend-aprov.ind-situacao     = 2
                           b-doc-pend-aprov.sit-aprov        = yes
                           b-doc-pend-aprov.cod-aprov-altern = if b-doc-pend-aprov.cod-aprov <> pAprovador then
                                                                  pAprovador else "":U.
                    run pi-cria-envia-e-mail-int ( 2 , rowid(b-doc-pend-aprov) ).
                end.
            end.
            /**  Caraiba
            **/
            else if doc-pend-aprov.ind-tip-doc = 10 then do:
                /** Documento Contrato **/
                for each b-doc-pend-aprov where
                    b-doc-pend-aprov.ind-tip-aprov = doc-pend-aprov.ind-tip-aprov and
                    b-doc-pend-aprov.cod-tip-aprov = doc-pend-aprov.cod-tip-aprov and
                    substring(b-doc-pend-aprov.char-1,1,16) = substring(doc-pend-aprov.char-1,1,16) and
                    b-doc-pend-aprov.ind-situacao  = 1 EXCLUSIVE-LOCK:
                    
                    assign b-doc-pend-aprov.narrativa-apr    = "Aprovaá∆o realizada pelo aprovador da lista"
                           b-doc-pend-aprov.dt-aprova        = today
                           b-doc-pend-aprov.ind-situacao     = 2
                           b-doc-pend-aprov.sit-aprov        = yes
                           b-doc-pend-aprov.cod-aprov-altern = if b-doc-pend-aprov.cod-aprov <> pAprovador then
                                                                   pAprovador else "":U.
                    run pi-cria-envia-e-mail-int ( 2 , rowid(b-doc-pend-aprov) ).
                end.
            end.
            else if doc-pend-aprov.ind-tip-doc = 11 then do:
                /** Evento **/
                for each b-doc-pend-aprov where
                    b-doc-pend-aprov.ind-tip-aprov = doc-pend-aprov.ind-tip-aprov and
                    b-doc-pend-aprov.cod-tip-aprov = doc-pend-aprov.cod-tip-aprov and
                    b-doc-pend-aprov.numero-ordem  = doc-pend-aprov.numero-ordem and
                    substring(b-doc-pend-aprov.char-2,13,4) = substring(b-doc-pend-aprov.char-2,13,4) and
                    b-doc-pend-aprov.ind-situacao  = 1 EXCLUSIVE-LOCK:
                    
                    assign b-doc-pend-aprov.narrativa-apr    = "Aprovaá∆o realizada pelo aprovador da lista"
                           b-doc-pend-aprov.dt-aprova        = today
                           b-doc-pend-aprov.ind-situacao     = 2
                           b-doc-pend-aprov.sit-aprov        = yes
                           b-doc-pend-aprov.cod-aprov-altern = if b-doc-pend-aprov.cod-aprov <> pAprovador then
                                                                   pAprovador else "":U.
                    run pi-cria-envia-e-mail-int ( 2 , rowid(b-doc-pend-aprov) ).
                end.
            end.
            else if doc-pend-aprov.ind-tip-doc = 12 then do:
                /** Mediá∆o **/
                for each b-doc-pend-aprov where
                    b-doc-pend-aprov.ind-tip-aprov = doc-pend-aprov.ind-tip-aprov and
                    b-doc-pend-aprov.cod-tip-aprov = doc-pend-aprov.cod-tip-aprov and
                    b-doc-pend-aprov.numero-ordem  = doc-pend-aprov.numero-ordem and
                    substring(b-doc-pend-aprov.char-2,13,4) = substring(b-doc-pend-aprov.char-2,13,4) and
                    substring(b-doc-pend-aprov.char-2,17,5) = substring(b-doc-pend-aprov.char-2,17,5) and
                    substring(b-doc-pend-aprov.char-2,22,4) = substring(b-doc-pend-aprov.char-2,22,4) and
                    substring(b-doc-pend-aprov.char-1,1,16) = substring(b-doc-pend-aprov.char-1,1,16) and
                    b-doc-pend-aprov.ind-situacao  = 1 EXCLUSIVE-LOCK:
                    
                    assign b-doc-pend-aprov.narrativa-apr    = "Aprovaá∆o realizada pelo aprovador da lista"
                           b-doc-pend-aprov.dt-aprova        = today
                           b-doc-pend-aprov.ind-situacao     = 2
                           b-doc-pend-aprov.sit-aprov        = yes
                           b-doc-pend-aprov.cod-aprov-altern = if b-doc-pend-aprov.cod-aprov <> pAprovador then
                                                                   pAprovador else "":U.
                    run pi-cria-envia-e-mail-int ( 2 , rowid(b-doc-pend-aprov) ).
                end.
            end.
          /*****/
        end.            
    end. 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPendFaixa DBOProgram 
PROCEDURE createPendFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input param pRowDocPend   as rowid   no-undo.
    define input param plAprovSemLim  as logical no-undo.
    define input param pTipTransacao  as char    no-undo. /* tipo transaá∆o efetuada
                                                           (cd1720a/cd1720a1/cd1720b/cd1720b1/cd1720c/cd1720c1)*/

    define variable c-it-codigo   as char no-undo.
    define variable c-usuario     as char no-undo.
    define variable i-num-faixa   as inte no-undo.
    define variable c-sc-cod      as char no-undo.
    define variable i-ind-tip-doc as inte no-undo.
    define variable rChave        as rowid no-undo.

    FIND bb-doc-pend-aprov WHERE rowid(bb-doc-pend-aprov)  = pRowDocPend no-lock no-error.
    
    find first hierarquia-faixa where
        hierarquia-faixa.sc-codigo   = bb-doc-pend-aprov.sc-codigo                     and
        hierarquia-faixa.ind-tip-doc = (if pTipTransacao = "cd1720b":U or pTipTransacao = "cd1720b1":U then 
                                          bb-doc-pend-aprov.ind-tip-doc
                                       else 
                                          (if bb-doc-pend-aprov.ind-tip-doc = 6 
                                           then 4 else if bb-doc-pend-aprov.ind-tip-doc = 5
                                           then 1 else bb-doc-pend-aprov.ind-tip-doc)) and
        hierarquia-faixa.num-faixa   = bb-doc-pend-aprov.num-faixa                     and
        hierarquia-faixa.seq-aprov   = bb-doc-pend-aprov.seq-aprov                     and
        hierarquia-faixa.cod-aprov   = bb-doc-pend-aprov.cod-aprov   
        no-lock no-error.
        
    if available hierarquia-faixa and
        (((pTipTransacao = "cd1720b":U or pTipTransacao = "cd1720b1":U) and hierarquia-faixa.log-depend) or
         ((pTipTransacao <> "cd1720b":U and pTipTransacao <> "cd1720b1":U) and (hierarquia-faixa.log-depend or
         (not hierarquia-faixa.log-depend and plAprovSemLim)))) then do:
        
        assign i-num-faixa = hierarquia-faixa.num-faixa
               c-sc-cod    = hierarquia-faixa.sc-codigo.
               
        if pTipTransacao <> "cd1720a":U and pTipTransacao <> "cd1720b":U then
            assign i-ind-tip-doc = hierarquia-faixa.ind-tip-doc.
        
        cria-nova-pend-faixa:               
        for each hierarquia-faixa where               
            hierarquia-faixa.sc-codigo   = c-sc-cod                                                         and
            hierarquia-faixa.ind-tip-doc = (if pTipTransacao = "cd1720a1":U then 
                                              (if i-ind-tip-doc  = 6 then 4
                                              else i-ind-tip-doc)
                                           else if pTipTransacao = "cd1720b":U or pTipTransacao = "cd1720b1":U then 
                                              bb-doc-pend-aprov.ind-tip-doc
                                           else 
                                              (if bb-doc-pend-aprov.ind-tip-doc = 6 then 4
                                              else if bb-doc-pend-aprov.ind-tip-doc = 5 then 1
                                              else bb-doc-pend-aprov.ind-tip-doc))                             and 
            hierarquia-faixa.num-faixa   = (if pTipTransacao = "cd1720b1":U then bb-doc-pend-aprov.num-faixa  
                                            else i-num-faixa)                                               and
            hierarquia-faixa.seq-aprov   > bb-doc-pend-aprov.seq-aprov NO-LOCK:
            
            find b-aprovador where
                b-aprovador.cod-aprov = hierarquia-faixa.cod-aprov
                no-lock no-error.        
            if available b-aprovador and
                ((b-aprovador.perm-solic  and  bb-doc-pend-aprov.ind-tip-doc = 1)  or
                 (b-aprovador.perm-solic  and  bb-doc-pend-aprov.ind-tip-doc = 5)  or
                 (b-aprovador.perm-requis and  bb-doc-pend-aprov.ind-tip-doc = 2)  or
                 (b-aprovador.perm-cotac  and  bb-doc-pend-aprov.ind-tip-doc = 3)  or
                 (b-aprovador.perm-pedido and (bb-doc-pend-aprov.ind-tip-doc = 4   or 
                                               bb-doc-pend-aprov.ind-tip-doc = 6)) or
                 (b-aprovador.log-1       and  bb-doc-pend-aprov.ind-tip-doc = 7)  or
                 (b-aprovador.log-2       and  bb-doc-pend-aprov.ind-tip-doc = 8)  or
                 (b-aprovador.perm-manut  and  bb-doc-pend-aprov.ind-tip-doc = 9)) then do:
                 assign rChave = rowid(hierarquia-faixa).
                 leave cria-nova-pend-faixa.
            end.
        end.            
        find first hierarquia-faixa where rowid(hierarquia-faixa) = rChave no-lock no-error.
        if available hierarquia-faixa then do:
            /**
            ***   Gera documento pendente para pr¢ximo aprovador
            **/
            assign c-it-codigo = bb-doc-pend-aprov.it-codigo
                   c-usuario   = bb-doc-pend-aprov.cod-usuario.
            create b-doc-pend-aprov.
            assign b-doc-pend-aprov.num-faixa     = i-num-faixa
                   b-doc-pend-aprov.sc-codigo     = c-sc-cod
                   b-doc-pend-aprov.cod-aprov     = hierarquia-faixa.cod-aprov
                   b-doc-pend-aprov.aprov-total   = bb-doc-pend-aprov.aprov-total
                   b-doc-pend-aprov.cod-usuario   = c-usuario
                   b-doc-pend-aprov.cod-tip-aprov = bb-doc-pend-aprov.cod-tip-aprov
                   b-doc-pend-aprov.dt-geracao    = today
                   b-doc-pend-aprov.ind-situacao  = 1
                   b-doc-pend-aprov.ind-tip-doc   = bb-doc-pend-aprov.ind-tip-doc
                   b-doc-pend-aprov.ind-tip-aprov = (if pTipTransacao = "cd1720b1":U or pTipTransacao = "cd1720c1":U then 1 else 4)
                   b-doc-pend-aprov.seq-aprov     = hierarquia-faixa.seq-aprov
                   b-doc-pend-aprov.aprov-tec     = no
                   b-doc-pend-aprov.it-codigo     = c-it-codigo
                   b-doc-pend-aprov.int-1         = bb-doc-pend-aprov.int-1  /* processo */
                   b-doc-pend-aprov.char-1        = bb-doc-pend-aprov.char-1 /* contrato */
                   b-doc-pend-aprov.char-2        = bb-doc-pend-aprov.char-2 
                   b-doc-pend-aprov.nr-requisicao = bb-doc-pend-aprov.nr-requisicao
                   b-doc-pend-aprov.num-pedido    = bb-doc-pend-aprov.num-pedido
                   b-doc-pend-aprov.numero-ordem  = bb-doc-pend-aprov.numero-ordem
                   b-doc-pend-aprov.sequencia     = bb-doc-pend-aprov.sequencia
                   b-doc-pend-aprov.cod-emitente  = bb-doc-pend-aprov.cod-emitente.
                   
            &if defined(bf_mat_aprova_eletronica) &then
                assign b-doc-pend-aprov.prioridade = bb-doc-pend-aprov.prioridade.
            &endif                   
                   
            /**   Envia E-Mail  **/        
            run pi-cria-envia-e-mail-int ( 1 , rowid(b-doc-pend-aprov) ).
            /****/            
        end.
    end.                    
 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createPendHierarquia DBOProgram 
PROCEDURE createPendHierarquia :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input  param pRowDocPend    as rowid   no-undo.
    define input  param lAprovSemLim   as logi    no-undo.
    define input  param pTipTransacao  as char    no-undo. /* tipo transaá∆o efetuada
                                                           (cd1720a/cd1720a1/cd1720b/cd1720b1/cd1720c/cd1720c1) */
    define output param lProximoAprov  as logical no-undo.
    
    define variable c-sc-codigo  as char no-undo.
    define variable rChave       as rowid no-undo.
    define variable c-it-codigo  as char no-undo.
    define variable c-usuario    as char no-undo.
    define variable lCondicao    as logi no-undo.
    define variable lCond        as logi no-undo.
    
    FIND b-doc-pend-aprov WHERE rowid(b-doc-pend-aprov)  = pRowDocPend no-lock no-error.

    find hierarquia-aprov where
        hierarquia-aprov.sc-codigo = b-doc-pend-aprov.sc-codigo and
        hierarquia-aprov.seq-aprov = b-doc-pend-aprov.seq-aprov and
        hierarquia-aprov.cod-aprov = b-doc-pend-aprov.cod-aprov 
        no-lock no-error.
    if available hierarquia-aprov then
        CASE pTipTransacao:
            when "cd1720a":U then 
                                 if (hierarquia-aprov.log-depend or 
                                    (not hierarquia-aprov.log-depend and lAprovSemLim)) or
                                    (b-doc-pend-aprov.seq-aprov = 0 and b-doc-pend-aprov.ind-tip-doc = 5) then
                                    assign lCondicao = yes.
            when "cd1720a1":U then
                                 if (not hierarquia-aprov.log-depend and lAprovSemLim) or
                                    hierarquia-aprov.log-depend then
                                    assign lCondicao = yes.                   
            when "cd1720b":U or when "cd1720b1":U then 
                                 if hierarquia-aprov.log-depend then
                                    assign lCondicao = yes.
            when "cd1720c":U or when "cd1720c1":U then
                                 if (not hierarquia-aprov.log-depend and lAprovSemLim) or
                                    hierarquia-aprov.log-depend then
                                    assign lCondicao = yes.
        END CASE.
    if lCondicao then do:
        /**
        ***   Busca pr¢ximo aprovador da hierarquia
        **/
        assign c-sc-codigo = (if pTipTransacao <> "cd1720a":U and pTipTransacao <> "cd1720a1":U then 
                                 hierarquia-aprov.sc-codigo
                             else b-doc-pend-aprov.sc-codigo).
        cria-nova-pend-hierarquia:        
        for each hierarquia-aprov where
            hierarquia-aprov.sc-codigo = c-sc-codigo and
            hierarquia-aprov.seq-aprov > b-doc-pend-aprov.seq-aprov no-lock:
            find b-aprovador where
                b-aprovador.cod-aprov = hierarquia-aprov.cod-aprov
                no-lock no-error.
            assign lCond = no.
            if avail b-aprovador and pTipTransacao = "cd1720c" or  pTipTransacao = "cd1720c1" then
                 if b-aprovador.cod-aprov <> b-doc-pend-aprov.cod-aprov then
                     assign lCond = yes.
                 else
                    assign lCond = no.
            else assign lCond = yes.
            if available b-aprovador and
                lCond                and
                ((b-aprovador.perm-solic  and  b-doc-pend-aprov.ind-tip-doc = 1)  or
                 (b-aprovador.perm-solic  and  b-doc-pend-aprov.ind-tip-doc = 5)  or
                 (b-aprovador.perm-requis and  b-doc-pend-aprov.ind-tip-doc = 2)  or
                 (b-aprovador.perm-cotac  and  b-doc-pend-aprov.ind-tip-doc = 3)  or
                 (b-aprovador.perm-pedido and (b-doc-pend-aprov.ind-tip-doc = 4   or 
                                               b-doc-pend-aprov.ind-tip-doc = 6)) or
                 (b-aprovador.log-1       and  b-doc-pend-aprov.ind-tip-doc = 7)  or
                 (b-aprovador.log-2       and  b-doc-pend-aprov.ind-tip-doc = 8)  or
                 (b-aprovador.perm-manut  and  b-doc-pend-aprov.ind-tip-doc = 9)) then do:
                 if pTipTransacao = "cd1720a1":U or pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then
                    assign lProximoAprov = yes.
                 assign rChave = rowid(hierarquia-aprov).
                 leave cria-nova-pend-hierarquia.
            end.
        end.
        find hierarquia-aprov where rowid(hierarquia-aprov) = rChave no-lock no-error.
        if available hierarquia-aprov then do:
            /**
            ***   Gera documento pendente para pr¢ximo aprovador
            **/
            assign c-it-codigo = b-doc-pend-aprov.it-codigo
                   c-usuario   = b-doc-pend-aprov.cod-usuario.
                       
            create bb-doc-pend-aprov.
            assign bb-doc-pend-aprov.cod-aprov     = hierarquia-aprov.cod-aprov
                   bb-doc-pend-aprov.sc-codigo     = c-sc-codigo
                   bb-doc-pend-aprov.cod-usuario   = c-usuario
                   bb-doc-pend-aprov.cod-tip-aprov = b-doc-pend-aprov.cod-tip-aprov
                   bb-doc-pend-aprov.aprov-total   = b-doc-pend-aprov.aprov-total
                   bb-doc-pend-aprov.dt-geracao    = today
                   bb-doc-pend-aprov.ind-situacao  = 1
                   bb-doc-pend-aprov.ind-tip-doc   = b-doc-pend-aprov.ind-tip-doc
                   bb-doc-pend-aprov.ind-tip-aprov = 1
                   bb-doc-pend-aprov.seq-aprov     = hierarquia-aprov.seq-aprov
                   bb-doc-pend-aprov.aprov-tec     = no
                   bb-doc-pend-aprov.it-codigo     = c-it-codigo
                   bb-doc-pend-aprov.int-1         = b-doc-pend-aprov.int-1  /* processo */
                   bb-doc-pend-aprov.char-1        = b-doc-pend-aprov.char-1 /* contrato */
                   bb-doc-pend-aprov.char-2        = b-doc-pend-aprov.char-2 
                   bb-doc-pend-aprov.nr-requisicao = b-doc-pend-aprov.nr-requisicao
                   bb-doc-pend-aprov.num-pedido    = b-doc-pend-aprov.num-pedido
                   bb-doc-pend-aprov.numero-ordem  = b-doc-pend-aprov.numero-ordem
                   bb-doc-pend-aprov.sequencia     = b-doc-pend-aprov.sequencia
                   bb-doc-pend-aprov.cod-emitente  = b-doc-pend-aprov.cod-emitente.
                   
            &if defined(bf_mat_aprova_eletronica) &then
                assign bb-doc-pend-aprov.prioridade = b-doc-pend-aprov.prioridade.
            &endif                   
                   
            /**
            ***   Envia E-Mail
            **/        
            run pi-cria-envia-e-mail-int ( 1 , rowid(bb-doc-pend-aprov) ).
            /****/            
        end.
    end.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE geraProximaPrioridade DBOProgram 
PROCEDURE geraProximaPrioridade :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter pIndTipDoc    as integer no-undo.
    def input parameter pRowItRequis  as rowid   no-undo.
    def input parameter pRowDocAprov  as rowid   no-undo.
    def input parameter pTipTransacao as char    no-undo. /* tipo transaá∆o efetuada( Aprova/Rejeita/cd1720c) */
    

    find b-doc-pend-aprov where
         rowid(b-doc-pend-aprov) = pRowDocAprov no-lock no-error.

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        if b-doc-pend-aprov.prioridade > 0 then do:
            assign gi-proxima-prioridade = b-doc-pend-aprov.prioridade + 10.
            
            if pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720c1":U then
                assign gl-proxima-aprovacao  = yes.
                
            run cdp/cdapi171.p (pIndTipDoc, 1, pRowItRequis).
            find doc-pend-aprov where
                 rowid(doc-pend-aprov) = pRowDocAprov no-lock no-error.
            find b-doc-pend-aprov where
                 rowid(b-doc-pend-aprov) = pRowDocAprov no-lock no-error.            
        end.
    &endif
    
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

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-aprov":U THEN ASSIGN pFieldValue = RowObject.cod-aprov.
        WHEN "cod-aprov-altern":U THEN ASSIGN pFieldValue = RowObject.cod-aprov-altern.
        WHEN "cod-rej":U THEN ASSIGN pFieldValue = RowObject.cod-rej.
        WHEN "cod-tip-aprov":U THEN ASSIGN pFieldValue = RowObject.cod-tip-aprov.
        WHEN "cod-usuario":U THEN ASSIGN pFieldValue = RowObject.cod-usuario.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "narrativa-apr":U THEN ASSIGN pFieldValue = RowObject.narrativa-apr.
        WHEN "narrativa-rej":U THEN ASSIGN pFieldValue = RowObject.narrativa-rej.
        WHEN "sc-codigo":U THEN ASSIGN pFieldValue = RowObject.sc-codigo.
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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-aprova":U THEN ASSIGN pFieldValue = RowObject.dt-aprova.
        WHEN "dt-geracao":U THEN ASSIGN pFieldValue = RowObject.dt-geracao.
        WHEN "dt-reaprova":U THEN ASSIGN pFieldValue = RowObject.dt-reaprova.
        WHEN "dt-rejeita":U THEN ASSIGN pFieldValue = RowObject.dt-rejeita.
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
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
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
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "ind-situacao":U THEN ASSIGN pFieldValue = RowObject.ind-situacao.
        WHEN "ind-tip-aprov":U THEN ASSIGN pFieldValue = RowObject.ind-tip-aprov.
        WHEN "ind-tip-doc":U THEN ASSIGN pFieldValue = RowObject.ind-tip-doc.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-contrato":U THEN ASSIGN pFieldValue = RowObject.nr-contrato.
        WHEN "nr-requisicao":U THEN ASSIGN pFieldValue = RowObject.nr-requisicao.
        WHEN "nr-trans":U THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "num-faixa":U THEN ASSIGN pFieldValue = RowObject.num-faixa.
        WHEN "num-pedido":U THEN ASSIGN pFieldValue = RowObject.num-pedido.
        WHEN "numero-ordem":U THEN ASSIGN pFieldValue = RowObject.numero-ordem.
        WHEN "prioridade":U THEN ASSIGN pFieldValue = RowObject.prioridade.
        WHEN "seq-aprov":U THEN ASSIGN pFieldValue = RowObject.seq-aprov.
        WHEN "seq-evento":U THEN ASSIGN pFieldValue = RowObject.seq-evento.
        WHEN "seq-item":U THEN ASSIGN pFieldValue = RowObject.seq-item.
        WHEN "seq-medicao":U THEN ASSIGN pFieldValue = RowObject.seq-medicao.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice DOC-PEND-APROV-6
  Parameters:
               retorna valor dos campos do °ndice DOC-PEND-APROV-6
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-aprov LIKE doc-pend-aprov.cod-aprov NO-UNDO.
    DEFINE OUTPUT PARAMETER pind-tip-doc LIKE doc-pend-aprov.ind-tip-doc NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-aprov = RowObject.cod-aprov.
    ASSIGN pind-tip-doc = RowObject.ind-tip-doc.

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
        WHEN "aprov-auto":U THEN ASSIGN pFieldValue = RowObject.aprov-auto.
        WHEN "aprov-tec":U THEN ASSIGN pFieldValue = RowObject.aprov-tec.
        WHEN "aprov-total":U THEN ASSIGN pFieldValue = RowObject.aprov-total.
        WHEN "cot-aprovada":U THEN ASSIGN pFieldValue = RowObject.cot-aprovada.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "sit-aprov":U THEN ASSIGN pFieldValue = RowObject.sit-aprov.
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice DOC-PEND-APROV-6
  Parameters:
               recebe valor dos campos do °ndice DOC-PEND-APROV-6
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-aprov LIKE doc-pend-aprov.cod-aprov NO-UNDO.
    DEFINE INPUT PARAMETER pind-tip-doc LIKE doc-pend-aprov.ind-tip-doc NO-UNDO.

    FIND FIRST bfdoc-pend-aprov WHERE
        bfdoc-pend-aprov.cod-aprov = pcod-aprov AND
        bfdoc-pend-aprov.ind-tip-doc = pind-tip-doc
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfdoc-pend-aprov THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfdoc-pend-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitialColorsPrioridadeLetra DBOProgram 
PROCEDURE InitialColorsPrioridadeLetra :
/*------------------------------------------------------------------------------
  Purpose:    Retorna as cores padr‰es de letras cadastradas na tabela param-mat
  Parameters: 
  Notes: 
  
------------------------------------------------------------------------------*/
    def output param poCorLetraMAlta as int no-undo.
    def output param poCorLetraAlta  as int no-undo.
    def output param poCorLetraMedia as int no-undo.
    def output param poCorLetraBaixa as int no-undo.
    
    find first param-mat no-lock no-error.
    if avail param-mat then
        assign poCorLetraMAlta  = param-mat.cor-fundo-muito
               poCorLetraAlta   = param-mat.cor-fundo-alta
               poCorLetraMedia  = param-mat.cor-fundo-media
               poCorLetraBaixa  = param-mat.cor-fundo-baixa.

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
    OPEN QUERY {&QueryName} FOR EACH doc-pend-aprov NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaLimiteAprovador DBOProgram 
PROCEDURE retornaLimiteAprovador :
/*------------------------------------------------------------------------------
  Purpose: Retorna Limite para aprovacao.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input  parameter pFmCodigo    like item.fm-codigo no-undo.
def input  parameter pCodAprov    like aprovador.cod-aprov no-undo.
def input  parameter pIndTipDoc   like doc-pend-aprov.ind-tip-doc no-undo.
def input  parameter plAprovTotal as   log no-undo.
def output parameter pValorLim    like aprovador.lim-solic no-undo.
def output parameter pMoedaDes    like aprovador.mo-codigo no-undo.

    find lim-aprov-fam-mat where
         lim-aprov-fam-mat.fm-codigo = pFmCodigo and
         lim-aprov-fam-mat.cod-aprov = pCodAprov no-lock no-error.
    
    find aprovador where aprovador.cod-aprov = pCodAprov no-lock no-error.
    
    if available lim-aprov-fam-mat and
       not plAprovTotal            then do:
        case pIndTipDoc:
            when 1 then assign pValorLim = lim-aprov-fam-mat.lim-solic.
            when 2 then assign pValorLim = lim-aprov-fam-mat.lim-requis.
            when 3 then assign pValorLim = lim-aprov-fam-mat.lim-cotac.
            when 4 then assign pValorLim = lim-aprov-fam-mat.lim-pedido.
            when 5 then assign pValorLim = lim-aprov-fam-mat.lim-solic.
            when 6 then assign pValorLim = lim-aprov-fam-mat.lim-pedido.
            when 7 then assign pValorLim = lim-aprov-fam-mat.dec-1.
            when 8 then assign pValorLim = lim-aprov-fam-mat.dec-2.
            when 9 then assign pValorLim = lim-aprov-fam-mat.lim-req-manut.
 
            /**  Caraiba
            **/
            when 10 then assign pValorLim = decimal(substring(lim-aprov-fam-mat.char-1,31,15)).
            when 11 then assign pValorLim = decimal(substring(lim-aprov-fam-mat.char-1,1,15)).
            when 12 then assign pValorLim = decimal(substring(lim-aprov-fam-mat.char-1,16,15)).
            /*****/
            
        end case.
        assign pMoedaDes = lim-aprov-fam-mat.mo-codigo.
    end.
    else do:
        case pIndTipDoc:
            when 1 then assign pValorLim = aprovador.lim-solic.
            when 2 then assign pValorLim = aprovador.lim-requis.
            when 3 then assign pValorLim = aprovador.lim-cotac.
            when 4 then assign pValorLim = aprovador.lim-pedido.
            when 5 then assign pValorLim = aprovador.lim-solic.
            when 6 then assign pValorLim = aprovador.lim-pedido.
            when 7 then assign pValorLim = aprovador.dec-1.
            when 8 then assign pValorLim = aprovador.dec-2.
            when 9 then assign pValorLim = aprovador.lim-req-manut.

            /**  Caraiba
            **/
            when 10 then assign pValorLim = decimal(substring(aprovador.char-1,34,15)).
            when 11 then assign pValorLim = decimal(substring(aprovador.char-1,4,15)).
            when 12 then assign pValorLim = decimal(substring(aprovador.char-1,19,15)).
            /*****/
            
        end case.
        assign pMoedaDes = aprovador.mo-codigo.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNarrativaDocumento DBOProgram 
PROCEDURE retornaNarrativaDocumento :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

  define input  param     pRowDocPendAprov as rowid     no-undo.
  DEFINE OUTPUT PARAMETER pc-narrativa-doc AS CHARACTER NO-UNDO.

  find doc-pend-aprov where
       rowid(doc-pend-aprov) = pRowDocPendAprov NO-LOCK NO-ERROR.
  if avail doc-pend-aprov then do:
      if doc-pend-aprov.ind-tip-doc = 1 or
         doc-pend-aprov.ind-tip-doc = 2 or
         doc-pend-aprov.ind-tip-doc = 5 then do:
         find it-requisicao where
             it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
             it-requisicao.it-codigo     = doc-pend-aprov.it-codigo     and
             it-requisicao.sequencia     = doc-pend-aprov.sequencia
             no-lock no-error.
          if available it-requisicao then
             assign pc-narrativa-doc = it-requisicao.narrativa.
          else do:
             find requisicao where
                  requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao no-lock no-error.
             if avail requisicao then
                assign pc-narrativa-doc = requisicao.narrativa.
          end.   
      end.
      else
          if doc-pend-aprov.ind-tip-doc = 3 then do:
             find cotacao-item where
                  cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
                  cotacao-item.it-codigo    = doc-pend-aprov.it-codigo    and
                  cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
                  cotacao-item.seq-cotac    = doc-pend-aprov.sequencia
                  no-lock no-error.
             if available cotacao-item then
                assign pc-narrativa-doc = cotacao-item.narrativa.
          end.
          else
              if doc-pend-aprov.ind-tip-doc = 4 then do:
                 find ordem-compra where
                      ordem-compra.numero-ordem = doc-pend-aprov.numero-ordem
                      no-lock no-error.
                 if available ordem-compra then
                    assign pc-narrativa-doc = ordem-compra .narrativa.
              end.
              else
                  if doc-pend-aprov.ind-tip-doc = 9 then do:
                     find msg-solic-serv
                         where msg-solic-serv.nr-soli-serv = doc-pend-aprov.nr-requisicao
                         no-lock no-error.
                     if avail msg-solic-serv then
                        assign pc-narrativa-doc = msg-solic-serv.msg-exp.
                  end.
                  else
                      if doc-pend-aprov.ind-tip-doc = 8 then do:
                          find contrato-for where
                              &if defined(bf_mat_contratos) &then
                              contrato-for.nr-contrato = int(substring(doc-pend-aprov.char-1,1,16))
                              &else
                              contrato-for.nr-contrato = substring(doc-pend-aprov.char-1,1,16)
                              &endif
                              no-lock no-error.
                          if available contrato-for then
                              assign pc-narrativa-doc = contrato-for.narrat-contrat.
                      end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValoresDocumento DBOProgram 
PROCEDURE retornaValoresDocumento :
/*------------------------------------------------------------------------------
  Purpose: Retorna Limite, Quantidade e Valor do Documento conforme tipo de documento.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    define input  param pRowDocPend     as rowid no-undo.
    define input  param pAprovador      as char no-undo.
    define input  param pTipTransacao   as char no-undo.    
    define output param de-valor-lim    as deci no-undo.
    define output param de-valor-doc    as deci no-undo.
    define output param de-quantidade   as deci no-undo.  
    define output param c-narrativa-apr as char no-undo.
    define output param lHabNarrat      as logi no-undo.
    
    define variable de-valor-doc-aux    as deci no-undo.
    define variable c-it-codigo         as char no-undo.
    define variable c-usuario           as char no-undo.
    define variable dt-transacao        as date no-undo.
    define variable de-valor-conv       as deci no-undo.
    assign lHabNarrat = yes.
               
    FIND doc-pend-aprov WHERE rowid(doc-pend-aprov)  = pRowDocPend no-lock no-error.           

    run pi-verifica-importacao(output l-importacao).     /* Integracao Modulo Importacao */
    
    find aprovador where aprovador.cod-aprov = pAprovador no-lock no-error.
    
    find item where item.it-codigo = doc-pend-aprov.it-codigo no-lock no-error.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    
    /**  Caraiba
    **/
    if doc-pend-aprov.ind-tip-doc = 12 then do:
        find first item-contrat where
            string(item-contrat.nr-contrato) = substring(doc-pend-aprov.char-1,1,16) and
            item-contrat.num-seq-item = integer(substring(doc-pend-aprov.char-2,17,5)) 
            no-lock no-error.    
        if available item-contrat then
            find item where
                item.it-codigo = item-contrat.it-codigo
                no-lock no-error.
    end.
    /*****/
    
    if avail item then
        run retornaLimiteAprovador (item.fm-codigo, 
                                    aprovador.cod-aprov,
                                    doc-pend-aprov.ind-tip-doc,
                                    doc-pend-aprov.aprov-total,
                                    output de-valor-lim,
                                    output i-moeda-destino).
    else
        run retornaLimiteAprovador (?,
                                    aprovador.cod-aprov,
                                    doc-pend-aprov.ind-tip-doc,
                                    doc-pend-aprov.aprov-total,
                                    output de-valor-lim,
                                    output i-moeda-destino).

    if doc-pend-aprov.ind-tip-doc = 1 then do:
        /** Solicitaá∆o **/
        find requisicao where
            requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao
            no-lock no-error.
        if doc-pend-aprov.aprov-total = no then do:
            find it-requisicao where
                    it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
                    it-requisicao.sequencia     = doc-pend-aprov.sequencia 
                    no-lock no-error.
             if avail it-requisicao then do:
                 if pTipTransacao <> "cd1720b1":U then do:                                
                    run cdp/cd0812.p (0, i-moeda-destino,
                                      it-requisicao.val-item,
                                      today, output de-valor-doc).
                    if de-valor-doc = ? then
                        assign de-valor-doc = it-requisicao.val-item.                    
                 end.       

                 if pTipTransacao = "cd1720b1":U then
                    assign de-valor-doc = it-requisicao.val-item.

                 assign de-quantidade = it-requisicao.qt-requisitada.
                 
                 if it-requisicao.num-ord-inv <> 0
                 AND param-global.modulo-in then do:
                    assign c-narrativa-apr = "Aprovaá∆o para Investimento"
                           lHabNarrat      = no.
                 end.
             end.
        end.
        else do:
            assign de-valor-total = 0.
            for each it-requisicao where
                     it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao no-lock:
                assign de-valor-total = de-valor-total + it-requisicao.val-item.
            end.

            if pTipTransacao = "cd1720b1":U then
               assign de-valor-doc = de-valor-total. 
            else do:              
                run cdp/cd0812.p (0, i-moeda-destino,
                                  de-valor-total,
                                  today, output de-valor-doc).
                if de-valor-doc = ? then
                    assign de-valor-doc = de-valor-total.
                assign de-quantidade = 0.
            end.   
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 2 then do:
        /** Requisi∆o **/
        find requisicao where requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao
            no-lock no-error.
        if doc-pend-aprov.aprov-total = no then do:

            find it-requisicao where
                    it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
                    it-requisicao.sequencia     = doc-pend-aprov.sequencia
                    no-lock no-error.   
            if avail it-requisicao then do:
                if pTipTransacao = "cd1720b1":U then
                   assign de-valor-doc = it-requisicao.val-item.   
                else do:   
                    run cdp/cd0812.p (0, i-moeda-destino,
                                      it-requisicao.val-item,
                                      today, output de-valor-doc).
                    if de-valor-doc = ? then
                        assign de-valor-doc = it-requisicao.val-item.
                    assign de-quantidade = it-requisicao.qt-requisitada.
                    if it-requisicao.num-ord-inv <> 0
                    AND  param-global.modulo-in then do:
                        assign c-narrativa-apr = "Aprovaá∆o para Investimento"
                               lHabNarrat      = no.
                    end.

                end.    
            end.
        end.
        else do:
            assign de-valor-total = 0.
            for each it-requisicao where
                     it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao no-lock:
                assign de-valor-total = de-valor-total + it-requisicao.val-item.
            end.
            
            if pTipTransacao = "cd1720b1":U then
               assign de-valor-doc = de-valor-total.
            else do:     
                run cdp/cd0812.p (0, i-moeda-destino,
                                  de-valor-total,
                                  today, output de-valor-doc).
                if de-valor-doc = ? then
                   assign de-valor-doc = de-valor-total.
                   assign de-quantidade = 0.
            end.        
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 3 then do:
        /** Cotaá∆o **/
        find ordem-compra where
             ordem-compra.numero-ordem = doc-pend-aprov.numero-ordem no-lock no-error.
        find cotacao-item where
            cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
            cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
            cotacao-item.it-codigo    = doc-pend-aprov.it-codigo    and
            cotacao-item.seq-cotac    = doc-pend-aprov.sequencia    no-lock no-error.
                
        assign dt-transacao = if pTipTransacao = "cd1720b":U or pTipTransacao = "cd1720b1":U then
                                 today  
                              else      
                                 cotacao-item.data-cotacao.
                                             
        run cdp/cd0812.p (cotacao-item.mo-codigo, 
                          i-moeda-destino,
                          (ordem-compra.qt-solic * cotacao-item.preco-unit),
                          dt-transacao,
                          output de-valor-doc).
        if de-valor-doc = ? or pTipTransacao = "cd1720b1":U then
            assign de-valor-doc = (ordem-compra.qt-solic * cotacao-item.preco-unit).
        if l-importacao then do:
            run pi-desp-importacao(input rowid(cotacao-item),input ordem-compra.qt-solic,
                                   input i-moeda-destino,output de-val-despesas-aux).
            assign de-valor-doc = de-valor-doc + de-val-despesas-aux.
        end.
        assign de-quantidade = ordem-compra.qt-solic.
    end.
    else if doc-pend-aprov.ind-tip-doc = 4 or doc-pend-aprov.ind-tip-doc = 6 then do:
        /** Pedido **/
        find pedido-compr where
             pedido-compr.num-pedido = doc-pend-aprov.num-pedido
             no-lock no-error.
        if doc-pend-aprov.aprov-total = no then do:
            find ordem-compra where
                ordem-compra.numero-ordem = doc-pend-aprov.numero-ordem 
                no-lock no-error.
            find first cotacao-item where
                cotacao-item.numero-ordem = (if pTiptransacao = "cd1720a":U or pTipTransacao = "cd1720a1":U then ordem-compra.numero-ordem else doc-pend-aprov.numero-ordem) and
                cotacao-item.it-codigo    = (if pTiptransacao = "cd1720a":U or pTipTransacao = "cd1720a1":U then ordem-compra.it-codigo    else doc-pend-aprov.it-codigo)        and
                cotacao-item.cod-emitente = (if pTiptransacao = "cd1720a":U or pTipTransacao = "cd1720a1":U then ordem-compra.cod-emitente else doc-pend-aprov.cod-emitente)     and
                cotacao-item.cot-aprovada = yes 
                no-lock no-error.
            if avail cotacao-item then do:
               run cdp/cd0812.p (cotacao-item.mo-codigo, i-moeda-destino,
                                (ordem-compra.qt-solic * cotacao-item.preco-unit),
                                dt-transacao, output de-valor-doc).
               if de-valor-doc = ? or pTipTransacao = "Rejeita1" then
                  assign de-valor-doc = (ordem-compra.qt-solic * cotacao-item.preco-unit).                
            end.      
            if l-importacao then do:
                run pi-desp-importacao(input rowid(cotacao-item), 
                                       input ordem-compra.qt-solic,
                                       input i-moeda-destino,
                                       output de-val-despesas-aux).
                assign de-valor-doc = de-valor-doc + de-val-despesas-aux.
            end.
            assign de-quantidade = ordem-compra.qt-solic.
        end.
        else do:
            assign de-valor-total = 0.
            for each ordem-compra where
                     ordem-compra.num-pedido = pedido-compr.num-pedido no-lock:
                find first cotacao-item where
                           cotacao-item.numero-ordem = ordem-compra.numero-ordem   and
                           cotacao-item.it-codigo    = ordem-compra.it-codigo      and
                           cotacao-item.cod-emitente = ordem-compra.cod-emitente   and
                           cotacao-item.cot-aprovada = yes            no-lock no-error.
                if available cotacao-item then
                    if pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720c":U or pTiptransacao = "cd1720a1":U then do:   
                       run cdp/cd0812.p (cotacao-item.mo-codigo, i-moeda-destino,
                                        (ordem-compra.qt-solic * cotacao-item.preco-unit), 
                                         if pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720a1":U then today else cotacao-item.data-cotacao,
                                         output de-valor-conv).
                       if de-valor-conv = ? then
                          assign de-valor-conv = ordem-compra.qt-solic * cotacao-item.preco-unit.                                                  
                       assign de-valor-total = de-valor-total + de-valor-conv.                  
                    end.   
                    else                
                       assign de-valor-total = de-valor-total + (ordem-compra.qt-solic * cotacao-item.preco-unit).
                    
                if l-importacao then do: 
                    run pi-desp-importacao(input rowid(cotacao-item),
                                           input ordem-compra.qt-solic,
                                           if pTipTransacao = "cd1720a1":U or pTipTransacao = "cd1720c":U then cotacao-item.mo-codigo else i-moeda-destino,
                                           output de-val-despesas-aux).
                    assign de-valor-total = de-valor-total + de-val-despesas-aux.
                end.
            end. 
            if (pTipTransacao = "cd1720b":U or pTipTransacao = "cd1720b1":U) and avail cotacao-item  then do:           
               run cdp/cd0812.p (cotacao-item.mo-codigo, 
                                 i-moeda-destino,
                                 de-valor-total, 
                                 today, 
                                 output de-valor-doc).
               if de-valor-doc = ? or pTipTransacao = "cd1720b1":U then
                   assign de-valor-doc = de-valor-total.
            end.                          
            assign de-quantidade = 0.
        end.                                   
    end.
    else if doc-pend-aprov.ind-tip-doc = 5 then do:
        /** Solicitaá∆o de Cotaá∆o **/
        find requisicao where
            requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao
            no-lock no-error.
        if ((doc-pend-aprov.aprov-total = no) and (pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720a1":U or pTipTransacao = "cd1720c1":U)) or (pTipTransacao = "cd1720b":U) or (pTipTransacao = "cd1720b1":U) then do:
            find it-requisicao where
                 it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
                 it-requisicao.sequencia     = doc-pend-aprov.sequencia
                 no-lock no-error.                 
            run cdp/cd0812.p (0, 
                              i-moeda-destino, 
                              if pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720a1":U or pTipTransacao = "cd1720b1":U then it-requisicao.val-item else de-valor-total, 
                              today, 
                              output de-valor-doc).
            if avail it-requisicao then do:
                if de-valor-doc = ? or pTipTransacao = "cd1720b1":U then 
                    assign de-valor-doc = it-requisicao.val-item.
                assign de-quantidade = it-requisicao.qt-requisitada.
                if it-requisicao.num-ord-inv <> 0 
                AND  param-global.modulo-in then do:
                    assign c-narrativa-apr = "Aprovaá∆o para Investimento"
                           lHabNarrat      = no.
                end.
             end.
        end.        
        else if pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720c":U or pTipTransacao = "cd1720a1":U or pTipTransacao = "cd1720c1":U then do:
            assign de-valor-total = 0.
            for each it-requisicao where
                     it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao no-lock:
                assign de-valor-total = de-valor-total + it-requisicao.val-item.
            end.
            if pTipTransacao = "cd1720a1":U then do:
                find it-requisicao where
                     it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
                     it-requisicao.sequencia     = doc-pend-aprov.sequencia
                     no-lock no-error.                 
                if avail it-requisicao then
                    de-valor-total = it-requisicao.val-item.
            end.
            
            run cdp/cd0812.p (0,
                              i-moeda-destino,
                              de-valor-total,
                              today,
                              output de-valor-doc).
            if de-valor-doc = ? then
                assign de-valor-doc = de-valor-total.
            assign de-quantidade = 0.
        end.
    end.
    else
        /* BRAVO*/
        RUN retornaValoresDocumento-aux( INPUT pTipTransacao,    OUTPUT de-valor-doc, OUTPUT de-quantidade, 
                                         INPUT de-valor-doc-aux, INPUT c-it-codigo,   INPUT c-usuario,      INPUT dt-transacao).
    
END PROCEDURE.

&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaValoresDocumento-aux DBOProgram 
PROCEDURE retornaValoresDocumento-aux :
    
    define input  param pTipTransacao   as char no-undo.  
    define output param de-valor-doc    as deci no-undo. 
    define output param de-quantidade   as deci no-undo. 
    
    define input  param de-valor-doc-aux    as deci no-undo. 
    define input  param c-it-codigo         as char no-undo. 
    define input  param c-usuario           as char no-undo. 
    define input  param dt-transacao        as date no-undo. 

    if doc-pend-aprov.ind-tip-doc = 7 then do:
        /** Processo **/
        if ((doc-pend-aprov.aprov-total = no) and (pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720a1":U)) or (pTipTransacao = "cd1720b":U) or (pTipTransacao = "cd1720c":U) or (pTipTransacao = "cd1720c1":U) then do:
            find ordem-compra where
                 ordem-compra.numero-ordem = doc-pend-aprov.numero-ordem and
                 ordem-compra.nr-processo  = doc-pend-aprov.int-1
                 no-lock no-error.
            find cotacao-item where
                 cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
                 cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
                 cotacao-item.it-codigo    = ordem-compra.it-codigo      and
                 cotacao-item.seq-cotac    = doc-pend-aprov.sequencia
                 no-lock no-error.
            run cdp/cd0812.p (cotacao-item.mo-codigo,
                              i-moeda-destino,
                              (ordem-compra.qt-solic * cotacao-item.preco-unit),
                              if pTipTransacao = "cd1720c":U then today else dt-transacao, output de-valor-doc).
            if de-valor-doc = ? or pTipTransacao = "cd1720b1" then
                assign de-valor-doc = (ordem-compra.qt-solic * cotacao-item.preco-unit).
            if l-importacao then do: 
                run pi-desp-importacao(input rowid(cotacao-item),
                                       input ordem-compra.qt-solic,
                                       input if pTipTransacao = "cd1720b1":U then cotacao-item.mo-codigo else i-moeda-destino,
                                       output de-val-despesas-aux).
                assign de-valor-doc = de-valor-doc + de-val-despesas-aux.
            end.
            assign de-quantidade = ordem-compra.qt-solic.
        end.
        else if pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720a1":U then do:
            assign de-valor-doc = 0.
            for each ordem-compra field (numero-ordem nr-processo qt-solic) 
                where ordem-compra.nr-processo  = doc-pend-aprov.int-1 no-lock:
                for first cotacao-item field (numero-ordem int-1 mo-codigo preco-unit)
                    where cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem
                    and   cotacao-item.log-1 no-lock:
                    run cdp/cd0812.p (cotacao-item.mo-codigo,
                                      i-moeda-destino,
                                      (ordem-compra.qt-solic * cotacao-item.preco-unit),
                                      if pTipTransacao = "cd1720":U then today else cotacao-item.data-cotacao, 
                                      output de-valor-doc-aux).
                    if  de-valor-doc-aux = ? then
                        assign de-valor-doc-aux = (ordem-compra.qt-solic * cotacao-item.preco-unit).                            
                    if l-importacao then do:
                        run pi-desp-importacao(input rowid(cotacao-item),
                                               input ordem-compra.qt-solic,
                                               input i-moeda-destino,
                                               output de-val-despesas-aux).
                        assign de-valor-doc-aux = de-valor-doc-aux + de-val-despesas-aux.
                    end.
                    assign de-quantidade = ordem-compra.qt-solic
                           de-valor-doc = de-valor-doc + de-valor-doc-aux.
                end.
            end.
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 8 then do:
        /** Contrato **/
        find first item-contrat where &if defined(bf_mat_contratos) &then
                                      item-contrat.nr-contrato  = int(doc-pend-aprov.char-1)  and
                                      &else
                                      item-contrat.nr-contrato  = doc-pend-aprov.char-1    and
                                      &endif
                                      item-contrat.num-seq-item = doc-pend-aprov.sequencia
                   no-lock no-error.
        if available item-contrat
        then do:
            if pTipTransacao <> "cd1720b1":U then do:
                run cdp/cd0812.p (item-contrat.mo-codigo, i-moeda-destino,
                                  item-contrat.val-total,
                                  today, output de-valor-doc).
                if de-valor-doc = ? then
                    assign de-valor-doc = item-contrat.val-total.
            end.        
            assign c-it-codigo = item-contrat.it-codigo
                   c-usuario   = item-contrat.cod-comprado
                   de-quantidade = item-contrat.qtd-total.
        end.
        else do:
            assign de-valor-total = 0.
            for each ordem-compra where 
                     &if defined(bf_mat_contratos) &then
                     ordem-compra.nr-contrato  = int(doc-pend-aprov.char-1)     and
                     &else
                     ordem-compra.nr-contrato  = doc-pend-aprov.char-1       and
                     &endif
                     ordem-compra.numero-ordem = doc-pend-aprov.numero-ordem no-lock:
                find first cotacao-item where
                           cotacao-item.numero-ordem = ordem-compra.numero-ordem and
                           cotacao-item.cot-aprovada = yes
                     no-lock no-error.
                if available cotacao-item
                then do:
                    assign c-it-codigo    = ordem-compra.it-codigo
                           c-usuario      = if pTipTransacao = "cd1720b1":U then substring(ordem-compra.char-1,1,12) else ordem-compra.cod-comprado
                           de-valor-total = de-valor-total + 
                                           (ordem-compra.qt-solic * cotacao-item.preco-unit).
                    if l-importacao and pTipTransacao <> "cd1720b1":U then do:
                        run pi-desp-importacao(input rowid(cotacao-item),
                                               input ordem-compra.qt-solic,
                                               input if pTipTransacao = "cd1720c1":U then cotacao-item.mo-codigo else i-moeda-destino,
                                               output de-val-despesas-aux).
                        assign de-valor-total = de-valor-total + de-val-despesas-aux.
                    end.                                           
                end.                                           
            end.
            run cdp/cd0812.p (cotacao-item.mo-codigo, 
                              i-moeda-destino,
                              de-valor-total,
                              today, 
                              output de-valor-doc).
            if de-valor-doc = ? or pTipTransacao = "cd1720b1":U then
                assign de-valor-doc = de-valor-total.
            assign de-quantidade = 0.
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 9 then do:
        /** Manutená∆o Industrial **/
        find first param-mi no-lock no-error.
        find solic-serv where
             solic-serv.nr-soli-serv = doc-pend-aprov.nr-requisicao no-lock no-error.
        assign c-it-codigo    = param-mi.it-codigo
               c-usuario      = solic-serv.nome-usua.
               
        if pTipTransacao = "cd1720b1":U then
           assign de-valor-total = vl-orcado-mob + vl-orcado-mat
                  de-valor-doc   = de-valor-total.       
        else do:          
            if doc-pend-aprov.aprov-total = no or ptipTransacao = "cd1720a1":U or pTipTransacao = "cd1720c1":U
            then do:
                run cdp/cd0812.p (0, 
                                  i-moeda-destino,
                                  if pTipTransacao = "cd1720a1":U then (vl-orcado-mat + vl-orcado-mob) else (solic-serv.vl-orcado-mat + solic-serv.vl-orcado-mob),
                                  today, 
                                  output de-valor-doc).
                if de-valor-doc = ? then
                    assign de-valor-doc = (solic-serv.vl-orcado-mat + solic-serv.vl-orcado-mob).
                if pTipTransacao = "cd1720c1" then
                    assign de-valor-total = de-valor-doc.    
                    
            end.
            else do:
                assign de-valor-total = 0
                       de-quantidade  = 0
                       de-valor-total = solic-serv.vl-orcado-mat +
                                        solic-serv.vl-orcado-mob.
                run cdp/cd0812.p (0, 
                                  i-moeda-destino,
                                  de-valor-total,
                                  today, 
                                  output de-valor-doc).
                if de-valor-doc = ? then
                    assign de-valor-doc = de-valor-total.
                assign de-quantidade = 0.
            end.
        end.     
    end.
    
    /**  Caraiba
    **/
    if doc-pend-aprov.ind-tip-doc = 10 then do:
        /**
        ***   Documento Contrato
        **/
        find contrato-for where
            integer(contrato-for.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16))
            no-lock no-error.
        if available contrato-for
        then do:
            assign de-valor-total = contrato-for.dec-2.
            run cdp/cd0812.p (contrato-for.mo-codigo,
                              i-moeda-destino,
                              de-valor-total,
                              today,
                              output de-valor-doc).
            if de-valor-doc = ? then
                assign de-valor-doc = de-valor-total.
        end.
        else do:
            assign de-valor-doc = 0.
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 11 then do:
        /**
        ***   Evento
        **/
        if doc-pend-aprov.aprov-total = no then do:
            find evento-ped where
                evento-ped.numero-ordem = doc-pend-aprov.numero-ordem and
                evento-ped.seq-evento = integer(substring(doc-pend-aprov.char-2,13,4)) 
                no-lock no-error.
            if available evento-ped then do:
                find contrato-for where
                    integer(contrato-for.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16))
                    no-lock no-error.
                find first item-contrat where
                    integer(item-contrat.nr-contrato) = integer(contrato-for.nr-contrato)
                    no-lock no-error.
                assign de-valor-total = evento-ped.val-previsto.
                run cdp/cd0812.p (item-contrat.mo-codigo,
                                  i-moeda-destino,
                                  de-valor-total,
                                  today, 
                                  output de-valor-doc).
                if de-valor-doc = ? then
                    assign de-valor-doc = de-valor-total.
            end.
        end.
        else do:
            assign de-valor-total = 0.
            for each evento-ped where
                evento-ped.numero-ordem = doc-pend-aprov.numero-ordem and
                evento-ped.seq-evento = integer(substring(doc-pend-aprov.char-2,13,4)) and
                evento-ped.ind-sit-event = 1
                no-lock:
                find contrato-for where
                    integer(contrato-for.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16))
                    no-lock no-error.
                find first item-contrat where
                    integer(item-contrat.nr-contrato) = integer(contrato-for.nr-contrato)
                    no-lock no-error.
                assign de-valor-total = de-valor-total + evento-ped.val-previsto.
            end.
            run cdp/cd0812.p (item-contrat.mo-codigo,
                              i-moeda-destino,
                              de-valor-total,
                              today, 
                              output de-valor-doc).
            if de-valor-doc = ? then
                assign de-valor-doc = de-valor-total.
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 12 then do:
        /**
        ***   Mediá∆o
        **/
        if doc-pend-aprov.aprov-total = no then do:
            find first medicao-contrat where
                integer(medicao-contrat.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16)) and
                medicao-contrat.numero-ordem = doc-pend-aprov.numero-ordem and            
                medicao-contrat.num-seq-item = integer(substring(doc-pend-aprov.char-2,17,5)) and
                medicao-contrat.num-seq-event = integer(substring(doc-pend-aprov.char-2,13,4)) and
                medicao-contrat.num-seq-medicao = integer(substring(doc-pend-aprov.char-2,22,4))
                no-lock no-error.
            if available medicao-contrat then do:
                find contrato-for where
                    integer(contrato-for.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16))
                    no-lock no-error.
                find first item-contrat where
                    integer(item-contrat.nr-contrato) = integer(contrato-for.nr-contrato)
                    no-lock no-error.
                assign de-valor-total = medicao-contrat.val-medicao.
                run cdp/cd0812.p (item-contrat.mo-codigo,
                                  i-moeda-destino,
                                  de-valor-total,
                                  today, 
                                  output de-valor-doc).
                if de-valor-doc = ? then
                    assign de-valor-doc = de-valor-total.
            end.
        end.
        else do:
            assign de-valor-total = 0.
            for each medicao-contrat where
                integer(medicao-contrat.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16)) and
                medicao-contrat.numero-ordem = doc-pend-aprov.numero-ordem and            
                /**  Jackson
                medicao-contrat.num-seq-item = integer(substring(doc-pend-aprov.char-2,17,4)) and
                *****/
                medicao-contrat.num-seq-event = integer(substring(doc-pend-aprov.char-2,13,4)) and
                medicao-contrat.ind-sit-medicao = 1 no-lock:
                find contrato-for where
                    integer(contrato-for.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16))
                    no-lock no-error.
                find first item-contrat where
                    integer(item-contrat.nr-contrato) = integer(contrato-for.nr-contrato) and
                    item-contrat.num-seq-item         = medicao-contrat.num-seq-item
                    no-lock no-error.
                if item-contrat.ind-caract-item = 1 then
                    assign de-valor-total = de-valor-total + medicao-contrat.val-medicao.
                else
                    assign de-valor-total = de-valor-total - medicao-contrat.val-medicao.
            end.
            run cdp/cd0812.p (item-contrat.mo-codigo,
                              i-moeda-destino,
                              de-valor-total,
                              today, 
                              output de-valor-doc).
            if de-valor-doc = ? then
                assign de-valor-doc = de-valor-total.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnHtmlColor DBOProgram 
PROCEDURE returnHtmlColor :
/*------------------------------------------------------------------------------
  Purpose:    Recebe o n£mero da cor do progress e retorna a cor correspondente para p†ginas
              Html no formato Hexadecimal.
  Parameters: ipar1   -  piProgressColor  - Nr Cor Progress(inteiro)
              opar1   -  pcHtmlColor      - Cor Html (Hexa)
  Notes: 
  
------------------------------------------------------------------------------*/    
    
    define input  param piProgressColor as integer no-undo.
    define output param pcHtmlColor     as char    no-undo.
    
    case piProgressColor:
        when 0 then 
            pcHtmlColor = "#000000".
        when 1 then 
            pcHtmlColor = "#000066".
        when 2 then 
            pcHtmlColor = "#006600".
        when 3 then 
            pcHtmlColor = "#006666".
        when 4 then 
            pcHtmlColor = "#800000".
        when 5 then 
            pcHtmlColor = "#660066".
        when 6 then 
            pcHtmlColor = "#996600".
        when 7 then 
            pcHtmlColor = "#666666".
        when 8 then 
            pcHtmlColor = "#999999".
        when 9 then 
            pcHtmlColor = "#0000ff".
        when 10 then 
            pcHtmlColor = "#00ff00".                                                
        when 11 then 
            pcHtmlColor = "#00ffff".                                                
        when 12 then 
            pcHtmlColor = "#ff0000".                                                
        when 13 then 
            pcHtmlColor = "#ff00ff".                                                
        when 14 then 
            pcHtmlColor = "#ffff00". 
        when 15 then 
            pcHtmlColor = "#ffffff".                      
    end case.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnLimiteAprovador DBOProgram 
PROCEDURE returnLimiteAprovador :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    def input  parameter pFmCodigo  like item.fm-codigo.
    def input  parameter pCodAprov  like aprovador.cod-aprov.
    def input  parameter pIndTipDoc like doc-pend-aprov.ind-tip-doc.
    def output parameter pValorLim  like aprovador.lim-solic.
    def output parameter pMoedaDes  like aprovador.mo-codigo.
    
    find lim-aprov-fam-mat where
         lim-aprov-fam-mat.fm-codigo = pFmCodigo and
         lim-aprov-fam-mat.cod-aprov = pCodAprov no-lock no-error.
    if  available lim-aprov-fam-mat and
        doc-pend-aprov.aprov-total = no then do:
        case pIndTipDoc:
            when 1 then assign pValorLim = lim-aprov-fam-mat.lim-solic.
            when 2 then assign pValorLim = lim-aprov-fam-mat.lim-requis.
            when 3 then assign pValorLim = lim-aprov-fam-mat.lim-cotac.
            when 4 then assign pValorLim = lim-aprov-fam-mat.lim-pedido.
            when 5 then assign pValorLim = lim-aprov-fam-mat.lim-solic.
            when 6 then assign pValorLim = lim-aprov-fam-mat.lim-pedido.
            when 7 then assign pValorLim = lim-aprov-fam-mat.dec-1.
            when 8 then assign pValorLim = lim-aprov-fam-mat.dec-2.
            when 9 then assign pValorLim = lim-aprov-fam-mat.lim-req-manut.
        end case.
        assign pMoedaDes = lim-aprov-fam-mat.mo-codigo.
    end.
    else do:            
        case pIndTipDoc:
            when 1 then assign pValorLim = aprovador.lim-solic.
            when 2 then assign pValorLim = aprovador.lim-requis.
            when 3 then assign pValorLim = aprovador.lim-cotac.
            when 4 then assign pValorLim = aprovador.lim-pedido.
            when 5 then assign pValorLim = aprovador.lim-solic.
            when 6 then assign pValorLim = aprovador.lim-pedido.
            when 7 then assign pValorLim = aprovador.dec-1.
            when 8 then assign pValorLim = aprovador.dec-2.
            when 9 then assign pValorLim = aprovador.lim-req-manut.
        end case.
        assign pMoedaDes = aprovador.mo-codigo.                    
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaAprovacaoDocumento DBOProgram 
PROCEDURE salvaAprovacaoDocumento :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input param pRowDocPend   as rowid   no-undo.
    define input param lSitAprov     as logical no-undo.
    define input param pAprovador    as char    no-undo.
    define input param pAprovSemLim  as logi    no-undo.
    define input param pTipTransacao as char    no-undo. /* tipo transaá∆o efetuada( cd1720a(1)/cd1720c) */    
    
    define variable l-alternativo   as logical no-undo.
    define variable l-pendente      as logical no-undo.
    define variable l-pendente-var  as logical no-undo.
    define variable l-prox-aprov    as logical no-undo.
 
    FIND doc-pend-aprov WHERE rowid(doc-pend-aprov)  = pRowDocPend exclusive-lock no-error.
    
    FIND FIRST RowObject no-lock no-error.   

    FIND FIRST param-global NO-LOCK NO-ERROR.

    assign l-alternativo = if doc-pend-aprov.cod-aprov <> pAprovador then yes else no.
    
    assign doc-pend-aprov.narrativa-apr    = RowObject.narrativa-apr
           doc-pend-aprov.dt-aprova        = today
           doc-pend-aprov.ind-situacao     = if (pTipTransacao = "cd1720a":U  or
                                                 pTipTransacao = "cd1720a1":U) then 2 else 4
           doc-pend-aprov.sit-aprov        = lSitAprov
           doc-pend-aprov.cod-aprov-altern = if l-alternativo then pAprovador else "":U.

    
    
    if pTipTransacao = "cd1720c1":U then
        find it-requisicao where
             it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
             it-requisicao.sequencia     = doc-pend-aprov.sequencia     and
             it-requisicao.it-codigo     = doc-pend-aprov.it-codigo     no-lock no-error.

    if pTipTransacao <> "cd1720a1":U and pTipTransacao <> "cd1720c1":U then do:
        if doc-pend-aprov.ind-tip-doc = 9 then do:
           find msg-solic-serv
               where msg-solic-serv.nr-soli-serv = doc-pend-aprov.nr-requisicao
               EXCLUSIVE-LOCK no-error.
           if avail msg-solic-serv then
              assign msg-solic-serv.msg-exp = doc-pend-aprov.narrativa-apr.
        end.
    end.
    else
        if pTipTransacao              =  "cd1720c1":U and 
           doc-pend-aprov.ind-tip-doc =  2            and 
           it-requisicao.num-ord-inv  <> 0            AND 
           param-global.modulo-in then
              assign doc-pend-aprov.narrativa-apr = "Aprovaá∆o para Investimento".

    FIND CURRENT doc-pend-aprov NO-LOCK NO-ERROR.            

    if lSitAprov and doc-pend-aprov.ind-tip-doc = 3 then do:
      for each bb-doc-pend-aprov where bb-doc-pend-aprov.it-codigo    =  doc-pend-aprov.it-codigo 
                                  and bb-doc-pend-aprov.numero-ordem =  doc-pend-aprov.numero-ordem
                                  and bb-doc-pend-aprov.cod-emitente <> doc-pend-aprov.cod-emitente          
                                  and bb-doc-pend-aprov.ind-situacao = 1
                                  and bb-doc-pend-aprov.ind-tip-doc  = 3 EXCLUSIVE-LOCK:
         delete bb-doc-pend-aprov.
      end.
    end.
    
    /* Cria nova pendància para pr¢ximo aprovador da hierarquia */
    if doc-pend-aprov.ind-tip-aprov = 1 then
        run createPendHierarquia (rowid(doc-pend-aprov),
                                  pAprovSemLim,
                                  pTipTransacao,
                                  output l-prox-aprov).
    /* Cria nova pendància para pr¢ximo aprovador da faixa */
    if doc-pend-aprov.ind-tip-aprov = 4 then
        run createPendFaixa (rowid(doc-pend-aprov),
                             pAprovSemLim,
                             pTipTransacao).

    
    FIND doc-pend-aprov WHERE rowid(doc-pend-aprov)  = pRowDocPend no-lock no-error.
                             
    /*  Aprova documentos pendentes da lista */
    run aprovaListaDocumentos (rowid(doc-pend-aprov),
                               pAprovador,
                               pTipTransacao).
    if pTipTransacao = "cd1720c":U then
        run pi-cria-envia-e-mail-int (4, rowid(doc-pend-aprov)). /** Envia e-mail  **/

    /* Aprovaá∆o do Documento principal */
    assign l-pendente = no.
    if  doc-pend-aprov.ind-tip-doc  = 1 or
        doc-pend-aprov.ind-tip-doc = 2 or
        doc-pend-aprov.ind-tip-doc = 5 then do:
        /* Aprovaá∆o  Solic. Requisiá∆o Solic.Cotaá∆o */

        find first param-compra no-lock no-error.
        if  ((doc-pend-aprov.ind-tip-doc = 1 and  substring(param-compra.char-2,1,3) = "sim") or     
            (doc-pend-aprov.ind-tip-doc = 2 and  substring(param-compra.char-2,4,3) = "sim")) and 
            (pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720a1":U or pTipTransacao = "cd1720c1":U) then do:
            for each  it-requisicao 
                where it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao no-lock:
                run cdp/cdapi172.p (doc-pend-aprov.ind-tip-doc,
                                    rowid(it-requisicao),
                                    output l-pendente).
                if l-pendente then leave.
            end.
        end.
        else do:
            if  (doc-pend-aprov.ind-tip-doc = 1 or
                doc-pend-aprov.ind-tip-doc = 2) then do:
                find it-requisicao where
                     it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
                     it-requisicao.sequencia     = doc-pend-aprov.sequencia     and
                     it-requisicao.it-codigo     = doc-pend-aprov.it-codigo     no-lock no-error.
                if  avail it-requisicao then do:
                    run cdp/cdapi172.p (doc-pend-aprov.ind-tip-doc,
                                        rowid(it-requisicao),
                                        output l-pendente).
                    if not l-pendente then do:
                        run geraProximaPrioridade (doc-pend-aprov.ind-tip-doc, 
                                                   rowid(it-requisicao), 
                                                   rowid(doc-pend-aprov),
                                                   pTipTransacao).
                        
                        run cdp/cdapi172.p (doc-pend-aprov.ind-tip-doc,
                                            rowid(it-requisicao),
                                            output l-pendente).
                    end.
                end.                
            end.
        end.
        if pTipTransacao <> "cd1720a1":U then do:
            if  doc-pend-aprov.ind-tip-doc = 5 and
                doc-pend-aprov.numero-ordem <> 0 then
            for each it-requisicao where
                it-requisicao.numero-ordem = doc-pend-aprov.numero-ordem no-lock:
                run cdp/cdapi172.p (doc-pend-aprov.ind-tip-doc,
                                    rowid(it-requisicao),
                                    output l-pendente).
                if not l-pendente then do:
                    run geraProximaPrioridade(5, 
                                              rowid(it-requisicao), 
                                              rowid(doc-pend-aprov),
                                              pTipTransacao).

                    run cdp/cdapi172.p (doc-pend-aprov.ind-tip-doc,
                                        rowid(it-requisicao),
                                        output l-pendente).
                end.
                if l-pendente = yes then leave.
            end.
        end.        
        /*  Verifica variaá∆o preáo*/
        &if defined(bf_mat_aprova_eletronica) &then
            if doc-pend-aprov.ind-tip-doc = 1 and not l-pendente then do:
                assign l-pendente-var = yes.
                find first cotacao-item where   
                    cotacao-item.it-codigo    = it-requisicao.it-codigo    and
                    cotacao-item.numero-ordem = it-requisicao.numero-ordem and
                    cotacao-item.log-1        = yes
                    exclusive-lock no-error.
                if available cotacao-item then do:
                    run cdp/cdapi172.p (3,rowid(cotacao-item),output l-pendente-var).
                    if not l-pendente-var then do:
                        {cdp/cd1720a.i} /* Aprovaá∆o da Cotaá∆o */
                        release cotacao-item.
                    end.
                end.
            end.                                     
        &endif
        find requisicao where
            requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao no-lock no-error.
        if  doc-pend-aprov.ind-tip-doc = 5 then do:
            /* Passa a ordem de compra da solicitaá∆o de cotaá∆o para Expectativa de compra = NO*/
            if available requisicao and
                requisicao.tp-requis = 3 then do:
                find it-requisicao where
                     it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
                     it-requisicao.sequencia     = doc-pend-aprov.sequencia     
                     no-lock no-error.
                
                if  avail it-requisicao then do:
                    find first b-doc-pend-aprov where
                        b-doc-pend-aprov.ind-tip-doc   = 5                           and
                        b-doc-pend-aprov.nr-requisicao = it-requisicao.nr-requisicao and
                        b-doc-pend-aprov.it-codigo     = it-requisicao.it-codigo     and
                        b-doc-pend-aprov.sequencia     = it-requisicao.sequencia     and
                      ((b-doc-pend-aprov.ind-situacao  = 1  or 
                        b-doc-pend-aprov.ind-situacao  = 3) or
                       (b-doc-pend-aprov.ind-situacao  = 2  and b-doc-pend-aprov.sit-aprov = no))
                        no-lock no-error.
                    
                    if  not available b-doc-pend-aprov then 
                        find ordem-compra where
                            ordem-compra.numero-ordem = it-requisicao.numero-ordem
                            exclusive-lock no-error.
                    if  available ordem-compra then do:
                        assign ordem-compra.expectativa = no.
                        find current ordem-compra no-lock no-error.
                    end.
                end.
            end.
        end.
        if not l-pendente then do:
            if available requisicao then do:
                find current requisicao exclusive-lock no-error.
                assign requisicao.estado = 1
                       requisicao.nome-aprov = doc-pend-aprov.cod-aprov.
                find current requisicao no-lock no-error.
                /*  Controle por item da solicitaá∆o*/
                &if defined(bf_mat_aprova_eletronica) &then
                    if doc-pend-aprov.aprov-total then do:
                        for each it-requisicao where
                            it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao EXCLUSIVE-LOCK:
                            assign it-requisicao.estado = 1
                                   it-requisicao.nome-aprov = doc-pend-aprov.cod-aprov.
                        end.
                    end.
                    else do:
                        find it-requisicao where
                            it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
                            it-requisicao.sequencia     = doc-pend-aprov.sequencia 
                            exclusive-lock no-error.
                        if available it-requisicao then do:
                            assign it-requisicao.estado     = 1
                                   it-requisicao.nome-aprov = doc-pend-aprov.cod-aprov.
                        end.                    
                        release it-requisicao.
                    end.     
                    if  can-find (first it-requisicao where
                        it-requisicao.nr-requisicao = doc-pend-aprov.nr-requisicao and
                        it-requisicao.estado = 2) then do:
                        find current requisicao exclusive-lock no-error.
                        assign requisicao.estado = 2.                   
                        find current requisicao no-lock no-error.                    
                    end.
                &endif
                if doc-pend-aprov.ind-tip-doc = 1 then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-solicitacao AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Solicitaá∆o" *}
                    ASSIGN c-lbl-liter-solicitacao = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15596"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION" 
                                        &ErrorParameters="c-lbl-liter-solicitacao"}            
                end.
                else                       
                if doc-pend-aprov.ind-tip-doc = 2 then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-requisicao AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Requisiá∆o" *}
                    ASSIGN c-lbl-liter-requisicao = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15596"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION" 
                                        &ErrorParameters="c-lbl-liter-requisicao"}                 
                end.
                else
                if doc-pend-aprov.ind-tip-doc = 5 then do: 
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-solicitacao-de-cotacao AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Solicitaá∆o_de_Cotaá∆o" *}
                    ASSIGN c-lbl-liter-solicitacao-de-cotacao = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15596"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION" 
                                        &ErrorParameters="c-lbl-liter-solicitacao-de-cotacao"}
                end.
            end.                
        end.
    end.                   
    else if doc-pend-aprov.ind-tip-doc  = 3 then do:
        if pTipTransacao = "cd1720a1":U  or pTipTransacao = "Rejeita1":U then
            assign l-pendente = no.
        find cotacao-item where
            cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
            cotacao-item.it-codigo    = doc-pend-aprov.it-codigo    and
            cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
            cotacao-item.seq-cotac    = doc-pend-aprov.sequencia
            no-lock no-error.
        run cdp/cdapi172.p (3,rowid(cotacao-item),output l-pendente).
        if not l-pendente then do:
            run geraProximaPrioridade(3, 
                                      rowid(cotacao-item), 
                                      rowid(doc-pend-aprov),
                                      pTipTransacao).        
            run cdp/cdapi172.p (3, rowid(cotacao-item), output l-pendente).
        end.
        if  not l-pendente then do:            
            find cotacao-item where
                cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
                cotacao-item.it-codigo    = doc-pend-aprov.it-codigo    and
                cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
                cotacao-item.seq-cotac    = doc-pend-aprov.sequencia
                exclusive-lock no-error.
            {cdp/cd1720a.i} /* Aprovaá∆o da Cotaá∆o */
            find cotacao-item where
                cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
                cotacao-item.it-codigo    = doc-pend-aprov.it-codigo    and
                cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
                cotacao-item.seq-cotac    = doc-pend-aprov.sequencia
                no-lock no-error.
            if cotacao-item.cot-aprovada then do:     
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-cotacao-de-item AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Cotaá∆o_de_Item" *}
                    ASSIGN c-lbl-liter-cotacao-de-item = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15596"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION" 
                                        &ErrorParameters="c-lbl-liter-cotacao-de-item"}            
            end.                
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 4 or
            doc-pend-aprov.ind-tip-doc = 6 then do:
        if pTipTransacao = "cd1720a1":U  or pTipTransacao = "Rejeita1":U then
            assign l-pendente = no.            
        /* Aprovaá∆o do Pedido */
        for each ordem-compra where
            ordem-compra.num-pedido = doc-pend-aprov.num-pedido no-lock:
            run cdp/cdapi172.p (4,rowid(ordem-compra),output l-pendente).
            if not l-pendente then do:
                run geraProximaPrioridade(doc-pend-aprov.ind-tip-doc, 
                                          rowid(ordem-compra), 
                                          rowid(doc-pend-aprov),
                                          pTipTransacao).        
                run cdp/cdapi172.p (4,rowid(ordem-compra),output l-pendente).
            end.
            if l-pendente = yes then leave.
        end.
        if not l-pendente then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-pedido-de-compra AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Pedido_de_Compra" *}
                    ASSIGN c-lbl-liter-pedido-de-compra = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15596"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION" 
                                        &ErrorParameters="c-lbl-liter-pedido-de-compra"}            
        end.
    end.
    RUN salvaAprovacaoDocumento-aux( INPUT pTipTransacao, INPUT l-pendente).

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaAprovacaoDocumento-aux DBOProgram 
PROCEDURE salvaAprovacaoDocumento-aux :
    
    define input param pTipTransacao as char    no-undo. /* tipo transaá∆o efetuada( cd1720a(1)/cd1720c) */    
    define input param l-pendente    as logical no-undo.

    if doc-pend-aprov.ind-tip-doc  = 7 then do:
        if pTipTransacao = "cd1720a1":U  or pTipTransacao = "Rejeita1":U then
            assign l-pendente = no.
        /* Aprovaá∆o do Processo */
        find ordem-compra where ordem-compra.numero-ordem = doc-pend-aprov.numero-ordem no-lock no-error.
        find cotacao-item where
             cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
             cotacao-item.it-codigo    = ordem-compra.it-codigo    and
             cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
             cotacao-item.seq-cotac    = doc-pend-aprov.sequencia
             no-lock no-error.
        run cdp/cdapi172.p (7,rowid(cotacao-item),output l-pendente).
        if not l-pendente then do:
                run geraProximaPrioridade(7, 
                                          rowid(cotacao-item), 
                                          rowid(doc-pend-aprov),
                                          pTipTransacao).        
            run cdp/cdapi172.p (7,rowid(cotacao-item),output l-pendente).
        end.
        if not l-pendente then do:            
            find cotacao-item where
                 cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
                 cotacao-item.it-codigo    = ordem-compra.it-codigo    and
                 cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
                 cotacao-item.seq-cotac    = doc-pend-aprov.sequencia
                 exclusive-lock no-error.
            {cdp/cd1720a.i} /* Aprovaá∆o do Processo */
            find cotacao-item where
                 cotacao-item.numero-ordem = doc-pend-aprov.numero-ordem and
                 cotacao-item.it-codigo    = ordem-compra.it-codigo    and
                 cotacao-item.cod-emitente = doc-pend-aprov.cod-emitente and
                 cotacao-item.seq-cotac    = doc-pend-aprov.sequencia
                 no-lock no-error.
            if cotacao-item.cot-aprovada then do:      
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-cotacao-de-item-2 AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Cotaá∆o_de_Item" *}
                    ASSIGN c-lbl-liter-cotacao-de-item-2 = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15596"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION" 
                                        &ErrorParameters="c-lbl-liter-cotacao-de-item-2"}            
            end.                
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 8 then do:
        if pTipTransacao = "cd1720a1":U  or pTipTransacao = "Rejeita1":U then
            assign l-pendente = no.    
        /*   Aprovaá∆o do Contrato */
        for each item-contrat where
                 &if defined(bf_mat_contratos) &then
                     item-contrat.nr-contrato  = int(doc-pend-aprov.char-1) and
                 &else
                     item-contrat.nr-contrato  = doc-pend-aprov.char-1 and
                 &endif
                 item-contrat.val-total    > 0 no-lock:
            run cdp/cdapi172.p (8, rowid(item-contrat), output l-pendente).
            if not l-pendente then do:
                run geraProximaPrioridade(8, 
                                          rowid(item-contrat), 
                                          rowid(doc-pend-aprov),
                                          pTipTransacao).             
                run cdp/cdapi172.p (8, rowid(item-contrat), output l-pendente).
            end.
            if l-pendente = yes then leave.
        end.
        for each ordem-compra where
                 &if defined(bf_mat_contratos) &then
                 ordem-compra.nr-contrato  = int(doc-pend-aprov.char-1)     and
                 &else
                 ordem-compra.nr-contrato  = doc-pend-aprov.char-1       and
                 &endif
                 ordem-compra.numero-ordem = doc-pend-aprov.numero-ordem no-lock:
            run cdp/cdapi172.p (8, rowid(ordem-compra), output l-pendente).
            if not l-pendente then do:
                run geraProximaPrioridade(8, 
                                          rowid(ordem-compra), 
                                          rowid(doc-pend-aprov)).             
                run cdp/cdapi172.p (8, rowid(ordem-compra), output l-pendente).
            end.
            if l-pendente = yes then leave.
        end.
        if not l-pendente then do:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-contrato AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Contrato" *}
                    ASSIGN c-lbl-liter-contrato = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15596"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION" 
                                        &ErrorParameters="c-lbl-liter-contrato"}
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 9
    then do:
        find solic-serv where solic-serv.nr-soli-serv = doc-pend-aprov.nr-requisicao no-lock no-error.
        if not available solic-serv
        then leave.
        run cdp/cdapi172.p (doc-pend-aprov.ind-tip-doc,rowid(solic-serv),output l-pendente).
        if not l-pendente then do:
            run geraProximaPrioridade(9, 
                                      rowid(solic-serv), 
                                      rowid(doc-pend-aprov)).        
            run cdp/cdapi172.p (doc-pend-aprov.ind-tip-doc,rowid(solic-serv),output l-pendente).
        end.
        if not l-pendente 
        then do:
            find solic-serv where solic-serv.nr-soli-serv = doc-pend-aprov.nr-requisicao EXCLUSIVE-LOCK NO-ERROR.
            assign solic-serv.estado = 2.
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-solicitacao-de-servico AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Solicitaá∆o_de_Serviáo" *}
                    ASSIGN c-lbl-liter-solicitacao-de-servico = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15596"
                                        &ErrorType="EMS"
                                        &ErrorSubType="INFORMATION" 
                                        &ErrorParameters="c-lbl-liter-solicitacao-de-servico"}
        end.                
    end.
    
    /**  Caraiba
    **/
    if doc-pend-aprov.ind-tip-doc = 10 then do:
        /**
        ***   Aprovaá∆o do Documento Contrato
        **/
        assign l-pendente = no.
        find contrato-for where
            integer(contrato-for.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16))
            no-lock no-error.
        if not l-pendente then do:
            run geraProximaPrioridade(10, 
                                      rowid(contrato-for), 
                                      rowid(doc-pend-aprov)).            
            run cdp/cdapi172.p (10, rowid(contrato-for), output l-pendente).
        end.
        if not l-pendente then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-documento-contrato AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Documento_Contrato" *}
            ASSIGN c-lbl-liter-documento-contrato = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="15596"
                               &ErrorType="EMS"
                               &ErrorSubType="INFORMATION" 
                               &ErrorParameters="c-lbl-liter-documento-contrato"}            
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 11 then do:
        /**
        ***   Aprovaá∆o do Evento
        **/
        assign l-pendente = no.
        find evento-ped where
            evento-ped.numero-ordem = doc-pend-aprov.numero-ordem and
            evento-ped.seq-evento = integer(substring(doc-pend-aprov.char-2,13,4))
            no-lock no-error.
        if not l-pendente then do:
            run geraProximaPrioridade(11, 
                                      rowid(evento-ped), 
                                      rowid(doc-pend-aprov)).
            run cdp/cdapi172.p (11, rowid(evento-ped), output l-pendente).
        end.                 
        if not l-pendente then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-evento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Evento" *}
            ASSIGN c-lbl-liter-evento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="15596"
                               &ErrorType="EMS"
                               &ErrorSubType="INFORMATION" 
                               &ErrorParameters="c-lbl-liter-evento"}
        end.
    end.
    else if doc-pend-aprov.ind-tip-doc = 12 then do:
        /**
        ***   Aprovaá∆o da Mediá∆o
        **/
        assign l-pendente = no.
        find medicao-contrat where
            integer(medicao-contrat.nr-contrato) = integer(substring(doc-pend-aprov.char-1,1,16)) and
            medicao-contrat.numero-ordem         = doc-pend-aprov.numero-ordem and
            medicao-contrat.num-seq-item         = integer(substring(doc-pend-aprov.char-2,17,5)) and
            medicao-contrat.num-seq-event        = integer(substring(doc-pend-aprov.char-2,13,4)) and
            medicao-contrat.num-seq-medicao      = integer(substring(doc-pend-aprov.char-2,22,4))
            no-lock no-error.
        if not l-pendente then do:
            run geraProximaPrioridade(12, 
                                      rowid(medicao-contrat), 
                                      rowid(doc-pend-aprov)).
            run cdp/cdapi172.p (12, rowid(medicao-contrat), output l-pendente).
        end.                 
        if not l-pendente then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-medicao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Mediá∆o" *}
            ASSIGN c-lbl-liter-medicao = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                               &ErrorNumber="15596"
                               &ErrorType="EMS"
                               &ErrorSubType="INFORMATION" 
                               &ErrorParameters="c-lbl-liter-medicao"}
        end.
    end.
    
    if pTipTransacao = "cd1720a":U or pTipTransacao = "cd1720a1":U then do:
        if (doc-pend-aprov.ind-tip-doc = 3 and
            cotacao-item.cot-aprovada) or
            doc-pend-aprov.ind-tip-doc <> 3 then do:

            /********************** Chamada EPC Grendene ************************/
            {include/i-epc200.i2 &CodEvent='"envia-email"'
                                 &CodParameter='"rowid-doc-pend-aprov"'
                                 &ValueParameter="string(rowid(doc-pend-aprov))"}                        
            /* Include i-epc201.i: Chamada do programa de EPC */
            {include/i-epc201.i "envia-email"}        
            IF return-value = "NOK":U THEN RETURN.
            /********************************************************************/

            run pi-cria-envia-e-mail-int ( 2 , rowid(doc-pend-aprov) ).
        end.
    end.

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaRejeicaoDocumento DBOProgram 
PROCEDURE salvaRejeicaoDocumento :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input param pRowDocPend   as rowid   no-undo.
    define input param lSitAprov     as logical no-undo.
    define input param pAprovador    as char    no-undo.
    define input param pTipTransacao as char    no-undo. /* tipo transaá∆o efetuada(Rejeita/Rejeita1) */

    define variable l-alternativo  as logi  no-undo.

    FIND doc-pend-aprov WHERE rowid(doc-pend-aprov)  = pRowDocPend EXCLUSIVE-LOCK no-error.
    
    find first RowObject no-lock no-error.
    
    assign l-alternativo = if doc-pend-aprov.cod-aprov <> pAprovador then yes else no.
    
    assign doc-pend-aprov.narrativa-rej = RowObject.narrativa-rej
           doc-pend-aprov.cod-rej       = RowObject.cod-rej
           doc-pend-aprov.dt-rejeita    = today
           doc-pend-aprov.ind-situacao  = 3
           doc-pend-aprov.sit-aprov     = no
           doc-pend-aprov.cod-aprov-altern = if l-alternativo then pAprovador else "":U.
    
    if pTipTransacao <> "cd1720b1":U then do:
        if doc-pend-aprov.ind-tip-doc = 9 then do:
           find solic-serv
               where solic-serv.nr-soli-serv = doc-pend-aprov.nr-requisicao EXCLUSIVE-LOCK no-error.
           if avail solic-serv then
              assign solic-serv.mot-cancelado = doc-pend-aprov.narrativa-rej
                     solic-serv.estado        = 4.
        end.
    end.    
    
    /**
    ***   Envia E-Mail
    **/                                                  
    run pi-cria-envia-e-mail-int ( 3 , rowid(doc-pend-aprov) ).
    /****/            

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaAprovacaoDocumento DBOProgram 
PROCEDURE validaAprovacaoDocumento :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

    define input param pRowDocPend   as rowid   no-undo.
    define input  param pAprovador    as char  no-undo.
    define input  param pValorLimite  as deci  no-undo.
    define input  param pValorDoc     as deci  no-undo.
    define input  param pTipTransacao as char  no-undo. /* tipo transaá∆o efetuada( Aprova/Rejeita/cd1720c) */    
    define input  param pLimAprov     as logi  no-undo.
    define output param pAprovSemLim  as logi  no-undo.
    define output param pSitAprov     as logi  no-undo.  

    define variable lProximoAprov  as logical no-undo.
    define variable lSitAprov      as logical no-undo.
    define variable lAprovSemLim   as logical no-undo.
    FIND doc-pend-aprov WHERE rowid(doc-pend-aprov)  = pRowDocPend no-lock no-error.
               
    find aprovador where aprovador.cod-aprov = pAprovador  no-lock no-error.
        
    assign pSitAprov    = yes
           pAprovSemLim = yes.

    if RowObject.narrativa-apr = "" then do:        
        /** Mensagem: Narrativa de aprovaá∆o n∆o pode ser nula. **/
            {method/svc/errors/inserr.i
                                &ErrorNumber="15541"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U}
             find first RowErrors no-lock no-error.
             return "NOK":U.
    end.

    /**  Permite aprovar pendància tÇcnica somente por aprovador tÇcnico.
    **/
    if  doc-pend-aprov.aprov-tec and
        aprovador.aprov-tec = no then do:
        /** Mensagem: Esta pendància somente poder† ser &1 por um tÇcnico. **/
        if pTipTransacao = "cd1720a":U then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-aprovada AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "aprovada" *}
            ASSIGN c-lbl-liter-aprovada = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="17619"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-aprovada"}
            return "NOK":U.
         end.
         else 
         if pTipTransacao = "cd1720c":U then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-reaprovada AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Reaprovada" *}
            ASSIGN c-lbl-liter-reaprovada = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="17619"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-reaprovada"}    
            return "NOK":U.
         end.
    end.
    /**
    ***   Verifica se existe pr¢ximo aprovador na hierarquia
    **/
    if doc-pend-aprov.ind-tip-aprov = 1 then do:
        pesq-prox-aprov-hierarquia:
        for each hierarquia-aprov where
            hierarquia-aprov.sc-codigo = doc-pend-aprov.sc-codigo and
            hierarquia-aprov.seq-aprov > doc-pend-aprov.seq-aprov NO-LOCK:
            find b-aprovador where
                b-aprovador.cod-aprov = hierarquia-aprov.cod-aprov
                no-lock no-error.
            if available b-aprovador and 
               b-aprovador.cod-aprov <> pAprovador and
                ((b-aprovador.perm-solic  and  doc-pend-aprov.ind-tip-doc = 1)  or
                 (b-aprovador.perm-solic  and  doc-pend-aprov.ind-tip-doc = 5)  or
                 (b-aprovador.perm-requis and  doc-pend-aprov.ind-tip-doc = 2)  or
                 (b-aprovador.perm-cotac  and  doc-pend-aprov.ind-tip-doc = 3)  or
                 (b-aprovador.perm-pedido and (doc-pend-aprov.ind-tip-doc = 4   or 
                                               doc-pend-aprov.ind-tip-doc = 6)) or
                 (b-aprovador.log-1       and  doc-pend-aprov.ind-tip-doc = 7)  or
                 (b-aprovador.log-2       and  doc-pend-aprov.ind-tip-doc = 8)  or
                 (b-aprovador.perm-manut  and  doc-pend-aprov.ind-tip-doc = 9)  or
                 /**  Caraiba
                 **/ 
                 (substring(b-aprovador.char-1,2,1) = "Y" and doc-pend-aprov.ind-tip-doc = 11) or
                 (substring(b-aprovador.char-1,3,1) = "Y" and doc-pend-aprov.ind-tip-doc = 12)) then do:
                 
                 assign lProximoAprov = yes.
                 leave pesq-prox-aprov-hierarquia.
             end.
         end.
    end.
    /**
    ***   Verifica se existe pr¢ximo aprovador na faixa
    **/
    if doc-pend-aprov.ind-tip-aprov = 4 then do:
        pesq-prox-aprov-faixa:
        for each hierarquia-faixa where
            hierarquia-faixa.sc-codigo   = doc-pend-aprov.sc-codigo   and
            hierarquia-faixa.ind-tip-doc = (if doc-pend-aprov.ind-tip-doc = 6 
                                           then 4
                                           else 
                                           if doc-pend-aprov.ind-tip-doc = 5
                                           then 1
                                           else doc-pend-aprov.ind-tip-doc) and
            hierarquia-faixa.num-faixa   = doc-pend-aprov.num-faixa   and
            hierarquia-faixa.seq-aprov   > doc-pend-aprov.seq-aprov no-lock:
            find b-aprovador where
                b-aprovador.cod-aprov = hierarquia-faixa.cod-aprov
                no-lock no-error.
            if available b-aprovador and
               b-aprovador.cod-aprov <> pAprovador and
                ((b-aprovador.perm-solic  and  doc-pend-aprov.ind-tip-doc = 1)  or
                 (b-aprovador.perm-solic  and  doc-pend-aprov.ind-tip-doc = 5)  or
                 (b-aprovador.perm-requis and  doc-pend-aprov.ind-tip-doc = 2)  or
                 (b-aprovador.perm-cotac  and  doc-pend-aprov.ind-tip-doc = 3)  or
                 (b-aprovador.perm-pedido and (doc-pend-aprov.ind-tip-doc = 4   or 
                                               doc-pend-aprov.ind-tip-doc = 6)) or
                 (b-aprovador.log-1       and  doc-pend-aprov.ind-tip-doc = 7)  or
                 (b-aprovador.log-2       and  doc-pend-aprov.ind-tip-doc = 8)  or
                 (b-aprovador.perm-manut  and  doc-pend-aprov.ind-tip-doc = 9)  or

                 /**  Caraiba
                 **/
                 (substring(b-aprovador.char-1,1,1) = "Y" and doc-pend-aprov.ind-tip-doc = 10) or
                 (substring(b-aprovador.char-1,2,1) = "Y" and doc-pend-aprov.ind-tip-doc = 11) or
                 (substring(b-aprovador.char-1,3,1) = "Y" and doc-pend-aprov.ind-tip-doc = 12) ) then do:
                 
                 assign lProximoAprov = yes.
                 leave pesq-prox-aprov-faixa.
             end.
        end.            
    end.

    /**  Valida limite do aprovador para tipo lista e padr∆o
    **/
    if  doc-pend-aprov.ind-tip-aprov  = 2 or
       (doc-pend-aprov.ind-tip-aprov  = 3 and
        doc-pend-aprov.aprov-tec = no) then do:
        if pValorLimite < pValorDoc then do:
            /** Mensagem: Aprovador n∆o possui limite para aprovar esta pendància. **/
            {method/svc/errors/inserr.i
                                &ErrorNumber="17618"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"}    
            return "NOK":U.
        end.
    end.

    if lProximoAprov and
       (doc-pend-aprov.ind-tip-aprov = 1 or
        doc-pend-aprov.ind-tip-aprov = 4) and
        not aprovador.mestre and
        not doc-pend-aprov.aprov-tec and
        pValorDoc > pValorLimite and pLimAprov = no then do:
        /** Mensagem: Aprovador n∆o tem limite para aprovaá∆o. Documento ficar† com estado de aprovado sem limite. Confirma? **/
            {method/svc/errors/inserr.i
                               &ErrorNumber="32524"
                               &ErrorType="EMS"
                               &ErrorSubType="warning"} 
        assign lSitAprov = no. 
        return "OK":U.        
    end.

        
    if not lProximoAprov and
          (doc-pend-aprov.ind-tip-aprov = 1  or
           doc-pend-aprov.ind-tip-aprov = 4) and
           not aprovador.mestre and
           not doc-pend-aprov.aprov-tec      and
           pValorDoc >  pValorLimite         then do:
        /** Mensagem: Aprovador n∆o tem limite para aprovaá∆o. 
                      Documento n∆o poder† ficar com estado de aprovado sem limite, pois se trata do £ltimo aprovador. **/
        if doc-pend-aprov.ind-tip-aprov = 1 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-hierarquia AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Hierarquia" *}
            ASSIGN c-lbl-liter-hierarquia = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="16495"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-hierarquia"} 
             return "NOK":U.
        end.
        else if doc-pend-aprov.ind-tip-aprov = 4 then do:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-faixa AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Faixa" *}
            ASSIGN c-lbl-liter-faixa = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="16495"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-faixa"}   
             return "NOK":U.
        end.
    end.
    
    assign pAprovSemLim = no.
    if (doc-pend-aprov.ind-tip-aprov = 1  or
        doc-pend-aprov.ind-tip-aprov = 4) and
        pSitAprov     = no                and
        lProximoAprov = yes then 
        assign pSitAprov     = yes
               pAprovSemLim  = yes.

    /**  Caraiba
    **/
    case doc-pend-aprov.ind-tip-doc:
        when 10 then do:
            find first b-doc-pend-aprov where
                substring(b-doc-pend-aprov.char-1,1,16) = substring(doc-pend-aprov.char-1,1,16) and
               (b-doc-pend-aprov.ind-situacao = 2  or
                b-doc-pend-aprov.ind-situacao = 4) and
                b-doc-pend-aprov.ind-tip-doc  = 10 and
                b-doc-pend-aprov.cod-aprov    = pAprovador
                no-lock no-error.
            if not available b-doc-pend-aprov then
                find first b-doc-pend-aprov where
                    substring(b-doc-pend-aprov.char-1,1,16) = substring(doc-pend-aprov.char-1,1,16) and
                   (b-doc-pend-aprov.ind-situacao     = 2  or
                    b-doc-pend-aprov.ind-situacao     = 4) and
                    b-doc-pend-aprov.ind-tip-doc      = 10 and
                    b-doc-pend-aprov.cod-aprov-altern = pAprovador
                    no-lock no-error.
        end.
        when 11 then do:
            if doc-pend-aprov.aprov-total then do:
                find first b-doc-pend-aprov where
                    b-doc-pend-aprov.numero-ordem = doc-pend-aprov.numero-ordem and
                   (b-doc-pend-aprov.ind-situacao = 2  or
                    b-doc-pend-aprov.ind-situacao = 4) and
                    b-doc-pend-aprov.ind-tip-doc  = 11 and
                    b-doc-pend-aprov.cod-aprov    = pAprovador
                    no-lock no-error.
                if not available b-doc-pend-aprov then                    
                    find first b-doc-pend-aprov where
                        b-doc-pend-aprov.numero-ordem     = doc-pend-aprov.numero-ordem and
                       (b-doc-pend-aprov.ind-situacao     = 2  or
                        b-doc-pend-aprov.ind-situacao     = 4) and
                        b-doc-pend-aprov.ind-tip-doc      = 11 and
                        b-doc-pend-aprov.cod-aprov-altern = pAprovador
                        no-lock no-error.
            end.
            else do:
                find first b-doc-pend-aprov where
                    b-doc-pend-aprov.numero-ordem = doc-pend-aprov.numero-ordem and
                   (b-doc-pend-aprov.ind-situacao = 2  or
                    b-doc-pend-aprov.ind-situacao = 4) and
                    b-doc-pend-aprov.ind-tip-doc  = 11 and
                    substring(b-doc-pend-aprov.char-2,13,4) = substring(doc-pend-aprov.char-2,13,4) and
                    b-doc-pend-aprov.cod-aprov    = pAprovador
                    no-lock no-error.
                if not available b-doc-pend-aprov then                    
                    find first b-doc-pend-aprov where
                        b-doc-pend-aprov.numero-ordem     = doc-pend-aprov.numero-ordem and
                       (b-doc-pend-aprov.ind-situacao     = 2  or
                        b-doc-pend-aprov.ind-situacao     = 4) and
                        b-doc-pend-aprov.ind-tip-doc      = 11 and
                        substring(b-doc-pend-aprov.char-2,13,4) = substring(doc-pend-aprov.char-2,13,4) and
                        b-doc-pend-aprov.cod-aprov-altern = pAprovador
                        no-lock no-error.
            end.
        end.
        when 12 then do:
            if doc-pend-aprov.aprov-total then do:
                find first b-doc-pend-aprov where
                    substring(b-doc-pend-aprov.char-1,1,16) = substring(doc-pend-aprov.char-1,1,16) and
                    b-doc-pend-aprov.numero-ordem           = doc-pend-aprov.numero-ordem           and
                    substring(b-doc-pend-aprov.char-2,13,4) = substring(doc-pend-aprov.char-2,13,4) and
                   (b-doc-pend-aprov.ind-situacao = 2  or
                    b-doc-pend-aprov.ind-situacao = 4) and
                    b-doc-pend-aprov.ind-tip-doc  = 12 and
                    b-doc-pend-aprov.cod-aprov    = pAprovador
                    no-lock no-error.
                if not available b-doc-pend-aprov then    
                    find first b-doc-pend-aprov where
                        substring(b-doc-pend-aprov.char-1,1,16) = substring(doc-pend-aprov.char-1,1,16) and
                        b-doc-pend-aprov.numero-ordem           = doc-pend-aprov.numero-ordem           and
                        substring(b-doc-pend-aprov.char-2,13,4) = substring(doc-pend-aprov.char-2,13,4) and
                       (b-doc-pend-aprov.ind-situacao     = 2  or
                        b-doc-pend-aprov.ind-situacao     = 4) and
                        b-doc-pend-aprov.ind-tip-doc      = 12 and
                        b-doc-pend-aprov.cod-aprov-altern = pAprovador
                        no-lock no-error.
            end.
            else do:
                find first b-doc-pend-aprov where
                    substring(b-doc-pend-aprov.char-1,1,16) = substring(doc-pend-aprov.char-1,1,16) and
                    b-doc-pend-aprov.numero-ordem           = doc-pend-aprov.numero-ordem           and
                    substring(b-doc-pend-aprov.char-2,13,4) = substring(doc-pend-aprov.char-2,13,4) and
                    substring(b-doc-pend-aprov.char-2,17,5) = substring(doc-pend-aprov.char-2,17,5) and
                    substring(b-doc-pend-aprov.char-2,22,4) = substring(doc-pend-aprov.char-2,22,4) and
                   (b-doc-pend-aprov.ind-situacao = 2  or
                    b-doc-pend-aprov.ind-situacao = 4) and
                    b-doc-pend-aprov.ind-tip-doc  = 12 and
                    b-doc-pend-aprov.cod-aprov    = pAprovador
                    no-lock no-error.
                if not available b-doc-pend-aprov then    
                    find first b-doc-pend-aprov where
                        substring(b-doc-pend-aprov.char-1,1,16) = substring(doc-pend-aprov.char-1,1,16) and
                        b-doc-pend-aprov.numero-ordem           = doc-pend-aprov.numero-ordem           and
                        substring(b-doc-pend-aprov.char-2,13,4) = substring(doc-pend-aprov.char-2,13,4) and
                        substring(b-doc-pend-aprov.char-2,17,5) = substring(doc-pend-aprov.char-2,17,5) and
                        substring(b-doc-pend-aprov.char-2,22,4) = substring(doc-pend-aprov.char-2,22,4) and
                       (b-doc-pend-aprov.ind-situacao     = 2  or
                        b-doc-pend-aprov.ind-situacao     = 4) and
                        b-doc-pend-aprov.ind-tip-doc      = 12 and
                        b-doc-pend-aprov.cod-aprov-altern = pAprovador
                        no-lock no-error.
            end.        
        end.
    end case.

/******************/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaBotoes DBOProgram 
PROCEDURE validaBotoes :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define input  parameter  prRowDoc    as rowid   no-undo.
    define output parameter  plBtAprov   as logical no-undo.
    define output parameter  plBtRejeit  as logical no-undo.
    define output parameter  plBtReaprov as logical no-undo.
    
    assign plBtAprov    = no
           plBtRejeit   = no
           plBtReaprov  = no.
    
   find doc-pend-aprov where 
         rowid(doc-pend-aprov) = prRowDoc no-lock no-error.
    if avail doc-pend-aprov then do:
        assign plBtAprov   = (doc-pend-aprov.ind-situacao = 1)
               plBtRejeit  = (doc-pend-aprov.ind-situacao = 1)
               plBtReaprov = (doc-pend-aprov.ind-situacao = 3).    
    end.
    else
        RETURN "NOK":U.
   
 
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaReaprovacaoDocumento DBOProgram 
PROCEDURE validaReaprovacaoDocumento :
/*------------------------------------------------------------------------------
  Purpose:    Valida Reaprovaá∆o do documento
  Parameters: ipar1 : pCodAprov : Recebe c¢digo do aprovador
              opar2 : pSitAprov : Retorna situaá∆o da aprovaá∆o
  Notes:       
------------------------------------------------------------------------------*/

    define input  param pCodAprov     as character  no-undo.
    define output param pAprovSemLim  as logical    no-undo.
    

    FIND FIRST aprovador WHERE
               aprovador.cod-aprov = pcodAprov NO-LOCK NO-ERROR.
    
    find first rowObject no-lock no-error.
    
    assign pAprovSemLim = yes.
       
    if RowObject.narrativa-apr = "" then do:        
        /** Mensagem: Narrativa de aprovaá∆o n∆o pode ser nula. **/
        {method/svc/errors/inserr.i
                   &ErrorNumber="15541"
                   &ErrorType="EMS"
                   &ErrorSubType="ERROR"}
    end.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaRejeicaoDocumento DBOProgram 
PROCEDURE validaRejeicaoDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Esta procedure È utilizada pelos programas wcd1720b e wcd1720b1 (Rejeita Documento)
         que por sua vez s„o chamada a partir do wcd1720. E s„o diferenciados pelo pTipTran-
         saÁ„o passado como par‚metro.
------------------------------------------------------------------------------*/

DEF INPUT PARAM c-cod-rej         AS CHAR  NO-UNDO.
DEF INPUT PARAM c-narrativa-rej   AS CHAR  NO-UNDO.
DEF INPUT PARAM c-cod-aprov       AS CHAR  NO-UNDO.
DEF INPUT PARAM l-aprov-tec       AS LOG   NO-UNDO.
DEF INPUT PARAM pTipTransacao     AS CHAR  NO-UNDO.
DEF INPUT PARAM rowidDocPendAprov AS ROWID NO-UNDO.

    /**  Permite aprovar pendància tÇcnica somente por aprovador tÇcnico.
    **/
    find aprovador where
         aprovador.cod-aprov = c-cod-aprov
         no-lock no-error.
        
    if l-aprov-tec and
        aprovador.aprov-tec = no and pTipTransacao = "cd1720b":U then do:
        /** Mensagem: Esta pendància somente poder† ser &1 por um tÇcnico. **/
       /* Inicio -- Projeto Internacional */
       DEFINE VARIABLE c-lbl-liter-rejeitada AS CHARACTER NO-UNDO.
       {utp/ut-liter.i "rejeitada" *}
       ASSIGN c-lbl-liter-rejeitada = TRIM(RETURN-VALUE).
       {method/svc/errors/inserr.i &ErrorNumber="17619"
                                   &ErrorType="EMS":U
                                   &ErrorSubType="ERROR":U 
                                   &ErrorParameters="c-lbl-liter-rejeitada"}
    end.
    
    find rej-aprov where rej-aprov.cod-rej = c-cod-rej no-lock no-error.
    if not can-find (first RowErrors) then do:
        if not available rej-aprov then do:
           /** Mensagem: N∆o foi encontrada ocorrància em &1 com a chave informada. **/
           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-codigo-rejeicao AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "C¢digo_Rejeiá∆o" *}
           ASSIGN c-lbl-liter-codigo-rejeicao = TRIM(RETURN-VALUE).
           {method/svc/errors/inserr.i &ErrorNumber="2"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U
                                       &ErrorParameters="c-lbl-liter-codigo-rejeicao"}
           return "NOK":U.
        end.
    end.
    
    if not can-find (first RowErrors) then do:
        if available rej-aprov and
            rej-aprov.log-nar-obr and
            c-narrativa-rej = "":U then do:        
            /** Mensagem: Narrativa de rejeiáÉo n∆o pode ser nula. **/
           {method/svc/errors/inserr.i &ErrorNumber="15547"
                                       &ErrorType="EMS":U
                                       &ErrorSubType="ERROR":U}
           return "NOK":U.
            
        end.
    end.
    
   
    if not can-find (first Rowerrors) and pTipTransacao = "cd1720b1":U then do:
            /**
            ***   Assign¥s restantes
            **/
            find doc-pend-aprov where
                rowid(doc-pend-aprov) = rowidDocPendAprov
                NO-LOCK no-error.
        
            /** Permite aprovar pendÍncia tÈcnica somente 
             ** por aprovador tÈcnico. **/
            if (doc-pend-aprov.aprov-tec and
                aprovador.aprov-tec = yes) or
                doc-pend-aprov.aprov-tec = no then do:                
               run SalvaRejeicaoDocumento (input rowid(doc-pend-aprov),
                                           input no,
                                           input doc-pend-aprov.cod-aprov,
                                           input "cd1720b1":U).             
                
            end.
    end.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaReaprovacao DBOProgram 
PROCEDURE VerificaReaprovacao :
/*------------------------------------------------------------------------------
  Purpose:   
  Parameters: ipar1 : pRowDocPend : Recebe rowid da tabela doc-pend-aprov
              ipar2 : pcAprovador : Recebe c¢digo do aprovador
  Notes: Esta procedure Ç utilizada pelos programas wcd1720c e wcd1720c1 (Reaprovaá∆o Documento)
         que por sua vez s„o chamada a partir do wcd1720. E s∆o diferenciados pelo pTipTrans
         passado como parÉmetro.
  
------------------------------------------------------------------------------*/

    define input parameter pRowDocPend   as rowid      no-undo.
    define input parameter pcAprovador   as character  no-undo.
    define input parameter pcTipTrans    as character  no-undo.    
    define input parameter lAprovSemLim  as logical    no-undo.
    
    define variable lProximoAprov        as logical    no-undo.
    define variable lSitAprov            as logical    no-undo.
    define variable deValorLim           as decimal    no-undo.
    define variable deValorDoc           as decimal    no-undo.
    define variable deQuantidade         as decimal    no-undo.
    define variable cNarrativaApr        as character  no-undo.
    define variable lHabNarrat           as logical    no-undo.

    FIND doc-pend-aprov WHERE rowid(doc-pend-aprov)  = pRowDocPend no-lock no-error.

    run validaReaprovacaoDocumento (input  pcAprovador,
                                    output lAprovSemLim).  
    
    run retornaValoresDocumento (input  pRowDocPend,
                                 input  pcAprovador,
                                 input  pcTipTrans,
                                 output deValorLim,
                                 output deValorDoc,
                                 output deQuantidade,
                                 output cNarrativaApr,
                                 output lHabNarrat).   

    assign lSitAprov = yes.        
    if not aprovador.mestre            and
        not doc-pend-aprov.aprov-tec   and
        deValorDoc > deValorLim        then do:
        assign lSitAprov = no.
    end.
    
    assign lProximoAprov = no.
    /**
    ***   Verifica se existe pr¢ximo aprovador na hierarquia
    **/
    if doc-pend-aprov.ind-tip-aprov = 1 then do:
        pesq-prox-aprov-hierarquia:
        for each hierarquia-aprov where
            hierarquia-aprov.sc-codigo = doc-pend-aprov.sc-codigo and
            hierarquia-aprov.seq-aprov > doc-pend-aprov.seq-aprov NO-LOCK:
            find b-aprovador where
                b-aprovador.cod-aprov = hierarquia-aprov.cod-aprov
                no-lock no-error.
            if available b-aprovador                                            and
               b-aprovador.cod-aprov <> pcAprovador                             and
                ((b-aprovador.perm-solic  and  doc-pend-aprov.ind-tip-doc = 1)  or
                 (b-aprovador.perm-solic  and  doc-pend-aprov.ind-tip-doc = 5)  or
                 (b-aprovador.perm-requis and  doc-pend-aprov.ind-tip-doc = 2)  or
                 (b-aprovador.perm-cotac  and  doc-pend-aprov.ind-tip-doc = 3)  or
                 (b-aprovador.perm-pedido and (doc-pend-aprov.ind-tip-doc = 4   or 
                                               doc-pend-aprov.ind-tip-doc = 6)) or
                 (b-aprovador.log-1       and  doc-pend-aprov.ind-tip-doc = 7)  or
                 (b-aprovador.log-2       and  doc-pend-aprov.ind-tip-doc = 8)  or
                 (b-aprovador.perm-manut  and  doc-pend-aprov.ind-tip-doc = 9)) then do:
                 assign lProximoAprov = yes.
                 leave pesq-prox-aprov-hierarquia.
            end.
        end.
    end.
    /**
    ***   Verifica se existe pr¢ximo aprovador na faixa
    **/
    if doc-pend-aprov.ind-tip-aprov = 4 then do:
        pesq-prox-aprov-faixa:
        for each hierarquia-faixa where
            hierarquia-faixa.sc-codigo   = doc-pend-aprov.sc-codigo             and
            hierarquia-faixa.ind-tip-doc = (if doc-pend-aprov.ind-tip-doc = 6 
                                           then 4
                                           else 
                                           if doc-pend-aprov.ind-tip-doc = 5 
                                           then 1
                                           else doc-pend-aprov.ind-tip-doc)     and
            hierarquia-faixa.num-faixa   = doc-pend-aprov.num-faixa             and
            hierarquia-faixa.seq-aprov   > doc-pend-aprov.seq-aprov no-lock:
            find b-aprovador where
                b-aprovador.cod-aprov = hierarquia-faixa.cod-aprov
                no-lock no-error.
            if available b-aprovador and
               b-aprovador.cod-aprov <> pcAprovador                             and
                ((b-aprovador.perm-solic  and  doc-pend-aprov.ind-tip-doc = 1)  or
                 (b-aprovador.perm-solic  and  doc-pend-aprov.ind-tip-doc = 5)  or
                 (b-aprovador.perm-requis and  doc-pend-aprov.ind-tip-doc = 2)  or
                 (b-aprovador.perm-cotac  and  doc-pend-aprov.ind-tip-doc = 3)  or
                 (b-aprovador.perm-pedido and (doc-pend-aprov.ind-tip-doc = 4   or 
                                               doc-pend-aprov.ind-tip-doc = 6)) or
                 (b-aprovador.log-1       and  doc-pend-aprov.ind-tip-doc = 7)  or
                 (b-aprovador.log-2       and  doc-pend-aprov.ind-tip-doc = 8)  or
                 (b-aprovador.perm-manut  and  doc-pend-aprov.ind-tip-doc = 9)) then do:
                 assign lProximoAprov = yes.
                 leave pesq-prox-aprov-faixa.
            end.
        end.            
    end.
    assign lAprovSemLim = no.
    if (doc-pend-aprov.ind-tip-aprov = 1    or
        doc-pend-aprov.ind-tip-aprov = 4)   and
        lSitAprov = no                      and
        lProximoAprov = yes                 then 
        assign lSitAprov    = yes
               lAprovSemLim = yes.
     
    if not lProximoAprov                    and
        (doc-pend-aprov.ind-tip-aprov = 1   or
        doc-pend-aprov.ind-tip-aprov = 4)   and
        not aprovador.mestre                and
        not doc-pend-aprov.aprov-tec        and
        not lAprovSemLim                    and
        deValorDoc > deValorLim             then do:
        /** Mensagem: Aprovador n∆o tem limite para aprovaá∆o. 
              Documento n∆o poder† ficar com estado de aprovado sem limite, pois se trata do £ltimo aprovador. **/
            {method/svc/errors/inserr.i
                                &ErrorNumber="17618"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U}               
    end.
    else do:
        /**  Valida limite do aprovador para tipo lista e padr∆o
        **/
        if (doc-pend-aprov.ind-tip-aprov  = 2    or
           (doc-pend-aprov.ind-tip-aprov  = 3    and
            doc-pend-aprov.aprov-tec      = no)) and
            not lAprovSemLim                     and            
            deValorLim < deValorDoc              then do:
            /** Mensagem: Aprovador n∆o possui limite para aprovar esta pendància. **/
            {method/svc/errors/inserr.i
                                &ErrorNumber="17618"
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U}               
        end.
        else do:
            /** Permite aprovar pendància tÇcnica somente 
             ** por aprovador tÇcnico. */
            if (doc-pend-aprov.aprov-tec         and 
                aprovador.aprov-tec = yes)       or
                doc-pend-aprov.aprov-tec = no    then do:                

                run salvaAprovacaoDocumento(input pRowDocPend,
                                            input lSitAprov,
                                            input pcAprovador,
                                            input lAprovSemLim,
                                            input pcTipTrans). 
            end.
        end.
    end.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
