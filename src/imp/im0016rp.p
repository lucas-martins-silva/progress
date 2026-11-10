/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0016RP 2.00.00.019 } /*** "010019" 20/08/2026 16:06:09 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0016rp MIM}
&ENDIF

{include/i_fncrowid.i}
{include/i_fnctrad.i}

{cdp/cdcfgmat.i} /* Definiá∆o de prÇ-processadores */
{cdp/cdcfgdis.i}

/* Vari†veis Globais */
{utp/ut-glob.i}

{method/dbotterr.i}

define temp-table tt-param no-undo
        field destino             as integer
        field arquivo             as char format "x(35)"
        field usuario             as char format "x(12)"
        field data-exec           as date
        field hora-exec           as integer
        field c-ini-item          as char
        field c-fim-item          as char
        field c-ini-estabel       as char
        field c-fim-estabel       as char
        field c-ini-comprador     as char
        field c-fim-comprador     as char
        field i-ini-ordem         as int
        field i-fim-ordem         as int
        field d-ini-dt-emissao    as date
        field d-fim-dt-emissao    as date
        field c-ini-familia       as char
        field c-fim-familia       as char
        field i-ini-fornec        as int
        field i-fim-fornec        as int
        field c-ini-nome-abrev    as char
        field c-fim-nome-abrev    as char
        field i-ini-contr-compras as int
        field i-fim-contr-compras as int
        field i-ini-proc-compras  as int
        field i-fim-proc-compras  as int
        field i-gera              as int  /* 1 - Gera Despesas | 2 - Gera Somente Dados Obrigat¢rios */
        field l-recalcula         as log.

define temp-table tt-raw-digita
        field raw-digita    as raw.

/* recebimento de parÉmetros */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

{cxbo/bocx085.i tt-cotacao-item-cex}
{include/boerrtab.i} /* tt-bo-erro */

define temp-table tt-relatorio no-undo
    field numero-ordem    like cotacao-item-cex.numero-ordem
    field it-codigo       like cotacao-item-cex.it-codigo
    field desc-item       as char
    field qtde            like prazo-compra.quantidade
    &if defined(bf-mat-comex) &then
    &else
        field qtde-fornec     like ordem-compra.qt-solic
    &endif
    field moeda           like cotacao-item-cex.mo-codigo
    field vl-pre-unit     like cotacao-item.preco-unit
    field vl-pre-unit-for like cotacao-item.pre-unit-for
    field incoterm        like cotacao-item-cex.cod-incoterm
    field pto-contr-base  as char
    field aprovacao       as logical format "Sim/N∆o"
    field cod-itiner      like cotacao-item-cex.cod-itiner
    field fornec-desp     like cotacao-item-cex.cod-emitente-desp
    field nome-abrev      as char
    field pto-contr       like cotacao-item-cex.cod-pto-contr
    field cod-desp        like cotacao-item-cex.cod-desp
    field desc-desp       as char
    field cond-pag        like cotacao-item-cex.cod-cond-pag
    field vl-des          like cotacao-item-cex.val-desp
    field moeda-desp      like cotacao-item-cex.mo-codigo
    field nr-tab-desp     like cotacao-item-cex.nr-tab
    field r-rowid         as rowid
    index ch-codigo numero-ordem cod-itiner fornec-desp.

define temp-table tt-erros no-undo
    field numero-ordem   like cotacao-item-cex.numero-ordem
    field cod-erro       as int
    field desc-erro      as char format "x(80)"
    FIELD c-help         AS CHAR FORMAT "x(80)"
    index ch-codigo numero-ordem.

&if defined(bf-mat-comex) &then  /* Magnus - utilizada no rec†lculo compra */
    def new shared temp-table t-aprov NO-UNDO
        field cod-comprado  like aprov-comp.cod-comprado
        field cod-aprovador like aprov-comp.cod-aprovador
        field lim-aprovacao like aprov-comp.lim-aprovacao
        field atualiza      as logical
        index aprovador is primary cod-aprovador ascending.
&else
&endif


/* include padr∆o para vari†veis de relat¢rio */
{include/i-rpvar.i}


/* definiá∆o de vari†veis  */
def var h-acomp           as handle  no-undo.
def var c-traduz          as char    no-undo.
def var c-desc-gera       as char    no-undo.
def var h-bocx085         as handle  no-undo.
def var c-desc-itiner     as char    no-undo.
def var de-qtd-tot        like prazo-compra.quantidade no-undo.
def var de-qtd-tot-forn   like prazo-compra.qtd-do-forn no-undo.
def var de-val-despesas   like cotacao-item.preco-unit no-undo.
def var de-val-tot        as dec   no-undo.
def var l-despesas        as log   no-undo.
DEF VAR i-seq-erro        AS INT   NO-UNDO.

&if "{&bf_mat_versao_ems}":U >= "2.062":U &then
define variable i-cod-fabricante as integer format ">>>>>>>>9":U no-undo.
define variable i-cdn-pais-orig  as integer format ">>,>>9":U    no-undo.
define variable i-regime-import  as integer format ">9":U        no-undo.
define variable de-aliq-ii       as decimal format ">>9.9999":U  no-undo.
define variable de-aliq-ipi      as decimal format ">>9.99":U    no-undo.
define variable h-boin082i       as handle                       no-undo.
def var l-preco-bruto            as logical                      no-undo.
&endif

