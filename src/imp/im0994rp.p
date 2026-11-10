/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0994RP 2.00.00.016 } /*** "010016" 21/03/2025 09:24:36  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0994rp MRE}
&ENDIF

{include/i_fnctrad.i}

/*****************************************************************************
**
**       Programa: IM0994RP
**
**       Objetivo: Atualizacao de Faturas - Consistencias (COMEX)
**
*****************************************************************************/

{utp/ut-glob.i}

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

{cep/ceapi001.i}                    /* Definicao TT-MOVTO               */
{cdp/cd0666.i}                      /* Definicao TT-ERRO                */
{imp/im0994c.i}
{rep/re1005.i01}
{cdp/cd4300.i3}                     /* Variaveis para o cd4300.i4       */
{rep/re9341.i50}                    /* Variaveis para o re9341.i51      */
{app/apapi001b.i}                    /* Definicao de temp-tables         */
{rep/re9340.i1 new}                 /* Frame para impressao dos titulos */
{cdp/cd1234.i}    /* Validaá∆o Decimais */
{include/tt-edit.i}
{include/i-rpvar.i} 

{include/i-epc200.i IM0994rp} /** Upc **/

{local/ecu/rep/ecure1005.i} /*Vari†veis Localizaá∆o Equador*/

define temp-table tt-param NO-UNDO
    field destino            as integer
    field arquivo            as char
    field usuario            as char
    field data-exec          as date
    field hora-exec          as integer
    field classifica         as integer
    field c-cod-estabel-ini  as char
    field c-cod-estabel-fim  as char
    field i-cod-emitente-ini as integer
    field i-cod-emitente-fim as integer
    field c-nro-docto-ini    as char
    field c-nro-docto-fim    as char
    field c-serie-docto-ini  as char
    field c-serie-docto-fim  as char
    field c-nat-operacao-ini as char
    field c-nat-operacao-fim as char
    field da-dt-trans-ini    as date
    field da-dt-trans-fim    as date.

define temp-table tt-digita
    field r-docum-est        as rowid
    FIELD narrativa          AS CHAR.

define temp-table tt-raw-digita
    field raw-digita as raw.

define temp-table tt-movimento NO-UNDO
    field nr-trans  as integer
    field sequencia as integer.

def input param raw-param   as raw                no-undo.
def input param table       for tt-raw-digita.
def input param table       for tt-total.
def input param table       for tt-dupli-imp.

def buffer b-docum-est      for docum-est.
def buffer b-item-doc-est   for item-doc-est.
def buffer b2-item-doc-est  for item-doc-est.
DEF BUFFER b-item           FOR ITEM.
DEF BUFFER bfdocum-est-cex FOR docum-est-cex.
DEF BUFFER bf-item-doc-est-cex FOR item-doc-est-cex.

def var h-acomp             as handle                              no-undo.
def var l-erro              as logical                             no-undo.
def var c-texto1            as char                                no-undo.
def var c-texto2            as char                                no-undo.
def var c-texto3            as char                                no-undo.
def var c-aux-msg           as char                                no-undo.
def var l-itens             as logical                             no-undo.
def var da-data             as date    extent 12                   no-undo.
def var da-partida          as date                                no-undo.
def var i-ind               as integer                             no-undo.
def var i-avanco            as integer                             no-undo.
def var rw-duplicata        as rowid                               no-undo.
def var i-parcela-imp       as integer                             no-undo.
def var h_re0994e1          as handle                              no-undo.
def var l-usa-mp            as logical                             no-undo.
def var de-val-tot          as dec                                 no-undo.
def var l-erro-ap           as logical                             no-undo.
def var l-erro-movto        as logical                             no-undo.
def var l-dif-desconto      as logical                             no-undo.
def var l-dif-preco         as logical                             no-undo.
def var c-cod-depos         like rat-lote.cod-depos                no-undo.
def var c-cod-localiz       like rat-lote.cod-localiz              no-undo.
def var c-lote              like rat-lote.lote                     no-undo.
def var c-ct-credito        like movto-estoq.ct-codigo             no-undo.
def var c-sc-credito        like movto-estoq.sc-codigo             no-undo.
def var c-ct-debito         like movto-estoq.ct-codigo             no-undo.
def var c-sc-debito         like movto-estoq.sc-codigo             no-undo.
def var c-ct-aux            like movto-estoq.ct-codigo             no-undo.
def var c-sc-aux            like movto-estoq.sc-codigo             no-undo.
def var da-validade         like rat-lote.dt-vali-lote             no-undo.
def var de-val-aux          like movto-estoq.valor-mat-m extent 0  no-undo.
def var de-vl-diferenca     like movto-estoq.valor-mat-m extent 0  no-undo.
def var de-valor            as decimal                             no-undo.
def var de-valor-total      as decimal                             no-undo.
def var de-valor-max        as decimal                             no-undo.
def var r-tt-movto          as rowid                               no-undo.
DEF VAR tot-despesa         AS DECIMAL                             NO-UNDO.
DEF VAR i-cont-aux          AS INTEGER                             NO-UNDO.
DEF VAR rw-saldo-terc       AS ROWID                               NO-UNDO.

def var i-empresa           like param-global.empresa-prin         no-undo.
def var l-ems50             as logical                             no-undo.
def var l-ja-conectado      as logical                             no-undo.
def var dat-tipo-dia        like calen-coml.tipo-dia               no-undo. /*CD9020.i7*/

def new global shared var c-prog-concil as char no-undo. /*variable con el nombre del programa concialiador*/


{btb/btb009za.i}

DEF VAR h-btb009za AS HANDLE.

{rep/re1005.i14} 

{cdp/cdcfgdis.i}

find first param-global NO-LOCK NO-ERROR.

assign  l-ems50 = can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00"
                                    and funcao.ativo = yes
                                    and funcao.log-1 = yes).
if  l-ems50 then do:

    run pi-conecta-ems50 ( 1 ). /* 1 = conecta */

    if l-erro then 
       undo, return "NOK".
end.     

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Atualizaá∆o_ParÉmetros  MRE R}
assign c-texto1 = return-value.
{utp/ut-liter.i Atualizaá∆o_Faturas  MRE R}
assign c-texto3 = return-value.

run pi-inicializar in h-acomp (input c-texto3).
/*run pi-inicializar in h-acomp ("Atualizaá∆o Faturas").*/

find first param-estoq NO-LOCK NO-ERROR.

run pi-acompanhar in h-acomp (input c-texto1).

create tt-param.
raw-transfer raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.

find first tt-digita no-error.
if  not available tt-digita then do:
    for each docum-est 
        where docum-est.cod-estabel  >= tt-param.c-cod-estabel-ini 
          and docum-est.cod-estabel  <= tt-param.c-cod-estabel-fim 
          and docum-est.cod-emitente >= tt-param.i-cod-emitente-ini 
          and docum-est.cod-emitente <= tt-param.i-cod-emitente-fim 
          and docum-est.nro-docto    >= tt-param.c-nro-docto-ini 
          and docum-est.nro-docto    <= tt-param.c-nro-docto-fim 
          and docum-est.serie-docto  >= tt-param.c-serie-docto-ini 
          and docum-est.serie-docto  <= tt-param.c-serie-docto-fim 
          and docum-est.nat-operacao >= tt-param.c-nat-operacao-ini 
          and docum-est.nat-operacao <= tt-param.c-nat-operacao-fim 
          and docum-est.dt-trans     >= tt-param.da-dt-trans-ini 
          and docum-est.dt-trans     <= tt-param.da-dt-trans-fim 
          and docum-est.ce-atual      = no no-lock:

        {utp/ut-liter.i Docto:  MRE L}
        assign c-texto1 = return-value.
        run pi-acompanhar in h-acomp (input c-texto1 + docum-est.nro-docto +
                                      "/" + docum-est.serie-docto).

        create tt-digita.
        assign tt-digita.r-docum-est = rowid(docum-est).

    end.
end.

find first tt-param no-error.
    
find first param-global NO-LOCK NO-ERROR.
find param-re where param-re.usuario = c-seg-usuario no-lock no-error.

assign c-empresa    = param-global.grupo
       c-programa   = "IM/0994":U
       c-versao     = "1.00"
       c-revisao    = "000".

{utp/ut-liter.i Recebimento *}
ASSIGN c-sistema = TRIM(RETURN-VALUE).

{utp/ut-liter.i Conciliaá∆o_Remito_x_Fatura WDK}
ASSIGN c-titulo-relat = TRIM(RETURN-VALUE).
    
