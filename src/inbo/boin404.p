/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN404 2.00.00.013 } /*** "010013" 17/06/2025 16:40:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin404 MUT}
&ENDIF


/*
**  BOIN404.P
**
**  saldo-terc - Saldos dos Materiais em Consigna»’o ou Beneficiamento
**
**  Ultima altera»’o : 14/03/2000 - Hoff.
*/
 
&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.001
&scoped-define FIRST-TABLE-IN-QUERY saldo-terc
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME saldo-terc

/***************** Embalagem *******************************/

def var c-it-codigo like item.it-codigo no-undo.  

define temp-table tt-saldo-terc no-undo
   field cod-emitente like saldo-terc.cod-emitente
   field nro-docto    like saldo-terc.nro-docto
   field serie-docto  like saldo-terc.serie-docto
   field cod-estabel  like saldo-terc.cod-estabel
   field quantidade   like saldo-terc.quantidade. 

/***********************************************************/

 
{include/boini.i}
 
def temp-table tt-saldo-terc-2 like saldo-terc.
{inbo/boin404.i RowObject}
{inbo/boin176.i5 tt-item-terc}  /* Definicao tt-item-terc, igual a saldo-terc */
 
DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.
 
procedure setConstraint1:
 
end procedure.

procedure setConstraint2:
  define input parameter pit-codigo like item.it-codigo no-undo.

    assign c-it-codigo = pit-codigo.
 
end procedure.
 
procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock INDEXED-REPOSITION.
        when 2 then
            open query {&query-name} for each {&TABLE-NAME} where {&TABLE-NAME}.it-codigo = c-it-codigo no-lock INDEXED-REPOSITION. 
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.
 
{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
{include/bosetcur.i}
{include/bogetcur.i}
{include/bosersen.i}
{include/boprebro.i}
{include/boexecre.i}
{include/boexeupt.i}
{include/boexedel.i}
{include/bovalupt.i}
{include/bovaldel.i}
 
procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
 
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure findDocumento:
    /*
    **  Procura pelo indice, caso nao ache,
    **  retorna mensagem de erro padrao do EMS.
    */
    run startMethod ("find").
    def input parameter c-serie-docto as char  no-undo.
    def input parameter c-nro-docto as char    no-undo.
    def input parameter i-cod-emitente as inte no-undo.
    def input parameter c-nat-operacao as char no-undo.
    def input parameter c-it-codigo as char    no-undo.
    def input parameter c-cod-refer as char    no-undo.
    def input parameter i-sequencia as inte    no-undo.
    def output parameter c-return as char      no-undo.
 
    find saldo-terc where
        saldo-terc.serie-docto      = c-serie-docto
        and saldo-terc.nro-docto    = c-nro-docto
        and saldo-terc.cod-emitente = i-cod-emitente
        and saldo-terc.nat-operacao = c-nat-operacao
        and saldo-terc.it-codigo    = c-it-codigo
        and saldo-terc.cod-refer    = c-cod-refer
        and saldo-terc.sequencia    = i-sequencia
        no-lock no-error.
    if not avail {&TABLE-NAME} then do:
        {utp/ut-table.i movind {&TABLE-NAME} 1}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input return-value).
        assign c-return = return-value.
    end.
    else do:
       run setCurrent.
    end.
    run endMethod ("find").
end procedure.
 