/* frame-tabela-ordem */
def var i-ordem          as int  format "zzzzz9,99"            label "Ordem"          no-undo.
def var c-item           as char format "x(15)"                label "Item"           no-undo.
def var c-desc-item      as char format "x(15)"                label "Descriá∆o"      no-undo.
def var d-qtde-for       as dec  format "zzzzz,zz9.9999"       label "Qtde Fornec"    no-undo.
def var d-qtde           as dec  format "zzzzz,zz9.9999"       label "Nossa Qtde"     no-undo.
def var i-moeda          as int  format "z9"                   label "Mo"             no-undo.
def var d-prc-unit       as dec  format "zzzzz,zzz,zz9.99999"  label "Preáo Unit†rio" no-undo.
def var d-prc-unit-for   as dec  format "zzzzz,zzz,zz9.99999"  label "Preáo Fornecedor" no-undo.
def var c-incoterm       as char format "x(3)"                 label "Inc"            no-undo.
def var i-pto-contr-base as int  format "zz,zz9"               label "Pto Contr"      no-undo.
def var l-aprovada       as log  format "Sim/N∆o"              label "Apr"            no-undo.

/* frame-tabela-itiner */
def var i-fornec-desp    as int  format "zzzzzzzz9"            label "Forn Desp"      no-undo.
def var c-nome-abrev     as char format "x(12)"                label "Nome Abreviado" no-undo.
def var i-pto-contr      as int  format "zz,zz9"               label "Pto Contr"      no-undo.
def var i-despesa        as int  format "zz,zz9"               label "Despesa"        no-undo.
def var c-desc-desp      as char format "x(30)"                label "Descriá∆o"      no-undo.
def var i-cond-pag       as int  format "zz9"                  label "Cond Pagto"     no-undo.
def var d-val-desp       as dec  format "zzzzz,zzz,zz9.99999"  label "Valor Despesa"  no-undo.
def var i-moeda-desp     as int  format "z9"                   label "Mo Desp"        no-undo.
def var c-nr-tab         as char format "x(10)"                label "Tab Preáo"      no-undo.

DEF BUFFER b-ordem-compra FOR ordem-compra.
DEF BUFFER b-cotacao-item FOR cotacao-item.

/* definiá∆o de frames do relat¢rio */
form i-ordem
     c-item
     c-desc-item
     d-qtde-for
     d-qtde
     i-moeda
     d-prc-unit
     d-prc-unit-for
     c-incoterm
     i-pto-contr-base
     l-aprovada
    with down no-box width 138 stream-io frame f-tabela-ordem.

form i-fornec-desp
     c-nome-abrev
     i-pto-contr
     i-despesa
     c-desc-desp
     i-cond-pag
     d-val-desp
     i-moeda-desp
     c-nr-tab
    with down no-box width 138 stream-io frame f-tabela-itiner.

form
    tt-erros.cod-erro AT 5 " - "
    tt-erros.desc-erro AT 20
    tt-erros.c-help AT 4
    with down no-box no-label width 138 stream-io frame f-erros.


/* include padr∆o para output de relat¢rios */
/*{include/i-rpout.i}*/
{cdp/cd-rpout.i}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
run utp/ut-trfrrp.p (input frame f-erros:handle).
run utp/ut-trfrrp.p (input frame f-tabela-itiner:handle).
run utp/ut-trfrrp.p (input frame f-tabela-ordem:handle).
{include/i-rpcab.i}

/* bloco principal do programa */
for first empresa fields (ep-codigo razao-social) where empresa.ep-codigo = i-ep-codigo-usuario no-lock:
    assign c-empresa = empresa.razao-social.
end.

assign c-programa 	  = "IM0016RP"
	   c-versao	      = "2.00"
	   c-revisao	  = ".00.000"
	   c-sistema	  = "MIM"
	   c-titulo-relat = "Geraá∆o Autom†tica Despesas Importaá∆o".

view frame f-cabec.
view frame f-rodape.

find first param-compra no-lock no-error.

run utp/ut-acomp.p persistent set h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Preparaá∆o dados para Geraá∆o Despesas").
RUN pi-seta-titulo IN h-acomp (INPUT "Preparaá∆o dados para Geraá∆o Despesas").
/* Inicio -- Projeto Internacional */
{utp/ut-liter.i "Preparando_dados" *}
RUN pi-acompanhar  IN h-acomp (INPUT RETURN-VALUE + "...").

run pi-limpa-temp-tables.
run pi-leitura-registros.
run pi-impressao-dados.

page.

run pi-impressao-parametros.


/* fechamento do output do relat¢rio */
{include/i-rpclo.i}
run pi-finalizar in h-acomp.
return "OK":U.


/*************** PROCEDIMENTOS INTERNOS *****************/
procedure pi-limpa-temp-tables:

    for each tt-relatorio:
        delete tt-relatorio.
    end.
    for each tt-erros:
        delete tt-erros.
    end.

end procedure.

