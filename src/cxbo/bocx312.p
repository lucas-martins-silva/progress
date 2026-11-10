&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
          movind           PROGRESS 
*/


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO LIKE item-doc-est
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-itens-di NO-UNDO LIKE pedido-drb-item
       field r-rowid as rowid
       field declaracao-import like pedido-drb-di.declaracao-import
       field un like item.un.
DEFINE TEMP-TABLE tt-itens-drb-bkp NO-UNDO LIKE pedido-drb-item
       field r-rowid as rowid.

DEFINE TEMP-TABLE tt-itens-nfe-imp NO-UNDO LIKE pedido-drb-item
       field r-rowid as rowid
       field cod-ser-docto like ped-draw-nfe.cod-ser-docto
       field cod-docto like ped-draw-nfe.cod-docto
       field cdn-emitente like ped-draw-nfe.cdn-emitente
       field cod-natur-operac like ped-draw-nfe.cod-natur-operac
       FIELD seq-docto LIKE movto-ato.seq-docto 
       field declaracao-import like pedido-drb-di.declaracao-import
       field un like item.un
    INDEX ch-seq IS PRIMARY cod-estabel
                            nr-pedido-drb
                            it-codigo
                            seq-docto.

DEFINE TEMP-TABLE tt-itens-nfs NO-UNDO LIKE pedido-drb-item
       field cod-serie like ped-draw-nfs.cod-serie
       field cod-fatura like ped-draw-nfs.cod-fatura
       field un like item.un
       field nr-seq-fat Like it-nota-fisc.nr-seq-fat
       field nat-operacao Like it-nota-fisc.nat-operacao
       field cod-emitente Like nota-fiscal.cod-emitente
       field dt-emis-nota Like nota-fiscal.dt-emis-nota
       field class-fiscal like item.class-fiscal
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pedido-drb-aux NO-UNDO LIKE Pedido-drb
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pedido-drb1 NO-UNDO LIKE Pedido-drb
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-pedido-drb2 NO-UNDO LIKE Pedido-drb
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOCX312 2.00.00.074 } /*** "010074" 10/12/2024 18:05:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bocx312 MUT}
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
&GLOBAL-DEFINE DBOName Pedido-drb
&GLOBAL-DEFINE DBOVersion 20000000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName Pedido-drb
&GLOBAL-DEFINE TableLabel Pedido-drb
&GLOBAL-DEFINE QueryName qr{&TableName}


/*--- Include com defini‡Æo da temptable RowObject ---*/
def var i-seq-erro  as int no-undo.
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{cxbo/bocx312.i RowObject}
{cxbo/bocx312.i tt-ped-drb}
{cxbo/bocx315.i tt-item-drb}
{cxbo/bocx315.i tt-pedido-drb-item}
DEFINE TEMP-TABLE tt-item-estrut NO-UNDO
    field r-rowid       as rowid
    field seq           as integer
    field nivel         as char format "X(16)"
    field it-codigo     like estrutura.it-codigo
    field refer         like ref-item.cod-refer
    field quant-usada   like estrutura.quant-usada     
    field quant-liquid  like estrutura.quant-liquid
    field quantidade    like estrutura.quant-usada
    field aux           as char format "X(4)" 
    field proporcao     like estrutura.proporcao
    field fator-perda   like estrutura.fator-perda
    field data-inicio   like estrutura.data-inicio
    field data-termino  like estrutura.data-termino
    INDEX codigo IS primary it-codigo ASCENDING.

DEFINE TEMP-TABLE tt-saldo-entrada NO-UNDO
    field it-entrada   like estrutura.it-codigo
    field it-saida     like estrutura.it-codigo
    field quantidade   like estrutura.quant-usada
    INDEX codigo IS primary it-saida it-entrada ASCENDING.

DEFINE TEMP-TABLE tt-nota-fiscal-aux NO-UNDO LIKE nota-fiscal
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-nota-fiscal-entrada NO-UNDO LIKE nota-fiscal
       field marcar  as char
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-nota-fiscal-saida NO-UNDO LIKE nota-fiscal
       field marcar  as char
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-param-nota NO-UNDO
    FIELD dec-imp-ini       AS CHARACTER
    FIELD dec-imp-fim       AS CHARACTER
    FIELD it-codigo-ini     AS CHARACTER
    FIELD it-codigo-fim     AS CHARACTER
    FIELD nat-operacao-ini  AS CHARACTER
    FIELD nat-operacao-fim  AS CHARACTER
    FIELD dt-di-ini         AS DATE
    FIELD dt-di-fim         AS DATE
    FIELD rs-integrado      AS INTEGER.

DEFINE TEMP-TABLE tt-it-nota-fisc-aux NO-UNDO LIKE it-nota-fisc
       field r-rowid as rowid.

/*estas includes devem ser definidas para buscar o n£mero do embarque no campo livre (docum-est.char-1)*/
{cdp/cd4300.i3} /* tratamento atributo livre */
{rep/re1001a.i50}

{cdp/cdcfgmat.i}
{include/boerrtab.i}

def var c-estabini        as char    no-undo.
def var c-estabfin        as char    no-undo.
def var c-estabel-ini     as char    no-undo.
def var c-estabel-fin     as char    no-undo.
def var c-pedido-ini      as char    no-undo.
def var c-pedido-fin      as char    no-undo.
def var c-ato-ini         as char    no-undo.
def var c-ato-fin         as char    no-undo.
DEF VAR c-programa        AS CHAR    NO-UNDO.
DEF VAR c-ultimo-programa AS CHAR    NO-UNDO.

DEF VAR h-bocx332         AS HANDLE  NO-UNDO.
DEF VAR h-bocx315         AS HANDLE  NO-UNDO.
DEF VAR h-exapi025        AS HANDLE  NO-UNDO.
DEF VAR h-boin176         AS HANDLE  NO-UNDO.

DEF VAR i-nivel           AS INTEGER NO-UNDO.
DEF VAR l-ok              AS LOGICAL NO-UNDO.
DEF VAR d-data-di         AS DATE    NO-UNDO.
DEF VAR de-quant-sdo      AS DEC     NO-UNDO.
DEF VAR r-rowidAux        AS ROWID   NO-UNDO.

DEF VAR de-qtd-maior      LIKE it-nota-fisc.qt-faturada[1].
DEF VAR de-qtd-fatur-nf   LIKE it-nota-fisc.qt-faturada[1].
DEF VAR de-qtd-faturada   LIKE it-nota-fisc.qt-faturada[1].

DEF VAR da-dt-prim-nota   AS DATE NO-UNDO.

def var i-idi-tip-movto   like movto-ato.idi-tip-movto  initial 1 no-undo.

DEFINE TEMP-TABLE tt-itens-ac NO-UNDO 
       FIELD it-codigo          LIKE pedido-drb-item.it-codigo
       FIELD nr-ato-concessorio LIKE pedido-drb.nr-ato-concessorio
       FIELD l-item-ato         AS   LOGICAL
       FIELD r-rowid-item       AS   ROWID.

DEFINE TEMP-TABLE tt-it-nota-fisc NO-UNDO LIKE it-nota-fisc
    FIELD r-Rowid AS ROWID.

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER bf-ordens-embarque FOR ordens-embarque.
DEF TEMP-TABLE tt-bo-erro-aux NO-UNDO LIKE tt-bo-erro.

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
   Temp-Tables and Buffers:
      TABLE: tt-item-doc-est T "?" NO-UNDO movind item-doc-est
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-itens-di T "?" NO-UNDO mgcex pedido-drb-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field declaracao-import like pedido-drb-di.declaracao-import
          field un like item.un
      END-FIELDS.
      TABLE: tt-itens-drb-bkp T "?" NO-UNDO mgcex pedido-drb-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-itens-nfe-imp T "?" NO-UNDO mgcex pedido-drb-item
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field cod-ser-docto like ped-draw-nfe.cod-ser-docto
          field cod-docto like ped-draw-nfe.cod-docto
          field cdn-emitente like ped-draw-nfe.cdn-emitente
          field cod-natur-operac like ped-draw-nfe.cod-natur-operac
          field seq-docto like movto-ato.seq-docto
          field declaracao-import like pedido-drb-di.declaracao-import
          field un like item.un
          index ch-seq is primary cod-estabel nr-pedido-drb it-codigo seq-docto
      END-FIELDS.
      TABLE: tt-itens-nfs T "?" NO-UNDO mgcex pedido-drb-item
      ADDITIONAL-FIELDS:
          field cod-serie like ped-draw-nfs.cod-serie
          field cod-fatura like ped-draw-nfs.cod-fatura
          field un like item.un
          field nr-seq-fat Like it-nota-fisc.nr-seq-fat
          field nat-operacao Like it-nota-fisc.nat-operacao
          field cod-emitente Like nota-fiscal.cod-emitente
          field dt-emis-nota Like nota-fiscal.dt-emis-nota
          field class-fiscal like item.class-fiscal
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pedido-drb-aux T "?" NO-UNDO mgcex Pedido-drb
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pedido-drb1 T "?" NO-UNDO mgcex Pedido-drb
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-pedido-drb2 T "?" NO-UNDO mgcex Pedido-drb
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 15.83
         WIDTH              = 39.57.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp fields(char-1) 
         WHERE param-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:
    END.
    
    IF AVAIL param-imp 
        AND TRIM(SUBSTRING(param-imp.char-1,227,1)) = "1":U THEN DO: /*Tabela Ato Concessório - IM0000 Folder Drawback*/
        {utp/ut-liter.i "Cria‡Æo"}
        RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:   Eliminar o handle.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    IF VALID-HANDLE(h-exapi025) THEN DO:
        DELETE PROCEDURE h-exapi025.
        ASSIGN h-exapi025 = ?.
    END.

    IF VALID-HANDLE(h-bocx332) THEN DO:
        DELETE PROCEDURE h-bocx332.
        ASSIGN h-bocx332 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR FIRST param-imp fields(char-1) 
         WHERE param-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:
    END.
    
    IF AVAIL param-imp 
        AND TRIM(SUBSTRING(param-imp.char-1,227,1)) = "1":U THEN DO: /*Tabela Ato Concessório - IM0000 Folder Drawback*/
        {utp/ut-liter.i "Altera‡Æo"}
        RUN pi-cria-historico-criacao-alteracao(INPUT RETURN-VALUE).
    END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atoConcessorioOrdem DBOProgram 
PROCEDURE atoConcessorioOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no indice CH-PEDIDO
  Parameters:
               recebe valor dos campos do indice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-rowid as rowid NO-UNDO.
    DEFINE OUTPUT PARAMETER p-ordem LIKE ordens-embarque.numero-ordem NO-UNDO.
    DEFINE OUTPUT PARAMETER p-item  LIKE pedido-drb-item.it-codigo    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-parcela LIKE ordens-embarque.parcela    NO-UNDO.
     
    for first ordens-embarque fields(numero-ordem) no-lock 
        where rowid(ordens-embarque) = p-rowid:
    end.
    if avail ordens-embarque then do:
        for first ordem-compra fields(numero-ordem it-codigo) no-lock 
            where ordem-compra.numero-ordem = ordens-embarque.numero-ordem:
        end.
        if avail ordem-compra then
           assign p-ordem   = ordem-compra.numero-ordem
                  p-item    = ordem-compra.it-codigo
                  p-parcela = ordens-embarque.parcela.
    end.
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AtualizaMotivoReprovacao DBOProgram 
PROCEDURE AtualizaMotivoReprovacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estabel       as char no-undo.
    def input param c-pedido-drb    as char no-undo.
    def input param c-motivo-reprov as char no-undo.

    find pedido-drb exclusive-lock 
        where pedido-drb.cod-estabel   = c-estabel 
          and pedido-drb.nr-pedido-drb = c-pedido-drb no-error.
    if avail pedido-drb then
        assign pedido-drb.motivo-reprovacao = c-motivo-reprov
               pedido-drb.cod-sit-ped-drb   = 3.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AtualizaSituacaoPedido DBOProgram 
PROCEDURE AtualizaSituacaoPedido :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estabel       as char no-undo.
    def input param c-pedido-drb    as char no-undo.
    
    find pedido-drb exclusive-lock
        where pedido-drb.cod-estabel   = c-estabel 
          and pedido-drb.nr-pedido-drb = c-pedido-drb no-error.
    if avail pedido-drb then
        assign pedido-drb.cod-sit-ped-drb = 2.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeCreateRecord DBOProgram 
PROCEDURE beforeCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS(char-1)
         WHERE param-imp.cod-estabel = RowObject.cod-estabel NO-LOCK:
    END.

    IF AVAIL param-imp 
        AND TRIM(SUBSTRING(param-imp.char-1,227,1)) = "1":U THEN DO: /*Tabela Ato Concessório - IM0000 Folder Drawback*/
        IF NOT VALID-HANDLE(h-exapi025) THEN
            RUN exp/exapi025.p PERSISTENT SET h-exapi025.

        RUN pi-salva-valor-antigo IN h-exapi025(INPUT "pedido-drb":U, INPUT ?).
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDeleteRecord DBOProgram 
PROCEDURE BeforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     Excluir os registros dos filhos do registro pai corrente
  Parameters:
               
  Notes:
------------------------------------------------------------------------------*/

    for each pedido-drb-di exclusive-lock 
        where pedido-drb-di.cod-estabel = rowobject.cod-estabel 
          and pedido-drb-di.nr-pedido-drb = rowobject.nr-pedido-drb use-index ch-di:
        delete pedido-drb-di.
    end.

    for each pedido-drb-re exclusive-lock 
        where pedido-drb-re.cod-estabel = rowobject.cod-estabel 
          and pedido-drb-re.nr-pedido-drb = rowobject.nr-pedido-drb use-index ch-re:
        delete pedido-drb-re.
    end.                              

    for each pedido-drb-item exclusive-lock 
        where pedido-drb-item.cod-estabel   = rowobject.cod-estabel 
          and pedido-drb-item.nr-pedido-drb = rowobject.nr-pedido-drb use-index ch-item
        break by idi-reg:

        if first-of(pedido-drb-item.idi-reg) then do:
            
            if pedido-drb-item.idi-reg = 1 then 

                for each tab-ocor exclusive-lock
                   where tab-ocor.cod-tab = 720 
                     and trim(substring(tab-ocor.char-1,76,5))   = pedido-drb-item.cod-estabel                    
                     and trim(substring(tab-ocor.char-1,40,20))  = pedido-drb-item.nr-pedido-drb:
                
                     delete tab-ocor.

                end.
            else
                for each tab-ocor exclusive-lock
                   where tab-ocor.cod-tab = 721
                     and trim(substring(tab-ocor.char-1,22,5))  = pedido-drb-item.cod-estabel
                     and trim(substring(tab-ocor.char-1,43,20)) = pedido-drb-item.nr-pedido-drb:
                    
                    delete tab-ocor.

                end.
        end.
        delete pedido-drb-item.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
    Notes:       
