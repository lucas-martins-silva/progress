/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN218P 2.00.00.067 } /*** "010067" 17/06/2025 16:40:47 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin218p MUT}
&ENDIF

{inbo/boin218p.i} /*** Defini»„es ***/
{cep/ceapi001k.i} /*tt-movto*/

{cdp/cd0666.i}    /*** Temp-table de erros      ***/
{cdp/cdcfgman.i}  /*** Preprocessador release   ***/
{cdp/cdcfgmat.i}  /*** Preprocessador materiais ***/

def new Global shared var c-seg-usuario as char format "x(12)" no-undo.

define temp-table tt-deposito no-undo
field  cod-depos    like deposito.cod-depos
field  log-recicl   as logical
index  id cod-depos log-recicl.   

define temp-table tt-item-processo no-undo
   field it-codigo        as char format "x(16)"
   FIELD es-codigo        AS CHAR FORMAT "x(16)"
   field cod-ref-it       as char format "x(16)"
   field cod-lista        as char format "x(16)"
   field cod-roteiro      as char format "x(16)"
   field qtd-item         as decimal format "->>>>,>>>,>>9.99"
   field qtd-recicl       as decimal format "->>>>,>>>,>>9.99"
   field qtd-refgda       as decimal format "->>>>,>>>,>>9.99"
   field nr-ord-produ     like ord-prod.nr-ord-produ 
   index id it-codigo cod-ref-it cod-lista cod-roteiro.   

DEFINE TEMP-TABLE tt-aux NO-UNDO
       FIELD it-codigo LIKE estrutura.it-codigo
       FIELD es-codigo LIKE estrutura.es-codigo
       INDEX es IS PRIMARY  es-codigo.

DEFINE TEMP-TABLE tt_log_erro NO-UNDO
     FIELD ttv_num_cod_erro  AS integer   INITIAL ?
     FIELD ttv_des_msg_ajuda AS character INITIAL ?
     FIELD ttv_des_msg_erro  AS character INITIAL ?.	   
	 
find first param-estoq NO-LOCK NO-ERROR.
DEFINE VARIABLE h-ceapi001k AS HANDLE      NO-UNDO.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
{cep/ceapi030.i}
&endif

/********************************************************************************
** 
** PROCEDURE CalcularSaldoItem:
** OBJETIVO: Determina a posicao de saldo de um item num estabelecimento
**           e deposito numa data determinada
** PAR“METROS:i-it-codigo
**            i-cod-refer
**            i-cod-estabel
**            i-cod-deposito
**            i-cod-localiz
**            i-dat-saldo     
**            o-dt-ul-contag  (data de ßltima contagem dos saldos)
**            o-qtd-dispon    (quantidade disponðvel na data)
**            o-qtd-saldo     (saldo fðsico na data)
********************************************************************************/
PROCEDURE CalcularSaldoItem:

    def input  param p-it-codigo    AS CHARACTER   no-undo.
    def input  param p-cod-refer    AS CHARACTER   no-undo.
    def input  param p-cod-estabel  AS CHARACTER   no-undo.
    def input  param p-cod-deposito AS CHARACTER   no-undo.
    def input  param p-cod-localiz  AS CHARACTER   no-undo.
    def input  param p-lote         AS CHARACTER   no-undo.
    def input  param p-dat-saldo    as date        no-undo.
    def output param p-dt-ul-contag AS DATE        no-undo.
    def output param p-qtd-dispon   as dec         no-undo.
    def output param p-qtd-saldo    as dec         no-undo.
    def output param p-rw-saldo     as rowid       no-undo.

    def var v-qtd-saidas    as  decimal no-undo.
    def var v-qtd-entradas  as  decimal no-undo.
    def var v-num-reg-saldo as  integer no-undo.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    def var l-lote-avancado as log    no-undo.
    def var h-ceapi030      as handle no-undo.
    def var l-retorno       as log    no-undo.

    if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                             funcao.ativo) then do:
        assign l-lote-avancado = yes.

        if not valid-handle(h-ceapi030) then
            run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                          output table tt-valores,
                                                          output table tt-erro).
    end.
  &endif

    assign p-qtd-dispon     = 0
           p-qtd-saldo      = 0
           p-dt-ul-contag   = ?
           v-num-reg-saldo  = 0.

    /*** Acumula posi¯´es de saldo ***/
    for each saldo-estoq FIELDS (cod-estabel cod-depos lote it-codigo
                                 qtidade-atu dt-vali-lote dt-ul-contag
                                 cod-refer qt-aloc-prod qt-alocada qt-aloc-ped
                                 cod-localiz) where
             saldo-estoq.it-codigo   = p-it-codigo   and
             saldo-estoq.cod-estabel = p-cod-estabel and
             saldo-estoq.cod-refer   = p-cod-refer no-lock:

        if  p-lote <> "" and p-lote <> saldo-estoq.lote then
            next.

        /*** Teste de parümetros de entrada ***/
        if  p-cod-deposito <> ""
        and p-cod-deposito <> saldo-estoq.cod-depos then
            next.

        if p-cod-localiz <> saldo-estoq.cod-localiz then next.

        if  p-dt-ul-contag = ? or 
           (saldo-estoq.dt-ul-contag <> ? and 
            saldo-estoq.dt-ul-contag <  p-dt-ul-contag) then 
            assign p-dt-ul-contag = min(p-dt-ul-contag, saldo-estoq.dt-ul-contag).

      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        assign l-retorno = yes.

        find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
        if l-lote-avancado and
           avail item and
           item.tipo-con-est > 2 then do:

            run pi-identifica-saldo in h-ceapi030 (input 1,
                                                   input saldo-estoq.it-codigo,
                                                   input saldo-estoq.cod-estabel,
                                                   input saldo-estoq.lote,
                                                   input 0,
                                                   output l-retorno,
                                                   output table tt-valores2,
                                                   output table tt-erro).

        end.

        if l-retorno then
      &endif

        assign p-qtd-dispon   = p-qtd-dispon + (saldo-estoq.qtidade-atu  - saldo-estoq.qt-alocada - 
                                                saldo-estoq.qt-aloc-prod - saldo-estoq.qt-aloc-ped)
               p-qtd-saldo    = p-qtd-saldo  + saldo-estoq.qtidade-atu.

        assign v-qtd-saidas   = 0
               v-qtd-entradas = 0.
/* Ativ. 161342 */
        /*** Retroatividade de movimentos ***/
        for each movto-estoq use-index item-data where
                 movto-estoq.it-codigo   = saldo-estoq.it-codigo      and
                 movto-estoq.cod-estabel = saldo-estoq.cod-estabel    and
                 movto-estoq.dt-trans    > p-dat-saldo                and
                 movto-estoq.cod-refer   = saldo-estoq.cod-refer      and
                 movto-estoq.cod-depos   = saldo-estoq.cod-depos      and
                 movto-estoq.cod-localiz = saldo-estoq.cod-localiz    AND
                 movto-estoq.lote        = saldo-estoq.lote           and
                 movto-estoq.esp-docto   <> 37     no-lock:

            if  movto-estoq.tipo-trans = 1 then
                    assign v-qtd-entradas = v-qtd-entradas + movto-estoq.quantidade.
                else
                    assign v-qtd-saidas   = v-qtd-saidas   + movto-estoq.quantidade.
        end. 


        assign p-qtd-dispon    = p-qtd-dispon + v-qtd-saidas - v-qtd-entradas 
               p-qtd-saldo     = p-qtd-saldo  + v-qtd-saidas - v-qtd-entradas
               v-num-reg-saldo = v-num-reg-saldo + 1
               p-rw-saldo      = if v-num-reg-saldo = 1 then rowid(saldo-estoq)
                                                        else ?.


         &IF DEFINED (bf_mat_versao_ems) &THEN /*2.04*/
            IF param-estoq.tp-fech = 2 THEN
               FOR FIRST estab-mat FIELDS (mensal-ate)  WHERE 
                         estab-mat.cod-estabel = p-cod-estabel  NO-LOCK:
                   IF (p-dt-ul-contag = ? or 
                       p-dt-ul-contag <= param-estoq.mensal-ate) THEN
                       assign   p-dt-ul-contag   = estab-mat.mensal-ate + 1.
               END.
            ELSE 
                if p-dt-ul-contag = ? or 
                   p-dt-ul-contag <= param-estoq.mensal-ate then
                assign   p-dt-ul-contag   = param-estoq.mensal-ate + 1.
         &else        
            if p-dt-ul-contag = ? or 
               p-dt-ul-contag <= param-estoq.mensal-ate then
                assign   p-dt-ul-contag   = param-estoq.mensal-ate + 1.
         &endif
    end.    

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if valid-handle(h-ceapi030) then
        delete procedure h-ceapi030.
  &endif

END PROCEDURE.


/********************************************************************************
** 
** PROCEDURE InicializarOrdensConsumo:
** OBJETIVO: Elimina registros tempor˜rios relacionados ao saldo
** PAR“METROS:i-cod-estabel
**            i-cod-deposito
**            i-cod-localiz
**            i-es-codigo
**            i-cod-refer-es
**            io-tt-op-consumo (nro ordem, item da ordem, qtd-real, qtd-padrao)
**               
********************************************************************************/
PROCEDURE InicializarOrdensConsumo:

    define input parameter p-cod-estabel  AS CHARACTER    no-undo.
    define input parameter p-cod-depos    AS CHARACTER    no-undo.
    define input parameter p-cod-localiz  AS CHARACTER    no-undo.
    define input parameter p-es-codigo    AS CHARACTER    no-undo.
    define input parameter p-cod-refer-es AS CHARACTER    no-undo.
    define input parameter p-lote         AS CHARACTER    no-undo.
    define input-output parameter table for tt-op-consumo.

    for each tt-op-consumo where 
             tt-op-consumo.cod-estabel  = p-cod-estabel  and
             tt-op-consumo.cod-deposito = p-cod-depos    and 
             tt-op-consumo.cod-localiz  = p-cod-localiz  and 
             tt-op-consumo.es-codigo    = p-es-codigo    and 
             tt-op-consumo.cod-ref-es   = p-cod-refer-es:

        if  p-lote <> ""
        and tt-op-consumo.es-lote <> p-lote then
            next.

        delete tt-op-consumo.
    end.          

END PROCEDURE.    


/********************************************************************************
** 
** PROCEDURE PesquisarOrdensConsumo:
** OBJETIVO: Determina ordens que movimentaram um componente de um 
**           estab/deposito/localiza¯Êo numa faixa de datas
** PAR“METROS:i-cod-estabel
**            i-cod-deposito
**            i-cod-localiz
**            i-es-codigo
**            i-cod-refer-es
**            i-es-lote
**            i-dat-inic
**            i-dat-fim
**            i-qtd-dif
**            o-erro    
**            o-tt-op-consumo (nro ordem, item da ordem, qtd-real, qtd-padrao)
**               
********************************************************************************/