procedure pi-leitura-registros:

    for each ordem-compra fields(it-codigo cod-estabel cod-comprado numero-ordem data-emissao
                                 cod-emitente nr-contrato nr-processo char-1 situacao
                                 &if defined(bf-mat-comex) &then &else qt-solic &endif) no-lock
        where ordem-compra.it-codigo    >= tt-param.c-ini-item
        and   ordem-compra.it-codigo    <= tt-param.c-fim-item
        and   ordem-compra.cod-estabel  >= tt-param.c-ini-estabel
        and   ordem-compra.cod-estabel  <= tt-param.c-fim-estabel
        and   ordem-compra.cod-comprado >= tt-param.c-ini-comprador
        and   ordem-compra.cod-comprado <= tt-param.c-fim-comprador
        and   ordem-compra.numero-ordem >= tt-param.i-ini-ordem
        and   ordem-compra.numero-ordem <= tt-param.i-fim-ordem
        and   ordem-compra.data-emissao >= tt-param.d-ini-dt-emissao
        and   ordem-compra.data-emissao <= tt-param.d-fim-dt-emissao
        and   ordem-compra.cod-emitente >= tt-param.i-ini-fornec
        and   ordem-compra.cod-emitente <= tt-param.i-fim-fornec
        and   ordem-compra.nr-contrato  >= &if defined(bf_dis_versao_ems) &then
                                               tt-param.i-ini-contr-compras
                                           &else
                                               string(tt-param.i-ini-contr-compras)
                                           &endif
        and   ordem-compra.nr-contrato  <= &if defined(bf_dis_versao_ems) &then
                                               tt-param.i-fim-contr-compras
                                           &else
                                               string(tt-param.i-fim-contr-compras)
                                           &endif
        and   ordem-compra.nr-processo  >= tt-param.i-ini-proc-compras
        and   ordem-compra.nr-processo  <= tt-param.i-fim-proc-compras :

        /* Faixa Fornecedor */
        for first emitente fields(cod-emitente nome-abrev natureza)
            where emitente.cod-emitente = ordem-compra.cod-emitente no-lock:
        end.
        if  avail emitente then do:
            if  emitente.nome-abrev < tt-param.c-ini-nome-abrev or
                emitente.nome-abrev > tt-param.c-fim-nome-abrev then
                next.
            &if defined(bf-mat-comex) &then
                if  emitente.natureza <> "E" or emitente.natureza <> "T" then /* filtra somente Estrangeiro ou Trading */
                    next.
            &else
                if  emitente.natureza < 3 then /* filtra somente Estrangeiro ou Trading */
                    next.
            &endif
        end.

        /* Faixa Fam°lia Material */
        for first item fields(it-codigo fm-codigo class-fiscal tipo-contr char-2)
            where item.it-codigo = ordem-compra.it-codigo no-lock:
        end.
        if  avail item then
        if  item.fm-codigo < tt-param.c-ini-familia or
            item.fm-codigo > tt-param.c-fim-familia then
            next.
        FOR FIRST param-imp fields(int-1) WHERE
                  param-imp.cod-estabel = ordem-compra.cod-estabel NO-LOCK:
        END.

        IF NOT AVAIL param-imp THEN NEXT.

        run pi-gera-dados-obrigatorios.

    end.

end procedure.