{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

/* Leitura dos documentos */
for each tt-digita:               

    find docum-est where rowid(docum-est) = tt-digita.r-docum-est EXCLUSIVE-LOCK no-error.

    if  docum-est.ap-atual then 
        next.

    find emitente where emitente.cod-emitente = docum-est.cod-emitente no-lock no-error.

    {utp/ut-liter.i Verificando_Documento  MRE R}
    assign c-texto2 = return-value.

    run pi-acompanhar in h-acomp (input c-texto2 + docum-est.nro-docto + "/" + docum-est.serie-docto ). 

    if  docum-est.dt-trans < (today - param-re.var-atual) then do:
        {utp/ut-field.i mgind docum-est dt-trans 2}
        run pi-erro-nota ( 8824,                /* Data de Transacao fora dos Parametros do Usuario */
                           return-value ).
    end.

    if  docum-est.dt-trans > today then 
        run pi-erro-nota ( 1788, " ").          /* Data nao pode ser superior ao Sistema */

    {utp/ut-liter.i Verificando_Itens  MRE R}
    assign c-texto2 = return-value.

    run pi-acompanhar in h-acomp (input c-texto2 + c-texto1 + docum-est.nro-docto + docum-est.serie-docto ).

    /*Validaá‰es Internacional*/
    RUN pi-valida-docto-internacional.

    assign l-itens = no.
    for first item-doc-est fields() {cdp/cd8900.i item-doc-est docum-est} no-lock:
        assign l-itens = yes.
    end.

    if  not l-itens then  
        run pi-erro-nota ( 6504, " ").              /* Nota Fiscal nao possui Itens para Atualizacao */

    if  not l-itens then 
        undo, next.

    /* Caso existam erros na nota - cancela a atualizaá∆o */
    if  l-erro then 
        next.

    assign docum-est.usuario = c-seg-usuario.

    /*****************************************************************************/    
    /** Chamada UPC no inicio da Atualizaá∆o                                    **/
    /*****************************************************************************/

    for each tt-epc where tt-epc.cod-event = "inicio-atualizacao":
       delete tt-epc.
    end.

    create tt-epc.
    assign tt-epc.cod-event     = "inicio-atualizacao"
           tt-epc.cod-parameter = "docum-est rowid"
           tt-epc.val-parameter = string(rowid(docum-est)).

    {include/i-epc201.i "inicio-atualizacao"}

    if  return-value = "NOK" then do:
        undo, next.
    end.
    /*****************************************************************************/

    run pi-atualiza-documento (output l-erro ) .

    if  l-erro then do:
        undo, next.
    end.

    run pi-erro-nota ( 4070, " " ).

    for each tt-erro:
        delete tt-erro.
    end.

    assign l-erro = no
           docum-est.ce-atual = yes. /* A fatura n∆o atualiza estoque, mas o flag ≤ marcado como yes
                                        pois a exportaá∆o(re0404) somente pega documentos como o flag 
                                        ce-atual = yes */

    FOR EACH docum-est-cex EXCLUSIVE-LOCK
       WHERE docum-est-cex.serie-docto  = docum-est.serie-docto  
         AND docum-est-cex.nro-docto    = docum-est.nro-docto    
         AND docum-est-cex.cod-emitente = docum-est.cod-emitente  
         AND docum-est-cex.nro-docto    = docum-est.nro-docto    
         AND docum-est-cex.nat-operacao = docum-est.nat-operacao:

        FOR EACH item-doc-est-cex EXCLUSIVE-LOCK
           WHERE item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto  
             AND item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto    
             AND item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente  
             AND item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto    
             AND item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao
             AND item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
             AND item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp:

            &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
            ASSIGN item-doc-est-cex.idi-sit-despes  = 1.
            &ELSE
            ASSIGN item-doc-est-cex.int-1           = 1.
            &ENDIF

        END.

        &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
        ASSIGN docum-est-cex.idi-sit-despes  = 1.
        &ELSE
        ASSIGN docum-est-cex.int-1           = 1.
        &ENDIF
        
        assign docum-est-cex.log-2 = yes.

    END.
    /*speto*/
     
  
    /* Para documentos de gastos de aduana com fornecedor generico */
    FOR EACH docum-est-cex NO-LOCK
       WHERE docum-est-cex.serie-docto  = docum-est.serie-docto  
         AND docum-est-cex.nro-docto    = docum-est.nro-docto    
         AND docum-est-cex.cod-emitente = docum-est.cod-emitente  
         AND docum-est-cex.nro-docto    = docum-est.nro-docto    
         AND docum-est-cex.nat-operacao = docum-est.nat-operacao: /*doc est cex im0994*/

        FOR EACH item-doc-est-cex NO-LOCK
           WHERE item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto  
             AND item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto    
             AND item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente    
             AND item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao
             AND item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
             AND item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp: /*item doc est cex im0994*/

            for each item-doc-est no-lock
               where item-doc-est.serie-docto  = docum-est.serie-docto
                 and item-doc-est.nro-docto    = docum-est.nro-docto
                 and item-doc-est.cod-emitente = docum-est.cod-emitente
                 and item-doc-est.nat-operacao = docum-est.nat-operacao:   /*item doc est criado im0994*/

                FIND FIRST bf-item-doc-est-cex  
                     WHERE bf-item-doc-est-cex.serie-docto  = item-doc-est.serie-comp       AND
                           bf-item-doc-est-cex.nro-docto    = item-doc-est.nro-comp         AND
                           bf-item-doc-est-cex.cod-emitente = item-doc-est.fornec-comp      AND
                           bf-item-doc-est-cex.nat-operacao = item-doc-est.nat-comp         AND
                           bf-item-doc-est-cex.sequencia    = item-doc-est-cex.num-seq-orig AND
                           bf-item-doc-est-cex.embarque     = item-doc-est-cex.embarque     AND 
                           bf-item-doc-est-cex.cod-desp     = item-doc-est-cex.cod-desp  NO-LOCK NO-ERROR. /* item doc est cex orig*/

                IF AVAIL bf-item-doc-est-cex THEN DO:                

                    FIND FIRST bfdocum-est-cex exclusive-LOCK
                         WHERE bfdocum-est-cex.cod-emitente = bf-item-doc-est-cex.cod-emitente
                           AND bfdocum-est-cex.serie-docto  = bf-item-doc-est-cex.serie-docto
                           AND bfdocum-est-cex.nro-docto    = bf-item-doc-est-cex.nro-docto
                           AND bfdocum-est-cex.nat-operacao = bf-item-doc-est-cex.nat-operacao
                           AND bfdocum-est-cex.cod-desp     = bf-item-doc-est-cex.cod-desp no-error. /*desp doc orig*/

                    IF AVAIL bfdocum-est-cex THEN DO:
                        ASSIGN bfdocum-est-cex.log-2 = yes.
                    END.
                END.
            END.
        END.
    END.   

     
    /*****************************************************************************/    
    /** Chamada UPC no final da Atualizaá∆o                                     **/
    /*****************************************************************************/

    for each tt-epc where tt-epc.cod-event = "fim-atualizacao":
       delete tt-epc.
    end.

    create tt-epc.
    assign tt-epc.cod-event     = "fim-atualizacao"
           tt-epc.cod-parameter = "docum-est rowid"
           tt-epc.val-parameter = string(rowid(docum-est)).

    {include/i-epc201.i "fim-atualizacao"}     

    if  return-value = "NOK" then 
        undo, next.
    /*****************************************************************************/

end.        

{utp/ut-liter.i Finalizando_Atualizaá∆o MRE R}
assign c-texto1 = return-value.
run pi-acompanhar in h-acomp (input c-texto1).

{include/i-rpclo.i}

if  valid-handle(h-acomp) then
    run pi-finalizar in h-acomp.

if  l-ems50 and 
not l-ja-conectado then
    run pi-conecta-ems50 ( 2 ). 

IF  VALID-HANDLE (h-btb009za) THEN DO:
    IF  h-btb009za:TYPE <> "PROCEDURE":U 
    OR  h-btb009za:FILE-NAME <> "btb/h-btb009za.p":U THEN
        DELETE PROCEDURE h-btb009za.
END.


RETURN "OK":U.

{rep/re1005.i}

/* --------------------  PROCEDURES INTERNAS DO PROGRAMA  ------------------- */

Procedure pi-atualiza-documento:

    def output param l-erro-doc   as logical no-undo.

    for each consist-nota {cdp/cd8900.i consist-nota docum-est} exclusive-lock:
        delete consist-nota.
    end.

    find first tt-total no-error.
    assign docum-est.tot-valor-me     = tt-total.tot-valor-fat
           docum-est.valor-mercad-me  = tt-total.valor-mercad-fat
           docum-est.tot-taxa-me      = tt-total.tot-taxa-fat
           docum-est.dec-2            = tt-total.taxa-inc-fat
           docum-est.tot-desconto-me  = tt-total.tot-desconto-fat
           docum-est.despesa-nota-me  = tt-total.despesa-nota-fat
           docum-est.tot-valor        = FN_AJUST_DEC(docum-est.tot-valor-me     * docum-est.cotacao-dia, 0)
           docum-est.valor-mercad     = FN_AJUST_DEC(docum-est.valor-mercad-me  * docum-est.cotacao-dia, 0)
           docum-est.tot-taxa         = FN_AJUST_DEC(docum-est.tot-taxa-me      * docum-est.cotacao-dia, 0) 
           docum-est.dec-1            = FN_AJUST_DEC(docum-est.dec-2            * docum-est.cotacao-dia, 0)
           docum-est.tot-desconto     = FN_AJUST_DEC(docum-est.tot-desconto-me  * docum-est.cotacao-dia, 0)  
           docum-est.despesa-nota     = FN_AJUST_DEC(docum-est.despesa-nota-me  * docum-est.cotacao-dia, 0).

    assign l-dif-desconto = tt-total.tot-desconto-dif <> 0
           l-dif-preco    = tt-total.valor-mercad-dif <> 0. 

    run pi-gera-dupli-apagar.

    run pi-gera-dupli-imp.

    for each tt-epc 
       where tt-epc.cod-event = "End-Tax-Calculation" :
        delete tt-epc.
    end.

    /* Chamada EPC para geracao dos impostos na localizacao*/
    create tt-epc.
    assign tt-epc.cod-event     = "End-Tax-Calculation"
           tt-epc.cod-parameter = "rowid(docum-est)"
           tt-epc.val-parameter = string(rowid(docum-est)).

    {include/i-epc201.i "End-Tax-Calculation"}

    /* Geracao de Movimentos na Conciliacao - Release 2.02 */ 
    &if defined(bf_mat_variacao_compras) &then

         /*** Processo de Rateio da variaá∆o da despesas entre os itens ***/
         if  docum-est.fat-despesa = yes then do:
             for each fat-despesa of docum-est no-lock:
                 assign de-val-tot = 0.
                 for each item-doc-est of docum-est where
                          item-doc-est.cod-despesa = fat-despesa.cod-despesa no-lock :
                     assign de-val-tot = de-val-tot + item-doc-est.preco-total-me.
                 end.
                 assign de-vl-diferenca = fat-despesa.vl-despesa - de-val-tot /*de-tot-despesa*/.

                 if  de-vl-diferenca <> 0 then do: /*variacao preco - necessario rateio*/
                     for each item-doc-est of docum-est where
                              item-doc-est.cod-despesa = fat-despesa.cod-despesa no-lock:

                         assign de-val-aux = item-doc-est.preco-total-me + /* + variacao*/
                                            (item-doc-est.preco-total-me *
                                            de-vl-diferenca / de-val-tot /*de-tot-despesa*/).
                         find despesa where
                              despesa.cod-despesa = fat-despesa.cod-despesa no-lock no-error.

                         run pi-consiste-nota (input yes, input 5529, /* Seq:&1 Item:&2 - Diferenca Preco*/
                                               input item-doc-est.cod-despesa + " ~~ " + despesa.des-despesa,
                                               input item-doc-est.sequencia,
                                               input (de-val-aux * docum-est.cotacao-dia),
                                               input (item-doc-est.preco-total-me * docum-est.cotacao-dia),
                                               input 1).
                     end.
                 end.
             end.
         end.


     /***INI******************************/
         FOR EACH item-doc-est EXCLUSIVE-LOCK {cdp/cd8900.i item-doc-est docum-est}
              AND item-doc-est.cod-despesa  > "":U
              AND item-doc-est.nro-comp     = "":U
              AND item-doc-est.serie-comp   = "":U
              AND item-doc-est.nat-comp     = "":U
             BREAK BY item-doc-est.seq-comp :

             FIND despesa WHERE
                  despesa.cod-despesa = item-doc-est.cod-despesa NO-LOCK NO-ERROR.
             IF  NOT AVAIL despesa THEN NEXT.

            IF  despesa.num-livre-1 = 4 OR   /*Sem Rateio*/
                 despesa.num-livre-1 = 0 THEN /*Garantir Integridade*/
                 NEXT.

             ASSIGN tot-despesa = preco-total[1].

             RUN pi-consiste-nota (INPUT YES,
                                   INPUT 28228,
                                   INPUT STRING(item-doc-est.seq-comp) + "~~" + item-doc-est.it-codigo,
                                   INPUT item-doc-est.sequencia,
                                   INPUT tot-despesa,
                                   INPUT ?,
                                   INPUT 1).
         END.

         /* Para despesas parametrizadas como "SEM RATEIO" */
         FOR EACH item-doc-est of docum-est
            WHERE item-doc-est.it-codigo   = "":U
              AND item-doc-est.cod-despesa > "":U
              AND item-doc-est.seq-comp    = 0 NO-LOCK:

             RUN pi-gera-tt-movto-despesa (INPUT item-doc-est.cod-despesa,
                                           INPUT item-doc-est.preco-total[1],
                                           /*INPUT item-doc-est.conta-contabil*/
                                           INPUT item-doc-est.ct-codigo,
                                           INPUT item-doc-est.sc-codigo).

         END.

     /***FIM******************************/
         /* Verifica se o usuario esta parametrizado para gerar movimento 
            para as diferencas de Desconto e Preco */
         if  param-re.gera-ce-fatura 
             &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
                OR docum-est.log-entreg-fut
             &ENDIF
         then do:
                                   
             for each consist-nota {cdp/cd8900.i consist-nota docum-est} 
                 and can-do("5528,5529,26709", string(consist-nota.mensagem)) no-lock
                 break by consist-nota.int-1 /* Sequencia */:

                 /* Acha o item da fatura */        
                 find item-doc-est
                     where item-doc-est.cod-emitente = docum-est.cod-emitente
                       and item-doc-est.nro-docto    = docum-est.nro-docto
                       and item-doc-est.serie-docto  = docum-est.serie-docto
                       and item-doc-est.nat-operacao = docum-est.nat-operacao
                       and item-doc-est.sequencia    = consist-nota.int-1  no-lock no-error.

                 /*************************/

                 IF  item-doc-est.cod-despesa > "":U THEN DO:

                     /*localiza a despesa do remito com o fornecedor da fatura e n∆o do remito*/
                     FIND b-item-doc-est WHERE
                          b-item-doc-est.cod-emitente = item-doc-est.fornec-comp AND
                          b-item-doc-est.serie-docto  = item-doc-est.serie-comp  AND
                          b-item-doc-est.nro-docto    = item-doc-est.nro-comp    AND
                          b-item-doc-est.nat-operacao = item-doc-est.nat-comp    AND
                          b-item-doc-est.sequencia    = item-doc-est.seq-comp NO-LOCK NO-ERROR.

                     IF  NOT AVAIL b-item-doc-est THEN DO:

                         FIND b-item-doc-est WHERE /*despesa adicional*/
                              b-item-doc-est.cod-emitente = item-doc-est.cod-emitente AND
                              b-item-doc-est.serie-comp   = "":U                      AND
                              b-item-doc-est.nro-comp     = "":U                      AND
                              b-item-doc-est.nat-comp     = "":U                      AND
                              b-item-doc-est.it-codigo    = item-doc-est.it-codigo    AND
                              b-item-doc-est.sequencia    = item-doc-est.sequencia    AND
                              b-item-doc-est.cod-despesa  = item-doc-est.cod-despesa  NO-LOCK NO-ERROR.
                     END.         
                 END.

                 ELSE DO:

                     FIND b-item-doc-est WHERE
                          b-item-doc-est.cod-emitente = item-doc-est.cod-emitente AND
                          b-item-doc-est.serie-docto  = item-doc-est.serie-comp   AND
                          b-item-doc-est.nro-docto    = item-doc-est.nro-comp     AND
                          b-item-doc-est.nat-operacao = item-doc-est.nat-comp     AND
                          b-item-doc-est.sequencia    = item-doc-est.seq-comp     NO-LOCK NO-ERROR.

                     IF  NOT AVAIL b-item-doc-est THEN DO:

                         FIND b-item-doc-est WHERE /*item adicional*/
                              b-item-doc-est.nro-docto    = item-doc-est.nro-docto AND
                              b-item-doc-est.it-codigo    = item-doc-est.it-codigo AND 
                              b-item-doc-est.cod-despesa  = "":U                   AND
                              b-item-doc-est.nro-comp     = "":U                   AND
                              b-item-doc-est.seq-comp     = 0                      AND 
                              b-item-doc-est.sequencia    = item-doc-est.sequencia NO-LOCK NO-ERROR.

                         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
                             IF  NOT AVAIL b-item-doc-est AND docum-est.log-entreg-fut THEN 
                                 /* Acha o item da fatura */
                                 FIND b-item-doc-est WHERE 
                                      b-item-doc-est.cod-emitente = item-doc-est.cod-emitente AND
                                      b-item-doc-est.nro-docto    = item-doc-est.nro-docto    AND
                                      b-item-doc-est.serie-docto  = item-doc-est.serie-docto  AND
                                      b-item-doc-est.nat-operacao = item-doc-est.nat-operacao AND
                                      b-item-doc-est.sequencia    = consist-nota.int-1        NO-LOCK NO-ERROR.
                         &ENDIF
                     END.
                 END.

                 /*************************/

                 if  avail b-item-doc-est then do:

                     find b-docum-est {cdp/cd8900.i b-docum-est b-item-doc-est} no-lock no-error.
                     find first rat-lote {cdp/cd8900.i rat-lote b-item-doc-est} no-lock no-error.

                     find item
                         where item.it-codigo = b-item-doc-est.it-codigo no-lock no-error.

                     if  first-of(consist-nota.int-1) then 
                         assign de-vl-diferenca = 0. /* Zera o valor da diferenca */

                     if  avail rat-lote then
                         assign c-cod-depos   = rat-lote.cod-depos
                                c-cod-localiz = rat-lote.cod-localiz
                                c-lote        = rat-lote.lote 
                                da-validade   = rat-lote.dt-vali-lote.
                     else
                         assign c-cod-depos   = item.deposito-pad
                                c-cod-localiz = item.cod-localiz.

                     /* Item com Controle por Lote ou Referencia */
                     if  not avail rat-lote
                     and can-do("3,4", string(item.tipo-con-est)) then do:
                         find last saldo-estoq use-index item-lote
                             where saldo-estoq.cod-estabel = docum-est.cod-estabel
                               and saldo-estoq.it-codigo   = item-doc-est.it-codigo 
                               and saldo-estoq.cod-refer   = item-doc-est.cod-refer
                             no-lock no-error.

                         if  avail saldo-estoq then 
                             assign c-lote      = saldo-estoq.lote 
                                    da-validade = saldo-estoq.dt-vali-lote.
                         else 
                             assign da-validade = 12/31/9999.                   
                     end.

                     /* Item com Controle por N£mero SÇrie */
                     &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
                         IF  item.tipo-con-est = 2
                         AND docum-est.log-entreg-fut THEN
                            ASSIGN c-lote = "12319999".
                     &ENDIF

                     assign de-vl-diferenca = de-vl-diferenca
                                            + if  (consist-nota.mensagem = 5529 or
                                                   consist-nota.mensagem = 26709) /* Diferenca Preco */
                                              then consist-nota.informado - consist-nota.calculado
                                              /* Diferenca Desconto (5528) */
                                              else consist-nota.calculado - consist-nota.informado.

                     /* Gera movimento na ultima consistencia do item */
                     if  last-of(consist-nota.int-1) then do:

                         if  de-vl-diferenca = 0 then /* Variacao acumulada zero */
                             next.

                         run pi-gera-tt-movto ( de-vl-diferenca > 0 ).

                     end. 
                 end.    
             end.

             run pi-gera-movto-estoq ( output l-erro-movto ).

             assign l-erro-doc = if  l-erro-movto
                                 then yes
                                 else l-erro-doc.

         end.                        
         else do:
            /* Gera movimento para as diferencas de Desconto e Preco */
            for each consist-nota {cdp/cd8900.i consist-nota docum-est} 
                and can-do("26709", string(consist-nota.mensagem)) no-lock
                break by consist-nota.int-1 /* Sequencia */:

                /* fatura */
                find item-doc-est
                    where item-doc-est.cod-emitente = docum-est.cod-emitente
                      and item-doc-est.nro-docto    = docum-est.nro-docto
                      and item-doc-est.serie-docto  = docum-est.serie-docto
                      and item-doc-est.nat-operacao = docum-est.nat-operacao
                      and item-doc-est.sequencia    = consist-nota.int-1  no-lock no-error.

                /* remito */
                find b-item-doc-est
                    where b-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                      and b-item-doc-est.nro-docto    = item-doc-est.nro-comp
                      and b-item-doc-est.serie-docto  = item-doc-est.serie-comp
                      and b-item-doc-est.nat-operacao = item-doc-est.nat-comp
                      and b-item-doc-est.sequencia    = item-doc-est.seq-comp no-lock no-error.

                if  avail b-item-doc-est then do:
                    find b-docum-est {cdp/cd8900.i b-docum-est b-item-doc-est} no-lock no-error.

                    if  first-of(consist-nota.int-1) then 
                        assign de-vl-diferenca = 0. /* Zera o valor da diferenca */

                    find item where item.it-codigo = "" no-lock no-error. 

                    assign c-cod-depos   = item.deposito-pad
                           c-cod-localiz = item.cod-localiz.

                    assign de-vl-diferenca = de-vl-diferenca
                                           + consist-nota.informado - consist-nota.calculado.

                    /* Gera movimento na ultima consistencia do item */
                    if  last-of(consist-nota.int-1) then do:

                        if  de-vl-diferenca = 0 then /* Variacao acumulada zero */
                            next.

                        run pi-gera-tt-movto-debito-direto ( de-vl-diferenca > 0 ).

                    end. 
                end.    
            end.

            run pi-gera-movto-estoq ( output l-erro-movto ).

            assign l-erro-doc = if  l-erro-movto
                                then yes
                                else l-erro-doc.

         END.
     /***INI***************************************************/
         for each consist-nota {cdp/cd8900.i consist-nota docum-est}
             and can-do("28228", string(consist-nota.mensagem)) no-lock
             break by consist-nota.int-1 /* Sequencia da Despesa */:

             assign de-vl-diferenca = consist-nota.calculado.

             /*Acha a despesa adicional*/
             FIND b2-item-doc-est
                  WHERE b2-item-doc-est.cod-emitente = docum-est.cod-emitente
                    AND b2-item-doc-est.nro-docto    = docum-est.nro-docto
                    AND b2-item-doc-est.serie-docto  = docum-est.serie-docto
                    AND b2-item-doc-est.nat-operacao = docum-est.nat-operacao
                    AND b2-item-doc-est.sequencia    = consist-nota.int-1 NO-LOCK NO-ERROR.

             /* Acha o item da fatura */
             find item-doc-est
                  where item-doc-est.cod-emitente = b2-item-doc-est.cod-emitente
                    and item-doc-est.nro-docto    = b2-item-doc-est.nro-docto
                    and item-doc-est.serie-docto  = b2-item-doc-est.serie-docto
                    and item-doc-est.nat-operacao = b2-item-doc-est.nat-operacao
                    and item-doc-est.sequencia    = b2-item-doc-est.seq-comp no-lock no-error.

             /* Acha o item do remito */
             find b-item-doc-est
                  where b-item-doc-est.cod-emitente = item-doc-est.cod-emitente
                    and b-item-doc-est.nro-docto    = item-doc-est.nro-comp
                    and b-item-doc-est.serie-docto  = item-doc-est.serie-comp
                    and b-item-doc-est.nat-operacao = item-doc-est.nat-comp
                    and b-item-doc-est.sequencia    = item-doc-est.seq-comp no-lock no-error.

             IF  AVAIL b-item-doc-est THEN DO:

                 FIND b-docum-est {cdp/cd8900.i b-docum-est b-item-doc-est} NO-LOCK NO-ERROR.
                 FIND ITEM WHERE ITEM.it-codigo = b-item-doc-est.it-codigo NO-LOCK NO-ERROR.

                 ASSIGN de-valor-total = 0.

                 FOR EACH rat-lote {cdp/cd8900.i rat-lote b-item-doc-est}
                      AND rat-lote.it-codigo = item-doc-est.it-codigo
                      AND rat-lote.sequencia = item-doc-est.seq-comp NO-LOCK:

                     assign c-cod-depos   = rat-lote.cod-depos
                            c-cod-localiz = rat-lote.cod-localiz
                            c-lote        = rat-lote.lote 
                            da-validade   = rat-lote.dt-vali-lote.

                     /* Item com Controle por Lote ou Referencia */
                     IF  CAN-DO("3,4", STRING(ITEM.tipo-con-est)) THEN DO:
                         FIND LAST saldo-estoq USE-INDEX item-lote
                             WHERE saldo-estoq.it-codigo   = item-doc-est.it-codigo 
                               AND saldo-estoq.cod-refer   = item-doc-est.cod-refer
                               AND saldo-estoq.cod-estabel = docum-est.cod-estabel
                               AND saldo-estoq.lote        = c-lote
                             NO-LOCK NO-ERROR.

                         IF  AVAIL saldo-estoq THEN 
                             ASSIGN c-lote      = saldo-estoq.lote
                                    da-validade = saldo-estoq.dt-vali-lote.
                         ELSE 
                             ASSIGN da-validade = 12/31/9999.
                     END.

                     &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
                        IF b-item-doc-est.dec-1 > 0 THEN
                            ASSIGN de-valor = ROUND(de-vl-diferenca / b-item-doc-est.dec-1 * rat-lote.quantidade,2).
                        ELSE
                            ASSIGN de-valor = ROUND(de-vl-diferenca / b-item-doc-est.quantidade * rat-lote.quantidade,2).
                     &ELSE
                        ASSIGN de-valor = ROUND(de-vl-diferenca / b-item-doc-est.quantidade * rat-lote.quantidade,2).
                     &ENDIF

                     /* Valida Saldo */
                     IF  item.tipo-contr <> 1 AND        /*Fisico*/
                         item.tipo-contr <> 4 THEN DO:   /*Debito Direto*/

                         /* Se tipo de controle do item for TOTAL e existir uma ORDEM *
                          * DE PRODUÄ«O para o item, n∆o precisa validar saldo deste  */
                         IF  NOT (item.tipo-contr = 2 AND
                                  item-doc-est.nr-ord-produ <> 0) THEN DO:
                             FIND estab-mat NO-LOCK WHERE 
                                  estab-mat.cod-estabel = docum-est.cod-estabel NO-ERROR.                                
                             FIND FIRST item-uni-estab
                                  WHERE item-uni-estab.it-codigo = item-doc-est.it-codigo
                                    AND item-uni-estab.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
                             IF  AVAIL estab-mat AND AVAIL item-uni-estab THEN DO:
                                 IF  NOT estab-mat.usa-on-line OR
                                     (item-uni-estab.metodo-custeio <> 6 AND
                                     item-uni-estab.metodo-custeio <> 1) THEN DO:
                                     FIND FIRST saldo-estoq USE-INDEX item-lote
                                          WHERE saldo-estoq.it-codigo   = item-uni-estab.it-codigo
                                            AND saldo-estoq.cod-estabel = item-uni-estab.cod-estabel
                                            AND saldo-estoq.lote        = c-lote
                                            AND saldo-estoq.cod-refer   = item-doc-est.cod-refer
                                            AND saldo-estoq.qtidade-atu > 0 NO-LOCK NO-ERROR.
                                     IF  NOT AVAIL saldo-estoq THEN DO:
                                         RUN pi-erro-nota ( 28314, item-doc-est.it-codigo   + "~~" + STRING(item-doc-est.sequencia) ).
                                         ASSIGN l-erro-doc = YES.
                                         RETURN "NOK":U.
                                     END.
                                 END.
                                 ELSE DO:
                                     FIND FIRST saldo-custo USE-INDEX ch-item
                                          WHERE saldo-custo.it-codigo   = item-uni-estab.it-codigo
                                            AND saldo-custo.cod-estabel = item-uni-estab.cod-estabel
                                            AND saldo-custo.lote        = c-lote
                                            AND saldo-custo.cod-refer   = item-doc-est.cod-refer
                                            AND saldo-custo.qt-saldo    > 0 NO-LOCK NO-ERROR.
                                     IF  NOT AVAIL saldo-custo THEN DO:
                                         RUN pi-erro-nota ( 28314, item-doc-est.it-codigo   + "~~" + STRING(item-doc-est.sequencia) ).
                                         ASSIGN l-erro-doc = YES.
                                         RETURN "NOK":U.
                                     END.
                                 END.
                             END.
                         END.
                     END.
                     /* ********************* */
                     run pi-gera-tt-movto-rateio (input de-valor,
                                                  input c-cod-depos,
                                                  input c-cod-localiz,
                                                  input c-lote).

                     /*Tratamento de Arredondamento*/
                     assign de-valor-total = de-valor-total
                                           + de-valor.

                     if  de-valor-max < de-valor then
                         assign de-valor-max = de-valor
                                r-tt-movto   = rowid(tt-movto).
                 end. /*rat-lote*/

                 IF  de-valor-total <> de-vl-diferenca THEN DO:
                     FIND tt-movto WHERE ROWID(tt-movto) = r-tt-movto NO-ERROR.
                     IF  NOT AVAIL tt-movto THEN NEXT. 
                     IF  de-valor-total > de-vl-diferenca THEN
                         ASSIGN tt-movto.valor-mat-m[1] = tt-movto.valor-mat-m[1]
                                                        - (de-valor-total - de-vl-diferenca).
                     ELSE
                         ASSIGN tt-movto.valor-mat-m[1] = tt-movto.valor-mat-m[1]
                                                        + (de-vl-diferenca - de-valor-total).
                 END.
             END. /*b-item-doc-est*/
         END. /*consist-nota*/

         run pi-gera-movto-estoq ( output l-erro-movto ).

         assign l-erro-doc = if   l-erro-movto then yes
                             else l-erro-doc.
     /***FIM***************************************************/
    &endif

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
        IF docum-est.log-entreg-fut THEN DO:

            FOR EACH item-doc-est EXCLUSIVE-LOCK {cdp/cd8900.i item-doc-est docum-est}:
                RUN cdp/cd4398.p(INPUT NO,
                                 INPUT ROWID(item-doc-est),
                                 INPUT docum-est.dt-trans,
                                 OUTPUT rw-saldo-terc,
                                 INPUT-OUTPUT TABLE tt-erro).

                FOR EACH tt-erro:
                    IF NOT l-erro-doc THEN
                        assign l-erro-doc = yes.

                    if line-counter > 62 then
                        page.

                    if line-counter <= 5 then do:
                        put c-cabec1 at 0 skip.
                        put c-cabec2 at 0 skip.
                    end.

                    put docum-est.serie-docto at 1.
                    put docum-est.nro-docto   at 7.
                    put string(docum-est.cod-emitente) at 24 format "x(9)".
                    put docum-est.nat-operacao at 35.
                    put string(tt-erro.cd-erro,">>>>>9") at 43.
                    put tt-erro.mensagem at 53 format "X(78)" skip.
                END.
            END.

            FIND estab-mat NO-LOCK WHERE 
                estab-mat.cod-estabel = docum-est.cod-estabel NO-ERROR.
            IF AVAILABLE estab-mat and
               estab-mat.usa-on-line THEN DO:
                FOR EACH movto-estoq NO-LOCK WHERE
                    movto-estoq.serie-docto  = docum-est.serie-docto  AND
                    movto-estoq.nro-docto    = docum-est.nro-docto    AND
                    movto-estoq.cod-emitente = docum-est.cod-emitente AND
                    movto-estoq.nat-operacao = docum-est.nat-operacao AND
                    movto-estoq.quantidade   > 0                      AND
                    movto-estoq.tipo-trans   = 2 /* saida */ :

                    IF CAN-FIND(FIRST saldo-terc WHERE
                                      saldo-terc.serie-docto  = movto-estoq.serie-docto  AND
                                      saldo-terc.nro-docto    = movto-estoq.nro-docto    AND
                                      saldo-terc.cod-emitente = movto-estoq.cod-emitente AND
                                      saldo-terc.nat-operacao = movto-estoq.nat-operacao AND
                                      saldo-terc.it-codigo    = movto-estoq.it-codigo    AND
                                      saldo-terc.cod-refer    = movto-estoq.cod-refer    AND
                                      saldo-terc.sequencia    = movto-estoq.sequen-nf    AND
                                      (saldo-terc.valor-mat-o[1] +
                                       saldo-terc.valor-mob-o[1] +
                                       saldo-terc.valor-ggf-o[1]) = 0) THEN DO:
                        FOR EACH saldo-terc EXCLUSIVE-LOCK WHERE
                            saldo-terc.serie-docto  = movto-estoq.serie-docto  AND
                            saldo-terc.nro-docto    = movto-estoq.nro-docto    AND
                            saldo-terc.cod-emitente = movto-estoq.cod-emitente AND
                            saldo-terc.nat-operacao = movto-estoq.nat-operacao AND
                            saldo-terc.it-codigo    = movto-estoq.it-codigo    AND
                            saldo-terc.cod-refer    = movto-estoq.cod-refer    AND
                            saldo-terc.sequencia    = movto-estoq.sequen-nf    AND
                            (saldo-terc.valor-mat-o[1] +
                             saldo-terc.valor-mob-o[1] +
                             saldo-terc.valor-ggf-o[1]) = 0:
                            DO i-cont-aux = 1 TO 3:
                           		assign saldo-terc.valor-mat-o[i-cont-aux] = (movto-estoq.valor-mat-o[i-cont-aux]  / movto-estoq.quantidade)
                              		   saldo-terc.valor-mob-o[i-cont-aux] = (movto-estoq.valor-mob-o[i-cont-aux]  / movto-estoq.quantidade)
                                  	   saldo-terc.valor-ggf-o[i-cont-aux] = (movto-estoq.valor-ggf-o[i-cont-aux]  / movto-estoq.quantidade).
                            END.
                        END.
                    END.
                END.
            END.
        END.
    &ENDIF
    
    /* ATUALIZACAO DAS DUPLICATAS - AP */
    if  param-global.modulo-ap 
    and param-estoq.gera-ap = 1
    and not docum-est.ap-atual 
    and docum-est.nff          then 
    do:
        {utp/ut-liter.i Atualizando_Contas_Pagar  MRE R}
        assign c-texto2      = return-value
               c-prog-concil = "im0994".

        run pi-acompanhar in h-acomp (input c-texto2 ).
        run rep/re9340.p ( input rowid(docum-est),
                           input l-usa-mp,
                           output l-erro-ap,
                           input-output table tt-lin-i-ap,
                           input-output table tt-lin-conta-ap,
                           input-output table tt-impto-tit-pend-ap,
                           input-output de-val-tot,
                           input-output table tt-erro ).

        assign l-erro-doc = if  l-erro-ap
                            then yes
                            else l-erro-doc.

        if line-counter <= 5 then do:
            put c-cabec1 at 0 skip.
            put c-cabec2 at 0 skip.
        end.

        for each tt-erro :
            assign l-erro-doc = yes.
            put docum-est.serie-docto at 1.
            put docum-est.nro-docto   at 7.
            put string(docum-est.cod-emitente,">>>>>9") at 24.
            put docum-est.nat-operacao at 32.
            put string(tt-erro.cd-erro,">>>>>9") at 42.
            put tt-erro.mensagem at 50 format "X(80)" skip.

        end.

        if  not docum-est.ap-atual and l-erro-ap = no then
            assign docum-est.ap-atual = yes.

    end.

    /* Atualiza a situacao da fatura do remito */ 
    run pi-atualiza-fatura-despesa.

    if  docum-est.ap-atual 
    and docum-est.sit-docum = 1 
    and not l-erro-doc then do:  /* Fatura liberada para pagamento */
        run utp/ut-msgs.p ("msg", 5530, "").
        put docum-est.serie-docto at 1.
        put docum-est.nro-docto   at 7.
        put string(docum-est.cod-emitente,">>>>>9") at 24.
        put docum-est.nat-operacao at 32.
        put string(5530,">>>>>9") at 42.
        put return-value at 50 format "X(80)" skip.
    end.


End Procedure. /*pi-atualiza-documento*/


Procedure pi-gera-dupli-apagar:

    def var de-total-doc as decimal no-undo.
    def var de-total-dif as decimal no-undo.
    def var i-parcela    as integer no-undo.
    /* Elimina geracoes anteriores */
    for each dupli-apagar
       where dupli-apagar.cod-emitente = docum-est.cod-emitente
         and dupli-apagar.nat-operacao = docum-est.nat-operacao 
         and dupli-apagar.serie-docto  = docum-est.serie-docto 
         and dupli-apagar.nro-docto    = docum-est.nro-docto EXCLUSIVE-LOCK:
        delete dupli-apagar.
    end.

    for each tt-epc 
       where tt-epc.cod-event = "Before-Invoice-Generation" :
        delete tt-epc.
    end.

    /* Chamada EPC para geracao dos impostos na localizacao*/
    create tt-epc.
    assign tt-epc.cod-event     = "Before-Invoice-Generation"
           tt-epc.cod-parameter = "rowid(docum-est)"
           tt-epc.val-parameter = string(rowid(docum-est)).

    {include/i-epc201.i "Before-Invoice-Generation"}

    find cond-pagto 
        where cond-pagto.cod-cond-pag = tt-total.cod-cond-pag no-lock no-error.

    assign da-data    = today
           da-partida = docum-est.dt-emissao.

    {cdp/cd9020.i7 docum-est.cod-estabel}

    assign i-empresa = param-global.empresa-prin.

    &if defined (bf_dis_consiste_conta) &then

        find estabelec where
             estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.

        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).
    &endif    

    do  i-ind = 1 to cond-pagto.num-parcelas:
        assign i-parcela = i-parcela + 1.
        create dupli-apagar.
        assign dupli-apagar.ep-codigo         = i-empresa
               dupli-apagar.cod-estabel       = docum-est.cod-estabel
               dupli-apagar.cod-emitente      = docum-est.cod-emitente
               dupli-apagar.dt-emissao        = docum-est.dt-emissao
               dupli-apagar.dt-trans          = docum-est.dt-trans
               dupli-apagar.dt-vencim         = da-data[i-ind]
               dupli-apagar.esp-movto         = 1
               dupli-apagar.nat-operacao      = docum-est.nat-operacao
               dupli-apagar.nro-docto         = docum-est.nro-docto
               dupli-apagar.parcela           = string(i-parcela)
               dupli-apagar.serie-docto       = docum-est.serie-docto
               dupli-apagar.nr-duplic         = docum-est.nro-docto
               dupli-apagar.tp-despesa        = tt-total.tp-despesa
               dupli-apagar.cod-esp           = tt-total.cod-esp
               dupli-apagar.observacao        = IF tt-digita.narrativa = ? THEN "" ELSE tt-digita.narrativa.

        if i-pais-impto-usuario = 7 /* Chile */ then do:
            assign dupli-apagar.valor-a-pagar-me  = docum-est.tot-valor-me 
                                                  * (cond-pagto.per-pg-dup[i-ind] / 100)
                   dupli-apagar.dec-2             = tt-total.tot-valor-dif                 /*diferenªa-me*/
                                                  * (cond-pagto.per-pg-dup[i-ind] / 100)
                   dupli-apagar.vl-a-pagar        = FN_VLD_AJUST_DEC(dupli-apagar.valor-a-pagar-me * docum-est.cotacao-dia, 0)
                   dupli-apagar.dec-1             = FN_VLD_AJUST_DEC(dupli-apagar.dec-2 * docum-est.cotacao-dia, 0)  /*diferenca*/
                   rw-duplicata                   = rowid(dupli-apagar)
                   de-total-doc                   = de-total-doc + dupli-apagar.vl-a-pagar
                   de-total-dif                   = de-total-dif + dupli-apagar.dec-2.
        end.
        else do:
            assign dupli-apagar.valor-a-pagar-me  = FN_VLD_AJUST_DEC((tt-total.tot-valor-fat 
                                                  * cond-pagto.per-pg-dup[i-ind] / 100), docum-est.mo-codigo)
                   dupli-apagar.dec-2             = FN_VLD_AJUST_DEC((tt-total.tot-valor-dif                 /*diferenªa-me*/
                                                  * cond-pagto.per-pg-dup[i-ind] / 100), docum-est.mo-codigo)
                   dupli-apagar.vl-a-pagar        = FN_VLD_AJUST_DEC(dupli-apagar.valor-a-pagar-me * docum-est.cotacao-dia, 0)
                   dupli-apagar.dec-1             = FN_VLD_AJUST_DEC(dupli-apagar.dec-2 * docum-est.cotacao-dia, 0)  /*diferenca*/
                   rw-duplicata                   = rowid(dupli-apagar)
                   de-total-doc                   = de-total-doc + dupli-apagar.valor-a-pagar-me
                   de-total-dif                   = de-total-dif + dupli-apagar.dec-2.
        end.
    end.

    /* Para acertar diferenca de arrendondamente em uma duplicata qualquer */
    if  rw-duplicata <> ? then do:
        {utp/ut-liter.i "Valor arredondado nesta duplicata." MRE R}
        find dupli-apagar where rowid(dupli-apagar) = rw-duplicata EXCLUSIVE-LOCK no-error.

        if i-pais-impto-usuario = 7 /* Chile */ then do:
            if de-total-doc <> docum-est.tot-valor then 
                assign dupli-apagar.vl-a-pagar = dupli-apagar.vl-a-pagar 
                                               + docum-est.tot-valor
                                               - de-total-doc.
        end.
        else do:
            if de-total-doc <> tt-total.tot-valor-fat then 
                assign dupli-apagar.valor-a-pagar-me = dupli-apagar.valor-a-pagar-me 
                                                     + (tt-total.tot-valor-fat - de-total-doc).
        END.

        assign dupli-apagar.vl-a-pagar = fn_ajust_dec(dupli-apagar.valor-a-pagar-me * docum-est.cotacao-dia, 0).
        
        if de-total-dif <> tt-total.tot-valor-dif then 
            assign dupli-apagar.dec-2 = dupli-apagar.dec-2 
                                      + (tt-total.tot-valor-dif - de-total-dif).                                                            

        assign dupli-apagar.dec-1      = fn_ajust_dec(dupli-apagar.dec-2 * docum-est.cotacao-dia, 0)  /*diferenca*/
               dupli-apagar.observacao = dupli-apagar.observacao + CHR(10) +
                                         "Invoice: "     + TRIM(STRING(dupli-apagar.nro-docto))    +
                                         " Ser: "        + TRIM(STRING(dupli-apagar.serie-docto))  +
                                         " Vendor: "     + TRIM(STRING(dupli-apagar.cod-emitente)) +
                                         " Trans Type: " + TRIM(STRING(dupli-apagar.nat-operacao)) +
                                         " Sch: "        + TRIM(STRING(dupli-apagar.parcela)).

    end.

    {cdp/cd4300.i3}
    {rep/re1001c.i50} 
    ASSIGN i-mo-codigo      = docum-est.mo-codigo
           de-vl-a-pagar-mo = docum-est.tot-valor-me
           de-vl-descto-mo  = docum-est.tot-desconto-me.
    {rep/re1001c.i51 "no"}
    {cdp/cd4300.i4  "no" dupli-apagar.char-1}
  


