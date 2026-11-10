/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0501RP 2.00.00.018}  /*** 020018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0501RP MBC}
&ENDIF


/******************************************************************************
**
**     Copyright 1997 Datasul S.A. 
**
**     Programa...: BC0501.P
**
**     Finalidade.: Eliminacao de transacoes e etiquetas
**
******************************************************************************/
def var h-acomp          as handle               no-undo.
def var c-lit-selecao    as char format "x(07)"  no-undo.
def var c-lit-parametros as char format "x(10)"  no-undo.
def var c-lit-impressao  as char format "x(09)"  no-undo.
def var c-destino        as char format "x(10)"  no-undo.
DEF VAR i-cont-pai       AS INTEGER FORMAT '>>>>>>>>9' NO-UNDO.
DEF VAR i-cont-filho     AS INTEGER FORMAT '>>>>>>>>9' NO-UNDO.
DEF VAR c-lit-registros  AS CHARACTER FORMAT 'x(90)' NO-UNDO.

define temp-table tt-param NO-UNDO
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field d-trans-ini      as decimal
    field d-trans-fim      as decimal
    field d-dt-ini         as date             
    field d-dt-fim         as date
    field hora-exec        as integer
    field l-nova           as logical
    field l-atualizada     as logical
    field l-com-erro       as logical
    FIELD l-em-processo    AS LOGICAL
    FIELD l-cancelado      AS LOGICAL
    field l-movimento      as logical
    field l-etiqueta       as logical
    field c-cd-trans-ini   like bc-trans.cd-trans
    field c-cd-trans-fim   like bc-trans.cd-trans
    field c-horario-ini    like bc-trans.horario
    field c-horario-fim    like bc-trans.horario.

def temp-table tt-raw-digita NO-UNDO
    field raw-digita as raw.

def input param raw-param as raw no-undo.
def input param table for tt-raw-digita.

def var c-transacao as char.
def var c-nr-trans  as char.

create tt-param.
raw-transfer raw-param to tt-param.

form
    skip(2)
    c-lit-selecao         no-label colon 55
    skip(1)
    tt-param.d-trans-ini  format "zzzzzzzzz9" colon 60 "|< >|"
    tt-param.d-trans-fim  format "zzzzzzzzz9" no-label
    tt-param.d-dt-ini                           colon 60   space(1) "|< >|"
    tt-param.d-dt-fim       no-label   
    tt-param.c-horario-ini  label "Hora Transa‡Æo" colon 60   space(3) "|< >|"
    tt-param.c-horario-fim  no-label   
    skip(1)
    c-lit-parametros      no-label colon 55
    skip(1)
    tt-param.l-nova            colon 60
    tt-param.l-atualizada      colon 60
    tt-param.l-com-erro        colon 60
    tt-param.l-em-processo     colon 60
    tt-param.l-cancelado       colon 60
    skip(1) 
    c-lit-impressao       no-label colon 55
    skip(1)
    c-destino                      colon 60 "-"
    tt-param.arquivo      no-label format "x(30)"
    tt-param.usuario               colon 60
    skip(1)
    c-lit-registros            NO-LABEL COLON 38
    with side-label stream-io width 132 frame f-fim.

{utp/ut-liter.i Sele‡Æo * r}
assign c-lit-selecao = trim(return-value).

{utp/ut-liter.i Parƒmetros * r}
assign c-lit-parametros = trim(return-value).

{utp/ut-liter.i ImpressÆo * r}
assign c-lit-impressao = trim(return-value).

{utp/ut-liter.i Destino * r}
assign c-destino:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Usu rio * r}
assign tt-param.usuario:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans nr-trans 1}
assign tt-param.d-trans-ini:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans data 1}
assign tt-param.d-dt-ini:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Atualizados * r}
assign tt-param.l-atualizada:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Sim/NÆo * r}
assign tt-param.l-atualizada:format in frame f-fim = trim(return-value).

{utp/ut-liter.i Nova * r}
assign tt-param.l-nova:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Sim/NÆo * r}
assign tt-param.l-nova:format in frame f-fim = trim(return-value).

{utp/ut-liter.i "Com erro" * r}
assign tt-param.l-com-erro:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Sim/NÆo * r}
assign tt-param.l-com-erro:format in frame f-fim = trim(return-value).

{utp/ut-liter.i "Em Processo" * r}
assign tt-param.l-em-processo:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Sim/NÆo * r}
assign tt-param.l-em-processo:format in frame f-fim = trim(return-value).

