/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0401RP 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" 
&THEN
{include/i-license-manager.i BC0401RP MBC}
&ENDIF



/******************************************************************************
**
**    Copyright 1996 Datasul S.A. - All rights reserved.
**                                               
**    Programa...: BC0401.P
**
**    Finalidade.: Relatorio das Transacoes
**
**    Criado em..: Abril de 1996
**
**    Versao.....: A.00 Datasul-EMS
**
******************************************************************************/
def var c-ret like impressora.nom_impressora.
def var h-acomp as handle no-undo.

define button b-ok      auto-go. 
define button b-cancel  auto-endkey.
define var da-dt-ini    as date     init today format '99/99/9999'.
define var da-dt-fim    as date     init today format '99/99/9999'.
define var d-trans-ini  as decimal  format '9999999999'  init 0.
define var d-trans-fim  as decimal  format '9999999999'  init 9999999999.
define var l-erro       as logical  view-as toggle-box init yes.
define var l-atual      as logical  view-as toggle-box.
define var l-nova       as logical  view-as toggle-box.

/*********** Relat¢rio **********/

def var c-destino         as char format "x(30)" no-undo.  
def var c-parametros      as char format "x(12)". 
def var c-arquivo         as char format "x(40)" no-undo.
def var c-liter-impres    as char format "x(09)" no-undo.
def var c-liter-destin    as char format "x(08)" no-undo.
def var c-liter-usuario   as char format "x(08)" no-undo.
def var c-nome-imp        as char format "x(20)". 
def var c-selecao         as char format "x(08)". 
def var c-detalhe         as char format "x(100)".
def var c-data            as char format "x(06)" .
def var c-estado-trans    as char format "x(15)".    

 {utp/ut-liter.i Usu rio * r}
  assign c-liter-usuario = trim(return-value).

 {utp/ut-liter.i Destino * r}
  assign c-liter-destin = trim(return-value).

 {utp/ut-liter.i IMPRESSÇO * r}
  assign c-liter-impres = trim(return-value). 

 {utp/ut-liter.i PAR¶METROS *  r}
  assign c-parametros =  trim(return-value).

  {utp/ut-liter.i SELE€ÇO * r}
  assign c-selecao = trim (return-value).

define temp-table tt-param NO-UNDO
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field da-dt-ini        as date
    field da-dt-fim        as date
    field d-trans-ini      as decimal
    field d-trans-fim      as decimal format ">>>>>>>>>9" init "9999999999"
    field l-erro           as logical
    field l-atual          as logical
    field l-nova           as logical
&IF "{&mguni_version}" >= "2.071" &THEN
    field ep-codigo        LIKE empresa.ep-codigo format "x(03)".
&ELSE
    field ep-codigo        as integer format ">>9".
&ENDIF

    def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

    def input parameter raw-param as raw no-undo.
    def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.               

{include/i-rpvar.i}

find first empresa
     where empresa.ep-codigo = tt-param.ep-codigo no-lock no-error.
if avail empresa then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

assign c-programa     = 'BC/0401' 
       c-versao       = '0.00'
       c-revisao      = '000'.

{include/i-rpcab.i}


  assign   da-dt-ini    = tt-param.da-dt-ini         
           da-dt-fim    = tt-param.da-dt-fim      
           d-trans-ini  = tt-param.d-trans-ini   
           d-trans-fim  = tt-param.d-trans-fim 
           l-erro       = tt-param.l-erro   
           l-atual      = tt-param.l-atual    
           l-nova       = tt-param.l-nova.   

form
    skip(1)
    da-dt-ini    colon 20 
    da-dt-fim    colon 20
    skip(1)
    d-trans-ini  colon 20 
    d-trans-fim  colon 20
    skip(1)
    l-erro       colon 50
    l-atual      colon 50
    skip
    c-nome-imp   colon 47
    skip
    b-ok b-cancel   
    with overlay side-labels stream-io width 80 frame f-param.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-param:HANDLE).