End Procedure. /*pi-gera-dupli-apagar*/ 


Procedure pi-gera-dupli-imp:

    /* Elimina geracoes anteriores */
    for each dupli-imp 
       where dupli-imp.serie-docto  = docum-est.serie-docto
         and dupli-imp.nro-docto    = docum-est.nro-docto    
         and dupli-imp.cod-emitente = docum-est.cod-emitente 
         and dupli-imp.nat-operacao = docum-est.nat-operacao EXCLUSIVE-LOCK:
        delete dupli-imp.
    end.

    find first dupli-apagar
         where dupli-apagar.cod-emitente = docum-est.cod-emitente
           and dupli-apagar.nat-operacao = docum-est.nat-operacao 
           and dupli-apagar.serie-docto  = docum-est.serie-docto 
           and dupli-apagar.nro-docto    = docum-est.nro-docto no-lock no-error.

    for each tt-dupli-imp:
        assign i-parcela-imp = i-parcela-imp + 10.
        find tipo-tax 
             where tipo-tax.cod-tax = tt-dupli-imp.cod-imposto NO-LOCK NO-ERROR.

        create dupli-imp.
        assign dupli-imp.cod-emitente = docum-est.cod-emitente
               dupli-imp.nat-operacao = docum-est.nat-operacao
               dupli-imp.serie-docto  = docum-est.serie-docto
               dupli-imp.nro-docto    = docum-est.nro-docto
               dupli-imp.parcela      = if  avail dupli-apagar 
                                        then dupli-apagar.parcela 
                                        else "1" /* Gera o imposto sempre pra primeira parcela do dupli-apagar */
               dupli-imp.parcela-imp  = string(i-parcela-imp)
               dupli-imp.int-1        = tt-dupli-imp.cod-imposto
               dupli-imp.cod-esp      = tt-total.cod-esp
               dupli-imp.dt-venc-imp  = docum-est.dt-trans
               dupli-imp.tp-codigo    = emitente.tp-desp-padrao
               dupli-imp.aliquota     = tt-dupli-imp.perc-imposto
               dupli-imp.rend-trib    = tt-dupli-imp.vl-base 
               dupli-imp.vl-imposto   = tt-dupli-imp.vl-imposto 
               /*c-conta-imposto        = tt-dupli-imp.conta-imposto*/
               c-ct-imposto           = tt-dupli-imp.ct-imposto
               c-sc-imposto           = tt-dupli-imp.sc-imposto
               de-vl-base-me          = tt-dupli-imp.vl-base-me
               de-vl-imposto-me       = tt-dupli-imp.vl-imposto-me.

        {rep/re9341.i51 "no"}
        {cdp/cd4300.i4  "no" dupli-imp.char-1}

        run pi-chama-dpc-impostos.        

    end.

