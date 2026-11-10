/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0302A 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0302A MIM}
&ENDIF

/********************************************************************************
**
**   Programa: im0302a.p - Op‡Æo envio e-mail
**
********************************************************************************/
{utp/ut-glob.i}
{utp/utapi009.i}
{cdp/cdcfgmat.i} /* Include pre-processadores Magnus */

{imp/im0302.i}

def input param raw-param as raw no-undo.
def input param h-acomp   as handle no-undo.

define temp-table ttQuotation no-undo
    field rw-cotacao-item as rowid.

define temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as int  initial ?
    field ttv_des_msg_ajuda as char initial ?
    field ttv_des_msg_erro  as char initial ?.

def var r-registro as rowid no-undo.
def new global shared variable v_log_eai_habilit as logical no-undo.

def var de-indice    as decimal    no-undo.
def var de-quant     as decimal    no-undo format "99,999,999,999.99" decimals 2.
def var da-data      as date       no-undo.
def var i-seq        as integer    no-undo.
def var c-arq1       as char       no-undo.
def var c-arq2       as char       no-undo.
def var c-prog       as char       no-undo.
/*def var h-acomp      as handle     no-undo. */
def var c-item-fornec as char      no-undo format "x(20)".
def var c-descricao   as char      no-undo.
def var i-aux         as int       no-undo.
def var i-cont        as int       no-undo.

/* Define Vari veis para Tradu‡Æo */
def var c-contato   as char no-undo.
def var c-fone      as char no-undo.
def var c-it-forn   as char no-undo.
def var c-cotacao   as char no-undo.
def var c-linha1    as char no-undo.
def var c-linha2    as char no-undo.
def var c-linha3    as char no-undo.
def var c-compra    as char no-undo.
def var c-lin-item  as char no-undo.

/*------------ Envio e-mail -------------*/
def var c-arq            as char no-undo.
def var c-arq-anexo      as char format  "x(30)" no-undo.
def var c-assunto-e-mail as char format  "x(25)" no-undo.
def var c-mensagem-e-mail as char format "x(46)" no-undo.

/*---------------------------------------*/

{include/i-rpvar.i}       

find first param-global no-lock no-error.
find first param-compra no-lock no-error.

/*run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Emissão de Ficha para Cotação").*/

create tt-param.
raw-transfer raw-param to tt-param.

if avail param-compra then
    assign c-arq = tt-param.diretorio.

assign c-empresa  = (if avail param-global then 
                        codepage-convert(param-global.grupo, "iso8859-1", "ibm850")
                     else "")
       c-programa = "IM/0302"
       c-versao   = "1.00"
       c-revisao  = "000".
       
{utp/ut-liter.i IMPORTA€ÇO * r}
assign c-sistema = codepage-convert(trim(return-value), "iso8859-1", "ibm850").
{utp/ut-liter.i Ficha_Cota‡Æo_Internacional * r}
assign c-titulo-relat = codepage-convert(trim(return-value), "iso8859-1", "ibm850").       

{include/i-rpcb80.i}

/* {include/i-rpout.i} */

{imp/im0302.i3} /* cria‡Æo tt-ficha */

assign c-traco1    = fill("-",80).

