/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN400A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN400A MUT}
&ENDIF


{enp/enapi502.i}
{cdp/cd0666.i}

PROCEDURE GerarOperRotItem:

   def input  param table for tt-item-processo.
   def input  param table for tt-rot-fabric-sfc.
   def input  param table for tt-rot-item-sfc.
   def input  param table for tt-operacao.
   def input  param table for tt-rede-pert.
   def output param table for tt-erro.
   def input  param l-tempos  as logical.

   def var v-log-alternativas as log  no-undo.
   def var v-it-codigo        as char no-undo.
   def var v-cod-roteiro      as char no-undo.   

   def buffer b-operacao    for operacao.
   def buffer b-tt-operacao for tt-operacao.

   for each tt-rot-item-sfc:
   
       if not can-find (first tt-item-processo where
                              tt-item-processo.it-codigo = tt-rot-item-sfc.it-codigo) then next.
   
       find first rot-item
            where rot-item.it-codigo   = tt-rot-item-sfc.it-codigo
              and rot-item.cod-roteiro = tt-rot-item-sfc.cod-roteiro exclusive-lock no-error.
       if not avail rot-item then do:
          create rot-item.
          assign rot-item.it-codigo   = tt-rot-item-sfc.it-codigo
                 rot-item.cod-roteiro = tt-rot-item-sfc.cod-roteiro.
       end.
       assign rot-item.sequencia    = tt-rot-item-sfc.num-seq
              rot-item.data-inicio  = tt-rot-item-sfc.data-inicio
              rot-item.data-termino = tt-rot-item-sfc.data-termino.
   
       find first tt-rot-fabric-sfc where
                  tt-rot-fabric-sfc.cod-roteiro = tt-rot-item-sfc.cod-roteiro no-error.
       
       if not available tt-rot-fabric-sfc then next.

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
       
       delete tt-rot-fabric-sfc.       
                   
   end.    

   for each tt-item-processo:

       assign v-cod-roteiro = ""
              v-it-codigo   = tt-item-processo.it-codigo.
               
       {inbo/boin398a.i}       

   end.

   
END PROCEDURE.   
