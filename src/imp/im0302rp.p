/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0302RP 2.00.00.012}  /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0302RP MIM}
&ENDIF


/*****************************************************************************
**
**     PROGRAMA: IM0302RP.P
**
**     DATA....: 10/09/1999
**
**     AUTOR...: DATASUL S.A.
**
**     OBJETIVO: Emissao de Fichas para Cota‡Æo
**
**     VERSÇO..: 1.00.000 - Vivian Beatriz de Almeida
**    
*****************************************************************************/

{cdp/cdcfgmat.i} /* Pre Processador Integracao Magnus */

{imp/im0302.i}

def var de-indice    as decimal    no-undo.
def var de-quant     as decimal    no-undo format "99,999,999,999.99" decimals 2.
def var da-data      as date       no-undo.
def var c-arq1       as char       no-undo.
def var c-arq2       as char       no-undo.
def var c-prog       as char       no-undo.
def var c-assunto-e-mail as char   no-undo.
def var c-item-fornec as char      no-undo format "x(20)".
def var c-descricao   as char      no-undo.
def var i-aux         as int       no-undo.
def var i-cont        as int       no-undo.
def var h-acomp       as handle    no-undo.
def var c-acompanha   as char      no-undo.
def var v-retorno     as char      no-undo.
def var v-cod-emit    like emitente.cod-emitente.
def var l-primeira as log  no-undo.
def var h-axssu003 as handle no-undo.
def var c-erro-eai as char no-undo.
def var c-lb-erro  as char no-undo.
def var c-lb-ajuda as char no-undo.

def new global shared variable v_log_eai_habilit as logical no-undo.

define temp-table ttQuotation no-undo
    field rw-cotacao-item as rowid.

define temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as int  initial ?
    field ttv_des_msg_ajuda as char initial ?
    field ttv_des_msg_erro  as char initial ?.

define temp-table tt_log_erro_aux no-undo like tt_log_erro.

def temp-table tt-raw-digita
    field raw-digita as raw.

def var r-registro as rowid no-undo.

{include/i-rpvar.i}

{utp/ut-liter.i Ficha_para_Cota‡Æo_de_Pre‡os * r}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i Erros_ocorridos_durante_o_envio_ao_EAI * r}
assign c-erro-eai = return-value.
{utp/ut-liter.i Erro * r}
assign c-lb-erro = return-value.
{utp/ut-liter.i Ajuda * r}
assign c-lb-ajuda = return-value.

{utp/ut-liter.i Importa‡Æo * r}
assign c-sistema = trim(return-value).

def input param raw-param as raw.
def input param table for tt-raw-digita.

def var c-arq-temp as char no-undo.

create tt-param.
raw-transfer raw-param to tt-param.

case tt-param.destino:
    when 1 then do:
       {utp/ut-liter.i Impressora * r}
       assign c-destino = trim(return-value).
    end.
    when 2 then do:
       {utp/ut-liter.i Arquivo * r}
       assign c-destino = trim(return-value). 
    end.
    when 3 then do:
       {utp/ut-liter.i Terminal * r}
       assign c-destino = trim(return-value).  
    end.
    when 4 then do:
       {utp/ut-liter.i E-mail * r}
       assign c-destino = trim(return-value). 
    end.    
end case.

{utp/ut-liter.i Dest._Inconsistˆncias * r}.
assign c-dest-inc = trim(return-value).
{utp/ut-liter.i SELE€ÇO * r}
find first param-global no-lock no-error.

assign c-empresa  = (if avail param-global then param-global.grupo else "")
       c-programa = "IM/0302"
       c-versao   = "1.00"
       c-revisao  = "000".

{include/i-rpcb80.i}

{cdp/cd-rpout.i}   /* include customizada Comex */

{utp/ut-liter.i Selecionando_Ordens_de_Compra * r}.
assign c-acompanha = return-value.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-acompanha).

find first param-compra 
     no-lock no-error.
if   avail param-compra then
     assign c-arq1 = trim(substr(param-compra.char-1, 1, 50))
            c-arq2 = trim(substr(param-compra.char-1, 51, 100)).

for each tt-inconsist:
    delete tt-inconsist.
end.

