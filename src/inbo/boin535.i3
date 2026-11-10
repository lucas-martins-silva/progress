 /******************************************************************************
** 
** PROCEDURE AlterarEstadoSplit
** Objetivo: Alteraá∆o de estado do split da operaá∆o
** ParÉmetros: buffer split-operac
**
*******************************************************************************/
{sfc/sf9999.i}
PROCEDURE AlterarEstadoSplit:

    define parameter buffer b-split-operac for split-operac.
    define input parameter p-ind-estado    as integer no-undo.
    
    def var h-boin536 as handle no-undo.

    def var v-qtd-aberto     like split-operac.qtd-operac-aprov no-undo.
    def var v-log-finaliz-op as logical no-undo.

    def buffer b1-split-operac for split-operac.
	def buffer b2-split-operac for split-operac.

    &IF DEFINED(bf_man_204) &THEN
    DEFINE VARIABLE l-sfc-mudanca AS LOGICAL    NO-UNDO.
    assign l-sfc-mudanca = l-glob-novo-sfc.
    &ENDIF

    if  b-split-operac.ind-estado-split = p-ind-estado then do:
        find first oper-ord exclusive-lock where   
                oper-ord.nr-ord-produ     = b-split-operac.nr-ord-produ   and
                oper-ord.num-operac-sfc   = b-split-operac.num-operac-sfc no-error.
		if avail oper-ord then do:
		    assign oper-ord.qt-produzida = 0.
		    for each b2-split-operac where 
		             b2-split-operac.nr-ord-produ   = b-split-operac.nr-ord-produ  and
				     b2-split-operac.num-operac-sfc = b-split-operac.num-operac-sfc:
		        assign oper-ord.qt-produzida = oper-ord.qt-produzida + b2-split-operac.qtd-operac-aprov + b2-split-operac.qtd-operac-refgda.
		    end.
		end.
        return.
    end.

    /*** Split fica como n∆o iniciado ***/
    if  p-ind-estado = 1 then do:
        assign b-split-operac.dat-progda-inic-setup       = ?
               b-split-operac.qtd-segs-progdo-inic-setup  = 0
               b-split-operac.dat-progda-inic-operac      = ?
               b-split-operac.qtd-segs-progdo-inic-operac = 0
               b-split-operac.dat-progda-fim-operac       = ?
               b-split-operac.qtd-segs-progdo-fim-operac  = 0.
               
        find first oper-ord exclusive-lock 
             where oper-ord.nr-ord-produ     = b-split-operac.nr-ord-produ   
               and oper-ord.num-operac-sfc   = b-split-operac.num-operac-sfc no-error.
        if available oper-ord then
            assign oper-ord.estado = 1.
                
    end.  

    &IF DEFINED(bf_man_204) &THEN
    If l-sfc-mudanca = no then do:
    &ENDIF

        /*** Mudanáa de n∆o iniciado para liberado ***/ 
        if b-split-operac.ind-estado-split = 1 and p-ind-estado = 3 then do:
             /*** Alteraá∆o de datas programadas em funá∆o de imc e fmt ***/
             assign b-split-operac.dat-progda-inic-setup       = b-split-operac.dat-imc-setup 
                    b-split-operac.qtd-segs-progdo-inic-setup  = b-split-operac.qtd-segs-imc-setup
                    b-split-operac.dat-progda-inic-operac      = b-split-operac.dat-imc
                    b-split-operac.qtd-segs-progdo-inic-operac = b-split-operac.qtd-segs-imc
                    b-split-operac.dat-progda-fim-operac       = b-split-operac.dat-fmt
                    b-split-operac.qtd-segs-progdo-fim-operac  = b-split-operac.qtd-segs-fmt.
        end. 

    &IF DEFINED(bf_man_204) &THEN
    END.
    &ENDIF

   /*** Mudanáa para liberado - regra comum ***/
   if p-ind-estado = 3 or p-ind-estado = 2 then do:
       assign b-split-operac.val-perc-avanco        = 0
              b-split-operac.log-split-finaliz      = no
              b-split-operac.dat-inic-setup         = ?  
              b-split-operac.qtd-segs-inic-setup    = 0
              b-split-operac.dat-fim-setup          = ?
              b-split-operac.qtd-segs-fim-setup     = 0
              b-split-operac.dat-inic-operac        = ?  
              b-split-operac.qtd-segs-inic-operac   = 0
              b-split-operac.dat-fim-operac         = ?
              b-split-operac.qtd-segs-fim-operac    = 0
              b-split-operac.dat-produt-dispon      = ?
              b-split-operac.qtd-segs-produt-dispon = 0.

       find first b1-split-operac no-lock
            where b1-split-operac.nr-ord-produ     = b-split-operac.nr-ord-produ   and
                  b1-split-operac.num-operac-sfc   = b-split-operac.num-operac-sfc and
                  b1-split-operac.ind-estado-split > 3                           and
                  rowid(b1-split-operac)          <> rowid(b-split-operac) no-error.

       if not available b1-split-operac then do:

           find first oper-ord exclusive-lock where   
                oper-ord.nr-ord-produ     = b-split-operac.nr-ord-produ   and
                oper-ord.num-operac-sfc   = b-split-operac.num-operac-sfc no-error.

           assign oper-ord.estado         = 1 /* nao-iniciada */
                  oper-ord.qtd-aprov-sfc  = 0 
                  oper-ord.qt-refugada    = 0
                  oper-ord.qt-produzida   = 0
                  oper-ord.qtd-reptda-sfc = 0
                  oper-ord.qtd-refgda-sfc = 0
                  oper-ord.qtd-retrab-sfc = 0
                  oper-ord.dt-inireal     = ?
                  oper-ord.dt-fimreal     = ?
                  oper-ord.h-inireal      = ?
                  oper-ord.h-fimreal      = ?.
       end.
   end.

    /*** Finalizaá∆o do split ***/ 
   if p-ind-estado = 5 then do:

        /*** Geraá∆o de split para o saldo da ordem ***/
        find first oper-ord no-lock where 
             oper-ord.nr-ord-produ   = b-split-operac.nr-ord-produ and
             oper-ord.num-operac-sfc = b-split-operac.num-operac-sfc no-error.

        assign v-qtd-aberto = oper-ord.qtd-previs-operac * 
                                (100 - oper-ord.val-perc-avanco) / 100.  


        /*** Finalizaá∆o autom†tica da operaá∆o ***/
        if v-qtd-aberto <= 0 then do:
            find item-man where
                 item-man.it-codigo = oper-ord.it-codigo no-lock no-error.

            if not available item-man then do: 
                find first param-sfc no-lock.
                assign v-log-finaliz-op = param-sfc.log-finaliz-op.
            end.
            else  
                assign v-log-finaliz-op = item-man.log-finaliz-op.

            if v-log-finaliz-op then do:
                find current oper-ord exclusive-lock no-error.
                run FecharOperacao (buffer oper-ord).
            end.
            else    
                run DividirSplit (buffer b-split-operac,
                                  input 0,
                                  input 0,
                                  output table tt-bo-erro).
        end.
        /*** Geraá∆o de split pela quantidade pendente da operaá∆o ***/
        else 
            run DividirSplit (buffer b-split-operac,
                              input 0,
                              input v-qtd-aberto,
                              output table tt-bo-erro).
   end. 

   /*** Muda de finalizado para iniciado o split ***/
   if p-ind-estado = 4 and 
      b-split-operac.ind-estado-split = 5 then do: 

       find first oper-ord no-lock where 
            oper-ord.nr-ord-produ   = b-split-operac.nr-ord-produ and
            oper-ord.num-operac-sfc = b-split-operac.num-operac-sfc no-error.

       if oper-ord.estado = 3 then do:
          run inbo/boin536.p persistent set h-boin536.
          find current oper-ord exclusive-lock no-error.
          run ReabrirOperacao in h-boin536 (buffer oper-ord).
          delete procedure h-boin536.
       end.
   end.
   assign b-split-operac.ind-estado-split = p-ind-estado.

