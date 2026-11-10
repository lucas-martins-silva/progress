&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOFunction 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
******************************************************************************/
{include/i-prgvrs.i BOIN404RE 2.00.00.062 } /*** "010062" 17/06/2025 16:40:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin404re MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbofun.p
    Purpose    : O DBO Function (Datasul Business Objects) ý um programa 
                 PROGRESS que contým a l«gica de neg«cio.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName      BOIN404RE
&GLOBAL-DEFINE DBOVersion   1.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName    saldo-terc
&GLOBAL-DEFINE TableLabel   Saldo Terceiros
&GLOBAL-DEFINE QueryName    qr{&TableName}

{utp/ut-glob.i}
{cdp/cdcfgmat.i}

{method/dboqry.i}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret«rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser id¬ntico ao nome do DBO mas com 
      extensÊo .i ---*/
{inbo/boin404.i RowObject}

{inbo/boin404.i RowObjectAux}

{inbo/boin404re.i1 tt-item-estrut }

{inbo/boin176.i5 tt-item-saldo-terc }

{include/i-epc200.i boin404re}         /* Definicao da temp-table tt-epc */

/* Defini‡Æo/atribui‡Æo da vari ve l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{cdp/cd9701.i}

DEFINE TEMP-TABLE RowErrorsTemp NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEF BUFFER bNaturOper FOR natur-oper.

def var l-retorno       as logical  no-undo.
def var l-remessa       as logical  no-undo.
def var i-tipo-sal-terc as integer  no-undo.
def var h-boin176       as handle   no-undo.
DEF VAR h-boin404       AS HANDLE   NO-UNDO.
def var c-deposito      as char     no-undo.

DEFINE TEMP-TABLE tt-doc-orig-refer NO-UNDO
    LIKE doc-orig-refer-nfe
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-saldo NO-UNDO LIKE item-ref-nfe
    FIELD l-referenciada AS LOGICAL
    FIELD dt-saldo       AS DATE
    FIELD dt-retorno     AS DATE
    FIELD qtd-comercial  LIKE item-ref-nfe.qtd-alocada
    FIELD qtd-alocar     LIKE item-ref-nfe.qtd-alocada   
    FIELD vlr-unit-item  LIKE componente.preco-total[1]
    FIELD vlr-tot-item   LIKE componente.preco-total[1]
    FIELD narrativa-item LIKE componente.narrativa.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOFunction



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOFunction
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOFunction ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOFunction 
/* ************************* Included-Libraries *********************** */

{method/dbofun.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOFunction 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alocaSaldoTerc DBOFunction 
PROCEDURE alocaSaldoTerc :
/*------------------------------------------------------------------------------
  Purpose: Alocar/desalocar o saldo em poder de terceiros.
  Parameters:
  pl-aloca:         Indica se deve alocar (YES) ou desalocar (NO) saldo em poder de terceiros
  pd-qtd-alocar:    Quantidade a ser alocada/desalocada
  pi-seq:           Sequˆncia do item
  pi-cod-emitente:  C¢digo do emitente 
  pc-nro-docto:     N£mero do documento 
  pc-serie-docto:   S‚rie do documento
  pc-nat-operacao:  Natureza de opera‡Æo do item
  pc-nat-terc:      Nutereza de opera‡Æo do saldo em terceiros
  pc-it-codigo:     C¢digo do item
  
  Notes:
------------------------------------------------------------------------------*/      
    def input param pl-aloca        as log  no-undo.
    def input param pd-qtd-alocar   as dec  no-undo.
    def input param pi-seq          as int  no-undo.
    def input param pi-cod-emitente as int  no-undo.
    def input param pc-nro-docto    as char no-undo.
    def input param pc-serie-docto  as char no-undo.
    def input param pc-nat-operacao as char no-undo. /* Natureza do item. */
    def input param pc-nat-terc     as char no-undo. /* Natureza do saldo em terceiros. */
    def input param pc-it-codigo    as char no-undo.

    DEFINE VARIABLE lFatConsigDevSimb    AS LOGICAL                 NO-UNDO.
        
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:
        find first saldo-terc exclusive-lock
            where saldo-terc.serie-docto  = pc-serie-docto
            and   saldo-terc.nro-docto    = pc-nro-docto
            and   saldo-terc.cod-emitente = pi-cod-emitente
            and   saldo-terc.nat-operacao = pc-nat-terc
            and   saldo-terc.it-codigo    = pc-it-codigo
            and   saldo-terc.sequencia    = pi-seq no-error.
        
        if avail saldo-terc then do:
    
            find first natur-oper no-lock
                where natur-oper.nat-operacao = pc-nat-operacao no-error.

            ASSIGN lFatConsigDevSimb = {cdp/cd0066.i2 saldo-terc.cod-estabel}. /* Valida obrigacoes fiscais. */

            /******** Inicio UPC Unimed Nordeste RS **********/
            IF c-nom-prog-dpc-mg97  <> "" OR 
               c-nom-prog-appc-mg97 <> "" OR
               c-nom-prog-upc-mg97  <> "" THEN DO:
                
                FOR EACH tt-epc 
                    WHERE tt-epc.cod-event = "devol-simb-consig-aloca":U:
                    DELETE tt-epc.
                END.

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-aloca":U
                       tt-epc.cod-parameter = "nat-operacao-retorno":U
                       tt-epc.val-parameter = STRING(pc-nat-operacao).
                
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-aloca":U
                       tt-epc.cod-parameter = "rowid-saldo-terc":U
                       tt-epc.val-parameter = STRING(ROWID(saldo-terc)).
            
                {include/i-epc201.i "devol-simb-consig-aloca"}
            
                FOR FIRST tt-epc 
                    WHERE tt-epc.cod-event     = "devol-simb-consig-aloca"
                    AND   tt-epc.cod-parameter = "altera-flag":
                    ASSIGN lFatConsigDevSimb = LOGICAL(tt-epc.val-parameter).
                END.
            END.
            /******* Fim UPC Unimed Nordeste RS *******/
            
            /* Aloca‡Æo nota de Faturamento Consignacao. */
            if  avail natur-oper
            /*and {cdp/cd0066.i2 saldo-terc.cod-estabel} /* Valida obrigacoes fiscais. */*/
            and lFatConsigDevSimb
            and natur-oper.tp-oper-terc = 4 THEN DO:
            
                if not valid-handle(h-boin404) or
                    h-boin404:type      <> "PROCEDURE":U or
                    h-boin404:file-name <> "inbo/boin404.p":U then
                    
                    RUN inbo/boin404.p PERSISTENT SET h-boin404.
    
                run updateFifoDevolucaoSimbolica in h-boin404 (yes,
                                                               pl-aloca,
                                                               rowid(saldo-terc),
                                                               pd-qtd-alocar).
            END.
            ELSE DO:       
                if pl-aloca then /* YES -> aloca. */
                    assign saldo-terc.dec-1 = saldo-terc.dec-1 + pd-qtd-alocar.
                else /* NO -> desaloca. */
                    assign saldo-terc.dec-1 = saldo-terc.dec-1 - pd-qtd-alocar.
                IF saldo-terc.dec-1 < 0 THEN
                    ASSIGN saldo-terc.dec-1 = 0.
            END.
        end.
    END.
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOFunction 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose: Elina‡Æo de handles    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    IF  VALID-HANDLE(h-boin404)        AND
        h-boin404:TYPE = "PROCEDURE":U AND
        h-boin404:FILE-NAME = "inbo/boin404.p":U THEN DO:
        DELETE PROCEDURE h-boin404.
        ASSIGN h-boin404 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaSaldoTerc DBOFunction 
PROCEDURE carregaSaldoTerc :
/*------------------------------------------------------------------------------
  Purpose: Carrega Saldo de terceiros para o conversor de NFe de entrada    
  Parameters: pchave-acesso: Chave de acesso da NFe
              tt-doc-orig-refer: Temp-table contendo os documentos referenciados
              tt-saldo: Temp-table contendo os saldos carregados
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER pchave-acesso LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEF INPUT  PARAMETER l-desconsidera-item  AS LOGICAL   NO-UNDO.
    DEF INPUT  PARAMETER TABLE FOR tt-doc-orig-refer.   
    DEF OUTPUT PARAMETER TABLE FOR tt-saldo.

    DEFINE VARIABLE i-cont             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-nat-oper         AS CHARACTER NO-UNDO.

    DEFINE VARIABLE deQtdeAFatur         LIKE componente.quantidade NO-UNDO.
    DEFINE VARIABLE lMovtoDevSimbConsig  AS LOGICAL                 NO-UNDO.
    DEFINE VARIABLE lFatConsigDevSimb    AS LOGICAL                 NO-UNDO.

    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:        
        EMPTY TEMP-TABLE tt-saldo.

        FOR FIRST doc-orig-nfe FIELDS(cod-emitente cod-estabel dt-emissao)
            WHERE doc-orig-nfe.ch-acesso-comp-nfe = pchave-acesso
              AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:                    
        END.        
        
        ASSIGN i-cont = 0.
        FOR EACH item-doc-orig-nfe FIELDS (it-codigo ch-acesso-comp-nfe idi-orig-trad nat-operacao qtd-comercial seq-item int-2)
            WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = pchave-acesso
            and   item-doc-orig-nfe.idi-orig-trad      = 2 no-lock
            break by item-doc-orig-nfe.it-codigo
                  by item-doc-orig-nfe.nat-operacao:
              
            IF NOT(item-doc-orig-nfe.int-2 = 5  OR  /* Retorno Beneficiamento  */
                   item-doc-orig-nfe.int-2 = 7  OR  /* Faturamento Consigna‡Æo */
                   item-doc-orig-nfe.int-2 = 8  OR  /* Devolu‡Æo Consigna‡Æo   */
                   item-doc-orig-nfe.int-2 = 9  OR  /* Devolu‡Æo Consigna‡Æo   */
                   item-doc-orig-nfe.int-2 = 12 OR  /* Reajuste Pre‡o  */ 
                   item-doc-orig-nfe.int-2 = 19 OR  /*Ret Dep Fechado  */
                   item-doc-orig-nfe.int-2 = 21) THEN /*Ret Armaz Geral*/
                NEXT. 
            ELSE
                RUN setTipoSalTercTipoOperac (INPUT item-doc-orig-nfe.int-2). 
           
            IF FIRST-OF (item-doc-orig-nfe.it-codigo)
            OR FIRST-OF (item-doc-orig-nfe.nat-operacao) THEN DO:      
                IF l-desconsidera-item THEN DO:
                    {inbo/boin404re.i2} /* For each saldo-terc desconsiderando codigo do item */
                END.
                ELSE DO:
                    {inbo/boin404re.i2 "AND saldo-terc.it-codigo = item-doc-orig-nfe.it-codigo"} /* For each saldo-terc considerando codigo do item */
                END.
            END.
        END.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaSaldoTercItem DBOFunction 
