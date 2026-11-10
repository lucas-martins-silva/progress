/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ACAPI004 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i acapi004 MAC}
&ENDIF

/*******************************************************************************
**
**  Programa : acapi004.p 
**  Objetivo : Leitura das cotas para os pedidos.
**
******************************************************************************/

/* Variaveis que nao aceitam o "?" */
def input  param estab      like cotas.cod-estabel       no-undo.
def input  param repres     like cotas.cod-rep           no-undo.
def input  param produto    like cotas.cd-produto        no-undo.
def input  param dt-inicial like cotas.dt-inicial        no-undo.

/*  Variaveis que aceitam o "?" */

def input  param canal-1    like cotas.cod-canal-venda   no-undo.
def input  param grcli-1    like cotas.cod-gr-cli        no-undo.
def input  param cliente-1  like emitente.nome-abrev     no-undo.
def input  param reg-1      like cotas.nome-ab-reg       no-undo.
def input  param micreg-1   like cotas.nome-mic-reg      no-undo.

/* Variavel que devolve o rowid de Cotas */
def output param r-cotas    as rowid                     no-undo.

def var canal-0   like canal-1        initial ?.
def var grcli-0   like grcli-1        initial ?.
def var cliente-0 like cliente-1      initial ?.
def var reg-0     like reg-1          initial ?.
def var micreg-0  like micreg-1       initial ?.

def var canal     like canal-1        initial ?.
def var grcli     like grcli-1        initial ?.
def var cliente   like cliente-1      initial ?.
def var reg       like reg-1          initial ?.
def var micreg    like micreg-1       initial ?.

{utp/ut-glob.i}
{cdp/cd9000.i}

{utp/ut-liter.i "Leitura cotas p/ pedidos"}
assign c-programa    = "acapi004"
       c-titulo-tela = return-value
       da-data-proc  = today
       c-hora-proc   = string(time, "HH:MM").

find par-cota no-lock
     where par-cota.cod-estabel = estab no-error.
if not avail par-cota then return.
find last  cotas no-lock
     where cotas.cod-estabel     =  estab
     and   cotas.cod-canal-venda = (if par-cota.cont-canal-venda then canal-1   else 0)
     and   cotas.cod-gr-cli      = (if par-cota.cont-gr-cli      then grcli-1   else 0)
     and   cotas.nome-abrev      = (if par-cota.cont-cliente     then cliente-1 else "")
     and   cotas.nome-ab-reg     = (if par-cota.cont-ab-reg      then reg-1     else "")
     and   cotas.nome-mic-reg    = (if par-cota.cont-mic-reg     then micreg-1  else "")
     and   cotas.cod-rep         =  repres
     and   cotas.cd-produto      =  produto
     and   cotas.dt-inicial     <=  dt-inicial 
     and   cotas.dt-final       >=  dt-inicial no-error.

if   not avail cotas 
and par-cota.cont-ab-reg
and not par-cota.log-impl-niveis then

find last  cotas no-lock
     where cotas.cod-estabel     =  estab
     and   cotas.cod-canal-venda = (if par-cota.cont-canal-venda then canal-1   else 0)
     and   cotas.cod-gr-cli      = (if par-cota.cont-gr-cli      then grcli-1   else 0)
     and   cotas.nome-abrev      = (if par-cota.cont-cliente     then cliente-1 else "")
     and   cotas.nome-ab-reg     = (if par-cota.cont-ab-reg      then reg-0     else "")
     and   cotas.nome-mic-reg    = (if par-cota.cont-mic-reg     then micreg-1  else "")
     and   cotas.cod-rep         =  repres
     and   cotas.cd-produto      =  produto
     and   cotas.dt-inicial     <=  dt-inicial 
     and   cotas.dt-final       >=  dt-inicial no-error.                             

