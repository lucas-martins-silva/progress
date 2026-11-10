/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN172J 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin172j MUT}
&ENDIF

/*****************************************************************************/

/* Validaá‰es de Criaá∆o, Alteraá∆o e Exclus∆o da tabela item.               */
/* Foi adiciona a procedure pi-valida-criacao-eai para atender as validaá‰es */
/* que as procedures e trigger n∆o tinham.                                   */
{cdp/cdcfgman.i}
{cdp/cdcfgman.i1}
{inbo/boin172j.i}
{inbo/boin172.i tt-item}
{inbo/boin375.i tt-ref-item}
{bhp/bh9999.i1}

procedure pi-inclusao:
    def input  param table for tt-pi-valida.
    def output param cod-erro-pi-valida as char format "x(500)" no-undo.
    
    find first tt-pi-valida no-lock no-error.
    
    def var l-erro           as logical             no-undo.
    def var c-codigo         like item.it-codigo    no-undo.
     
    assign cod-erro-pi-valida = "".
    find first tt-pi-valida NO-LOCK NO-ERROR.  
    find first param-global NO-LOCK NO-ERROR.
    
    /********[ Validaá‰es da v34in172 ]********/
    if can-find(item where item.it-codigo = tt-pi-valida.it-codigo) then do:     
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "8".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",8".
    end.
    
    if search ("cdp/cd0204y.r") <> ? or 
       search ("cdp/cd0204y.p") <> ? then do:
        run cdp/cd0204y.p (input tt-pi-valida.it-codigo,
                           output c-codigo,
                           output l-erro).
        if l-erro = yes then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "932".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",932".
        end.
    end.
    
    if tt-pi-valida.desc-item = "" then do: 
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "190".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",190".
    end. 
      
    &if defined (bf_man_203) &then 
        if can-find(first dp-item where dp-item.item-dp = tt-pi-valida.it-codigo) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "27187".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",27187".
        end.
    &else   
        if can-find(first cot-item where cot-item.item-destino = tt-pi-valida.it-codigo) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "27187".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",27187".
        end.
    &endif. 
    /********[ Fim das Validaá‰es da v34in172 ]********/
    
    /********[ Validaá‰es da twin172 ]********/ 
    if tt-pi-valida.data-implant > today then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "2566".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",2566".
    end.
    
    if tt-pi-valida.data-liberac < tt-pi-valida.data-implant then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "2565".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",2565".
    end.
       
    /*** Tipo de reporte por item n∆o permite tipo de controle debito direto nem
         outra pol°tica diferente a periodo fixo ou lote econ¢mico ***/         
    if tt-pi-valida.rep-prod = 4 then do:
        if (tt-pi-valida.tipo-contr   =  3   and 
            tt-pi-valida.rep-prod     =  4 ) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "1941".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",1941".
        end.
        if (tt-pi-valida.politica  <>  1     and 
            tt-pi-valida.politica  <>  2) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "1942".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",1942".
        end.
    end.
    
    /*** Folha de especificaá∆o n∆o est† cadastrada para fam°lia desta tt-pi-valida ***/
    if tt-pi-valida.cd-folh-item <> "" then do:
        find first folh-fm-it where folh-fm-it.fm-codigo = tt-pi-valida.fm-codigo    and
                                    folh-fm-it.cd-folha  = tt-pi-valida.cd-folh-item no-lock no-error.
        if not available folh-fm-it then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "2676".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",2676".
        end.
    end.
    
    /*** Verifica se a imagem informada Ç valida. ***/
    if tt-pi-valida.cod-imagem <> "" and
       tt-pi-valida.cod-imagem <> ? then do:
        find first imagem where imagem.cod_imagem = tt-pi-valida.cod-imagem no-lock no-error.
        if not avail imagem then do:
            if cod-erro-pi-valida = "" then
                assign cod-erro-pi-valida = "3154".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",3154".
        end.
    end.
    /*Fim Validaá‰es Triggers*/
    
    find grup-estoque where grup-estoque.ge-codigo = tt-pi-valida.ge-codigo no-lock no-error.
    if not avail grup-estoque then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "4103".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",4103".
    end.
    
    find familia where familia.fm-codigo = tt-pi-valida.fm-codigo no-lock no-error.
    if not avail familia then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "34584".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",34584".
    end.    
    
    if tt-pi-valida.fm-cod-com <> "" then do:
        find fam-comerc where fam-comerc.fm-cod-com = tt-pi-valida.fm-cod-com no-lock no-error.
        if not avail fam-comerc then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "17006".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",17006".
        end.                                          
    end.
    
    find estabelec where estabelec.cod-estabel = tt-pi-valida.cod-estabel no-lock no-error.
    if not avail estabelec then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "4802".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",4802".
    end.
    
    if not can-find (first tab-unidade where tab-unidade.un = tt-pi-valida.un) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "47".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",47".
    end.    
    
    if tt-pi-valida.ind-serv-mat < 1 or
       tt-pi-valida.ind-serv-mat > 2 then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30493".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30493".
    end.
    
    if tt-pi-valida.tipo-contr < 1 or
       tt-pi-valida.tipo-contr > 4 then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30494".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30494".
    end.
    
    /** Item s¢ pode ser de Serviáo quando tipo de 
        controle for DÇbito-Direto **/
    if tt-pi-valida.tipo-contr < 4 and
       tt-pi-valida.ind-serv-mat = 1 then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "27863".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",27863".
    end.
    
    if tt-pi-valida.cod-obsoleto < 1 or
       tt-pi-valida.cod-obsoleto > 4 then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "3662".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",3662".
    end.

    if tt-pi-valida.politica = 5 then do:
        if tt-pi-valida.tipo-con-est <> 4 then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "16535".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",16535".
        end.
    end.
    
    if tt-pi-valida.deposito-pad <> "" then do:
        if not can-find(deposito where deposito.cod-depos = tt-pi-valida.deposito-pad) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "530".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",530".
        end.
    end.
    
    if tt-pi-valida.cd-planejado <> "" then
        if not can-find(planejad where planejad.cd-planejado = tt-pi-valida.cd-planejado) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "167".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",167".
        end.                             
    /*                                                                                               */
    if tt-pi-valida.nr-linha <> 0 then do:
        &if defined (bf_man_linha_estab) &then
            if not can-find(lin-prod where lin-prod.cod-estabel = tt-pi-valida.cod-estabel and
                                           lin-prod.nr-linha    = tt-pi-valida.nr-linha) then do:
        &else
            if not can-find(lin-prod where lin-prod.nr-linha = tt-pi-valida.nr-linha) then do:
        &endif
                if cod-erro-pi-valida = "" then
                    assign cod-erro-pi-valida = "168".
                else
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",168".
            end.
    end.
    
    if tt-pi-valida.contr-plan = 2 then do:
        if not param-global.modulo-pi then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "924".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",924".
        end.
       
        if tt-pi-valida.politica <> 1 and 
           tt-pi-valida.politica <> 2 then do:
           /**** Item de controle de Manutená∆o Industrial inv†lido! ****/  
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "925".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",925".
        end.
    end.
    
    return "ok":u.