procedure pi-gera-dados-obrigatorios:

    DEF VAR de-aliq-ipi-antiga LIKE cotacao-item.aliquota-ipi NO-UNDO.

    RUN pi-seta-titulo IN h-acomp (INPUT "Geraá∆o Dados").
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gerando_dados_de_importaá∆o" *}
    RUN pi-acompanhar  IN h-acomp (INPUT RETURN-VALUE + "...").

    def var c-ponto-controle     as char  no-undo.
    def var l-incoterm-pto-contr as log initial no no-undo.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    if  not valid-handle(h-boin082i) then
        run inbo/boin082i.p persistent set h-boin082i.
    &endif

    for each cotacao-item NO-LOCK
        where cotacao-item.numero-ordem = ordem-compra.numero-ordem
          and cotacao-item.cod-emitente = ordem-compra.cod-emitente
          and cotacao-item.it-codigo    = ordem-compra.it-codigo :

        /* Mapa Cotaá∆o */
        if  &if defined(bf-mat-comex) &then
              int(substring(cotacao-item.char-1,6,2)) > 0
            &else
              int(substring(cotacao-item.char-1,1,20)) > 0
            &endif
            then next.

        /* Verifica se j† possue os dados obrigat¢rios de Importaá∆o (Incoterm e Pto Controle Base) */
        &if defined(bf-mat-comex) &then  /* Magnus */
            if  substring(cotacao-item.char-1,8,3) <> "" or  /* C¢digo Incoterm */
                (substring(cotacao-item.char-1,11,5) <> "" and
                int(substring(cotacao-item.char-1,11,5)) <> 0) then do:  /* Ponto Contr. Base */
                assign l-incoterm-pto-contr = yes.
            end.
        &else /* No EMS */

            if  substring(cotacao-item.char-1,21,20) <> "" or  /* C¢digo Incoterm */
                (substring(cotacao-item.char-1,41,20) <> "" AND
                int(substring(cotacao-item.char-1,41,20)) <> 0) then do: /* Ponto Contr. Base */
                assign l-incoterm-pto-contr = yes.
            end.

        &endif

        /* Posiciona fornecedor internacional */
        for first emitente-cex fields(int-1 cod-emitente cod-incoterm-imp cod-itiner-imp &IF '{&BF_DIS_VERSAO_EMS}' >= '2.05' &THEN cod-pto-contr &ELSE char-1 &ENDIF)
            where emitente-cex.cod-emitente = emitente.cod-emitente no-lock:
        end.

        FIND FIRST b-cotacao-item
             WHERE ROWID(b-cotacao-item) = ROWID(cotacao-item) EXCLUSIVE-LOCK NO-ERROR.

        /* Se n∆o est∆o informados os dados obrigat¢rios, ent∆o s∆o gerados conforme im0060 */
        if  not l-incoterm-pto-contr then do:

            if  avail emitente-cex then do:

                &IF '{&BF_DIS_VERSAO_EMS}' >= '2.05' &THEN
                    assign c-ponto-controle = string(emitente-cex.cod-pto-contr).
                &ELSE
                    assign c-ponto-controle = substring(emitente-cex.char-1,11,6).
                &ENDIF

                &if defined(bf-mat-comex) &then  /* Magnus */
                    assign overlay(b-cotacao-item.char-1,8,3)  = string(emitente-cex.cod-incoterm-imp)
                           overlay(b-cotacao-item.char-1,11,5) = c-ponto-controle.
                &else
                    assign overlay(b-cotacao-item.char-1,21,20) = string(emitente-cex.cod-incoterm-imp)
                           overlay(b-cotacao-item.char-1,41,20) = c-ponto-controle.
                &endif

                ASSIGN b-cotacao-item.int-1 = IF param-imp.int-1 = 2 THEN emitente-cex.cod-itiner-imp ELSE 0.

                if  substr(b-cotacao-item.char-1,81,20) = "":U then
                    assign overlay(b-cotacao-item.char-1,81,20) = item.class-fiscal. /* Independente do tipo de controle do item,
                                                            devera ser gravada a classificacao fiscal do cadastro na cotacao do item */

                assign overlay(b-cotacao-item.char-2,41,20) = string(cotacao-item.cod-emitente) /*fabricante*/
                       overlay(b-cotacao-item.char-1,61,20) = trim(substring(item.char-2,22,6)).

                &if "{&bf_mat_versao_ems}":U >= "2.062":U &then

                    assign de-aliq-ipi-antiga = cotacao-item.aliquota-ipi.
                    /* Busca o valor padrao do fabricante, do pais de origem e do regime de importacao padrao */
                    run setDefaultsIm0060 in h-boin082i (input  cotacao-item.it-codigo,
                                                         input  cotacao-item.cod-emitente,
                                                         input  substr(cotacao-item.char-1,81,20), /* class-fiscal */
                                                         output i-cod-fabricante,
                                                         output i-cdn-pais-orig,
                                                         output i-regime-import).

                    assign b-cotacao-item.cdn-pais-orig         = i-cdn-pais-orig
                           overlay(b-cotacao-item.char-2,41,20) = string(i-cod-fabricante)
                           overlay(b-cotacao-item.char-2,61,20) = string(i-regime-import).

                    /* Busca aliquotas II e IPI */
                    run calculateII_IPI in h-boin082i (input  cotacao-item.it-codigo,
                                                       input  cotacao-item.numero-ordem,
                                                       input  cotacao-item.aliquota-ipi,
                                                       input  substr(cotacao-item.char-1,81,20), /* class-fiscal */
                                                       input  cotacao-item.cdn-pais-orig,
                                                       input  int(trim(substr(cotacao-item.char-2,61,20))), /* regime-import */
                                                       output de-aliq-ii,
                                                       output de-aliq-ipi).

                    assign overlay(b-cotacao-item.char-1,61,20) = string(de-aliq-ii)
                           b-cotacao-item.aliquota-ipi          = de-aliq-ipi.

                    /* recalcula valor do item quando altera a aliquota do ipi */
                    if  de-aliq-ipi-antiga <> cotacao-item.aliquota-ipi then do:

                        assign l-preco-bruto = (param-compra.ipi-sobre-preco = 1).
                        {cdp/cd9300.i cotacao-item}
                        assign b-cotacao-item.preco-unit   = cotacao-item.pre-unit-for.

                        find b-ordem-compra
                            where b-ordem-compra.numero-ordem = cotacao-item.numero-ordem exclusive-lock no-error.
                        assign b-ordem-compra.aliquota-ipi = cotacao-item.aliquota-ipi.
                        {cdp/cd9300.i b-ordem-compra}
                        assign b-ordem-compra.preco-unit   = b-ordem-compra.pre-unit-for.

                        /*
                        ** Calculo do preco de reposicao do item
                        */
                        run ccp/ccapi001.p (input rowid(b-ordem-compra)).
                    end.
                &endif
            end.
        end.

        /* Depois de ter gerado os dados obrigat¢rios, ver opá∆o nos parÉmetros */
        if  tt-param.i-gera = 1 then /* Gera Despesas */
            run pi-gera-despesas-importacao.

        else do: /* Gera somente dados obrigat¢rios */

            /* Mapa Cotaá∆o */
            &if defined(bf-mat-comex) &then
                assign overlay(b-cotacao-item.char-1,6,2) = "0".
            &else
                assign overlay(b-cotacao-item.char-1,1,20) = "0".
            &endif

            /* Gera listagem somente com os dados da ordem-compra/cotacao-item */
            create tt-relatorio.
            assign tt-relatorio.numero-ordem    = ordem-compra.numero-ordem
                   tt-relatorio.it-codigo       = ordem-compra.it-codigo
                   tt-relatorio.moeda           = cotacao-item.mo-codigo
                   tt-relatorio.vl-pre-unit     = &if defined(bf-mat-comex) &then cotacao-item.preco-unit
                                                  &else (cotacao-item.preco-unit * 100)/(100 + cotacao-item.aliquota-ipi)
                                                  &endif
                   tt-relatorio.vl-pre-unit-for = &if defined(bf-mat-comex) &then 0
                                                  &else (cotacao-item.pre-unit-for * 100)/(100 + cotacao-item.aliquota-ipi)
                                                  &endif
                   tt-relatorio.incoterm        = &if defined(bf-mat-comex) &then
                                                  substring(cotacao-item.char-1,8,3)
                                                  &else
                                                  substring(cotacao-item.char-1,21,20)
                                                  &endif
                   tt-relatorio.pto-contr-base  = &if defined(bf-mat-comex) &then
                                                  substring(cotacao-item.char-1,11,5)
                                                  &else
                                                  substring(cotacao-item.char-1,41,20)
                                                  &endif
                   tt-relatorio.aprovacao       = cotacao-item.cot-aprovada
                   tt-relatorio.cod-itiner      = cotacao-item.int-1
                   l-despesas                   = no.

            /* Nossa Qtde */
            &if defined(bf-mat-comex) &then
                for each prazo-compra fields(numero-ordem quantidade) no-lock where
                         prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                    assign de-qtd-tot      = de-qtd-tot + prazo-compra.quantidade.
                end.
                assign tt-relatorio.qtde = de-qtd-tot.
            &else
                for each prazo-compra fields(numero-ordem qtd-do-forn) no-lock where
                         prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                    assign de-qtd-tot-forn = de-qtd-tot-forn + prazo-compra.qtd-do-forn.
                end.
                assign tt-relatorio.qtde        = ordem-compra.qt-solic
                       tt-relatorio.qtde-fornec = de-qtd-tot-forn.
            &endif

            /* Descriá∆o do Item */
            for first item fields(it-codigo &if defined(bf-mat-comex) &then descricao-1 &else desc-item &endif)
                where item.it-codigo = ordem-compra.it-codigo no-lock:
            end.
            if  avail item then do:
                &if defined(bf-mat-comex) &then
                    assign tt-relatorio.desc-item = item.descricao-1.
                &else
                    assign tt-relatorio.desc-item = item.desc-item.
                &endif
            end.
        end.
    end. /* fim for each cotacao-item */

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    if  valid-handle(h-boin082i) then do:
        delete procedure h-boin082i.
        assign h-boin082i = ?.
    end.
    &endif

