/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN469BT 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN469BT MUT}
&ENDIF

/*** Programa funciona a partir da release 2.02 ***/

{cdp/cdcfgman.i}

&IF DEFINED (bf_man_sfc_lc) &THEN 

    def var i-func-inic  as integer.
    def var i-func-fim   as integer.
    def var i-func-tempo as integer.
    def var i-tempo      as decimal.

    def var v-tempo as decimal.
    def var v-tempo-aux as decimal.

    def var v-dat-inic as date.
    def var v-dat-fim as date.
    def var v-dat-aux as date.
    def var da-ini-aux as date.
    def var da-fim-aux as date.

    def var v-qtd-hra-inic as decimal.
    def var v-qtd-hra-fim as integer.

    def var v-qtd-segs-inic as integer.
    def var v-qtd-segs-fim as integer.
    def var hra-ini-aux as integer.
    def var hra-fim-aux as integer.

    def var i-cont as integer.
    def var i-test as integer.

    def var h-bo as handle no-undo.

    def temp-table tt-diferencas NO-UNDO       field dat-inic-orig as date
       field hra-inic-orig as decimal 
       field dat-fim-orig  as date 
       field hra-fim-orig as decimal 
       field tempo-orig   as decimal

       field dat-inic-calc as date
       field hra-inic-calc as decimal 
       field dat-fim-calc  as date 
       field hra-fim-calc as decimal 
       field tempo-calc   as decimal.

   def var v-cod-ctrab  as char.
   def var v-gm-codigo  as char.
   def var v-cod-area   as char.
   def var c-cod-calend as char.

   output to c:~\ems203~\tmp~\diferb.lst.

   run inbo/boin469b.p persistent set h-bo.

   assign v-dat-inic = today.

   find first area-produc-ctrab where
              cod-ctrab > "i" no-lock.

   assign v-cod-ctrab  = ? /** area-produc-ctrab.cod-ctrab **/
          v-gm-codigo  = ? /** area-produc-ctrab.gm-codigo **/
          v-cod-area   =  area-produc-ctrab.cod-area-produc 
          c-cod-calend = ?.          

   assign i-tempo = time.

   blk-repeat:
   repeat:

       do i-cont = 1 to 96:
          assign v-qtd-hra-inic = i-cont * 900
                  v-tempo    = random(1,200) / 4 
                  v-dat-fim  = ?.

        /*** fim evento ***/
        run CalcularTemposCtrab in h-bo (input-output v-cod-area,
                                               input-output v-gm-codigo,
                                               input        v-cod-ctrab,
                                               input-output c-cod-calend,
                                               Input-output v-dat-fim,
                                               Input-output v-qtd-segs-fim,
                                               Input-output v-dat-inic,
                                               Input-output v-qtd-hra-inic,
                                               Input-output v-tempo).

        assign v-dat-inic = ?. 


        /*** Inicio evento ***/
        run CalcularTemposCtrab in h-bo (input-output v-cod-area,
                                               input-output v-gm-codigo,
                                               input        v-cod-ctrab,
                                               input-output c-cod-calend,
                                               Input-output v-dat-fim,
                                               Input-output v-qtd-segs-fim,
                                               Input-output v-dat-inic,
                                               Input-output v-qtd-segs-inic,
                                               Input-output v-tempo).


          assign da-fim-aux  = v-dat-fim 
                 hra-fim-aux = v-qtd-segs-fim
                 da-ini-aux  = v-dat-inic 
                 hra-ini-aux = v-qtd-segs-inic
                 v-tempo-aux = v-tempo
                 v-dat-fim   = ?.

          /*** Fim Evento ***/
          run CalcularTemposCtrab in h-bo (input-output v-cod-area,
                                               input-output v-gm-codigo,
                                               input        v-cod-ctrab,
                                               input-output c-cod-calend,
                                               Input-output v-dat-fim,
                                               Input-output v-qtd-segs-fim,
                                               Input-output v-dat-inic,
                                               Input-output v-qtd-segs-inic,
                                               Input-output v-tempo).



          if da-fim-aux <> v-dat-fim or
             hra-fim-aux  <> v-qtd-segs-fim then do:
             create tt-diferencas.
             assign tt-diferencas.dat-inic-orig = da-ini-aux
                    tt-diferencas.hra-inic-orig = hra-ini-aux / 3600
                    tt-diferencas.dat-fim-orig  = da-fim-aux
                    tt-diferencas.hra-fim-orig  = hra-fim-aux / 3600
                    tt-diferencas.tempo-orig    = v-tempo-aux
                    tt-diferencas.dat-inic-calc = ?
                    tt-diferencas.hra-inic-calc = ?
                    tt-diferencas.dat-fim-calc  = v-dat-fim
                    tt-diferencas.hra-fim-calc  = v-qtd-segs-fim                           
                    tt-diferencas.tempo-calc    = ?.
          end.                             
          assign da-fim-aux  = v-dat-fim 
                 hra-fim-aux = v-qtd-segs-fim
                 da-ini-aux  = v-dat-inic 
                 hra-ini-aux = v-qtd-segs-inic
                 v-tempo-aux = v-tempo.


          /*** Tempo Util ***/                   
          run CalcularTemposCtrab in h-bo (input-output v-cod-area,
                                               input-output v-gm-codigo,
                                               input        v-cod-ctrab,
                                               input-output c-cod-calend,
                                               Input-output v-dat-fim,
                                               Input-output v-qtd-segs-fim,
                                               Input-output v-dat-inic,
                                               Input-output v-qtd-segs-inic,
                                               Input-output v-tempo).

          if v-tempo <> v-tempo-aux then do:
             create tt-diferencas.
             assign tt-diferencas.dat-inic-orig = da-ini-aux
                    tt-diferencas.hra-inic-orig = hra-ini-aux / 3600
                    tt-diferencas.dat-fim-orig  = da-fim-aux
                    tt-diferencas.hra-fim-orig  = hra-fim-aux / 3600
                    tt-diferencas.tempo-orig    = v-tempo-aux
                    tt-diferencas.dat-inic-calc = ?
                    tt-diferencas.hra-inic-calc = ?
                    tt-diferencas.dat-fim-calc  = ?
                    tt-diferencas.hra-fim-calc  = ?                           
                    tt-diferencas.tempo-calc    = v-tempo.
          end.

          assign i-cont = i-cont + 1
                 i-test = i-test + 1.

          if i-test >= 700 then leave blk-repeat.

       end.

       assign v-dat-inic = v-dat-inic + 1.       

   end.

   assign i-tempo = time - i-tempo.  

   for each tt-diferencas:
      display tt-diferencas with width 132.
   end.   

   display '  ' i-test '   ' i-tempo / 60  '   ' i-tempo / i-test.

 output close.

 delete procedure h-bo.

