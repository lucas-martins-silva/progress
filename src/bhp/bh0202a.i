    /* ----------------------------------------------------------------------- */
    /* --------------------------- Importa Pedidos --------------------------- */
    /* ----------------------------------------------------------------------- */
    
    {utp/ut-liter.i Importando_Pedidos}.
    assign c-acompanha-aux3 = trim(return-value)
           i-cont-aux3      = 0.
                 
    Blk_PedVenda:
    for each hisdis.ped-venda where 
             hisdis.ped-venda.dt-entrega >= tt-param.da-per-corte AND 
            (hisdis.ped-venda.cod-sit-ped = 3 or                              /* Atendido Total */
             hisdis.ped-venda.cod-sit-ped = 6) exclusive-lock transaction:    /* Cancelado      */     
             
             assign i-cont-aux3 = i-cont-aux3 + 1.
             run pi-acompanhar in h-acomp (input c-acompanha-aux3 + ": " + string(i-cont-aux3)).

             /* ----------------- Importa hisdis.ped-item/hisdis.ped-ent/hisdis.his-ped-ent ----------------- */
             {utp/ut-liter.i Itens}.
             assign c-acompanha-aux4 = c-acompanha-aux3 + "/" + trim(return-value) + ": ".
                    i-cont-aux4      = 0.
             for each hisdis.ped-item of hisdis.ped-venda exclusive-lock:
             
                      assign i-cont-aux4 = i-cont-aux4 + 1.
                      run pi-acompanhar in h-acomp (input c-acompanha-aux4 + string(i-cont-aux3) + "/" + string(i-cont-aux4)).
                                                
                      {utp/ut-liter.i Entregas}.
                      assign c-acompanha-aux5 = c-acompanha-aux3 + "/" + trim(return-value) + ": ".
                             i-cont-aux5      = 0.
                    
                      find first tt-estat-modulo where tt-estat-modulo.i-sequencia = 14 no-error.                             
                      for each hisdis.ped-ent of hisdis.ped-item exclusive-lock:
                      
                          assign i-cont-aux5 = i-cont-aux5 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux5 + string(i-cont-aux3) + "/" + string(i-cont-aux5)).
                                            
                          run bhp/bh0202b.p ("ped-ent", rowid(hisdis.ped-ent)).

                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 14
                                     tt-erro-bh.r-rowid  = ROWID(hisdis.ped-ent).
                              UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                          END.

                          on delete of hisdis.ped-ent override do: end.
                          delete hisdis.ped-ent validate(true,"").
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                      end.

                      {utp/ut-liter.i Hist_Entr}.
                      assign c-acompanha-aux5 = c-acompanha-aux3 + "/" + trim(return-value) + ": ".
                             i-cont-aux5      = 0.
                             
                      find first tt-estat-modulo where tt-estat-modulo.i-sequencia = 15 no-error.                             
                      for each hisdis.his-ped-ent of hisdis.ped-item exclusive-lock:

                          assign i-cont-aux5 = i-cont-aux5 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux5 + string(i-cont-aux3) + "/" + string(i-cont-aux5)).
                                            
                          run bhp/bh0202b.p ("his-ped-ent", rowid(hisdis.his-ped-ent)).

                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 14
                                     tt-erro-bh.r-rowid  = ROWID(hisdis.ped-ent).
                              UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                          END.

                          on delete of hisdis.his-ped-ent override do: end.
                          delete hisdis.his-ped-ent validate(true,"").
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                      end.
                   
                      find first tt-estat-modulo where tt-estat-modulo.i-sequencia = 13 no-error.                             
                   
                      run bhp/bh0202b.p ("ped-item", rowid(hisdis.ped-item)).

                      IF  RETURN-VALUE = "NOK":U THEN DO:
                          CREATE tt-erro-bh.
                          ASSIGN tt-erro-bh.i-tabela = 13
                                 tt-erro-bh.r-rowid  = ROWID(hisdis.ped-item).
                          UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                      END.

                      on delete of hisdis.ped-item override do: end.
                      delete hisdis.ped-item validate(true,"").
                      assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 
             end.
             
             /* -------------------------- Importa hisdis.ped-repre --------------------------- */
             {utp/ut-liter.i Representates}.
             assign c-acompanha-aux4 = c-acompanha-aux3 + "/" + trim(return-value) + ": ".
                    i-cont-aux4      = 0.
                    
             find first tt-estat-modulo where tt-estat-modulo.i-sequencia = 16 no-error.
             for each hisdis.ped-repre where hisdis.ped-repre.nr-pedido = hisdis.ped-venda.nr-pedido EXCLUSIVE-LOCK:
             
                 assign i-cont-aux4 = i-cont-aux4 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux4 + string(i-cont-aux3) + "/" + string(i-cont-aux4)).
                          
                 run bhp/bh0202b.p ("ped-repre", rowid(hisdis.ped-repre)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                    CREATE tt-erro-bh.
                    ASSIGN tt-erro-bh.i-tabela = 16
                           tt-erro-bh.r-rowid  = ROWID(hisdis.ped-repre).
                    UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                END.

                 on delete of hisdis.ped-repre override do: end.
                 delete hisdis.ped-repre validate(true,"").
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                     
             end.
             
             /* --------------------------- Importa hisdis.cond-ped --------------------------- */
             {utp/ut-liter.i Cond_Pagto_Esp}.
             assign c-acompanha-aux4 = c-acompanha-aux3 + "/" + trim(return-value) + ": ".
                    i-cont-aux4      = 0.
                    
             find first tt-estat-modulo where tt-estat-modulo.i-sequencia = 18 no-error.
             for each hisdis.cond-ped where hisdis.cond-ped.nr-pedido = hisdis.ped-venda.nr-pedido EXCLUSIVE-LOCK:
             
                 assign i-cont-aux4 = i-cont-aux4 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux4 + string(i-cont-aux3) + "/" + string(i-cont-aux4)).                          

                 run bhp/bh0202b.p ("cond-ped", rowid(hisdis.cond-ped)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 18
                            tt-erro-bh.r-rowid  = ROWID(hisdis.cond-ped).
                     UNDO Blk_PedVenda, NEXT Blk_PedVenda.
                 END.

                 on delete of hisdis.cond-ped override do: end.
                 delete hisdis.cond-ped validate(true,"").
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 
             end.

             find first tt-estat-modulo where tt-estat-modulo.i-sequencia = 12 no-error.
             
             run bhp/bh0202b.p ("ped-venda", rowid(hisdis.ped-venda)).
                           
             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 12
                        tt-erro-bh.r-rowid  = ROWID(hisdis.ped-venda).
                 UNDO Blk_PedVenda, NEXT Blk_PedVenda.
             END.

             /* ------------------------- Cria Tabela de Locks ------------------------- */
                find first his-ped-venda where
                           his-ped-venda.nr-pedido  = hisdis.ped-venda.nr-pedido and
                           his-ped-venda.nr-pedcli  = hisdis.ped-venda.nr-pedcli and
                           his-ped-venda.nome-abrev = hisdis.ped-venda.nome-abrev EXCLUSIVE-LOCK no-error.
                if avail his-ped-venda then delete his-ped-venda validate(true,"").
             /* ------------------------------------------------------------------------ */ 
             
             on delete of hisdis.ped-venda override do: end.
             delete hisdis.ped-venda validate(true,"").
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.    
