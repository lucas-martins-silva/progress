/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0102AA 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bh0102aa MBH}
&ENDIF

/**************************************************************************
**
**  Programa: BH0102A.P
**
**  Data....: JULHO DE 1997
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Retornar dados para o banco de movimentos (Contas a Pagar)
**
******************************************************************************/

/**** Miniflexibilizacao ****/
{cdp/cdcfgfin.i}

/**** DEFINI€ÇO DE TEMP-TABLES *****/

/*--- W-PER ---*/
{bhp/bh0102.i2}

/*--- TT-CHAVE-TIT-AP ---*/
{bhp/bh0102aa.i}


/**** Defini‡Æo dos parametros ****/

def input  parameter p-ep-codigo   like hisadm.tit-ap.ep-codigo   no-undo.
def input  parameter p-cod-estabel like hisadm.tit-ap.cod-estabel no-undo.
def input  parameter p-cod-fornec  like hisadm.tit-ap.cod-fornec  no-undo.
def input  parameter p-cod-esp     like hisadm.tit-ap.cod-esp     no-undo.
def input  parameter p-serie       like hisadm.tit-ap.serie       no-undo.
def input  parameter p-nr-docto    like hisadm.tit-ap.nr-docto    no-undo.
def input  parameter p-parcela     like hisadm.tit-ap.parcela     no-undo.
def input-output parameter i-registro as   int format ">>>,>>9"     no-undo.
def input-output parameter table for w-per.


/**** Defini‡Æo das demais variaveis ****/
define var i-empresa  like empresa.ep-codigo  no-undo.

define buffer b-tit-ap for hisadm.tit-ap.

for each  tt-chave-transfere : 
    delete tt-chave-transfere.
end.

find hisadm.tit-ap
     where hisadm.tit-ap.ep-codigo   = p-ep-codigo
     and   hisadm.tit-ap.cod-estabel = p-cod-estabel
     and   hisadm.tit-ap.cod-fornec  = p-cod-fornec 
     and   hisadm.tit-ap.cod-esp     = p-cod-esp
     and   hisadm.tit-ap.serie       = p-serie
     and   hisadm.tit-ap.nr-docto    = p-nr-docto
     and   hisadm.tit-ap.parcela     = p-parcela
     exclusive no-error.

      
if  not avail hisadm.tit-ap then
    RETURN "NOK":U.

&IF DEFINED(BF_FIN_RAC) &THEN
    if  tit-ap.origem = 5  then
        RETURN "NOK":U.
&ENDIF 

find first tt-chave-tit-ap
     where tt-chave-tit-ap.ep-codigo   = p-ep-codigo
     and   tt-chave-tit-ap.cod-estabel = p-cod-estabel
     and   tt-chave-tit-ap.cod-fornec  = p-cod-fornec 
     and   tt-chave-tit-ap.cod-esp     = p-cod-esp
     and   tt-chave-tit-ap.serie       = p-serie
     and   tt-chave-tit-ap.nr-docto    = p-nr-docto
     and   tt-chave-tit-ap.parcela     = p-parcela
     no-lock no-error.

if  not avail tt-chave-tit-ap then do:
    create tt-chave-tit-ap.
    assign tt-chave-tit-ap.ep-codigo   = hisadm.tit-ap.ep-codigo
           tt-chave-tit-ap.cod-estabel = hisadm.tit-ap.cod-estabel
           tt-chave-tit-ap.cod-fornec  = hisadm.tit-ap.cod-fornec  
           tt-chave-tit-ap.cod-esp     = hisadm.tit-ap.cod-esp
           tt-chave-tit-ap.serie       = hisadm.tit-ap.serie
           tt-chave-tit-ap.nr-docto    = hisadm.tit-ap.nr-docto
           tt-chave-tit-ap.parcela     = hisadm.tit-ap.parcela.
end.


assign i-empresa = p-ep-codigo.
           