PROCEDURE carregaSaldoTercItem :
/*------------------------------------------------------------------------------
  Purpose: Carrega Saldo de terceiros para o conversor de NFe de entrada    
  Parameters: pchave-acesso: Chave de acesso da NFe
              pseq-item: sequencia do item nf-e
              tt-saldo: Temp-table contendo os saldos carregados
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT  PARAMETER pchave-acesso LIKE doc-orig-nfe.ch-acesso-comp-nfe NO-UNDO.
    DEF INPUT  PARAMETER pseq-item     AS INT                               NO-UNDO.
    DEF INPUT  PARAMETER l-desconsidera-item  AS LOGICAL                    NO-UNDO.
    DEF OUTPUT PARAMETER TABLE FOR tt-saldo.

    DEFINE VARIABLE i-cont             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-nat-oper         AS CHARACTER NO-UNDO.

    DEFINE VARIABLE deQtdeAFatur         LIKE componente.quantidade NO-UNDO.
    DEFINE VARIABLE lMovtoDevSimbConsig  AS LOGICAL                 NO-UNDO.
    DEFINE VARIABLE lFatConsigDevSimb    AS LOGICAL                 NO-UNDO.

    EMPTY TEMP-TABLE tt-saldo.

    FOR FIRST doc-orig-nfe FIELDS(cod-emitente cod-estabel dt-emissao)
        WHERE doc-orig-nfe.ch-acesso-comp-nfe = pchave-acesso
          AND doc-orig-nfe.idi-orig-trad      = 2 NO-LOCK:
    END.

    ASSIGN i-cont = 0.
    FOR FIRST item-doc-orig-nfe FIELDS (it-codigo ch-acesso-comp-nfe idi-orig-trad nat-operacao qtd-comercial seq-item int-2)
        WHERE item-doc-orig-nfe.ch-acesso-comp-nfe = pchave-acesso
          AND item-doc-orig-nfe.seq-item           = pseq-item
          AND item-doc-orig-nfe.idi-orig-trad      = 2 no-lock:

        IF NOT(item-doc-orig-nfe.int-2 = 5  OR  /* Retorno Beneficiamento  */
               item-doc-orig-nfe.int-2 = 7  OR  /* Faturamento Consigna‡Æo */
               item-doc-orig-nfe.int-2 = 8  OR  /* Devolu‡Æo Consigna‡Æo   */
               item-doc-orig-nfe.int-2 = 9  OR  /* Devolu‡Æo Consigna‡Æo   */
               item-doc-orig-nfe.int-2 = 12 OR  /* Reajuste Pre‡o  */ 
               item-doc-orig-nfe.int-2 = 19 OR  /*Ret Dep Fechado  */
               item-doc-orig-nfe.int-2 = 21) THEN /*Ret Armaz Geral*/
            NEXT. 
        ELSE
            RUN setTipoSalTercTipoOperac (INPUT item-doc-orig-nfe.int-2).

        IF l-desconsidera-item THEN DO:
            {inbo/boin404re.i2} /* For each saldo-terc desconsiderando codigo do item */
        END.
        ELSE DO:
            {inbo/boin404re.i2 "AND saldo-terc.it-codigo = item-doc-orig-nfe.it-codigo"} /* For each saldo-terc considerando codigo do item */
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItembyEstrutura DBOFunction 
PROCEDURE createItembyEstrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItemPai       like componente.it-codigo   no-undo.
    def input param piQuantidade    like componente.quantidade  no-undo.
    def input param piDataCorte     like componente.dt-retorno  no-undo.
    
    def buffer b-item               for item.
    def buffer b-estrutura          for estrutura.

    def var rw-end-ret              as   rowid   extent 22      no-undo.
    def var i-fator                 as   decimal extent 22      no-undo.
    def var i-retorno               as   integer                no-undo.
    def var c-item                  like componente.it-codigo   no-undo.
    def var i-sequencia             like componente.sequencia   no-undo.
    
    find last tt-item-estrut no-lock no-error.

    assign i-fator[1]  = piQuantidade
           i-retorno   = 1
           c-item      = piItemPai
           i-sequencia = if  avail tt-item-estrut 
                         then tt-item-estrut.sequencia + 10
                         else 10.

    comeco:
    repeat:
        for first estrutura 
            fields (estrutura.es-codigo
                    estrutura.qtd-compon
                    estrutura.qtd-item   
                    estrutura.proporcao
                    estrutura.quant-usada
                    estrutura.fantasma
                    estrutura.it-codigo
                    estrutura.sequencia
                    estrutura.log-quant-fix)
            where estrutura.it-codigo    = c-item 
            and   estrutura.data-inicio <= piDataCorte
            and   estrutura.data-termino > piDataCorte
            and   estrutura.quant-usada  > 0 no-lock:
        end.
          
        if  not available estrutura 
        and i-retorno < 3 then
            leave.
                  
        if  i-retorno = 1 then
            assign i-retorno             = i-retorno + 1
                   rw-end-ret[i-retorno] = rowid(estrutura).
          
        repeat:
            if  available estrutura then do:
                for first b-item 
                    fields ( b-item.it-codigo b-item.tipo-contr)
                    where b-item.it-codigo = estrutura.es-codigo no-lock:
                end.
                          
                &IF DEFINED (bf_man_sfc_lc) &THEN
                    /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                    assign i-fator[i-retorno] = if estrutura.log-quant-fix then estrutura.qtd-compon
                                                else i-fator[i-retorno - 1] * estrutura.qtd-compon / estrutura.qtd-item * estrutura.proporcao  / 100.
                &ELSE
                    assign i-fator[i-retorno] = i-fator[i-retorno - 1] * estrutura.quant-usada *
                                                estrutura.proporcao    / 100.                
                &ENDIF
                          
                if  estrutura.fantasma then do:
                    for first b-estrutura 
                        fields ()
                        where b-estrutura.it-codigo    = estrutura.es-codigo  
                        and   b-estrutura.data-inicio <= piDataCorte 
                        and   b-estrutura.data-termino > piDataCorte no-lock:
                    end.
                              
                    if  not avail b-estrutura 
                    and b-item.it-codigo  <> "" 
                    and b-item.tipo-contr <> 4 then do: /* Debito Direto */
                        find first tt-item-estrut
                             where tt-item-estrut.it-codigo = b-item.it-codigo no-error.
  
                        if  not avail tt-item-estrut then do:
                            create tt-item-estrut.
                            assign tt-item-estrut.sequencia = i-sequencia
                                   tt-item-estrut.it-codigo = b-item.it-codigo
                                   tt-item-estrut.cod-depos = c-deposito
                                   tt-item-estrut.aux       = "*"
                                   i-sequencia              = i-sequencia + 10.
                        end.
  
                        assign tt-item-estrut.quantidade = tt-item-estrut.quantidade + i-fator[i-retorno].
                    end.
  
                    assign c-item = estrutura.es-codigo
                           i-retorno = i-retorno + 1
                           rw-end-ret[i-retorno] = rowid(estrutura).
                    next comeco.
                end.
                else
                    if  b-item.tipo-contr <> 4                /* Debito Direto */ 
                    and b-item.it-codigo <> "" then do:
                        find first tt-item-estrut 
                             where tt-item-estrut.it-codigo = b-item.it-codigo no-error.

                        if  not avail tt-item-estrut then do:
                            create tt-item-estrut.
                            assign tt-item-estrut.sequencia = i-sequencia
                                   tt-item-estrut.cod-depos = c-deposito
                                   tt-item-estrut.aux       = "*"
                                   tt-item-estrut.it-codigo = b-item.it-codigo
                                   i-sequencia              = i-sequencia + 10.
                        end.
          
                        assign tt-item-estrut.quantidade = tt-item-estrut.quantidade + i-fator[i-retorno].
                    end.
            end.
            else do:
                if  i-retorno = 2 then
                    leave comeco.
                else
                for first estrutura 
                    fields (estrutura.es-codigo
                            estrutura.qtd-compon
                            estrutura.qtd-item   
                            estrutura.proporcao
                            estrutura.quant-usada
                            estrutura.fantasma
                            estrutura.it-codigo)
                    where rowid(estrutura) = rw-end-ret[i-retorno] no-lock:
  
                    assign c-item = estrutura.it-codigo
                           i-retorno = i-retorno - 1.
                end.
            end.

            find next estrutura 
                 where estrutura.it-codigo    = c-item
                 and   estrutura.data-inicio <= piDataCorte
                 and   estrutura.data-termino > piDataCorte
                 and   estrutura.quant-usada  > 0 no-lock no-error.
        end.
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItembyOrdProd DBOFunction 
PROCEDURE createItembyOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piOrdProd    like componente.nr-ord-prod no-undo.
    def input param piQuantidade like componente.quantidade  no-undo.
        
    def var de-qtd-saldo         like componente.quantidade  no-undo.
    def var i-sequencia          like componente.sequencia   no-undo.
    def var l-reserva            as logical                  no-undo.
    
    find last tt-item-estrut no-lock no-error.
    
    assign i-sequencia = if  avail tt-item-estrut then 
                             tt-item-estrut.sequencia + 10
                         else 
                             10.
                             
    for first ord-prod
        fields ( nr-ord-produ ord-prod.qt-ordem)
         where ord-prod.nr-ord-produ = piOrdProd no-lock:
           
        for each reservas 
            fields (reservas.quant-orig 
                    reservas.quant-atend
                    reservas.quant-terc
                    reservas.it-codigo
                    reservas.cod-refer)
            where reservas.nr-ord-produ = ord-prod.nr-ord-produ
            and   reservas.quant-orig  > 0 no-lock:
         
            assign de-qtd-saldo = reservas.quant-orig - (reservas.quant-atend + reservas.quant-terc).
         
            if  l-remessa 
            and de-qtd-saldo <= 0 then 
                next.
                
            create tt-item-estrut.
            assign tt-item-estrut.sequencia   = i-sequencia
                   tt-item-estrut.aux         = "*"
                   tt-item-estrut.it-codigo   = reservas.it-codigo
                   tt-item-estrut.nr-ord-prod = ord-prod.nr-ord-produ
                   tt-item-estrut.cod-depos   = c-deposito
                   tt-item-estrut.cod-refer   = reservas.cod-refer
                   tt-item-estrut.quantidade  = piQuantidade 
                                              * reservas.quant-orig / ord-prod.qt-ordem
                   tt-item-estrut.rw-reservas = rowid(reservas)
                   i-sequencia                = i-sequencia + 10.
                                                                      
            assign l-reserva = yes.
            
            if  l-remessa 
            and tt-item-estrut.quantidade > de-qtd-saldo then 
                assign tt-item-estrut.quantidade = de-qtd-saldo.
         
            if  l-retorno 
            and tt-item-estrut.quantidade > (reservas.quant-orig - reservas.quant-atend) then 
                assign tt-item-estrut.quantidade = (reservas.quant-orig - reservas.quant-atend).
        end.
    end.
    
    if  not l-reserva then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="25842"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
    end.
    else RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItemEstrutbyItem DBOFunction 