PROCEDURE PesquisarOrdensConsumo:

    define input parameter p-cod-estabel  AS CHARACTER    no-undo.
    define input parameter p-cod-depos    AS CHARACTER    no-undo.
    define input parameter p-cod-localiz  AS CHARACTER    no-undo.
    define input parameter p-es-codigo    AS CHARACTER    no-undo.
    define input parameter p-cod-refer-es AS CHARACTER    no-undo.
    define input parameter p-es-lote      AS CHARACTER    no-undo.
    define input parameter p-dat-inic     as date         no-undo.
    define input parameter p-dat-fim      as date         no-undo.
    define input-output parameter table for tt-op-consumo.

    define buffer btt-op-consumo for tt-op-consumo.

    /*** NÊo inicializa quando a chamada ý recursiva ***/ 
    if  p-es-lote <> ? then
        run InicializarOrdensConsumo (p-cod-estabel,
                                      p-cod-depos,
                                      p-cod-localiz,
                                      p-es-codigo,
                                      p-cod-refer-es,
                                      p-es-lote,
                                      input-output table tt-op-consumo).
    if  p-es-lote = ? then
        assign p-es-lote = "".                                   

    find first param-global no-lock no-error.

    /*** Retroatividade de movimentos ***/
        for each movto-estoq fields (it-codigo cod-estabel dt-trans cod-refer lote cod-localiz
                                     cod-depos nr-ord-produ esp-docto tipo-trans quantidade) 
                 use-index item-data where
                 movto-estoq.it-codigo   = p-es-codigo    and
                 movto-estoq.cod-estabel = p-cod-estabel  and 
                 movto-estoq.dt-trans    > p-dat-inic - 1 and
                 movto-estoq.dt-trans    < p-dat-fim  + 1  no-lock:


            IF NOT movto-estoq.cod-refer   = p-cod-refer-es THEN NEXT.

            if  movto-estoq.lote <> p-es-lote
            and p-es-lote        <> "" then
                next.

            /*** Tratamento de localiza¯Êo branco ***/
            if  p-cod-localiz <> ""
            and movto-estoq.cod-localiz <> p-cod-localiz then
                next.

            /*** Tratamento de dep«sito branco ***/
            if  p-cod-depos           <> ""
            and movto-estoq.cod-depos <> p-cod-depos then
                next.

            /*** Verifica existencia de saldo em localiza¯Êo ou dep«sito branco ***/
            if ((p-cod-localiz  = "" and movto-estoq.cod-localiz <> "")  or  
                (p-cod-depos    = "" and movto-estoq.cod-depos   <> "")) and   
               can-find (first saldo-estoq where
                               saldo-estoq.cod-estabel = p-cod-estabel and
                               saldo-estoq.cod-depos   = p-cod-depos   and
                               saldo-estoq.cod-localiz = p-cod-localiz and
                               saldo-estoq.lote        = p-es-lote     and
                               saldo-estoq.it-codigo   = p-es-codigo   and
                               saldo-estoq.cod-refer   = p-cod-refer-es) 
               then next.                

            /*** Filtro de tipos de movimentos ***/
            if  movto-estoq.nr-ord-produ  =  0 or
               (movto-estoq.esp-docto    <> 5   and
                movto-estoq.esp-docto    <> 6   and
                movto-estoq.esp-docto    <> 7   and
                movto-estoq.esp-docto    <> 25  and  
                movto-estoq.esp-docto    <> 28  and   
                movto-estoq.esp-docto    <> 30  and   
                movto-estoq.esp-docto    <> 31) then 
                next.

            FOR FIRST ord-prod FIELDS (nr-ord-produ it-codigo estado cod-refer
                                       &IF DEFINED (bf_man_sfc_lc) &THEN
                                       cod-lista-compon cod-roteiro &endif) where
                      ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ no-lock:
            END.

            if movto-estoq.it-codigo = ord-prod.it-codigo then next.

            if  not available ord-prod
            or (ord-prod.estado > 7 and param-global.modulo-cs = yes) then
                next.

            /*** So considerar ordens para linha de processo ***/
            find first tt-op-consumo where 
                       tt-op-consumo.cod-estabel  = p-cod-estabel  and
                       tt-op-consumo.cod-deposito = p-cod-depos    and 
                       tt-op-consumo.cod-localiz  = p-cod-localiz  and 
                       tt-op-consumo.es-codigo    = p-es-codigo    and 
                       tt-op-consumo.cod-ref-es   = p-cod-refer-es and 
                       tt-op-consumo.nr-ord-produ = ord-prod.nr-ord-produ and
                       tt-op-consumo.es-lote      = p-es-lote      no-error.

            if  not available tt-op-consumo then do:
                create tt-op-consumo.
                assign tt-op-consumo.cod-estabel  = p-cod-estabel 
                       tt-op-consumo.cod-deposito    = p-cod-depos 
                       tt-op-consumo.cod-localiz  = p-cod-localiz  
                       tt-op-consumo.es-codigo    = p-es-codigo    
                       tt-op-consumo.cod-ref-es   = p-cod-refer-es 
                       tt-op-consumo.nr-ord-produ = ord-prod.nr-ord-produ
                       tt-op-consumo.dat-i-corte  = p-dat-inic
                       tt-op-consumo.dat-f-corte  = p-dat-fim
                       tt-op-consumo.dat-ult-aca  = movto-estoq.dt-trans 
                       tt-op-consumo.it-codigo    = ord-prod.it-codigo
                       tt-op-consumo.cod-ref-it   = ord-prod.cod-refer
                       tt-op-consumo.es-lote      = p-es-lote
                       tt-op-consumo.r-rowid      = ROWID(ord-prod).

                &IF DEFINED (bf_man_sfc_lc) &THEN       
                    assign tt-op-consumo.cod-lista   = ord-prod.cod-lista-compon
                           tt-op-consumo.cod-roteiro = ord-prod.cod-roteiro.

                    FOR first item-man FIELDS (dec-1) where 
                              item-man.it-codigo = tt-op-consumo.it-codigo no-lock:
                        assign tt-op-consumo.fator-item-un-al = item-man.dec-1.
                    END.
                    FOR first item-man FIELDS (dec-1) where 
                              item-man.it-codigo = tt-op-consumo.es-codigo no-lock:
                        assign tt-op-consumo.fator-comp-un-al = item-man.dec-1.                
                    END.
                &ENDIF       
            end.          

            /*busca a data da ultima movimentação*/

            IF movto-estoq.dt-trans > tt-op-consumo.dat-ult-aca THEN DO:
                 ASSIGN tt-op-consumo.dat-ult-aca = movto-estoq.dt-trans.
            END.

             /*fim da busca da data*/

            find first btt-op-consumo where
                       btt-op-consumo.nr-ord-produ = tt-op-consumo.nr-ord-produ and
                       btt-op-consumo.dat-i-corte  = tt-op-consumo.dat-i-corte  and
                       rowid(btt-op-consumo)      <> rowid(tt-op-consumo) no-error.

            if  not available btt-op-consumo then
                run CalcularQtdRepOrdem (input ord-prod.nr-ord-produ, 
                                         input ord-prod.it-codigo,
                                         input ord-prod.cod-refer,
                                         input p-dat-inic,
                                         input p-dat-fim,
                                         output tt-op-consumo.qtd-item,
                                         output tt-op-consumo.qtd-recicl,
                                         output tt-op-consumo.qtd-refgda ,                        
             
                                         output tt-op-consumo.dat-ult-aca ).
            else 
                assign tt-op-consumo.qtd-item    = btt-op-consumo.qtd-item
                       tt-op-consumo.qtd-recicl  = btt-op-consumo.qtd-recicl
                       tt-op-consumo.qtd-refgda  = btt-op-consumo.qtd-refgda            
                       tt-op-consumo.dat-ult-aca = btt-op-consumo.dat-ult-aca.

            /*** Entrada: devolve material, Saida: Requisita material ***/
            if  movto-estoq.tipo-trans = 1 then
                assign tt-op-consumo.qtd-consumida = tt-op-consumo.qtd-consumida - movto-estoq.quantidade.
            else
                assign tt-op-consumo.qtd-consumida = tt-op-consumo.qtd-consumida + movto-estoq.quantidade.
        end.


END PROCEDURE.          