procedure validateFields:
    /*
    **  Valida Fields
    */
    find first rowObject
        no-lock no-error.
 
    run startMethod ("validateFields").
    if rowObject.cod-depos = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-depos 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-emitente = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-emitente 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-estabel = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-estabel 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.cod-refer = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} cod-refer 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.it-codigo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} it-codigo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.lote = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} lote 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nat-operacao = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nat-operacao 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nr-ord-produ = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nr-ord-prod 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.nro-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} nro-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.qtd-ini = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} qtd-ini 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.quantidade = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} quantidade 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.sequencia = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} sequencia 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.serie-docto = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} serie-docto 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tipo = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tipo 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.tipo-sal-terc = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} tipo-sal-terc 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor[03] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-icm[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-icm 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-icm[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-icm 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-ipi[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-ipi 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-ipi[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-ipi 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-mob[01] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-mob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-mob[02] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-mob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.valor-mob[03] = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} valor-mob 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-icm-cmi = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-icm-cmi 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    if rowObject.vl-ipi-cmi = ? then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-field.i movind {&TABLE-NAME} vl-ipi-cmi 1}
        run utp/ut-msgs.p (input "msg",
                           input 265,
                           input return-value).
        create tt-bo-erro.
        assign tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 265
               tt-bo-erro.mensagem     = return-value.
    end.
 
    run endMethod ("validateFields").
 
end procedure.
 
procedure validateCreate:
    /*
    **  Valida cria»’o da tabela/duplicidade de registro.
    */
    def input  parameter table for RowObject.
    def output parameter table for tt-bo-erro.
    def output parameter r-chave as rowid.
 
    run initializeValidate.
    run startMethod ("validateCreate").
 
    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
 
    run validateFields.
 
    find first tt-bo-erro
        no-error.
    if not available tt-bo-erro then do:
        find saldo-terc where
            saldo-terc.serie-docto = rowObject.serie-docto
        and saldo-terc.nro-docto = rowObject.nro-docto
        and saldo-terc.cod-emitente = rowObject.cod-emitente
        and saldo-terc.nat-operacao = rowObject.nat-operacao
        and saldo-terc.it-codigo = rowObject.it-codigo
        and saldo-terc.cod-refer = rowObject.cod-refer
        and saldo-terc.sequencia = rowObject.sequencia
            no-lock no-error.
        if avail saldo-terc then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 8,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 8
                   tt-bo-erro.mensagem     = return-value.
        end.
        else do:
             run executeCreate.
             assign r-chave = to-rowid(return-value).
        end.
    end.
 
    run endMethod ("validateCreate").
end procedure.
 
procedure getCharField:
    define input  parameter c-field as char no-undo.
    define output parameter c-value as char no-undo.
 
    case c-field:
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        when "check-sum" then c-value = RowObject.check-sum.
        when "cod-depos" then c-value = RowObject.cod-depos.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "cod-localiz" then c-value = RowObject.cod-localiz.
        when "cod-refer" then c-value = RowObject.cod-refer.
        when "it-codigo" then c-value = RowObject.it-codigo.
        when "lote" then c-value = RowObject.lote.
        when "nat-operacao" then c-value = RowObject.nat-operacao.
        when "nro-docto" then c-value = RowObject.nro-docto.
        when "serie-docto" then c-value = RowObject.serie-docto.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char    no-undo.
    define output parameter c-value as decimal no-undo.
 
    case c-field:
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "desp-cons" then c-value = RowObject.desp-cons.
        when "qt-aloca-trans" then c-value = RowObject.qt-aloca-trans.
        when "qtd-ini" then c-value = RowObject.qtd-ini.
        when "quantidade" then c-value = RowObject.quantidade.
        when "sald-ini-mat" then c-value = RowObject.sald-ini-mat.
        when "sald-ini-mob" then c-value = RowObject.sald-ini-mob.
        when "valor[1]" then c-value = RowObject.valor[1].
        when "valor[2]" then c-value = RowObject.valor[2].
        when "valor[3]" then c-value = RowObject.valor[3].
        when "valor-ggf-m[1]" then c-value = RowObject.valor-ggf-m[1].
        when "valor-ggf-m[2]" then c-value = RowObject.valor-ggf-m[2].
        when "valor-ggf-m[3]" then c-value = RowObject.valor-ggf-m[3].
        when "valor-ggf-o[1]" then c-value = RowObject.valor-ggf-o[1].
        when "valor-ggf-o[2]" then c-value = RowObject.valor-ggf-o[2].
        when "valor-ggf-o[3]" then c-value = RowObject.valor-ggf-o[3].
        when "valor-ggf-p[1]" then c-value = RowObject.valor-ggf-p[1].
        when "valor-ggf-p[2]" then c-value = RowObject.valor-ggf-p[2].
        when "valor-ggf-p[3]" then c-value = RowObject.valor-ggf-p[3].
        when "valor-icm[1]" then c-value = RowObject.valor-icm[1].
        when "valor-icm[2]" then c-value = RowObject.valor-icm[2].
        when "valor-ipi[1]" then c-value = RowObject.valor-ipi[1].
        when "valor-ipi[2]" then c-value = RowObject.valor-ipi[2].
        when "valor-mat-m[1]" then c-value = RowObject.valor-mat-m[1].
        when "valor-mat-m[2]" then c-value = RowObject.valor-mat-m[2].
        when "valor-mat-m[3]" then c-value = RowObject.valor-mat-m[3].
        when "valor-mat-o[1]" then c-value = RowObject.valor-mat-o[1].
        when "valor-mat-o[2]" then c-value = RowObject.valor-mat-o[2].
        when "valor-mat-o[3]" then c-value = RowObject.valor-mat-o[3].
        when "valor-mat-p[1]" then c-value = RowObject.valor-mat-p[1].
        when "valor-mat-p[2]" then c-value = RowObject.valor-mat-p[2].
        when "valor-mat-p[3]" then c-value = RowObject.valor-mat-p[3].
        when "valor-mob[1]" then c-value = RowObject.valor-mob[1].
        when "valor-mob[2]" then c-value = RowObject.valor-mob[2].
        when "valor-mob[3]" then c-value = RowObject.valor-mob[3].
        when "valor-mob-m[1]" then c-value = RowObject.valor-mob-m[1].
        when "valor-mob-m[2]" then c-value = RowObject.valor-mob-m[2].
        when "valor-mob-m[3]" then c-value = RowObject.valor-mob-m[3].
        when "valor-mob-o[1]" then c-value = RowObject.valor-mob-o[1].
        when "valor-mob-o[2]" then c-value = RowObject.valor-mob-o[2].
        when "valor-mob-o[3]" then c-value = RowObject.valor-mob-o[3].
        when "valor-mob-p[1]" then c-value = RowObject.valor-mob-p[1].
        when "valor-mob-p[2]" then c-value = RowObject.valor-mob-p[2].
        when "valor-mob-p[3]" then c-value = RowObject.valor-mob-p[3].
        when "vl-icm-cmi" then c-value = RowObject.vl-icm-cmi.
        when "vl-ipi-cmi" then c-value = RowObject.vl-ipi-cmi.
        when "vl-saldo-mat" then c-value = RowObject.vl-saldo-mat.
        when "vl-saldo-mob" then c-value = RowObject.vl-saldo-mob.
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char    no-undo.
    define output parameter c-value as integer no-undo.
 
    case c-field:
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        when "nr-ord-prod" then c-value = RowObject.nr-ord-produ.
        when "sequencia" then c-value = RowObject.sequencia.
        when "tipo-sal-terc" then c-value = RowObject.tipo-sal-terc.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char no-undo.
    define output parameter c-value as date no-undo.
 
    case c-field:
        when "data-1" then c-value = RowObject.data-1.
        when "data-2" then c-value = RowObject.data-2.
        when "dt-retorno" then c-value = RowObject.dt-retorno.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char    no-undo.
    define output parameter c-value as logical no-undo.
 
    case c-field:
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        when "tipo" then c-value = RowObject.tipo.
        otherwise return error.
    end case.
end procedure.
 
procedure CalculaSaldoTercItem:

    define input        parameter p-it-codigo as char    no-undo.
    define input-output parameter de-saldo    as decimal no-undo.

    for each saldo-terc fields(it-codigo quantidade)
           where saldo-terc.it-codigo = item.it-codigo no-lock,
        each deposito fields(cod-depos alocado)
           where deposito.cod-depos = saldo-terc.cod-depos
             and deposito.alocado no-lock:
        assign de-saldo = de-saldo + saldo-terc.quantidade.
    end.
end procedure.

/**************** EMBALAGEM ********************************************/

procedure saldoTerc:     
    DEF INPUT  PARAM c-it-codigo like item.it-codigo no-undo.
    DEF OUTPUT PARAM TABLE FOR tt-saldo-terc.

    for each tt-saldo-terc:
        delete tt-saldo-terc.
    end.

    for each saldo-terc fields(it-codigo cod-emitente nro-docto
                               serie-docto cod-estabel quantidade)
        where saldo-terc.it-codigo = c-it-codigo no-lock:
        create tt-saldo-terc.
        assign tt-saldo-terc.cod-emitente = saldo-terc.cod-emitente
               tt-saldo-terc.nro-docto    = saldo-terc.nro-docto
               tt-saldo-terc.serie-docto  = saldo-terc.serie-docto
               tt-saldo-terc.cod-estabel  = saldo-terc.cod-estabel
               tt-saldo-terc.quantidade   = saldo-terc.quantidade.
    end.        

end procedure.


procedure validadettItemTerc:     

    def input param pc-serie-docto  like saldo-terc.serie-docto          no-undo.
    def input param pc-nro-docto    like saldo-terc.nro-docto            no-undo.
    def input param pc-nat-operacao like saldo-terc.nat-operacao         no-undo.
    def input param pi-cod-emitente like saldo-terc.cod-emitente         no-undo.
    def input param pc-it-codigo    like saldo-terc.it-codigo            no-undo.
    def input param pi-sequencia    like saldo-terc.sequencia            no-undo.
    def input param pd-qtd          like saldo-terc.quantidade           no-undo.
    def input param pc-nat-oper-ret like saldo-terc.nat-operacao         no-undo.
    def output param table for tt-item-terc.
    def output param table for tt-saldo-terc-2.
    def output param table for tt-bo-erro.

    DEF VAR lDevSimbConsig              AS LOGICAL                       NO-UNDO.

    for each tt-item-terc:
        delete tt-item-terc.
    end.

    for each tt-bo-erro:
        delete tt-bo-erro.
    end.
    
    if  pi-sequencia <> ? then do:
        if not can-find(first saldo-terc 
                        where saldo-terc.serie-docto  = pc-serie-docto  
                          and saldo-terc.nro-docto    = pc-nro-docto    
                          and saldo-terc.nat-operacao = pc-nat-operacao 
                          AND saldo-terc.cod-emitente = pi-cod-emitente
                          and saldo-terc.it-codigo    = pc-it-codigo                    
                          and saldo-terc.sequencia    = pi-sequencia) then do:
            assign i-seq-erro = i-seq-erro + 1.
            {utp/ut-table.i movind {&TABLE-NAME} 1}
            run utp/ut-msgs.p (input "msg",
                               input 2,
                               input return-value).
            create tt-bo-erro.
            assign tt-bo-erro.i-sequen     = i-seq-erro
                   tt-bo-erro.cd-erro      = 2
                   tt-bo-erro.mensagem     = return-value.
            return "NOK":U.        
        end.
    end.
    else do:
        if  not can-find (saldo-terc 
                          where saldo-terc.serie-docto  = pc-serie-docto  
                            and saldo-terc.nro-docto    = pc-nro-docto    
                            and saldo-terc.nat-operacao = pc-nat-operacao 
                            AND saldo-terc.cod-emitente = pi-cod-emitente
                            and saldo-terc.it-codigo    = pc-it-codigo ) then do:
            if  can-find (first saldo-terc 
                          where saldo-terc.serie-docto  = pc-serie-docto  
                            and saldo-terc.nro-docto    = pc-nro-docto    
                            and saldo-terc.nat-operacao = pc-nat-operacao 
                            AND saldo-terc.cod-emitente = pi-cod-emitente
                            and saldo-terc.it-codigo    = pc-it-codigo ) then do:
                assign i-seq-erro = i-seq-erro + 1.
                run utp/ut-msgs.p (input "msg",
                                   input 27905,
                                   input "").
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 27905
                       tt-bo-erro.mensagem     = return-value.
                return "NOK":U.
            end.
            else do:
                assign i-seq-erro = i-seq-erro + 1.
                {utp/ut-table.i movind {&TABLE-NAME} 1}
                run utp/ut-msgs.p (input "msg",
                                   input 2,
                                   input return-value).
                create tt-bo-erro.
                assign tt-bo-erro.i-sequen     = i-seq-erro
                       tt-bo-erro.cd-erro      = 2
                       tt-bo-erro.mensagem     = return-value.
                return "NOK":U.        
            end.
        end.
    end.
    
    if  pi-sequencia <> ? then
        find first saldo-terc 
             where saldo-terc.serie-docto  = pc-serie-docto  
               and saldo-terc.nro-docto    = pc-nro-docto    
               and saldo-terc.nat-operacao = pc-nat-operacao 
               and saldo-terc.it-codigo    = pc-it-codigo                    
               AND saldo-terc.cod-emitente = pi-cod-emitente
               and saldo-terc.sequencia    = pi-sequencia no-lock no-error.
    else 
        find first saldo-terc 
             where saldo-terc.serie-docto  = pc-serie-docto  
               and saldo-terc.nro-docto    = pc-nro-docto    
               and saldo-terc.nat-operacao = pc-nat-operacao 
               AND saldo-terc.cod-emitente = pi-cod-emitente
               and saldo-terc.it-codigo    = pc-it-codigo no-lock no-error.

    if  avail saldo-terc then do:
        
        
        FIND FIRST natur-oper NO-LOCK
             WHERE natur-oper.nat-operacao = pc-nat-operacao NO-ERROR.
        
        IF  AVAIL natur-oper 
        AND natur-oper.terceiros 
        AND natur-oper.tp-oper-terc = 4  /* Faturamento de Consigna‡Æo */
        AND {cdp/cd0066.i2 saldo-terc.cod-estabel}
        THEN DO:
            
            FOR EACH componente 
                FIELDS( quantidade preco-total[1] ) NO-LOCK
                OF saldo-terc:
                
                IF  componente.quantidade = 0 AND componente.preco-total[1] = 0 THEN DO:
                    FIND FIRST natur-oper NO-LOCK
                         WHERE natur-oper.nat-operacao = componente.nat-operacao NO-ERROR.
                    IF  AVAIL natur-oper THEN DO:
                        ASSIGN lDevSimbConsig = {cdp/cd0066.i saldo-terc.cod-estabel natur-oper}
                        
                        IF  NOT lDevSimbConsig THEN DO:
                            ASSIGN i-seq-erro = i-seq-erro + 1.
                            RUN utp/ut-msgs.p ("msg", 2, "").
                            
                            CREATE tt-bo-erro.
                            ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
                                   tt-bo-erro.cd-erro      = 2
                                   tt-bo-erro.mensagem     = RETURN-VALUE.
                            RETURN "NOK":U. 
                        END.
                    END.
                END.
            END.
        END.

        create tt-item-terc.
        assign tt-item-terc.rw-saldo-terc = rowid(saldo-terc)
               tt-item-terc.quantidade    = pd-qtd
               tt-item-terc.preco-total   = saldo-terc.valor[1]
               tt-item-terc.desconto      = saldo-terc.dec-2
               tt-item-terc.cod-depos     = saldo-terc.cod-depos
               tt-item-terc.nr-ord-prod   = saldo-terc.nr-ord-produ
               tt-item-terc.nat-of        = IF natur-oper.nat-comp <> "" THEN natur-oper.nat-comp ELSE pc-nat-oper-ret.
        create tt-saldo-terc-2.
        assign tt-saldo-terc-2.cod-emitente  = saldo-terc.cod-emitente
               tt-saldo-terc-2.serie-docto   = pc-serie-docto
               tt-saldo-terc-2.nro-docto     = pc-nro-docto
               tt-saldo-terc-2.nat-operacao  = pc-nat-operacao
               tt-saldo-terc-2.sequencia     = saldo-terc.sequencia
               tt-saldo-terc-2.it-codigo     = pc-it-codigo
               tt-saldo-terc-2.cod-refer     = saldo-terc.cod-refer.
    end.
    
    return "OK":U.
end procedure.

PROCEDURE updateFifoDevolucaoSimbolica:
/*------------------------------------------------------------------------------
  Purpose   :
  Parameters:
  Notes     : Atualiza o saldo em faturamento e faturado do componente de 
              devolu‡Æo simb¢lica.
------------------------------------------------------------------------------*/

    DEF INPUT PARAM l-digita-confirma-nf  AS LOG FORM "Digita/Confirma"     NO-UNDO.
    DEF INPUT PARAM l-atualiz-desatual-nf AS LOG FORM "Atualiza/Desatuaiza" NO-UNDO.
    DEF INPUT PARAM rw-saldo-terc         AS ROWID                          NO-UNDO.
    DEF INPUT PARAM de-quantidade         AS DEC                            NO-UNDO.

    DEF VAR de-qtd-devol-simbol           AS DEC NO-UNDO FORMAT '999999999.9999'.
    DEF VAR de-qtd-afatur-consig          AS DEC NO-UNDO FORMAT '999999999.9999'.
    DEF VAR de-qtd-fatur-consig           AS DEC NO-UNDO FORMAT '999999999.9999'.

    &IF "{&mguni_version}" >= "2.08" &THEN
     &GLOBAL-DEFINE qtdDevolSimbol    componente.qtd-devol-simbol
     &GLOBAL-DEFINE qtdAFaturConsig   componente.qtd-afatur-consig
     &GLOBAL-DEFINE qtdFaturConsig    componente.qtd-fatur-consig
     &GLOBAL-DEFINE idiTipDevolConsig componente.idi-tip-devol-consig
    &ELSE
     &GLOBAL-DEFINE qtdDevolSimbol    DEC(SUBSTR(componente.char-1, 40,14))
     &GLOBAL-DEFINE qtdAFaturConsig   DEC(SUBSTR(componente.char-1, 54,14))
     &GLOBAL-DEFINE qtdFaturConsig    DEC(SUBSTR(componente.char-1, 68,14))
     &GLOBAL-DEFINE idiTipDevolConsig INT(SUBSTR(componente.char-1, 82, 1))
    &ENDIF

    DO  TRANS ON ERROR UNDO, LEAVE:

        FIND FIRST saldo-terc NO-LOCK
             WHERE ROWID(saldo-terc) = rw-saldo-terc NO-ERROR.

        FIND FIRST componente NO-LOCK
             WHERE componente.cod-emitente   = saldo-terc.cod-emitente
               AND componente.nro-comp       = saldo-terc.nro-docto
               AND componente.serie-comp     = saldo-terc.serie-docto
               AND componente.nat-comp       = saldo-terc.nat-operacao
               AND componente.seq-comp       = saldo-terc.sequencia
               AND componente.quantidade     = 0
               AND componente.preco-total[1] = 0 NO-ERROR.

        IF  NOT AVAIL componente THEN RETURN.

        FOR EACH  componente EXCLUSIVE-LOCK
            WHERE componente.cod-emitente   = saldo-terc.cod-emitente
              AND componente.nro-comp       = saldo-terc.nro-docto
              AND componente.serie-comp     = saldo-terc.serie-docto
              AND componente.nat-comp       = saldo-terc.nat-operacao
              AND componente.seq-comp       = saldo-terc.sequencia
              AND componente.quantidade     = 0
              AND componente.preco-total[1] = 0
            BY componente.dt-retorno:

            IF {&qtdDevolSimbol} = 0 THEN NEXT.

            IF  l-digita-confirma-nf  AND l-atualiz-desatual-nf
            AND {&qtdAFaturConsig} + {&qtdFaturConsig} >= {&qtdDevolSimbol} THEN NEXT.

            IF  l-digita-confirma-nf  AND NOT l-atualiz-desatual-nf
            AND {&qtdAFaturConsig} = 0 THEN NEXT.

            IF  NOT l-digita-confirma-nf  AND l-atualiz-desatual-nf
            AND {&qtdAFaturConsig} = 0 THEN NEXT.

            IF  l-digita-confirma-nf THEN DO:
                IF  l-atualiz-desatual-nf THEN DO:
                    ASSIGN de-qtd-afatur-consig  = {&qtdAFaturConsig}
                           de-qtd-devol-simbol   = {&qtdDevolSimbol} - {&qtdFaturConsig}

                           &IF "{&mguni_version}" >= "2.08" &THEN
                            componente.qtd-afatur-consig = IF   de-quantidade > de-qtd-devol-simbol
                                                           OR   de-quantidade > de-qtd-devol-simbol - {&qtdAFaturConsig}
                                                           THEN de-qtd-devol-simbol
                                                           ELSE {&qtdAFaturConsig} + de-quantidade
                           &ELSE
                            OVERLAY(componente.char-1, 54,14) = IF   de-quantidade > de-qtd-devol-simbol
                                                                OR   de-quantidade > de-qtd-devol-simbol - {&qtdAFaturConsig}
                                                                THEN STRING(de-qtd-devol-simbol,'>>>>>>>>9.9999')
                                                                ELSE STRING({&qtdAFaturConsig} + de-quantidade ,'>>>>>>>>9.9999')
                           &ENDIF

                           de-quantidade = IF   de-quantidade > de-qtd-devol-simbol
                                           THEN de-quantidade - de-qtd-devol-simbol
                                           ELSE 
                                                IF   de-quantidade > {&qtdDevolSimbol} - de-qtd-afatur-consig - {&qtdFaturConsig}
                                                THEN de-quantidade - ({&qtdDevolSimbol} - de-qtd-afatur-consig - {&qtdFaturConsig})
                                                ELSE 0.
                END.
                ELSE DO: 
                    ASSIGN de-qtd-afatur-consig  = {&qtdAFaturConsig}

                           &IF "{&mguni_version}" >= "2.08" &THEN
                            componente.qtd-afatur-consig = IF   de-quantidade > {&qtdAFaturConsig}
                                                           THEN 0
                                                           ELSE {&qtdAFaturConsig} - de-quantidade
                           &ELSE
                            OVERLAY(componente.char-1, 54,14) = IF   de-quantidade > {&qtdAFaturConsig}
                                                                THEN STRING(0,'>>>>>>>>9.9999')
                                                                ELSE STRING({&qtdAFaturConsig} - de-quantidade,'>>>>>>>>9.9999')
                           &ENDIF

                           de-quantidade = IF   de-quantidade > de-qtd-afatur-consig
                                           THEN de-quantidade - de-qtd-afatur-consig
                                           ELSE 0.
                END.
            END.
            ELSE DO:
                IF  l-atualiz-desatual-nf THEN DO:
                    ASSIGN de-qtd-fatur-consig  = {&qtdFaturConsig}
                           &IF "{&mguni_version}" >= "2.08" &THEN
                            componente.qtd-fatur-consig = IF   de-quantidade > {&qtdAFaturConsig}
                                                          OR   de-quantidade > {&qtdAFaturConsig} - {&qtdFaturConsig}
                                                          THEN {&qtdAFaturConsig} + {&qtdFaturConsig}
                                                          ELSE {&qtdFaturConsig} + de-quantidade
                           &ELSE
                            OVERLAY(componente.char-1, 68,14) = IF   de-quantidade > {&qtdAFaturConsig}
                                                                OR   de-quantidade > {&qtdAFaturConsig} - {&qtdFaturConsig}
                                                                THEN STRING(( {&qtdAFaturConsig} + {&qtdFaturConsig} ),'>>>>>>>>9.9999')
                                                                ELSE STRING({&qtdFaturConsig} + de-quantidade,'>>>>>>>>9.9999')
                           &ENDIF

                           de-qtd-afatur-consig = {&qtdAFaturConsig}

                           &IF "{&mguni_version}" >= "2.08" &THEN
                            componente.qtd-afatur-consig = IF   de-quantidade > {&qtdAFaturConsig}
                                                           OR   de-quantidade > {&qtdAFaturConsig} - de-qtd-fatur-consig
                                                           THEN 0
                                                           ELSE {&qtdAFaturConsig} - de-quantidade
                           &ELSE
                            OVERLAY(componente.char-1, 54,14) = IF   de-quantidade > {&qtdAFaturConsig}
                                                                OR   de-quantidade > {&qtdAFaturConsig} - de-qtd-fatur-consig
                                                                THEN STRING(0,'>>>>>>>>9.9999')
                                                                ELSE STRING({&qtdAFaturConsig} - de-quantidade,'>>>>>>>>9.9999')
                           &ENDIF

                           de-quantidade    = IF   de-quantidade > de-qtd-afatur-consig
                                              THEN de-quantidade - de-qtd-afatur-consig
                                              ELSE
                                                  IF   de-quantidade > de-qtd-afatur-consig - de-qtd-fatur-consig
                                                  THEN de-quantidade - (de-qtd-afatur-consig - de-qtd-fatur-consig)
                                                  ELSE 0
                           .
                END.
                ELSE DO:
                    ASSIGN de-qtd-fatur-consig  = {&qtdFaturConsig}

                           &IF "{&mguni_version}" >= "2.08" &THEN
                            componente.qtd-fatur-consig = IF   de-quantidade > {&qtdFaturConsig}
                                                          THEN 0
                                                          ELSE {&qtdFaturConsig} - de-quantidade
                           &ELSE
                           OVERLAY(componente.char-1, 68,14) = IF   de-quantidade > {&qtdFaturConsig}
                                                               THEN STRING(0,'>>>>>>>>9.9999')
                                                               ELSE STRING({&qtdFaturConsig} - de-quantidade,'>>>>>>>>9.9999')
                           &ENDIF

                           de-qtd-afatur-consig = {&qtdAFaturConsig}

                           &IF "{&mguni_version}" >= "2.08" &THEN
                            componente.qtd-afatur-consig = IF   de-quantidade > de-qtd-fatur-consig
                                                           THEN {&qtdAFaturConsig} + de-qtd-fatur-consig
                                                           ELSE {&qtdAFaturConsig} + de-quantidade
                           &ELSE
                           OVERLAY(componente.char-1, 54,14) = IF   de-quantidade > de-qtd-fatur-consig
                                                               THEN STRING({&qtdAFaturConsig} + de-qtd-fatur-consig,'>>>>>>>>9.9999')
                                                               ELSE STRING({&qtdAFaturConsig} + de-quantidade,'>>>>>>>>9.9999')
                           &ENDIF

                           de-quantidade    = IF   de-quantidade > de-qtd-fatur-consig
                                              THEN de-quantidade - de-qtd-fatur-consig
                                              ELSE 0
                           .
                END.
            END.

            IF  de-quantidade = 0 THEN LEAVE.

        END.
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE validaFaturamentoSimbolico:
/*------------------------------------------------------------------------------
  Purpose   :
  Parameters:
  Notes     : Valida‡Æo .
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM rwSaldoTerc         AS ROWID                     NO-UNDO.
    DEF OUTPUT PARAM deQuantidade        AS DEC                       NO-UNDO.

    &IF "{&mguni_version}" >= "2.08" &THEN
     &GLOBAL-DEFINE qtdDevolSimbol    componente.qtd-devol-simbol
     &GLOBAL-DEFINE qtdAFaturConsig   componente.qtd-afatur-consig
     &GLOBAL-DEFINE qtdFaturConsig    componente.qtd-fatur-consig
    &ELSE
     &GLOBAL-DEFINE qtdDevolSimbol    DEC(SUBSTR(componente.char-1, 40,14))
     &GLOBAL-DEFINE qtdAFaturConsig   DEC(SUBSTR(componente.char-1, 54,14))
     &GLOBAL-DEFINE qtdFaturConsig    DEC(SUBSTR(componente.char-1, 68,14))
    &ENDIF

    FIND FIRST saldo-terc NO-LOCK
        WHERE ROWID(saldo-terc) = rwSaldoTerc NO-ERROR.

    IF  NOT CAN-FIND(FIRST componente NO-LOCK
                     WHERE componente.cod-emitente   = saldo-terc.cod-emitente
                       AND componente.nro-comp       = saldo-terc.nro-docto
                       AND componente.serie-comp     = saldo-terc.serie-docto
                       AND componente.nat-comp       = saldo-terc.nat-operacao
                       AND componente.seq-comp       = saldo-terc.sequencia
                       AND componente.quantidade     = 0
                       AND componente.preco-total[1] = 0) THEN
        RETURN "OK":U.

    FOR EACH  componente EXCLUSIVE-LOCK
        WHERE componente.cod-emitente   = saldo-terc.cod-emitente
          AND componente.nro-comp       = saldo-terc.nro-docto
          AND componente.serie-comp     = saldo-terc.serie-docto
          AND componente.nat-comp       = saldo-terc.nat-operacao
          AND componente.seq-comp       = saldo-terc.sequencia
          AND componente.quantidade     = 0
          AND componente.preco-total[1] = 0
           BY componente.dt-retorno:

        ASSIGN deQuantidade = deQuantidade + ({&qtdDevolSimbol}  -
                                              {&qtdAFaturConsig} -
                                              {&qtdFaturConsig}).
    END.

    RETURN "OK":U.
END PROCEDURE.