------------------------------------------------------------------------------*/
    FOR FIRST param-imp FIELDS(char-1)
        WHERE param-imp.cod-estabel = rowObject.cod-estabel NO-LOCK:
    END.

    IF AVAIL param-imp
       AND TRIM(SUBSTRING(param-imp.char-1,227,1)) = "1":U THEN DO: /*Tabela Ato Concessório - IM0000 Folder Drawback*/
            IF NOT VALID-HANDLE(h-exapi025) THEN
                RUN exp/exapi025.p PERSISTENT SET h-exapi025.
            
            RUN pi-salva-valor-antigo IN h-exapi025(INPUT "pedido-drb":U, INPUT rowObject.r-rowid). 
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaItemPedidoDrb DBOProgram 
PROCEDURE criaItemPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param c-estab  as char no-undo.
    def input param c-pedido as char no-undo.
    def output param table for tt-item-drb.
    
    empty temp-table tt-item-drb.
    
    for each pedido-drb-item fields(cod-estabel nr-pedido-drb it-codigo moeda peso-liquido preco-fob quantidade) 
        where pedido-drb-item.cod-estabel   = c-estab 
          and pedido-drb-item.nr-pedido-drb = c-pedido no-lock use-index ch-item:
    
        create tt-item-drb.
        assign tt-item-drb.cod-estabel   = pedido-drb-item.cod-estabel
               tt-item-drb.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
               tt-item-drb.it-codigo     = pedido-drb-item.it-codigo
               tt-item-drb.moeda         = pedido-drb-item.moeda
               tt-item-drb.peso-liquido  = pedido-drb-item.peso-liquido
               tt-item-drb.preco-fob     = pedido-drb-item.preco-fob
               tt-item-drb.quantidade    = pedido-drb-item.quantidade.
               
    end.  
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE elimina-movto DBOProgram 
PROCEDURE elimina-movto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-estabel LIKE pedido-drb.cod-estabel   NO-UNDO.
    DEF INPUT PARAM p-pedido  LIKE pedido-drb.nr-pedido-drb NO-UNDO.

    FOR EACH movto-ato
        WHERE movto-ato.cod-estabel   = p-estabel 
          AND movto-ato.nr-pedido-drb = p-pedido EXCLUSIVE-LOCK:
        DELETE movto-ato.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Existe-item DBOProgram 
PROCEDURE Existe-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM  c-estabel     AS CHAR NO-UNDO.
    DEF INPUT PARAM  c-pedido      AS CHAR NO-UNDO.
    DEF OUTPUT PARAM l-existe-item AS LOG  NO-UNDO.
    
    IF CAN-FIND(FIRST pedido-drb-item 
                WHERE pedido-drb-item.cod-estabel   = c-estabel
                  AND pedido-drb-item.nr-pedido-drb = c-pedido) THEN
        ASSIGN l-existe-item = YES.
    ELSE
        ASSIGN l-existe-item = NO.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Existe-item-re DBOProgram 
PROCEDURE Existe-item-re :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param c-estabel           LIKE pedido-drb-di.cod-estabel       no-undo.
    def input param c-pedido-drb        LIKE pedido-drb-di.nr-pedido-drb     no-undo.
    DEF INPUT PARAM i-num-re            LIKE pedido-drb-re.nr-re          NO-UNDO.
    def OUTPUT PARAM l-resultado        AS LOGICAL                           NO-UNDO.

    IF CAN-FIND(FIRST item-re WHERE
                      item-re.cod-estabel = c-estabel AND
                      item-re.nr-pedido-drb  = c-pedido-drb AND
                      item-re.num-re      = i-num-re) THEN
        ASSIGN l-resultado = YES.
    ELSE
        ASSIGN l-resultado = NO.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Existe-movto-ato DBOProgram 
PROCEDURE Existe-movto-ato :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param c-estabel           LIKE pedido-drb-di.cod-estabel       no-undo.
    def input param c-pedido-drb        LIKE pedido-drb-di.nr-pedido-drb     no-undo.
    def input param c-variavel          LIKE pedido-drb-di.declaracao-import no-undo.
    DEF INPUT PARAM i-codigo            AS INT                               NO-UNDO.
    def OUTPUT PARAM l-resultado        AS LOGICAL                           NO-UNDO.

    IF i-codigo = 1 THEN DO:
        IF CAN-FIND (FIRST movto-ato 
                     where movto-ato.cod-estabel   = c-estabel 
                       and movto-ato.nr-pedido-drb = c-pedido-drb 
                       AND movto-ato.it-codigo     = c-variavel) THEN
    
            ASSIGN l-resultado = YES.
        ELSE 
            ASSIGN l-resultado = NO.
    END.
    ELSE DO:    
        IF CAN-FIND (movto-ato 
                     where movto-ato.cod-estabel       = c-estabel 
                       and movto-ato.nr-pedido-drb     = c-pedido-drb 
                       AND movto-ato.declaracao-import = c-variavel) THEN
    
            ASSIGN l-resultado = YES.
        ELSE 
            ASSIGN l-resultado = NO.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Existe-movto-ato-nfe DBOProgram 
PROCEDURE Existe-movto-ato-nfe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM c-cod-ser-docto    LIKE ped-draw-nfe.cod-ser-docto    NO-UNDO.
    DEF INPUT PARAM c-cod-docto        LIKE ped-draw-nfe.cod-docto        NO-UNDO.
    DEF INPUT PARAM i-cdn-emitente     LIKE ped-draw-nfe.cdn-emitente     NO-UNDO.  
    DEF INPUT PARAM c-cod-natur-operac LIKE ped-draw-nfe.cod-natur-operac NO-UNDO.  
    DEF INPUT PARAM c-cod-estab        LIKE ped-draw-nfe.cod-estab        NO-UNDO.  
    DEF INPUT PARAM c-cod-ped-draw     LIKE ped-draw-nfe.cod-ped-draw     NO-UNDO. 
    DEF OUTPUT PARAM l-resultado       AS LOGICAL INITIAL NO              NO-UNDO.
    
    IF CAN-FIND (FIRST movto-ato 
                 WHERE movto-ato.serie  = c-cod-ser-docto
                   AND movto-ato.nro-docto = c-cod-docto
                   AND movto-ato.cod-emitente = i-cdn-emitente
                   AND movto-ato.nat-operacao = c-cod-natur-operac
                   AND movto-ato.cod-estabel = c-cod-estab
                   AND movto-ato.nr-pedido-drb = c-cod-ped-draw) THEN 

       ASSIGN l-resultado = YES.    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Existe-movto-ato-nfs DBOProgram 
PROCEDURE Existe-movto-ato-nfs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM c-cod-serie    LIKE ped-draw-nfs.cod-serie    NO-UNDO.
    DEF INPUT PARAM c-cod-fatura   LIKE ped-draw-nfs.cod-fatura   NO-UNDO.
    DEF INPUT PARAM c-cod-estab    LIKE ped-draw-nfs.cod-estab    NO-UNDO.  
    DEF INPUT PARAM c-cod-ped-draw LIKE ped-draw-nfs.cod-ped-draw NO-UNDO.  
    DEF OUTPUT PARAM l-resultado   AS LOGICAL INITIAL NO          NO-UNDO.
    
    IF CAN-FIND (FIRST movto-ato 
                 WHERE movto-ato.serie  = c-cod-serie           
                   AND movto-ato.nro-docto = c-cod-fatura        
                   AND movto-ato.cod-estabel = c-cod-estab      
                   AND movto-ato.nr-pedido-drb = c-cod-ped-draw) THEN
    
       ASSIGN l-resultado = YES.
   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerattItensDi DBOProgram 
PROCEDURE gerattItensDi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-r-pedido-drb AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-itens-di.

    DEFINE VARIABLE de-valor-item-conv  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-tot-quant AS DECIMAL    NO-UNDO.

    EMPTY TEMP-TABLE tt-itens-di.

    FIND bfPedido-drb WHERE ROWID(bfPedido-drb) = p-r-pedido-drb NO-LOCK NO-ERROR.
    
    If avail bfPedido-drb then do:

        For each pedido-drb-di where pedido-drb-di.cod-estabel = bfPedido-drb.cod-estabel and
                                     pedido-drb-di.nr-pedido-drb = bfPedido-drb.nr-pedido-drb NO-LOCK:

            for each embarque-imp WHERE embarque-imp.declaracao-import = pedido-drb-di.declaracao-import no-lock:

                find first ordens-embarque where ordens-embarque.cod-estabel = embarque-imp.cod-estabel AND
                                                 ordens-embarque.embarque  = embarque-imp.embarque no-lock no-error.

                if avail ordens-embarque then
                    find ordem-compra where ordem-compra.numero-ordem = ordens-embarque.numero-ordem no-lock no-error.

                If avail ordem-compra then do:
                    for each docum-est where docum-est.cod-emitente =  ordem-compra.cod-emitente no-lock:

                        if docum-est.char-1       = "":U then next.

                        {cdp/cd4300.i4 "yes" docum-est.char-1}
                        {rep/re1001a.i51 "yes"}

                        /*a vari vel c-embarque j  vem carregada com o n£mero do embarque do campo docum-est.char-1*/
                        if c-embarque = embarque-imp.embarque then do:
                            if docum-est.ce-atual then do:
                                for each item-doc-est where item-doc-est.serie-docto = docum-est.serie-docto   and
                                                            item-doc-est.nro-docto   = docum-est.nro-docto     and
                                                            item-doc-est.cod-emitente = docum-est.cod-emitente and
                                                            item-doc-est.nat-operacao = docum-est.nat-operacao 
                                                            NO-LOCK BREAK BY item-doc-est.it-codigo:

                                    ASSIGN de-tot-quant = de-tot-quant + item-doc-est.quantidade.

                                    IF LAST-OF (item-doc-est.it-codigo) THEN DO:
                                    
                                    FIND pedido-drb-item WHERE pedido-drb-item.cod-estabel = bfPedido-drb.cod-estabel AND
                                                               pedido-drb-item.nr-pedido-drb = bfPedido-drb.nr-pedido-drb AND
                                                               pedido-drb-item.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.

                                    IF AVAIL pedido-drb-item THEN DO:
                                        
                                            ASSIGN de-tot-quant = de-tot-quant - pedido-drb-item.quantidade.

                                            IF de-tot-quant <> 0 THEN DO:
                                            
                                                run cdp/cd0812.p (input 0,
                                                                  input ordem-compra.mo-codigo, 
                                                                  input (item-doc-est.preco-unit[1] * de-tot-quant),
                                                                  input embarque-imp.data-di,
                                                                  output de-valor-item-conv). 
    
                                                find first tt-itens-di where tt-itens-di.it-codigo = item-doc-est.it-codigo  no-error.
    
                                                If not avail tt-itens-di then do:
    
                                                    FIND ITEM WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.
    
                                                    Create  tt-itens-di.
    
                                                    Assign  tt-itens-di.cod-estabel = bfPedido-drb.cod-estabel
                                                            tt-itens-di.nr-pedido-drb =  bfPedido-drb.nr-pedido-drb 
                                                            tt-itens-di.it-codigo = item-doc-est.it-codigo
                                                            tt-itens-di.declaracao-import = embarque-imp.declaracao-import
                                                            tt-itens-di.moeda = ordem-compra.mo-codigo
                                                            tt-itens-di.un = item.un
                                                            tt-itens-di.quantidade = de-tot-quant
                                                            tt-itens-di.preco-fob = de-valor-item-conv.
                                                    
                                                end.
                                            END.
                                        
                                    END.
                                    
                                    IF NOT AVAIL pedido-drb-item THEN DO:

                                        run cdp/cd0812.p (input 0,
                                                          input ordem-compra.mo-codigo, 
                                                          input (item-doc-est.preco-unit[1] * de-tot-quant),
                                                          input embarque-imp.data-di,
                                                          output de-valor-item-conv). 
                                        
                                        find first tt-itens-di where tt-itens-di.it-codigo = item-doc-est.it-codigo  no-error.
                                        
                                        If not avail tt-itens-di then do:
                                        
                                            FIND ITEM WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-LOCK NO-ERROR.
                                            
                                            Create  tt-itens-di.
                                            Assign tt-itens-di.cod-estabel = bfPedido-drb.cod-estabel
                                                   tt-itens-di.nr-pedido-drb =  bfPedido-drb.nr-pedido-drb 
                                                   tt-itens-di.it-codigo = item-doc-est.it-codigo
                                                   tt-itens-di.declaracao-import = embarque-imp.declaracao-import
                                                   tt-itens-di.moeda = ordem-compra.mo-codigo
                                                   tt-itens-di.un = item.un
                                                   tt-itens-di.quantidade = de-tot-quant
                                                   tt-itens-di.preco-fob = de-valor-item-conv.
                                            

                                        end.
                                    END.
                                    ASSIGN de-tot-quant = 0.
                                    END.

                                end.
                            end.
                        end.
                    end.
                end.
            end.
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerattItensNfe DBOProgram 
PROCEDURE gerattItensNfe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-r-pedido-drb AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER l-tipo-item    AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-item-doc-est.

    DEFINE VARIABLE de-valor-item-conv  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-tot-quant AS DECIMAL    NO-UNDO.

    EMPTY TEMP-TABLE tt-item-doc-est.

    FIND bfPedido-drb WHERE ROWID(bfPedido-drb) = p-r-pedido-drb NO-LOCK NO-ERROR.

    IF AVAIL bfPedido-drb THEN DO:

       FOR EACH ped-draw-nfe 
           WHERE ped-draw-nfe.cod-estab = bfPedido-drb.cod-estabel 
           AND   ped-draw-nfe.cod-ped-draw = bfPedido-drb.nr-pedido-drb NO-LOCK:

           FOR EACH  docum-est 
               WHERE docum-est.serie-docto  = ped-draw-nfe.cod-ser-docto    
               AND   docum-est.nro-docto    = ped-draw-nfe.cod-docto        
               AND   docum-est.cod-emitente = ped-draw-nfe.cdn-emitente     
               AND   docum-est.nat-operacao = ped-draw-nfe.cod-natur-operac NO-LOCK: 

               IF docum-est.ce-atual THEN DO:
                   FOR FIRST emitente NO-LOCK
                       WHERE emitente.cod-emitente = docum-est.cod-emitente: END.
    
                   FOR FIRST estabelec NO-LOCK
                       WHERE estabelec.cod-estabel = docum-est.cod-estabel: END.
    
                   IF l-tipo-item
                       AND (emitente.natureza < 3 OR 
                               (emitente.natureza = 4 AND 
                                estabelec.pais = emitente.pais)
                            ) THEN
                       NEXT.
                   ELSE 
                       IF NOT l-tipo-item 
                           AND (emitente.natureza > 2 OR
                                    (emitente.natureza = 4 AND
                                     estabelec.pais <> emitente.pais)
                                )
                           THEN
                           NEXT.
    
                   FOR EACH item-doc-est 
                       WHERE item-doc-est.serie-docto  = docum-est.serie-docto   
                       AND   item-doc-est.nro-docto    = docum-est.nro-docto     
                       AND   item-doc-est.cod-emitente = docum-est.cod-emitente 
                       AND   item-doc-est.nat-operacao = docum-est.nat-operacao 
                       NO-LOCK:

                       /*Verificando se ainda nÆo foi alocado o item ao ato concess¢rio*/
                       IF NOT CAN-FIND(FIRST tab-ocor
                                       WHERE tab-ocor.cod-tab = 720
                                       AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = item-doc-est.serie-docto
                                       AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = item-doc-est.nro-docto  
                                       AND   TRIM(SUBSTRING(tab-ocor.char-1,22,6))  = item-doc-est.nat-operacao
                                       AND   TRIM(SUBSTRING(tab-ocor.char-1,28,12)) = STRING(item-doc-est.cod-emitente)
                                       AND   tab-ocor.int-1                         = item-doc-est.sequencia
                                       AND   tab-ocor.int-2                         = 1 /*Tipo Entrada*/
                                       AND   tab-ocor.log-1                         = l-tipo-item /*Nacional ou Internacional*/
                                       ) OR
                           CAN-FIND(FIRST tab-ocor
                                    WHERE tab-ocor.cod-tab = 720
                                    AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = item-doc-est.serie-docto
                                    AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = item-doc-est.nro-docto  
                                    AND   TRIM(SUBSTRING(tab-ocor.char-1,22,6))  = item-doc-est.nat-operacao
                                    AND   TRIM(SUBSTRING(tab-ocor.char-1,28,12)) = STRING(item-doc-est.cod-emitente)
                                    AND   tab-ocor.int-1                         = item-doc-est.sequencia
                                    AND   tab-ocor.int-2                         = 1 /*Tipo Entrada*/
                                    AND   tab-ocor.log-1                         = l-tipo-item /*Nacional ou Internacional*/ 
                                    AND   tab-ocor.dec-1                         < item-doc-est.quantidade)
                                    THEN DO:

                           CREATE tt-item-doc-est.
                           BUFFER-COPY item-doc-est EXCEPT item-doc-est.quantidade TO tt-item-doc-est.
                           ASSIGN tt-item-doc-est.declaracao-import = SUBSTRING(ped-draw-nfe.cod-livre-1,1,20)
                                  tt-item-doc-est.int-1             = docum-est.mo-codigo.

                           FOR FIRST tab-ocor NO-LOCK
                               WHERE tab-ocor.cod-tab = 720
                               AND   trim(SUBSTRING(tab-ocor.char-1,1,5))   = item-doc-est.serie-docto
                               AND   trim(SUBSTRING(tab-ocor.char-1,6,16))  = item-doc-est.nro-docto  
                               AND   trim(SUBSTRING(tab-ocor.char-1,22,6))  = item-doc-est.nat-operacao
                               AND   trim(SUBSTRING(tab-ocor.char-1,28,12)) = STRING(item-doc-est.cod-emitente)
                               AND   tab-ocor.int-1                   = item-doc-est.sequencia
                               AND   tab-ocor.int-2                   = 1 /*Tipo Entrada*/
                               AND   tab-ocor.log-1                   = l-tipo-item /*Nacional ou Internacional*/ :

                               ASSIGN tt-item-doc-est.quantidade = item-doc-est.quantidade - tab-ocor.dec-1.
                                
                           END.

                           IF NOT AVAIL tab-ocor THEN
                               ASSIGN tt-item-doc-est.quantidade = item-doc-est.quantidade.
                       END.
                   END.
               END.
           END.
       END.    
    END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gerattItensNfs DBOProgram 