view frame f-cabec-80.
view frame f-rodape-80.

if  tt-param.l-envia 
then do:
    &if defined(bf-mat-comex) 
    &then
    &else
    /******* Envio por E-mail ********/ 
      run imp/im0302a.p (input raw-param,
                         input h-acomp). 
    &endif
end.
else do:

    {imp/im0302.i3}

   &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        if can-find (first ttQuotation no-lock) then do:
            run adapters/xml/su2/axssu003.p persistent set h-axssu003 (output table tt_log_erro) .
            run PIUpsertByQuoteList in h-axssu003 (input  table ttQuotation,
                                                   output table tt_log_erro).
            for each tt_log_erro no-lock:
                create tt_log_erro_aux.
                buffer-copy tt_log_erro to tt_log_erro_aux.
            end.
            delete procedure h-axssu003.
        end.
    &ENDIF

    assign c-traco1    = fill("-",80)
           v-cod-emit  = ?.

    {utp/ut-liter.i Ficha_para_Cota‡Æo_de_Pre‡os * r}
    assign c-titulo-relat = trim(return-value).           

    if  tt-param.l-traduz then do:        
        find trad-gerais use-index pk-tr-texto
             where trad-gerais.texto      =  "Ficha para Cota‡Æo de Pre‡os"
             and   trad-gerais.cod-idioma =  tt-ficha.cod-idioma
             no-lock no-error.
        if  avail trad-gerais then
            assign c-titulo-relat = trim(trad-gerais.texto-trad).
    end.            
    {utp/ut-liter.i Fichas_Cota‡Æo * r}.
    assign c-acompanha = return-value.    
    run pi-inicializar in h-acomp(input c-acompanha).
    {imp/im0302.i2}

    for each tt-ficha
        break by tt-ficha.cod-forn:
        {utp/ut-liter.i Imprimindo_fornecedor * r}.    
        assign c-acompanha = return-value + "" + string(tt-ficha.cod-forn).
        run pi-acompanhar in h-acomp(input c-acompanha).
        assign c-acompanha = "".

        if tt-ficha.int-1 = 2 then do:
           {utp/ut-liter.i Embarque * r}
           assign c-cheg = trim(return-value).
           {utp/ut-liter.i Dt_Prev_Emb * r}
           assign c-data = trim(return-value).
        end.
        if tt-ficha.int-1 <> 2 then do:
           {utp/ut-liter.i Chegada * r}
           assign c-cheg = trim(return-value).
           {utp/ut-liter.i Dt_Prev_Cheg * r}
           assign c-data = trim(return-value).
        end.

        if  tt-param.l-traduz then do:

            {imp/im0302.i1}

            find traduc-item where
                 traduc-item.it-codigo =  tt-ficha.item       and
                 traduc-item.cod-idioma = tt-ficha.cod-idioma
                 no-lock no-error.
            if   avail traduc-item then 
                  assign tt-ficha.item      = traduc-item.tr-it-codigo
                         tt-ficha.descricao = traduc-item.tr-desc-item.
            else do:
                find first item-fornec no-lock
                     where item-fornec.cod-emitente = tt-ficha.cod-forn
                     and   item-fornec.item-do-forn = tt-ficha.item no-error.
                if avail item-fornec then do:
                    find traduc-item where
                         traduc-item.it-codigo =  item-fornec.it-codigo       and
                         traduc-item.cod-idioma = tt-ficha.cod-idioma
                         no-lock no-error.
                    if   avail traduc-item then 
                          assign tt-ficha.descricao = traduc-item.tr-desc-item.                
                end.
            end.
        end.


        /******** preenchimento do espa‡o reservado nas literais para tradu‡Æo com pontos ********/

        {imp/im9999.i2 "c-para" "10"}
        {imp/im9999.i2 "c-tel" "10"}
        {imp/im9999.i2 "c-de" "10"}
        {imp/im9999.i2 "c-tel-c" "10"}

        /*****************************************************************************************/

        if first-of(tt-ficha.cod-forn) then do:
            view frame f-cabec-80.
            view frame f-rodape-80.
            if  line-counter >= 59 then 
                page.        
            disp c-para
                 tt-ficha.cod-forn
                 tt-ficha.fornecedor
                 c-tel
                 tt-ficha.tel1
                 c-fax
                 tt-ficha.fax1
                 c-de
                 tt-ficha.comprador
                 c-tel-c
                 tt-ficha.tel2
                 c-fax-c
                 tt-ficha.fax2
            with frame f-ficha1.
        end.

        if  line-counter >= 59 then 
            page.

        disp c-ordem
             c-item-forn
             c-quant
             c-un             
             c-cheg
             c-desc
             c-traco1
             with frame f-ficha2.

        disp tt-ficha.numero-ordem
             tt-ficha.item
             tt-ficha.quant
             tt-ficha.un
             tt-ficha.chegada
             tt-ficha.descricao
             with frame f-ficha3.

        /* Narrativa */
        if tt-param.l-narrativa then do:
           &if defined(bf-mat-comex) &then

                if tt-ficha.narrativa[1] <> "" then do:                
                   put  fill("-",20) format "x(20)" at 4 
                        c-lb-narra at 26
                        fill("-", 20) format "x(20)".
                   put tt-ficha.narrativa[1] at 04
                       tt-ficha.narrativa[2] at 04
                       tt-ficha.narrativa[3] at 04
                       tt-ficha.narrativa[4] at 04
                       tt-ficha.narrativa[5] at 04.
                end.  

            &else

                if tt-ficha.narrativa <> "" then do:                
                    run pi-print-editor (tt-ficha.narrativa, 60).
                    for each tt-editor:
                        if  tt-editor.linha = 1 then
                            put  fill("-",20) format "x(20)" at 4 
                                 c-lb-narra at 26
                                 fill("-", 20) format "x(20)".
                        disp
                            tt-editor.conteudo
                            with frame f-narrativa.
                        down with frame f-narrativa.
                    end.
                end.

            &endif

            put skip(1).
        end.

        if  line-counter >= 59 then 
            page.

        disp c-preco
             c-moeda
             c-incoterm
             c-cond
             c-qtde
             c-un
             c-data
             with frame f-ficha4.

        down with frame f-ficha1.     
        down with frame f-ficha2.
        down with frame f-ficha3.
        down with frame f-ficha4.
        if last-of(tt-ficha.cod-forn) then 
           page.
    end.

    if  tt-param.l-impre then do:
        page.
        disp c-sel
             tt-param.c-item-i
             tt-param.c-item-f                         
             tt-param.c-estab-i                       
             tt-param.c-estab-f
             tt-param.c-compr-i
             tt-param.c-compr-f
             tt-param.i-ordem-i
             tt-param.i-ordem-f 
             tt-param.d-data-i  
             tt-param.d-data-f  
             tt-param.c-fami-i  
             tt-param.c-fami-f  
             tt-param.i-forn-i  
             tt-param.i-forn-f 
             c-imp
             c-destino format "x(32)"             
             tt-param.usuario
             c-dest-inc                       no-label 
             tt-param.dest-inc format "x(32)" no-label 

        with frame f-param.

    end.

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        if v_log_eai_habilit then do:
            page.
            run pi-imprime-erros-eai.
        end.
    &ENDIF

    run pi-finalizar in h-acomp.
    {include/i-rpclo.i}

    if can-find(first tt-inconsist) then
    do:
        {utp/ut-liter.i Itens_Sem_Fornecedor * r}
        assign c-titulo-relat = trim(return-value).
        if  i-num-ped-exec-rpw <> 0 then do:
            &if "{&pagesize}" = "" &then
                output {&stream} 
                   to value(tt-param.dest-inc) 
                   paged page-size 64
                   convert target "iso8859-1" {&append}. 
            &else 
                assign i-page-size-rel = integer("{&pagesize}").
                output {&stream} 
                   to value(tt-param.dest-inc) 
                   paged page-size value(i-page-size-rel)
                   convert target "iso8859-1" {&append}. 
            &endif 
        end.
        else do:
            &if "{&pagesize}" = "" &then
                output {&stream} 
                   to value(tt-param.dest-inc) 
                   paged page-size 64 
                   convert target "iso8859-1" {&append}.         
            &else         
                assign i-page-size-rel = integer("{&pagesize}").
                output {&stream} 
                   to value(tt-param.dest-inc) 
                   paged page-size value(i-page-size-rel)
                   convert target "iso8859-1" {&append}.         
            &endif         
        end.
        {utp/ut-liter.i Itens_Sem_Fornecedor * r}.
        assign c-acompanha = return-value.

        {utp/ut-liter.i Ordem_Compra * r}.
        assign c-ordem = return-value.

        {utp/ut-liter.i Requisitante * r}.
        assign c-requis = return-value.

        {utp/ut-liter.i Nome_Abreviado * r}.
        assign c-nome = return-value.

        {utp/ut-liter.i Item * r}.
        assign c-item = return-value.

        run utp/ut-acomp.p persistent set h-acomp.
        run pi-inicializar in h-acomp(input c-acompanha).       

        page.
        view frame f-cabec-80.
        view frame f-rodape-80.
        disp c-ordem    
             c-requis   
             c-nome     
             c-item     
             with frame f-inc-cab.        
        for each tt-inconsist no-lock
            break by tt-inconsist.num-ordem:
            {utp/ut-liter.i Ordem * r}.
            assign v-retorno = return-value + " - " +  string(tt-inconsist.num-ordem).
            run pi-acompanhar in h-acomp(input v-retorno).
            disp tt-inconsist.num-ordem    
                 tt-inconsist.requisitante 
                 tt-inconsist.nome-abrev   
                 tt-inconsist.it-codigo 
                 with frame f-inc.
            down with frame f-inc.