/********************************************************************************
** 
** PROCEDURE CalcularQtdRepOrdem:
** OBJETIVO: Determina quantidade ACA movimentada por uma ordem numa faixa de datas
** PAR“METROS: i-nr-ord-produ
**             i-it-codigo
**             i-cod-refer
**             i-dat-inic
**             i-dat-fim
**             o-qtd-reptda
**             o-qtd-recic  (quantidade movimentada para deposito de reciclagem)
**             o-qtf-refgda
**             o-dat-ult-movto
**               
********************************************************************************/
PROCEDURE CalcularQtdRepOrdem:

    define input  parameter p-nr-ord-produ AS INTEGER    no-undo.
    define input  parameter p-it-codigo    AS CHARACTER       no-undo.
    define input  parameter p-cod-refer    AS CHARACTER       no-undo.
    define input  parameter p-dat-inic     as date                       no-undo.
    define input  parameter p-dat-fim      as date                       no-undo.
    define output parameter p-qtd-item     like ord-prod.qt-ordem        no-undo.
    define output parameter p-qtd-recicl   like ord-prod.qt-ordem        no-undo.
    define output parameter p-qtd-refgda   like ord-prod.qt-ordem        no-undo.
    define output parameter p-dat-ult-movto as date                      no-undo. 

    define buffer b-movto-estoq for movto-estoq.

    assign p-qtd-item = 0 
           p-dat-ult-movto = date(1,1,1900).

    FOR first ord-prod FIELDS (nr-ord-produ cod-estabel ) where 
              ord-prod.nr-ord-produ = p-nr-ord-produ no-lock :        

        for each b-movto-estoq  fields (it-codigo cod-estabel dt-trans nr-ord-produ cod-refer esp-docto
                                        tipo-trans quantidade cod-depos)
             WHERE b-movto-estoq.nr-ord-produ = p-nr-ord-produ AND
                   b-movto-estoq.it-codigo    = p-it-codigo           and
                   b-movto-estoq.cod-estabel  = ord-prod.cod-estabel  AND
                   b-movto-estoq.dt-trans     >= p-dat-inic /*- 1 */  AND 
                   b-movto-estoq.dt-trans     <= p-dat-fim  /*+ 1*/   
            no-lock:


                /*IF NOT (b-movto-estoq.nr-ord-produ = p-nr-ord-produ /*and
                        b-movto-estoq.cod-refer    = p-cod-refer  */  ) THEN NEXT.*/

            if b-movto-estoq.esp-docto   <> 1  and
               b-movto-estoq.esp-docto   <> 6  and
               b-movto-estoq.esp-docto   <> 8  and
               b-movto-estoq.esp-docto   <> 25 and   
               b-movto-estoq.esp-docto   <> 35 then
                next.

            /*** Entrada: entra acabado, Saida: Estorna acabado ***/
            if  b-movto-estoq.tipo-trans = 1 then
                assign p-qtd-item      = p-qtd-item + b-movto-estoq.quantidade
                       p-dat-ult-movto = max(p-dat-ult-movto, b-movto-estoq.dt-trans).
            else
                assign p-qtd-item = p-qtd-item - b-movto-estoq.quantidade.

            if b-movto-estoq.esp-docto = 25 then do:
               if b-movto-estoq.tipo-trans = 1 then
                   assign p-qtd-refgda =  p-qtd-refgda + b-movto-estoq.quantidade.
               else        
                   assign p-qtd-refgda =  p-qtd-refgda - b-movto-estoq.quantidade.
               next.
            end.

            &IF DEFINED (bf_man_sfc_lc) &THEN
            /*** Quantidade que entra em dep«sito de reciclagem ***/
            if can-find (first tt-deposito where 
                               tt-deposito.cod-depos  = b-movto-estoq.cod-depos and
                               tt-deposito.log-recicl = no) then next.

            if not can-find (first tt-deposito where 
                                   tt-deposito.cod-depos = b-movto-estoq.cod-depos) then do:
                FOR first deposito FIELDS (cod-depos log-reciclagem) where 
                          deposito.cod-depos = b-movto-estoq.cod-depos NO-LOCK:
                    create tt-deposito.
                    assign tt-deposito.cod-depos  = deposito.cod-depos
                           tt-deposito.log-recicl = deposito.log-reciclagem.
                END.
                if tt-deposito.log-recicl then do:
                    if b-movto-estoq.tipo-trans = 1 then
                        assign p-qtd-recicl =  p-qtd-recicl + b-movto-estoq.quantidade.
                    else        
                        assign p-qtd-recicl =  p-qtd-recicl - b-movto-estoq.quantidade.
                end.
            end.
            else do:
                if b-movto-estoq.tipo-trans = 1 then
                    assign p-qtd-recicl =  p-qtd-recicl + b-movto-estoq.quantidade.
                else        
                    assign p-qtd-recicl =  p-qtd-recicl - b-movto-estoq.quantidade.
            end.
            &ENDIF
        end.
    END.
    if  p-dat-ult-movto = date(1,1,1900) then do:
        assign p-dat-ult-movto = today.
        FOR last b-movto-estoq FIELDS (dt-trans) where
                 b-movto-estoq.nr-ord-produ = p-nr-ord-produ 
             AND b-movto-estoq.dt-trans    >= p-dat-inic
             AND b-movto-estoq.dt-trans    <= p-dat-fim 
                  use-index ord-seq NO-LOCK:
            assign p-dat-ult-movto = b-movto-estoq.dt-trans.
        END.
    end.

END PROCEDURE.


/********************************************************************************
** 
** PROCEDURE InicializarOrdensItem:
** OBJETIVO: Elimina registros tempor˜rios relacionados ao saldo
** PAR“METROS:i-cod-estab
              i-es-codigo
              i-cod-refer-es
**            io-tt-op-consumo (nro ordem, item da ordem, qtd-real, qtd-padrao)
**               
********************************************************************************/
PROCEDURE InicializarOrdensItem:

    define input        parameter p-cod-estabel    AS CHARACTER no-undo.
    define input        parameter p-es-codigo      AS CHARACTER     no-undo.
    define input        parameter p-cod-ref-es     AS CHARACTER      no-undo.
    define input-output parameter table for tt-op-consumo.

    for each tt-op-consumo
        where tt-op-consumo.cod-estabel = p-cod-estabel
          and tt-op-consumo.es-codigo   = p-es-codigo:

        if p-cod-ref-es <> "" and
           p-cod-ref-es <> tt-op-consumo.cod-ref-es then next.   

        delete tt-op-consumo.

    end.

END PROCEDURE.    

/********************************************************************************
** 
** PROCEDURE PesquisarOrdensItemUnidadeNegocio:
** OBJETIVO: Determina ordens que movimentaram um componente numa faixa de datas
**           e Unidade de Neg¢cio na release 2.06b com a fun‡Æo 
             "ems2-unidade-negocio" ativo.
** PAR“METROS: i-cod-estabel
**             i-es-codigo
**             i-dat-inic
**             i-dat-fim
**             c-ini-unid-negoc-par
**             c-fim-unid-negoc-par 
**             o-tt-op-consumo (nro ordem, item da ordem, qtd-real, qtd-padrao)
**               
********************************************************************************/
PROCEDURE PesquisarOrdensItemUnidadeNegocio:
        
    define input parameter  p-cod-estabel  AS CHARACTER     no-undo.
    define input parameter  p-es-codigo    AS CHARACTER     no-undo.
    define input parameter  p-cod-ref-es   AS CHARACTER     no-undo.
    define input parameter  p-dat-inic     as date          no-undo.
    define input parameter  p-dat-fim      as date          no-undo.
    define input parameter  p-unid-negoc-ini as character   no-undo.
    define input parameter  p-unid-negoc-fim as character   no-undo.
    DEFINE OUTPUT PARAMETER p-de-qtd-consumida AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE d-dt-trans AS DATE NO-UNDO.
    ASSIGN p-de-qtd-consumida = 0.

    &IF DEFINED(bf_man_206b) &THEN
        IF(can-find(funcao where funcao.cd-funcao = "ems2-unidade-negocio" and
                    funcao.ativo     = yes)) THEN DO:

            define buffer btt-op-consumo for tt-op-consumo.
        
            run InicializarOrdensItem (p-cod-estabel,
                                       p-es-codigo,
                                       p-cod-ref-es,
                                       input-output table tt-op-consumo).
        
            find first param-global no-lock no-error.
        
            /*** Retroatividade de movimentos ***/
        
            for each movto-estoq  fields (it-codigo cod-estabel dt-trans cod-unid-negoc cod-refer nr-ord-produ esp-docto 
                                          cod-depos cod-localiz tipo-trans quantidade ) 
                use-index item-data
                where movto-estoq.it-codigo      =  p-es-codigo
                  and movto-estoq.cod-estabel    =  p-cod-estabel
                  and movto-estoq.dt-trans       >  p-dat-inic - 1
                  and movto-estoq.dt-trans       <  p-dat-fim + 1
                  and movto-estoq.cod-unid-negoc >= p-unid-negoc-ini  
                  and movto-estoq.cod-unid-negoc <= p-unid-negoc-fim NO-LOCK:
        
                if p-cod-ref-es <> "" and
                   p-cod-ref-es <> movto-estoq.cod-refer then next.   
        
                if  movto-estoq.nr-ord-produ  = 0   or
                   (movto-estoq.esp-docto    <> 5   and
                    movto-estoq.esp-docto    <> 6   and
                    movto-estoq.esp-docto    <> 7   and
                    movto-estoq.esp-docto    <> 25  and  
                    movto-estoq.esp-docto    <> 28  and   
                    movto-estoq.esp-docto    <> 30  and   
                    movto-estoq.esp-docto    <> 31) then 
                    next.
        
                FOR FIRST ord-prod FIELDS (nr-ord-produ it-codigo cod-refer 
                                           &IF DEFINED (bf_man_sfc_lc) &then
                                           cod-lista-compon
                                           &endif) where
                          ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ NO-LOCK: END.
        
                if movto-estoq.it-codigo = ord-prod.it-codigo then next.
        
                /*** So considerar ordens para linha de processo ***/
                find first tt-op-consumo where 
                           tt-op-consumo.cod-estabel  = movto-estoq.cod-estabel  and
                           tt-op-consumo.cod-deposito = movto-estoq.cod-depos    and 
                           tt-op-consumo.cod-localiz  = movto-estoq.cod-localiz  and 
                           tt-op-consumo.es-codigo    = movto-estoq.it-codigo    and 
                           tt-op-consumo.cod-ref-es   = movto-estoq.cod-refer    and 
                           tt-op-consumo.nr-ord-produ = movto-estoq.nr-ord-produ and
                           tt-op-consumo.cod-unid-negoc = movto-estoq.cod-unid-negoc no-error.
        
        
                if  not available tt-op-consumo then do:
                    create tt-op-consumo.
                    assign tt-op-consumo.cod-estabel  = movto-estoq.cod-estabel 
                           tt-op-consumo.cod-deposito    = movto-estoq.cod-depos 
                           tt-op-consumo.cod-localiz  = movto-estoq.cod-localiz  
                           tt-op-consumo.es-codigo    = movto-estoq.it-codigo    
                           tt-op-consumo.cod-ref-es   = movto-estoq.cod-refer
                           tt-op-consumo.nr-ord-produ = ord-prod.nr-ord-produ
                           tt-op-consumo.dat-i-corte  = p-dat-inic
                           tt-op-consumo.dat-f-corte  = p-dat-fim
                           tt-op-consumo.dat-ult-aca  = ?
                           tt-op-consumo.it-codigo    = /* movto-estoq.item-pai */ ord-prod.it-codigo 
                           tt-op-consumo.r-rowid      = ROWID(ord-prod)
                           tt-op-consumo.cod-unid-negoc = movto-estoq.cod-unid-negoc.
        
        
                    &IF DEFINED (bf_man_sfc_lc) &THEN       
                        assign tt-op-consumo.cod-lista = ord-prod.cod-lista-compon.
        
                        FOR first item-man FIELDS (dec-1) where 
                                  item-man.it-codigo = tt-op-consumo.it-codigo NO-LOCK:
                            assign tt-op-consumo.fator-item-un-al = item-man.dec-1.
                        END.
                        FOR first item-man FIELDS (dec-1) where 
                                  item-man.it-codigo = tt-op-consumo.es-codigo no-lock:
                            assign tt-op-consumo.fator-comp-un-al = item-man.dec-1.               
     
                        END.
                    &ENDIF
                end.          
        
                find first btt-op-consumo where
                           btt-op-consumo.nr-ord-produ = tt-op-consumo.nr-ord-produ and
                           btt-op-consumo.dat-i-corte  = tt-op-consumo.dat-i-corte  and
                           rowid(btt-op-consumo)      <> rowid(tt-op-consumo) no-error.
        
                if  not available btt-op-consumo then
                    run CalcularQtdRepOrdem (input ord-prod.nr-ord-produ, 
                                             input ord-prod.it-codigo,
                                             input ord-prod.cod-refer,
                                             input p-dat-inic,
                                             input p-dat-fim,
                                             output tt-op-consumo.qtd-item, 
                                             output tt-op-consumo.qtd-recicl,
                                             output tt-op-consumo.qtd-refgda,
                                             output tt-op-consumo.dat-ult-aca).
                else 
                    assign tt-op-consumo.qtd-item    = btt-op-consumo.qtd-item
                           tt-op-consumo.qtd-recicl  = btt-op-consumo.qtd-recicl
                           tt-op-consumo.qtd-refgda  = btt-op-consumo.qtd-refgda 
                           tt-op-consumo.dat-ult-aca = btt-op-consumo.dat-ult-aca.
        
                /*** Entrada: devolve material, Saida: Requisita material ***/
                if  movto-estoq.tipo-trans = 1 then
                        assign tt-op-consumo.qtd-consumida = tt-op-consumo.qtd-consumida - movto-estoq.quantidade
                               p-de-qtd-consumida = p-de-qtd-consumida - movto-estoq.quantidade.
                else
                        assign tt-op-consumo.qtd-consumida = tt-op-consumo.qtd-consumida + movto-estoq.quantidade
                               p-de-qtd-consumida = p-de-qtd-consumida + movto-estoq.quantidade.
                               .           
        
            end.
        END.
    &ENDIF