end procedure.

procedure pi-gera-despesas-importacao:

    RUN pi-seta-titulo IN h-acomp (INPUT "Geraá∆o Despesas").
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Gerando_despesas_de_importaá∆o" *}
    RUN pi-acompanhar  IN h-acomp (INPUT RETURN-VALUE + "...").

    def var r-chave        as rowid no-undo.
    def var l-criou        as log initial no no-undo.
    def var i-mapa-cotacao as int   no-undo.

    &if defined(bf-mat-comex) &then
        assign i-mapa-cotacao = int(substring(cotacao-item.char-1,6,2)).
    &else
        assign i-mapa-cotacao = int(substring(cotacao-item.char-1,1,20)).

    &endif

    for first cotacao-item-cex fields(numero-ordem cod-emitente it-codigo data-cotacao mapa-cotacao
                                      &if defined(bf-mat-comex) &then &else seq-cotac &endif)
         where cotacao-item-cex.numero-ordem = cotacao-item.numero-ordem
           and cotacao-item-cex.cod-emitente = cotacao-item.cod-emitente
           and cotacao-item-cex.it-codigo    = cotacao-item.it-codigo
         &if defined(bf-mat-comex) &then
         &else
           and cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
         &endif
           and cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
           and cotacao-item-cex.mapa-cotacao = i-mapa-cotacao
           no-lock:
    end.
    if  avail cotacao-item-cex then do:
        next.
    end.

    for each tt-cotacao-item-cex:
        delete tt-cotacao-item-cex.
    end.
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.

    assign l-despesas = no.

    create tt-cotacao-item-cex.
    assign tt-cotacao-item-cex.numero-ordem = ordem-compra.numero-ordem
           tt-cotacao-item-cex.cod-emitente = ordem-compra.cod-emitente
           tt-cotacao-item-cex.it-codigo    = ordem-compra.it-codigo
         &if defined(bf-mat-comex) &then
         &else
           tt-cotacao-item-cex.seq-cotac    = cotacao-item.seq-cotac
         &endif
           tt-cotacao-item-cex.data-cotacao = cotacao-item.data-cotacao
           tt-cotacao-item-cex.mapa-cotacao = 1
           tt-cotacao-item-cex.cod-itiner   = if avail emitente-cex then emitente-cex.cod-itiner-imp else 0.

    run cxbo/bocx085.p persistent set h-bocx085.

    run validateCreatePai in h-bocx085 (input-output table tt-cotacao-item-cex,
                                        output table tt-bo-erro,
                                        output r-chave,
                                        output l-criou).

    FIND LAST tt-bo-erro NO-LOCK NO-ERROR.
    IF AVAIL tt-bo-erro THEN
       ASSIGN i-seq-erro = tt-bo-erro.i-sequen.

    find first tt-cotacao-item-cex no-error.

    {imp/im0016.i} /*Validaá∆o fornecedor da despesa e Ponto de Controle*/

    if  can-find (first tt-bo-erro) then do:

        create tt-relatorio.
        assign /*-- Informaá‰es da ordem-compra e cotacao-item --*/
               tt-relatorio.numero-ordem    = tt-cotacao-item-cex.numero-ordem
               tt-relatorio.it-codigo       = tt-cotacao-item-cex.it-codigo
               tt-relatorio.moeda           = cotacao-item.mo-codigo
               tt-relatorio.vl-pre-unit     = &if defined(bf-mat-comex) &then cotacao-item.preco-unit
                                              &else (cotacao-item.preco-unit * 100)/(100 + cotacao-item.aliquota-ipi)
                                              &endif
               tt-relatorio.vl-pre-unit-for = &if defined(bf-mat-comex) &then 0
                                              &else (cotacao-item.pre-unit-for * 100)/(100 + cotacao-item.aliquota-ipi)
                                              &endif
               tt-relatorio.incoterm        = &if defined(bf-mat-comex) &then
                                              substring(cotacao-item.char-1,8,3)
                                              &else
                                              substring(cotacao-item.char-1,21,20)
                                              &endif
               tt-relatorio.pto-contr-base  = &if defined(bf-mat-comex) &then
                                              substring(cotacao-item.char-1,11,5)
                                              &else
                                              substring(cotacao-item.char-1,41,20)
                                              &endif
               tt-relatorio.aprovacao       = cotacao-item.cot-aprovada
               l-despesas                   = no.

        for each tt-bo-erro:
            create tt-erros.
            assign tt-erros.numero-ordem = tt-cotacao-item-cex.numero-ordem
                   tt-erros.cod-erro     = tt-bo-erro.cd-erro
                   tt-erros.desc-erro    = tt-bo-erro.mensagem
                   tt-erros.c-help       = tt-bo-erro.errorhelp.

        end.
        IF r-chave <> ? THEN
            RUN validateDeletePai in h-bocx085(input-output r-chave,output table tt-bo-erro).

    end.
    else do:
        /* Gerou corretamente as despesas, ent∆o Mapa Cotaá∆o aprovado (= 1) */
        &if defined(bf-mat-comex) &then
            assign overlay(cotacao-item.char-1,6,2) = "1".
        &else
            assign overlay(cotacao-item.char-1,1,20) = "1".
        &endif
        /*release cotacao-item.*/
    end.

    delete procedure h-bocx085.

    for each cotacao-item-cex fields(numero-ordem cod-emitente it-codigo cod-itiner cod-emitente-desp
                                     cod-pto-contr cod-desp cod-cond-pag val-desp mo-codigo nr-tab
                                     &if defined(bf-mat-comex) &then &else seq-cotac mapa-cotacao data-cotacao &endif) no-lock
        where cotacao-item-cex.numero-ordem = tt-cotacao-item-cex.numero-ordem
          and cotacao-item-cex.cod-emitente = tt-cotacao-item-cex.cod-emitente
          and cotacao-item-cex.it-codigo    = tt-cotacao-item-cex.it-codigo
        &if defined(bf-mat-comex) &then
        &else
          and cotacao-item-cex.seq-cotac    = tt-cotacao-item-cex.seq-cotac
        &endif
          and cotacao-item-cex.mapa-cotacao = tt-cotacao-item-cex.mapa-cotacao
          and cotacao-item-cex.data-cotacao = tt-cotacao-item-cex.data-cotacao :

        /* Gera listagem com os dados da ordem-compra/cotacao-item e lista as despesas (cotacao-item-cex) geradas */
        create tt-relatorio.
        assign /*-- Informaá‰es da ordem-compra e cotacao-item --*/
               tt-relatorio.numero-ordem    = cotacao-item-cex.numero-ordem
               tt-relatorio.it-codigo       = cotacao-item-cex.it-codigo
               tt-relatorio.moeda           = cotacao-item.mo-codigo
               tt-relatorio.vl-pre-unit     = &if defined(bf-mat-comex) &then cotacao-item.preco-unit
                                              &else (cotacao-item.preco-unit * 100)/(100 + cotacao-item.aliquota-ipi)
                                              &endif
               tt-relatorio.vl-pre-unit-for = &if defined(bf-mat-comex) &then 0
                                              &else (cotacao-item.pre-unit-for * 100)/(100 + cotacao-item.aliquota-ipi)
                                              &endif
               tt-relatorio.incoterm        = &if defined(bf-mat-comex) &then
                                              substring(cotacao-item.char-1,8,3)
                                              &else
                                              substring(cotacao-item.char-1,21,20)
                                              &endif
               tt-relatorio.pto-contr-base  = &if defined(bf-mat-comex) &then
                                              substring(cotacao-item.char-1,11,5)
                                              &else
                                              substring(cotacao-item.char-1,41,20)
                                              &endif
               tt-relatorio.aprovacao       = cotacao-item.cot-aprovada
               /*-- Informaá‰es da cotacao-item-cex (Despesas) --*/
               tt-relatorio.cod-itiner      = cotacao-item-cex.cod-itiner
               tt-relatorio.fornec-desp     = cotacao-item-cex.cod-emitente-desp
               tt-relatorio.pto-contr       = cotacao-item-cex.cod-pto-contr
               tt-relatorio.cod-desp        = cotacao-item-cex.cod-desp
               tt-relatorio.cond-pag        = cotacao-item-cex.cod-cond-pag
               tt-relatorio.vl-des          = cotacao-item-cex.val-desp
               tt-relatorio.moeda-desp      = cotacao-item-cex.mo-codigo
               tt-relatorio.nr-tab-desp     = cotacao-item-cex.nr-tab
               l-despesas                   = yes.

        /* Nossa Qtde */
        &if defined(bf-mat-comex) &then
            for each prazo-compra fields(numero-ordem quantidade) no-lock where
                     prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                assign de-qtd-tot = de-qtd-tot + prazo-compra.quantidade.
            end.
            assign tt-relatorio.qtde = de-qtd-tot.
        &else
            for each prazo-compra fields(numero-ordem qtd-do-forn) no-lock where
                     prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                assign de-qtd-tot-forn = de-qtd-tot-forn + prazo-compra.qtd-do-forn.
            end.
            assign tt-relatorio.qtde        = ordem-compra.qt-solic
                   tt-relatorio.qtde-fornec = de-qtd-tot-forn.
        &endif

        /* Descriá∆o do Item */
        for first item fields(it-codigo &if defined(bf-mat-comex) &then descricao-1 &else desc-item &endif)
            where item.it-codigo = tt-cotacao-item-cex.it-codigo no-lock:
        end.
        if  avail item then do:
            &if defined(bf-mat-comex) &then
                assign tt-relatorio.desc-item = item.descricao-1.
            &else
                assign tt-relatorio.desc-item = item.desc-item.
            &endif
        end.

        /* Nome Abreviado do fornecedor da despesa */
        for first emitente fields(cod-emitente nome-abrev)
            where emitente.cod-emitente = cotacao-item-cex.cod-emitente-desp no-lock:
        end.
        if  avail emitente then
            assign tt-relatorio.nome-abrev = emitente.nome-abrev.

        /* Descriá∆o da Despesa */
        for first desp-imp fields(cod-desp descricao)
            where desp-imp.cod-desp = cotacao-item-cex.cod-desp no-lock:
        end.
        if  avail desp-imp then
            assign tt-relatorio.desc-desp = desp-imp.descricao.

    end. /* fim for each cotacao-item-cex */

    if  tt-param.l-recalcula then do:
        run pi-recalcula-aprovacao-compra.
    end.