End Procedure. /*pi-gera-dupli-imp*/ 


Procedure pi-chama-dpc-impostos:

    if  c-nom-prog-dpc-mg97  <> ""
    or  c-nom-prog-appc-mg97 <> "" 
    or  c-nom-prog-upc-mg97  <> ""  then do:

        run rep/re0994e1.p persistent set h_re0994e1.

        /* Envia as tabelas temporarias para o programa re099431.p */
        run pi-assign-tt-dupli-imp     in h_re0994e1 (input table tt-dupli-imp ).

        for each tt-epc 
            where tt-epc.cod-event = "Create-Table-Dupli-Imp" :
            delete tt-epc.
        end.            

        /* Chamada UPC */
        create tt-epc.
        assign tt-epc.cod-event     = "create-table-dupli-imp"
               tt-epc.cod-parameter = "Handle-re0994e1"
               tt-epc.val-parameter = string(h_re0994e1).
        create tt-epc.
        assign tt-epc.cod-event     = "Create-Table-Dupli-Imp"
               tt-epc.cod-parameter = "rowid(dupli-imp)"
               tt-epc.val-parameter = string(rowid(dupli-imp)).
        create tt-epc.
        assign tt-epc.cod-event     = "Create-Table-Dupli-Imp"
               tt-epc.cod-parameter = "num-seq-impto"
               tt-epc.val-parameter = string(tt-dupli-imp.num-seq-impto).

        {include/i-epc201.i "Create-Table-Dupli-Imp"}

    end.