for each hisadm.mov-ap use-index codigo
   where hisadm.mov-ap.ep-codigo   = tt-chave-tit-ap.ep-codigo
   and   hisadm.mov-ap.cod-estabel = tt-chave-tit-ap.cod-estabel
   and   hisadm.mov-ap.cod-esp     = tt-chave-tit-ap.cod-esp
   and   hisadm.mov-ap.cod-fornec  = tt-chave-tit-ap.cod-fornec
   and   hisadm.mov-ap.serie       = tt-chave-tit-ap.serie
   and   hisadm.mov-ap.nr-docto    = tt-chave-tit-ap.nr-docto
   and   hisadm.mov-ap.parcela     = tt-chave-tit-ap.parcela
   exclusive-lock:

   for each hisadm.tit-conta-ap
       where hisadm.tit-conta-ap.ep-codigo = hisadm.mov-ap.ep-codigo
       and hisadm.tit-conta-ap.cod-estabel = hisadm.mov-ap.cod-estabel
       and hisadm.tit-conta-ap.cod-esp     = hisadm.mov-ap.cod-esp
       and hisadm.tit-conta-ap.serie       = hisadm.mov-ap.serie
       and hisadm.tit-conta-ap.nr-docto    = hisadm.mov-ap.nr-docto
       and hisadm.tit-conta-ap.parcela     = hisadm.mov-ap.parcela
       and hisadm.tit-conta-ap.cod-fornec  = hisadm.mov-ap.cod-fornec
       exclusive-lock:
       {bhp/bh9801.i &area=adm &arqmov=tit-conta-ap}
       delete hisadm.tit-conta-ap. 
       assign i-registro = i-registro + 1.
   end.

   do  for hisadm.che-emit:
       find first hisadm.che-emit  use-index codigo
             where hisadm.che-emit.ep-codigo = hisadm.mov-ap.ep-codigo
             and hisadm.che-emit.portador    = hisadm.mov-ap.portador
             and hisadm.che-emit.nr-cheque   = hisadm.mov-ap.nr-cheque
             and hisadm.che-emit.cod-fornec  = hisadm.mov-ap.cod-fornec
             and hisadm.che-emit.cod-estabel = hisadm.mov-ap.cod-estabel
             and hisadm.che-emit.cod-esp     = hisadm.mov-ap.cod-esp
             and hisadm.che-emit.serie       = hisadm.mov-ap.serie
             and hisadm.che-emit.nr-docto    = hisadm.mov-ap.nr-docto
             and hisadm.che-emit.parcela     = hisadm.mov-ap.parcela
             and hisadm.che-emit.transacao   = hisadm.mov-ap.transacao
             and hisadm.che-emit.dt-emissao  = hisadm.mov-ap.dt-transacao
             exclusive-lock no-error.
       if  avail hisadm.che-emit then do:
           {bhp/bh9801.i &area=adm &arqmov=che-emit}
           delete hisadm.che-emit.
           assign i-registro = i-registro + 1.
       end.
   end.

   if  hisadm.mov-ap.transacao = 1 
   or  hisadm.mov-ap.transacao = 2 then do:
   
       /**** BUSCA O PORTADOR DO MOVIMENTO ****/
       find first portador 
            where portador.ep-codigo    = hisadm.mov-ap.ep-codigo
            and   portador.cod-portador = hisadm.mov-ap.portador
            and   portador.modalidade   = hisadm.mov-ap.modalidade 
            no-lock no-error.
    
        if  avail portador  then do:
        
            /**** BUSCA O CHEQUE RELACIONADO AO MOVIMENTO ****/
            find first hisadm.cheque
                 where hisadm.cheque.cod-banco     = portador.cod-banco
                 and   hisadm.cheque.agencia       = portador.agencia
                 and   hisadm.cheque.conta-corren  = portador.conta-corren 
                 and   hisadm.cheque.nr-cheque     = hisadm.mov-ap.nr-cheque
                 and   hisadm.cheque.origem-cheque = 5 /* AP */
                 exclusive-lock no-error.
           if  avail hisadm.cheque then do:
               run pi-elimina-his-cheque.
        
               {bhp/bh9801.i &area=adm &arqmov=cheque}
               delete hisadm.cheque.
               assign i-registro = i-registro + 1.
           end.
    
        end.
   end.
   
   /**** Acha os titulo vinculados a documento ****/
   
   if  can-find(first b-tit-ap 
                where b-tit-ap.ep-codigo = hisadm.mov-ap.ep-codigo
                and   b-tit-ap.cod-est   = hisadm.mov-ap.cod-est
                and   b-tit-ap.cod-forn  = hisadm.mov-ap.fornec-ant
                and   b-tit-ap.cod-esp   = hisadm.mov-ap.esp-ant
                and   b-tit-ap.serie     = hisadm.mov-ap.serie-ant
                and   b-tit-ap.nr-docto  = hisadm.mov-ap.docto-ant
                and   b-tit-ap.parcela   = hisadm.mov-ap.parc-ant) then do:

       if  not can-find(first tt-chave-transfere
                        where tt-chave-transfere.ep-codigo   = hisadm.mov-ap.ep-codigo
                        and   tt-chave-transfere.cod-estabel = hisadm.mov-ap.cod-est
                        and   tt-chave-transfere.cod-fornec  = hisadm.mov-ap.fornec-ant
                        and   tt-chave-transfere.cod-esp     = hisadm.mov-ap.esp-ant
                        and   tt-chave-transfere.serie       = hisadm.mov-ap.serie-ant
                        and   tt-chave-transfere.nr-docto    = hisadm.mov-ap.docto-ant
                        and   tt-chave-transfere.parcela     = hisadm.mov-ap.parc-ant) then do:
           create tt-chave-transfere.
           assign tt-chave-transfere.ep-codigo   = hisadm.mov-ap.ep-codigo
                  tt-chave-transfere.cod-estabel = hisadm.mov-ap.cod-est
                  tt-chave-transfere.cod-fornec  = hisadm.mov-ap.fornec-ant
                  tt-chave-transfere.cod-esp     = hisadm.mov-ap.esp-ant
                  tt-chave-transfere.serie       = hisadm.mov-ap.serie-ant
                  tt-chave-transfere.nr-docto    = hisadm.mov-ap.docto-ant
                  tt-chave-transfere.parcela     = hisadm.mov-ap.parc-ant.
       end.
                
    end.
   
   
   {bhp/bh9801.i &area=adm &arqmov=mov-ap}
   delete hisadm.mov-ap.
   release hisadm.mov-ap.
   assign i-registro = i-registro + 1.