PROCEDURE createItemEstrutbyItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItCodigo      like componente.it-codigo       no-undo.
    def input param piQuantidade    like componente.quantidade      no-undo.
    def input param piPrecoUnit     like item-doc-est.preco-unit[1] no-undo.
    def input param piPrecoTotal    like componente.preco-total[1]  no-undo.
    def input param piOrdProd       like componente.nr-ord-prod     no-undo.
    def input param piCodDepos      like componente.cod-depos       no-undo.
            
    def var i-sequencia             as int                          no-undo.
    
    run emptyRowErrors.
                
    run findItem ( input piItCodigo ).
    
    if  piOrdProd <> 0 then 
        run findOrdProd ( input piOrdProd ).
    
    if  piQuantidade = 0 then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="2920"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
    end.            
    else do:
    
        if  piPrecoUnit <> 0 then 
            assign piPrecoTotal = piPrecoUnit * piQuantidade.
        else 
            assign piPrecoUnit  = piPrecoTotal / piQuantidade.                                                 
    end.            

    if  piCodDepos <> "" then 
        run findDeposito ( input piCodDepos ).
        
    IF  NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:

        find last tt-item-estrut no-error.

        assign i-sequencia = if  avail tt-item-estrut
                             then tt-item-estrut.sequencia + 10
                             else 10.

        create tt-item-estrut.
        assign tt-item-estrut.sequencia   = i-sequencia
               tt-item-estrut.it-codigo   = piItCodigo
               tt-item-estrut.quantidade  = piQuantidade
               tt-item-estrut.preco-unit  = piPrecoUnit
               tt-item-estrut.preco-total = piPrecoTotal
               tt-item-estrut.nr-ord-prod = piOrdProd
               tt-item-estrut.cod-depos   = piCodDepos
               tt-item-estrut.aux         = "*".

        RETURN "OK":U.               

    END.
    ELSE 
        RETURN "NOK":U.
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItemEstrutbyOrdProd DBOFunction 
PROCEDURE createItemEstrutbyOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piOrdProd       like componente.nr-ord-prod no-undo.
    def input param piItemPai       like componente.it-codigo   no-undo.
    def input param piQuantidade    like componente.quantidade  no-undo.
    def input param piDataCorte     like componente.dt-retorno  no-undo.
    def input param piCodDepos      like componente.cod-depos   no-undo.
    
    if  piQuantidade <= 0 then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="2920"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
        return "NOK":U.                            
    end.
    
    if  piCodDepos <> "" then do:
        run findDeposito ( piCodDepos ).
        if  return-value = "NOK":U then 
            RETURN "NOK":U.
    end.
    
    assign c-deposito = piCodDepos.
    
    if  piOrdProd <> 0 then 
        run createItembyOrdProd ( piOrdProd, piQuantidade ).
    else
        run createItembyEstrutura ( piItemPai, piQuantidade, piDataCorte ).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyTTItemEstrut DBOFunction 
PROCEDURE emptyTTItemEstrut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each tt-item-estrut exclusive-lock:
    
        delete tt-item-estrut.
    end.        
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableQtdePrecoTotal DBOFunction 
PROCEDURE enableQtdePrecoTotal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piNatOperacao    like saldo-terc.nat-operacao  no-undo.
    def output param piHabilitaQtde   as log                        no-undo.
    def output param piHabilitaPreco  as log                        no-undo.
    
    run findNaturOper ( piNatOperacao ).

    assign piHabilitaQtde  =   avail natur-oper
                           and natur-oper.tp-oper-terc <> 6        /* Diferente de Diferenca Preco */
                           
           piHabilitaPreco =   avail natur-oper
                           and substr(natur-oper.char-2,36,5) = "1    ". /* Altera Valor Terceiros */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDeposito DBOFunction 
PROCEDURE findDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodDepos   like componente.cod-depos no-undo.
    

    
    if  not avail deposito
    or  deposito.cod-depos <> piCodDepos then 
    
        for first deposito
            fields ( cod-depos )
            where deposito.cod-depos = piCodDepos no-lock.
        end.
        
    if  not avail deposito then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-depsito AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Dep«sito" *}
        ASSIGN c-lbl-liter-depsito = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-depsito"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findEmitente DBOFunction 
PROCEDURE findEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente  like componente.cod-emitente no-undo.
    
    if  not avail emitente
    or  emitente.cod-emitente <> piCodEmitente then 
    
        for first emitente
            fields ( cod-emitente nome-abrev  )
            where emitente.cod-emitente = piCodEmitente no-lock.
        end.
        
    if  not avail emitente then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-emitente AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Emitente" *}
        ASSIGN c-lbl-liter-emitente = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-emitente"}
        RETURN "NOK":U.
    end.
    else 
        RETURN "OK":U.        



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOFunction 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItCodigo   like componente.it-codigo no-undo.
    
    if  not avail item
    or  item.it-codigo <> piItCodigo then 
    
        for first item
            fields ( it-codigo un desc-item fraciona )
            where item.it-codigo = piItCodigo no-lock.
        end.
        
    if  not avail item then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-item"}
        RETURN "NOK":U.
    end.
    else 
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNaturOper DBOFunction 
PROCEDURE findNaturOper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNatOperacao like componente.nat-operacao no-undo.
    
    if  not avail natur-oper
    or  natur-oper.nat-operacao <> piNatOperacao then 
    
        for first natur-oper
            fields ( nat-operacao tp-oper-terc tipo transf denominacao 
                     terceiros char-2 dec-1 
                   &IF "{&mguni_version}" >= "2.08" &THEN idi-tip-devol-consig &ELSE char-1 &ENDIF )
            where natur-oper.nat-operacao = piNatOperacao no-lock.
        end.
        
    if  not avail natur-oper then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-natureza-de-operacao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Natureza_de_Opera‡Æo" *}
        ASSIGN c-lbl-liter-natureza-de-operacao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-natureza-de-operacao"}
        RETURN "NOK":U.
    end.
    else 
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrdProd DBOFunction 
PROCEDURE findOrdProd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piOrdProd   like componente.nr-ord-prod no-undo.
    
    if  not avail ord-prod
    or  ord-prod.nr-ord-produ <> piOrdProd then 
    
        for first ord-prod
            fields ( nr-ord-produ )
            where ord-prod.nr-ord-produ = piOrdProd no-lock.
        end.
        
    if  not avail ord-prod then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-ordem-de-producao AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Ordem_de_Produ‡Æo" *}
        ASSIGN c-lbl-liter-ordem-de-producao = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-ordem-de-producao"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findSaldoTerc DBOFunction 
