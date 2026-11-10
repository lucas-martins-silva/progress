/****************************************************************************
**
**   app/ap1001.i3 - Gerenciamento dos movimentos p/ envio ao banco.
**
****************************************************************************/

/*fut36887 - atividade 140138 - testa se o usu rio tem o Banking Connect habilitado*/
{include/getdefinedfunction.i} /*** Verificar se a fun‡Æo especial est  habilitada ***/

def var l-banking-connect as logical initial no no-undo.
DEF VAR v_hdl_reg_produt  AS HANDLE NO-UNDO.             /* Handle para o controle de registro - cdp/cd4210b.p */
DEF VAR l-registro-ok     AS LOGICAL INITIAL NO NO-UNDO. /* Variavel auxiliar para verifica‡Æo do Registro */
DEF VAR d-limite          AS DATE NO-UNDO.               /* Data limite do registro */
DEF VAR c-empresa-banking AS CHAR NO-UNDO.               /* Empresa do registro encontrado */
DEF VAR l-integra-banking AS LOGICAL INITIAL NO NO-UNDO. /* Verifica se h  integra‡Æo com Banking fut40695 */

/* Banking Connect - Verifica‡Æo do Registro - Inicializando Handle */
IF NOT VALID-HANDLE(v_hdl_reg_produt)
        OR  v_hdl_reg_produt:TYPE       <> "procedure":U
        OR  v_hdl_reg_produt:FILE-NAME  <>  "cdp/cd4210b.p":U
       THEN run cdp/cd4210b.p PERSISTENT SET v_hdl_reg_produt.

/* Verifica se o usu ri otem persmissÆo para usar o Banking Connect */
&if "{&mgadm_version}" >= "2.04" &then
    /* Procura o registro */
    run find_registro in v_hdl_reg_produt (OUTPUT l-registro-ok, OUTPUT c-empresa-banking).

    /* Se encontrar verifica a data limite */
    IF l-registro-ok then do:
        RUN retorna_data_limite IN v_hdl_reg_produt (OUTPUT d-limite).
        
        /* Se a data Limite ‚ valida */
        assign l-banking-connect = TODAY <= d-limite.

        /* Mensagem 30 dias antes do prazo do termino da licen‡a */
        IF ((d-limite - 30) <= TODAY) and (today <= d-limite) then do:
            run utp/ut-msgs.p (input "show",
                               input 31436,
                               input STRING(d-limite - TODAY)).
        end.

        /* Mensagem de vencimento do Banking */
        if (today > d-limite) then do:
            run utp/ut-msgs.p (input "show",
                               input 31456,
                               input STRING(d-limite - TODAY)).
        end.
    end.
&else
     assign  l-banking-connect = no.
&endif.


assign de-hea-val = 0
       i-hea-qua  = 0.

/*for each tt-digita:*/
/* Banking Connect "for each tt-digita:" */
for each tt-digita no-lock
break by tt-digita.i-tipo-pagto
      by tt-digita.dt-vencimen:
      
    assign da-venci = tt-digita.dt-vencimen.
    
    if first-of(tt-digita.dt-vencimen) then do:
        disp da-venci with frame f-venci.
    end.

    l-integra-banking = NO.
    &if "{&mgadm_version}" >= "2.04" &then
        l-integra-banking = (portador.log-4 = yes) and (l-banking-connect = yes).
    &endif.
        
    if l-integra-banking then
        assign i-tipo-pag = tt-digita.i-tipo-pagto.
    else
    do:
        if l-varios-pagtos 
        and i-op-banco = 237 then do:
            assign i-tipo-pag = tt-digita.i-tipo-pagto.
        end.
        else do:
            assign i-tipo-pag = tt-param.i-tipo-pag.
        end.
    end.
    
    /* ---- Antecipacoes ---- */
    find first bordero-ap where rowid(bordero-ap) = tt-digita.row-mov-ap no-lock no-error.
    if  avail bordero-ap then do:
        assign l-antecipacao = yes.
    end.    
    else do:
    /*--- Documentos Normais ---*/
        find first mov-ap where rowid(mov-ap) = tt-digita.row-mov-ap no-lock no-error.
        if  avail mov-ap then do:
            assign l-antecipacao = no.
        end.
    end.
    
    if  avail mov-ap or avail bordero-ap then do:
        {app/ap1001.i14 "{1}" 
                        "{2}"}
    end.
end.


{"{3}"} /* trailer de arquivo */

if  line-counter >= 62 then
    page.

disp de-tot-geral-l
     de-tot-geral-b with frame f-tot-geral.

if (portador.cod-febraban <> 745
and portador.cod-febraban <> 237
and portador.cod-febraban <> 001) 
or (portador.cod-febraban  = 237 
and portador.dec-2         = 1) 
or (portador.cod-febraban  = 001 
and tt-param.l-incl-param-arq) then 
    put stream relat unformatted chr(26).
else
    put stream relat unformatted skip.    

page.

hide frame f-cabec2.
disp tt-param.i-empresa
     tt-param.i-portador
     c-banco
     tt-param.c-arquivo-remessa
     tt-param.c-esp-ini
     tt-param.c-esp-fim
     tt-param.c-est-ini
     tt-param.c-est-fim
     tt-param.da-inicial
     tt-param.da-final
     tt-param.da-vencimen-ini
     tt-param.da-vencimen-fim
     tt-param.i-docto-ini
     tt-param.i-docto-fim
     tt-param.i-fornec-ini
     tt-param.i-fornec-fim
     tt-param.c-ser-ini
     tt-param.c-ser-fim
     tt-param.i-bord-ini
     tt-param.i-bord-fim
     with frame f-cabec1.

output stream relat close.

{include/i-rpclo.i}

if valid-handle(v_hdl_reg_produt) then
   delete procedure(v_hdl_reg_produt).
/*-- Fim da Include --*/