END PROCEDURE.

/********************************************************************************
** 
** PROCEDURE PesquisarOrdensItem:
** OBJETIVO: Determina ordens que movimentaram um componente numa faixa de datas
** PAR“METROS: i-cod-estabel
**             i-es-codigo
**             i-dat-inic
**             i-dat-fim
**             o-tt-op-consumo (nro ordem, item da ordem, qtd-real, qtd-padrao)
**               
********************************************************************************/

PROCEDURE PesquisarOrdensItem:

    define input parameter p-cod-estabel  AS CHARACTER  no-undo.
    define input parameter p-es-codigo    AS CHARACTER      no-undo.
    define input parameter p-cod-ref-es   AS CHARACTER       no-undo.
    define input parameter p-dat-inic     as date                       no-undo.
    define input parameter p-dat-fim      as date                       no-undo.
    DEFINE OUTPUT PARAMETER p-de-qtd-consumida AS DECIMAL NO-UNDO.

    define buffer btt-op-consumo for tt-op-consumo.

    ASSIGN p-de-qtd-consumida = 0.
    run InicializarOrdensItem (p-cod-estabel,
                               p-es-codigo,
                               p-cod-ref-es,
                               input-output table tt-op-consumo).

    find first param-global no-lock no-error.

    /*** Retroatividade de movimentos ***/

    for each movto-estoq  fields (it-codigo cod-estabel dt-trans cod-refer nr-ord-produ esp-docto 
                                  cod-depos cod-localiz tipo-trans quantidade ) 
        use-index item-data
        where movto-estoq.it-codigo   = p-es-codigo
          and movto-estoq.cod-estabel = p-cod-estabel
          and movto-estoq.dt-trans    >  p-dat-inic - 1
          and movto-estoq.dt-trans    <  p-dat-fim + 1  no-lock:

        if p-cod-ref-es <> "" and
           p-cod-ref-es <> movto-estoq.cod-refer then next.   

        if  movto-estoq.nr-ord-produ  = 0   or
           (movto-estoq.esp-docto    <> 5   and
            movto-estoq.esp-docto    <> 6   and
            movto-estoq.esp-docto    <> 7   and
            movto-estoq.esp-docto    <> 25  and  
            movto-estoq.esp-docto    <> 28  and   
            movto-estoq.esp-docto    <> 30  and   
            movto-estoq.esp-docto    <> 31) then 
            next.

        FOR FIRST ord-prod FIELDS (nr-ord-produ it-codigo cod-refer 
                                   &IF DEFINED (bf_man_sfc_lc) &then
                                   cod-lista-compon
                                   &endif) where
                  ord-prod.nr-ord-produ = movto-estoq.nr-ord-produ NO-LOCK: END.

        if movto-estoq.it-codigo = ord-prod.it-codigo then next.

        /*** So considerar ordens para linha de processo ***/
        find first tt-op-consumo where 
                   tt-op-consumo.cod-estabel  = movto-estoq.cod-estabel  and
                   tt-op-consumo.cod-deposito = movto-estoq.cod-depos    and 
                   tt-op-consumo.cod-localiz  = movto-estoq.cod-localiz  and 
                   tt-op-consumo.es-codigo    = movto-estoq.it-codigo    and 
                   tt-op-consumo.cod-ref-es   = movto-estoq.cod-refer    and 
                   tt-op-consumo.nr-ord-produ = movto-estoq.nr-ord-produ no-error.


        if  not available tt-op-consumo then do:
            create tt-op-consumo.
            assign tt-op-consumo.cod-estabel  = movto-estoq.cod-estabel 
                   tt-op-consumo.cod-deposito    = movto-estoq.cod-depos 
                   tt-op-consumo.cod-localiz  = movto-estoq.cod-localiz  
                   tt-op-consumo.es-codigo    = movto-estoq.it-codigo    
                   tt-op-consumo.cod-ref-es   = movto-estoq.cod-refer
                   tt-op-consumo.nr-ord-produ = ord-prod.nr-ord-produ
                   tt-op-consumo.dat-i-corte  = p-dat-inic
                   tt-op-consumo.dat-f-corte  = p-dat-fim
                   tt-op-consumo.dat-ult-aca  = ?
                   tt-op-consumo.it-codigo    = /* movto-estoq.item-pai */ ord-prod.it-codigo 
                   tt-op-consumo.r-rowid      = ROWID(ord-prod).


            &IF DEFINED (bf_man_sfc_lc) &THEN       
                assign tt-op-consumo.cod-lista = ord-prod.cod-lista-compon.

                FOR first item-man FIELDS (dec-1) where 
                          item-man.it-codigo = tt-op-consumo.it-codigo NO-LOCK:
                    assign tt-op-consumo.fator-item-un-al = item-man.dec-1.
                END.
                FOR first item-man FIELDS (dec-1) where 
                          item-man.it-codigo = tt-op-consumo.es-codigo no-lock:
                    assign tt-op-consumo.fator-comp-un-al = item-man.dec-1.                    
                END.
            &ENDIF
        end.          

        find first btt-op-consumo where
                   btt-op-consumo.nr-ord-produ = tt-op-consumo.nr-ord-produ and
                   btt-op-consumo.dat-i-corte  = tt-op-consumo.dat-i-corte  and
                   rowid(btt-op-consumo)      <> rowid(tt-op-consumo) no-error.

        if  not available btt-op-consumo then
            run CalcularQtdRepOrdem (input ord-prod.nr-ord-produ, 
                                     input ord-prod.it-codigo,
                                     input ord-prod.cod-refer,
                                     input p-dat-inic,
                                     input p-dat-fim,
                                     output tt-op-consumo.qtd-item, 
                                     output tt-op-consumo.qtd-recicl,
                                     output tt-op-consumo.qtd-refgda,
                                     output tt-op-consumo.dat-ult-aca).
        else 
            assign tt-op-consumo.qtd-item    = btt-op-consumo.qtd-item
                   tt-op-consumo.qtd-recicl  = btt-op-consumo.qtd-recicl
                   tt-op-consumo.qtd-refgda  = btt-op-consumo.qtd-refgda 
                   tt-op-consumo.dat-ult-aca = btt-op-consumo.dat-ult-aca.

        /*** Entrada: devolve material, Saida: Requisita material ***/
        if  movto-estoq.tipo-trans = 1 then
                assign tt-op-consumo.qtd-consumida = tt-op-consumo.qtd-consumida - movto-estoq.quantidade
                       p-de-qtd-consumida = p-de-qtd-consumida - movto-estoq.quantidade.
        else
                assign tt-op-consumo.qtd-consumida = tt-op-consumo.qtd-consumida + movto-estoq.quantidade
                       p-de-qtd-consumida = p-de-qtd-consumida + movto-estoq.quantidade.

    end.

END PROCEDURE.