PROCEDURE findSaldoTerc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente like saldo-terc.cod-emitente no-undo.
    def input param piSerieDocto  like saldo-terc.serie-docto  no-undo.
    def input param piNroDocto    like saldo-terc.nro-docto    no-undo.
    def input param piNatOperacao like saldo-terc.nat-operacao no-undo.
    def input param piSequencia   like saldo-terc.sequencia    no-undo.
    def input param piItCodigo    like saldo-terc.it-codigo    no-undo.
    def input param piCodRefer    like saldo-terc.cod-refer    no-undo.

    
    if  not avail saldo-terc
    or  saldo-terc.cod-emitente <> piCodEmitente
    or  saldo-terc.serie-docto  <> piSerieDocto
    or  saldo-terc.nro-docto    <> piNroDocto
    or  saldo-terc.nat-operacao <> piNatOperacao
    or  saldo-terc.sequencia    <> piSequencia
    or  saldo-terc.it-codigo    <> piItCodigo
    or  saldo-terc.cod-refer    <> piCodRefer then 
    
       for first saldo-terc 
           where saldo-terc.cod-emitente = piCodEmitente
             and saldo-terc.serie-docto  = piSerieDocto
             and saldo-terc.nro-docto    = piNroDocto
             and saldo-terc.nat-operacao = piNatOperacao
             and saldo-terc.it-codigo    = piItCodigo
             and saldo-terc.cod-refer    = piCodRefer
             and saldo-terc.sequencia    = piSequencia no-lock:
          end.            

    if  not avail saldo-terc then do:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-saldo-em-poder-de-terceiros AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Saldo_em_Poder_de_Terceiros" *}
        ASSIGN c-lbl-liter-saldo-em-poder-de-terceiros = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lbl-liter-saldo-em-poder-de-terceiros"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsOfDocumento DBOFunction 