end procedure. /* inclusao */




procedure pi-alteracao:
    def input  param table for tt-pi-valida.
    def output param cod-erro-pi-valida as char format "x(500)" no-undo.
    
    find first tt-pi-valida no-lock no-error.
    
    def var l-altera-unidade as log              no-undo.
    def var v-log-adm        as log init yes     no-undo.
    def var v-log-dis        as log init yes     no-undo.
    def var v-log-mnt        as log init yes     no-undo.
    def var v-log-mrp        as log init yes     no-undo.
    def var l-erro           as log              no-undo.
    def var c-codigo         like item.it-codigo no-undo.
    
    &if defined (bf_man_204) &then
        def var l-existe as log    no-undo.
        def var h-cd7010 as handle no-undo.
    
        run cdp/cd7010.p persistent set h-cd7010.
    &endif
    
        
    assign cod-erro-pi-valida = "".
    find first tt-pi-valida NO-LOCK NO-ERROR.
    
    /**********[ Funá∆o para verificar se a unidade de medida pode ser alterada ]**********/
    if can-find (first estrutura                         where estrutura.it-codigo   = tt-pi-valida.it-codigo) or
       can-find (first estrutura   use-index onde-se-usa where estrutura.es-codigo   = tt-pi-valida.it-codigo) or 
       can-find (first alternativo use-index onde-se-usa where alternativo.al-codigo = tt-pi-valida.it-codigo) or 
       can-find (first operacao                          where operacao.it-codigo    = tt-pi-valida.it-codigo and   
                                                               operacao.cod-roteiro  = '')                     or 
       can-find (first oper-item-cons                    where oper-item-cons.it-consumo     = tt-pi-valida.it-codigo) or 
       can-find (first oper-item-cons-pad                where oper-item-cons-pad.it-consumo = tt-pi-valida.it-codigo) or 
       can-find (first estr-modelo                       where estr-modelo.it-codigo  = tt-pi-valida.it-codigo) or 
       can-find (first cotacao-item                      where cotacao-item.it-codigo = tt-pi-valida.it-codigo) or 
       can-find (first item-fornec                       where item-fornec.it-codigo  = tt-pi-valida.it-codigo) or 
       can-find (first ordem-compra use-index item       where ordem-compra.it-codigo = tt-pi-valida.it-codigo) or 
       can-find (first ord-prod     use-index item       where ord-prod.it-codigo     = tt-pi-valida.it-codigo) or 
       can-find (first reservas     use-index data       where reservas.it-codigo     = tt-pi-valida.it-codigo) or 
       can-find (first oper-ord     use-index item       where oper-ord.it-codigo     = tt-pi-valida.it-codigo) or 
       can-find (first consumo      use-index item-conta where consumo.it-codigo      = tt-pi-valida.it-codigo) or 
       can-find (first movto-estoq  use-index item-data  where movto-estoq.it-codigo  = tt-pi-valida.it-codigo) or 
       can-find (first saldo-estoq  use-index item       where saldo-estoq.it-codigo  = tt-pi-valida.it-codigo) or 
       can-find (first movto-mat    use-index onde-usou  where movto-mat.it-codigo    = tt-pi-valida.it-codigo) or 
       can-find (first sl-it-per    use-index item       where sl-it-per.it-codigo    = tt-pi-valida.it-codigo) or 
       can-find (first pr-it-per    use-index codigo     where pr-it-per.it-codigo    = tt-pi-valida.it-codigo) or 
       can-find (first item-doc-est                      where item-doc-est.it-codigo = tt-pi-valida.it-codigo) or 
       can-find (first est-prod     use-index onde-se-usa where est-prod.it-codigo    = tt-pi-valida.it-codigo) then
        assign l-altera-unidade = no.
    
    else do:              
        assign l-altera-unidade = yes.
        run VerificarConfiguracaoMAN (output v-log-adm,
                                      output v-log-dis,
                                      output v-log-mnt,
                                      output v-log-mrp). 
        if v-log-dis then do: 
            run inbo/boin172a.p (input tt-pi-valida.it-codigo,
                                 output l-altera-unidade).
        end.                              
    end.
    
    if not can-find (first tab-unidade where tab-unidade.un = tt-pi-valida.un) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "47".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",47".
    end.    
    
    if search ("cdp/cd0204y.r") <> ? or 
       search ("cdp/cd0204y.p") <> ? then do:
        run cdp/cd0204y.p (input tt-pi-valida.it-codigo,
                           output c-codigo,
                           output l-erro).
        if l-erro = yes then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "932".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",932".
        end.
    end.
    
    if tt-pi-valida.desc-item = "" then do: 
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "190".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",190".
    end. 
    /********[ Fim das Validaá‰es da v34in172 ]********/
    
    /********[ Validaá‰es da twin172 ]********/ 
    if tt-pi-valida.data-implant > today then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "2566".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",2566".
    end.
    
    if tt-pi-valida.data-liberac < tt-pi-valida.data-implant then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "2565".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",2565".
    end.
       
    /*** Tipo de reporte por item n∆o permite tipo de controle debito direto nem
         outra pol°tica diferente a periodo fixo ou lote econ¢mico ***/         
    if tt-pi-valida.rep-prod = 4 then do:
        if (tt-pi-valida.tipo-contr   =  3   and 
            tt-pi-valida.rep-prod     =  4 ) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "1941".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",1941".
        end.
        if (tt-pi-valida.politica  <>  1     and 
            tt-pi-valida.politica  <>  2   ) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "1942".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",1942".
        end.
    end.
    
    /*** Folha de especificaá∆o n∆o est† cadastrada para fam°lia desta tt-pi-valida ***/
    if tt-pi-valida.cd-folh-item <> "" then do:
        find first folh-fm-it where folh-fm-it.fm-codigo = tt-pi-valida.fm-codigo    and
                                    folh-fm-it.cd-folha  = tt-pi-valida.cd-folh-item no-lock no-error.
        if not available folh-fm-it then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "2676".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",2676".
        end.
    end.       
    
    /*** Verifica se a imagem informada Ç valida. ***/
    if tt-pi-valida.cod-imagem <> "" and
       tt-pi-valida.cod-imagem <> ? then do:
        find first imagem where imagem.cod_imagem = tt-pi-valida.cod-imagem no-lock no-error.
        if not avail imagem then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "3154".
           else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",3154".
        end. 
    end.      
    
    find grup-estoque where grup-estoque.ge-codigo = tt-pi-valida.ge-codigo no-lock no-error.
    if not avail grup-estoque then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "4103".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",4103".
    end.
    
    find familia where familia.fm-codigo = tt-pi-valida.fm-codigo no-lock no-error.
    if not avail familia then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "34584".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",34584".
    end.    
    
    if tt-pi-valida.fm-cod-com <> "" then do:
        find fam-comerc where fam-comerc.fm-cod-com = tt-pi-valida.fm-cod-com no-lock no-error.
        if not avail fam-comerc then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "17006".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",17006".
        end.                                          
    end.
    
    find estabelec where estabelec.cod-estabel = tt-pi-valida.cod-estabel no-lock no-error.
        if not avail estabelec then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "4802".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",4802".
        end.    
    
    if tt-pi-valida.ind-serv-mat < 1 or
       tt-pi-valida.ind-serv-mat > 2 then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30493".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30493".
    end.
    
    if tt-pi-valida.tipo-contr < 1 or
       tt-pi-valida.tipo-contr > 4 then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30494".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30494".
    end.
    
    /** Item s¢ pode ser de Serviáo quando tipo de 
        controle for DÇbito-Direto **/
    if tt-pi-valida.tipo-contr < 4 and
       tt-pi-valida.ind-serv-mat = 1 then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "27863".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",27863".
    end.
    
    if tt-pi-valida.cod-obsoleto < 1 or
       tt-pi-valida.cod-obsoleto > 4 then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "3662".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",3662".
    end.
    
    find first param-global NO-LOCK NO-ERROR.

    if tt-pi-valida.politica = 5 then do:
        if tt-pi-valida.tipo-con-est <> 4 then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "16535".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",16535".
        end.
    end.	

    if tt-pi-valida.deposito-pad <> "" then do:
        if not can-find(deposito where deposito.cod-depos = tt-pi-valida.deposito-pad) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "530".
            else 
               assign cod-erro-pi-valida = cod-erro-pi-valida + ",530".
        end.
    end.
    
    if tt-pi-valida.cd-planejado <> "" then
        if not can-find(planejad where planejad.cd-planejado = tt-pi-valida.cd-planejado) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "167".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",167".
        end.     
    
    if tt-pi-valida.nr-linha <> 0 then do:
        &if defined (bf_man_linha_estab) &then
            if not can-find(lin-prod where lin-prod.cod-estabel = tt-pi-valida.cod-estabel and 
                                           lin-prod.nr-linha    = tt-pi-valida.nr-linha) then do:
        &else
            if not can-find(lin-prod where lin-prod.nr-linha = tt-pi-valida.nr-linha) then do:
        &endif   
                if cod-erro-pi-valida = "" then 
                    assign cod-erro-pi-valida = "168".
                else 
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",168".
            end.
    end.
    
    if tt-pi-valida.contr-plan = 2 then do:
        if not param-global.modulo-pi then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "924".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",924".
        end.
       
        if tt-pi-valida.politica <> 1 and 
           tt-pi-valida.politica <> 2 then do:
           /**** Item de controle de Manutená∆o Industrial inv†lido! ****/  
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "925".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",925".
        end.
    end.
    
    &if defined (bf_man_204) &then                                                                   
        if can-find (first item where item.it-codigo = tt-pi-valida.it-codigo) then do:
            if can-find (first item where item.fm-codigo <> tt-pi-valida.fm-codigo) then do:                   
                for each item-uni-estab where item-uni-estab.it-codigo = tt-pi-valida.it-codigo no-lock:
                    run pi-mov-estab in h-cd7010 (input  item-uni-estab.it-codigo,
                                                  input  item-uni-estab.cod-estabel,
                                                  output l-existe).                 
                    if l-existe then do:
                        if not can-find (first fam-uni-estab where fam-uni-estab.fm-codigo   = tt-pi-valida.fm-codigo and
                                                                   fam-uni-estab.cod-estabel = item-uni-estab.cod-estabel) then do:
                            if cod-erro-pi-valida = "" then 
                                assign cod-erro-pi-valida = "26435".
                            else 
                                assign cod-erro-pi-valida = cod-erro-pi-valida + ",26435".
                        end.
                    end.
                end.
            end.
        end.
    &endif
    
    /*** Se o grupo de estoque da tt-pi-valida for alterado n∆o poder∆o existir  ***/
    /*** registros nas tabelas saldo-estoq e movto-estoq para o periodo.         ***/
    if can-find (first item where item.it-codigo =  tt-pi-valida.it-codigo
                              and item.ge-codigo <> tt-pi-valida.ge-codigo) then do:
       
        /*** Grupo de estoque nío pode ser modificado pois ***/
        /*** possui saldo de estoque cadastrado.           ***/
        if can-find (first saldo-estoq use-index item where saldo-estoq.it-codigo = tt-pi-valida.it-codigo and
                                                            saldo-estoq.qtidade-atu <> 0) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "34583".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",34583".
        end.
    
        /*** ParÉmetros de estoque nío cadastrados ***/
        find first param-estoq no-lock no-error. 
        if not avail param-estoq then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "1059".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",1059".
        end.
       
        /*** Grupo de estoque nío pode ser modificado pois item possui ***/
        /*** movimentaªío de estoques para o per≠odo corrente.         ***/
        if can-find (movto-estoq use-index item-data where movto-estoq.it-codigo = tt-pi-valida.it-codigo and
                                                           movto-estoq.dt-trans  > param-estoq.mensal-ate) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "2802".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",2802".
          
        end.
    end.
    
    /*** Verifica se tipo de controle do item pode ser modificado ***/
    if tt-pi-valida.it-codigo <> "" then do:
        if can-find(first item where item.it-codigo  = tt-pi-valida.it-codigo and
                                     item.tipo-contr <> tt-pi-valida.tipo-contr) then do:
          
            /*** ParÉmetros de estoque n∆o cadastrados ***/
            find first param-estoq no-lock no-error. 
            if not avail param-estoq then do:
                if cod-erro-pi-valida = "" then 
                    assign cod-erro-pi-valida = "1059".
                else 
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",1059".
            end.
    
            /*** Item possui movimento de estoque em periodo nío fechado ***/
            if can-find (first movto-estoq where movto-estoq.it-codigo = tt-pi-valida.it-codigo and
                                                 movto-estoq.dt-trans > param-estoq.ult-fech-dia) then do:
                if cod-erro-pi-valida = "" then 
                    assign cod-erro-pi-valida = "2227".
                else 
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",2227".
            end.
    
            /***   Verifica se o Item possui saldo em estoque!   ***/     
            for each saldo-estoq no-lock where saldo-estoq.it-codigo = tt-pi-valida.it-codigo:
                
                if saldo-estoq.qtidade-atu <> 0 or 
                   saldo-estoq.qtidade-ini <> 0 then do:
                    if cod-erro-pi-valida = "" then 
                        assign cod-erro-pi-valida = "2763".
                    else 
                        assign cod-erro-pi-valida = cod-erro-pi-valida + ",2763".
                    
                end.
            end.
        end.
    end.
    
    /*** Lote m£ltiplo n∆o pode ser fracionado ***/
    find first item where item.it-codigo = tt-pi-valida.it-codigo no-lock no-error.
    if avail item then do:
        if (item.lote-multipl <> tt-pi-valida.lote-multipl             or
            item.fraciona     <> tt-pi-valida.fraciona)                and
            item.lote-multipl <> truncate(tt-pi-valida.lote-multipl,0) and
            not tt-pi-valida.fraciona then do:
    
            if cod-erro-pi-valida = "" then
                assign cod-erro-pi-valida = "907".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",907".
        end.
    
        if (item.politica     <> tt-pi-valida.politica      or 
            item.periodo-fixo <> tt-pi-valida.periodo-fixo  or   
            item.lote-economi <> tt-pi-valida.lote-economi) then do:
            /*** ParÉmetro de pol°tica incompat°veis com a pol°tica ***/ 
            if tt-pi-valida.politica     = 2 and
               tt-pi-valida.lote-economi = 0 then do:
                if return-value = 'pol-le' then do:
                    {utp/ut-field.i mgind item lote-economi 1}
                    if cod-erro-pi-valida = "" then 
                        assign cod-erro-pi-valida = "27686".
                    else 
                        assign cod-erro-pi-valida = cod-erro-pi-valida + ",27686".
                end.
            end.
        end.
        
        if param-global.modulo-co and 
           can-find(first modelo-cf where modelo-cf.item-criado = ITEM.it-codigo) then do:
            if item.politica <> tt-pi-valida.politica and 
               tt-pi-valida.politica <> 5 then do:
                if cod-erro-pi-valida = "" then 
                    assign cod-erro-pi-valida = "4329".
                else 
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",4329".
            end.
            if item.tipo-con-est <> tt-pi-valida.tipo-con-est and 
               tt-pi-valida.tipo-con-est <> 4 then do:  
                if cod-erro-pi-valida = "" then 
                    assign cod-erro-pi-valida = "19060".
                else 
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",19060".
            end.
        end.
        
        /*** Tempo de resuprimento do item n∆o pode ser menor que nenhum tempo de reserva 
             de nenhuma estrutura ativa ou a ser ativada ***/
        find first estrutura where estrutura.it-codigo      = tt-pi-valida.it-codigo    and
                                   estrutura.tempo-reserv   <> ?                        and
                                   estrutura.tempo-reserv   > tt-pi-valida.ressup-fabri and 
                                   estrutura.data-termino   > today no-lock no-error.
        if available estrutura then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "8500".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",8500".
        end.
        
        /*** Valida a alteraá∆o do tipo-con-est ***/
        if item.tipo-con-est <> tt-pi-valida.tipo-con-est and 
           can-find(first saldo-estoq where saldo-estoq.it-codigo = ITEM.it-codigo) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "15763".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",15763".
        end.
    
    end.
    
    &if defined (bf_man_204) &then
        delete procedure h-cd7010.
    &endif
    
    return "ok":u.