/********************************************************************************
** 
** PROCEDURE SumarizarTabelaConsumo:
** OBJETIVO: Resume tabela tt-op-consumo por item, referencia,
**           componente, referencia do componente, lista de componentes, roteiro
** PAR“METROS: io - tt-op-consumo
**               
********************************************************************************/
PROCEDURE SumarizarTabelaConsumo:

    def input-output param table for tt-op-consumo.

    def var i-nr-ord-ant as decimal  no-undo.
    def var c-it-cod-ant AS CHAR     no-undo.
    def var c-es-cod-ant AS CHAR     no-undo.
    def buffer b-tt-op-consumo for tt-op-consumo.

    for each tt-item-processo:
       delete tt-item-processo.
    end.   

    for each tt-op-consumo 
         BREAK BY tt-op-consumo.es-codigo
               BY tt-op-consumo.cod-ref-es
               BY tt-op-consumo.nr-ord-produ
               BY tt-op-consumo.cod-estabel
               BY tt-op-consumo.cod-deposito
               BY tt-op-consumo.cod-localiz
               BY tt-op-consumo.es-lote   
               BY tt-op-consumo.it-codigo
               BY tt-op-consumo.cod-ref-it
               BY tt-op-consumo.cod-lista
               BY tt-op-consumo.cod-roteiro:


        IF i-nr-ord-ant <> tt-op-consumo.nr-ord-produ then do:

           find first tt-item-processo where
                      tt-item-processo.it-codigo   = tt-op-consumo.it-codigo   and
                      tt-item-processo.es-codigo   = tt-op-consumo.es-codigo   AND
                      tt-item-processo.cod-ref-it  = tt-op-consumo.cod-ref-it  and  
                      tt-item-processo.cod-lista   = tt-op-consumo.cod-lista   and  
                      tt-item-processo.cod-roteiro = tt-op-consumo.cod-roteiro no-error.
           if not available tt-item-processo then do:
              create tt-item-processo.
              assign tt-item-processo.it-codigo   = tt-op-consumo.it-codigo  
                     tt-item-processo.es-codigo   = tt-op-consumo.es-codigo
                     tt-item-processo.cod-ref-it  = tt-op-consumo.cod-ref-it 
                     tt-item-processo.cod-lista   = tt-op-consumo.cod-lista    
                     tt-item-processo.cod-roteiro = tt-op-consumo.cod-roteiro
                     tt-item-processo.qtd-item     = tt-item-processo.qtd-item   + tt-op-consumo.qtd-item
                     tt-item-processo.qtd-refgda   = tt-item-processo.qtd-refgda + tt-op-consumo.qtd-refgda
                     tt-item-processo.qtd-recicl   = tt-item-processo.qtd-recicl + tt-op-consumo.qtd-recicl
                     tt-item-processo.nr-ord-produ = tt-op-consumo.nr-ord-produ
                     i-nr-ord-ant                  = tt-op-consumo.nr-ord-produ
                     c-it-cod-ant                  = tt-op-consumo.it-codigo
                     c-es-cod-ant                  = tt-op-consumo.es-codigo.
           end.          
           ELSE 
                assign tt-item-processo.qtd-item     = tt-item-processo.qtd-item   + tt-op-consumo.qtd-item
                       tt-item-processo.qtd-refgda   = tt-item-processo.qtd-refgda + tt-op-consumo.qtd-refgda
                       tt-item-processo.qtd-recicl   = tt-item-processo.qtd-recicl + tt-op-consumo.qtd-recicl
                       tt-item-processo.nr-ord-produ = tt-op-consumo.nr-ord-produ
                       i-nr-ord-ant                  = tt-op-consumo.nr-ord-produ
                       c-it-cod-ant                  = tt-op-consumo.it-codigo
                       c-es-cod-ant                  = tt-op-consumo.es-codigo.
        end.
        ELSE DO: 

            IF tt-op-consumo.it-codigo =  c-it-cod-ant AND
               tt-op-consumo.es-codigo NE c-es-cod-ant THEN DO:

               find first tt-item-processo where
                          tt-item-processo.it-codigo   = tt-op-consumo.it-codigo   and
                          tt-item-processo.es-codigo   = tt-op-consumo.es-codigo   AND
                          tt-item-processo.cod-ref-it  = tt-op-consumo.cod-ref-it  and  
                          tt-item-processo.cod-lista   = tt-op-consumo.cod-lista   and  
                          tt-item-processo.cod-roteiro = tt-op-consumo.cod-roteiro no-error.
               if not available tt-item-processo then do:
                  create tt-item-processo.
                  assign tt-item-processo.it-codigo   = tt-op-consumo.it-codigo  
                         tt-item-processo.es-codigo   = tt-op-consumo.es-codigo
                         tt-item-processo.cod-ref-it  = tt-op-consumo.cod-ref-it 
                         tt-item-processo.cod-lista   = tt-op-consumo.cod-lista    
                         tt-item-processo.cod-roteiro = tt-op-consumo.cod-roteiro
                         tt-item-processo.qtd-item     = tt-item-processo.qtd-item   + tt-op-consumo.qtd-item
                         tt-item-processo.qtd-refgda   = tt-item-processo.qtd-refgda + tt-op-consumo.qtd-refgda
                         tt-item-processo.qtd-recicl   = tt-item-processo.qtd-recicl + tt-op-consumo.qtd-recicl
                         tt-item-processo.nr-ord-produ = tt-op-consumo.nr-ord-produ
                         i-nr-ord-ant                  = tt-op-consumo.nr-ord-produ
                         c-it-cod-ant                  = tt-op-consumo.it-codigo
                         c-es-cod-ant                  = tt-op-consumo.es-codigo. 
               END.          
               ELSE
                   assign tt-item-processo.qtd-item     = tt-item-processo.qtd-item   + tt-op-consumo.qtd-item
                          tt-item-processo.qtd-refgda   = tt-item-processo.qtd-refgda + tt-op-consumo.qtd-refgda
                          tt-item-processo.qtd-recicl   = tt-item-processo.qtd-recicl + tt-op-consumo.qtd-recicl
                          tt-item-processo.nr-ord-produ = tt-op-consumo.nr-ord-produ
                          i-nr-ord-ant                  = tt-op-consumo.nr-ord-produ
                          c-it-cod-ant                  = tt-op-consumo.it-codigo
                          c-es-cod-ant                  = tt-op-consumo.es-codigo.
            END.
        END.
        assign tt-op-consumo.qtd-item      = 0
               tt-op-consumo.qtd-recicl    = 0
               tt-op-consumo.qtd-refgda    = 0.
    end.   

    for each tt-op-consumo 
        BREAK BY tt-op-consumo.nr-ord-produ
             BY tt-op-consumo.cod-estabel
             BY tt-op-consumo.cod-deposito
             BY tt-op-consumo.cod-localiz
             BY tt-op-consumo.es-codigo
             BY tt-op-consumo.es-lote
             BY tt-op-consumo.cod-ref-es
             BY tt-op-consumo.it-codigo
             BY tt-op-consumo.cod-ref-it
             BY tt-op-consumo.cod-lista
             BY tt-op-consumo.cod-roteiro:

        find first b-tt-op-consumo
             where b-tt-op-consumo.it-codigo   = tt-op-consumo.it-codigo
               and b-tt-op-consumo.es-codigo   = tt-op-consumo.es-codigo
               and b-tt-op-consumo.cod-ref-it  = tt-op-consumo.cod-ref-it
               and b-tt-op-consumo.cod-ref-es  = tt-op-consumo.cod-ref-es
               and b-tt-op-consumo.cod-lista   = tt-op-consumo.cod-lista
               and b-tt-op-consumo.cod-roteiro = tt-op-consumo.cod-roteiro no-error.
        if avail b-tt-op-consumo and 
           rowid(b-tt-op-consumo) <> rowid(tt-op-consumo) then do:
           assign b-tt-op-consumo.qtd-consumida = b-tt-op-consumo.qtd-consumida + tt-op-consumo.qtd-consumida
                  b-tt-op-consumo.qtd-teorica   = b-tt-op-consumo.qtd-teorica   + tt-op-consumo.qtd-teorica.
           delete tt-op-consumo.
        end.
        if avail b-tt-op-consumo AND b-tt-op-consumo.qtd-item <= 0 then do:
            find first tt-item-processo where 
                       tt-item-processo.it-codigo   = b-tt-op-consumo.it-codigo   and
                       tt-item-processo.es-codigo   = b-tt-op-consumo.es-codigo   AND
                       tt-item-processo.cod-ref-it  = b-tt-op-consumo.cod-ref-it  and
                       tt-item-processo.cod-lista   = b-tt-op-consumo.cod-lista   and
                       tt-item-processo.cod-roteiro = b-tt-op-consumo.cod-roteiro NO-ERROR.

            IF AVAIL tt-item-processo THEN DO:
                assign b-tt-op-consumo.qtd-item     = tt-item-processo.qtd-item
                       b-tt-op-consumo.qtd-refgda   = tt-item-processo.qtd-refgda
                       b-tt-op-consumo.qtd-recicl   = tt-item-processo.qtd-recicl
                       b-tt-op-consumo.nr-ord-produ = tt-item-processo.nr-ord-produ.
            END.
        end.
    end.

END PROCEDURE.          


/********************************************************************************
** 
** PROCEDURE CalcularQtdAjuste:
** OBJETIVO: Calcula as quantidades a serem ajustadas na tt-op-consumo
**           (tt-op-consumo.qtd-ajuste e tt-op-consumo.perc-distrib) 
** PAR“METROS: io - tt-op-consumo
**             es-codigo
**             cod-refer-es
**             p-qtd-ajuste
**             p-log-padrao (distribui pelo padrao / real) (yes / no)
**               
********************************************************************************/
PROCEDURE CalcularQtdAjuste:

    define input parameter p-qtd-difer    like ord-prod.qt-ordem   no-undo.
    define input parameter p-log-padrao   as logical               no-undo.
    define input parameter p-es-codigo    AS CHARACTER no-undo.
    define input parameter p-cod-refer-es AS CHARACTER no-undo.
    define input parameter p-es-lote      AS CHARACTER no-undo.
    DEFINE INPUT PARAMETER p-cod-localiz  AS CHARACTER NO-UNDO.
    define input-output parameter table for tt-op-consumo.

    def var de-acum   like ord-prod.qt-ordem no-undo.
    def var de-acum-p like ord-prod.qt-ordem no-undo.
    def var de-acum-r like ord-prod.qt-ordem no-undo.
    def var i-num-reg as int                 no-undo.
    def var de-correcao as decimal           no-undo.
    FOR FIRST ITEM FIELDS (IT-CODIGO FRACIONA) 
        where item.it-codigo = p-es-codigo no-lock: END.

    for each tt-op-consumo where
             tt-op-consumo.es-codigo   = p-es-codigo    and
             tt-op-consumo.cod-ref-es  = p-cod-refer-es and
             tt-op-consumo.es-lote     = p-es-lote      AND 
             tt-op-consumo.cod-localiz = p-cod-localiz:

        assign  de-acum-p  = de-acum-p + tt-op-consumo.qtd-consumida
                de-acum-r  = de-acum-r + tt-op-consumo.qtd-teorica
                i-num-reg  = i-num-reg + 1.

        end.

    if  not p-log-padrao then
        assign de-acum = de-acum-p.
    else
        assign de-acum = de-acum-r.

    assign de-correcao = 0.
    for each tt-op-consumo where
             tt-op-consumo.es-codigo  = p-es-codigo    and
             tt-op-consumo.cod-ref-es = p-cod-refer-es and
             tt-op-consumo.es-lote    = p-es-lote      AND 
             tt-op-consumo.cod-localiz = p-cod-localiz:

        if  avail item then do: 
            if  not p-log-padrao then
                assign  tt-op-consumo.perc-distrib = if  de-acum > 0
                                                     then tt-op-consumo.qtd-consumida / de-acum * 100
                                                     else 100 / i-num-reg.
            else
                assign tt-op-consumo.perc-distrib = if  de-acum > 0 
                                                    then tt-op-consumo.qtd-teorica / de-acum * 100
                                                    else 100 / i-num-reg. 

            assign tt-op-consumo.qtd-ajuste = p-qtd-difer * (tt-op-consumo.perc-distrib / 100).

            if  item.fraciona = no 
            and int(tt-op-consumo.qtd-ajuste) <> tt-op-consumo.qtd-ajuste then
                assign tt-op-consumo.qtd-ajuste = round(tt-op-consumo.qtd-ajuste, 0).

        end.

        assign de-correcao = de-correcao + tt-op-consumo.qtd-ajuste.

    end.

    if  p-qtd-difer <> de-correcao then DO:
        
        assign de-correcao = p-qtd-difer - de-correcao.
        
		find first tt-op-consumo
			where tt-op-consumo.es-codigo = p-es-codigo      and
				  tt-op-consumo.cod-ref-es = p-cod-refer-es  and
				  tt-op-consumo.es-lote = p-es-lote          AND 
				  tt-op-consumo.cod-localiz = p-cod-localiz NO-ERROR.
        if  available tt-op-consumo then do:
            assign tt-op-consumo.qtd-ajuste = tt-op-consumo.qtd-ajuste + de-correcao.
        end.
    end.


END PROCEDURE.


/********************************************************************************
** 
** PROCEDURE AjustarConsumoNivelItem:
** OBJETIVO: Reorganiza a tt-op-consumo a nðvel de item fabricado
** PAR“METROS: io - tt-op-consumo
**             p-es-codigo
**             p-cod-refer                
********************************************************************************/