PROCEDURE getBatchRecordsOfDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piCodEmitente    as int                                no-undo.
    def input  param piNatOperRetorno as char                               no-undo.
    def input  param piDataTrans      as date                               no-undo.    
    def input  param piProporcao      as dec                                no-undo.
    def input  param piSerieDocto     as char                               no-undo.
    def input  param piNroDocto       as char                               no-undo.
    def input  param piNatOperacao    as char                               no-undo.    
    def output param table            for RowObjectAux. 

    DEF VAR deQtdeEmFatur             LIKE componente.quantidade            NO-UNDO.
    DEF VAR deQtdeAFatur              LIKE componente.quantidade            NO-UNDO.
    def var de-quantidade             like componente.quantidade            no-undo.
    def var de-preco-total            like componente.preco-total extent 0  no-undo.
    def var de-desconto               like componente.desconto    extent 0  no-undo.
    DEF VAR lMovtoDevSimbConsig       AS LOGICAL                            NO-UNDO.
    def var i-tipo-sal-terc           as integer                            no-undo.
    
    DEFINE VARIABLE lFatConsigDevSimb    AS LOGICAL                 NO-UNDO.

    /* Limpa temp-table RowObjectAux */
    for each RowObjectAux :
        delete RowObjectAux.
    end.        

    run findNaturOper ( piNatOperRetorno ).

    /* Se USA m£ltiplas naturezas no recebimento */
    IF  l-mult-natur-receb THEN DO: /* l-mult-natur-receb -> def em cd9701.i */
    
        /* Atualiza I-TIPO-SAL-TERC */
        {inbo/boin404.i2 natur-oper.tipo
                         natur-oper.tp-oper-terc
                         natur-oper.transf }

        FOR EACH saldo-terc 
            WHERE saldo-terc.cod-emitente = piCodEmitente
              AND saldo-terc.serie-docto  = piSerieDocto
              AND saldo-terc.nro-docto    = piNroDocto NO-LOCK: /* nÆo consiste a natureza... */
    
            IF saldo-terc.tipo-sal-terc <> i-tipo-sal-terc THEN
                NEXT.
                
            create RowObjectAux.
            buffer-copy saldo-terc to RowObjectAux.
            assign RowObjectAux.r-rowid = rowid(saldo-terc)
                   de-quantidade  = 0.
    
            for first componente 
                fields ( cod-emitente nro-docto serie-docto 
                         nat-operacao it-codigo cod-refer 
                         sequencia preco-total[1] desconto[1] )
                of RowObjectAux no-lock.
            end.         
        
            run findItem ( input saldo-terc.it-codigo ).
            
            ASSIGN lFatConsigDevSimb = {cdp/cd0066.i2 saldo-terc.cod-estabel}. /* Valida obrigacoes fiscais. */

            /******** Inicio UPC Unimed Nordeste RS **********/
            IF c-nom-prog-dpc-mg97  <> "" OR 
               c-nom-prog-appc-mg97 <> "" OR
               c-nom-prog-upc-mg97  <> "" THEN DO:
                
                FOR EACH tt-epc 
                    WHERE tt-epc.cod-event = "devol-simb-consig-manual":U:
                    DELETE tt-epc.
                END.
                
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-manual":U
                       tt-epc.cod-parameter = "cod-emitente-retorno":U
                       tt-epc.val-parameter = STRING(piCodEmitente).
                
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-manual":U
                       tt-epc.cod-parameter = "nat-operacao-retorno":U
                       tt-epc.val-parameter = STRING(piNatOperRetorno).

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-manual":U
                       tt-epc.cod-parameter = "rowid-saldo-terc":U
                       tt-epc.val-parameter = STRING(ROWID(saldo-terc)).

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-manual":U
                       tt-epc.cod-parameter = "rowid-componente":U
                       tt-epc.val-parameter = STRING(ROWID(componente)).
            
                {include/i-epc201.i "devol-simb-consig-manual"}
            
                FOR FIRST tt-epc 
                    WHERE tt-epc.cod-event     = "devol-simb-consig-manual"
                    AND   tt-epc.cod-parameter = "altera-flag":
                    ASSIGN lFatConsigDevSimb = LOGICAL(tt-epc.val-parameter).
                END.
            END.
            /******* Fim UPC Unimed Nordeste RS *******/

            /*IF  {cdp/cd0066.i2 saldo-terc.cod-estabel}*/
            IF  lFatConsigDevSimb
            AND natur-oper.tp-oper-terc = 4 THEN DO:
                ASSIGN deQtdeEmFatur = 0
                       deQtdeAFatur  = 0.
                
                FOR EACH componente NO-LOCK
                    WHERE componente.cod-emitente = saldo-terc.cod-emitente
                      AND componente.nro-comp     = saldo-terc.nro-docto
                      AND componente.serie-comp   = saldo-terc.serie-docto
                      AND componente.nat-comp     = saldo-terc.nat-operacao
                      AND componente.seq-comp     = saldo-terc.sequencia
                      AND componente.it-codigo    = saldo-terc.it-codigo:
    
                    FIND FIRST bNaturOper NO-LOCK
                         WHERE bNaturOper.nat-operacao = componente.nat-operacao NO-ERROR.
                    IF  AVAIL bNaturOper THEN DO:
                        ASSIGN lMovtoDevSimbConsig = {cdp/cd0066.i1 bNaturOper componente}
                    END.
                    ELSE
                        ASSIGN lMovtoDevSimbConsig = NO.
                    
                    IF  lMovtoDevSimbConsig THEN DO:
                        ASSIGN deQtdeAFatur = deQtdeAFatur + 
                               &IF "{&mguni_version}" >= "2.08" &THEN
                                (componente.qtd-devol-simbol - componente.qtd-fatur-consig - componente.qtd-afatur-consig)
                               &ELSE
                                (DEC(SUBSTR(componente.char-1,40,14)) - DEC(SUBSTR(componente.char-1,68,14)) - DEC(SUBSTR(componente.char-1,54,14)))
                               &ENDIF .
    
                        ASSIGN deQtdeEmFatur = deQtdeEmFatur +
                               &IF "{&mguni_version}" >= "2.08" &THEN
                                componente.qtd-afatur-consig
                               &ELSE
                                DEC(SUBSTR(componente.char-1,54,14))
                               &ENDIF .
                    END.
                END.
                
                IF  deQtdeAFatur > 0 THEN
                    ASSIGN de-quantidade = (deQtdeAFatur * piProporcao ) / 100.
                IF  deQtdeEmFatur > 0 THEN
                    ASSIGN RowObjectAux.dec-1 = deQtdeEmFatur.
            END.
            ELSE 
                assign de-quantidade = (( RowObjectAux.quantidade - RowObjectAux.dec-1 ) * piProporcao ) / 100.
    
    
            IF  avail item 
            and not(item.fraciona)
            and natur-oper.tp-oper-terc <> 6 then
                assign de-quantidade = truncate(de-quantidade, 0 ).
             
            if  de-quantidade <= 0 then do:
                delete RowObjectAux.
                next.
            end.     
    
            run getValuesTerceiros ( piDataTrans,
                                     piProporcao,
                                     de-quantidade,
                                     output de-preco-total,
                                     output de-desconto ).
                                     
            /* O campo RowObjectAux.valor esta sendo utilizado para gravar o preco total */
            /* e o campo RowObjectAux.dec-2 para garvar o desconto do item.              */
        
            assign RowObjectAux.valor[1]   = de-preco-total
                   RowObjectAux.dec-2      = de-desconto
    
                   /* Para notas de reajuste de preco a quantidade e igual a 1 */
                   RowObjectAux.quantidade = if  natur-oper.tp-oper-terc <> 6
                                             then de-quantidade
                                             else 0.
                                             
        END. /* END FOR EACH saldo-terc */
    END.
    ELSE DO: /* Se NÇO usa m£ltiplas naturezas no recebimento... */

        FOR EACH saldo-terc 
            WHERE saldo-terc.cod-emitente = piCodEmitente
              AND saldo-terc.serie-docto  = piSerieDocto
              AND saldo-terc.nro-docto    = piNroDocto
              AND saldo-terc.nat-operacao = piNatOperacao NO-LOCK:
    
            create RowObjectAux.
            buffer-copy saldo-terc to RowObjectAux.
            assign RowObjectAux.r-rowid = rowid(saldo-terc)
                   de-quantidade  = 0.
    
            for first componente 
                fields ( cod-emitente nro-docto serie-docto 
                         nat-operacao it-codigo cod-refer 
                         sequencia preco-total[1] desconto[1] )
                of RowObjectAux no-lock.
            end.         
        
            run findItem ( input saldo-terc.it-codigo ).

            ASSIGN lFatConsigDevSimb = {cdp/cd0066.i2 saldo-terc.cod-estabel}. /* Valida obrigacoes fiscais. */
            
            /******** Inicio UPC Unimed Nordeste RS **********/
            IF c-nom-prog-dpc-mg97  <> "" OR 
               c-nom-prog-appc-mg97 <> "" OR
               c-nom-prog-upc-mg97  <> "" THEN DO:
                
                FOR EACH tt-epc 
                    WHERE tt-epc.cod-event = "devol-simb-consig-manual":U:
                    DELETE tt-epc.
                END.

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-manual":U
                       tt-epc.cod-parameter = "cod-emitente-retorno":U
                       tt-epc.val-parameter = STRING(piCodEmitente).
                
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-manual":U
                       tt-epc.cod-parameter = "nat-operacao-retorno":U
                       tt-epc.val-parameter = STRING(piNatOperRetorno).
                
                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-manual":U
                       tt-epc.cod-parameter = "rowid-saldo-terc":U
                       tt-epc.val-parameter = STRING(ROWID(saldo-terc)).

                CREATE tt-epc.
                ASSIGN tt-epc.cod-event     = "devol-simb-consig-manual":U
                       tt-epc.cod-parameter = "rowid-componente":U
                       tt-epc.val-parameter = STRING(ROWID(componente)).

                {include/i-epc201.i "devol-simb-consig-manual"}
            
                FOR FIRST tt-epc 
                    WHERE tt-epc.cod-event     = "devol-simb-consig-manual"
                    AND   tt-epc.cod-parameter = "altera-flag":
                    ASSIGN lFatConsigDevSimb = LOGICAL(tt-epc.val-parameter).
                END.
            END.
            /******* Fim UPC Unimed Nordeste RS *******/

            /*IF  {cdp/cd0066.i2 saldo-terc.cod-estabel}*/
            IF  lFatConsigDevSimb
            AND natur-oper.tp-oper-terc = 4 THEN DO:
                ASSIGN deQtdeEmFatur = 0
                       deQtdeAFatur  = 0.
                
                FOR EACH componente NO-LOCK
                    WHERE componente.cod-emitente = saldo-terc.cod-emitente
                      AND componente.nro-comp     = saldo-terc.nro-docto
                      AND componente.serie-comp   = saldo-terc.serie-docto
                      AND componente.nat-comp     = saldo-terc.nat-operacao
                      AND componente.seq-comp     = saldo-terc.sequencia
                      AND componente.it-codigo    = saldo-terc.it-codigo:
    
                    FIND FIRST bNaturOper NO-LOCK
                         WHERE bNaturOper.nat-operacao = componente.nat-operacao NO-ERROR.
                    IF  AVAIL bNaturOper THEN DO:
                        ASSIGN lMovtoDevSimbConsig = {cdp/cd0066.i1 bNaturOper componente}
                    END.
                    ELSE
                        ASSIGN lMovtoDevSimbConsig = NO.
                    
                    IF  lMovtoDevSimbConsig THEN DO:
                        ASSIGN deQtdeAFatur = deQtdeAFatur + 
                               &IF "{&mguni_version}" >= "2.08" &THEN
                                (componente.qtd-devol-simbol - componente.qtd-fatur-consig - componente.qtd-afatur-consig)
                               &ELSE
                                (DEC(SUBSTR(componente.char-1,40,14)) - DEC(SUBSTR(componente.char-1,68,14)) - DEC(SUBSTR(componente.char-1,54,14)))
                               &ENDIF .
    
                        ASSIGN deQtdeEmFatur = deQtdeEmFatur +
                               &IF "{&mguni_version}" >= "2.08" &THEN
                                componente.qtd-afatur-consig
                               &ELSE
                                DEC(SUBSTR(componente.char-1,54,14))
                               &ENDIF .
                    END.
                END.
                
                IF  deQtdeAFatur > 0 THEN
                    ASSIGN de-quantidade = (deQtdeAFatur * piProporcao ) / 100.
                IF  deQtdeEmFatur > 0 THEN
                    ASSIGN RowObjectAux.dec-1 = deQtdeEmFatur.
            END.
            ELSE 
                assign de-quantidade = (( RowObjectAux.quantidade - RowObjectAux.dec-1 ) * piProporcao ) / 100.
    
    
            IF  avail item 
            and not(item.fraciona)
            and natur-oper.tp-oper-terc <> 6 then
                assign de-quantidade = truncate(de-quantidade, 0 ).
             
            if  de-quantidade <= 0 then do:
                delete RowObjectAux.
                next.
            end.     
    
            run getValuesTerceiros ( piDataTrans,
                                     piProporcao,
                                     de-quantidade,
                                     output de-preco-total,
                                     output de-desconto ).
                                     
            /* O campo RowObjectAux.valor esta sendo utilizado para gravar o preco total */
            /* e o campo RowObjectAux.dec-2 para garvar o desconto do item.              */
        
            assign RowObjectAux.valor[1]   = de-preco-total
                   RowObjectAux.dec-2      = de-desconto
    
                   /* Para notas de reajuste de preco a quantidade e igual a 1 */
                   RowObjectAux.quantidade = if  natur-oper.tp-oper-terc <> 6
                                             then de-quantidade
                                             else 0.
                                             
        END. /* END FOR EACH saldo-terc */

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBatchRecordsOfVariosDocumentos DBOFunction 
PROCEDURE getBatchRecordsOfVariosDocumentos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input  param piCodEmitente    as int                                no-undo.
    def input  param piNatOperRetorno as char                               no-undo.
    def input  param piDataTrans      as date                               no-undo.    
    def input  param piProporcao      as dec                                no-undo.
    
    def input  param piSerieDocto-ini     as char                               no-undo.
    def input  param piNroDocto-ini       as char                               no-undo.
    def input  param piNatOperacao-ini    as char                               no-undo. 
    def input  param piSerieDocto-fim     as char                               no-undo.
    def input  param piNroDocto-fim       as char                               no-undo.
    def input  param piNatOperacao-fim    as char                               no-undo. 

    def output param table            for RowObjectAux. 

    def var de-quantidade             like componente.quantidade            no-undo.
    def var de-preco-total            like componente.preco-total extent 0  no-undo.
    def var de-desconto               like componente.desconto    extent 0  no-undo.

    /* Limpa temp-table RowObjectAux */
    for each RowObjectAux :
        delete RowObjectAux.
    end.        

    run findNaturOper ( piNatOperRetorno ).

    for each saldo-terc 
        where saldo-terc.cod-emitente = piCodEmitente
          and saldo-terc.serie-docto  >= piSerieDocto-ini
          and saldo-terc.serie-docto  <= piSerieDocto-fim
          and saldo-terc.nro-docto    >= piNroDocto-ini
          and saldo-terc.nro-docto    <= piNroDocto-fim
          and saldo-terc.nat-operacao >= piNatOperacao-ini
          and saldo-terc.nat-operacao <= piNatOperacao-fim
          and (saldo-terc.quantidade - saldo-terc.dec-1) > 0 no-lock:

        create RowObjectAux.
        buffer-copy saldo-terc to RowObjectAux.
        assign RowObjectAux.r-rowid = rowid(saldo-terc).

        for first componente 
            fields ( cod-emitente nro-docto serie-docto 
                     nat-operacao it-codigo cod-refer 
                     sequencia preco-total[1] desconto[1] )
            of RowObjectAux no-lock.
        end.         
    
        run findItem ( input saldo-terc.it-codigo ).
        
        assign de-quantidade = (( RowObjectAux.quantidade - RowObjectAux.dec-1 ) * piProporcao ) / 100.
        
        if  avail item 
        and not(item.fraciona)
        and natur-oper.tp-oper-terc <> 6 then
            assign de-quantidade = truncate(de-quantidade, 0 ).
         
        if  de-quantidade <= 0 then do:
            delete RowObjectAux.
            next.
        end.     
        
        run getValuesTerceiros ( piDataTrans,
                                 piProporcao,
                                 de-quantidade,
                                 output de-preco-total,
                                 output de-desconto ).
                                 
        /* O campo RowObjectAux.valor esta sendo utilizado para gravar o preco total */
        /* e o campo RowObjectAux.dec-2 para garvar o desconto do item.              */
    
        assign RowObjectAux.valor[1]   = de-preco-total
               RowObjectAux.dec-2      = de-desconto

               /* Para notas de reajuste de preco a quantidade e igual a 1 */
               RowObjectAux.quantidade = if  natur-oper.tp-oper-terc <> 6
                                         then de-quantidade
                                         else 0.
                                         
    end.                   
    
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescriptionFields DBOFunction 
PROCEDURE getDescriptionFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    CASE pFieldName:
        WHEN "emitente.nome-abrev":U    THEN ASSIGN pFieldValue = if  avail emitente then 
                                                                      emitente.nome-abrev
                                                                  else "".
        WHEN "natur-oper.denominacao":U THEN ASSIGN pFieldValue = if  avail natur-oper then 
                                                                      natur-oper.denominacao
                                                                  else "".
        WHEN "item.desc-item":U         THEN ASSIGN pFieldValue = if  avail item then 
                                                                      item.desc-item
                                                                  else "".
        WHEN "item.un":U                THEN ASSIGN pFieldValue = if  avail item then 
                                                                      item.un
                                                                  else "".
                                                                  
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.    
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTItemEstrut DBOFunction 
PROCEDURE getTTItemEstrut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for tt-item-estrut.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTTItemSaldoTercAux DBOFunction 
PROCEDURE getTTItemSaldoTercAux :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for tt-item-saldo-terc-aux.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValuesTerceiros DBOFunction 
PROCEDURE getValuesTerceiros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    def input  param piDataTrans      like componente.dt-retorno            no-undo.
    def input  param piProporcao      as dec                                no-undo.
    def input  param piQtdeItem       like componente.quantidade            no-undo.
    def output param piPrecoTotal     like componente.preco-total[1]        no-undo.
    def output param piDesconto       like componente.desconto[1]           no-undo.

    def buffer b-componente           for componente.

    def var de-valor-tot              like componente.preco-total extent 0  no-undo.
    def var de-desc-tot               like componente.desconto    extent 0  no-undo.
    
    for first componente 
        fields ( cod-emitente nro-docto serie-docto 
                 nat-operacao it-codigo cod-refer 
                 sequencia preco-total[1] desconto[1] )
        of saldo-terc no-lock.
    end.  

    assign de-valor-tot  = componente.preco-total[1]
           de-desc-tot   = componente.desconto[1].
    
    IF componente.nat-operacao BEGINS "5" OR
       componente.nat-operacao BEGINS "6" OR
       componente.nat-operacao BEGINS "7" THEN DO:

        FOR FIRST nota-fiscal
            WHERE nota-fiscal.cod-estabel   = saldo-terc.cod-estabel
             AND  nota-fiscal.serie         = componente.serie-docto
             AND  nota-fiscal.nr-nota-fis   = componente.nro-docto
             AND  nota-fiscal.cod-emitente  = componente.cod-emitente NO-LOCK:

            FOR FIRST it-nota-fisc 
                WHERE it-nota-fisc.cod-estabel  = saldo-terc.cod-estabel
                  AND it-nota-fisc.serie        = componente.serie-docto
                  AND it-nota-fisc.nr-nota-fis  = componente.nro-docto 
                  AND it-nota-fisc.nr-seq-fat   = componente.sequencia
                  AND it-nota-fisc.it-codigo    = componente.it-codigo NO-LOCK:
                
                IF it-nota-fisc.per-des-icms > 0 OR /*desconto ICMS*/ 
                   it-nota-fisc.dec-1 > 0        OR /*ICMS ZFM*/ 
                   DEC(SUBSTRING(it-nota-fisc.char-1,128,16)) > 0 OR       /*PIS ZFM*/
                   DEC(SUBSTRING(it-nota-fisc.char-1,145,16)) > 0 THEN DO: /*COFINS ZFM*/

                    ASSIGN de-valor-tot = it-nota-fisc.vl-merc-ori
                           de-desc-tot = (it-nota-fisc.vl-merc-ori - it-nota-fisc.vl-merc-liq).

                    IF  it-nota-fisc.per-des-icms > 0 THEN DO:
                        FOR FIRST ext-it-nota-fisc
                            WHERE ext-it-nota-fisc.cod-estabel = it-nota-fisc.cod-estabel
                            AND   ext-it-nota-fisc.serie       = it-nota-fisc.serie
                            AND   ext-it-nota-fisc.nr-nota-fis = it-nota-fisc.nr-nota-fis
                            AND   ext-it-nota-fisc.nr-seq-fat  = it-nota-fisc.nr-seq-fat
                            AND   ext-it-nota-fisc.it-codigo   = it-nota-fisc.it-codigo
                            AND   ext-it-nota-fisc.cod-param   = "Val-Desc-ICMS" NO-LOCK: END.
                        IF AVAIL ext-it-nota-fisc THEN
                            ASSIGN de-desc-tot = de-desc-tot - ext-it-nota-fisc.val-livre-1.
                        ELSE
                           IF  it-nota-fisc.val-pct-desconto-total >= it-nota-fisc.per-des-icms THEN DO:
                               IF it-nota-fisc.dec-1 > 0        OR /*ICMS ZFM*/ 
                                  DEC(SUBSTRING(it-nota-fisc.char-1,128,16)) > 0 OR       /*PIS ZFM*/
                                  DEC(SUBSTRING(it-nota-fisc.char-1,145,16)) > 0 THEN /*COFINS ZFM*/
                                   ASSIGN de-desc-tot = de-desc-tot - (it-nota-fisc.vl-merc-ori * (it-nota-fisc.per-des-icms / 100)).
                               ELSE
                                   ASSIGN de-desc-tot = (it-nota-fisc.vl-merc-ori - (it-nota-fisc.vl-merc-liq / ((100 - it-nota-fisc.per-des-icms) / 100))).
                           END.
                    END.

                    IF de-desc-tot < 0 THEN
                        ASSIGN de-desc-tot = 0.
                END.
            END.
        END.
    END. /*IF componente.nat-operacao*/

    for each b-componente
        fields ( quantidade dt-retorno componente
                 preco-total[1] desconto[1] )
        where b-componente.cod-emitente = componente.cod-emitente 
          and b-componente.nro-comp     = componente.nro-docto    
          and b-componente.serie-comp   = componente.serie-docto  
          and b-componente.nat-comp     = componente.nat-operacao 
          and b-componente.it-codigo    = componente.it-codigo    
          and b-componente.cod-refer    = componente.cod-refer   
          and b-componente.seq-comp     = componente.sequencia   no-lock:

        /* Considera Nota de Reajuste de Preco somente ate Data da Nota */
        if  b-componente.quantidade <> 0
        or  b-componente.dt-retorno <= piDataTrans then do:

            if  b-componente.componente = 1 then 
                assign de-valor-tot = de-valor-tot + b-componente.preco-total[1]
                       de-desc-tot  = de-desc-tot  + b-componente.desconto[1].
            else 
                assign de-valor-tot = de-valor-tot - b-componente.preco-total[1]
                       de-desc-tot  = de-desc-tot  - b-componente.desconto[1].
        end.            
    end.

    if  natur-oper.tp-oper-terc <> 6 then  /* Diferente de Reajuste Preco */
        assign piPrecoTotal = ROUND(( de-valor-tot / saldo-terc.quantidade ), 10) * piQtdeItem
               piDesconto   = ROUND(( de-desc-tot  / saldo-terc.quantidade ), 10) * piQtdeItem.
    else
        assign piPrecoTotal = (de-valor-tot * piProporcao) / 100
               piDesconto   = (de-desc-tot  * piProporcao) / 100.
    
    if  piDesconto < 0
    or  piDesconto = ? then
        assign piDesconto = 0.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOFunction 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} 
      for each {&tableName} no-lock INDEXED-REPOSITION.
       
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecord DBOFunction 
PROCEDURE repositionRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid  AS ROWID NO-UNDO.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectSaldoTercbyFIFO DBOFunction 
PROCEDURE selectSaldoTercbyFIFO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    def input param piHandleBOin090    as handle                            no-undo.        
    def input param piHandleBOin176    as handle                            no-undo.
    def input param piCodEmitente      like saldo-terc.cod-emitente         no-undo.
    def input param piCodEstabel       like saldo-terc.cod-estabel          no-undo.
    def input param piNatOperacao      like saldo-terc.nat-operacao         no-undo.
    def input param piTipoOperacao     as   integer                         no-undo.
    def input param piDataTrans        like saldo-terc.dt-retorno           no-undo.
    
    def var de-quantidade              like saldo-terc.quantidade           no-undo.
    def var de-qtd-saldo               like saldo-terc.quantidade           no-undo.
    def var de-tot-alocado             like saldo-terc.quantidade           no-undo.
    def var de-preco-total             like componente.preco-total extent 0 no-undo.
    def var de-valor-calc              like componente.preco-total extent 0 no-undo.
    def var de-valor-max               like componente.preco-total extent 0 no-undo.
    def var de-valor-min               like componente.preco-total extent 0 no-undo.
    def var de-valor-inf               like componente.preco-total extent 0 no-undo.
    def var h-acomp                    as handle                            no-undo.
    DEF VAR c-item-pai                 LIKE item-doc-est.item-pai           NO-UNDO.
    DEF VAR c-cod-roteiro              LIKE item-doc-est.cod-roteiro        NO-UNDO.
    DEF VAR i-op-codigo                LIKE item-doc-est.op-codigo          NO-UNDO.
    DEF VAR c-nro-docto                LIKE item-doc-est.nro-docto          NO-UNDO.

    /* Deve ser executado anteriormente a procedure para atualizar o tipo de saldo em poder 
       de terceiros - setTipoSalTerc */

    run setTipoSalTerc ( input piNatOperacao,
                         input piTipoOperacao ).
                         
    if  return-value <> "OK":U then 
        RETURN "NOK":U.
        
    run utp/ut-acomp.p persistent set h-acomp.
    run pi-inicializar in h-acomp ("Calculando Nota Retorno").
    run pi-desabilita-cancela in h-acomp.
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Efetuando_Fifo_do_Saldo_em_Terceiros" *}
    run pi-acompanhar in h-acomp (RETURN-VALUE).
    
    for each tt-item-saldo-terc:
        delete tt-item-saldo-terc.
    end.

    FOR EACH tt-item-saldo-terc-aux:
        DELETE tt-item-saldo-terc-aux.
    END.

    for each tt-item-estrut:
        assign de-quantidade             = tt-item-estrut.quantidade
               de-preco-total            = tt-item-estrut.preco-total
               tt-item-estrut.preco-unit = tt-item-estrut.preco-total / tt-item-estrut.quantidade.
               
        if  natur-oper.tp-oper-terc = 6 then
            assign de-quantidade = 1.
        for each saldo-terc use-index estab-fornec
            where saldo-terc.it-codigo     = tt-item-estrut.it-codigo
              AND saldo-terc.cod-refer     = tt-item-estrut.cod-refer
              and saldo-terc.cod-emitente  = piCodEmitente
              and saldo-terc.cod-estabel   = piCodEstabel
              and saldo-terc.tipo-sal-terc = i-tipo-sal-terc
              and saldo-terc.quantidade    > 0 
              and (   saldo-terc.nr-ord-produ = tt-item-estrut.nr-ord-prod
                   or saldo-terc.nr-ord-produ = 0 ) exclusive-lock
            by saldo-terc.dt-retorno :             

            /* --- its35061 --- */
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062" &THEN 
               IF i-pais-impto-usuario <> 1 AND saldo-terc.log-entreg-fut THEN
                   NEXT.
            &ENDIF

            /* O CAMPO DEC-1 ESTA SENDO UTILIZADO PARA ARMAZENAR O SALDO 
                ALOCADO, OU SEJA, QUE JA ESTEJA SENDO UTILIZADO NA DIGITACAO 
                DE OUTRA NOTA FISCAL 
            */
        
            assign de-qtd-saldo = saldo-terc.quantidade - saldo-terc.dec-1.

            if  de-qtd-saldo <= 0 then 
                next.

            /* A LOGICA A SEGUIR ESTA SENDO UTILIZADA PARA VERIFICAR SE O SALDO 
                ESTA ALOCADO NA PROPRIA NOTA, OU SEJA, JA ESTA SENDO UTILIZADO
                NA NOTA FISCAL QUE ESTA SENDO DIGITADA
            */
           /* Silvia - retirado pois est  fazendo alocacao e antes de gerar o item
           desaloca*/
           /*if  can-find (tt-item-saldo-terc-aux
                    where tt-item-saldo-terc-aux.rw-saldo-terc = rowid(saldo-terc)) then do:

                assign de-tot-alocado = 0.

                for each tt-item-saldo-terc-aux
                   where tt-item-saldo-terc-aux.rw-saldo-terc = rowid(saldo-terc):
                    assign de-tot-alocado = de-tot-alocado + tt-item-saldo-terc-aux.quantidade.
                end.
                if  de-qtd-saldo <= de-tot-alocado then 
                    next.

                assign de-qtd-saldo = if (de-qtd-saldo - de-tot-alocado) > de-quantidade then
                                          de-quantidade
                                      else 
                                          (de-qtd-saldo - de-tot-alocado).
            end.*/
            
            assign de-qtd-saldo = if  de-qtd-saldo > de-quantidade then 
                                      de-quantidade
                                  else 
                                      de-qtd-saldo.
            

            /* Verifica Variacao de Valor no Saldo Terceiros */
            if  avail natur-oper
            and de-preco-total <> 0 then do:
            
                for first componente 
                    fields ( preco-total quantidade ) 
                      of  saldo-terc no-lock : end.
                      
                assign de-valor-calc = ( componente.preco-total[1] / componente.quantidade ) 
                                     * de-qtd-saldo
                       de-valor-inf  = tt-item-estrut.preco-unit * de-qtd-saldo.
                       
                if  int(substr(natur-oper.char-2,36,5)) = 1 
                and natur-oper.dec-1 <> 0 then 
                    assign de-valor-max = de-valor-calc
                                        + (de-valor-calc * natur-oper.dec-1 / 100)
                           de-valor-min = de-valor-calc
                                        - (de-valor-calc * natur-oper.dec-1 / 100).
                else 
                    assign de-valor-max = de-valor-calc
                           de-valor-min = de-valor-calc.
                
                if  de-valor-inf > de-valor-max             /* desconsidera saldo-terc com valor fora da */
                or  de-valor-inf < de-valor-min then        /* varia‡Æo permitida */
                    next.

            end. /* controle valor */

            create tt-item-saldo-terc-aux.
            assign tt-item-saldo-terc-aux.rw-saldo-terc = rowid(saldo-terc)
                   tt-item-saldo-terc-aux.quantidade    = de-qtd-saldo
                   tt-item-saldo-terc-aux.preco-total   = tt-item-estrut.preco-unit * de-qtd-saldo
                   tt-item-saldo-terc-aux.cod-depos     = tt-item-estrut.cod-depos
                   tt-item-saldo-terc-aux.nr-ord-prod   = tt-item-estrut.nr-ord-prod.
            
            FIND reservas WHERE
                 ROWID(reservas) = tt-item-estrut.rw-reservas NO-LOCK NO-ERROR.

            IF AVAIL reservas THEN DO:
                ASSIGN tt-item-saldo-terc-aux.item-pai         = reservas.item-pai  
                       tt-item-saldo-terc-aux.cod-roteiro      = reservas.cod-roteiro
                       tt-item-saldo-terc-aux.op-codigo        = reservas.op-codigo.
            END.

            /* Silvia - aloca */
            ASSIGN saldo-terc.dec-1 = saldo-terc.dec-1 + tt-item-saldo-terc-aux.quantidade.

            /*******
            FOR EACH  reservas
                where reservas.nr-ord-prod = saldo-terc.nr-ord-prod and
                      reservas.it-codigo   = tt-item-estrut.it-codigo NO-LOCK:

                  FIND tt-item-saldo-terc-aux where
                       tt-item-saldo-terc-aux.rw-saldo-terc  = ROWID(saldo-terc)    AND
                       tt-item-saldo-terc-aux.rw-reserva     = ROWID(reservas)      AND
                       tt-item-saldo-terc-aux.item-pai       = reservas.item-pai    AND
                       tt-item-saldo-terc-aux.cod-roteiro    = reservas.cod-roteiro AND
                       tt-item-saldo-terc-aux.op-codigo      = reservas.op-codigo   NO-ERROR.

                  IF NOT AVAIL tt-item-saldo-terc-aux THEN DO:
                      CREATE tt-item-saldo-terc-aux.
                      ASSIGN tt-item-saldo-terc-aux.rw-saldo-terc  = ROWID(saldo-terc)  
                             tt-item-saldo-terc-aux.rw-reserva     = ROWID(reservas)    
                             tt-item-saldo-terc-aux.item-pai       = reservas.item-pai  
                             tt-item-saldo-terc-aux.cod-roteiro    = reservas.cod-roteiro
                             tt-item-saldo-terc-aux.op-codigo      = reservas.op-codigo.

                  END.
            END.
            ***********/
            /* Retorna os saldos de preco e desconto do saldo-terc quando */
            /* o item nao possui preco total definido.                    */

            if  tt-item-saldo-terc-aux.preco-total = 0 then
                run getValuesTerceiros ( piDataTrans,
                                         0,              /* Proporcao para Reajuste de Preco */
                                         de-qtd-saldo,
                                         output tt-item-saldo-terc-aux.preco-total,
                                         output tt-item-saldo-terc-aux.desconto ).
            else do:
            
                assign de-preco-total = de-preco-total - tt-item-saldo-terc-aux.preco-total.
            
                /* Acerto de Residuos */
                if  de-quantidade = 0 
                and de-preco-total <> 0 then 
                    assign tt-item-saldo-terc-aux.preco-total = tt-item-saldo-terc-aux.preco-total + de-preco-total.
            
            end.
            
            assign de-quantidade = de-quantidade - tt-item-saldo-terc-aux.quantidade.
            
            if  de-quantidade = 0 then 
                leave.
        end.            

        /* Inicio chamada epc grendene */
        for each tt-epc where tt-epc.cod-event = "item-equivalent":U:
            delete tt-epc.
        end.

        create tt-epc.
        assign tt-epc.cod-event     = "item-equivalent":U
               tt-epc.cod-parameter = "handle-tt":U
               tt-epc.val-parameter = string(temp-table tt-item-saldo-terc-aux:handle) + "*" +
                                      tt-item-estrut.it-codigo + "*" +
                                      string(piHandleBOin090) + "*" +
                                      tt-item-estrut.cod-depos + "*" +
                                      string(i-tipo-sal-terc) + "*" +
                                      string(tt-item-estrut.nr-ord-prod) + "*" + 
                                      string(tt-item-estrut.quantidade) + "*" + 
                                      string(de-quantidade) + "*" + 
                                      string(tt-item-estrut.preco-total).

        /* Inclusao ponto UPC Villanova - chamado TPABKS. */
        create tt-epc.
        assign tt-epc.cod-event     = "item-equivalent":U
               tt-epc.cod-parameter = "handle-dbo":U
               tt-epc.val-parameter = string(this-procedure).

        {include/i-epc201.i "item-equivalent"}

        find first tt-epc
             where tt-epc.cod-event     = "item-equivalent":U
               and tt-epc.cod-parameter = "return" no-error.
        if avail tt-epc then
            assign de-quantidade = dec(tt-epc.val-parameter).
        /* FIM chamada epc grendene */
    
        if  de-quantidade <> 0 then do:
            {method/svc/errors/inserr.i
                                &ErrorNumber="19520"
                                &ErrorType="EMS"
                                &ErrorSubType="WARNING"
                                &ErrorParameters="string(tt-item-estrut.it-codigo) + '~~~~' + string(tt-item-estrut.quantidade) + '~~~~' + string(tt-item-estrut.quantidade - de-quantidade)"}
        end.
    end.
    delete procedure h-acomp.
    assign h-acomp = ?.

    /* Cria os itens da nota de retorno com base na remessa */
    

    /* Silvia - desaloca */
    FOR EACH tt-item-saldo-terc-aux:

         FIND FIRST saldo-terc
             WHERE ROWID(saldo-terc) = tt-item-saldo-terc-aux.rw-saldo-terc  EXCLUSIVE-LOCK
             NO-ERROR.

         IF  AVAIL saldo-terc THEN
             ASSIGN saldo-terc.dec-1 = saldo-terc.dec-1 -  tt-item-saldo-terc-aux.quantidade. 
    END.

    FIND FIRST rowErrors 
         WHERE rowErrors.errorSubType <> "Warning":U NO-ERROR.
    IF NOT AVAIL rowErrors THEN DO:
        IF piHandleBOin176:GET-SIGNATURE("createItemOfComponenteEvoluido":U) <> "" THEN DO:
            run createItemOfComponenteEvoluido in piHandleBOin176 ( input piHandleBOin090 ,
                                                                     input table tt-item-saldo-terc-aux ).
        END.
        ELSE DO:
            FOR EACH tt-item-saldo-terc-aux:
                create tt-item-saldo-terc.             
                assign tt-item-saldo-terc.rw-saldo-terc = tt-item-saldo-terc-aux.rw-saldo-terc
                       tt-item-saldo-terc.quantidade    = tt-item-saldo-terc-aux.quantidade
                       tt-item-saldo-terc.preco-total   = tt-item-saldo-terc-aux.preco-total
                       tt-item-saldo-terc.cod-depos     = tt-item-saldo-terc-aux.cod-depos
                       tt-item-saldo-terc.nr-ord-prod   = tt-item-saldo-terc-aux.nr-ord-prod.
            END.

            if  can-find(first tt-item-saldo-terc) then 
                run createItemOfComponente in piHandleBOin176 ( input piHandleBOin090 ,
                                                                input table tt-item-saldo-terc ).
        END.
        if  return-value = "NOK":U then do:
            run getRowErrors in piHandleBOin176 ( output table RowErrorsTemp ).
        END.

        FOR EACH rowErrorsTemp:
            FIND FIRST rowErrors
                 WHERE rowErrors.errorNumber = rowErrorsTemp.errorNumber NO-ERROR.
            IF NOT AVAIL rowErrors THEN DO:
                CREATE rowErrors.
                BUFFER-COPY rowErrorsTemp TO rowErrors NO-ERROR.
            END.
        END.
    END.
    ELSE DO:
        run getRowErrors in piHandleBOin176 ( output table RowErrorsTemp ).

        FOR EACH rowErrorsTemp:
            FIND FIRST rowErrors
                 WHERE rowErrors.errorNumber = rowErrorsTemp.errorNumber NO-ERROR.
            IF NOT AVAIL rowErrors THEN DO:
                CREATE rowErrors.
                BUFFER-COPY rowErrorsTemp TO rowErrors NO-ERROR.
            END.
        END.
    END.

    FIND FIRST rowErrors NO-ERROR.
    IF AVAIL rowErrors THEN
        RETURN "NOK":U.

    return "OK":U.            
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTipoSalTerc DBOFunction 
PROCEDURE setTipoSalTerc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
        Atualiza Vari˜veis de Controle para Determinar se ý Remessa ou Retorno
        
        * Tipos Opera‡Æo Terceiros da Natureza de Opera‡Æo ( natur-oper.tp-oper-terc )
        1. Remessa Beneficiamento
        2. Retorno Beneficiamento
        3. Remessa Consigna‡Æo
        4. Faturamento Consigna‡Æo
        5. Devolu‡Æo Consigna‡Æo
        6. Reajuste de Pre¯o
        
        * Tipos de Notas do Recebimento Fðsico ( doc-fisico.tipo-nota )
        1. Compra
        2. Devolu‡Æo
        3. Tranfer¬ncia
        4. Entrada Beneficiamento
        5. Retorno Beneficiamento
        6. Entrada Consigna‡Æo
        7. Faturamento Consigna‡Æo
        8. Devolu‡Æo Consigna‡Æo
        9. Nota Rateio
