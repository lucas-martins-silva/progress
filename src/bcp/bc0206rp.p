/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0206RP 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0206RP MBC}
&ENDIF


/*************************************************************************
**
**     Programa BC0206RP.P
**
**************************************************************************/
{include/i_dbvers.i}

def var c-lit-selecao    as char format "x(07)" no-undo.
def var c-lit-impressao  as char format "x(09)" no-undo.
def var c-lit-trans      as char format "X(60)" no-undo.
def var c-trans          as char format "X(60)" no-undo.
def var c-destino        as char format "x(10)" no-undo.
def var h-acomp          as handle              no-undo.
def var c-tipo-trans     as char format "x(15)" no-undo.
def var c-movimento      as char format "x(15)" no-undo.
def var c-etiqueta       as char format "x(15)" no-undo.
def var c-estado-trans   as char format "x(15)" no-undo.
def var c-nova           as char format "x(15)" no-undo.
def var c-atualizada     as char format "x(15)" no-undo.
def var c-erro           as char format "x(15)" no-undo.
def var c-processo       as char format "x(15)" no-undo.
def var c-cancelado      as char format "x(15)" no-undo.
def var c-lit-erros      as char format "x(10)" no-undo.
def var c-linha          as char format "x(122)" no-undo.
def var c-linha1         as char format "x(122)" no-undo.
def var i-cont           as int  initial 1      no-undo.
def var c-detalhe-1      as char format "X(50)" no-undo.
def var c-detalhe-2      as char format "X(50)" no-undo.
def var c-detalhe-3      as char format "X(50)" no-undo.
def var c-detalhe-4      as char format "X(50)" no-undo.
def var c-detalhe-5      as char format "X(50)" no-undo.
def var i                as integer             no-undo.
def var i2               as integer             no-undo.
def var i3               as integer             no-undo.
def var i4               as integer             no-undo.
def var i5               as integer             no-undo.
Def Var c-Ltr            As Char                 No-undo.
Def Var c-Ltr1           As Char                 No-undo.
Def Var c-Ltr2           As Char                 No-undo.
Def Var c-Ltr3           As Char                 No-undo.
Def Var c-Ltr4           As Char                 No-undo.
Def Var c-Ltr5           As Char                 No-undo.
Def Var c-Ltr6           As Char                 No-undo.
DEF VAR i-contador       AS INTEGER             NO-UNDO.
def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
def new global shared var v_cdn_empres_usuar   like empresa.ep-codigo        no-undo.

{bcp/bc0206.i} /* Include para a defini‡Æo da temp-table de parƒmetros gerais */
{include/i_fnctrad.i}

define temp-table tt-raw-digita NO-UNDO
    field raw-digita    as raw.

def input param r-raw as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer r-raw to tt-param.

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i "Efetiva‡Æo Transa‡Æo" * L}
run pi-inicializar in h-acomp (input trim(return-value)).

form
    skip(2)
    c-lit-selecao         no-label colon 30
    skip(1)
    tt-param.transacao-ini     format "x(8)" colon 30 "|< >|"
    tt-param.transacao-fim     format "x(8)" no-label
    skip(1) 
    c-lit-impressao       no-label colon 30
    skip(1)
    c-destino             colon 30 "-"
    tt-param.arquivo      no-label format "x(30)"
with side-label stream-io width 132 frame f-fim.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-fim:Handle).
&ENDIF

{utp/ut-liter.i Sele‡Æo * R}
assign c-lit-selecao = trim(return-value).

{utp/ut-liter.i ImpressÆo * R}
assign c-lit-impressao = trim(return-value).

{utp/ut-liter.i Destino * R}
assign c-destino:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld bc-trans cd-trans 1}
assign tt-param.transacao-ini:label in frame f-fim = trim(return-value).

{include/i-rpvar.i}

assign i-ep-codigo-usuario = tt-param.ep-codigo
       v_cdn_empres_usuar  = i-ep-codigo-usuario.

find first empresa no-lock
    where empresa.ep-codigo = i-ep-codigo-usuario no-error.
if  avail empresa
then
    assign c-empresa = empresa.razao-social.
else
    assign c-empresa = "".

{utp/ut-liter.i "Relat¢rio de Transa‡äes" * L}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i "Coleta de Dados" * C}
assign c-sistema  = trim(return-value).