END PROCEDURE.


Procedure VerificaEstadoSplit:

    DEFINE PARAMETER BUFFER b-split-operac FOR split-operac.
    DEFINE           BUFFER bf-op-sfc      FOR op-sfc.
    
    define var h-boin533          as handle  no-undo.
    DEFINE VAR i-ind-estado-split AS INTEGER NO-UNDO.


    If b-split-operac.ind-estado-split > 3 then return "NOK":U.
    
    find bf-op-sfc no-lock 
        where bf-op-sfc.nr-ord-produ = b-split-operac.nr-ord-produ no-error.
        
    if bf-op-sfc.ind-estado-op = 1 then /*N∆o Iniciada*/ do:
       if not valid-handle(h-boin533) then 
          run inbo/boin533.p persistent set h-boin533.
          
       if valid-handle(h-boin533) then do:
          run LiberarOrdemSFC in h-boin533 (bf-op-sfc.nr-ord-produ).
          
          delete procedure h-boin533.
       end.
    end.
    if b-split-operac.ind-estado-split < 4 then do:
       Assign i-ind-estado-split = ?.
       If b-split-operac.cod-ctrab <> "" and b-split-operac.dat-progda-inic-operac <> ? then 
          Assign i-ind-estado-split = 2. /*Programado*/

       If (b-split-operac.cod-ctrab = "" and b-split-operac.dat-progda-inic-operac <> ?) or
          (b-split-operac.cod-ctrab <> "" and b-split-operac.dat-progda-inic-operac = ?) then 
          Assign i-ind-estado-split = 3. /*Liberado*/

       if i-ind-estado-split <> ? then 
          run AlterarEstadoSplit(buffer b-split-operac,
                                 input i-ind-estado-split).
    end.
    Return "OK":U.