PROCEDURE AjustarConsumoNivelItem:

    define input-output parameter table for tt-op-consumo.
    define input  parameter p-es-codigo       AS CHARACTER      no-undo.
    define input  parameter p-cod-refer-es    AS CHARACTER       no-undo.
    define input  parameter p-es-lote         AS CHARACTER      no-undo.

    def buffer b-tt-op-consumo for tt-op-consumo.
    def buffer b-ord-prod      for ord-prod.
    def var v-num-ord          like ord-prod.nr-ord-produ no-undo.

    for each tt-op-consumo
        where tt-op-consumo.es-codigo  = p-es-codigo
        and   tt-op-consumo.cod-ref-es = p-cod-refer-es
        and   tt-op-consumo.es-lote    = p-es-lote:

        FOR FIRST ord-prod FIELDS (NR-ORD-PRODU IT-CODIGO ESTADO QT-ORDEM) 
            where ord-prod.nr-ord-produ = tt-op-consumo.nr-ord-produ no-lock:

            FOR first b-tt-op-consumo
                 where b-tt-op-consumo.it-codigo    = tt-op-consumo.it-codigo
                   and b-tt-op-consumo.cod-ref-it   = tt-op-consumo.cod-ref-it
                   and b-tt-op-consumo.cod-lista    = tt-op-consumo.cod-lista
                   and b-tt-op-consumo.es-codigo    = tt-op-consumo.es-codigo
                   and b-tt-op-consumo.cod-ref-es   = tt-op-consumo.cod-ref-es
                   and rowid(b-tt-op-consumo) <> rowid(tt-op-consumo) :

                  FOR FIRST b-ord-prod FIELDS (NR-ORD-PRODU IT-CODIGO ESTADO QT-ORDEM) 
                     where b-ord-prod.nr-ord-produ = b-tt-op-consumo.nr-ord-produ
                     no-lock : 
                  END.
                  assign tt-op-consumo.qtd-item      = tt-op-consumo.qtd-item     + b-tt-op-consumo.qtd-item
                        tt-op-consumo.qtd-consumida = tt-op-consumo.qtd-consumida + 
                                                      b-tt-op-consumo.qtd-consumida.

                  delete b-tt-op-consumo.

                  if b-ord-prod.estado   = ord-prod.estado and
                    b-ord-prod.qt-ordem = ord-prod.qt-ordem then
                    assign tt-op-consumo.nr-ord-produ = max(b-ord-prod.nr-ord-produ, ord-prod.nr-ord-produ).    

                  if b-ord-prod.estado   = ord-prod.estado then
                    assign tt-op-consumo.nr-ord-produ = if (b-ord-prod.qt-ordem > ord-prod.qt-ordem)
                                                        then b-ord-prod.nr-ord-produ
                                                        else ord-prod.nr-ord-produ.
                  if b-ord-prod.estado <> ord-prod.estado then
                    assign tt-op-consumo.nr-ord-produ = if (b-ord-prod.estado < ord-prod.estado)
                                                        then b-ord-prod.nr-ord-produ
                                                        else ord-prod.nr-ord-produ.
            end. 
        end.
    end.

END PROCEDURE.


/********************************************************************************
** 
** PROCEDURE: RequisitarQtdAjuste:
** OBJETIVO:  Requisita automaticamente quantidades de ajuste para acertar 
**            o saldo de estoque
** PAR“METROS: i - p-nr-ord-produ
**             i - p-cod-es-codigo
**             i - p-cod-refer-es
**             i - p-qtd-reqdev (Quantidade requisitada / Devolvida)
**
**               
********************************************************************************/
PROCEDURE RequisitarQtdAjuste:

    def param buffer b-tt-op-consumo for tt-op-consumo.

    def var l-erro         as log  no-undo.
    def var l-terminada    as log  no-undo.
    def var c-conta-aplic  as char format "x(17)" no-undo.
    def var c-ccusto-aplic  as char format "x(17)" no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
    def var i-empresa-prin LIKE empresa.ep-codigo  no-undo.
&ELSE
    def var i-empresa-prin as int  no-undo.
&ENDIF

	def var v_cod_cta_ctbl       as char   no-undo.
	
	def var v_titulo_cta_ctbl    as char   no-undo.
	def var v_num_tip_cta_ctbl   as int    no-undo.
	def var v_num_sit_cta_ctbl   as int    no-undo.
	def var v_ind_finalid_cta    as char   no-undo.
		
	def var h_api_cta_ctbl          as handle  no-undo.
	def var c_formato_conta         as char    no-undo.
	
    DEFINE VARIABLE i-esp-docto AS INTEGER NO-UNDO.

    for each tt-movto:
        delete tt-movto.
    end.

    EMPTY TEMP-TABLE tt-erro.

    find item
        where item.it-codigo = b-tt-op-consumo.es-codigo no-lock no-error.
    find ord-prod NO-LOCK
        where ord-prod.nr-ord-produ = b-tt-op-consumo.nr-ord-produ no-error.

    /*** Para conseguir fazer requisi¯Êo ou devolu¯Êo de ordens terminadas ***/
    if  ord-prod.estado = 8 then DO:

        FIND CURRENT ord-prod EXCLUSIVE-LOCK.
        assign ord-prod.estado = 7
               l-terminada     = yes.    
    END.

    create tt-movto.
    assign tt-movto.cod-versao-integracao = 001
           tt-movto.cod-prog-orig  = "boin218"
           tt-movto.usuario        = c-seg-usuario
           tt-movto.it-codigo      = b-tt-op-consumo.es-codigo
           tt-movto.cod-refer      = b-tt-op-consumo.cod-ref-es
           tt-movto.cod-estabel    = b-tt-op-consumo.cod-estabel
           tt-movto.dt-trans       = b-tt-op-consumo.dat-ult-aca
           tt-movto.dt-nf-saida    = b-tt-op-consumo.dat-ult-aca
           tt-movto.cod-depos      = b-tt-op-consumo.cod-deposito
           tt-movto.cod-localiz    = b-tt-op-consumo.cod-localiz
           tt-movto.lote           = b-tt-op-consumo.es-lote    
           tt-movto.nr-ord-produ   = b-tt-op-consumo.nr-ord-produ
           tt-movto.ct-codigo      = ord-prod.ct-codigo
           tt-movto.sc-codigo      = ord-prod.sc-codigo
           tt-movto.un             = item.un
           tt-movto.tipo-valor     = 2    /* Valorizado */    
           tt-movto.nro-docto      = string(ord-prod.nr-ord-produ).

    IF  b-tt-op-consumo.qtd-ajuste  > 0 THEN
        ASSIGN tt-movto.esp-docto   = 31 /* RRQ */
               tt-movto.tipo-trans  = 1
               tt-movto.quantidade  = min(b-tt-op-consumo.qtd-ajuste, b-tt-op-consumo.qtd-consumida)
               tt-movto.dt-trans    = b-tt-op-consumo.dat-ult-aca
               tt-movto.dt-nf-saida = b-tt-op-consumo.dat-ult-aca
               i-esp-docto = 28.
    ELSE
        ASSIGN tt-movto.esp-docto   = 28 /* REQ */
               tt-movto.tipo-trans  = 2
               tt-movto.quantidade  = b-tt-op-consumo.qtd-ajuste * -1
               tt-movto.dt-trans    = b-tt-op-consumo.dat-ult-aca
               tt-movto.dt-nf-saida = b-tt-op-consumo.dat-ult-aca
               i-esp-docto = 31.
		   
    IF ord-prod.rep-prod = 2 or 
       ord-prod.rep-prod = 3 THEN DO:
        FIND FIRST reservas NO-LOCK
             WHERE reservas.nr-ord-produ = tt-movto.nr-ord-produ
               AND reservas.it-codigo    = tt-movto.it-codigo
               AND reservas.cod-refer    = tt-movto.cod-refer
               AND reservas.op-codigo    > 0 NO-ERROR.
        IF AVAIL reservas THEN
          FIND oper-ord NO-LOCK
            WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
              AND oper-ord.it-codigo    = reservas.item-pai 
			  AND oper-ord.cod-roteiro  = reservas.cod-roteiro
              AND oper-ord.op-codigo    = reservas.op-codigo NO-ERROR.
        ELSE DO:
            FOR LAST oper-ord NO-LOCK
               WHERE oper-ord.nr-ord-produ = ord-prod.nr-ord-produ:
            END.
        END.
        IF AVAIL oper-ord THEN
            ASSIGN tt-movto.op-seq = oper-ord.sequencia.
			
        FIND FIRST movto-estoq NO-LOCK
             WHERE movto-estoq.nr-ord-produ = tt-movto.nr-ord-produ
               AND movto-estoq.it-codigo    = tt-movto.it-codigo
               AND movto-estoq.cod-refer    = tt-movto.cod-refer			   
               AND movto-estoq.esp-docto    = i-esp-docto
               AND movto-estoq.op-seq      <> 0 NO-ERROR.

        IF AVAIL movto-estoq THEN
            ASSIGN tt-movto.op-seq = movto-estoq.op-seq.
    END.

    if  item.fraciona = no
    and int(tt-movto.quantidade) <> tt-movto.quantidade then 
        assign tt-movto.quantidade = truncate(tt-movto.quantidade,0) + 1.

    IF tt-movto.quantidade = 0 THEN 
        return.
		
    if  item.tipo-contr <> 2
    or  item.it-codigo  =  ""
    or  item.it-codigo  =  ?  then do:

        &IF DEFINED (bf_man_sfc_lc) &THEN
        if  item.tipo-contr = 3 then do:
            find first param-cp no-lock no-error.
            &IF DEFINED (bf_mat_conta_estab) &THEN
                find first estab-mfg 
                     where estab-mfg.cod-estabel = tt-movto.cod-estabel no-lock no-error.
                if avail estab-mfg and
                   estab-mfg.cod-cta-unif <> ? then
                       assign c-conta-aplic  = estab-mfg.cod-cta-unif
                              c-ccusto-aplic = estab-mfg.cod-ccusto-unif.
                else
            &ENDIF
                    assign c-conta-aplic = param-cp.cod-cta-unif
                           c-ccusto-aplic = param-cp.cod-ccusto-unif.
        end.
        else
        &ENDIF
            assign c-conta-aplic = item.ct-codigo
                   c-ccusto-aplic = item.sc-codigo.


        assign i-empresa-prin = param-global.empresa-prin.
        &IF DEFINED (bf_mat_conta_estab) &THEN
            find first estabelec
                 where estabelec.cod-estabel = tt-movto.cod-estabel no-lock no-error.
            if avail estabelec then
               run cdp/cd9970.p (input rowid(estabelec),
                                 output i-empresa-prin).
        &ENDIF

		assign v_cod_cta_ctbl = c-conta-aplic.
		
		run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

        /* CONTA */
		run pi_busca_dados_cta_ctbl in h_api_cta_ctbl ( input        i-empresa-prin,     /* EMPRESA EMS2 */
                                                        input        "",                 /* PLANO DE CONTAS */
                                                        input-output v_cod_cta_ctbl,     /* CONTA */
                                                        input        today,              /* DATA TRANSACAO */   
                                                        output       v_titulo_cta_ctbl,  /* DESCRICAO CONTA */
                                                        output       v_num_tip_cta_ctbl, /* TIPO DA CONTA */
                                                        output       v_num_sit_cta_ctbl, /* SITUACAO DA CONTA */
                                                        output       v_ind_finalid_cta,  /* FINALIDADES DA CONTA */
                                                        output table tt_log_erro).       /* ERROS */
														
		delete object h_api_cta_ctbl.

        assign tt-movto.ct-db = v_cod_cta_ctbl.
		assign tt-movto.sc-db = c-ccusto-aplic.


		/*
        for first conta-contab fields (ep-codigo   conta-contabil
                                       sc-codigo   ct-codigo)
            where conta-contab.ep-codigo      = i-empresa-prin
              and conta-contab.conta-contabil = c-conta-aplic
              no-lock: end.

		assign tt-movto.conta-db = conta-contab.conta-contabil  **conta
               tt-movto.ct-db    = conta-contab.ct-codigo       **conta reduzida
               tt-movto.sc-db    = conta-contab.sc-codigo.      **centro de custo													
		*/

    end.

    /* a exclus’o do handle ² feito na BOIN218.*/
    IF NOT VALID-HANDLE(h-ceapi001k) THEN
        RUN cep/ceapi001k.p PERSISTENT SET h-ceapi001k.


    RUN pi-execute IN h-ceapi001k (INPUT-OUTPUT TABLE tt-movto,
                                   INPUT-OUTPUT TABLE tt-erro,
                                   INPUT NO).

    assign l-erro = (return-value = "nok" OR CAN-FIND(FIRST tt-erro)). 

    /*** Volta estado da ordem para terminada ***/
    if  l-terminada then 
        assign ord-prod.estado = 8.

    RELEASE ord-prod.

    if  l-erro then
        return.