for each tt-ficha
    break by tt-ficha.cod-forn:
    
     run pi-acompanhar in h-acomp(input tt-ficha.cod-forn).
    
     {imp/im0302.i2} 
     
     {utp/ut-liter.i Ficha_para_Cota‡Æo_de_Pre‡os * r}
     assign c-titulo-relat = codepage-convert(trim(return-value), "iso8859-1", "ibm850").
     {utp/ut-liter.i Ficha_Cota‡Æo_Internacional * L}
     assign c-assunto-e-mail = return-value.
     {utp/ut-liter.i Arquivo_Anexo_com_ficha_de_Cota‡Æo_Internacional: * L}
     assign c-mensagem-e-mail = return-value.
        
     if  tt-param.l-traduz then do:        
         find trad-gerais use-index pk-tr-texto
              where trad-gerais.texto      =  "Ficha para Cota‡Æo de Pre‡os"
              and   trad-gerais.cod-idioma =  tt-ficha.cod-idioma
              no-lock no-error.
         if  avail trad-gerais then
             assign c-titulo-relat = codepage-convert(trim(trad-gerais.texto-trad), "iso8859-1", "ibm850").
             
         find trad-gerais use-index pk-tr-texto
              where trad-gerais.texto      =  "Ficha Cota‡Æo Internacional"
              and   trad-gerais.cod-idioma =  tt-ficha.cod-idioma
              no-lock no-error.
         if  avail trad-gerais then
             assign c-assunto-e-mail = trim(trad-gerais.texto-trad).

         find trad-gerais use-index pk-tr-texto
              where trad-gerais.texto      =  "Arquivo Anexo com ficha de Cota‡Æo Internacional"
              and   trad-gerais.cod-idioma =  tt-ficha.cod-idioma
              no-lock no-error.
         if  avail trad-gerais then
             assign c-mensagem-e-mail = trim(trad-gerais.texto-trad).                          
        
         {imp/im0302.i1}
             
         find traduc-item where
              traduc-item.it-codigo =  tt-ficha.item       and
              traduc-item.cod-idioma = tt-ficha.cod-idioma
              no-lock no-error.
         if   avail traduc-item then 
              assign tt-ficha.item      = traduc-item.tr-it-codigo
                     tt-ficha.descricao = traduc-item.tr-desc-item. 
     end.       
        
   /******** preenchimento do espa‡o reservado nas literais para tradu‡Æo com pontos ********/
        
    {imp/im9999.i2 "c-para" "10"}
    {imp/im9999.i2 "c-tel" "10"}
    {imp/im9999.i2 "c-de" "10"}
    {imp/im9999.i2 "c-tel-c" "10"}
         
   /*****************************************************************************************/
    
   if first-of(tt-ficha.cod-forn) then do:
      output to value(c-arq + "~\" + string(tt-ficha.cod-forn) + ".txt")
      paged page-size 64.
      view  frame f-cabec-80.
      view  frame f-rodape-80.
      disp c-para
           tt-ficha.cod-forn
           codepage-convert(tt-ficha.fornecedor, "iso8859-1", "ibm850") @ tt-ficha.fornecedor
           c-tel
           tt-ficha.tel1
           c-fax
           tt-ficha.fax1
           c-de
           codepage-convert(tt-ficha.comprador, "iso8859-1", "ibm850") @ tt-ficha.comprador
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
        c-cheg
        codepage-convert(c-desc, "iso8859-1", "ibm850") @ c-desc
        c-traco1
   with frame f-ficha2.
             
   disp tt-ficha.numero-ordem
        codepage-convert(tt-ficha.item, "iso8859-1", "ibm850") @ tt-ficha.item
        tt-ficha.quant
        tt-ficha.chegada
        codepage-convert(tt-ficha.descricao, "iso8859-1", "ibm850") @ tt-ficha.descricao
   with frame f-ficha3.
       
   disp codepage-convert(c-preco, "iso8859-1", "ibm850") @ c-preco
        c-moeda
        c-incoterm
        c-cond
        c-qtde
        c-data
   with frame f-ficha4.
             
   down with frame f-ficha1.     
   down with frame f-ficha2.
   down with frame f-ficha3.
   down with frame f-ficha4.

   if  last-of(tt-ficha.cod-forn) then do:         
       output close.
       find first param-global
            no-lock no-error.
       if   avail param-global then do:     
            &if defined(bf-mat-comex) &then 
            &else       
                if tt-ficha.e-mail <> "":U then do:
                    assign c-arq = replace (c-arq, "~\","/")
                           c-arq-anexo = c-arq + "/" + string(tt-ficha.cod-forn) + ".txt".
                    for each tt-envio:
                        delete tt-envio.
                    end.           
                    create tt-envio.
                    assign tt-envio.versao-integracao = 001
                           tt-envio.exchange          = param-global.log-1
                           tt-envio.importancia       = 1                             
                           tt-envio.destino           = tt-ficha.e-mail
                           tt-envio.assunto           = c-assunto-e-mail
                           tt-envio.mensagem          = c-mensagem-e-mail
                           tt-envio.arq-anexo         = c-arq-anexo.
                                            
                    run utp/utapi009.p (input table tt-envio,
                                        output table tt-erros).

                    if return-value = "NOK" then do:
                        for each tt-erros:
                            disp tt-erros with 1 column width 300.
                        end.                                   
                    end.  
                end. 
            &endif            
       end.    
   end.     
end.

page.

hide frame f-ficha1.
hide frame f-ficha2.
hide frame f-ficha3.
hide frame f-ficha4.



/*run pi-finalizar in h-acomp. */

output close.


/* IM0302A.P */