End.

procedure AtualizaTempoPadrao:
    define parameter buffer b-oper-ord     for oper-ord.
    define parameter buffer b-split-operac for split-operac.
        
    DEFINE VARIABLE v-old-nr-lotes          AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE v-new-nr-lotes          AS DECIMAL    NO-UNDO.

    run CalcularTempoPadraoO (buffer b-oper-ord,
                              input  b-split-operac.cod-ctrab,
                              input  b-split-operac.cod-ferr-prod,
                              input  b-split-operac.qtd-previs-operac,
                              output b-split-operac.tempo-pad-maq,
                              output b-split-operac.tempo-pad-mod,
                              output b-split-operac.qtd-capac-operac).
    
    Find grup-maquina no-lock 
        where grup-maquina.gm-codigo = b-split-operac.gm-codigo no-error.
    
    Assign b-split-operac.tempo-pad-operac = if grup-maquina.ind-tip-ctrab = 4 then
                                           b-split-operac.tempo-pad-mod else 
                                           b-split-operac.tempo-pad-maq.         
    
    if grup-maquina.ind-tempo-operac = 3 and
       b-split-operac.cod-ctrab <> ""      and
       b-split-operac.qtd-carga-batch <> b-oper-ord.qtd-carga-batch then do:
    
        assign v-old-nr-lotes  = b-oper-ord.qtd-capac-operac / b-oper-ord.qtd-carga-batch
               v-old-nr-lotes  = if  round(v-old-nr-lotes,0) < (v-old-nr-lotes * 0.995) then  
                                 round(v-old-nr-lotes,0) + 1 else round(v-old-nr-lotes,0)
               v-new-nr-lotes  = b-split-operac.qtd-capac-operac / b-split-operac.qtd-carga-batch
               v-new-nr-lotes  = if  round(v-new-nr-lotes,0) < (v-new-nr-lotes * 0.995) then  
                                 round(v-new-nr-lotes,0) + 1 else round(v-new-nr-lotes,0).
    
        if v-new-nr-lotes <> ? and  v-new-nr-lotes <> 0 then
            assign b-split-operac.tempo-pad-setup      = b-split-operac.tempo-pad-setup  * 
                                                         v-new-nr-lotes / v-old-nr-lotes
                   b-split-operac.tempo-pad-operac     = b-split-operac.tempo-pad-operac * 
                                                         v-new-nr-lotes / v-old-nr-lotes
                   b-split-operac.tempo-pad-maq        = b-split-operac.tempo-pad-maq    * 
                                                         v-new-nr-lotes / v-old-nr-lotes
                   b-split-operac.tempo-pad-mod        = b-split-operac.tempo-pad-mod    * 
                                                         v-new-nr-lotes / v-old-nr-lotes
                   b-split-operac.tempo-pad-carga      = b-split-operac.tempo-pad-maq + 
                                                         b-split-operac.tempo-pad-setup.
    END.
end.