/*  update v-dat-inic v-qtd-hra-inic v-dat-fim v-qtd-hra-fim.

    assign v-qtd-segs-inic = v-qtd-hra-inic * 3600
           v-qtd-segs-fim = v-qtd-hra-fim * 3600.


       find first grp_maq_sfc no-lock.
       find first area_produc no-lock.
       @run (fnc_det_tempo_util(grp_maq_sfc.cod_grp_maq,
                                 area_produc.cod_area_produc,
                                 ?,                                 
                                 v-dat-fim,
                                 v-qtd-segs-fim,
                                 v-dat-inic,
                                 v-qtd-segs-inic,
                                 v-tempo)).

      display v-tempo.

*/

/*   update v-tempo v-dat-fim v-qtd-hra-fim.

    assign v-qtd-segs-fim = v-qtd-hra-fim * 3600.


       find first grp_maq_sfc no-lock.
       find first area_produc no-lock.
       @run (fnc_det_inic_evento(grp_maq_sfc.cod_grp_maq,
                                 area_produc.cod_area_produc,
                                 ?,
                                 v-tempo * 3600,
                                 v-dat-fim,
                                 v-qtd-segs-fim,
                                 v-dat-inic,
                                 v-qtd-segs-inic)).

      display v-dat-inic v-qtd-segs-inic / 3600.

 */   

/*  update v-tempo v-dat-inic v-qtd-hra-inic.

    assign v-qtd-segs-inic = v-qtd-hra-inic * 3600.

    find first grp_maq_sfc no-lock.
       find first area_produc no-lock.
       @run (fnc_det_fim_evento(grp_maq_sfc.cod_grp_maq,
                                 area_produc.cod_area_produc,
                                 ?,
                                 v-tempo * 3600,
                                 v-dat-inic,
                                 v-qtd-segs-inic,
                                 v-dat-fim,
                                 v-qtd-segs-fim)).

      display v-dat-fim v-qtd-segs-fim / 3600.    

*/                            


&ENDIF