------------------------------------------------------------------------------*/

    def input param piNatOperacao   like componente.nat-operacao no-undo.
    def input param piTipoOperacao  as   integer                 no-undo.
        
    def var i-terc-aux              as   integer                 no-undo.
    def var l-transf-aux            as   logical                 no-undo.
    
    if  piNatOperacao <> ? then do:
        
        run findNaturOper ( input piNatOperacao ).
    
        if  not avail natur-oper then 
            RETURN "NOK":U.
                
        if  natur-oper.tp-oper-terc = 1
        or  natur-oper.tp-oper-terc = 3 
        or  natur-oper.tp-oper-terc = 8 
        or  natur-oper.tp-oper-terc = 10 then 
            assign l-remessa = yes
                   l-retorno = no.
        else 
            assign l-remessa = no
                   l-retorno = yes.    
        
        /* Atualiza I-TIPO-SAL-TERC */
        {inbo/boin404.i2 natur-oper.tipo
                         natur-oper.tp-oper-terc
                         natur-oper.transf }

    end.
    else do:    /* Recebimento Fðsico */
    
        assign l-remessa = ( piTipoOperacao = 4
                          or piTipoOperacao = 6 )
               l-retorno = ( piTipoOperacao = 5
                          or piTipoOperacao = 7
                          or piTipoOperacao = 8 ).          
    
        assign i-terc-aux = if  piTipoOperacao = 4 then     /* Remessa Benef */
                                1
                            else if  piTipoOperacao = 5 then     /* Retorno Benef */
                                2
                            else if  piTipoOperacao = 6 then     /* Remessa Consig */
                                3
                            else if  piTipoOperacao = 7 then     /* Faturamento Consig */
                                4
                            else if  piTipoOperacao = 8 then     /* Devolu‡Æo Consig */
                                5
                            else 0
               l-transf-aux = ( piTipoOperacao = 3 ).                             
                            
        /* Atualiza I-TIPO-SAL-TERC */
        {inbo/boin404.i2 1  
                         i-terc-aux
                         l-transf-aux } 
                         /* Transfer¬ncia */                            
    end.
      
    RETURN "OK":U.
                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTipoSalTercTipoOperac DBOFunction 
PROCEDURE setTipoSalTercTipoOperac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:  

------------------------------------------------------------------------------*/

    DEF INPUT PARAM pi-tipo-operac  LIKE item-doc-orig-nfe.int-2 NO-UNDO.
               
    ASSIGN l-remessa = no
           l-retorno = yes.    
		   
    /* Atualiza I-TIPO-SAL-TERC */
    {inbo/boin404.i3 pi-tipo-operac}

   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTItemEstrut DBOFunction 
PROCEDURE setTTItemEstrut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param table for tt-item-estrut.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