end.

do  for hisadm.emite-ap:
    find first hisadm.emite-ap use-index codigo
         where hisadm.emite-ap.ep-codigo   = tt-chave-tit-ap.ep-codigo
         and   hisadm.emite-ap.cod-estabel = tt-chave-tit-ap.cod-estabel
         and   hisadm.emite-ap.cod-esp     = tt-chave-tit-ap.cod-esp
         and   hisadm.emite-ap.serie       = tt-chave-tit-ap.serie
         and   hisadm.emite-ap.cod-fornec  = tt-chave-tit-ap.cod-fornec
         and   hisadm.emite-ap.nr-docto    = tt-chave-tit-ap.nr-docto
         and   hisadm.emite-ap.parcela     = tt-chave-tit-ap.parcela
         exclusive-lock no-error.
    
    if  avail hisadm.emite-ap then do:
        {bhp/bh9801.i &area=adm &arqmov=emite-ap}
        delete hisadm.emite-ap.
        assign i-registro = i-registro + 1.
    end.
end.

for each hisadm.his-d-ap use-index codigo
    where hisadm.his-d-ap.ep-codigo   = tt-chave-tit-ap.ep-codigo
    and   hisadm.his-d-ap.cod-estabel = tt-chave-tit-ap.cod-estabel
    and   hisadm.his-d-ap.cod-esp     = tt-chave-tit-ap.cod-esp
    and   hisadm.his-d-ap.serie       = tt-chave-tit-ap.serie
    and   hisadm.his-d-ap.nr-docto    = tt-chave-tit-ap.nr-docto
    and   hisadm.his-d-ap.parcela     = tt-chave-tit-ap.parcela
    and   hisadm.his-d-ap.cod-fornec  = tt-chave-tit-ap.cod-fornec
    exclusive-lock:
    {bhp/bh9801.i &area=adm &arqmov=his-d-ap} 
    delete hisadm.his-d-ap.
    assign i-registro = i-registro + 1.
end.


/***** Chave das notas *****/

for each hisadm.nota-dup
    where hisadm.nota-dup.ep-codigo-n   = tt-chave-tit-ap.ep-codigo
    and   hisadm.nota-dup.cod-estabel-n = tt-chave-tit-ap.cod-estabel
    and   hisadm.nota-dup.cod-fornec    = tt-chave-tit-ap.cod-fornec
    and   hisadm.nota-dup.cod-esp-n     = tt-chave-tit-ap.cod-esp
    and   hisadm.nota-dup.serie-n       = tt-chave-tit-ap.serie
    and   hisadm.nota-dup.nr-docto-n    = tt-chave-tit-ap.nr-docto
    and   hisadm.nota-dup.parcela-n     = tt-chave-tit-ap.parcela
    exclusive-lock:
    run pi-elimina-nota-dup.    