End Procedure. /*pi-chama-dpc-impostos*/


Procedure pi-atualiza-item:

    for each item-doc-est {cdp/cd8900.i item-doc-est docum-est}
         and item-doc-est.cod-despesa = "":U no-lock:

        run rep/re0992a.p ( input rowid(docum-est),
                            input rowid(item-doc-est),
                            input l-dif-desconto,
                            input l-dif-preco ).
    end.

End Procedure. /* pi-atualiza-item */

procedure pi-atualiza-fatura-despesa:

/**********************************************************************************
**  Logica para atualizar a situacao do remito, da fatura, dos itens do remito, dos  
**  itens da fatura e despesas dos itens do remito 
***********************************************************************************/ 

    for each item-doc-est {cdp/cd8900.i item-doc-est docum-est} EXCLUSIVE-LOCK
        break by item-doc-est.fornec-comp /* Leitura de itens por remito */
              by item-doc-est.nro-comp
              by item-doc-est.serie-comp
              by item-doc-est.nat-comp:

        assign item-doc-est.sit-item = 1. /* OK */

        IF  item-doc-est.cod-despesa > "":U THEN DO:
            /* Acha as despesas do item do remito que estao sendo conciliadas */
            FOR EACH  desp-item-doc-est 
                WHERE desp-item-doc-est.cod-emitente = item-doc-est.fornec-comp 
                  AND desp-item-doc-est.nat-operacao = item-doc-est.nat-comp    
                  AND desp-item-doc-est.serie-docto  = item-doc-est.serie-comp  
                  AND desp-item-doc-est.nro-docto    = item-doc-est.nro-comp    
                  AND desp-item-doc-est.sequencia    = item-doc-est.seq-comp   
                  AND desp-item-doc-est.cod-despesa  = item-doc-est.cod-despesa
                  AND desp-item-doc-est.situacao     = 1 EXCLUSIVE-LOCK:

                /* Marca a despesa do item do remito como conciliada */ 
                ASSIGN desp-item-doc-est.situacao = 2.

            END.
        END.

        IF  item-doc-est.cod-despesa > "":U THEN DO:

            /*localiza a despesa do remito com o fornecedor da fatura e n∆o do remito*/
            FIND b-item-doc-est WHERE
                 b-item-doc-est.cod-emitente = item-doc-est.fornec-comp AND
                 b-item-doc-est.serie-docto  = item-doc-est.serie-comp  AND
                 b-item-doc-est.nro-docto    = item-doc-est.nro-comp    AND
                 b-item-doc-est.nat-operacao = item-doc-est.nat-comp    AND
                 b-item-doc-est.sequencia    = item-doc-est.seq-comp    EXCLUSIVE-LOCK NO-ERROR.

            IF  NOT AVAIL b-item-doc-est THEN DO:

                FIND b-item-doc-est WHERE /*despesa adicional*/
                     b-item-doc-est.cod-emitente = item-doc-est.cod-emitente AND
                     b-item-doc-est.serie-comp   = "":U                      AND
                     b-item-doc-est.nro-comp     = "":U                      AND
                     b-item-doc-est.nat-comp     = "":U                      AND
                     b-item-doc-est.it-codigo    = item-doc-est.it-codigo    AND
                     b-item-doc-est.cod-despesa  = item-doc-est.cod-despesa  EXCLUSIVE-LOCK NO-ERROR.
            END.         
        END.

        ELSE DO:

            FIND b-item-doc-est WHERE
                 b-item-doc-est.cod-emitente = item-doc-est.cod-emitente AND
                 b-item-doc-est.serie-docto  = item-doc-est.serie-comp   AND
                 b-item-doc-est.nro-docto    = item-doc-est.nro-comp     AND
                 b-item-doc-est.nat-operacao = item-doc-est.nat-comp     AND
                 b-item-doc-est.sequencia    = item-doc-est.seq-comp     EXCLUSIVE-LOCK NO-ERROR.

            IF  NOT AVAIL b-item-doc-est THEN DO:

                FIND b-item-doc-est WHERE /*item adicional*/
                     b-item-doc-est.nro-docto    = item-doc-est.nro-docto AND
                     b-item-doc-est.it-codigo    = item-doc-est.it-codigo AND 
                     b-item-doc-est.cod-despesa  = "":U                   AND
                     b-item-doc-est.nro-comp     = "":U                   AND
                     b-item-doc-est.seq-comp     = 0                      EXCLUSIVE-LOCK NO-ERROR.
            END.
        END.

        IF  NOT AVAIL b-item-doc-est THEN
            NEXT.
        /******************************************************/

        /* Se o item do remito possuir saldo para conciliacao, 
           marca o remito com a situacao "Aguardando Fatura" */
        if  b-item-doc-est.qt-saldo > 0 
        and b-item-doc-est.sit-item <> 3 then do:

            assign b-item-doc-est.sit-item = 2. /*  Aguardando Fatura */

            IF  item-doc-est.cod-despesa > "":U THEN
                find b-docum-est where
                     b-docum-est.nro-docto    = item-doc-est.nro-comp    and
                     b-docum-est.cod-emitente = item-doc-est.fornec-comp and
                     b-docum-est.serie-docto  = item-doc-est.serie-comp  and
                     b-docum-est.nat-operacao = item-doc-est.nat-comp exclusive-lock no-error.
            else
                find b-docum-est where
                     b-docum-est.nro-docto    = item-doc-est.nro-comp     and
                     b-docum-est.cod-emitente = item-doc-est.cod-emitente and
                     b-docum-est.serie-docto  = item-doc-est.serie-comp   and
                     b-docum-est.nat-operacao = item-doc-est.nat-comp exclusive-lock no-error.

            if  avail b-docum-est then
                assign b-docum-est.sit-docum = 2. /* Aguardando Fatura */

            RELEASE b-docum-est NO-ERROR.
        end.
        else do:
            /* Acha o remito */
            IF  item-doc-est.cod-despesa > "":U THEN DO:
                if  not avail b-docum-est then
                    find b-docum-est where
                         b-docum-est.cod-emitente = item-doc-est.fornec-comp and
                         b-docum-est.nro-docto    = item-doc-est.nro-comp    and
                         b-docum-est.serie-docto  = item-doc-est.serie-comp  and
                         b-docum-est.nat-operacao = item-doc-est.nat-comp exclusive-lock no-error.
                else if  (   b-docum-est.cod-emitente <> item-doc-est.fornec-comp
                          or b-docum-est.nro-docto    <> item-doc-est.nro-comp 
                          or b-docum-est.serie-docto  <> item-doc-est.serie-comp
                          or b-docum-est.nat-operacao <> item-doc-est.nat-comp ) then
                         find b-docum-est where
                              b-docum-est.cod-emitente = item-doc-est.fornec-comp and
                              b-docum-est.nro-docto    = item-doc-est.nro-comp    and
                              b-docum-est.serie-docto  = item-doc-est.serie-comp  and
                              b-docum-est.nat-operacao = item-doc-est.nat-comp exclusive-lock no-error.
                     else
                         find current b-docum-est exclusive-lock no-error.
            END.
            ELSE DO:
                if  not avail b-docum-est then
                    find b-docum-est where
                         b-docum-est.cod-emitente = item-doc-est.cod-emitente and
                         b-docum-est.nro-docto    = item-doc-est.nro-comp     and
                         b-docum-est.serie-docto  = item-doc-est.serie-comp   and
                         b-docum-est.nat-operacao = item-doc-est.nat-comp exclusive-lock no-error.
                else if  (   b-docum-est.cod-emitente <> item-doc-est.cod-emitente
                          or b-docum-est.nro-docto    <> item-doc-est.nro-comp 
                          or b-docum-est.serie-docto  <> item-doc-est.serie-comp
                          or b-docum-est.nat-operacao <> item-doc-est.nat-comp ) then
                         find b-docum-est where
                              b-docum-est.cod-emitente = item-doc-est.cod-emitente and
                              b-docum-est.nro-docto    = item-doc-est.nro-comp     and
                              b-docum-est.serie-docto  = item-doc-est.serie-comp   and
                              b-docum-est.nat-operacao = item-doc-est.nat-comp exclusive-lock no-error.
                     else
                         find current b-docum-est exclusive-lock no-error.
            END.

            /* Se nao achar nenhuma despesa do remito ainda por conciliar, marca
               o remito como "OK" */
            IF  AVAIL b-docum-est THEN DO:
                if  b-docum-est.sit-docum <> 3 then do:  

                    IF  CAN-FIND(FIRST item-doc-est
                                 WHERE item-doc-est.nro-docto    = b-docum-est.nro-docto
                                   AND item-doc-est.serie-docto  = b-docum-est.serie-docto
                                   AND item-doc-est.nat-operacao = b-docum-est.nat-operacao
                                   AND item-doc-est.cod-emitente = b-docum-est.cod-emitente
                                   AND item-doc-est.qt-saldo     > 0 ) THEN DO:
                         ASSIGN b-docum-est.sit-docum = 2. /* Aguardando Fatura */
                    END.
                    ELSE DO:
                        IF  can-find(first desp-item-doc-est 
                                     where desp-item-doc-est.cod-emitente = b-docum-est.cod-emitente  
                                       and desp-item-doc-est.nro-docto    = b-docum-est.nro-docto     
                                       and desp-item-doc-est.serie-docto  = b-docum-est.serie-docto   
                                       and desp-item-doc-est.nat-operacao = b-docum-est.nat-operacao     
                                       and desp-item-doc-est.situacao     = 1) /* Nao conciliada */
                        then
                             assign b-docum-est.sit-docum = 5. /* Aguardando fatura despesas */
                        ELSE
                             ASSIGN b-docum-est.sit-docum = 1. /* OK */
                    END.
                end.
                RELEASE b-docum-est NO-ERROR.
            END.

            /* Se nao achar nenhuma despesa do remito ainda por conciliar, marca 
               o remito como "OK" */
            if  not can-find(first desp-item-doc-est 
                              where desp-item-doc-est.cod-emitente = item-doc-est.fornec-comp  
                                and desp-item-doc-est.nro-docto    = item-doc-est.nro-comp     
                                and desp-item-doc-est.serie-docto  = item-doc-est.serie-comp   
                                and desp-item-doc-est.nat-operacao = item-doc-est.nat-comp     
                                and desp-item-doc-est.sequencia    = item-doc-est.seq-comp     
                                and desp-item-doc-est.situacao     = 1) /* Nao conciliada */ 
            then if  b-item-doc-est.sit-item <> 3 then
                     assign b-item-doc-est.sit-item = 1.  /* OK */
        end. 
    end.