PROCEDURE gerattItensNfs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-r-pedido-drb AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER l-tipo-item    AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-it-nota-fisc.

    DEFINE VARIABLE de-valor-item-conv  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-tot-quant        AS DECIMAL NO-UNDO.

    EMPTY TEMP-TABLE tt-it-nota-fisc.

    FIND FIRST bfPedido-drb WHERE ROWID(bfPedido-drb) = p-r-pedido-drb NO-LOCK NO-ERROR.

    IF AVAIL bfPedido-drb THEN DO:

       FOR EACH ped-draw-nfs 
           WHERE ped-draw-nfs.cod-estab    = bfPedido-drb.cod-estabel 
           AND   ped-draw-nfs.cod-ped-draw = bfPedido-drb.nr-pedido-drb NO-LOCK:

           FOR EACH  nota-fiscal 
               WHERE nota-fiscal.serie       = ped-draw-nfs.cod-serie    
               AND   nota-fiscal.cod-estabel = ped-draw-nfs.cod-estab        
               AND   nota-fiscal.nr-nota-fis = ped-draw-nfs.cod-fatura NO-LOCK: 

               FOR FIRST emitente NO-LOCK
                   WHERE emitente.cod-emitente = nota-fiscal.cod-emitente: END.

               FOR FIRST estabelec NO-LOCK
                   WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel: END.

               IF l-tipo-item
                   AND (emitente.natureza < 3 OR 
                           (emitente.natureza = 4 AND 
                            estabelec.pais = emitente.pais)
                        ) THEN
                   NEXT.
               ELSE 
                   IF NOT l-tipo-item 
                       AND (emitente.natureza > 2 OR
                                (emitente.natureza = 4 AND
                                 estabelec.pais <> emitente.pais)
                            )
                       THEN
                       NEXT.

               FOR EACH it-nota-fisc 
                   WHERE it-nota-fisc.serie        = nota-fiscal.serie       
                   AND   it-nota-fisc.cod-estabel  = nota-fiscal.cod-estabel 
                   AND   it-nota-fisc.nr-nota-fis  = nota-fiscal.nr-nota-fis
                   NO-LOCK:

                   /*Verificando se ainda nÆo foi alocado o item ao ato concess¢rio*/
                   IF NOT CAN-FIND(FIRST tab-ocor
                                       WHERE tab-ocor.cod-tab = 721
                                       AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = it-nota-fisc.serie
                                       AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = it-nota-fisc.nr-nota-fis  
                                       AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = it-nota-fisc.cod-estabel
                                       AND   tab-ocor.int-1                         = it-nota-fisc.nr-seq-fat
                                       AND   tab-ocor.int-2                         = 2 /*Tipo Saida*/
                                       AND   tab-ocor.log-1                         = l-tipo-item /*Nacional ou Internacional*/
                                       ) OR
                       CAN-FIND(FIRST tab-ocor
                                WHERE tab-ocor.cod-tab = 721
                                AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = it-nota-fisc.serie         
                                AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = it-nota-fisc.nr-nota-fis   
                                AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = it-nota-fisc.cod-estabel   
                                AND   tab-ocor.int-1                         = it-nota-fisc.nr-seq-fat    
                                AND   tab-ocor.int-2                         = 2 /*Tipo Saida*/
                                AND   tab-ocor.log-1                         = l-tipo-item /*Nacional ou Internacional*/ 
                                AND   tab-ocor.dec-1                         < it-nota-fisc.qt-faturada[1])
                                THEN DO:

                       CREATE tt-it-nota-fisc.
                       BUFFER-COPY it-nota-fisc TO tt-it-nota-fisc.
                       ASSIGN tt-it-nota-fisc.int-1      = INT(nota-fiscal.mo-codigo)
                              tt-it-nota-fisc.desc-devol = TRIM(SUBSTRING(ped-draw-nfs.cod-livre-1,1,20)) /* campo usado para gravar o numero do registro de exporta‡ao*/ .

                       FOR FIRST tab-ocor NO-LOCK
                           WHERE tab-ocor.cod-tab = 721
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = it-nota-fisc.serie         
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = it-nota-fisc.nr-nota-fis   
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = it-nota-fisc.cod-estabel   
                           AND   tab-ocor.int-1                         = it-nota-fisc.nr-seq-fat    
                           AND   tab-ocor.int-2                         = 2 /*Tipo Saida*/
                           AND   tab-ocor.log-1                         = l-tipo-item /*Nacional ou Internacional*/ :

                           ASSIGN tt-it-nota-fisc.qt-faturada[1] = tt-it-nota-fisc.qt-faturada[1] - tab-ocor.dec-1.
                            
                       END.

                       IF NOT AVAIL tab-ocor THEN
                           ASSIGN tt-it-nota-fisc.qt-faturada[1] = it-nota-fisc.qt-faturada[1].

                   END.
               END.
           END.
       END.    
    END.    
    
                           
   /*Create  tt-itens-nfs.
   Assign  tt-itens-nfs.cod-estabel   = bfPedido-drb.cod-estabel
           tt-itens-nfs.cod-serie     = nota-fiscal.serie                   
           tt-itens-nfs.cod-fatura    = nota-fiscal.nr-nota-fis                
           tt-itens-nfs.nr-pedido-drb =  bfPedido-drb.nr-pedido-drb 
           tt-itens-nfs.it-codigo     = it-nota-fisc.it-codigo                                   
           tt-itens-nfs.un = item.un
           
           tt-itens-nfs.qtd-item-nac  = de-tot-quant
           tt-itens-nfs.val-fob-nac   = de-valor-item-conv  
           tt-itens-nfs.cdn-moed-nac  = INT(nota-fiscal.mo-codigo)
           tt-itens-nfs.val-unit-nac  = it-nota-fisc.vl-preori

           tt-itens-nfs.nr-seq-fat    = it-nota-fisc.nr-seq-fat                                                     
           tt-itens-nfs.cod-emitente  = nota-fiscal.cod-emitente        
           tt-itens-nfs.nat-operacao  = it-nota-fisc.nat-operacao          
           tt-itens-nfs.dt-emis-nota  = nota-fiscal.dt-emis-nota                 
           tt-itens-nfs.peso-liquido  = it-nota-fisc.peso-liq-fat 
           tt-itens-nfs.class-fiscal  = item.class-fiscal.        */                                           

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
        WHEN "nr-pedido-drb":U THEN ASSIGN pFieldValue = RowObject.nr-pedido-drb.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "Motivo-reprovacao":U THEN ASSIGN pFieldValue = RowObject.Motivo-reprovacao.
        WHEN "nr-ato-concessorio":U THEN ASSIGN pFieldValue = RowObject.nr-ato-concessorio.

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
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-emissao":U THEN ASSIGN pFieldValue = RowObject.data-emissao.
        WHEN "data-emissao-ato":U THEN ASSIGN pFieldValue = RowObject.data-emissao-ato.
        WHEN "data-validade-ato":U THEN ASSIGN pFieldValue = RowObject.data-validade-ato.
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

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "Cod-sit-ped-drb":U THEN ASSIGN pFieldValue = RowObject.Cod-sit-ped-drb.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "modalidade":U THEN ASSIGN pFieldValue = RowObject.modalidade.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice CH-PEDIDO
  Parameters:
               retorna valor dos campos do ¡ndice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-estabel LIKE Pedido-drb.cod-estabel NO-UNDO.
    DEFINE OUTPUT PARAMETER pnr-pedido-drb LIKE Pedido-drb.nr-pedido-drb NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pcod-estabel = RowObject.cod-estabel.
    ASSIGN pnr-pedido-drb = RowObject.nr-pedido-drb.

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
         
    &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN     
        CASE pFieldName: 
            WHEN "log-draw-integrad":U THEN ASSIGN pFieldValue = RowObject.log-draw-integrad.       
            WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1. 
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
            OTHERWISE RETURN "NOK":U.
        END CASE.
    &ELSE 
        CASE pFieldName:      
            WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1. 
            WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
            OTHERWISE RETURN "NOK":U.
        END CASE.
    &ENDIF
      
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToAtoConcessorio DBOProgram 
PROCEDURE goToAtoConcessorio :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CH-PEDIDO
  Parameters:
               recebe valor dos campos do ¡ndice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ato-concessorio LIKE Pedido-drb.nr-ato-concessorio NO-UNDO.

    FOR FIRST bfPedido-drb NO-LOCK WHERE
                bfPedido-drb.nr-ato-concessorio = pnr-ato-concessorio
                use-index ch-ato:
    END.

      /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfPedido-drb THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
/*    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfPedido-drb)).*/
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
                                                                                                    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToAtoConcessorioItem DBOProgram 
PROCEDURE goToAtoConcessorioItem :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CH-PEDIDO
  Parameters:
               recebe valor dos campos do ¡ndice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ato-concessorio LIKE Pedido-drb.nr-ato-concessorio NO-UNDO.
    DEFINE INPUT PARAMETER pnum-ordem as int NO-UNDO.    

    FOR FIRST bfPedido-drb NO-LOCK WHERE
                bfPedido-drb.nr-ato-concessorio = pnr-ato-concessorio
                use-index ch-ato:
      END.
      if avail bfPedido-drb then
          for first pedido-drb-item NO-LOCK where 
                    pedido-drb-item.nr-pedido-drb = bfPedido-drb.nr-pedido-drb:
          end.
    

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE Pedido-drb-item THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
/*    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfPedido-drb)). j[a estava*/
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice CH-PEDIDO
  Parameters:
               recebe valor dos campos do ¡ndice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel LIKE Pedido-drb.cod-estabel NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE Pedido-drb.nr-pedido-drb NO-UNDO.
    DEFINE INPUT PARAMETER pnr-ato LIKE Pedido-drb.nr-ato-concessorio NO-UNDO.

    
    if pcod-estabel <> "" and pnr-pedido-drb <> "" and pnr-ato = "" then
          FOR FIRST bfPedido-drb no-lock WHERE
                    bfPedido-drb.cod-estabel   = pcod-estabel AND
                    bfPedido-drb.nr-pedido-drb = pnr-pedido-drb
                    use-index ch-pedido:
          END.
              
      else if pcod-estabel <> "" and pnr-pedido-drb = "" and pnr-ato <> "" then
              FOR FIRST bfPedido-drb NO-LOCK WHERE
                        bfPedido-drb.cod-estabel = pcod-estabel AND
                        bfPedido-drb.nr-ato-concessorio = pnr-ato:
              END.
                        
           else if pcod-estabel <> "" and pnr-pedido-drb <> "" and pnr-ato <> "" then
                  FOR FIRST bfPedido-drb NO-LOCK WHERE
                            bfPedido-drb.cod-estabel = pcod-estabel AND
                            bfPedido-drb.nr-ato-concessorio = pnr-ato and
                            bfPedido-drb.nr-pedido-drb = pnr-pedido-drb:
                  END.
                else if pcod-estabel = "" and pnr-pedido-drb = "" and pnr-ato <> "" then
                          FOR FIRST bfPedido-drb NO-LOCK WHERE
                                    bfPedido-drb.nr-ato-concessorio = pnr-ato
                                    use-index ch-ato:
                          END.
                     else if pcod-estabel = "" and pnr-pedido-drb <> "" and pnr-ato = "" then
                              FOR FIRST bfPedido-drb NO-LOCK WHERE
                                        bfPedido-drb.nr-pedido-drb = pnr-pedido-drb:
                              END.
                          else RETURN "NOK":U.
         
    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfPedido-drb THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfPedido-drb)).
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
 define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
           run openQueryStatic ("Main").
        when 2 then 
           run openQueryStatic ("CodEstabel").           
        end. /*end case*/
   RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryAtoFaixa DBOProgram 
