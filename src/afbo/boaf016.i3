/*****************************************************************************
**       INCLUDE : boaf016.i3
**       DATA....: Outubro de 2004    
**       OBJETIVO: Preencher combo-box de per¡odos para sele‡Æo
******************************************************************************
** Parƒmetros 
** {1} Ano para preenchimento dos per¡odos
** {2} Combo-box com a descri‡Æo dos per¡odos
** {3} Frame com que cont‚m o combo-box
******************************************************************************/
   def var i-cont-per            as int no-undo.
   def var c-list-item-pairs-per as char no-undo.

   find af-periodo-aval where af-periodo-aval.ano-avaliacao = int({1}) and
                              af-periodo-aval.ep-codigo = v_cdn_empres_usuar no-lock no-error.
   if avail af-periodo-aval then do:
          do i-cont-per = 1 to af-periodo-aval.nr-periodos:
             if i-cont-per = 1 then do:
                assign c-list-item-pairs-per = string(af-periodo-aval.des-periodo-aval[i-cont-per]).
             end.
             else do: 
                assign c-list-item-pairs-per = c-list-item-pairs-per + "," +
                                               string(af-periodo-aval.des-periodo-aval[i-cont-per]).
             end.
          end.
          run utp/ut-lstit.p (input-output c-list-item-pairs-per).
                
          assign {2}:list-item-pairs in frame {3}  = c-list-item-pairs-per.      
      do i-cont-per = 1 to af-periodo-aval.nr-periodos:
         if af-periodo-aval.ano-avaliacao = year(today) then do:
            if month(today) >= month(af-periodo-aval.dt-periodo-ini[i-cont-per]) and
               month(today) <= month(af-periodo-aval.dt-periodo-fim[i-cont-per]) then do:
               assign {2}:screen-value in frame {3} = string(af-periodo-aval.des-periodo-aval[i-cont-per]).
               leave.
            end.
         end.
         else if af-periodo-aval.ano-avaliacao < year(today) then do:
              if i-cont-per = af-periodo-aval.nr-periodos then
                 assign {2}:screen-value in frame {3}  = string(af-periodo-aval.des-periodo-aval[i-cont-per]).
         end.
      end.
   end.
/**** Fim boaf016.i3 **********************************************************/
