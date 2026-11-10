/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0103RP 2.00.00.015}  /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0103RP MBC}
&ENDIF


/*************************************************************************
**
**     Programa BC0103RP.P
**
**************************************************************************/
def var c-lit-selecao    as char format "x(07)"  no-undo.
def var c-lit-impressao  as char format "x(09)"  no-undo.
def var c-destino        as char format "x(10)"  no-undo.
def var i-nr-linha       as inte format "999"    no-undo.
def var i-p-anterior     as inte format "999"    no-undo.
def var i-p-inicial      as inte format "999"    no-undo.
def var i-p-final        as inte format "999"    no-undo.
def var i-tamanho        as inte format "999"    no-undo.
def var i-cod-campo      as inte                 no-undo.
def var da-exec          as date                 no-undo.
def var h-acomp          as handle               no-undo.
def var l-erro           as logical              no-undo.
def var c-msg            as char                 no-undo.
def var c-estado         as char format "x(15)"  no-undo.
def var c-detalhe        as char                 no-undo.
def var c-descricao      as char format "X(25)"  no-undo.
def var c-etiqueta       as char                 no-undo.
def var c-campo          as char                 no-undo.
def var c-tipo-etiq      as char format "x(15)"  no-undo.
def var c-descricao2     as char format "x(15)"  no-undo.
def var c-auxiliar       as char format "x(10)"  no-undo.
Def Var c-Ltr            As Char                 No-undo.
Def Var c-Ltr1           As Char                 No-undo.
Def Var c-Ltr2           As Char                 No-undo.
Def Var c-Ltr3           As Char                 No-undo.
Def Var c-Ltr4           As Char                 No-undo.
Def Var c-Ltr5           As Char                 No-undo.

def new global shared var i-ep-codigo-usuario  like empresa.ep-codigo no-undo.
def new global shared var v_cdn_empres_usuar   like empresa.ep-codigo no-undo.

{bcp/bc0103a.i}
{include/i_fnctrad.i}

define temp-table tt-raw-digita NO-UNDO
    field raw-digita    as raw.

def input param r-raw as raw no-undo.
def input param table for tt-raw-digita.

create tt-param.
raw-transfer r-raw to tt-param.

{cdp/cd0666.i}

run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i "Relat¢rio de Etiquetas" * r}
run pi-inicializar in h-acomp (input trim(return-value)).

form
    skip(2)
    c-lit-selecao         no-label colon 55
    skip(1)
    tt-param.tp-etiq-ini     format "zzzzzzzzz9" colon 60 "|< >|"
    tt-param.tp-etiq-fim     format "zzzzzzzzz9" no-label
    skip(1) 
    c-lit-impressao       no-label colon 55
    skip(1)
    c-destino             colon 60 "-"
    tt-param.arquivo      no-label format "x(30)"
    with side-label stream-io width 132 frame f-fim.
&IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
    If Search("utp/ut-trfrrp.p") <> ? Or Search("utp/ut-trfrrp.r") <> ? Then
        Run utp/ut-trfrrp.p (input Frame f-fim:Handle).
&ENDIF

{utp/ut-liter.i Sele‡Æo * r}
assign c-lit-selecao = trim(return-value).

{utp/ut-liter.i ImpressÆo * r}
assign c-lit-impressao = trim(return-value).

{utp/ut-liter.i Destino * r}
assign c-destino:label in frame f-fim = trim(return-value).

{utp/ut-field.i mgcld tipo-etiqueta tipo-etiq 1}
assign tt-param.tp-etiq-ini:label in frame f-fim = trim(return-value).

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

{utp/ut-liter.i "Relat¢rio de Etiquetas" * L}
assign c-titulo-relat = trim(return-value).

{utp/ut-liter.i Coleta_de_Dados * C}
assign c-sistema  = trim(return-value).

{include/i-rpcab.i}
{include/i-rpout.i}

view frame f-cabec.
view frame f-rodape.

{utp/ut-liter.i "Etiqueta:" * r}
assign c-etiqueta = trim(return-value).
{utp/ut-liter.i "Campo:" * r}
assign c-campo = trim(return-value).
{utp/ut-liter.i "Tipo Etiqueta" * L}
assign c-tipo-etiq = trim(return-value) + ": ".
{utp/ut-liter.i Descri‡Æo * L}
assign c-descricao2 = trim(return-value) + ": ".
{utp/ut-liter.i Auxiliar * L}
assign c-auxiliar = trim(return-value) + " : ".

{bcp/bc0001.i1} /* UniÆo das Inclides i01cl016.i, i02cl016.i, i03cl016.i    */