if not avail cotas 
THEN DO:
    /******************* Verifica o Canal de Vendas ************************/
    if can-find(first cotas where 
        cotas.cod-estabel     = estab and
        cotas.cod-canal-venda = canal-1 no-lock) then
        assign canal = canal-1.
    else
        assign canal = canal-0.


    /******************* Verifica o Grupo de Cliente ***********************/
    if canal = canal-1 then do:
        if can-find(first cotas where
            cotas.cod-estabel     = estab    and
            cotas.cod-canal-venda = canal    and
            cotas.cod-gr-cli      = grcli-1  no-lock) then 
            assign grcli = grcli-1.
        else
            if can-find(first cotas where
                cotas.cod-estabel     = estab and 
                cotas.cod-canal-venda = canal-1 and
                cotas.cod-gr-cli      = grcli-0 no-lock) then
                assign grcli = grcli-0.
            else
                assign canal = canal-0.
    end.

    if canal = canal-0 then do:
        if   can-find(first cotas where
             cotas.cod-estabel = estab and 
             cotas.cod-gr-cli  = grcli-1 no-lock) then
             assign grcli = grcli-1.
        else assign grcli = grcli-0.
    end.

    /******************* Verifica o cliente *************************/
    if canal = canal-1 and
       grcli = grcli-1 then do:
        if can-find(first cotas where
            cotas.cod-estabel     = estab    and
            cotas.cod-canal-venda = canal-1  and
            cotas.cod-gr-cli      = grcli-1  and 
            cotas.nome-abrev      = cliente-1 no-lock) then 
            assign cliente = cliente-1.
        else
            if can-find(first cotas where
                cotas.cod-estabel     = estab and
                cotas.cod-canal-venda = canal-1 and
                cotas.cod-gr-cli      = grcli-1 and
                cotas.nome-abrev      = cliente-0 no-lock) then
                assign cliente = cliente-0.
            else
                assign cliente = cliente-1.
    end.

    if canal = canal-1 and
       grcli = grcli-0 then do:
        if can-find(first cotas where
            cotas.cod-estabel     = estab and
            cotas.cod-canal-venda = canal-1 and
            cotas.cod-gr-cli      = grcli-0 and
            cotas.nome-abrev      = cliente-1 no-lock) then 
            assign cliente = cliente-1.
        else
            if can-find(first cotas where
                cotas.cod-estabel     = estab and
                cotas.cod-canal-venda = canal-1 and
                cotas.cod-gr-cli      = grcli-0 and
                cotas.nome-abrev      = cliente-0 no-lock) then
                assign cliente = cliente-0.
            else
                assign canal = canal-0
                       grcli = grcli-1.
    end.

    if canal = canal-0 and
       grcli = grcli-1 then do:
        if can-find(first cotas where
            cotas.cod-estabel     = estab and
            cotas.cod-canal-venda = canal-0 and
            cotas.cod-gr-cli      = grcli-1 and
            cotas.nome-abrev      = cliente-1 no-lock) then 
            assign cliente = cliente-1.
        else
            if can-find(first cotas where
                cotas.cod-estabel     = estab and
                cotas.cod-canal-venda = canal-0 and
                cotas.cod-gr-cli      = grcli-1 and
                cotas.nome-abrev      = cliente-0 no-lock) then
                assign cliente = cliente-0.
            else
                assign grcli = grcli-0.
    end.

    if canal = canal-0 and
       grcli = grcli-0 then do:
        if can-find(first cotas where
            cotas.cod-estabel     = estab and
            cotas.cod-canal-venda = canal-0 and
            cotas.cod-gr-cli      = grcli-0 and
            cotas.nome-abrev      = cliente-1 no-lock) then
            assign cliente = cliente-1.
        else
            assign cliente = cliente-0.
    end.

    /******* Acessos Canal Venda  *******/
    if canal   = canal-1   and
       grcli   = grcli-1   and
       cliente = cliente-1 then do:
          run pi-leitura.
          if return-value = "ok" then return "ok".
          
          assign canal   = canal-1
                 grcli   = grcli-1 
                 cliente = cliente-0 .
    end.

    /******* Acessos Canal Venda  *******/
    if canal   = canal-1   and
       grcli   = grcli-1   and
       cliente = cliente-0 then do:

          run pi-leitura.
          if return-value = "ok" then return "ok".

          assign canal   = canal-1
                 grcli   = grcli-0
                 cliente = cliente-1.
    end.

    /******* Acessos Canal Venda *******/
    if Canal   = Canal-1 and
       grcli   = grcli-0 and 
       cliente = cliente-1 then do:

          run pi-leitura.
          if return-value = "ok" then return "ok".

          assign canal = canal-1
                 grcli = grcli-0
                 cliente = cliente-0.

    end.

    /******* Acessos Canal de Vendas *******/
    if Canal   = Canal-1 and
       grcli   = grcli-0 and
       cliente = cliente-0 then do:

          run pi-leitura.
          if return-value = "ok" then return "ok".

          assign Canal   = Canal-0
                 grcli   = grcli-1
                 cliente = cliente-1.
    end.

    /******* Acessos Canal de Vendas  *******/
    if Canal   = Canal-0 and
       grcli   = grcli-1 and
       cliente = cliente-1 then do:
          run pi-leitura.
          if return-value = "ok" then return "ok".

           assign canal   = canal-0
                  grcli   = grcli-1
                  cliente = cliente-0.

    end.

    /******* Acessos Canal de Vendas *******/
    if Canal = Canal-0 and
       grcli = grcli-1 and
       cliente = cliente-0 then do:

          run pi-leitura.
          if return-value = "ok" then return "ok".

          assign canal = canal-0
                 grcli = grcli-0
                 cliente = cliente-1.
    end.

    /******* Acessos Canal de Vendas  *******/
    if Canal   = Canal-0 and
       grcli   = grcli-0 and
       cliente = cliente-1 then do:

          run pi-leitura.
          if return-value = "ok" then return "ok".

          assign canal   = canal-0
                 grcli   = grcli-0
                 cliente = cliente-0.

    end.

    /******* Acessos Canal de Vendas  *******/
    if Canal   = Canal-0   and
       grcli   = grcli-0   and
       cliente = cliente-0 then do:
          run pi-leitura.
          if return-value = "ok" then return "ok".

    end.

END.
ELSE assign r-cotas = rowid(cotas).

return "ok".

/* acp/acapi004.p */




/* *******************  PROCEDURE INTERNA  ********************  */

PROCEDURE pi-leitura.

    {acp/acapi004.i1 "reg-1" "micreg-1"}

    {acp/acapi004.i1 "reg-1" "micreg-0"}

    {acp/acapi004.i1 "reg-0" "micreg-1"}

    {acp/acapi004.i1 "reg-0" "micreg-0"}

END PROCEDURE.