form
    bc-trans.data
    bc-trans.nr-trans
    c-detalhe
    c-estado-trans  
    with no-box stream-io width 150 32 down frame f-corpo. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-corpo:HANDLE).
  

{utp/ut-liter.i Estado * r}
assign c-estado-trans:label in frame f-corpo = return-value.
{utp/ut-liter.i Detalhe * r}
assign c-detalhe:label in frame f-corpo = return-value.

form c-selecao              no-label skip(2)
     c-data                 no-label
     tt-param.da-dt-ini     colon 30      "|<>|" colon 40   tt-param.da-dt-fim        no-label  skip
     tt-param.d-trans-ini   colon 30      "|<>|" colon 40   tt-param.d-trans-fim      no-label  skip
     c-parametros           no-label skip(2)
     tt-param.l-erro        colon 30
     tt-param.l-atual       colon 30
     tt-param.l-nova        colon 30 skip(2)
      
     with side-labels stream-io width 132 frame f-impressao.
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-impressao:HANDLE).


     {utp/ut-field.i mgcld bc-trans nr-trans 1}
     assign tt-param.d-trans-ini:label in frame f-impressao = return-value.    
     {utp/ut-liter.i Com_erro * r}
     assign tt-param.l-erro:label in frame f-impressao = trim(return-value). 
     {utp/ut-liter.i Atualizado * r}
     assign tt-param.l-atual:label in frame f-impressao = trim(return-value). 
     {utp/ut-liter.i Nova * r}
     assign tt-param.l-nova:label in frame f-impressao = trim(return-value).   
     {utp/ut-liter.i Data * r}
     assign tt-param.da-dt-ini:label in frame f-impressao = trim(return-value).   


      {include/i-rpout.i}   
      view frame f-cabec.
      view frame f-rodape.      

run utp/ut-acomp.p persistent set h-acomp.            
{utp/ut-liter.i Relat¢rio_das_transa‡äes *}

run pi-inicializar in h-acomp (input   Return-value ).


for each bc-trans EXCLUSIVE-LOCK   
      where  bc-trans.data >= da-dt-ini
       and   bc-trans.data <= da-dt-fim  
       and   bc-trans.nr-trans >= d-trans-ini  
       and   bc-trans.nr-trans <= d-trans-fim 
       and   ((bc-trans.estado-trans = 3 and l-erro) or 
              (bc-trans.estado-trans = 2 and l-atual) or
              (bc-trans.estado-trans = 1 and l-nova)) :

         assign c-estado-trans = {clinc/i01cl012.i 04 bc-trans.estado-trans}
                c-detalhe = bc-trans.detalhe.
         disp   bc-trans.data        
                bc-trans.nr-trans
                c-detalhe
                c-estado-trans
                with frame f-corpo.
         down with frame f-corpo.  

        run pi-acompanhar in h-acomp (input string(bc-trans.nr-trans)).
end. 

page.

    display c-selecao
           tt-param.da-dt-ini          
           tt-param.da-dt-fim   
           tt-param.d-trans-ini       
           tt-param.d-trans-fim
           c-parametros  
           tt-param.l-erro
           tt-param.l-atual
           tt-param.l-nova 
           with frame f-impressao.   

    run pi-finalizar in h-acomp.  


     assign c-destino = {varinc/var00002.i 04 tt-param.destino}
            c-arquivo = tt-param.arquivo.

       disp skip(3)
            c-liter-impres                at 02 skip(1)
            c-liter-destin                at 05 space(1) ":" space(1) 
            c-destino                           space(1) "-" space(1)
            c-arquivo
            c-liter-usuario               at 05 space(1) ":" space(1) tt-param.usuario
            with width 132 no-labels stream-io no-box frame f-imp-parametro.

        {include/i-rpclo.i}

        hide message no-pause.

return "OK".

/*    {cdp/include/i-rpclo.i}
 * end.
 * fim do programa */