for  each tipo-etiqueta no-lock
    where tipo-etiqueta.tipo-etiq    >= tt-param.tp-etiq-ini
      and tipo-etiqueta.tipo-etiq    <= tt-param.tp-etiq-fim:

    display c-tipo-etiq  string(tipo-etiqueta.tipo-etiq,"9999")
            c-descricao2 tipo-etiqueta.titulo   skip
            space(19)
            c-auxiliar   tipo-etiqueta.auxiliar
            with no-labels stream-io width 100.

    assign i-p-anterior = 0
           i-p-inicial  = 0
           i-p-final    = 0
           i-nr-linha   = 1.

    for  each seq-tipo-etiqueta
        where seq-tipo-etiqueta.tipo-etiq = tipo-etiqueta.tipo-etiq no-lock:

        assign  i-cod-campo = truncate(seq-tipo-etiqueta.cod-campo / 1000, 0)
                c-descricao = substring(entry(i-cod-campo,c-lista),1,23).

        if (i-cod-campo = 17) then
            assign i-tamanho = if int(length(seq-tipo-etiqueta.char-1)) <> 0 then
                                  int(length(seq-tipo-etiqueta.char-1)) else 1.
        else
        if (i-cod-campo >= 19 and i-cod-campo <= 29) then
            assign i-tamanho = if int(seq-tipo-etiqueta.int-1) <> 0 then
                                  int(seq-tipo-etiqueta.int-1) else 1.
        else
            assign i-tamanho = int(substring(entry(i-cod-campo,c-lista),28,4)).

        assign c-detalhe =   c-etiqueta
                           + " "
                           + string(seq-tipo-etiqueta.tipo-etiq,"9999")
                           + " - "
                           + c-campo
                           + " "
                           + string(i-cod-campo).

        run pi-acompanhar in h-acomp (input c-detalhe).

        run pi-nova-linha(input         i-cod-campo,
                          input-output  i-nr-linha,
                          input-output  i-p-anterior).

        run pi-calcula-posicao (input   i-cod-campo,
                                output  i-p-inicial,
                                output  i-p-final).

        {utp/ut-liter.i Sequencia *}
        Assign c-Ltr = Return-value.
        {utp/ut-liter.i Descricao *}
        Assign c-Ltr1 = Return-value.
        {utp/ut-liter.i Tamanho *}
        Assign c-Ltr2 = Return-value.
        {utp/ut-liter.i Linha *}
        Assign c-Ltr3 = Return-value.
        {utp/ut-liter.i Inicial *}
        Assign c-Ltr4 = Return-value.
        {utp/ut-liter.i Final *}
        Assign c-Ltr5 = Return-value.
        {utp/ut-liter.i Formato *}
        display space(19)
                seq-tipo-etiqueta.sequencia COLUMN-LABEL "Sequencia"    format "999"
                c-descricao                 COLUMN-LABEL "Descricao"
                i-tamanho                   COLUMN-LABEL "Tamanho"      when i-tamanho   <> 0
                space(02)
                i-nr-linha                  COLUMN-LABEL "Linha"        when i-tamanho   <> 0
                space(02)
                i-p-inicial                 COLUMN-LABEL "Inicial"      when i-p-inicial <> 0
                space(02)
                i-p-final                   COLUMN-LABEL "Final"        when i-p-final   <> 0
                space(02)
                seq-tipo-etiqueta.char-1    COLUMN-LABEL "Formato"      format "X(21)"
                with stream-io width 132 Frame fTrad Down.

        /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
        RUN utp/ut-trfrrp.p (INPUT FRAME fTrad:HANDLE).
                 Assign seq-tipo-etiqueta.sequencia:label In Frame fTrad = c-Ltr
                c-descricao:label In Frame fTrad  = c-Ltr1
                i-tamanho:label In Frame fTrad  = c-Ltr2
                i-nr-linha:label In Frame fTrad  = c-Ltr3
                i-p-inicial:label In Frame fTrad  = c-Ltr4
                i-p-final:label In Frame fTrad  = c-Ltr5
                char-1:label In Frame fTrad  = Return-value.
    end.
end.

assign c-destino = {varinc/var00002.i 04 tt-param.destino}.

disp
    c-lit-selecao
    tt-param.tp-etiq-ini
    tt-param.tp-etiq-fim
    c-lit-impressao
    c-destino
    tt-param.arquivo
    with frame f-fim.

{include/i-rpclo.i}

run pi-finalizar in h-acomp.

/*******************************************************************************/
PROCEDURE PI-NOVA-LINHA:
def input         param i-campo-atual as int.
def input-output  param i-linha       as int.
def input-output  param i-anterior    as int.

if i-campo-atual       = 18 then  /* campo Nova Linha */ do:
    assign  i-linha    = i-linha + 1
            i-anterior = 0.
end.
else do:
    assign  i-linha  = i-linha.
end.

END PROCEDURE.

/*******************************************************************************/
Procedure PI-CALCULA-POSICAO:
define input    param i-campo-atu   as integer.
define output   param i-inicial     as integer.
define output   param i-final       as integer.

assign  i-inicial    = (if i-campo-atu <> 18 then (i-p-anterior + 1) else i-p-anterior)
        i-final      = i-p-anterior + 
                       (if      substring(seq-tipo-etiqueta.char-1,1,2) = "X(" then
                            int(substring(seq-tipo-etiqueta.char-1,3,3))
                        else
                            (if int(length(seq-tipo-etiqueta.char-1)) <> 0 then
                                int(length(seq-tipo-etiqueta.char-1))
                             else
                                int(substring(entry(i-campo-atu,c-lista),28, 4))))
        i-p-anterior = i-final.

END PROCEDURE.

/*******************************************************************************/

/*
 * 
 * if (i-campo-atu  = 17) then do:
 *     assign i-inicial    = i-p-anterior + 1
 *            i-final      = i-p-anterior + (if    int(length(seq-tipo-etiqueta.char-1)) <> 0
 *                                            then int(length(seq-tipo-etiqueta.char-1)) else 1)
 *            i-p-anterior = i-final.
 * end.
 * else if (i-campo-atu >= 19 and i-campo-atu <= 29) then do:
 *     assign i-inicial    = i-p-anterior + 1
 *            i-final      = i-p-anterior + (if    int(seq-tipo-etiqueta.int-1) <> 0 
 *                                            then int(seq-tipo-etiqueta.int-1) else 1)
 *            i-p-anterior = i-final.
 * end.
 * else
 *     assign i-inicial    = if i-campo-atu <> 18 then (i-p-anterior + 1) else i-p-anterior
 *            i-final      = i-p-anterior + int(substring({c-lista 04 i-campo-atu},28, 4))
 *            i-p-anterior = i-final.*/