end procedure.

procedure pi-recalcula-aprovacao-compra:

    RUN pi-seta-titulo IN h-acomp (INPUT "Rec†lculo Aprovaá∆o").
    /* Inicio -- Projeto Internacional */
    {utp/ut-liter.i "Recalculando_valor_de_aprovaá∆o_de_compra" *}
    RUN pi-acompanhar  IN h-acomp (INPUT RETURN-VALUE + "...").

    assign de-qtd-tot      = 0
           de-val-despesas = 0
           de-val-tot      = 0.

    if  cotacao-item.cot-aprovada and
        &if defined(bf-mat-comex) &then
          substring(cotacao-item.char-1,6,2) = "1"
        &else
          substring(cotacao-item.char-1,1,20) = "1"
        &endif
    then do:

        /* MAGNUS */
        &if defined(bf-mat-comex) &then

            /* Extra°do do cc0303m.p (conforme Alan Koerbel) */

            find first param-compra no-lock no-error.

            if cotacao-item.numero-ordem <> ? then do:
                assign de-qtd-tot = 0.

                for each prazo-compra fields(numero-ordem quantidade) no-lock where
                         prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                    assign de-qtd-tot = de-qtd-tot + prazo-compra.quantidade.
                end.
                assign de-val-tot = de-qtd-tot * cotacao-item.preco-unit.

                /*** Integracao Modulo Importacao ***/
                &if int(entry(1,proversion,".")) >= 8 &THEN

                    run imp/im9029.p(input rowid(cotacao-item),
                                     output de-val-despesas).
                    assign de-val-despesas = de-qtd-tot * de-val-despesas.
                    assign de-val-tot = de-val-tot + de-val-despesas.

                &ENDIF
            end.

            /* linha 729 */
            if param-compra.cota-aprov then do:
               run ccp/cc9991.p(input &IF {&ROWID_READY} = YES &THEN
                                        ROWID(cotacao-item)
                                      &ELSE
                                        RECID(cotacao-item)
                                      &ENDIF).

               if param-compra.log-1 then do:
                  /* t-aprov alimentada no cc9991.p */
                  find first t-aprov where
                      t-aprov.cod-aprovador = cotacao-item.cod-comprado no-error.
                  find first comprador where
                      comprador.cod-comprado = t-aprov.cod-aprovador
                      no-lock no-error.

                  if de-val-tot > t-aprov.lim-aprovacao then do:
                     assign overlay(ordem-compra.char-1,6,1) = "1".
                  end.
               end.
            end.
            else do:
                if  ordem-compra.situacao = "N" then do:
                    assign ordem-compra.situacao = "M".
                    for each prazo-compra fields(numero-ordem situacao) exclusive-lock
                       where prazo-compra.numero-ordem = ordem-compra.numero-ordem:
                        assign prazo-compra.situacao = ordem-compra.situacao.
                    end.
                end.
            end.

        /* EMS */
        &else
            &if '{&bf_dis_versao_ems}' >= '2.062' &then
                run ocp/oc0201i.p (INPUT  "Reaprovaá∆o cotaá∆o autom†tica (IM0016)",
                                   INPUT  c-seg-usuario,
                                   INPUT  ROWID(cotacao-item),
                                   INPUT  3,
                                   OUTPUT TABLE RowErrors).

                FOR EACH rowerrors:
                    create tt-erros.
                    assign tt-erros.numero-ordem = cotacao-item.numero-ordem
                           tt-erros.cod-erro     = RowErrors.errorNumber
                           tt-erros.desc-erro    = RowErrors.errorDescription
                           tt-erros.c-help       = RowErrors.errorHelp.
                END.


            &else
                run ccp/cc0303i.p (input "Reaprovaá∆o cotaá∆o autom†tica (IM0016)",
                                   input c-seg-usuario,
                                   input rowid(cotacao-item),
                                   input 3).
            &endif
        &endif

    end.

