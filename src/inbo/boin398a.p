/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN398A 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN398A MUT}
&ENDIF

{enp/enapi503.i}
{cdp/cd0666.i}

PROCEDURE GerarRoteiroFabric:

    def input  param l-atu-existente as logical no-undo.
    def input  param l-tempos        as logical no-undo.
    def input  param table for tt-rot-fabric-sfc.
    def input  param table for tt-operacao.
    def input  param table for tt-rede-pert.
    def output param table for tt-erro.
    
    def buffer b-tt-operacao for tt-operacao.
    def buffer b-operacao    for operacao.
             
    def var v-log-alternativas as log  no-undo.
    def var v-it-codigo        as char no-undo.
    def var v-cod-roteiro      as char no-undo.
      
    /* Somente atualiza os registros existentes */
    if  l-atu-existente then do:
   
        for each tt-rot-fabric-sfc:
        
            find first rot-fabric
                 where rot-fabric.cod-roteiro = tt-rot-fabric-sfc.cod-roteiro exclusive-lock no-error.
            if not available rot-fabric then do:
                create rot-fabric.
                assign rot-fabric.cod-roteiro = tt-rot-fabric-sfc.cod-roteiro.
            end.
            assign rot-fabric.descricao      = tt-rot-fabric-sfc.descricao
                   rot-fabric.data-liberacao = tt-rot-fabric-sfc.data-inicio
                   v-cod-roteiro             = tt-rot-fabric-sfc.cod-roteiro
                   v-it-codigo               = "".
                   
            {inbo/boin398a.i}       

        end.
    end.
    else do: /* Cria roteiros novos */
        for each tt-rot-fabric-sfc:
            if  not can-find(first rot-fabric
                             where rot-fabric.cod-roteiro = tt-rot-fabric-sfc.cod-roteiro) then do:
                create rot-fabric.
                assign rot-fabric.cod-roteiro    = tt-rot-fabric-sfc.cod-roteiro
                       rot-fabric.descricao      = tt-rot-fabric-sfc.descricao
                       rot-fabric.data-liberacao = tt-rot-fabric-sfc.data-inicio.
            end.
        end.
    end.

END PROCEDURE.
