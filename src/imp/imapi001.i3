/**
** IMAPI001.I3 - Pesquisa Fornecedor PadrÆo e Tabela de Pre‡o PadrÆo
**
*/

procedure getFornecTabela:

    /*
    ** Busca Fornecedor PadrÆo e Tabela de Pre‡o PadrÆo
    */
    
    def input  parameter p-cod-desp       like desp-imp.cod-desp        no-undo.
    def input  parameter p-cod-itiner     like itiner.cod-itiner        no-undo.
    def input  parameter p-cod-incoterm   like inco-cx.cod-incoterm     no-undo.
    def output parameter p-fornec-desp    like desp-itiner.cod-emitente no-undo.
    def output parameter p-nr-tab         like desp-tb-pr-cex.nr-tab    no-undo.
    def output parameter p-desp-vinc      as logical                    no-undo.
    def output parameter table for tt-desp-vinc.
    
    
    define var l-desp-vinc as log no-undo.
    define variable i-cond-pag as integer no-undo.
    
    
    find first desp-itiner
         where desp-itiner.cod-desp   = p-cod-desp
           and desp-itiner.cod-itiner = p-cod-itiner no-lock no-error.
       
    if avail desp-itiner then
       assign p-fornec-desp = desp-itiner.cod-emitente.
    if p-fornec-desp = 0 then do:
       find first desp-imp
            where desp-imp.cod-desp = p-cod-desp no-lock no-error.
              
       if avail desp-imp then
          assign p-fornec-desp = desp-imp.cod-emitente.
       else
          assign p-fornec-desp = 0.
    end.
    
    if p-fornec-desp = ? then
       assign p-fornec-desp = 0.
    
    /* Retorna tabela de Pre‡o PadrÆo */
    {cxbo/bocx085.i6 p-cod-itiner p-cod-incoterm p-fornec-desp p-cod-desp}
            
    /* Verifica se a despesa possui formula com despesas complementares */
    /* e quais sÆo as despesas complementares                           */
    
    if avail desp-tb-pr-cex then
       assign p-nr-tab   = desp-tb-pr-cex.nr-tab
              i-cond-pag = desp-tb-pr-cex.cod-cond-pag.
    else    
        assign p-nr-tab   = "":U
               i-cond-pag = 0.
               
    run getFormulaDesp (input  p-cod-desp,
                        input  p-nr-tab,
                        input  i-cond-pag,
                        input  p-fornec-desp,
                        input  p-cod-itiner,
                        input  p-cod-incoterm,
                        output l-desp-vinc,
                        output table tt-desp-vinc).
                        
    /****/
    
    assign p-desp-vinc = l-desp-vinc.
    
    release tb-pr-cex.
    release desp-tb-pr-cex.
    
end procedure.

&if '{&bf_mat_versao_ems}' >= '2.062' &then
    {imp/imapi001.i4} /* Verifica se a Despesa possui F¢rmula com Despesas Complementares - getFormulaDesp */
&endif

/* IMAPI001.I3 */
