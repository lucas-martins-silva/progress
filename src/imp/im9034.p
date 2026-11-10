/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9034 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM9034 MIM}
&ENDIF

/*******************************************************************************
**
** IM9034.P - Integraá∆o Importaá∆o x Contratos - Atualiza as informaá‰es de 
**            importaá∆o (Incoterm/Ponto de Controle Base) para as cotaá‰es relacionadas
**            ao contrato em quest∆o.
**
*******************************************************************************/

{include/boerrtab.i} /* include definicao tt-bo-erro */

def input parameter p-numero-ordem   like ordem-compra.numero-ordem no-undo.
def input parameter c-cod-incoterm   like inco-cx.cod-incoterm      no-undo.
def input parameter i-pto-contr-base like pto-contr.cod-pto-contr   no-undo.
def output parameter table for tt-bo-erro.

{cdp/cd4300.i3}  /* include tratamento atributo livre cotacao-item.char-1 */
{ccp/cc9019.i50} /* include tratamento atributo livre cotacao-item.char-1 */

def var h-bocx025  as handle no-undo.
def var h-bocx110  as handle no-undo.
def var c-return   as char   no-undo.
def var i-seq-erro as integer no-undo.

run cxbo/bocx025.p persistent set h-bocx025.
run cxbo/bocx110.p persistent set h-bocx110.

find ordem-compra
    where ordem-compra.numero-ordem = p-numero-ordem no-lock no-error.
if avail ordem-compra then do:

    /* valicacao incoterm */
    run findPK_incoterm in h-bocx025 (input c-cod-incoterm,
                                 output c-return).
    if c-return <> "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-table.i mgcex inco-cx 1}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.
    end.
    
    /* validacao ponto de controle base */
    run findCodigo in h-bocx110 (input i-pto-contr-base,
                                 output c-return).
    if c-return <> "" then do:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Ponto_Controle_Base * L}
        create tt-bo-erro.
        assign tt-bo-erro.parametros = return-value.
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = return-value.    
    end.
    
    if not can-find(first tt-bo-erro) then do:
        find cotacao-item
            where cotacao-item.numero-ordem = ordem-compra.numero-ordem 
              and cotacao-item.cot-aprovada no-lock no-error.
        if avail cotacao-item then do:
            assign i-cod-pto-contr-i50    = i-pto-contr-base
                   c-cod-incoterm-i50     = c-cod-incoterm
                   d-entrega-embarque-i50 = 01/01/0001.
            {ccp/cc9019.i51 "no"}
            {cdp/cd4300.i4 "no" cotacao-item.char-1}
        end.
    end.          
    
end.

delete procedure h-bocx025.
delete procedure h-bocx110.

/* IM9034.P */