END PROCEDURE.
/********************************************************************************
** 
** PROCEDURE: piRecebeHandle:
**
********************************************************************************/
PROCEDURE piRecebeHandle:
    DEFINE INPUT PARAMETER pHldCeapi001k    AS HANDLE   NO-UNDO.

    ASSIGN h-ceapi001k = pHldCeapi001k.

END PROCEDURE.

/********************************************************************************
** 
** PROCEDURE: GetTTerro:
**
********************************************************************************/
PROCEDURE getTTerro:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
END PROCEDURE.



/********************************************************************************
** 
** PROCEDURE: CalcularQtdPadrao:
** OBJETIVO:  Determina quantidade padrÊo para a quantidade do item
** PAR“METROS: io tt-op-consumo
**
********************************************************************************/
PROCEDURE CalcularQtdPadrao:

    define input-output parameter table for tt-op-consumo.

    DEFINE BUFFER b-estrutura FOR estrutura.

    for each tt-op-consumo
        BREAK BY tt-op-consumo.es-codigo:
      /*IF LAST-OF(tt-op-consumo.es-codigo) THEN DO:*/
        
        /*  Verifica se o valor contido no campo it-codigo ² coerente com a estrutura atual  */
            IF NOT CAN-FIND(FIRST estrutura WHERE 
                                  estrutura.it-codigo = tt-op-consumo.it-codigo AND 
                                  estrutura.es-codigo = tt-op-consumo.es-codigo) THEN DO:

               FOR EACH tt-aux:  DELETE tt-aux.  END.

               /*  Faz a verifica»’o dos itens/componentes que foram requisitados na ordem  */
               /*  e grava na tt-aux                                                        */
               FOR EACH ord-prod FIELDS (nr-ord-produ it-codigo es-codigo) WHERE 
                        ord-prod.nr-ord-produ = tt-op-consumo.nr-ord-produ NO-LOCK,
                   FIRST estrutura FIELDS (it-codigo es-codigo)
                        WHERE estrutura.it-codigo = ord-prod.it-codigo NO-LOCK:

                   RUN CriaPaiFilho (INPUT estrutura.it-codigo,
                                     OUTPUT TABLE tt-aux).
               END.

               /*  Posiciona na estrutura conforme o componente */
               FOR FIRST b-estrutura FIELDS (es-codigo) WHERE 
                         b-estrutura.es-codigo = tt-op-consumo.es-codigo NO-LOCK: 
               END.

               /*  Caso seja vÿlido e tenha sido requisitado na ordem, grava o  */
               /*  it-codigo conforme estrutura                                 */
/*                FOR EACH tt-aux WHERE tt-aux.es-codigo = b-estrutura.es-codigo: */
/*                    ASSIGN tt-op-consumo.it-codigo = tt-aux.it-codigo.          */
/*                    LEAVE.                                                      */
/*                END.                                                            */
            END.

            run CalcularQuantoUsa (input  tt-op-consumo.it-codigo,
                                   input  tt-op-consumo.cod-ref-it,
                                   input  tt-op-consumo.cod-lista,
                                   input  tt-op-consumo.es-codigo,
                                   input  tt-op-consumo.cod-ref-es,
                                   input  tt-op-consumo.qtd-item,
                                   input  tt-op-consumo.dat-f-corte,
                                   output tt-op-consumo.qtd-teorica).
      /*   END.*/
    end.

END PROCEDURE.

/********************************************************************************
** 
** PROCEDURE: CalcularQuantoUsa:
** OBJETIVO:  Determina quantidade padrÊo para a quantidade do item
** PAR“METROS: i it-codigo
               i cod-refer
               i cod-lista-compon
               i es-codigo
               i cod-refer-es
               i qtd-pai
               o qtd-compon
**
********************************************************************************/
PROCEDURE CalcularQuantoUsa:

    def input  parameter p-it-codigo        like item.it-codigo no-undo.
    def input  parameter p-cod-refer        like item.cod-refer no-undo.
    def input  parameter p-cod-lista-compon as char format "x(16)" no-undo.
    def input  parameter p-es-codigo        like estrutura.es-codigo no-undo.
    def input  parameter p-cod-refer-es     like movto-estoq.cod-refer no-undo.
    def input  parameter p-qtd-pai          like movto-estoq.quantidade no-undo.
    def input  parameter p-data-corte       as date no-undo.
    def output parameter p-qtd-teorica      like movto-estoq.quantidade no-undo.

    def buffer b-estrutura for estrutura.

    def var v-qtd-usada    like movto-estoq.quantidade.
    def var de-fator-lista as dec no-undo.
    def var l-util-item    as log no-undo.
    def var c-ref-filho    as char no-undo.

    for each b-estrutura FIELDS (it-codigo es-codigo fantasma log-quant-fix sequencia
                                 &IF DEFINED (bf_man_sfc_lc) &THEN
                                  cod-lista-compon qtd-compon qtd-item
                                 &else quant-usada &endif) 
        where b-estrutura.it-codigo        = p-it-codigo
          and b-estrutura.data-inicio     <= p-data-corte
          and b-estrutura.data-termino    >= p-data-corte no-lock
          BREAK BY b-estrutura.es-codigo:

        &IF DEFINED (bf_man_sfc_lc) &THEN
          if not b-estrutura.cod-lista-compon = "" then next.
        &ENDIF

        IF  b-estrutura.fantasma = NO
        AND b-estrutura.es-codigo <> p-es-codigo
        AND NOT CAN-FIND(FIRST alternativo 
                         WHERE alternativo.it-codigo = b-estrutura.it-codigo
                           AND alternativo.sequencia = b-estrutura.sequencia
                           AND alternativo.es-codigo = b-estrutura.es-codigo
                           AND alternativo.al-codigo = p-es-codigo)
        THEN DO:
            NEXT.
        END.

        if  b-estrutura.es-codigo = p-es-codigo THEN DO:
            &IF DEFINED (bf_man_sfc_lc) &THEN
            /* D_MAN002 - Quantidade fixa para componentes de engenharia */
            assign p-qtd-teorica = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                   else p-qtd-teorica + 
                                        (p-qtd-pai     * (b-estrutura.qtd-compon / b-estrutura.qtd-item)).
            &ELSE
            assign p-qtd-teorica = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                   else p-qtd-teorica + 
                                        (p-qtd-pai     * b-estrutura.quant-usada).
            &ENDIF
        END.
        else do:
            // Caso tenha sido utilizado o item alternativo, busca as informa‡äes do item alternativo
            FIND FIRST alternativo 
                 WHERE alternativo.it-codigo = b-estrutura.it-codigo
                   AND alternativo.sequencia = b-estrutura.sequencia
                   AND alternativo.es-codigo = b-estrutura.es-codigo
                   AND alternativo.al-codigo = p-es-codigo
                NO-LOCK NO-ERROR.

            IF AVAIL alternativo
            THEN DO:
                assign p-qtd-teorica = if alternativo.log-quant-fix then alternativo.qtd-compon
                                       else p-qtd-teorica + 
                                            (p-qtd-pai * (alternativo.quant-usada / b-estrutura.qtd-item)).
            END.
            ELSE DO:
                &IF DEFINED (bf_man_sfc_lc) &THEN
                run CalcularQuantoUsa (input b-estrutura.es-codigo,
                                       input "",
                                       input "",
                                       input p-es-codigo,
                                       input p-cod-refer-es,
                                       /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                                       input if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                             else (p-qtd-pai * (b-estrutura.qtd-compon / b-estrutura.qtd-item)),
                                       input p-data-corte,
                                       output v-qtd-usada).
                &ELSE
                run CalcularQuantoUsa (input b-estrutura.es-codigo,
                                       input "",
                                       input "",
                                       input p-es-codigo,
                                       input p-cod-refer-es,
                                       input (p-qtd-pai * b-estrutura.quant-usada),
                                       input p-data-corte,
                                       output v-qtd-usada).            
                &ENDIF
                /* D_MAN002 - Quantidade fixa para componentes de engenharia */
                assign p-qtd-teorica = if b-estrutura.log-quant-fix then b-estrutura.qtd-compon
                                       else p-qtd-teorica + v-qtd-usada.
            END.
        end.
    end.
    &IF DEFINED (bf_man_sfc_lc) &THEN
    if  p-cod-lista-compon <> "" then do: 

        FOR FIRST lista-compon-item FIELDS (cod-lista-compon it-codigo qtd-lista qtd-item) 
            where lista-compon-item.it-codigo        = p-it-codigo
              and lista-compon-item.cod-lista-compon = p-cod-lista-compon NO-LOCK:
        END.
        if  not available lista-compon-item then
            return.

        /*** Identifica qual a quantidade da lista entra na composiîÒo do item. ***/
        assign de-fator-lista = p-qtd-pai * lista-compon-item.qtd-lista / lista-compon-item.qtd-item.


        DEFINE VARIABLE cComp AS CHARACTER   NO-UNDO.
        ASSIGN cComp = p-es-codigo.
        IF NOT CAN-FIND(FIRST item-lista-compon 
                         WHERE item-lista-compon.cod-lista-compon    = p-cod-lista-compon
                           AND item-lista-compon.es-codigo           = cComp)
        THEN DO:
            FIND FIRST alternativo 
                 WHERE alternativo.it-codigo = b-estrutura.it-codigo
                   AND alternativo.es-codigo = cComp
                NO-LOCK NO-ERROR.
            IF NOT AVAIL alternativo
            THEN DO:
                FIND FIRST alternativo 
                     WHERE alternativo.it-codigo = b-estrutura.it-codigo
                       AND alternativo.al-codigo = cComp
                    NO-LOCK NO-ERROR.
                IF NOT AVAIL alternativo 
                THEN DO:
                    ASSIGN cComp = "".
                END.
                ELSE DO:
                    assign  p-qtd-teorica = if alternativo.log-quant-fix 
                                            then alternativo.qtd-compon
                                            else p-qtd-teorica + (p-qtd-pai * alternativo.quant-usada).
                END.
            END.
            ELSE
                assign  p-qtd-teorica = if alternativo.log-quant-fix 
                                        then alternativo.qtd-compon
                                        else p-qtd-teorica + (p-qtd-pai * alternativo.quant-usada).
        END.

        for  each item-lista-compon FIELDS (es-codigo cod-ref-es fantasma cod-lista-compon sequencia proporcao qtd-compon qtd-lista log-quant-fix) 
            where item-lista-compon.cod-lista-compon    = p-cod-lista-compon
              AND item-lista-compon.es-codigo           = cComp
              and item-lista-compon.log-compon-altern   = no
              and item-lista-compon.data-termino        >  p-data-corte
              and item-lista-compon.data-inicio         <= p-data-corte no-lock:


            FOR FIRST ITEM FIELDS (it-codigo tipo-con-est fraciona) 
                WHERE ITEM.it-codigo = item-lista-compon.es-codigo NO-LOCK:
            END.

            if  item.tipo-con-est = 4 then do:
                if  item-lista-compon.cod-ref-es = "" then do:
                    if  can-find (first ref-item 
                                  where ref-item.it-codigo = item-lista-compon.es-codigo
                                    and ref-item.cod-refer = p-cod-refer) then
                        assign l-util-item = yes
                               c-ref-filho = p-cod-refer.
                    else 
                        assign l-util-item = no
                               c-ref-filho = "".
                end.
                else
                    assign l-util-item = yes
                           c-ref-filho = item-lista-compon.cod-ref-es.
            end.
            else
                assign l-util-item = yes
                       c-ref-filho = "".

            if (c-ref-filho <> p-cod-refer-es
            and not item-lista-compon.fantasma)
            or  not l-util-item then
                next.

            /* D_MAN002 - Quantidade fixa para componentes de engenharia */
            assign v-qtd-usada = if item-lista-compon.log-quant-fix  then item-lista-compon.qtd-compon
                                 else (item-lista-compon.qtd-compon / item-lista-compon.qtd-lista) *
                                       de-fator-lista               * item-lista-compon.proporcao  / 100.

            if  item.fraciona     = no
            and int(v-qtd-usada) <> v-qtd-usada then 
                assign v-qtd-usada = truncate(v-qtd-usada,0) + 1.

            if  item-lista-compon.fantasma then do:
                run CalcularQuantoUsa (input item-lista-compon.es-codigo,
                                       input c-ref-filho, 
                                       input "", 
                                       input p-es-codigo,
                                       input p-cod-refer-es,
                                       input v-qtd-usada, 
                                       input p-data-corte,
                                       output v-qtd-usada).
            END.

            /* D_MAN002 - Quantidade fixa para componentes de engenharia */
            assign p-qtd-teorica = if item-lista-compon.log-quant-fix then item-lista-compon.qtd-compon
                                   else p-qtd-teorica + v-qtd-usada.
        end.
    end.
    &ENDIF