run utp/ut-trfrrp.p (input frame f-narrativa:handle).
run utp/ut-trfrrp.p (input frame f-ficha1:handle).
run utp/ut-trfrrp.p (input frame f-ficha2:handle).
run utp/ut-trfrrp.p (input frame f-ficha3:handle).
run utp/ut-trfrrp.p (input frame f-ficha4:handle).
run utp/ut-trfrrp.p (input frame f-inc:handle).
            if  line-counter >= 59 then do:
                page.
                disp c-ordem    
                     c-requis   
                     c-nome     
                     c-item     
                     with frame f-inc-cab.                
            end.       
        end.

        page.
        {utp/ut-liter.i Ficha_para_Cota‡Æo_de_Pre‡os * r}
        assign c-titulo-relat = trim(return-value).
        run pi-finalizar in h-acomp.
        {include/i-rpclo.i}        
    end.    
end.

{include/pi-edit.i} /* Imprime campos texto */

return 'OK'.

PROCEDURE pi-imprime-erros-eai:

    if can-find (first tt_log_erro_aux) then do:    
        put c-erro-eai format "x(40)".
        put skip.
        put "-----------------------------------------------------------------".
    end.

    for each tt_log_erro_aux no-lock:
        if tt_log_erro_aux.ttv_des_msg_erro <> "" and tt_log_erro_aux.ttv_des_msg_erro <> ? then do:
            empty temp-table tt-editor.
            run pi-print-editor (input tt_log_erro_aux.ttv_des_msg_erro, input 60).
    
            assign l-primeira = yes.
            for each tt-editor no-lock:
                if l-primeira then 
                    put c-lb-erro + ": " + STRING(tt_log_erro_aux.ttv_num_cod_erro) + " - "  + tt-editor.conteudo at 1 format "x(60)".
                else 
                    put tt-editor.conteudo at 8 format "x(60)".
    
                assign l-primeira = no.
                if line-counter > (page-size - 4) then page.
            end.                       
        end.        
        if tt_log_erro_aux.ttv_des_msg_ajuda <> "" and tt_log_erro_aux.ttv_des_msg_ajuda <> ? then do:
            empty temp-table tt-editor.
            run pi-print-editor (input tt_log_erro_aux.ttv_des_msg_ajuda, input 60).
    
            assign l-primeira = yes.
            for each tt-editor no-lock:
                if l-primeira then 
                    put trim(c-lb-ajuda) + ": " + tt-editor.conteudo at 1 format "x(60)".
                else 
                    put tt-editor.conteudo at 8 format "x(60)".
    
                assign l-primeira = no.
                if line-counter > (page-size - 4) then page.
            end.
        end.
    end.
END PROCEDURE.