{utp/ut-liter.i Cancelado * r}
assign tt-param.l-cancelado:label in frame f-fim = trim(return-value).

{utp/ut-liter.i Sim/NÆo * r}
assign tt-param.l-cancelado:format in frame f-fim = trim(return-value).

{utp/ut-liter.i "Quantidade de Registros Eliminados (bc-trans/bc-trans-filho): " * R}
ASSIGN c-lit-registros = TRIM(RETURN-VALUE).

{include/i-rpvar.i}
run utp/ut-trfrrp.p (input frame f-fim:handle).
{include/i-rpcab.i}
{include/i-rpout.i}
{cdp/cdcfgint.i}

run utp/ut-acomp.p persistent set h-acomp.         

{utp/ut-liter.i Eliminando_Transa‡äes * r}
run pi-inicializar in h-acomp (input return-value).

view frame f-cabec.
view frame f-rodape.

{utp/ut-liter.i "Transa‡Æo: " * r}
assign c-transacao = trim(return-value).
{utp/ut-liter.i "Nr.Trans: " * r}
assign c-nr-trans = trim(return-value).

ASSIGN i-cont-pai = 0
       i-cont-filho = 0.

for  each bc-trans
    where bc-trans.nr-trans >= tt-param.d-trans-ini
      and bc-trans.nr-trans <= tt-param.d-trans-fim
      and bc-trans.data     >= tt-param.d-dt-ini
      and bc-trans.data     <= tt-param.d-dt-fim
      and bc-trans.cd-trans >= tt-param.c-cd-trans-ini
      and bc-trans.cd-trans <= tt-param.c-cd-trans-fim
      and bc-trans.horario  >= tt-param.c-horario-ini
      and bc-trans.horario  <= tt-param.c-horario-fim
    &IF "{&mgcld_version}" <= "2.02" &THEN
      and   (   (       bc-trans.log-1          = yes
                    and tt-param.l-etiqueta     = yes)
             or (       bc-trans.log-1          = no
                    and tt-param.l-movimento    = yes ))
   &else
    and   (   (       bc-trans.ind-tipo-trans = 1
                  and tt-param.l-etiqueta     = yes)
           or (       bc-trans.ind-tipo-trans = 2
                  and tt-param.l-movimento    = yes ))
    &endif   
      and ((tt-param.l-atualizada   = yes and bc-trans.estado-trans = 2)
      or   (tt-param.l-nova         = yes and bc-trans.estado-trans = 1)
      or   (tt-param.l-com-erro     = yes and bc-trans.estado-trans = 3)
      or   (tt-param.l-em-processo  = yes and bc-trans.estado-trans = 4)
      or   (tt-param.l-cancelado    = yes and bc-trans.estado-trans = 5)) exclusive-lock:

      run pi-acompanhar in h-acomp (input   c-transacao
                                          + bc-trans.cd-trans
                                          + " "
                                          + c-nr-trans
                                          + string(bc-trans.nr-trans)).

      &IF "{&mgcld_version}" >= "2.02" &THEN
        FOR  EACH bc-trans-filho
            WHERE bc-trans-filho.nr-trans = bc-trans.nr-trans EXCLUSIVE-LOCK:
            DELETE bc-trans-filho.
            ASSIGN i-cont-filho = i-cont-filho + 1.
        END.
      &ENDIF

      ASSIGN i-cont-pai = i-cont-pai + 1.
      delete bc-trans.

end.
ASSIGN c-lit-registros = c-lit-registros + STRING(i-cont-pai,'>>>>>>>>9') + '/':U + STRING(i-cont-filho,'>>>>>>>>9').

assign c-destino = {varinc/var00002.i 04 tt-param.destino}.

disp
    c-lit-selecao
    tt-param.d-trans-ini
    tt-param.d-trans-fim
    tt-param.d-dt-ini   format "99/99/9999"
    tt-param.d-dt-fim   format "99/99/9999"
    tt-param.c-horario-ini
    tt-param.c-horario-fim
    c-lit-parametros
    tt-param.l-nova
    tt-param.l-atualizada
    tt-param.l-com-erro
    tt-param.l-em-processo
    tt-param.l-cancelado
    c-destino
    c-lit-registros
    c-lit-impressao
    c-destino
    tt-param.arquivo
    tt-param.usuario
    with frame f-fim.

{include/i-rpclo.i}

run pi-finalizar in h-acomp.

return "OK".