end procedure.

procedure pi-determina-conta :

    def input  param c-conta        like movto-estoq.conta-contabil no-undo.
    def output param c-ct-codigo    like movto-estoq.ct-codigo      no-undo.
    def output param c-sc-codigo    like movto-estoq.sc-codigo      no-undo.

    assign i-empresa = param-global.empresa-prin.

    &if defined (bf_dis_consiste_conta) &then

        find estabelec where
             estabelec.cod-estabel = docum-est.cod-estabel no-lock no-error.

        run cdp/cd9970.p (input rowid(estabelec),
                          output i-empresa).
    &endif

    find first conta-contab
        where conta-contab.ep-codigo = i-empresa
          and conta-contab.conta-contabil = c-conta no-lock no-error .

    if  avail conta-contab then       
        assign c-ct-codigo = conta-contab.ct-codigo
               c-sc-codigo = conta-contab.sc-codigo.
end.

procedure pi-gera-tt-movto:

    def input param l-variacao   as log form "Positiva/Negativa"  no-undo.

    def var i-movto              as int                           no-undo.
    def var i-seq-movto          as int                           no-undo.
    def var i-tipo-trans         as int                           no-undo.

    assign i-tipo-trans = if  l-variacao 
                          then 1   /* Entrada */
                          else 2.  /* Saida   */

    {rep/re1005.i06 tt-movto i-tipo-trans}  /* Criacao Movimento Estoque */

    assign tt-movto.it-codigo       = item-doc-est.it-codigo
           tt-movto.cod-refer       = item-doc-est.cod-refer
           tt-movto.un              = item.un
           tt-movto.sequen-nf       = item-doc-est.sequencia
           tt-movto.numero-ordem    = item-doc-est.numero-ordem
           tt-movto.num-ord-inv     = item-doc-est.num-ord-inv
           i-movto                  = tt-movto.i-sequen

           tt-movto.quantidade      = 0        /* Quantidade zero */
           tt-movto.cod-depos       = c-cod-depos
           tt-movto.cod-localiz     = c-cod-localiz
           tt-movto.lote            = c-lote
           tt-movto.esp-docto       = docum-est.esp-docto
           tt-movto.peso-liquido    = item-doc-est.peso-liquido
           tt-movto.descricao-db    = item-doc-est.narrativa
           tt-movto.dt-vali-lote    = da-validade.

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
        IF docum-est.log-entreg-fut THEN DO:
            ASSIGN tt-movto.quantidade = item-doc-est.quantidade.
        END.
    &ENDIF
        

    if  i-tipo-trans = 1                       /* Entrada */
    and can-do("1,4", string(item.tipo-contr)) /* Fisico ou Debito Direto */
    and item-doc-est.nr-ord-produ <> 0   then DO:  /* Item com ordem de producao */
        assign tt-movto.tipo-trans  = 2        /* Muda o tipo do movimento para saida */ 
               tt-movto.nr-ord-produ = item-doc-est.nr-ord-produ
               c-ct-credito         = item-doc-est.ct-codigo
               c-sc-credito         = item-doc-est.sc-codigo
               c-ct-debito          = b-docum-est.ct-transit
               c-sc-debito          = b-docum-est.sc-transit.

    END.
    else DO:
        assign c-ct-credito         = b-docum-est.ct-transit
               c-sc-credito         = b-docum-est.sc-transit               
               c-ct-debito          = item-doc-est.ct-codigo
               c-sc-debito          = item-doc-est.sc-codigo.

    END.

    assign tt-movto.ct-codigo       = c-ct-credito
           tt-movto.sc-codigo       = c-sc-credito
           tt-movto.valor-mat-m[1]  = if  l-variacao        
                                      then de-vl-diferenca              /* Diferenca Positiva */
                                      else ( de-vl-diferenca * (- 1) ). /* Diferenca Negativa */

    run pi-atualiza-movto.

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN 
        IF docum-est.log-entreg-fut THEN DO:
            {rep/re1005.i06 tt-movto 2 /* saida */}  /* Criacao Movimento Estoque */

            FIND estab-mat NO-LOCK WHERE
                estab-mat.cod-estabel = docum-est.cod-estabel NO-ERROR.

            assign tt-movto.it-codigo       = item-doc-est.it-codigo
                   tt-movto.cod-refer       = item-doc-est.cod-refer
                   tt-movto.un              = item.un
                   tt-movto.sequen-nf       = item-doc-est.sequencia
                   tt-movto.numero-ordem    = item-doc-est.numero-ordem
                   tt-movto.num-ord-inv     = item-doc-est.num-ord-inv
                   i-movto                  = tt-movto.i-sequen
                   tt-movto.quantidade      = item-doc-est.quantidade
                   tt-movto.cod-depos       = c-cod-depos
                   tt-movto.cod-localiz     = c-cod-localiz
                   tt-movto.lote            = c-lote
                   tt-movto.esp-docto       = docum-est.esp-docto
                   tt-movto.peso-liquido    = item-doc-est.peso-liquido
                   tt-movto.descricao-db    = item-doc-est.narrativa
                   tt-movto.dt-vali-lote    = da-validade
                   c-ct-credito             = estab-mat.cod-cta-ctbl-entreg-fut WHEN AVAILABLE estab-mat
                   c-sc-credito             = estab-mat.cod-ccusto-entreg-fut   WHEN AVAILABLE estab-mat
                   c-ct-debito              = item-doc-est.ct-codigo
                   c-sc-debito              = item-doc-est.sc-codigo.

            assign tt-movto.ct-codigo       = c-ct-credito
                   tt-movto.sc-codigo       = c-sc-credito.

            run pi-atualiza-movto.
        END.
    &ENDIF