{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

{utp/ut-liter.i Erros * L}
assign c-lit-erros = trim(return-value).

{utp/ut-liter.i Nova * L}
assign c-nova = trim(return-value).

{utp/ut-liter.i Atualizada * l}
assign c-atualizada = trim(return-value).

{utp/ut-liter.i "Com Erro" * L}
assign c-erro = trim(return-value).

{utp/ut-liter.i "Em Processo" * l}
assign c-processo = trim(return-value).
{utp/ut-liter.i Cancelado * l}
assign c-cancelado = trim(return-value).
{utp/ut-liter.i Movimento * L}
assign c-movimento = trim(return-value).

{utp/ut-liter.i Etiqueta * L}
assign c-etiqueta = trim(return-value).

{utp/ut-field.i mgcld bc-trans cd-trans 1}
assign  c-trans = trim(return-value).

{utp/ut-liter.i Num_Trans *}
Assign c-Ltr = Return-value + Fill(" ",Length("Num_Trans") + 1 - Length(Return-value)).

{utp/ut-liter.i Estado_Transa‡Æo *}
Assign c-Ltr1 = Return-value + Fill(" ",Length("Estado_Transa‡Æo") + 1 - Length(Return-value)).

{utp/ut-liter.i Dt_Transa‡Æo *}
Assign c-Ltr2 = Return-value + Fill(" ",Length("Dt_Transa‡Æo") + 1 - Length(Return-value)).

{utp/ut-liter.i Hora *}
Assign c-Ltr3 = Return-value + Fill(" ",Length("Hora") + 5 - Length(Return-value)).

{utp/ut-liter.i Tipo_Transa‡Æo *}
Assign c-Ltr4 = Return-value + Fill(" ",Length("Tipo_Transa‡Æo") + 2 - Length(Return-value)). 

{utp/ut-liter.i Usu rio *}
Assign c-Ltr5 = Return-value + Fill(" ",Length("Usu rio") + 6 - Length(Return-value)).

{utp/ut-liter.i Detalhe *}
ASSIGN c-Ltr6 = Return-value + Fill(" ",Length("Detalhe") + 6 - Length(Return-value)).

assign c-linha  = fill("-", 122).
assign c-linha1 = fill("=", 122).

for  each bc-trans  field(bc-trans.cd-trans bc-trans.data bc-trans.horario bc-trans.nr-trans bc-trans.log-1 bc-trans.estado-trans bc-trans.usuario bc-trans.detalhe &if "{&mgcld_version}" >= "2.04" &then bc-trans.ind-tipo-trans &endif) NO-LOCK
    where bc-trans.cd-trans >= tt-param.transacao-ini
      and bc-trans.cd-trans <= tt-param.transacao-fim
      and bc-trans.data     >= tt-param.da-ini
      and bc-trans.data     <= tt-param.da-fim
      and bc-trans.horario  >= tt-param.hr-ini
      and bc-trans.horario  <= tt-param.hr-fim
      and bc-trans.nr-trans >= tt-param.nr-trans-ini
      and bc-trans.nr-trans <= tt-param.nr-trans-fim
      and (   tt-param.est-nova       = yes and bc-trans.estado-trans = 1
           or tt-param.est-atualizada = yes and bc-trans.estado-trans = 2
           or tt-param.est-erro       = yes and bc-trans.estado-trans = 3
           or tt-param.est-processo   = yes and bc-trans.estado-trans = 4
           or tt-param.est-cancelado  = yes and bc-trans.estado-trans = 5)
    break by bc-trans.cd-trans:

    find first bc-tipo-trans
         where bc-tipo-trans.cd-trans = bc-trans.cd-trans
         no-lock no-error.

    if  avail bc-tipo-trans then do:
        if  first-of(bc-trans.cd-trans)
        then do:

            put unformatted
                skip(1)
                "==========["
                c-trans
                ": "
                trim(bc-tipo-trans.cd-trans)
                " - "
                trim(bc-tipo-trans.descricao)
                "]"
                substring(c-linha1,1,length(c-linha1) - (   length(trim(c-trans))
                                                          + length(trim(bc-tipo-trans.cd-trans))
                                                          + length(trim(bc-tipo-trans.descricao))
                                                          + 8))
                skip(1).

            put Unformatted space(01)
                c-Ltr  
                c-Ltr1 
                c-Ltr2 
                c-Ltr3 
                c-Ltr4 
                c-Ltr5 
                c-Ltr6
                skip.

            put "----------------------------------------------------------------------"
                "------------------------------------------------------------"
                skip.
        end.

       IF i-contador > 100 THEN DO:
           ASSIGN i-contador = 0.
           run pi-acompanhar in h-acomp (input (bc-trans.cd-trans + "/":U + STRING(bc-trans.nr-trans))).
        END.
        ASSIGN i-contador = i-contador + 1.

        if  bc-trans.estado-trans = 1 then
            assign c-estado-trans = c-nova.
        if  bc-trans.estado-trans = 2 then
            assign c-estado-trans = c-atualizada.
        if  bc-trans.estado-trans = 3 then
            assign c-estado-trans = c-erro.
        if  bc-trans.estado-trans = 4 then
            assign c-estado-trans = c-processo.
        ELSE if bc-trans.estado-trans = 5 then
            assign c-estado-trans = c-cancelado.

         &if "{&mgcld_version}" < "2.04" &then
            if  bc-trans.log-1 = no then
        &else
            if  bc-trans.ind-tipo-trans = 2 then
        &endif
            assign c-tipo-trans = c-movimento.
        else
            assign c-tipo-trans = c-etiqueta.      

        put bc-trans.nr-trans
            c-estado-trans      at 12
            bc-trans.data       at 29
            bc-trans.horario    at 42
            c-tipo-trans        at 51
            bc-trans.usuario    at 67.

        assign  c-detalhe-2 = ""
                c-detalhe-3 = ""
                c-detalhe-4 = ""
                c-detalhe-5 = ""
                c-detalhe-1 = substring(bc-trans.detalhe, 1, 50).

        if  length(bc-trans.detalhe) > 50
        then do:
            do  i = length(c-detalhe-1) to 1 by -1:
                if  substring(c-detalhe-1, i, 1) = ""
                then do:
                    assign  c-detalhe-1 = substring(c-detalhe-1, 1, i).
                    leave.
                end.
            end.

            /*come‡a c-detalhe-2*/
            assign  c-detalhe-2   = substring(bc-trans.detalhe, i + 1, 50).
            if  length(c-detalhe-2) > 45
            then do:
                do  i2 = length(c-detalhe-2) to 1 by -1:
                    if  substring(c-detalhe-2, i2, 1) = ""
                    then do:
                        assign  c-detalhe-2   = substring(c-detalhe-2, 1 ,i2).
                        leave.       
                    end.
                end.

                /*come‡a c-detalhe-3*/
                assign  c-detalhe-3   = substring(bc-trans.detalhe, i + i2 + 1, 50).
                if  length(c-detalhe-3) > 45
                then do:
                    do  i3 = length(c-detalhe-3) to 1 by -1:
                        if  substring(c-detalhe-3, i3, 1) = ""
                        then do:
                            assign  c-detalhe-3   = substring(c-detalhe-3, 1 ,i3).
                            leave.
                        end.
                    end.

                    /*come‡a c-detalhe-4*/
                    assign  c-detalhe-4   = substring(bc-trans.detalhe, i + i2 + i3 + 1, 50).
                    if  length(c-detalhe-4) > 45
                    then do:
                        do  i4 = length(c-detalhe-4) to 1 by -1:
                            if  substring(c-detalhe-4, i4, 1) = ""
                            then do:
                                assign  c-detalhe-4   = substring(c-detalhe-4, 1 ,i4).
                                leave.
                            end.
                        end.

                        /*come‡a c-detalhe-5*/
                        assign  c-detalhe-5   = substring(bc-trans.detalhe, i + i2 + i3 + i4 + 1, 50).
                        if  length(c-detalhe-5) > 45
                        then do:
                            do  i5 = length(c-detalhe-5) to 1 by -1:
                                if  substring(c-detalhe-5, i5, 1) = ""
                                then do:
                                    assign  c-detalhe-5   = substring(c-detalhe-5, 1 ,i5).
                                    leave.
                                end.
                            end.
                        end /* if */ . 
                    end /* if */ .
                end /* if */ .
            end /* if */ .
        end /* if */ .                    

        put c-detalhe-1   at 80   format "X(50)"  skip.
        if c-detalhe-2 <> "" then do: 
            put " " c-detalhe-2   at 80   format "X(50)"  skip.
            if c-detalhe-3 <> "" then do:
                put " " c-detalhe-3   at 80   format "X(50)"  skip.
                if c-detalhe-4 <> "" then do:
                    put " " c-detalhe-4   at 80   format "X(50)"  skip.
                    if c-detalhe-5 <> ""  then
                         put " " c-detalhe-5   at 80   format "X(50)"  skip.
                end.
            end.
        end.

    end.

    if tt-param.imp-erros = yes then do:
        assign i-cont = 1.
        for  each bc-trans-erros  fields(bc-trans-erros.nr-trans bc-trans-erros.cd-msg bc-trans-erros.texto-msg)  no-lock 
            where bc-trans-erros.nr-trans = bc-trans.nr-trans
            break by bc-trans-erros.nr-trans:

            if i-cont = 1 then
                put unformatted
                    space(11)
                    "["
                    trim(c-lit-erros)
                    "]"
                    substring(c-linha,1,length(c-linha) - (length(trim(c-lit-erros)) + 5))
                    skip.

            put space(15)
                bc-trans-erros.cd-msg
                space(1)
                bc-trans-erros.texto-msg
                skip.
            assign i-cont = 99.
            if  last-of(bc-trans-erros.nr-trans)
            then put skip(1).
        end.
    end.    
end.        

assign c-destino = {varinc/var00002.i 04 tt-param.destino}.

disp
    c-lit-selecao
    tt-param.transacao-ini
    tt-param.transacao-fim
    c-lit-impressao
    c-destino
    tt-param.arquivo
    with frame f-fim.

{include/i-rpclo.i}

run pi-finalizar in h-acomp.

return "OK".