end procedure.

procedure pi-impressao-dados:

    for each tt-relatorio
        break by tt-relatorio.numero-ordem
              by tt-relatorio.cod-itiner
              by tt-relatorio.fornec-desp:

        if  first-of(tt-relatorio.numero-ordem) then do:

            &if defined(bf-mat-comex) &then
                disp tt-relatorio.numero-ordem   @ i-ordem
                     tt-relatorio.it-codigo      @ c-item
                     tt-relatorio.desc-item      @ c-desc-item
                     tt-relatorio.qtde           @ d-qtde
                     tt-relatorio.moeda          @ i-moeda
                     tt-relatorio.vl-pre-unit    @ d-prc-unit
                     tt-relatorio.incoterm       @ c-incoterm
                     tt-relatorio.pto-contr-base @ i-pto-contr-base
                     tt-relatorio.aprovacao      @ l-aprovada
                     with frame f-tabela-ordem.
                down with frame f-tabela-ordem.
            &else
                disp tt-relatorio.numero-ordem    @ i-ordem
                     tt-relatorio.it-codigo       @ c-item
                     tt-relatorio.desc-item       @ c-desc-item
                     tt-relatorio.qtde-fornec     @ d-qtde-for
                     tt-relatorio.qtde            @ d-qtde
                     tt-relatorio.moeda           @ i-moeda
                     tt-relatorio.vl-pre-unit     @ d-prc-unit
                     tt-relatorio.vl-pre-unit-for @ d-prc-unit-for
                     tt-relatorio.incoterm        @ c-incoterm
                     tt-relatorio.pto-contr-base  @ i-pto-contr-base
                     tt-relatorio.aprovacao       @ l-aprovada
                     with frame f-tabela-ordem.
                down with frame f-tabela-ordem.
            &endif

            if tt-param.i-gera = 1 then
            put unformatted skip(1).

            if  can-find (first tt-erros where tt-erros.numero-ordem = tt-relatorio.numero-ordem) then do:
                for each tt-erros where tt-erros.numero-ordem = tt-relatorio.numero-ordem:
                    disp tt-erros.cod-erro
                         tt-erros.desc-erro
                         tt-erros.c-help
                         with frame f-erros.
                    down with frame f-erros.
                end.
            end.

        end.
        if  first-of(tt-relatorio.cod-itiner) and tt-param.i-gera = 1 and l-despesas then do:

            for first itinerario fields(cod-itiner descricao)
                where itinerario.cod-itiner = tt-relatorio.cod-itiner no-lock:
            end.
            if  avail itinerario then
                assign c-desc-itiner = itinerario.descricao.

            put unformatted skip(1).
            assign c-traduz = "Itiner†rio:".
            put c-traduz                at 1  format "x(11)".
            put tt-relatorio.cod-itiner at 13 format "zz,zz9".
            put "-"                     at 21.
            put c-desc-itiner           at 23 format "x(30)".
            put unformatted skip(1).
        end.
        if  tt-param.i-gera = 1 and l-despesas then do:

            disp tt-relatorio.fornec-desp @ i-fornec-desp
                 tt-relatorio.nome-abrev  @ c-nome-abrev
                 tt-relatorio.pto-contr   @ i-pto-contr
                 tt-relatorio.cod-desp    @ i-despesa
                 tt-relatorio.desc-desp   @ c-desc-desp
                 tt-relatorio.cond-pag    @ i-cond-pag
                 tt-relatorio.vl-des      @ d-val-desp
                 tt-relatorio.moeda-desp  @ i-moeda-desp
                 tt-relatorio.nr-tab-desp @ c-nr-tab
                 with frame f-tabela-itiner.
            down with frame f-tabela-itiner.
        end.
        if  last-of(tt-relatorio.cod-itiner) and tt-param.i-gera = 1 then
            put unformatted skip(2).

    end.