end.

/* sandro - inicio */

procedure pi-gera-tt-movto-debito-direto:

    def input param l-variacao   as log form "Positiva/Negativa"  no-undo.

    def var i-movto              as int                           no-undo.
    def var i-seq-movto          as int                           no-undo.
    def var i-tipo-trans         as int                           no-undo.

    assign i-tipo-trans = if  l-variacao 
                          then 1   /* Entrada */
                          else 2.  /* Saida   */

    {rep/re1005.i06 tt-movto i-tipo-trans}  /* Criacao Movimento Estoque */

    assign tt-movto.it-codigo       = ITEM.it-codigo
           tt-movto.un              = item.un
           tt-movto.referencia      = "dif camb"
           i-movto                  = tt-movto.i-sequen

           tt-movto.quantidade      = 0        /* Quantidade zero */
           tt-movto.cod-depos       = c-cod-depos
           tt-movto.cod-localiz     = c-cod-localiz
           
           tt-movto.esp-docto       = docum-est.esp-docto
           tt-movto.peso-liquido    = item-doc-est.peso-liquido
           tt-movto.descricao-db    = item-doc-est.narrativa.

    assign c-ct-credito         = b-docum-est.ct-transit
           c-sc-credito         = b-docum-est.sc-transit           
           c-ct-debito          = param-estoq.ct-acerto
           c-sc-debito          = param-estoq.sc-acerto.

    assign tt-movto.ct-codigo       = c-ct-credito
           tt-movto.sc-codigo       = c-sc-credito.

    assign tt-movto.ct-db        = c-ct-debito
           tt-movto.sc-db        = c-sc-debito.

           tt-movto.valor-mat-m[1]  = if  l-variacao        
                                      then de-vl-diferenca              /* Diferenca Positiva */
                                      else ( de-vl-diferenca * (- 1) ). /* Diferenca Negativa */

    run pi-atualiza-movto.

