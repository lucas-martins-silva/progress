/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0402RP 2.00.00.024}  /*** 010024 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bc0402rp MBC}
&ENDIF

/**************************************************************************
**      DATASUL S/A.
**
**      Programa:    bc0402rp.p
**
**      Objetivo: Impress∆o de Etiquetas
**
***************************************************************************/
{cdp/cd0666.i}
{include/i_dbtype.i}
{cdp/cdcfgint.i} /*include para definiá∆o de preprocessador da release do banco*/
{include/i_dbvers.i}

def temp-table tt-raw-digita NO-UNDO
    field raw-digita        as raw.
    
def var raw-param        as raw no-undo. 
def input parameter r-raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

def var i as integer.

def var c-transacao      as char.
def var c-nr-trans       as char.
def var h-acomp          as handle              no-undo.
def var c-lit-selecao    as char format "x(07)" no-undo.
def var c-lit-parametros as char format "x(10)" no-undo.
def var c-lit-impressao  as char format "x(09)" no-undo.
def var c-destino        as char format "x(10)" no-undo.
def var rw-temp          as raw.
def var i-error          as int.
def var c-mensagem       as char.

define temp-table tt-digita no-undo
    field i-tipo        as inte
    field i-sequen      as inte
    field nr-trans      as deci format "zzzzzzzzz9"
    field cd-trans      as char format "x(8)".

define temp-table tt-param NO-UNDO
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field cd-trans-ini     like bc-trans.cd-trans
    field cd-trans-fim     like bc-trans.cd-trans
    field data-geracao-ini like bc-trans.data
    field data-geracao-fim like bc-trans.data
    field hora-geracao-ini like bc-trans.horario
    field hora-geracao-fim like bc-trans.horario
    field de-nr-trans-ini  like bc-trans.nr-trans
    field de-nr-trans-fim  like bc-trans.nr-trans
    field c-arq-saida      as char format "x(30)"
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo        LIKE empresa.ep-codigo format "x(03)".
&ELSE
    field ep-codigo        as int format ">>9".
&ENDIF

create  tt-param.
raw-transfer r-raw-param to tt-param.

for each tt-raw-digita:
    create tt-digita.
    raw-transfer tt-raw-digita.raw-digita to tt-digita.
end.   

form
    skip(2)
    c-lit-selecao                   no-label colon 55
    skip(1)
    tt-param.cd-trans-ini           colon 60   space(3) "|< >|"
    tt-param.cd-trans-fim           no-label
    skip(1)
    tt-param.data-geracao-ini       colon 60   space(3) "|< >|"
    tt-param.data-geracao-fim       no-label   
    skip(1)
    tt-param.hora-geracao-ini       colon 60   space(3) "|< >|"
    tt-param.hora-geracao-fim       no-label   
    skip(1)
    tt-param.de-nr-trans-ini        colon 60   space(3) "|< >|"
    tt-param.de-nr-trans-fim        no-label   
    skip(1)
    c-lit-parametros                no-label colon 55
    skip(1)
    c-destino                       colon 60 "-"
    tt-param.arquivo                no-label format "x(30)"
    tt-param.usuario                colon 60
    with side-label stream-io width 132 frame f-fim.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-fim:HANDLE).


{utp/ut-liter.i Seleá∆o * r}
assign c-lit-selecao = trim(return-value).

{utp/ut-liter.i ParÉmetros * r}
assign c-lit-parametros = trim(return-value).

{utp/ut-liter.i Impress∆o * r}
assign c-lit-impressao = trim(return-value).

{utp/ut-liter.i Destino * r}
assign c-destino:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Usu†rio * r}
assign tt-param.usuario:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans cd-trans 1}
assign tt-param.cd-trans-ini:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans nr-trans 1}
assign tt-param.de-nr-trans-ini:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans data 1}
assign tt-param.data-geracao-ini:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans horario 1}
assign tt-param.hora-geracao-ini:label in frame f-fim = trim(return-value).

{include/i-rpvar.i}

find first empresa
     where empresa.ep-codigo = tt-param.ep-codigo no-lock no-error.
if avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

def buffer b-bc-trans for bc-trans.

{utp/ut-liter.i "Impress∆o de Etiquetas" * L}
assign c-titulo-relat = trim(return-value).

assign c-programa     = "BC0402"
       c-sistema      = "COLETA DE DADOS"
       c-versao       = "1.00"
       c-revisao      = "01".
   
{include/i-rpout.i}
{include/i-rpcab.i}

run utp/ut-acomp.p persistent set h-acomp.         

view frame f-cabec.
view frame f-rodape.

{utp/ut-table.i mgcld bc-trans 1}
run pi-inicializar in h-acomp (input return-value).

{utp/ut-liter.i "Transaá∆o: " * R}
assign c-transacao = return-value.
{utp/ut-liter.i "Nr.Transaá∆o: " * R}
assign c-nr-trans = return-value.

/***** TRATAMENTO DE UMA SEQUENCIA DA ETIQUETA EM ESPECIFICO *****/
find first tt-digita no-error.
if  avail tt-digita
then do:
    run bcp/bc0402a.p ( input           table tt-digita,
                        input-output    table tt-erro).