end procedure.

procedure pi-impressao-parametros:

   /*** FOLDER SELEÄ«O ***/
   {utp/ut-liter.i "SELEÄ«O" * r}.
   assign c-traduz = return-value.
   put c-traduz at 056 skip(1).

   assign c-traduz = "Item:".
   put c-traduz                  at 038 format "x(5)"
       tt-param.c-ini-item       at 044 format "x(16)"
       "|<   >|"                 at 061
       tt-param.c-fim-item       at 069 format "x(16)".
   put unformatted skip.

   assign c-traduz = "Estabelecimento:".
   put c-traduz                  at 027 format "x(16)"
&IF "{&mguni_version}" >= "2.071" &THEN
       tt-param.c-ini-estabel    at 055 format "x(05)"
&ELSE
       tt-param.c-ini-estabel    at 057 format "x(3)"
&ENDIF
       "|<   >|"                 at 061
&IF "{&mguni_version}" >= "2.071" &THEN
       tt-param.c-fim-estabel    at 069 format "x(05)".
&ELSE
       tt-param.c-fim-estabel    at 069 format "x(3)".
&ENDIF
   put unformatted skip.

   assign c-traduz = "Comprador:".
   put c-traduz                  at 033 format "x(10)"
       tt-param.c-ini-comprador  at 048 format "x(12)"
       "|<   >|"                 at 061
       tt-param.c-fim-comprador  at 069 format "x(12)".
   put unformatted skip.

   assign c-traduz = "Ordem:".
   put c-traduz                  at 037 format "x(6)"
       tt-param.i-ini-ordem      at 051 format "zzzzz9,99"
       "|<   >|"                 at 061
       tt-param.i-fim-ordem      at 069 format "zzzzz9,99".
   put unformatted skip.

   assign c-traduz = "Data Emiss∆o:".
   put c-traduz                  at 030 format "x(13)"
       tt-param.d-ini-dt-emissao at 050 format "99/99/9999"
       "|<   >|"                 at 061
       tt-param.d-fim-dt-emissao at 069 format "99/99/9999".
   put unformatted skip.

   assign c-traduz = "Fam°lia:".
   put c-traduz                  at 035 format "x(8)"
       tt-param.c-ini-familia    at 052 format "x(8)"
       "|<   >|"                 at 061
       tt-param.c-fim-familia    at 069 format "x(8)".
   put unformatted skip.

   assign c-traduz = "Fornecedor Material:".
   put c-traduz                  at 023 format "x(20)"
       tt-param.i-ini-fornec     at 051 format "999999999"
       "|<   >|"                 at 061
       tt-param.i-fim-fornec     at 069 format "999999999".
   put unformatted skip.

   assign c-traduz = "Nome Abrev:".
   put c-traduz                  at 032 format "x(11)"
       tt-param.c-ini-nome-abrev at 048 format "x(12)"
       "|<   >|"                 at 061
       tt-param.c-fim-nome-abrev at 069 format "x(12)".
   put unformatted skip.

   assign c-traduz = "Contrato de Compras:".
   put c-traduz                     at 023 format "x(21)"
       tt-param.i-ini-contr-compras at 051 format "999999999"
       "|<   >|"                    at 061
       tt-param.i-fim-contr-compras at 069 format "999999999".
   put unformatted skip.

   assign c-traduz = "Processo de Compras:".
   put c-traduz                     at 023 format "x(21)"
       tt-param.i-ini-proc-compras  at 053 format "999,999"
       "|<   >|"                    at 061
       tt-param.i-fim-proc-compras  at 069 format "999,999".
   put unformatted skip(2).


   /*** FOLDER PAR∂METROS ***/
   {utp/ut-liter.i "PAR∂METROS" * r}.
   assign c-traduz = return-value.
   put c-traduz at 055 format "x(10)" skip(1).

   case tt-param.i-gera:
       when 1 then
           assign c-desc-gera = "Gera Despesas".
       when 2 then
           assign c-desc-gera = "Gera Somente Dados Obrigat¢rios".
   end case.

   put c-desc-gera         at 044 format "x(31)".
   put unformatted skip.

   put TRIM(RETURN-VALUE) + ":"  at 042 format "x(31)".
   {utp/ut-liter.i "Sim/N∆o" }.
   ASSIGN c-traduz = TRIM(RETURN-VALUE).
   put tt-param.l-recalcula      at 073 format c-traduz.
   put unformatted skip(2).


   /*** FOLDER IMPRESS«O ***/
   {utp/ut-liter.i "IMPRESS«O" * r}.
   assign c-traduz = return-value.
   put c-traduz at 055 format "x(15)" skip(1).

   {utp/ut-liter.i "Usu†rio:" * r}.
   assign c-traduz = return-value.

   put c-traduz         at 048 format "x(08)"
       tt-param.usuario at 057 format "x(20)".

   {utp/ut-liter.i "Destino:" * r}
   assign c-traduz = return-value.

   put c-traduz         at 048 format "x(08)"
       tt-param.arquivo at 057 format "x(40)".

end.


/* Fim IM0016RP.P */