end.

/* sandro - final */

procedure pi-gera-movto-estoq:

    def output param l-erro  as log   no-undo.

    {utp/ut-liter.i Atualizando_Estoque  MRE R}
    assign c-texto2 = return-value.

    run pi-acompanhar in h-acomp (input c-texto2 ).

    /*  ATUALIZACAO DE MOVIMENTOS DO ESTOQUE */

    run cep/ceapi001.p ( input-output table tt-movto,
                         input-output table tt-erro,
                         yes ).

    if  return-value = "nok" then 
        assign l-erro = yes.

    for each tt-erro :
        if line-counter > 62 then
           page.

        if line-counter <= 5 then do:
            put c-cabec1 at 0 skip.
            put c-cabec2 at 0 skip.
        end.

        put docum-est.serie-docto at 1.
        put docum-est.nro-docto   at 7.
        put string(docum-est.cod-emitente) at 24 format "X(9)".
        put docum-est.nat-operacao at 35.
        put string(tt-erro.cd-erro,">>>>>9") at 43.
        put tt-erro.mensagem at 53 format "X(78)" skip.

        assign l-erro = yes.
    end.

    for each tt-erro:
        delete tt-erro.
    end.

    for each tt-movto:
        delete tt-movto.
    end.    

end.

procedure pi-atualiza-movto:

    /* Convers∆o para Moeda Alternativa */
    {rep/re1005.i08 tt-movto tt-movto.dt-trans}   

    if  can-do("1,4", string(item.tipo-contr)) /* Fisico ou Debito Direto */ then
    do:
        assign tt-movto.ct-db    = c-ct-debito
               tt-movto.sc-db    = c-sc-debito.
    end.

end.

procedure pi-gera-tt-movto-rateio:
    def input param de-valor-desp like desp-docum-est.val-despesa no-undo.
    def input param c-cod-depos   like item-doc-est.cod-depos     no-undo.
    def input param c-cod-localiz like item-doc-est.cod-localiz   no-undo.
    def input param c-lote        like item-doc-est.lote          no-undo.

    def var i-movto      as int no-undo.
    def var i-seq-movto  as int no-undo.

    {rep/re1005.i06 tt-movto 1} /*Criaá∆o Movimento Estoque de Entrada "1" */

    assign tt-movto.it-codigo    = item-doc-est.it-codigo
           tt-movto.cod-refer    = item-doc-est.cod-refer
           tt-movto.un           = item.un
           tt-movto.sequen-nf    = item-doc-est.sequencia
           tt-movto.numero-ordem = item-doc-est.numero-ordem
           tt-movto.num-ord-inv  = item-doc-est.num-ord-inv
           i-movto               = tt-movto.i-sequen

           tt-movto.quantidade   = 0
           tt-movto.cod-depos    = c-cod-depos
           tt-movto.cod-localiz  = c-cod-localiz
           tt-movto.lote         = c-lote
           tt-movto.esp-docto    = docum-est.esp-docto
           tt-movto.peso-liquido = 0
           tt-movto.descricao-db = item-doc-est.narrativa
           tt-movto.dt-vali-lote = da-validade.

    IF  CAN-DO("1,4", STRING(ITEM.tipo-contr))      /* Fisico ou Debito Direto */
    OR  item-doc-est.nr-ord-produ    <> 0            /* Item com ordem de producao */
    OR  item-doc-est.ct-codigo      <> "" THEN DO:  /* Total requisitado por um centro de custo (conta contabil) */

        FIND despesa WHERE
             despesa.cod-despesa = b2-item-doc-est.cod-despesa NO-LOCK NO-ERROR.

        ASSIGN tt-movto.it-codigo   = ""
               c-ct-credito         = b-docum-est.ct-transit
               c-sc-credito         = b-docum-est.sc-transit.

        IF  AVAIL despesa AND item-doc-est.nr-ord-produ <> 0 THEN 
            ASSIGN c-ct-debito = despesa.cdn-ctconta
                   c-sc-debito = despesa.cdn-ccusto.
        ELSE 
            ASSIGN c-ct-debito = item-doc-est.ct-codigo
                   c-sc-debito = item-doc-est.sc-codigo.

        ASSIGN tt-movto.ct-db    = c-ct-debito
               tt-movto.sc-db    = c-sc-debito.

    END.
    ELSE DO:
        ASSIGN c-ct-credito         = b-docum-est.ct-transit
               c-sc-credito         = b-docum-est.sc-transit               
               c-ct-debito          = item-doc-est.ct-codigo
               c-sc-debito          = item-doc-est.sc-codigo.
    END.

    assign tt-movto.ct-codigo      = c-ct-credito
           tt-movto.sc-codigo      = c-sc-credito
           tt-movto.valor-mat-m[1] = de-valor-desp.

    run pi-atualiza-movto.

end procedure.

procedure pi-gera-tt-movto-despesa:

    def input param c-despesa        like desp-docum-est.cod-despesa no-undo.
    def input param de-valor-desp    like desp-docum-est.val-despesa no-undo.
    def input param c-ct-codigo      like item-doc-est.ct-codigo     no-undo.
    def input param c-sc-codigo      like item-doc-est.sc-codigo     no-undo.

    def var i-movto      as int no-undo.
    def var i-seq-movto  as int no-undo.
    def var i-tipo-trans as int no-undo.

    find despesa where despesa.cod-despesa = c-despesa no-lock no-error.
    if  not avail despesa then 
        return "NOK":U.

    find first item-uni-estab
         where item-uni-estab.it-codigo = "":U
           and item-uni-estab.cod-estabel = docum-est.cod-estabel no-lock no-error.
    if  not avail item-uni-estab then 
        return "NOK":U.

    find item where item.it-codigo = "":U no-lock no-error.

    {rep/re1005.i06 tt-movto 1} /*Criaá∆o Movimento Estoque de entrada*/

    assign tt-movto.it-codigo   = "":U
           tt-movto.un          = item.un
           tt-movto.referencia  = "":U
           i-movto              = tt-movto.i-sequen

           tt-movto.quantidade  = 0
           tt-movto.cod-depos   = item-uni-estab.deposito-pad
           tt-movto.cod-localiz = item-uni-estab.cod-localiz

           tt-movto.esp-docto   = docum-est.esp-docto.


    assign c-ct-credito    = docum-est.ct-transit
           c-sc-credito    = docum-est.sc-transit           
           c-ct-debito     = c-ct-codigo
           c-sc-debito     = c-sc-codigo.

    /*Conta Credito*/
    assign tt-movto.ct-codigo      = c-ct-credito
           tt-movto.sc-codigo      = c-sc-credito.

    /*Conta Debito*/
    assign tt-movto.ct-db    = c-ct-debito
           tt-movto.sc-db    = c-sc-debito.

    assign tt-movto.valor-mat-m[1] = de-valor-desp.

    run pi-atualiza-movto.

end procedure.

PROCEDURE pi-valida-docto-internacional:

    IF AVAIL docum-est THEN DO:        

        /*Validaá∆o Localizaá∆o Equador*/
        IF i-pais-impto-usuario = 21 THEN DO:

            /*Valida se existe Retená∆o de Imposto e n∆o foram gerados os comprovantes*/
            IF NOT VALID-HANDLE(h-boec026) THEN
                RUN local/ecu/ec2bo/boec026.p PERSISTENT SET h-boec026.

            RUN pi-valida-gerac-comprov-retenc IN h-boec026 (INPUT docum-est.cod-emitente,
                                                             INPUT docum-est.nat-operacao,
                                                             INPUT docum-est.nro-docto,
                                                             INPUT docum-est.serie-docto,
                                                             OUTPUT l-comprov-retenc).

            IF l-comprov-retenc 
                AND docum-est.nff THEN
                RUN pi-erro-nota (53927,""). /*Comprovante de Retená∆o n∆o foi gerado para os impostos retidos do documento*/
            
            /*Se existe retená∆o deve validar se foi gerado para todos os itens com valores corretos*/
            RUN pi-valida-valores-gerados-comprov IN h-boec026 (INPUT docum-est.cod-emitente,
                                                                INPUT docum-est.nat-operacao,
                                                                INPUT docum-est.nro-docto,
                                                                INPUT docum-est.serie-docto,
                                                                OUTPUT l-comprov-retenc).
            IF l-comprov-retenc 
                AND docum-est.nff THEN
                RUN pi-erro-nota (53951,""). 
            
        END. /*FIM Validaá‰es Localizaá∆o Equador*/

    END.

    IF VALID-HANDLE(h-boec026) THEN DO:
        RUN destroy IN h-boec026.
        ASSIGN h-boec026 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

{include/pi-edit.i}