end.
/****          TRATAMENTO DAS ETIQUETAS QUE EST«O NA SELEÄ«O        ******
*****  O programa s¢ atualiza e imprime etiquetas que n∆o estejam   ******
*****  com flag "Nova" por motivos de Seguranáa                     ******/
else do:
    for each  b-bc-trans
        where b-bc-trans.cd-trans       >= tt-param.cd-trans-ini
          and b-bc-trans.cd-trans       <= tt-param.cd-trans-fim
          and b-bc-trans.nr-trans       >= tt-param.de-nr-trans-ini
          and b-bc-trans.nr-trans       <= tt-param.de-nr-trans-fim
          and b-bc-trans.data           >= tt-param.data-geracao-ini
          and b-bc-trans.data           <= tt-param.data-geracao-fim
          and b-bc-trans.horario        >= tt-param.hora-geracao-ini
          and b-bc-trans.horario        <= tt-param.hora-geracao-fim
          and b-bc-trans.estado-trans   <> 1    /* 1=N∆o atualizada */
     &if '{&mgcld_version}' < '2.04' &then
          and b-bc-trans.log-1         = yes
     &else
          and b-bc-trans.ind-tipo-trans = 1
     &endif
          no-lock
          on stop undo, leave:
    
        find bc-trans
             where rowid(bc-trans) = rowid(b-bc-trans)
             exclusive-lock no-wait no-error.
             
        run pi-acompanhar in h-acomp (input   c-transacao 
                                            + bc-trans.cd-trans
                                            + " - "
                                            + c-nr-trans
                                            + string(bc-trans.nr-trans)).
       /* tratamento de etiqueta 2d */
       &IF '{&mgcld_version}' > '2.03' &then
            
            FIND bc-tipo-trans
                 WHERE bc-tipo-trans.cd-trans = bc-trans.cd-trans
                 NO-LOCK NO-ERROR.
               
            if  bc-tipo-trans.prog-etiq <> ""
            THEN
                run value(bc-tipo-trans.prog-etiq)
                          (  input bc-trans.nr-trans,
                             input bc-trans.conteudo-trans,
                             input-output table tt-erro) no-error.

       &ELSE

       &IF "{&mgcld_dbtype}" = "PROGRESS" &THEN
    
           run bcp/bcapi002.p (input               bc-trans.nr-trans,
                               input               bc-trans.conteudo-trans,
                               input-output table  tt-erro).


       &ELSE
    
           run btb/btb928za.p (input bc-trans.conteudo-trans,
                               output rw-temp) no-error.
    
           if ((   error-status:error
                or error-status:get-number(1) <> 0)
               and error-status:get-number(1) <> 138)
                or return-value = "NOK" then do:
    
               assign i-error    = error-status:get-number(1)
                      c-mensagem = error-status:get-message(1).
    
               if return-value = "NOK" then do:
                   {utp/ut-liter.i "Permiss∆o do Diret¢rio Tempor†rio" * L}
                   assign c-mensagem = trim(return-value)
                          i-error    = os-error.
               end.
    
               {utp/ut-liter.i "de Convers∆o do Campo RAW" * L}
               run utp/ut-msgs.p (input "msg",
                                  input 15837,
                                  input trim(return-value) + " - (" + c-mensagem + " : " + string(i-error) + ")").
    
               create tt-erro.
               assign tt-erro.cd-erro  = 15837
                      tt-erro.mensagem = trim(return-value).
           end.
    
           else do:
    
               run bcp/bcapi002.p (input               bc-trans.nr-trans,
                                   input               rw-temp,
                                   input-output table  tt-erro).
           end.
    
       &ENDIF
       &ENDIF
            
       /* Atualizaá∆o do Movimento caso n∆o n∆o ocorra erros */
          
       find first tt-erro no-error.
       
       if  not avail tt-erro then do:
           
           for each bc-trans-erros 
                 of bc-trans exclusive-lock:
               delete bc-trans-erros.
           end.
            
           assign  bc-trans.estado-trans = 2.
       
       end.
       
       /******************************************************/
       
    end.
end.

assign c-destino = {varinc/var00002.i 04 tt-param.destino}.

for each tt-erro:
    display tt-erro.cd-erro
            tt-erro.mensagem 
            with stream-io width 300.
end.

disp
    c-lit-selecao
    tt-param.cd-trans-ini
    tt-param.cd-trans-fim
    tt-param.de-nr-trans-ini
    tt-param.de-nr-trans-fim
    tt-param.data-geracao-ini
    tt-param.data-geracao-fim
    tt-param.hora-geracao-ini
    tt-param.hora-geracao-fim
    c-lit-parametros
    c-destino
    tt-param.arquivo
    tt-param.usuario
    with frame f-fim.
    

{include/i-rpclo.i}

run pi-finalizar in h-acomp.
find first tt-erro no-lock no-error.
if  avail tt-erro then 
    return "NOK".
else 
    return "OK".