procedure CalculaDataInicioSetup:
    define parameter buffer b-split-operac for split-operac.

    DEFINE VARIABLE l-cons-parada-prog      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE l-cons-parada-real      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE d-dat-corte-parada      AS DATE       NO-UNDO.
    DEFINE VARIABLE i-qtd-segs-corte-parada AS INTEGER    NO-UNDO.
    DEFINE VARIABLE de-tempo-aux            AS DECIMAL    NO-UNDO.
    
    DEFINE VARIABLE dt-dat-progda-inic-operac      AS DATE   NO-UNDO.    
    DEFINE VARIABLE de-qtd-segs-progdo-inic-operac AS DEC    NO-UNDO.
    DEFINE VARIABLE h-boin469e                     AS HANDLE NO-UNDO.

    Run inbo/boin469e.p PERSISTENT SET h-boin469e.
    
   Assign l-cons-parada-prog      = yes
          l-cons-parada-real      = yes
          d-dat-corte-parada      = today     
          i-qtd-segs-corte-parada = time.


   Assign b-split-operac.dat-progda-inic-setup       = b-split-operac.dat-progda-inic-operac
          b-split-operac.qtd-segs-progdo-inic-setup  = b-split-operac.qtd-segs-progdo-inic-operac.
   
   assign dt-dat-progda-inic-operac      = ?
          de-qtd-segs-progdo-inic-operac = ?
          de-tempo-aux                   = (b-split-operac.tempo-pad-setup / 3600). 
   
   RUN piCalculaDataHoraTempo IN h-boin469e
                            (INPUT        b-split-operac.cod-area-produc,        
                             INPUT        b-split-operac.gm-codigo,       
                             INPUT        b-split-operac.cod-ctrab,       
                             INPUT        ?,
                             INPUT-OUTPUT dt-dat-progda-inic-operac,
                             INPUT-OUTPUT de-qtd-segs-progdo-inic-operac,
                             INPUT-OUTPUT b-split-operac.dat-progda-inic-setup, 
                             INPUT-OUTPUT b-split-operac.qtd-segs-progdo-inic-setup, 
                             INPUT-OUTPUT de-tempo-aux,      
                             INPUT        l-cons-parada-prog,
                             INPUT        l-cons-parada-real,
                             INPUT        d-dat-corte-parada,     
                             INPUT        i-qtd-segs-corte-parada).
   
   ASSIGN b-split-operac.dat-progda-inic-operac      = dt-dat-progda-inic-operac
          b-split-operac.qtd-segs-progdo-inic-operac = de-qtd-segs-progdo-inic-operac.
   
   Delete procedure h-boin469e.
   
end.

/***********

Regras para implantar no futuro

    Mudanáa de n∆o iniciado para programado, compromete capacidade do 
    centro de trabalho ou grupo de m†quina

    /*** Alocaá∆o de capacidade devido a programaá∆o ***/
        run prgman/omg/omg034za.py (Input split-operac.cod-grp-maq,
                                    Input split-operac.cod-area-produc,
                                    Input split-operac.qtd-capac-operac,
                                    Input split-operac.dat-progda-inic-prepar,
                                    Input split-operac.qtd-segs-progdo-inic-prepar,
                                    Input split-operac.dat-progda-fim-limpeza,
                                    Input split-operac.qtd-segs-progdo-fim-limpeza,
                                    Input "1",
                                    Input param-geral-sfc.qtd-tempo-aprox) /*prg-fnc-perf-capac-grp-maq-area*/.

        /* ** Atualiza datas programadas para a operaá∆o da ordem ***/
        run pi-atualiza-programa-operac-op-sfc /*pi-atualiza-programa-operac-op-sfc*/.

        Pode gerar erros de programaá∆o na ordem de produá∆o.


    Mudanáa de programado para n∆o iniciado descarga capacidade alocada para o 
    centro de trabalho ou grupo de m†quina

    Elimina conflitos de programaá∆o (erros na ordem)


   /*** Se o split foi programado, baixa capacidade alocada na programaá∆o ***/
            run prgman/omg/omg034za.py (Input split-operac.cod-grp-maq,
                                        Input split-operac.cod-area-produc,
                                        Input split-operac.qtd-capac-operac,
                                        Input split-operac.dat-progda-inic-prepar,
                                        Input split-operac.qtd-segs-progdo-inic-prepar,
                                        Input split-operac.dat-progda-fim-limpeza,
                                        Input split-operac.qtd-segs-progdo-fim-limpeza,
                                        Input "2",
                                        Input param-geral-sfc.qtd-tempo-aprox) /*prg-fnc-perf-capac-grp-maq-area*/.


    /*** Se a operaá∆o n∆o possui centro de trabalho espec°fico, tirar o centro de trabalho do split ***/
        if  operac-op-sfc.cod-ctrab <> split-operac.cod-ctrab
        then do:
           assign split-operac.cod-ctrab = operac-op-sfc.cod-ctrab.
        end /* if */.


    end /* if */.


**********/