end procedure. /*pi-alteracao*/




procedure pi-exclusao:
    def input  param table for tt-pi-valida.
    def output param cod-erro-pi-valida as char format "x(500)" no-undo.
    
    find first tt-pi-valida no-lock no-error.
    
    def var v-log-adm         as log init yes         no-undo.
    def var v-log-dis         as log init yes         no-undo.
    def var v-log-mnt         as log init yes         no-undo.
    def var v-log-mrp         as log init yes         no-undo.
    def var l-erro            as log                  no-undo. 
    def var c-table-label     as char format "x(40)"  no-undo.
    def var c-relacionados    as char format "x(100)" no-undo.
    def var i-relacionamentos as int  format ">>>>9"  no-undo.
    
    assign cod-erro-pi-valida = "".
    find first tt-pi-valida NO-LOCK NO-ERROR.
    
    run VerificarConfiguracaoMAN (output v-log-adm,
                                  output v-log-dis,
                                  output v-log-mnt,
                                  output v-log-mrp). 
    
    /*** Verifica se item Ç o Item branco ("") ***/
    if tt-pi-valida.it-codigo = "" then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "16367".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",16367".
    end.              
    
    /*** Verifica se item Ç componente em algum desenho ***/
    if can-find (first item-desenho where item-desenho.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30459".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30459".
    end.              
    
    /*** Verifica se item Ç componente em alguma estrutura ***/
    if can-find (first estrutura where estrutura.es-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "27811".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",27811".
    end.
    
    /*** Verifica se item Ç alternativo em alguma estrutura ***/
    if can-find (first alternativo where alternativo.al-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30460".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30460".
    end.
    
    /*** Verifica se item Ç componente de algum modelo de estrutura ***/
    if can-find (first estr-modelo where estr-modelo.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30461".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30461".
    end.
    
    /*** Verifica se item Ç componente de algum modelo de estrutura no configurador***/
    if can-find (first estr-mod-cf where estr-mod-cf.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30463".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30463".
    end.
    
    /*** Verifica se item Ç componente de alguma estrutura de Item do CF/DP***/
    if can-find (first cot-estrut where cot-estrut.item-cotacao = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30464".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30464".
    end.
    
    if can-find (first cot-estrut where cot-estrut.es-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30464".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30464".
    end.
    
    &if defined(bf_man_204) &then 
        if can-find (first dp-estrut where dp-estrut.es-codigo = tt-pi-valida.it-codigo) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "30464".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",30464".
        end.
    &else 
    &endif 
    
    /*** Verifica se item Ç componente de algum modelo do CF ***/
    if can-find (first modelo-cf where modelo-cf.item-criado = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30465".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30465".
    end.
    
    /*** Verifica se item Ç do m¢dulo de Desenvolvimento de Produtos/Configurador ***/
    &if defined (bf_man_204) &then
    &else
        if can-find (first cot-item where cot-item.item-cotacao = tt-pi-valida.it-codigo) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "30466".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",30466".
        end.
    
        if can-find (first cot-item where cot-item.item-ordem = tt-pi-valida.it-codigo) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "30466".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",30466".
      
        end.
    &endif
    
    /*** Verifica se item faz parte de alguma Operaá∆o do DP ***/
    if can-find (first cot-oper where cot-oper.item-cotacao = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30467".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30467".
    end.
    
    /*** Verifica se item possui Rede Pert de Operaá‰es do DP ***/
    if can-find (first cot-rede-p where cot-rede-p.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30468".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30468".   
    end.
    
    /*** Verifica se existe Pendància de CF e DP para o item***/
    if can-find (first cot-pend where cot-pend.item-cotacao = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30469".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30469".
    end.
    
    /*** Verifica se item pertence a um Roteiro do item de prototipo ***/
    &if defined (bf_man_204) &then
    &else
        if can-find (first cot-rot-it where cot-rot-it.item-cotacao = tt-pi-valida.it-codigo) then do:
            if cod-erro-pi-valida = "" then
                assign cod-erro-pi-valida = "30470".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",30470".
        end.
    &endif
    
    /*** Verifica se item possui cotaá∆o (deveria ser delecao em cascata) ***/
    if can-find (first cotacao-item use-index item where cotacao-item.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30471".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30471".
    end.
    
    /*** Verifica se item Ç de algum fornecedor ***/
    if can-find (first item-fornec use-index onde-compra where item-fornec.it-codigo = tt-pi-valida.it-codigo) then do:   
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30472".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30472".               
    end.           
    
    /*** Verifica se possui ordem de compra ***/
    if can-find (first ordem-compra use-index item where ordem-compra.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30473".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30473".          
    end.
    
    /*** Verifica se existe nota de recebimento ***/
    if can-find (first recebimento use-index item where recebimento.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30474".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30474".             
    end.
    
    /*** Verifica se existe ordem de produá∆o ***/
    if can-find (first ord-prod use-index item where ord-prod.it-codigo = tt-pi-valida.it-codigo) then do: 
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30475".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30475".             
    end.
    
    /*** Verifica se existe reservas para o item ***/
    if can-find (first reservas use-index data where reservas.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30476".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30476".
    end.                    
    
    /*** Verifica se alguma operaá∆o de ordem possui o item ***/
    if can-find (first oper-ord use-index item where oper-ord.it-codigo = tt-pi-valida.it-codigo) then  do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30477".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30477".                                 
    end.   
    
    /*** Verifica se existe item-tab tabela de preáos??? ***/
    if can-find (first item-tab use-index item-tab where item-tab.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30478".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30478".                         
    end.   
    
    /*** Verifica existencia de consumo hist¢rico do item ***/
    if can-find (first consumo use-index item-conta where consumo.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30479".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30479".                        
    end.   
    
    /*** Verifica existencia de movimentos de estoque do item ***/
    if can-find (first movto-estoq use-index item-data where movto-estoq.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30480".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30480".       
    end.   
    
    /*** Verifica existencia de saldo do item ***/
    if can-find (first saldo-estoq use-index item where saldo-estoq.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30481".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30481".              
    end.   
    
    /*** Verifica existencia de movimentos de material do item ***/
    if can-find (first movto-mat use-index onde-usou where movto-mat.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30482".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30482".        
    end.   
    
    /*** Verifica se existem documentos do item ***/
    if can-find (first item-doc-est use-index item where item-doc-est.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30483".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30483".                          
    end.   
    
    /*** Verifica se item Ç de algum estabelecimento (n∆o deveria ser eliminaá∆o em cascata?) ***/
    if can-find (first item-estab use-index item where item-estab.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30484".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30484".     
    end.   
    
    /*** Verifica se item Ç ferramenta de produá∆o ***/ 
    if can-find (first ferr-prod where ferr-prod.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30485".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30485".                     
    end.   
    
    /*** Verificaá∆o de relacionamentos com  a tabela de necessidade 
         do item no plano ***/
    def var l-existe as logical initial no.
    
    for each pl-prod no-lock:
        if can-find (first pl-it-prod use-index ch-item where pl-it-prod.it-codigo = tt-pi-valida.it-codigo and
                                                              pl-it-prod.cd-plano  = pl-prod.cd-plano) then do:
            assign l-existe = yes.
            leave.                          
        end.  
    end.
    
    if l-existe then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30486".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30486".                           
    end. 
    
    /*** Verificaá∆o se o item tem estrutura (Se o item for Pai de uma estrutura § eliminar ***/
    if can-find (first estrutura where estrutura.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30487".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30487".       
    end.
    
    /*** Verificaá∆o de relacionamentos com estrutura do produto ***/
    if can-find (first est-prod where est-prod.it-codigo = tt-pi-valida.it-codigo) then do:
        if cod-erro-pi-valida = "" then 
            assign cod-erro-pi-valida = "30488".
        else 
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",30488".      
    end. 
    
    /*** Verificaá∆o de relacionamentos com as tabelas do banco mgdis e movdis ***/
    if v-log-dis then do:
        run inbo/boin172c.p (input tt-pi-valida.it-codigo,
                             input tt-pi-valida.ge-codigo,
                             input-output c-relacionados,
                             input-output i-relacionamentos).
        if c-relacionados <> "" then
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "30489".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",30489".         
    end.
    
    /*** Verificaá∆o de relacionamentos com as tabelas do banco mgmnt ***/
    if v-log-mnt then do:
        run inbo/boin172d.p (input tt-pi-valida.it-codigo,
                             input-output c-relacionados,
                             input-output i-relacionamentos).
        if c-relacionados <> "" then
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "30490".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",30490".        
    end.
    
    /*** Verificaá∆o de relacionamentos com Item Lista Componente - Na vers∆o 2.02 ***/
    &if defined (bf_man_sfc_lc) &then
        if can-find(first item-lista-compon where item-lista-compon.es-codigo = tt-pi-valida.it-codigo) then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "30491".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",30491".  
            
        end.
    
        find first altern-lista-compon where altern-lista-compon.al-codigo = tt-pi-valida.it-codigo no-lock no-error.
        if available altern-lista-compon then do:
            if cod-erro-pi-valida = "" then 
                assign cod-erro-pi-valida = "30491".
            else 
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",30491".  
            
        end.
    
    &endif
    
    /*********[ Bancos Hist¢ricos ]*********/
    if not available(param-global) then
        find first param-global no-lock no-error.
    
    if param-global.modulo-bh = yes then do:      
    
        {bhp/bh9999.i 4 item tt-pi-valida.it-codigo '' '' '' '' '' ''}
        if return-value <> "OK" then do:
            if c-relacionados <> "" then do:
                if cod-erro-pi-valida = "" then 
                    assign cod-erro-pi-valida = "30492".
                else 
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",30492".  
               
            end.
        end.                             
    end.
    /*********[ Fim Bancos Hist¢ricos ]************/
    
    return "ok":u.
end procedure. /* pi-exclusao */




procedure pi-valida-inclusao-alteracao:
    def input param c-acao as char no-undo.
    def input param table for tt-item.
    def output param cod-erro-pi-valida as char format "x(500)" no-undo.
    
    DEF VAR i-vetor-item-mat AS INTEGER NO-UNDO.

    find first tt-item no-lock no-error.
    find first param-global no-lock no-error.
    
    IF tt-item.cod-estabel = "" OR 
       tt-item.cod-estabel = ?  THEN DO:
       find first param-estoq no-lock no-error.
       if avail param-estoq then
          assign tt-item.cod-estabel = param-estoq.estabel-pad. 
    END.  
    
    /********[ Validaá‰es da v05in172 ]********/
    &if defined (bf_man_ponto_repos) &then
        if tt-item.politica = 7 then
            if tt-item.quant-segur >= tt-item.pto-repos then do:
                if cod-erro-pi-valida = "" then
                    assign cod-erro-pi-valida = "26786".
                else
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",26786".
            end.
    &endif
    /********[ Fim das Validaá‰es da v05in172 ]********/
    
    if c-acao = "upd" then do:
    /*** Valida a alteraá∆o do Tipo de Formulaá∆o p/ Fator de Cooncentraá∆o ***/   
        &if defined (bf_man_per_ppm) &then
        
            find first item where item.it-codigo = tt-item.it-codigo no-lock no-error.
        
            if param-global.modulo-per-ppm and
               (item.tipo-formula <> tt-item.tipo-formula or
                item.per-ppm      <> tt-item.per-ppm) then do:
        
                case tt-item.tipo-formula:
                    when 1 or
                    when 2 or
                    when 3 then do:
                        if tt-item.tipo-formula = 2 or
                           tt-item.tipo-formula = 3 then do:
                            if tt-item.tipo-con-est <> 3 or
                               can-find (first estrutura         where estrutura.es-codigo         = tt-item.it-codigo use-index onde-se-usa) or
                               can-find (first item-lista-compon where item-lista-compon.es-codigo = tt-item.it-codigo use-index onde-se-usa) or
                               can-find (first reservas          where reservas.it-codigo          = tt-item.it-codigo and
                                                                       reservas.estado             = 1 use-index planejamento)                or
                               can-find (first saldo-estoq       where saldo-estoq.it-codigo       = tt-item.it-codigo use-index item) then do:
                                if cod-erro-pi-valida = "" then
                                    assign cod-erro-pi-valida = "27371".
                                else
                                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",27371".
                            end.
                        end.
                    end.
                    when 4 then do:
                        if can-find (first estrutura         where estrutura.es-codigo         = tt-item.it-codigo use-index onde-se-usa) or
                           can-find (first alternativo       where alternativo.al-codigo       = tt-item.it-codigo use-index onde-se-usa) or
                           can-find (first item-lista-compon where item-lista-compon.es-codigo = tt-item.it-codigo use-index onde-se-usa) or
                           can-find (first reservas          where reservas.it-codigo          = tt-item.it-codigo and
                                                                   reservas.estado             = 1 use-index planejamento) or
                           can-find (first saldo-estoq where saldo-estoq.it-codigo             = tt-item.it-codigo use-index item) then
                            if cod-erro-pi-valida = "" then
                                assign cod-erro-pi-valida = "27371".
                            else
                                assign cod-erro-pi-valida = cod-erro-pi-valida + ",27371".
                    end.
                end case.
            end.
        
        &endif
    end.
    
    /**********************************************************************
    LUCIANO LEONHARDT: logica comentada pois a mesma Ç executado diretamente pela trigger da tabela item.
    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-integra-ems-his":U
                AND   funcao.ativo     = YES) THEN DO:
    
        find first fam-uni-estab where
                   fam-uni-estab.fm-codigo   = tt-item.fm-codigo and
                   fam-uni-estab.cod-estabel = tt-item.cod-estabel no-lock no-error.

        find estabelec where 
             estabelec.cod-estabel = fam-uni-estab.cod-estabel no-lock no-error. 

        FIND FIRST LIN-PROD WHERE LIN-PROD.COD-ESTABEL = ESTABELEC.COD-ESTABEL NO-LOCK NO-ERROR.
        if not can-find (item-uni-estab where
                         item-uni-estab.it-codigo   = tt-item.it-codigo and
                         item-uni-estab.cod-estabel = tt-item.cod-estabel) then do:
        
           CREATE item-uni-estab.
           BUFFER-COPY tt-item EXCEPT char-1 char-2 cod-estabel TO item-uni-estab.
           ASSIGN item-uni-estab.cod-estabel         = IF AVAIL estabelec THEN estabelec.cod-estabel ELSE ""
                  item-uni-estab.deposito-pad        = fam-uni-estab.deposito-pad
                  item-uni-estab.cd-planejado        = IF AVAIL lin-prod
                                                       THEN lin-prod.cd-planejado
                                                       ELSE tt-item.cd-planejado
                  item-uni-estab.cod-localiz         = fam-uni-estab.cod-localiz
                  SUBSTR(item-uni-estab.char-1,10,1) = IF INTEGER(SUBSTRING(tt-item.char-1,10,1)) <> 0
                                                       THEN SUBSTRING(tt-item.char-1,10,1)
                                                       ELSE "1"
                  item-uni-estab.qt-min-res-fabr     = DECIMAL(SUBSTRING(tt-item.char-1,20,12))
                  item-uni-estab.var-tempo-res-fabr  = INTEGER(SUBSTRING(tt-item.char-1,15,4))
                  item-uni-estab.var-qtd-res-fabr    = DECIMAL(SUBSTRING(tt-item.char-1,35,12))
                  item-uni-estab.nr-linha            = fam-uni-estab.nr-linha
                  item-uni-estab.int-1               = IF item-uni-estab.cod-estabel = tt-item.cod-estabel
                                                       THEN 0
                                                       ELSE 1.

            find item-man where
                 item-man.it-codigo = tt-item.it-codigo no-lock no-error.
            if avail item-man then
               assign item-uni-estab.ind-lista-mrp = item-man.ind-lista-mrp
                      item-uni-estab.ind-lista-csp = item-man.ind-lista-csp.

            /*--- Replicacao da tabela item-mat
                  para item-uni-estab ---*/
            {cdp/cd0204k.i}

        END.
    
    END.
    **********************************************************************/
    
    return "ok":U.
end procedure. /* pi-valida-inclusao */




procedure pi-valida-criacao-eai:
    def input  param table for tt-item.
    def input  param table for tt-ref-item.
    def output param cod-erro-pi-valida as char format "x(500)" no-undo.
    
    find first tt-item no-lock no-error.
    find first tt-ref-item no-lock no-error.
    
    if connected("mgmp") and
       tt-item.cod-lista-destino <> "" then do:
        run inbo/boin172l.p(input tt-item.cod-lista-destino,
                            input-output cod-erro-pi-valida).
    end.
    
    find first localizacao where localizacao.cod-localiz = tt-item.cod-localiz no-lock no-error.
    if not avail localizacao then do:
    
        if cod-erro-pi-valida = "" then
            assign cod-erro-pi-valida = "15997".
        else
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",15997".
    
    end.
    
    find first moeda where moeda.mo-codigo = tt-item.moeda-padrao no-lock no-error.
    if not avail moeda then do:
    
        if cod-erro-pi-valida = "" then
            assign cod-erro-pi-valida = "151".
        else
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",151".
    
    end.
    
    if avail tt-ref-item then do:
        find first referencia where referencia.cod-refer = tt-ref-item.cod-refer no-lock no-error.
        if not avail referencia then do:
        
            if cod-erro-pi-valida = "" then
                assign cod-erro-pi-valida = "529".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",529".
        
        end.
    end.
    
    /* Validaá‰es de v05in172 */
    if tt-item.politica = 2 and 
       tt-item.lote-economi = 0 then do:
        if cod-erro-pi-valida = "" then
            assign cod-erro-pi-valida = "4570".
        else
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",4570".
    end.
     
    if tt-item.lote-multipl <> truncate(tt-item.lote-multipl,0) and 
       tt-item.fraciona = no then do:
        if cod-erro-pi-valida = "" then
            assign cod-erro-pi-valida = "907".
        else
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",907".
    end.
    
    if substring(tt-item.char-1,10,1) = "2" then do:
        if tt-item.politica = 3 or
           tt-item.politica = 4 then do:
            if cod-erro-pi-valida = "" then
                assign cod-erro-pi-valida = "16490".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",16490".
        end.
    end.
    
    find first familia where familia.fm-codigo = tt-item.fm-codigo no-lock no-error.
    if avail familia then do:
       find first deposito where deposito.cod-depos  = familia.deposito-pad no-lock no-error.
       if not avail deposito then do:
           if cod-erro-pi-valida = "" then
                assign cod-erro-pi-valida = "28627".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",28627".
    
       end.
    end.
    
    &if defined (bf_man_sfc_ref_oper) &then 
        if tt-item.log-control-estoq-refugo = yes then do:
    
            if tt-item.cod-item-refugo = "" then do:
                if cod-erro-pi-valida = "" then
                    assign cod-erro-pi-valida = "29469".
                else
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",29469".
    
            end.
    
            if tt-item.cod-item-refugo = tt-item.it-codigo then do:
                if cod-erro-pi-valida = "" then
                    assign cod-erro-pi-valida = "29464".
                else
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",29464".
            end.
    
            if dec(tt-item.val-relac-refugo-item) <= 0 or
               dec(tt-item.val-relac-refugo-item)  = ? then do:
                if cod-erro-pi-valida = "" then
                    assign cod-erro-pi-valida = "28174".
                else
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",28174".
        
            end.
    
            find first item where item.it-codigo = tt-item.cod-item-refugo no-lock no-error.
            if not avail item then do:
                if cod-erro-pi-valida = "" then
                    assign cod-erro-pi-valida = "32241".
                else
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",32241".
            end.
            else do:
                if item.tipo-contr <> 2 then do:
                    if cod-erro-pi-valida = "" then
                        assign cod-erro-pi-valida = "29462".
                    else
                        assign cod-erro-pi-valida = cod-erro-pi-valida + ",29462".
                end.
        
               if item.tipo-con-est <> 1 then do:
                   if cod-erro-pi-valida = "" then
                       assign cod-erro-pi-valida = "29463".
                   else
                       assign cod-erro-pi-valida = cod-erro-pi-valida + ",29463".
               end.       
            end.
        end.
    
    &endif
    
    return "ok":U.
end procedure. /* pi-valida-criacao-eai */




procedure pi-valida-alteracao-eai:
    def input  param table for tt-item.
    def input  param table for tt-ref-item.
    def output param cod-erro-pi-valida as char format "x(500)" no-undo.
    
    
    find first tt-item no-lock no-error.
    find first tt-ref-item no-lock no-error.
    find first item where item.it-codigo = tt-item.it-codigo no-lock no-error.
    find first param-global no-lock no-error.
    
    if connected("mgmp") and
       tt-item.cod-lista-destino <> "" then do:
        run inbo/boin172l.p(input tt-item.cod-lista-destino,
                            input-output cod-erro-pi-valida).
    end.
    
    find first localizacao where localizacao.cod-localiz = tt-item.cod-localiz no-lock no-error.
    if not avail localizacao then do:
    
        if cod-erro-pi-valida = "" then
            assign cod-erro-pi-valida = "15997".
        else
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",15997".
    
    end.
    
    find first moeda where moeda.mo-codigo = tt-item.moeda-padrao no-lock no-error.
    if not avail moeda then do:
    
        if cod-erro-pi-valida = "" then
            assign cod-erro-pi-valida = "151".
        else
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",151".
    
    end.
    
    if avail tt-ref-item then do:
        find first referencia where referencia.cod-refer = tt-ref-item.cod-refer no-lock no-error.
        if not avail referencia then do:
        
            if cod-erro-pi-valida = "" then
                assign cod-erro-pi-valida = "529".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",529".
        
        end.
    end.
    
    if item.ge-codigo <> tt-item.ge-codigo then
        if cod-erro-pi-valida = "" then
            assign cod-erro-pi-valida = "7972".
        else
            assign cod-erro-pi-valida = cod-erro-pi-valida + ",7972".
    
    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-integra-ems-his"
                AND   funcao.ativo     = YES) THEN DO:
        FIND FIRST movto-estoq
             WHERE movto-estoq.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL movto-estoq THEN DO:
            IF ITEM.un <> tt-item.un THEN
                IF cod-erro-pi-valida = "" THEN
                    ASSIGN cod-erro-pi-valida = "36488".
                ELSE
                    ASSIGN cod-erro-pi-valida = cod-erro-pi-valida + ",36488".
        END.
    END.
    ELSE DO:
        if item.un <> tt-item.un then
            if cod-erro-pi-valida = "" then
                assign cod-erro-pi-valida = "36488".
            else
                assign cod-erro-pi-valida = cod-erro-pi-valida + ",36488".
    END.
    
    if tt-item.cod-localiz <> "" and
       tt-item.deposito-pad <> "" then do:
        find first localizacao where localizacao.cod-depos   = tt-item.deposito-pad and
                                     localizacao.cod-localiz = tt-item.cod-localiz no-lock no-error.
        if param-global.modulo-ce and
          (available localizacao or
           tt-item.cod-localiz = "") and
          (tt-item.cod-localiz  <> item.cod-localiz or
           tt-item.deposito-pad <> item.deposito-pad) then do:
                if cod-erro-pi-valida = "" then
                    assign cod-erro-pi-valida = "26255".
                else
                    assign cod-erro-pi-valida = cod-erro-pi-valida + ",26255".
        end.
    end.
    
    &if defined(bf_man_205) &then
        if param-global.modulo-per-ppm then do:
    
            if can-find (first estrutura         where estrutura.es-codigo         = tt-item.it-codigo use-index onde-se-usa) or
               can-find (first alternativo       where alternativo.al-codigo       = tt-item.it-codigo use-index onde-se-usa) or
               can-find (first item-lista-compon where item-lista-compon.es-codigo = tt-item.it-codigo use-index onde-se-usa) or
               can-find (first reservas          where reservas.it-codigo          = tt-item.it-codigo and
                                                       reservas.estado             = 1 use-index planejamento)                or
               can-find (first saldo-estoq       where saldo-estoq.it-codigo       = tt-item.it-codigo use-index item) then do:
    
                if tt-item.tipo-formula <> item.tipo-formula or
                   tt-item.per-ppm      <> item.per-ppm then
                    if cod-erro-pi-valida = "" then
                        assign cod-erro-pi-valida = "29463".
                    else
                        assign cod-erro-pi-valida = cod-erro-pi-valida + ",29463".
            end.
            else do:
                if tt-item.tipo-formula = 1 and
                   tt-item.tipo-formula = 4 then
                    assign tt-item.per-ppm = 0.
            end.
        end.
        else
            assign tt-item.tipo-formula = 1
                   tt-item.per-ppm = 0.
    &endif
    
    return "ok":U.
end procedure. /* pi-valida-alteracao-eai */
