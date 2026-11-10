/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN263A 2.00.00.002} /*** "010002" 07/11/2023 17:53:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN263A MUT}
&ENDIF

{inbo/boin263a.i}

PROCEDURE GerarOperacaoGM:
 
    def input  param table for tt-grp-maq.
    def input  param table for tt-operacao.
    def input  param table for tt-rot-fabric-sfc.
    def input  param table for tt-item-fabric.
    def output param table for tt-erro.

    for each tt-grp-maq:

        for each tt-operacao
            where tt-operacao.gm-codigo = tt-grp-maq.gm-codigo no-lock:

            find first operacao
                where operacao.it-codigo   = tt-operacao.it-codigo
                  and operacao.cod-roteiro = tt-operacao.cod-roteiro
                  and operacao.op-codigo   = tt-operacao.op-codigo no-error.

            if  tt-operacao.op-altern = 0 then do:
                if  not avail operacao then
                    create operacao.

            assign operacao.it-codigo    = tt-operacao.it-codigo
                   operacao.cod-roteiro  = tt-operacao.cod-roteiro
                   operacao.op-codigo    = tt-operacao.op-codigo
                   operacao.gm-codigo    = tt-operacao.gm-codigo
                   operacao.descricao    = tt-operacao.descricao
                   operacao.tempo-prepar = tt-operacao.tempo-prepar
                   operacao.tempo-maquin = tt-operacao.tempo-maquin
                   operacao.tempo-homem  = tt-operacao.tempo-homem
                   operacao.nr-unidades  = tt-operacao.nr-unidades.
            end.
            else do:
                if  not avail operacao then
                    next.
                
                find first op-altern
                    where op-altern.num-id-operacao = operacao.num-id-operacao
                      and op-altern.op-altern       = tt-operacao.op-altern no-lock no-error.
                if  not avail op-altern then
                    create op-altern.
                  
                assign op-altern.num-id-operacao = operacao.num-id-operacao
                       op-altern.op-altern       = tt-operacao.op-altern
                       op-altern.gm-codigo       = tt-operacao.gm-codigo
                       op-altern.descricao       = tt-operacao.descricao
                       op-altern.tempo-prepar    = tt-operacao.tempo-prepar
                       op-altern.tempo-maquin    = tt-operacao.tempo-maquin
                       op-altern.tempo-homem     = tt-operacao.tempo-homem
                       op-altern.nr-unidades     = tt-operacao.nr-unidades.
            end.
        end.
    end.
  
    /* Se existe algum roteiro que ainda n∆o tenha sido criado, primeiro faz a importaá∆o destes roteiros */
    if  can-find(first tt-rot-fabric-sfc) then do:
        run enp/en0510a1.p (input table tt-rot-fabric-sfc).
    end.
    
    /* Se existe algum item que ainda n∆o tenha sido criado, primeiro faz a importaá∆o destes itens */
    /*if  can-find(first tt-item-fabric) then do:
        run enp/en0510a2.p (input table tt-item-fabric).
    end.*/
  
END PROCEDURE.