END.

/********************************************************************************
** 
** PROCEDURE: GerarTabelaConsumoOrdem:
** OBJETIVO:  Gera¯Êo da tempor˜ria tt-op-consumo.
** PAR“METROS: i cod-estabel
               i cod-deposito
               i cod-localizacao
               i es-codigo
               i cod-refer-es
               i es-lote
               i qtd-ajuste (positivo a devolver, negativo a requisitar)
               o tt-op-consumo
**
********************************************************************************/
PROCEDURE GerarTabelaConsumoOrdem:

    def input  param p-cod-estab    AS CHARACTER    no-undo.
    def input  param p-cod-depos    AS CHARACTER    no-undo.
    def input  param p-cod-localiz  AS CHARACTER    no-undo.
    def input  param p-es-codigo    AS CHARACTER    no-undo.
    def input  param p-cod-refer-es AS CHARACTER    no-undo.
    def input  param p-es-lote      AS CHARACTER    no-undo.
    def input  param p-qtd-ajuste   as decimal      no-undo.
    def input  param p-dat-inic     as date         no-undo.
    def input  param p-dat-fim      as date         no-undo.
    define input-output parameter table for tt-op-consumo.
    run InicializarOrdensConsumo (p-cod-estab,
                                p-cod-depos,
                                p-cod-localiz,
                                p-es-codigo,
                                p-cod-refer-es,
                                p-es-lote,
                                input-output table tt-op-consumo).

    run PesquisarOrdensConsumo (input p-cod-estab,
                            input p-cod-depos,
                            input p-cod-localiz,
                            input p-es-codigo,
                            input p-cod-refer-es,
                            input p-es-lote,
                            input p-dat-inic,
                            input p-dat-fim,
                            input-output table tt-op-consumo).
    find first tt-op-consumo
         where tt-op-consumo.cod-estabel  = p-cod-estab    and
               tt-op-consumo.cod-deposito = p-cod-depos    and 
               tt-op-consumo.cod-localiz  = p-cod-localiz  and 
               tt-op-consumo.es-codigo    = p-es-codigo    and 
               tt-op-consumo.cod-ref-es   = p-cod-refer-es and
               tt-op-consumo.es-lote      = p-es-lote no-lock no-error.

    /*** Ajuste < 0 entÊo foi consumido mais do que o previsto ***/

    if  not avail tt-op-consumo
    and p-qtd-ajuste < 0 then do:

        FOR FIRST ITEM FIELDS (tipo-con-est) 
            where item.it-codigo = p-es-codigo NO-LOCK: END.


        if  item.tipo-con-est = 3 then do:
            run PesquisarOrdensConsumo (input p-cod-estab,
                                        input p-cod-depos,
                                        input p-cod-localiz,
                                        input p-es-codigo,
                                        input p-cod-refer-es,
                                        input ?,
                                        input p-dat-inic,
                                        input p-dat-fim,
                                        input-output table tt-op-consumo).
            for each tt-op-consumo where 
                     tt-op-consumo.cod-estabel  = p-cod-estab    and
                     tt-op-consumo.cod-deposito = p-cod-depos    and 
                     tt-op-consumo.cod-localiz  = p-cod-localiz  and 
                     tt-op-consumo.es-codigo    = p-es-codigo    and 
                     tt-op-consumo.cod-ref-es   = p-cod-refer-es and
                     tt-op-consumo.es-lote      = "":

                 assign tt-op-consumo.es-lote = p-es-lote.
            end.
        end.             

        /*** Procura em diferentes localiza¯´es ***/
        find first tt-op-consumo
             where tt-op-consumo.cod-estabel  = p-cod-estab    and
                   tt-op-consumo.cod-deposito = p-cod-depos    and 
                   tt-op-consumo.cod-localiz  = p-cod-localiz  and 
                   tt-op-consumo.es-codigo    = p-es-codigo    and 
                   tt-op-consumo.cod-ref-es   = p-cod-refer-es and
                   tt-op-consumo.es-lote      = p-es-lote no-lock no-error.

        if not available tt-op-consumo and 
           p-cod-localiz <> ""  and 
           not can-find (first tt-op-consumo where 
                              tt-op-consumo.cod-estabel  = p-cod-estab    and
                              tt-op-consumo.cod-deposito = p-cod-depos    and 
                              tt-op-consumo.cod-localiz  = ""                         and 
                              tt-op-consumo.es-codigo    = p-es-codigo    and 
                              tt-op-consumo.cod-ref-es   = p-cod-refer-es) then do:

            run PesquisarOrdensConsumo (input p-cod-estab,
                                        input p-cod-depos,
                                        input "",
                                        input p-es-codigo,
                                        input p-cod-refer-es,
                                        input ?,
                                        input p-dat-inic,
                                        input p-dat-fim,
                                        input-output table tt-op-consumo).

            for each tt-op-consumo where 
                     tt-op-consumo.cod-estabel  = p-cod-estab    and
                     tt-op-consumo.cod-deposito = p-cod-depos    and 
                     tt-op-consumo.cod-localiz  = ""             and 
                     tt-op-consumo.es-codigo    = p-es-codigo    and 
                     tt-op-consumo.cod-ref-es   = p-cod-refer-es and
                     tt-op-consumo.es-lote      = "":

                 assign tt-op-consumo.es-lote     = p-es-lote
                        tt-op-consumo.cod-localiz = p-cod-localiz.
            end.
        end.    
    end.

END PROCEDURE. 

/********************************************************************************
** PROCEDURE:  CriaPaiFilho
** OBJETIVO:   Cria recursivamente os relacionamentos Pai X Filho.
** PAR“METROS: in-it-codigo  -  Item pai
**             tt-aux        -  Temp table com os relacionamentos Pai X Filho
**
********************************************************************************/
PROCEDURE CriaPaiFilho:

  DEF INPUT PARAM in-it-codigo AS CHARACTER NO-UNDO.
  DEF OUTPUT PARAM TABLE FOR tt-aux.

  FOR EACH estrutura FIELDS (it-codigo es-codigo) WHERE 
           estrutura.it-codigo = in-it-codigo NO-LOCK:
      FIND FIRST tt-aux WHERE
                 tt-aux.it-codigo = estrutura.it-codigo AND
                 tt-aux.es-codigo = estrutura.es-codigo NO-ERROR.
      IF  NOT AVAIL tt-aux THEN DO:
          CREATE tt-aux.
          ASSIGN tt-aux.it-codigo = estrutura.it-codigo
                 tt-aux.es-codigo = estrutura.es-codigo.
          RUN CriaPaiFilho (INPUT estrutura.es-codigo,
                            OUTPUT TABLE tt-aux).
      END.
  END.

END PROCEDURE.
/********************************************************************************
** PROCEDURE:  retornaTTOPConsumo
** OBJETIVO:   Retornar a temp-table tt-op-consumo
** PAR“METROS: 
**
********************************************************************************/
PROCEDURE retornaTTOPConsumo.
DEFINE OUTPUT PARAMETER TABLE FOR tt-op-consumo.
END PROCEDURE.