end.

/***** Chave das duplicatas ****/
for each hisadm.nota-dup
    where hisadm.nota-dup.ep-codigo-n   = tt-chave-tit-ap.ep-codigo
    and   hisadm.nota-dup.cod-estabel-d = tt-chave-tit-ap.cod-estabel
    and   hisadm.nota-dup.fornec-dup    = tt-chave-tit-ap.cod-fornec
    and   hisadm.nota-dup.cod-esp-d     = tt-chave-tit-ap.cod-esp
    and   hisadm.nota-dup.serie-d       = tt-chave-tit-ap.serie
    and   hisadm.nota-dup.nr-docto-d    = tt-chave-tit-ap.nr-docto
    and   hisadm.nota-dup.parcela-d     = tt-chave-tit-ap.parcela
    exclusive-lock:

    run pi-elimina-nota-dup.

end.


for each hisadm.impto-tit-ap
    where hisadm.impto-tit-ap.ep-codigo   = tt-chave-tit-ap.ep-codigo
    and   hisadm.impto-tit-ap.cod-estabel = tt-chave-tit-ap.cod-estabel
    and   hisadm.impto-tit-ap.cod-esp     = tt-chave-tit-ap.cod-esp
    and   hisadm.impto-tit-ap.serie       = tt-chave-tit-ap.serie
    and   hisadm.impto-tit-ap.nr-docto    = tt-chave-tit-ap.nr-docto
    and   hisadm.impto-tit-ap.parcela     = tt-chave-tit-ap.parcela
    and   hisadm.impto-tit-ap.cod-fornec  = tt-chave-tit-ap.cod-fornec
    exclusive-lock:
    {bhp/bh9801.i &area=adm &arqmov=impto-tit-ap}
    delete hisadm.impto-tit-ap.
    assign i-registro = i-registro + 1.
end.


/**** Atualiza‡Æo da tabelas no banco de dados *****/

/***********
/*--- Elimin‡Æo das tabelas TIT-AP E HIS-TIT-AP ---*/
{bhp/bh0102a.i}
*************/


/*------------------ Elimina da tabela de locks -----------------*/
find first his-tit-ap
     where his-tit-ap.ep-codigo   = hisadm.tit-ap.ep-codigo
     and   his-tit-ap.cod-fornec  = hisadm.tit-ap.cod-fornec
     and   his-tit-ap.cod-estabel = hisadm.tit-ap.cod-estabel
     and   his-tit-ap.cod-esp     = hisadm.tit-ap.cod-esp
     and   his-tit-ap.serie       = hisadm.tit-ap.serie
     and   his-tit-ap.nr-docto    = hisadm.tit-ap.nr-docto
     and   his-tit-ap.parcela     = hisadm.tit-ap.parcela
     exclusive-lock no-error.
if  avail his-tit-ap then
    delete his-tit-ap validate(true,"").
/*---------------------------------------------------------------*/

/**** Cria a temp-table  w-per ****/
{bhp/bh0102.i AP hisadm.tit-ap.dt-transacao}

/***** Cria a o titulo na base quente ****/
{bhp/bh9801.i &area=adm &arqmov=tit-ap} 


delete hisadm.tit-ap validate(true,"").

release hisadm.tit-ap.
release his-tit-ap.

assign i-registro = i-registro + 1.

for each tt-chave-transfere : 
    find first tt-chave-tit-ap
         where tt-chave-tit-ap.ep-codigo   = tt-chave-transfere.ep-codigo
         and   tt-chave-tit-ap.cod-estabel = tt-chave-transfere.cod-estabel
         and   tt-chave-tit-ap.cod-fornec  = tt-chave-transfere.cod-fornec  
         and   tt-chave-tit-ap.cod-esp     = tt-chave-transfere.cod-esp
         and   tt-chave-tit-ap.serie       = tt-chave-transfere.serie
         and   tt-chave-tit-ap.nr-docto    = tt-chave-transfere.nr-docto
         and   tt-chave-tit-ap.parcela     = tt-chave-transfere.parcela
         no-error.
    if  not avail tt-chave-tit-ap then do: 
        create tt-chave-tit-ap.
        BUFFER-COPY tt-chave-transfere 
                 TO tt-chave-tit-ap.
    end.
end.