PROCEDURE openQueryAtoFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 open query qrPedido-drb for each pedido-drb no-lock 
                            where pedido-drb.cod-estabel >= c-estabini       and
                                  pedido-drb.cod-estabel <= c-estabfin       and
                                  pedido-drb.nr-ato-concessorio >= c-ato-ini and
                                  pedido-drb.nr-ato-concessorio <= c-ato-fin
                                  BY pedido-drb.nr-ato-concessorio
                                  BY pedido-drb.cod-estabel
                                  BY pedido-drb.nr-pedido-drb
                                  INDEXED-REPOSITION.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryCodEstabel DBOProgram 
PROCEDURE openQueryCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH Pedido-drb NO-LOCK 
                               where Pedido-drb.cod-estabel >= c-estabini and
                                     Pedido-drb.cod-estabel <= c-estabfin 
                                     USE-INDEX ch-pedido
                                     INDEXED-REPOSITION.

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

    OPEN QUERY {&QueryName} FOR EACH Pedido-drb NO-LOCK
                                  USE-INDEX ch-pedido
                                  INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain1 DBOProgram 
PROCEDURE openQueryMain1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName} FOR EACH Pedido-drb NO-LOCK 
                                  by Pedido-drb.nr-pedido-drb
                                  by Pedido-drb.cod-estabel
                                  INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryPedidoFaixa DBOProgram 
PROCEDURE openQueryPedidoFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

 open query qrPedido-drb for each pedido-drb no-lock where    
                                  pedido-drb.cod-estabel   >= c-estabini   and
                                  pedido-drb.cod-estabel   <= c-estabfin   and
                                  pedido-drb.nr-pedido-drb >= c-pedido-ini and
                                  pedido-drb.nr-pedido-drb <= c-pedido-fin
                                  BY pedido-drb.nr-pedido-drb
                                  BY pedido-drb.cod-estabel
                                  BY pedido-drb.nr-ato-concessorio
                                  INDEXED-REPOSITION.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRowPai DBOProgram 
PROCEDURE openQueryRowPai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-log-draw-integrad DBOProgram 
PROCEDURE pi-busca-log-draw-integrad :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM  p-cod-estabel       LIKE {&TableName}.cod-estabel       NO-UNDO.
    DEFINE INPUT PARAM  p-nr-pedido-drb     LIKE {&TableName}.nr-pedido-drb     NO-UNDO.
    DEFINE OUTPUT PARAM l-log-draw-integrad LIKE {&TableName}.log-draw-integrad NO-UNDO.

    FOR FIRST pedido-drb NO-LOCK
        WHERE pedido-drb.cod-estabel = p-cod-estabel 
        AND   pedido-drb.nr-pedido-drb = p-nr-pedido-drb:
        ASSIGN l-log-draw-integrad = pedido-drb.log-draw-integrad.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-historico-criacao-alteracao DBOProgram 