/***** Recursividade do programa  por causa da Substituicao de Nota por Dup *****/
for each tt-chave-tit-ap :
    run bhp/bh0102aa.p (input tt-chave-tit-ap.ep-codigo,
                        input tt-chave-tit-ap.cod-estabel,
                        input tt-chave-tit-ap.cod-fornec,
                        input tt-chave-tit-ap.cod-esp,
                        input tt-chave-tit-ap.serie,
                        input tt-chave-tit-ap.nr-docto,
                        input tt-chave-tit-ap.parcela,
                        input-output i-registro,
                        input-output table w-per).


    if  RETURN-VALUE = "NOK":U THEN
        next.
    
end.


RETURN "OK":U.
/***** [ PROCEDURES INTERNAS ] ******/

PROCEDURE pi-elimina-his-cheque :
    &IF DEFINED(BF_FIN_BANCO_HIST_ADM) &THEN
        find first his-cheque
             where his-cheque.cod-banco    = hisadm.cheque.cod-banco
             and   his-cheque.agencia      = hisadm.cheque.agencia
             and   his-cheque.conta-corren = hisadm.cheque.conta-corren
             and   his-cheque.nr-cheque    = hisadm.cheque.nr-cheque
             exclusive-lock no-error.
        if  avail his-cheque then 
            delete his-cheque.
    &ENDIF
    
    RETURN "OK":U.
END PROCEDURE.



PROCEDURE pi-elimina-nota-dup :

    if  not can-find(first tt-chave-transfere
                 where tt-chave-transfere.ep-codigo   = hisadm.nota-dup.ep-codigo-n
                 and   tt-chave-transfere.cod-estabel = hisadm.nota-dup.cod-estabel-n
                 and   tt-chave-transfere.cod-fornec  = hisadm.nota-dup.cod-fornec  
                 and   tt-chave-transfere.cod-esp     = hisadm.nota-dup.cod-esp-n
                 and   tt-chave-transfere.serie       = hisadm.nota-dup.serie-n
                 and   tt-chave-transfere.nr-docto    = hisadm.nota-dup.nr-docto-n
                 and   tt-chave-transfere.parcela     = hisadm.nota-dup.parcela-n) then do:
        create tt-chave-transfere.
        assign tt-chave-transfere.ep-codigo   = hisadm.nota-dup.ep-codigo-n
               tt-chave-transfere.cod-estabel = hisadm.nota-dup.cod-estabel-n
               tt-chave-transfere.cod-fornec  = hisadm.nota-dup.cod-fornec  
               tt-chave-transfere.cod-esp     = hisadm.nota-dup.cod-esp-n
               tt-chave-transfere.serie       = hisadm.nota-dup.serie-n
               tt-chave-transfere.nr-docto    = hisadm.nota-dup.nr-docto-n
               tt-chave-transfere.parcela     = hisadm.nota-dup.parcela-n.
    end.

    if  not can-find(first tt-chave-transfere
                     where tt-chave-transfere.ep-codigo   = hisadm.nota-dup.ep-codigo-n
                     and   tt-chave-transfere.cod-estabel = hisadm.nota-dup.cod-estabel-d
                     and   tt-chave-transfere.cod-fornec  = hisadm.nota-dup.fornec-dup  
                     and   tt-chave-transfere.cod-esp     = hisadm.nota-dup.cod-esp-d
                     and   tt-chave-transfere.serie       = hisadm.nota-dup.serie-d
                     and   tt-chave-transfere.nr-docto    = hisadm.nota-dup.nr-docto-d
                     and   tt-chave-transfere.parcela     = hisadm.nota-dup.parcela-d) then do:
        create tt-chave-transfere.
        assign tt-chave-transfere.ep-codigo   = hisadm.nota-dup.ep-codigo-n
               tt-chave-transfere.cod-estabel = hisadm.nota-dup.cod-estabel-d
               tt-chave-transfere.cod-fornec  = hisadm.nota-dup.fornec-dup 
               tt-chave-transfere.cod-esp     = hisadm.nota-dup.cod-esp-d
               tt-chave-transfere.serie       = hisadm.nota-dup.serie-d
               tt-chave-transfere.nr-docto    = hisadm.nota-dup.nr-docto-d
               tt-chave-transfere.parcela     = hisadm.nota-dup.parcela-d.
    end.

    
    {bhp/bh9801.i &area=adm &arqmov=nota-dup}
    delete  hisadm.nota-dup.
    release hisadm.nota-dup.

    assign i-registro = i-registro + 1.
    
    RETURN "OK":U.
END PROCEDURE.