PROCEDURE pi-cria-historico-criacao-alteracao :
/*------------------------------------------------------------------------------------------
Purpose:    Realiza a cria‡Æo do hist¢rico de cria‡Æo/altera‡Æo.
Parameters: c-metodo       : INPUT  : M²todo(Cria‡Æo, Altera‡Æo);
Notes: 
------------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER c-metodo AS CHARACTER   NO-UNDO.

    /* Verifica qual o £ltimo programa .w que executou esta procedure */
    ASSIGN i-nivel = 1.
    nivel_block:
    REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?.
        ASSIGN c-programa = REPLACE(PROGRAM-NAME(i-nivel),"~/","~\")
               i-nivel = i-nivel + 1.

        IF c-programa MATCHES "*men*":U THEN NEXT.
        IF c-programa MATCHES "*.w":U THEN
            ASSIGN c-ultimo-programa = c-programa
                   c-ultimo-programa = ENTRY(NUM-ENTRIES(c-programa,"~\"),c-programa,"~\").

    END.

    FOR FIRST pedido-drb NO-LOCK
        WHERE pedido-drb.cod-estabel = RowObject.cod-estabel
        AND   pedido-drb.nr-pedido-drb = RowObject.nr-pedido-drb:
        ASSIGN r-rowidAux = rowid(pedido-drb).
    END.


    IF NOT VALID-HANDLE(h-exapi025) THEN
        RUN exp/exapi025.p PERSISTENT SET h-exapi025.

    RUN pi-salva-alteracao IN h-exapi025 (INPUT c-metodo, INPUT "pedido-drb":U, INPUT r-rowidAux, INPUT c-ultimo-programa).


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-movimentos DBOProgram 
PROCEDURE pi-gera-movimentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-r-pedido-drb AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER p-idi-reg      AS INT   NO-UNDO.
    DEFINE INPUT PARAMETER p-l-tipo-item  AS LOG   NO-UNDO.
    DEFINE INPUT PARAMETER TABLE FOR tt-itens-nfe-imp.

    DEFINE VARIABLE i-cont          AS INTEGER    NO-UNDO.
    DEFINE VARIABLE de-valor-conv   AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-quant-saldo  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-valor-saldo  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-quant-saldo-ent  AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-quant-saldo-baixa  AS DECIMAL NO-UNDO.

    DEFINE VARIABLE c-modalidade AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-modalidade AS INTEGER    NO-UNDO.
    DEFINE VARIABLE de-val-orig AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-val-cotacao AS DECIMAL NO-UNDO.
    DEFINE VARIABLE de-tot-itens  AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE de-tot-saldo AS DECIMAL    NO-UNDO.

    DEFINE VARIABLE i-idi-tipo-item AS INT NO-UNDO.

    DEFINE BUFFER b-movto-ato FOR movto-ato.

    DEFINE VARIABLE c-it-codigo AS CHAR NO-UNDO.
    DEFINE VARIABLE c-cod-estab AS CHAR NO-UNDO.
    DEFINE VARIABLE c-nr-pedido-drb AS CHAR NO-UNDO.
    DEFINE VARIABLE h-bocx315 AS HANDLE      NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx332) OR
        h-bocx332:TYPE <> "PROCEDURE":U OR
        h-bocx332:FILE-NAME <> "cxbo/bocx332.p":U THEN DO:
        RUN cxbo/bocx332.p PERSISTEN SET h-bocx332.
    END.

    IF NOT VALID-HANDLE(h-bocx315) THEN
        RUN cxbo/bocx315.p PERSISTENT SET h-bocx315.

    RUN openQueryMain.

    IF p-l-tipo-item THEN
        ASSIGN i-idi-tipo-item = 1.
    ELSE
        ASSIGN i-idi-tipo-item = 2.

    FOR EACH tt-itens-nfe-imp:
        FIND FIRST ped-draw-nfe NO-LOCK
            WHERE ped-draw-nfe.cod-ser-docto     = tt-itens-nfe-imp.cod-ser-docto
            AND   ped-draw-nfe.cod-docto         = tt-itens-nfe-imp.cod-docto
            AND   ped-draw-nfe.cdn-emitente      = tt-itens-nfe-imp.cdn-emitente
            AND   ped-draw-nfe.cod-natur-operac  = tt-itens-nfe-imp.cod-natur-operac
            AND   ped-draw-nfe.cod-ped-draw      = tt-itens-nfe-imp.nr-pedido-drb
            AND   ped-draw-nfe.cod-estab         = tt-itens-nfe-imp.cod-estabel        NO-ERROR.
        
        IF p-l-tipo-item THEN
            ASSIGN de-tot-itens = tt-itens-nfe-imp.quantidade.
        ELSE
            ASSIGN de-tot-itens = tt-itens-nfe-imp.qtd-item-nac.

        FOR FIRST docum-est NO-LOCK
            WHERE docum-est.serie-docto  = tt-itens-nfe-imp.cod-ser-docto   
              AND docum-est.nro-docto    = tt-itens-nfe-imp.cod-docto     
              AND docum-est.cod-emitente = tt-itens-nfe-imp.cdn-emitente 
              AND docum-est.nat-operacao = tt-itens-nfe-imp.cod-natur-operac: END.

            if docum-est.ce-atual then do:
                for FIRST item-doc-est where item-doc-est.serie-docto = docum-est.serie-docto      and
                                            item-doc-est.nro-docto    = docum-est.nro-docto        and
                                            item-doc-est.cod-emitente = docum-est.cod-emitente     and
                                            item-doc-est.nat-operacao = docum-est.nat-operacao     and
                                            item-doc-est.sequencia    = tt-itens-nfe-imp.seq-docto AND
                                            item-doc-est.it-codigo    = tt-itens-nfe-imp.it-codigo NO-LOCK:

                    /*Grava o valor do embarque na c-embarque*/
                    {cdp/cd4300.i4 "yes" docum-est.char-1}
                    {rep/re1001a.i51 "yes"}
                    /*Grava o valor do embarque na c-embarque*/


                    find item where item.it-codigo = item-doc-est.it-codigo no-lock no-error.

                    find classif-fisc no-lock  where classif-fisc.class-fiscal = item.class-fiscal no-error.
                    
                    find ordem-compra where ordem-compra.numero-ordem = item-doc-est.numero-ordem no-lock no-error.
                    
                    IF AVAIL ordem-compra THEN
                        find moeda where moeda.mo-codigo = ordem-compra.mo-codigo no-lock no-error.
                    ELSE 
                        find moeda where moeda.mo-codigo = docum-est.mo-codigo no-lock no-error.

                    if not avail moeda then
                        find moeda where moeda.mo-codigo = 0 no-lock no-error.

                    IF CAN-FIND(FIRST embarque-imp
                                WHERE embarque-imp.embarque = trim(c-embarque)) THEN
                        FOR FIRST embarque-imp NO-LOCK
                            WHERE embarque-imp.embarque = trim(c-embarque):
                            ASSIGN d-data-di = embarque-imp.data-di.
                        END.
                    ELSE
                        ASSIGN d-data-di = TODAY.
                    
                    find first movto-ato where movto-ato.cod-estabel        = docum-est.cod-estabel          and
                                               movto-ato.nr-pedido-drb      = tt-itens-nfe-imp.nr-pedido-drb and        
                                               movto-ato.it-codigo          = item-doc-est.it-codigo         and
                                               movto-ato.seq-docto          = item-doc-est.sequencia         and
                                               movto-ato.nro-docto          = item-doc-est.nro-docto         and
                                               movto-ato.serie              = item-doc-est.serie-docto       and
                                               movto-ato.nat-operacao       = item-doc-est.nat-operacao      and
                                               movto-ato.cod-emitente       = item-doc-est.cod-emitente      and
                                               movto-ato.idi-tip-item-movto = i-idi-tipo-item
                                               exclusive-lock no-error.
                    
                    IF NOT AVAIL movto-ato THEN DO:
                        FIND LAST b-movto-ato WHERE  b-movto-ato.cod-estabel   = docum-est.cod-estabel and
                                                     b-movto-ato.nr-pedido-drb = tt-itens-nfe-imp.nr-pedido-drb and 
                                                     b-movto-ato.it-codigo     = item-doc-est.it-codigo 
                                                     NO-LOCK NO-ERROR.   
                                                      
                        IF AVAIL b-movto-ato THEN
                            ASSIGN i-cont = b-movto-ato.sequencia.

                        IF de-tot-itens <> 0 THEN DO:

                            Assign i-cont = i-cont + 1.
                            
                            Create  movto-ato.
                            Assign  movto-ato.dat-movto           = today
                                    movto-ato.nro-docto           = docum-est.nro-docto
                                    movto-ato.serie               = docum-est.serie-docto
                                    movto-ato.nat-operacao        = docum-est.nat-operacao
                                    movto-ato.cod-emitente        = docum-est.cod-emitente
                                    movto-ato.declaracao-import   = SUBSTRING(ped-draw-nfe.cod-livre-1,1,20) /*embarque-imp.declaracao-import*/
                                    movto-ato.dat-decla-import    = d-data-di /*embarque-imp.data-di*/
                                    movto-ato.dat-nf              = docum-est.dt-trans
                                    movto-ato.cdd-ncm             = classif-fisc.class-fiscal
                                    movto-ato.val-peso            = item-doc-est.peso-liquido
                                    movto-ato.un                  = item.un
                                    movto-ato.mo-codigo           = moeda.mo-codigo /*moeda ordem-compra*/
                                    movto-ato.cod-estabel         = tt-itens-nfe-imp.cod-estabel
                                    movto-ato.cod-estab-docto     = docum-est.cod-estabel
                                    movto-ato.nr-pedido-drb       = tt-itens-nfe-imp.nr-pedido-drb         
                                    movto-ato.it-codigo           = item-doc-est.it-codigo 
                                    movto-ato.seq-docto           = item-doc-est.sequencia
                                    movto-ato.idi-tip-movto       = i-idi-tip-movto
                                    movto-ato.sequencia           = i-cont + 1
                                    movto-ato.dat-cotac           = d-data-di /*embarque-imp.data-1*/
                                    movto-ato.idi-tip-item-movto  = i-idi-tipo-item.

                                IF de-tot-itens > item-doc-est.quantidade THEN DO:
                                    IF moeda.mo-codigo <> 0 THEN
                                        run cdp/cd0812.p (input 0,
                                                          input moeda.mo-codigo, 
                                                          input (item-doc-est.preco-unit[1] * item-doc-est.quantidade),
                                                          input  d-data-di, /*embarque-imp.data-di,*/
                                                          output de-valor-conv).
                                    ELSE 
                                        ASSIGN de-valor-conv = item-doc-est.preco-unit[1] * item-doc-est.quantidade.

                                    ASSIGN movto-ato.val-quant-movto-ato = item-doc-est.quantidade
                                           movto-ato.val-movto-ato-me    = de-valor-conv
                                           movto-ato.val-movto-ato-orig  = item-doc-est.preco-unit[1] * item-doc-est.quantidade
                                           de-tot-itens = de-tot-itens - item-doc-est.quantidade.
                                END.
                                ELSE DO:
                                    IF moeda.mo-codigo <> 0 THEN
                                        run cdp/cd0812.p (input 0,
                                                          input moeda.mo-codigo, 
                                                          input (item-doc-est.preco-unit[1] * de-tot-itens),
                                                          input d-data-di, /*embarque-imp.data-di,*/
                                                          output de-valor-conv).
                                    ELSE
                                        ASSIGN de-valor-conv = item-doc-est.preco-unit[1] * de-tot-itens.

                                    ASSIGN movto-ato.val-quant-movto-ato = de-tot-itens
                                           movto-ato.val-movto-ato-me    = de-valor-conv
                                           movto-ato.val-movto-ato-orig  = item-doc-est.preco-unit[1] * de-tot-itens
                                           de-tot-itens = 0
                                           de-tot-saldo = 0.
                                END.

                                RUN atualiza-valor-moeda IN h-bocx332 (INPUT  movto-ato.cod-estab-docto,
                                                                       INPUT  movto-ato.it-codigo,       
                                                                       INPUT  movto-ato.mo-codigo,       
                                                                       INPUT  movto-ato.dat-cotac,       
                                                                       INPUT  movto-ato.val-movto-ato-me,
                                                                      OUTPUT  de-val-orig,
                                                                      OUTPUT  de-val-cotacao). 

                                ASSIGN movto-ato.cotacao = de-val-cotacao
                                       movto-ato.val-movto-ato-orig = de-val-orig.

                        END.
                    END.
                    else do:

                        IF de-tot-itens > item-doc-est.quantidade THEN DO:

                            ASSIGN de-tot-saldo = de-tot-itens - item-doc-est.quantidade.
                            ASSIGN de-tot-itens = de-tot-itens - movto-ato.val-quant-movto-ato - de-tot-saldo.

                            IF moeda.mo-codigo <> 0 THEN
                                run cdp/cd0812.p (input 0,
                                                  input moeda.mo-codigo, 
                                                  input (item-doc-est.preco-unit[1] * de-tot-itens),
                                                  input d-data-di, /*embarque-imp.data-di,*/
                                                  output de-valor-conv).
                            ELSE
                                ASSIGN de-valor-conv = item-doc-est.preco-unit[1] * de-tot-itens.

                            assign movto-ato.val-quant-movto-ato = movto-ato.val-quant-movto-ato + de-tot-itens
                                   movto-ato.val-movto-ato-me    = movto-ato.val-movto-ato-me + de-valor-conv
                                   de-tot-itens = de-tot-saldo.
                        END.
                        ELSE DO:
                            
                            IF moeda.mo-codigo <> 0 THEN
                                run cdp/cd0812.p (input 0,
                                                  input moeda.mo-codigo, 
                                                  input (item-doc-est.preco-unit[1] * de-tot-itens),
                                                  input d-data-di, /*embarque-imp.data-di,*/
                                                  output de-valor-conv).
                            ELSE
                                ASSIGN de-valor-conv = item-doc-est.preco-unit[1] * de-tot-itens.

                            assign movto-ato.val-quant-movto-ato = movto-ato.val-quant-movto-ato + de-tot-itens
                                   movto-ato.val-movto-ato-me    = movto-ato.val-movto-ato-me + de-valor-conv.
                                   


                        END.


                        RUN atualiza-valor-moeda IN h-bocx332 (INPUT  movto-ato.cod-estab-docto,
                                                               INPUT  movto-ato.it-codigo,       
                                                               INPUT  movto-ato.mo-codigo,       
                                                               INPUT  movto-ato.dat-cotac,       
                                                               INPUT  movto-ato.val-movto-ato-me,
                                                              OUTPUT  de-val-orig,
                                                              OUTPUT  de-val-cotacao).   
                        ASSIGN movto-ato.cotacao = de-val-cotacao
                               movto-ato.val-movto-ato-orig = de-val-orig.

                    end.
                  
                    IF AVAIL movto-ato THEN
                        ASSIGN c-cod-estab      = movto-ato.cod-estab-docto
                               c-nr-pedido-drb  = movto-ato.nr-pedido-drb
                               c-it-codigo      = movto-ato.it-codigo.

                end.
           end.

        /*atualiza saldo item de drawback*/                                                   
        RUN calculo-saldo-itens IN h-bocx332 (INPUT c-cod-estab,                              
                                              INPUT c-nr-pedido-drb,                          
                                              INPUT c-it-codigo,   
                                              INPUT i-idi-tipo-item,                           
                                              OUTPUT de-quant-saldo,                          
                                              OUTPUT de-valor-saldo,                          
                                              OUTPUT de-quant-saldo-ent,                      
                                              OUTPUT de-quant-saldo-baixa).  

        FIND FIRST pedido-drb-item 
             WHERE pedido-drb-item.cod-estabel   = c-cod-estab      
               AND pedido-drb-item.nr-pedido-drb = c-nr-pedido-drb  
               AND pedido-drb-item.it-codigo     = c-it-codigo  
               AND Pedido-drb-item.idi-reg       = p-idi-reg NO-LOCK NO-ERROR.         
        IF AVAIL pedido-drb-item THEN DO:
            CREATE tt-pedido-drb-item.
            BUFFER-COPY pedido-drb-item TO tt-pedido-drb-item.
            ASSIGN tt-pedido-drb-item.r-rowid = ROWID(pedido-drb-item).

            IF p-l-tipo-item THEN
                ASSIGN tt-pedido-drb-item.qtd-sdo-item = de-quant-saldo                   
                       tt-pedido-drb-item.val-sdo-item = de-valor-saldo.
            ELSE
                ASSIGN tt-pedido-drb-item.qtd-sdo-item-nac = de-quant-saldo                   
                       tt-pedido-drb-item.val-sdo-item-nac = de-valor-saldo.

            RUN openQueryStatic IN h-bocx315 (INPUT "Main":U).
            RUN goToKey         IN h-bocx315 (INPUT tt-pedido-drb-item.cod-estabel,
                                              INPUT tt-pedido-drb-item.nr-pedido-drb,
                                              INPUT tt-pedido-drb-item.it-codigo).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN emptyRowErrors  IN h-bocx315.
                RUN emptyRowObject  IN h-bocx315.
                RUN setRecord       IN h-bocx315 (INPUT TABLE tt-pedido-drb-item).
                RUN updateRecord    IN h-bocx315.
            END.
            DELETE tt-pedido-drb-item.
        END.                                                                                  
    END.

    IF VALID-HANDLE(h-bocx315) THEN 
        RUN Destroy IN h-bocx315.
    

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-tt-pedido-drb DBOProgram 
PROCEDURE pi-retorna-tt-pedido-drb :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pr-tt-pedido-drb AS ROWID NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-pedido-drb-aux.

    FOR FIRST bfpedido-drb NO-LOCK
        WHERE ROWID(bfpedido-drb) = pr-tt-pedido-drb: 

        BUFFER-COPY bfpedido-drb TO tt-pedido-drb-aux.
        
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEnviaTempTables DBOProgram 
PROCEDURE piEnviaTempTables:
/*------------------------------------------------------------------------------
  Purpose:     Recebe as temp-tables para utiliza‡Æo nas procedures 
               "piGeraDadosNotas" e "piRetornaItensNF"
  Parameters:  Entrada: Temp-Table "tt-param-nota"
               Entrada: Temp-Table "tt-item-estrut"
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-param-nota.
    DEFINE INPUT PARAMETER TABLE FOR tt-item-estrut.
    DEFINE INPUT PARAMETER TABLE FOR tt-saldo-entrada.
    DEFINE INPUT PARAMETER p-dt-prim-nota AS DATE NO-UNDO.

    ASSIGN da-dt-prim-nota = p-dt-prim-nota.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGeraDadosNotas DBOProgram 
PROCEDURE piGeraDadosNotas :
/*------------------------------------------------------------------------------
  Purpose:     Gerar as temp-tables com notas fiscais dos browsers de entrada e sa¡da
               do programam DK2040
  Parameters:  Entrada:       temp-table tt-nota-fiscal-aux
               Entrada/Sa¡da: i-nr-nota-ent: contador referente … qtde de notas de entrada a serem apresentadas no browser dk2040, folder "Entrada" 
               Entrada/Sa¡da: i-nr-nota-sai: contador referente … qtde de notas de entrada a serem apresentadas no browser dk2040, folder "Sa¡da" 
               Entrada/Sa¡da: temp-table tt-nota-fiscal-entrada: cont‚m as notas fiscais de entrada a serem apresentadas no browser dk2040, folder "Entrada" 
               Entrada/Sa¡da: temp-table tt-nota-fiscal-saida: cont‚m as notas fiscais de entrada a serem apresentadas no browser dk2040, folder "Sa¡da" 
               Entrada/Sa¡da: temp-table tt-it-nota-fisc: cont‚m todos os itens de notas fiscais independente de Entrada/Sa¡da
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER TABLE FOR tt-nota-fiscal-aux.
    DEFINE INPUT-OUTPUT PARAMETER i-nr-nota-ent      AS INTEGER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER i-nr-nota-sai      AS INTEGER   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-nota-fiscal-entrada.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-nota-fiscal-saida.
    DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-it-nota-fisc.

    IF NOT AVAIL tt-param-nota THEN
        FIND FIRST tt-param-nota NO-LOCK NO-ERROR.

    IF NOT VALID-HANDLE(h-boin176) THEN
        RUN inbo/boin176.p PERSISTENT SET h-boin176.

    FOR EACH tt-nota-fiscal-aux NO-LOCK:

        IF CAN-FIND(FIRST tt-nota-fiscal-entrada
                    WHERE tt-nota-fiscal-entrada.cod-estabel = tt-nota-fiscal-aux.cod-estabel
                      AND tt-nota-fiscal-entrada.serie       = tt-nota-fiscal-aux.serie      
                      AND tt-nota-fiscal-entrada.nr-nota-fis = tt-nota-fiscal-aux.nr-nota-fis) THEN NEXT.

        IF CAN-FIND(FIRST tt-nota-fiscal-saida
                    WHERE tt-nota-fiscal-saida.cod-estabel = tt-nota-fiscal-aux.cod-estabel
                      AND tt-nota-fiscal-saida.serie       = tt-nota-fiscal-aux.serie      
                      AND tt-nota-fiscal-saida.nr-nota-fis = tt-nota-fiscal-aux.nr-nota-fis) THEN NEXT.

        FOR FIRST natur-oper FIELDS(tipo tipo-compra cod-cfop) NO-LOCK
            WHERE natur-oper.nat-operacao = tt-nota-fiscal-aux.nat-operacao:
        END.
        IF NOT AVAIL natur-oper THEN NEXT.

        /* NOTA DE SERVI€OS */
        IF natur-oper.tipo = 3 THEN NEXT.
        
        /* NOTA FISCAL SAÖDA - Atualiza‡Æo Estoque */
        IF natur-oper.tipo = 2 AND tt-nota-fiscal-aux.dt-confirma = ? THEN NEXT.
        
        /* NOTA ENTRADA - Considera somente Notas Recebimento - Compra Normal */
        IF natur-oper.tipo = 1 AND (tt-nota-fiscal-aux.ind-tip-nota <> 8 OR natur-oper.tipo-compra <> 1) THEN NEXT.
        
        /* Verifica NF Internacional - Nacional */
        IF  tt-param-nota.rs-integrado = 1 AND (NOT natur-oper.cod-cfop BEGINS "7" AND NOT natur-oper.cod-cfop BEGINS "3") THEN NEXT.
        IF  tt-param-nota.rs-integrado = 2 AND (    natur-oper.cod-cfop BEGINS "7" OR      natur-oper.cod-cfop BEGINS "3") THEN NEXT.

        /* NOTA FISCAL ENTRADA - Atualiza‡Æo Estoque */
        IF natur-oper.tipo = 1 THEN DO:
            FOR FIRST docum-est FIELDS (ce-atual)
                WHERE docum-est.serie-docto  = tt-nota-fiscal-aux.serie
                  AND docum-est.nro-docto    = tt-nota-fiscal-aux.nr-nota-fis
                  AND docum-est.cod-emitente = tt-nota-fiscal-aux.cod-emitente
                  AND docum-est.nat-operacao = tt-nota-fiscal-aux.nat-operacao:
            END.
            IF NOT AVAIL docum-est    THEN NEXT.
            IF NOT docum-est.ce-atual THEN NEXT.
        END.

        /* NOTA FISCAL ENTRADA - Declara‡Æo de Importa‡Æo */
        IF natur-oper.tipo = 1 AND natur-oper.cod-cfop BEGINS "3" THEN DO:

            FOR FIRST docto-estoq-nfe-imp FIELDS(des-decla-import dat-decla-import) NO-LOCK
                WHERE docto-estoq-nfe-imp.cod-ser-docto    = tt-nota-fiscal-aux.serie
                  AND docto-estoq-nfe-imp.cod-docto        = tt-nota-fiscal-aux.nr-nota-fis
                  AND docto-estoq-nfe-imp.cdn-emitente     = tt-nota-fiscal-aux.cod-emitente
                  AND docto-estoq-nfe-imp.cod-natur-operac = tt-nota-fiscal-aux.nat-operacao:
            END.
            IF NOT AVAIL docto-estoq-nfe-imp THEN NEXT.

            IF docto-estoq-nfe-imp.des-decla-import < tt-param-nota.dec-imp-ini 
            OR docto-estoq-nfe-imp.des-decla-import > tt-param-nota.dec-imp-fim  THEN NEXT.

            IF docto-estoq-nfe-imp.dat-decla-import < tt-param-nota.dt-di-ini  
            OR docto-estoq-nfe-imp.dat-decla-import > tt-param-nota.dt-di-fim THEN NEXT.
        END.

         /* NOTA FISCAL SAÖDA - A data da emissÆo deve ser maior que das notas de compra vinculadas */
        IF natur-oper.tipo = 2 AND da-dt-prim-nota <> ? AND da-dt-prim-nota > tt-nota-fiscal-aux.dt-emis-nota THEN NEXT.

        RUN piRetornaItensNF IN THIS-PROCEDURE (INPUT  tt-nota-fiscal-aux.cod-estabel,
                                                INPUT  tt-nota-fiscal-aux.serie,
                                                INPUT  tt-nota-fiscal-aux.nr-nota-fis,
                                                INPUT  tt-nota-fiscal-aux.cod-emitente,
                                                INPUT  tt-nota-fiscal-aux.nat-operacao,
                                                INPUT  natur-oper.tipo, 
                                                INPUT  h-boin176,
                                                OUTPUT TABLE tt-it-nota-fisc-aux).

        IF CAN-FIND(FIRST tt-it-nota-fisc-aux) THEN DO:
            FOR EACH tt-it-nota-fisc-aux OF tt-nota-fiscal-aux NO-LOCK:
                IF NOT CAN-FIND(FIRST tt-it-nota-fisc
                                WHERE tt-it-nota-fisc.cod-estabel = tt-it-nota-fisc-aux.cod-estabel
                                  AND tt-it-nota-fisc.serie       = tt-it-nota-fisc-aux.serie      
                                  AND tt-it-nota-fisc.nr-nota-fis = tt-it-nota-fisc-aux.nr-nota-fis
                                  AND tt-it-nota-fisc.nr-seq-fat  = tt-it-nota-fisc-aux.nr-seq-fat 
                                  AND tt-it-nota-fisc.it-codigo   = tt-it-nota-fisc-aux.it-codigo) THEN DO:
                    CREATE tt-it-nota-fisc.
                    BUFFER-COPY tt-it-nota-fisc-aux TO tt-it-nota-fisc.
                END.
            END.
        
            IF natur-oper.tipo = 1 THEN DO:
                IF NOT CAN-FIND(FIRST tt-nota-fiscal-entrada
                                WHERE tt-nota-fiscal-entrada.cod-estabel = tt-nota-fiscal-aux.cod-estabel
                                  AND tt-nota-fiscal-entrada.serie       = tt-nota-fiscal-aux.serie      
                                  AND tt-nota-fiscal-entrada.nr-nota-fis = tt-nota-fiscal-aux.nr-nota-fis) THEN DO:
                    CREATE tt-nota-fiscal-entrada.
                    BUFFER-COPY tt-nota-fiscal-aux TO tt-nota-fiscal-entrada.
                    ASSIGN i-nr-nota-ent = i-nr-nota-ent + 1.
                END.
            END.
            IF natur-oper.tipo = 2 THEN DO:
                IF NOT CAN-FIND(FIRST tt-nota-fiscal-saida
                                WHERE tt-nota-fiscal-saida.cod-estabel = tt-nota-fiscal-aux.cod-estabel
                                  AND tt-nota-fiscal-saida.serie       = tt-nota-fiscal-aux.serie      
                                  AND tt-nota-fiscal-saida.nr-nota-fis = tt-nota-fiscal-aux.nr-nota-fis) THEN DO:
                    CREATE tt-nota-fiscal-saida.
                    BUFFER-COPY tt-nota-fiscal-aux TO tt-nota-fiscal-saida.
                    ASSIGN i-nr-nota-sai = i-nr-nota-sai + 1.
                END.
            END.
        END.
    END.

    IF VALID-HANDLE(h-boin176) THEN DO:
        DELETE PROCEDURE h-boin176.
        ASSIGN h-boin176 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piRetornaItensNF DBOProgram 
PROCEDURE piRetornaItensNF :
/*------------------------------------------------------------------------------
  Purpose:     Retorna os itens das notas fiscais nos browsers em tela
  Parameters:  Entrada: Chave da tabela de documento e tipo da nota: entrada ou sa¡da;
               Sa¡da: Retorna tabela de itens para gera‡Æo dos movimentos
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM p-cod-estabel  LIKE nota-fiscal.cod-estabel  NO-UNDO.
    DEF INPUT  PARAM p-serie        LIKE nota-fiscal.serie        NO-UNDO.
    DEF INPUT  PARAM p-nr-nota-fis  LIKE nota-fiscal.nr-nota-fis  NO-UNDO.
    DEF INPUT  PARAM p-cod-emitente LIKE nota-fiscal.cod-emitente NO-UNDO.
    DEF INPUT  PARAM p-nat-operacao LIKE nota-fiscal.nat-operacao NO-UNDO.
    DEF INPUT  PARAM i-tipo         AS INTEGER                    NO-UNDO.
    DEF INPUT  PARAM ph-boin176     AS HANDLE                     NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-it-nota-fisc-aux.

    DEFINE VARIABLE iNrRegistro AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-existe    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-seq       AS INTEGER     NO-UNDO.
    
    EMPTY TEMP-TABLE tt-it-nota-fisc-aux.

    IF NOT AVAIL tt-param-nota THEN
        FIND FIRST tt-param-nota NO-LOCK NO-ERROR.

    FOR EACH it-nota-fisc
       WHERE it-nota-fisc.cod-estabel = p-cod-estabel
         AND it-nota-fisc.serie       = p-serie
         AND it-nota-fisc.nr-nota-fis = p-nr-nota-fis NO-LOCK:

        IF i-tipo = 1 THEN DO:
            /* Faixa ITEM - Nat Operacao DK2040A */
            IF it-nota-fisc.it-codigo    < tt-param-nota.it-codigo-ini
            OR it-nota-fisc.it-codigo    > tt-param-nota.it-codigo-fim
            OR it-nota-fisc.nat-operacao < tt-param-nota.nat-operacao-ini
            OR it-nota-fisc.nat-operacao > tt-param-nota.nat-operacao-fim THEN 
                NEXT.
            

            /* Item Entrada */
            IF CAN-FIND (FIRST movto-ato 
                         WHERE movto-ato.serie        = it-nota-fisc.serie
                           AND movto-ato.nro-docto    = it-nota-fisc.nr-nota-fis
                           AND movto-ato.cod-emitente = p-cod-emitente
                           AND movto-ato.nat-operacao = it-nota-fisc.nat-operacao
                           AND movto-ato.it-codigo    = it-nota-fisc.it-codigo 
                           AND movto-ato.seq-docto    = it-nota-fisc.nr-seq-fat) THEN NEXT.
        END.
        /* Item Sa¡da */
        IF i-tipo = 2 THEN DO:
            
           ASSIGN de-qtd-fatur-nf = 0
                  de-qtd-faturada = 0
                  de-qtd-maior    = 0.
           IF NOT CAN-FIND(FIRST tt-item-estrut 
                           WHERE tt-item-estrut.it-codigo = it-nota-fisc.it-codigo) THEN NEXT.

           /*Verificando se ainda nÆo foi alocado o item ao ato concess¢rio*/
           IF NOT CAN-FIND(FIRST tab-ocor
                           WHERE tab-ocor.cod-tab = 721
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = it-nota-fisc.serie
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = it-nota-fisc.nr-nota-fis  
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = it-nota-fisc.cod-estabel
                           AND   tab-ocor.int-1                         = it-nota-fisc.nr-seq-fat
                           AND   tab-ocor.int-2                         = 2 /*Tipo Saida*/
                           AND   tab-ocor.log-1                         = YES /*Nacional ou Internacional*/
                           ) OR
                  CAN-FIND(FIRST tab-ocor
                           WHERE tab-ocor.cod-tab = 721
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = it-nota-fisc.serie         
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = it-nota-fisc.nr-nota-fis   
                           AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = it-nota-fisc.cod-estabel   
                           AND   tab-ocor.int-1                         = it-nota-fisc.nr-seq-fat    
                           AND   tab-ocor.int-2                         = 2 /*Tipo Saida*/
                           AND   tab-ocor.log-1                         = YES /*Nacional ou Internacional*/ 
                           AND   tab-ocor.dec-1                         < it-nota-fisc.qt-faturada[1])
                           THEN DO:

               FOR FIRST tab-ocor NO-LOCK
                   WHERE tab-ocor.cod-tab = 721
                   AND   TRIM(SUBSTRING(tab-ocor.char-1,1,5))   = it-nota-fisc.serie         
                   AND   TRIM(SUBSTRING(tab-ocor.char-1,6,16))  = it-nota-fisc.nr-nota-fis   
                   AND   TRIM(SUBSTRING(tab-ocor.char-1,22,5))  = it-nota-fisc.cod-estabel   
                   AND   tab-ocor.int-1                         = it-nota-fisc.nr-seq-fat    
                   AND   tab-ocor.int-2                         = 2 /*Tipo Saida*/
                   AND   tab-ocor.log-1                         = YES /*Nacional ou Internacional*/ :

                   ASSIGN de-qtd-fatur-nf = it-nota-fisc.qt-faturada[1] - tab-ocor.dec-1.
                    
               END.

               IF NOT AVAIL tab-ocor THEN                                               
                  ASSIGN de-qtd-fatur-nf = it-nota-fisc.qt-faturada[1]. 

               FOR EACH tt-saldo-entrada
                   WHERE tt-saldo-entrada.it-saida = it-nota-fisc.it-codigo:   
                   
                   IF tt-saldo-entrada.quantidade = 0 THEN NEXT.

                   IF tt-saldo-entrada.quantidade > de-qtd-fatur-nf THEN
                      ASSIGN tt-saldo-entrada.quantidade = tt-saldo-entrada.quantidade - de-qtd-fatur-nf 
                             de-qtd-faturada = de-qtd-fatur-nf.
                   ELSE
                      IF tt-saldo-entrada.quantidade <= de-qtd-fatur-nf THEN
                         ASSIGN de-qtd-faturada = tt-saldo-entrada.quantidade
                                tt-saldo-entrada.quantidade = 0.

                   IF de-qtd-faturada > de-qtd-maior THEN
                      ASSIGN de-qtd-maior = de-qtd-faturada.
    
               END.
           END.

        END.
        
        IF i-tipo = 1 OR
          (i-tipo = 2 AND de-qtd-maior > 0) THEN DO: 

           CREATE tt-it-nota-fisc-aux.
           BUFFER-COPY it-nota-fisc TO tt-it-nota-fisc-aux.
            
           IF i-tipo = 2 AND de-qtd-maior > 0 THEN 
              ASSIGN tt-it-nota-fisc-aux.qt-faturada[1] = de-qtd-maior.
        END.
        
    END.

    /* Alterar a sequencia para os documentos de entrada, porque pode ser diferente da sequencia no faturamento */
    IF i-tipo = 1 THEN DO:
        IF CAN-FIND(FIRST tt-it-nota-fisc-aux) THEN DO:
            RUN setConstraintOfDocumEst IN ph-boin176 (INPUT p-cod-emitente,
                                                       INPUT p-serie,
                                                       INPUT p-nr-nota-fis,
                                                       INPUT p-nat-operacao).
            RUN openQueryStatic         IN ph-boin176 (INPUT "OfDocumEst":U).
        END.
        FOR EACH tt-it-nota-fisc-aux FIELDS(nr-nota-fis nr-seq-fat it-codigo nat-operacao serie it-codigo cod-estabel)
            BREAK BY tt-it-nota-fisc-aux.nr-nota-fis 
                  BY tt-it-nota-fisc-aux.nr-seq-fat:
        
            IF FIRST-OF(tt-it-nota-fisc-aux.nr-nota-fis) THEN DO:
                RUN getFirst    IN ph-boin176.
                RUN getIntField IN ph-boin176 (INPUT "sequencia", OUTPUT i-seq).
                IF RETURN-VALUE = "OK":U THEN
                    ASSIGN tt-it-nota-fisc-aux.nr-seq-fat = i-seq.
            END.
            ELSE DO:
                RUN getNext     IN ph-boin176.
                RUN getIntField IN ph-boin176 (INPUT "sequencia", OUTPUT i-seq).
                IF RETURN-VALUE = "OK":U THEN
                    ASSIGN tt-it-nota-fisc-aux.nr-seq-fat = i-seq.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PiRetornaTTItensAC DBOProgram 
PROCEDURE PiRetornaTTItensAC :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no indice CH-PEDIDO
  Parameters:
               recebe valor dos campos do indice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER TABLE FOR tt-itens-ac.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintAtoFaixa DBOProgram 
PROCEDURE setConstraintAtoFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter c-estabel-ini as char no-undo.
    define input parameter c-estabel-fin as char no-undo.
    define input parameter c-nr-ato-ini as char no-undo.
    define input parameter c-nr-ato-fin as char no-undo.            

assign c-estabini = c-estabel-ini
       c-estabfin = c-estabel-fin
       c-ato-ini  = c-nr-ato-ini
       c-ato-fin  = c-nr-ato-fin. 
       
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintCodEstabel DBOProgram 
PROCEDURE setConstraintCodEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pesrabelini AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pesrabelfin AS CHARACTER NO-UNDO.    

assign c-estabini =  pesrabelini
       c-estabfin =  pesrabelfin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintPedidoFaixa DBOProgram 
PROCEDURE setConstraintPedidoFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter c-estabel-ini as char no-undo.
    define input parameter c-estabel-fin as char no-undo. 
    define input parameter c-ped-ini     as char no-undo.
    define input parameter c-ped-fin     as char no-undo.            

    assign c-estabini    = c-estabel-ini
           c-estabfin    = c-estabel-fin
           c-pedido-ini  = c-ped-ini
           c-pedido-fin  = c-ped-fin.   
 
    RETURN "OK":U.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setIdi-tip-movto DBOProgram 
PROCEDURE setIdi-tip-movto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pidi-tip-movto LIKE movto-ato.idi-tip-movto NO-UNDO.

  ASSIGN i-idi-tip-movto = pidi-tip-movto.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaAtoConcessorio DBOProgram 
PROCEDURE ValidaAtoConcessorio :
/*------------------------------------------------------------------------------
  Purpose:     valida os atos concessorios na implanta‡Æo do documentos de entrada
               RE1001
  Parameters: Estabelecimento, numero do ato concessorio e item.
                 
  Notes: 
------------------------------------------------------------------------------*/
    DEF input parameter c-estabel like pedido-drb.cod-estabel                   no-undo.
    Def input parameter c-nr-ato-concessorio like pedido-drb.nr-ato-concessorio no-undo.
    Def input parameter c-item like pedido-drb-item.it-codigo                   no-undo.
    def output parameter table for tt-bo-erro.
    
    for each tt-bo-erro:
       delete tt-bo-erro.
    end.
    
    if c-nr-ato-concessorio = "" then do:
        assign i-seq-erro = i-seq-erro + 1.       
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265. /*NR Ato concessorio deve ser informado */
        {utp/ut-liter.i Ato_Concess¢rio}         
        assign tt-bo-erro.parametros   = return-value.    
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.mensagem   = return-value.
    end.
    else do:
        find pedido-drb 
            where pedido-drb.cod-estabel = c-estabel 
              and pedido-drb.nr-ato-concessorio = c-nr-ato-concessorio no-lock no-error.              
        if not avail pedido-drb then do:
            assign i-seq-erro = i-seq-erro + 1.
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2. /*Ato concessorio nÆo cadastrado */
           {utp/ut-liter.i Ato_Concess¢rio}         
            assign tt-bo-erro.parametros   = return-value.
     
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            assign tt-bo-erro.mensagem   = return-value.
        end.
        else do:
            run VerificaAtoConcessorioItem (input pedido-drb.cod-estabel,
                                            input pedido-drb.nr-pedido-drb, 
                                            input c-item). 
            if return-value = "NOK" then do:
                run utp/ut-msgs.p (input "msg",
                                   input 25706,
                                   input "").
                assign i-seq-erro = i-seq-erro + 1.
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 25706 /* NÆo encontrado item para o ato concessorio*/
                       tt-bo-erro.parametros   = return-value
                       tt-bo-erro.mensagem   = return-value.
            end.
            if pedido-drb.data-validade-ato < today then do:              
                assign i-seq-erro = i-seq-erro + 1.       
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 17238. /*Validade do ato concessorio expirou */
               {utp/ut-liter.i Ato_Concess¢rio}         
                assign tt-bo-erro.parametros   = return-value.       
                run utp/ut-msgs.p (input "msg",
                                   input 17238,
                                   input return-value).
                assign tt-bo-erro.mensagem   = return-value.
           end.
           
        end.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaPedidoDrb DBOProgram 
PROCEDURE ValidaPedidoDrb :
/*------------------------------------------------------------------------------
  Purpose:     Excluir os registros dos filhos do registro pai corrente
  Parameters: numero do ato concessorio 
                 
  Notes: Valida se o ato concesorio existe, na implanta‡Æo do saldo terc (re0408).
------------------------------------------------------------------------------*/

    Define input parameter c-nr-ato-concessorio like pedido-drb.nr-ato-concessorio no-undo.
    Define output parameter table for tt-bo-erro.
    
    if c-nr-ato-concessorio = "" then do:
        assign i-seq-erro = i-seq-erro + 1.       
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265. /*NR Ato concessorio deve ser informado */
       {utp/ut-liter.i Ato_Concess¢rio}         
        assign tt-bo-erro.parametros   = return-value.
    
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        assign tt-bo-erro.mensagem   = return-value.
        return 'ADM-ERROR':U.         
    end.
    find pedido-drb 
         where pedido-drb.nr-ato-concessorio = c-nr-ato-concessorio no-lock no-error.              
    if not avail pedido-drb then do:
        assign i-seq-erro = i-seq-erro + 1.       
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 2. /*NÆo encontrado Ato concessorio para a chave informada */
       {utp/ut-liter.i Ato_Concess¢rio}         
        assign tt-bo-erro.parametros   = return-value.
    
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign tt-bo-erro.mensagem   = return-value.
        return 'ADM-ERROR':U.
    end.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateAtoConcessorio DBOProgram 
PROCEDURE validateAtoConcessorio :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no indice CH-PEDIDO
  Parameters:
               recebe valor dos campos do indice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ato-concessorio LIKE Pedido-drb.nr-ato-concessorio      NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo          LIKE pedido-drb-item.it-codigo          NO-UNDO.
    DEFINE INPUT PARAMETER pl-origem           AS LOGICAL                              NO-UNDO. 
    DEFINE INPUT PARAMETER d-qt-solic          LIKE pedido-drb-item.qtd-alocada-import NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE for tt-bo-erro.
      
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.            

    run goToAtoConcessorio (input pnr-ato-concessorio).
    
    IF RETURN-VALUE = "NOK":U THEN DO:
        assign i-seq-erro = i-seq-erro + 1.       
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 558.
        
        {utp/ut-field.i mgcex pedido-drb nr-ato-concessorio 1}       
        assign tt-bo-erro.parametros   = return-value.
    
        run utp/ut-msgs.p (input "msg",
                           input 558,
                           input return-value).
        assign tt-bo-erro.mensagem   = return-value.                    
    END.
    ELSE DO:
        IF AVAIL pedido-drb THEN
            run VerificaAtoConcessorioItem (input pedido-drb.cod-estabel,
                                            input pedido-drb.nr-pedido-drb, 
                                            input pit-codigo).                                       
        ELSE 
            IF AVAIL bfpedido-drb THEN
                run VerificaAtoConcessorioItem (input bfpedido-drb.cod-estabel,
                                                input bfpedido-drb.nr-pedido-drb, 
                                                input pit-codigo).
        if return-value = "NOK":U 
            AND pnr-ato-concessorio <> "" then do:
            assign i-seq-erro = i-seq-erro + 1.
            if pl-origem then do:   /*** Cliente/Servidor ***/
               run utp/ut-msgs.p (input "msg",
                                  input 25546,
                                  input "").                                                          
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 25546
                      tt-bo-erro.parametros   = return-value
                      tt-bo-erro.mensagem   = return-value.
            end.          
            else do:    /*** WEB ***/
               run utp/ut-msgs.p (input "msg",
                                  input 25706,
                                  input "").
               create tt-bo-erro.
               assign tt-bo-erro.i-sequen     = i-seq-erro
                      tt-bo-erro.cd-erro      = 25706
                      tt-bo-erro.parametros   = return-value
                      tt-bo-erro.mensagem   = return-value.                             
            end.
        end.

        FIND FIRST pedido-drb-item
             WHERE pedido-drb-item.nr-pedido-drb = bfpedido-drb.nr-pedido-drb
               AND pedido-drb-item.cod-estabel   = bfpedido-drb.cod-estabel
               AND pedido-drb-item.it-codigo     = pit-codigo
               AND pedido-drb-item.idi-reg       = 1 NO-LOCK NO-ERROR.

        IF AVAIL pedido-drb-item THEN DO:

            IF NOT VALID-HANDLE(h-bocx315) THEN
                RUN cxbo/bocx315.p PERSISTENT SET h-bocx315.

            RUN retornaQuantidadeSaldoDrb IN h-bocx315 (INPUT 1, /* internacional */
                                                        INPUT bfpedido-drb.modalidade,
                                                        INPUT bfpedido-drb.cod-estabel,
                                                        INPUT pit-codigo,
                                                        INPUT bfpedido-drb.nr-pedido-drb,
                                                        OUTPUT de-quant-sdo).
            
            IF  de-quant-sdo <> 0
                AND  de-quant-sdo >= (pedido-drb-item.qtd-alocada-import + d-qt-solic) THEN DO:
                CREATE tt-pedido-drb-item.
                BUFFER-COPY pedido-drb-item TO tt-pedido-drb-item.
                ASSIGN tt-pedido-drb-item.qtd-alocada-import = pedido-drb-item.qtd-alocada-import + d-qt-solic.
                       tt-pedido-drb-item.r-rowid            = ROWID(pedido-drb-item).
    
                RUN openQueryStatic IN h-bocx315 (INPUT "Main":U).
                RUN goToKey         IN h-bocx315 (INPUT tt-pedido-drb-item.cod-estabel,
                                                  INPUT tt-pedido-drb-item.nr-pedido-drb,
                                                  INPUT tt-pedido-drb-item.it-codigo).
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN emptyRowErrors  IN h-bocx315.
                    RUN emptyRowObject  IN h-bocx315.
                    RUN setRecord       IN h-bocx315 (INPUT TABLE tt-pedido-drb-item).
                    RUN updateRecord    IN h-bocx315.
                END.
                DELETE tt-pedido-drb-item.
            END.
            ELSE DO:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-liter.i Ato_concess¢rio_nÆo_possui_saldo_suficiente. *}
                run utp/ut-msgs.p (input "msg",
                                   input 17006,
                                   input RETURN-VALUE).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 17006
                       tt-bo-erro.parametros   = return-value
                       tt-bo-erro.mensagem     = return-value.
            END.

            IF VALID-HANDLE(h-bocx315) THEN DO:
                DELETE PROCEDURE h-bocx315.
                ASSIGN h-bocx315 = ? .
            END.
        END.
    END. 
    
    RETURN "OK":U.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatePedidoDrb DBOProgram 
PROCEDURE validatePedidoDrb :
/*------------------------------------------------------------------------------
  Notes:       
------------------------------------------------------------------------------*/
def input  param piPedido     as char no-undo.
def input  param piEstabel    as char no-undo.
def output param            table for rowErrors.

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


    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    if not avail ROWOBJECT then 
        return "NOK":U.

    IF  pType = "CREATE":U THEN DO:

        IF rowObject.cod-estabel = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-codido-estabelecimento AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢dido_Estabelecimento" *}
            ASSIGN c-lbl-liter-codido-estabelecimento = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-codido-estabelecimento"}
        END.
        ELSE DO:
            FIND estabelec 
                WHERE estabelec.cod-estabel = rowObject.cod-estabel no-lock no-error.
            IF NOT AVAIL estabelec THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-estabelecimento AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Estabelecimento" *}
                ASSIGN c-lbl-liter-estabelecimento = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="2"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-lbl-liter-estabelecimento"}
            END.
        END.

        IF rowObject.nr-pedido-drb = "" THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-numero-do-pedido-drawback AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "N£mero_do_Pedido_Drawback" *}
            ASSIGN c-lbl-liter-numero-do-pedido-drawback = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-numero-do-pedido-drawback"}
        END.
        ELSE DO:
            FOR FIRST pedido-drb NO-LOCK  
                WHERE pedido-drb.cod-estabel   = rowObject.cod-estabel 
                  AND pedido-drb.nr-pedido-drb = rowObject.nr-pedido-drb:
            END. 
            IF AVAIL pedido-drb THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-pedido-drawback AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Pedido_Drawback" *}
                ASSIGN c-lbl-liter-pedido-drawback = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="8"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-lbl-liter-pedido-drawback"}
            END.
        END.

        IF rowObject.data-emissao = ? THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-data-emissao-pedido AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Data_EmissÆo_Pedido" *}
            ASSIGN c-lbl-liter-data-emissao-pedido = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-data-emissao-pedido"}
        END.

        IF rowobject.nr-ato-concessorio <> "" THEN DO:
            FOR FIRST pedido-drb no-lock 
                WHERE pedido-drb.nr-ato-concessorio = rowObject.nr-ato-concessorio USE-INDEX ch-ato:
            END.
            IF AVAIL pedido-drb THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-ato-concessorio AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Ato_Concess¢rio" *}
                ASSIGN c-lbl-liter-ato-concessorio = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                    &ErrorNumber="8"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters="c-lbl-liter-ato-concessorio"}
        
            END.
        END.

    END.            /* create */
  
    IF pType = "DELETE":U THEN DO:
    END.
    
    IF pType = "COPY":U THEN DO:
        IF rowObject.modalidade <> 1 THEN DO:
        {method/svc/errors/inserr.i
                            &ErrorNumber="25307"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="''"}
        END.
    END.

    IF pType = "UPDATE":U OR pType = "CREATE":U THEN DO:

        IF rowObject.nr-ato-concessorio <> "" THEN DO:

            IF rowObject.data-emissao-ato = ? THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-data-emissao-ato-concessorio AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Data_EmissÆo_Ato_Concess¢rio" *}
                ASSIGN c-lbl-liter-data-emissao-ato-concessorio = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-data-emissao-ato-concessorio"}
            END.
            IF rowObject.data-validade-ato = ? THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-data-validade-ato-concessorio AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Data_Validade_Ato_Concess¢rio" *}
                ASSIGN c-lbl-liter-data-validade-ato-concessorio = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-data-validade-ato-concessorio"}
            END.
            
            IF rowObject.data-emissao-ato < rowObject.data-emissao THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-emissao-ato-concessorio AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "EmissÆo_Ato_Concess¢rio" *}
                ASSIGN c-lbl-liter-emissao-ato-concessorio = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-emissao-pedido-drawback AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "EmissÆo_Pedido_Drawback" *}
                ASSIGN c-lbl-liter-emissao-pedido-drawback = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-merge-emissao-ato-concessorio-emiss AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-merge-emissao-ato-concessorio-emiss = c-lbl-liter-emissao-ato-concessorio + ' ' + "~~" + ' ' + c-lbl-liter-emissao-pedido-drawback.
                {method/svc/errors/inserr.i
                                &ErrorNumber="25282"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-merge-emissao-ato-concessorio-emiss"}
            END.
            
            IF rowObject.data-validade-ato < rowObject.data-emissao-ato THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-validade-ato-concessorio AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Validade_Ato_Concess¢rio" *}
                ASSIGN c-lbl-liter-validade-ato-concessorio = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-emissao-ato-concessorio-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "EmissÆo_Ato_Concess¢rio" *}
                ASSIGN c-lbl-liter-emissao-ato-concessorio-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-merge-validade-ato-concessorio-emis AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-merge-validade-ato-concessorio-emis = c-lbl-liter-validade-ato-concessorio + ' ' + "~~" + '  ' + c-lbl-liter-emissao-ato-concessorio-2.
                {method/svc/errors/inserr.i
                                &ErrorNumber="25282"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-merge-validade-ato-concessorio-emis" }
            END.

        END.

        IF rowObject.cod-sit-ped-drb = 3 THEN 
            IF rowObject.motivo-reprovacao = "" THEN DO:
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-motivo-da-reprovacao AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Motivo_da_reprovacao" *}
                ASSIGN c-lbl-liter-motivo-da-reprovacao = TRIM(RETURN-VALUE).
                {method/svc/errors/inserr.i
                                &ErrorNumber="265"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="c-lbl-liter-motivo-da-reprovacao"}
            END.

        IF rowObject.modalidade = 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-modalidade-do-ato-concessorio AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Modalidade_do_Ato_Concess¢rio" *}
            ASSIGN c-lbl-liter-modalidade-do-ato-concessorio = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-modalidade-do-ato-concessorio"}
        END.

        IF rowObject.cod-sit-ped-drb = 0 THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-situacao-do-pedido AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Situa‡Æo_do_Pedido" *}
            ASSIGN c-lbl-liter-situacao-do-pedido = TRIM(RETURN-VALUE).
            {method/svc/errors/inserr.i
                            &ErrorNumber="265"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-situacao-do-pedido"}
        END.


    END.    

    /*--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateVincAtoConcesEmbarque DBOProgram 
PROCEDURE validateVincAtoConcesEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM p-cod-estabel     LIKE embarque-imp.cod-estabel NO-UNDO.
    DEF INPUT PARAM p-embarque        LIKE embarque-imp.embarque    NO-UNDO.
    DEF INPUT PARAM p-ato-concessorio AS CHAR                       NO-UNDO.
    DEF OUTPUT PARAM TABLE FOR tt-bo-erro-aux.

    for each tt-bo-erro-aux:
       delete tt-bo-erro-aux.
    end.

    FOR EACH bf-ordens-embarque NO-LOCK
        WHERE bf-ordens-embarque.cod-estabel = p-cod-estabel
        AND   bf-ordens-embarque.embarque    = p-embarque,
        FIRST ordem-compra NO-LOCK
        WHERE ordem-compra.numero-ordem = bf-ordens-embarque.numero-ordem:

        for each tt-bo-erro:
           delete tt-bo-erro.
        end.

        RUN validateAtoConcessorio (INPUT p-ato-concessorio, 
                                    INPUT ordem-compra.it-codigo,
                                    INPUT YES,
                                    INPUT bf-ordens-embarque.quantidade,
                                    OUTPUT TABLE tt-bo-erro).      

        FOR EACH tt-bo-erro:
            {utp/ut-liter.i ITEM *}
            CREATE tt-bo-erro-aux.
            BUFFER-COPY tt-bo-erro EXCEPT tt-bo-erro.mensagem TO tt-bo-erro-aux.
            ASSIGN tt-bo-erro-aux.mensagem = RETURN-VALUE + ":" + ordem-compra.it-codigo + " - " + tt-bo-erro.mensagem.
        END.


    END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaValorAtoConcessorio DBOProgram 
PROCEDURE ValidaValorAtoConcessorio :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no indice CH-PEDIDO
  Parameters:
               recebe valor dos campos do indice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER c-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT  PARAMETER c-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT  PARAMETER i-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT  PARAMETER c-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-ok          AS   LOGICAL                NO-UNDO.

    DEFINE VARIABLE i-num-ord-import    AS INTEGER                             NO-UNDO.
    DEFINE VARIABLE i-num-parc-import   AS INTEGER                             NO-UNDO.
    DEFINE VARIABLE de-valor-saldo      AS DECIMAL                             NO-UNDO.
    DEFINE VARIABLE de-tot-valor-ent    AS DECIMAL                             NO-UNDO.
    DEFINE VARIABLE de-tot-quant-ent    AS DECIMAL                             NO-UNDO.
    DEFINE VARIABLE deTotQuantEntrada   AS DECIMAL FORMAT ">>>>>,>>9.9999":U   NO-UNDO.
    DEFINE VARIABLE deTotQuantBaixa     AS DECIMAL FORMAT ">>>>>,>>9.9999":U   NO-UNDO.
    DEFINE VARIABLE deValMovtoAtoMeConv AS DECIMAL FORMAT ">,>>>,>>>,>>9.99":U NO-UNDO.
    DEFINE VARIABLE deValMovtoNovaImp   AS DECIMAL FORMAT ">,>>>,>>>,>>9.99":U NO-UNDO.
    DEFINE VARIABLE deValBaixa          AS DECIMAL FORMAT ">,>>>,>>>,>>9.99":U NO-UNDO.
    DEFINE VARIABLE deValorConv         AS DECIMAL FORMAT ">,>>>,>>>,>>9.99":U NO-UNDO.
    DEFINE VARIABLE deTotValor          AS DECIMAL FORMAT ">,>>>,>>>,>>9.99":U NO-UNDO.
    DEFINE VARIABLE deTotValorAux       AS DECIMAL FORMAT ">,>>>,>>>,>>9.99":U NO-UNDO.
    DEFINE VARIABLE i-tip-movto         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-moeda-aux      AS INTEGER     NO-UNDO.

    FIND FIRST docum-est 
         WHERE docum-est.serie-docto  = c-serie-docto
           AND docum-est.nro-docto    = c-nro-docto
           AND docum-est.cod-emitente = i-cod-emitente
           AND docum-est.nat-operacao = c-nat-operacao NO-LOCK NO-ERROR.

    IF AVAIL docum-est THEN DO:
        FIND emitente  WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
        FIND estabelec WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.

        IF emitente.natureza > 2
            AND emitente.pais <> estabelec.pais THEN
            ASSIGN i-tip-movto = 1.
        ELSE
            ASSIGN i-tip-movto = 2.

        FOR EACH item-doc-est 
           WHERE item-doc-est.serie-docto  = docum-est.serie-docto
             AND item-doc-est.nro-docto    = docum-est.nro-docto
             AND item-doc-est.cod-emitente = docum-est.cod-emitente
             AND item-doc-est.nat-operacao = docum-est.nat-operacao NO-LOCK:
            
            IF item-doc-est.nr-ato-concessorio = "" THEN NEXT.
    
            FIND FIRST pedido-drb 
                 WHERE pedido-drb.cod-estabel        = docum-est.cod-estabel
                   AND pedido-drb.nr-ato-concessorio = item-doc-est.nr-ato-concessorio NO-LOCK NO-ERROR.
            IF AVAIL pedido-drb THEN DO:
                FIND FIRST pedido-drb-item
                    WHERE pedido-drb-item.cod-estabel   = pedido-drb.cod-estabel
                      AND pedido-drb-item.nr-pedido-drb = pedido-drb.nr-pedido-drb
                      AND pedido-drb-item.it-codigo     = item-doc-est.it-codigo NO-LOCK NO-ERROR.
    
                IF AVAIL pedido-drb-item THEN DO:

                    IF i-tip-movto = 1 THEN /* internacional */
                      ASSIGN i-moeda-aux = pedido-drb-item.moeda.
                    ELSE /* nacional */
                      ASSIGN i-moeda-aux = pedido-drb-item.cdn-moed-nac.


                    /*Nota Fiscal Simples Remessa*/ 
                    &if '{&bf_mat_versao_ems}':U >= '2.06':U &then
                        IF docum-est.idi-nf-simples-remes = 1 THEN DO: 
                    &else
                        IF TRIM(SUBSTR(docum-est.char-2,101,1)) = "1" THEN DO:
                    &endif     
                        IF AVAIL item-doc-est THEN DO:
                           &IF '{&bf_mat_versao_ems}' >= '2.06' &THEN
                             ASSIGN i-num-ord-import  = item-doc-est.num-ord-import 
                                    i-num-parc-import = item-doc-est.num-parc-import.
                           &ELSE
                             ASSIGN i-num-ord-import  = INT(SUBSTRING(item-doc-est.char-2,145,8)) 
                                    i-num-parc-import = INT(SUBSTRING(item-doc-est.char-2,154,5)).                 
                           &ENDIF
                        END.
                    END.
                    ELSE
                        ASSIGN i-num-ord-import  = item-doc-est.numero-ordem
                               i-num-parc-import = item-doc-est.parcela.
            
                    FIND FIRST ordem-compra 
                         WHERE ordem-compra.numero-ordem = &IF "{&bf_mat_versao_ems}" >= "2.04":U &THEN
                                                               i-num-ord-import
                                                           &ELSE
                                                               item-doc-est.numero-ordem 
                                                           &ENDIF NO-LOCK NO-ERROR.
                    IF  AVAIL ordem-compra THEN DO:
                        IF ordem-compra.mo-codigo <> 0 THEN
                            RUN cdp/cd0812.p (INPUT 0,
                                              INPUT ordem-compra.mo-codigo,
                                              INPUT item-doc-est.preco-total[1],
                                              INPUT IF AVAIL embarque-imp THEN embarque-imp.data-1
                                                    ELSE docum-est.dt-emissao,
                                              OUTPUT deValorConv).
                        ELSE
                            ASSIGN deValorConv = item-doc-est.preco-total[1].
    
                    IF pedido-drb.modalidade = 1 THEN DO: /** Suspensao **/
    
                        ASSIGN deTotValor = 0.
                        FOR EACH movto-ato
                            WHERE movto-ato.cod-estabel   = pedido-drb-item.cod-estabel
                              AND movto-ato.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                              AND movto-ato.it-codigo     = pedido-drb-item.it-codigo
                              AND movto-ato.idi-tip-item-movto = i-tip-movto
                              AND movto-ato.idi-tip-movto = 1 no-lock: /** Entrada **/

                            IF movto-ato.mo-codigo <> i-moeda-aux THEN DO:                            
                                RUN cdp/cd0812.p (INPUT movto-ato.mo-codigo, /*movto-ato.mo-codigo*/
                                                  input i-moeda-aux,
                                                  input movto-ato.val-movto-ato-me,
                                                  input IF AVAIL embarque-imp THEN embarque-imp.data-1 
                                                        ELSE docum-est.dt-emissao,
                                                  OUTPUT deTotValorAux).                                
                                ASSIGN deTotValor = deTotValor + deTotValorAux.  
                            END.
                            ELSE
                                ASSIGN deTotValor = deTotValor + movto-ato.val-movto-ato-me.  
                        END.
    
                        IF ordem-compra.mo-codigo <> i-moeda-aux THEN
                            RUN cdp/cd0812.p (INPUT ordem-compra.mo-codigo,
                                              input i-moeda-aux,
                                              input ROUND(deValorConv,2),
                                              input IF AVAIL embarque-imp THEN embarque-imp.data-1 
                                                    ELSE docum-est.dt-emissao,
                                              OUTPUT deValMovtoAtoMeConv).
                        ELSE
                           ASSIGN deValMovtoAtoMeConv = deValorConv.                            
                    
                        CREATE tt-itens-ac.
                        ASSIGN tt-itens-ac.it-codigo          = pedido-drb-item.it-codigo
                               tt-itens-ac.nr-ato-concessorio = pedido-drb.nr-ato-concessorio
                               tt-itens-ac.r-rowid-item       = ROWID(pedido-drb-item)
                               tt-itens-ac.l-item-ato         = YES.

                        IF i-tip-movto = 1 THEN DO: /* internacional */
                            IF pedido-drb-item.preco-fob - deTotValor < deValMovtoAtoMeConv THEN
                                ASSIGN tt-itens-ac.l-item-ato = NO.
                            ELSE
                                ASSIGN l-ok = YES.
                        END.
                        ELSE DO: /* nacional */
                            IF pedido-drb-item.val-fob-nac - deTotValor < deValMovtoAtoMeConv THEN
                                ASSIGN tt-itens-ac.l-item-ato = NO.
                            ELSE
                                ASSIGN l-ok = YES.
                        END.
                    END.
                    ELSE IF pedido-drb.modalidade = 2 THEN DO:  /** Isencao   **/
    
                        ASSIGN de-tot-valor-ent = 0
                               deValMovtoAtoMeConv = 0.
        
                        FOR EACH movto-ato 
                           WHERE movto-ato.cod-estabel   = pedido-drb-item.cod-estabel
                             AND movto-ato.nr-pedido-drb = pedido-drb-item.nr-pedido-drb
                             AND movto-ato.it-codigo     = pedido-drb-item.it-codigo NO-LOCK:
                           IF  movto-ato.idi-tip-movto = 2 THEN DO:  /**baixa **/

                               IF movto-ato.mo-codigo <> i-moeda-aux THEN DO:                               
                                   RUN cdp/cd0812.p (INPUT movto-ato.mo-codigo,
                                                     INPUT i-moeda-aux, 
                                                     INPUT movto-ato.val-movto-ato-me, 
                                                     INPUT movto-ato.dat-cotac, 
                                                     OUTPUT deTotValor).
                                   ASSIGN deValMovtoAtoMeConv  = deValMovtoAtoMeConv + deTotValor.
                               END.                                   
                               ELSE
                                   ASSIGN deValMovtoAtoMeConv  = deValMovtoAtoMeConv + movto-ato.val-movto-ato-me.
                               
                           END.
                        END.

                        IF ordem-compra.mo-codigo <> i-moeda-aux THEN
                            RUN cdp/cd0812.p (INPUT ordem-compra.mo-codigo, 
                                              input i-moeda-aux,
                                              input ROUND(deValorConv,2),
                                              input IF AVAIL embarque-imp THEN embarque-imp.data-1 
                                                    ELSE docum-est.dt-emissao,
                                              OUTPUT deValMovtoNovaImp).
                        ELSE 
                            ASSIGN deValMovtoNovaImp = deValorConv.

                        CREATE tt-itens-ac.
                        ASSIGN tt-itens-ac.it-codigo          = pedido-drb-item.it-codigo
                               tt-itens-ac.nr-ato-concessorio = pedido-drb.nr-ato-concessorio
                               tt-itens-ac.r-rowid-item       = ROWID(pedido-drb-item)
                               tt-itens-ac.l-item-ato         = YES.

                        IF i-tip-movto = 1 THEN DO: /* internacional */ 
                            IF pedido-drb-item.preco-fob - deValMovtoAtoMeConv < deValMovtoNovaImp THEN
                                ASSIGN tt-itens-ac.l-item-ato = NO.
                            ELSE
                                ASSIGN l-ok = YES.
                        END.
                        ELSE DO:
                            IF pedido-drb-item.val-fob-nac - deValMovtoAtoMeConv < deValMovtoNovaImp THEN
                                ASSIGN tt-itens-ac.l-item-ato = NO.
                            ELSE
                                ASSIGN l-ok = YES.
                        END.
                    END.
                    END.
                END.
            END.
        END.
    END.

    ASSIGN pl-ok = CAN-FIND(FIRST tt-itens-ac WHERE tt-itens-ac.l-item-ato = NO).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaAtoConcessorioItem DBOProgram 
PROCEDURE VerificaAtoConcessorioItem :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no indice CH-PEDIDO
  Parameters:
               recebe valor dos campos do indice CH-PEDIDO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-estabel   LIKE Pedido-drb.cod-estabel    NO-UNDO.
    DEFINE INPUT PARAMETER pnr-pedido-drb LIKE Pedido-drb.nr-pedido-drb  NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo     LIKE pedido-drb-item.it-codigo NO-UNDO.
    
    if can-find(pedido-drb-item 
                    WHERE pedido-drb-item.cod-estabel   = pcod-estabel 
                      and pedido-drb-item.nr-pedido-drb = pnr-pedido-drb
                      and pedido-drb-item.it-codigo     = pit-codigo) then 
        RETURN "OK":U.
    else
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

