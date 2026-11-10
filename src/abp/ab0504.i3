/********************************************************************************
**
**  Include: abp/ab0504.i2
**
**  Imprime Relat¢rio por Modelo
**
********************************************************************************/
procedure pi-modelo:
 

assign cControle = "".
for each mab-eqpto fields (cc-codigo cod-estab cod-eqpto cod-grp-eqpto cod-sit-eqpto
                           cod-model cd-tag ep-codigo cod-estrut-mec idi-tip-eqpto idi-tip-propriet)
    WHERE mab-eqpto.cod-eqpto         >= tt-param.c-eqpto-ini 
    and   mab-eqpto.cod-eqpto         <= tt-param.c-eqpto-fim
    and   mab-eqpto.ep-codigo         >= tt-param.c-empresa-ini 
    and   mab-eqpto.ep-codigo         <= tt-param.c-empresa-fim 
    and   mab-eqpto.cod-estabel       >= tt-param.c-estabelec-ini 
    and   mab-eqpto.cod-estabel       <= tt-param.c-estabelec-fim
    and   mab-eqpto.cod-grp-eqpto     >= tt-param.c-grupo-ini
    and   mab-eqpto.cod-grp-eqpto     <= tt-param.c-grupo-fim
    and   mab-eqpto.cd-tag            >= tt-param.c-tag-ini  
    and   mab-eqpto.cd-tag            <= tt-param.c-tag-fim
    and   mab-eqpto.cod-model         >= tt-param.c-modelo-ini 
    and   mab-eqpto.cod-model         <= tt-param.c-modelo-fim
    and   mab-eqpto.cod-estrut-mec    >= tt-param.c-estrut-mec-ini
    and   mab-eqpto.cod-estrut-mec    <= tt-param.c-estrut-mec-fim    
    and ((mab-eqpto.idi-tip-eqpto     = 1 and tt-param.l-EqptosMot) 
    or   (mab-eqpto.idi-tip-eqpto     = 2 and tt-param.l-EqptosNMot))
    and ((mab-eqpto.idi-tip-propriet  = 1 and tt-param.l-EqptosPro)
    or   (mab-eqpto.idi-tip-propriet  = 2 and tt-param.l-EqptosTerc)) no-lock,
        
    each  mab-sit-eqpto fields (cod-sit-eqpto idi-tip)
    where mab-sit-eqpto.cod-sit-eqpto = mab-eqpto.cod-sit-eqpto
    and ((mab-sit-eqpto.idi-tip       = 1 and tt-param.l-EqptosAtivos) 
    or   (mab-sit-eqpto.idi-tip       = 2 and tt-param.l-EqptosInativos)) no-lock,
    
    each mab-movto-event fields (cod-evento cod-sub-sist cd-tipo dat-inicial dat-final cod-eqpto 
                                 ep-codigo num-docto val-event ep-codigo-matr cod-estabel-matr cod-matr)
    where mab-movto-event.ep-codigo         =   mab-eqpto.ep-codigo
    and   mab-movto-event.cod-eqpto         =   mab-eqpto.cod-eqpto  
    and   mab-movto-event.cod-evento       >=   tt-param.c-evento-ini 
    and   mab-movto-event.cod-evento       <=   tt-param.c-evento-fim
    and   mab-movto-event.cod-sub-sist     >=   tt-param.c-sub-sist-ini
    and   mab-movto-event.cod-sub-sist     <=   tt-param.c-sub-sist-fim 
    and   mab-movto-event.cd-tipo          >=   tt-param.c-manut-ini 
    and   mab-movto-event.cd-tipo          <=   tt-param.c-manut-fim 
    and   mab-movto-event.dat-inicial      >=   tt-param.d-dat-inicial-ini 
    and   mab-movto-event.dat-inicial      <=   tt-param.d-dat-inicial-fim
    and   mab-movto-event.ep-codigo-matr   >=   tt-param.c-empresa-matr-ini
    and   mab-movto-event.ep-codigo-matr   <=   tt-param.c-empresa-matr-fim
    and   mab-movto-event.cod-estabel-matr >=   tt-param.c-estabel-matr-ini
    and   mab-movto-event.cod-estabel-matr <=   tt-param.c-estabel-matr-fim
    and   mab-movto-event.cod-matr         >=   tt-param.c-cod-matr-ini
    and   mab-movto-event.cod-matr         <=   tt-param.c-cod-matr-fim 
&IF DEFINED(bf_mnt_ems206b) &THEN
    and   mab-movto-event.cod-unid-negoc   >=   tt-param.c-cod-unid-negoc-ini
    and   mab-movto-event.cod-unid-negoc   <=   tt-param.c-cod-unid-negoc-fim
&ENDIF
    no-lock,
                    
    each mab-event fields (cod-evento cod-grp-event des-evento) 
    where mab-event.cod-evento = mab-movto-event.cod-evento no-lock,

    each mab-grp-event fields (cod-grp-event idi-tip)
    where mab-grp-event.cod-grp-event = mab-event.cod-grp-event
    and ((mab-grp-event.idi-tip       = 1 and tt-param.l-ManutOleo) 
    or   (mab-grp-event.idi-tip       = 2 and tt-param.l-ManutFiltros )
    or   (mab-grp-event.idi-tip       = 3 and tt-param.l-ManutMec)
    or   (mab-grp-event.idi-tip       = 4 and tt-param.l-MotivoParada)
    or   (mab-grp-event.idi-tip       = 5 and tt-param.l-Custos)
    or   (mab-grp-event.idi-tip       = 6 and tt-param.l-Outros)) no-lock
    break  by mab-eqpto.cod-model
           by mab-eqpto.ep-codigo
           by mab-eqpto.cod-eqpto:

    if tt-param.l-EventEncerr = false and mab-movto-event.dat-final <> ? then next.

    FOR LAST  mab-histor-ativid NO-LOCK
        WHERE mab-histor-ativid.ep-codigo = mab-eqpto.ep-codigo
        AND   mab-histor-ativid.cod-eqpto = mab-eqpto.cod-eqpto
        AND   mab-histor-ativid.cc-codigo = mab-eqpto.cc-codigo:
    END.
        
    IF NOT AVAIL mab-histor-ativid THEN DO:
        ASSIGN cCCCodigo = mab-eqpto.cc-codigo.
    END.
    ELSE DO:
        ASSIGN cCCCodigo = mab-histor-ativid.cc-codigo.
    END.

    IF cCCCodigo < tt-param.c-custo-ini
    OR cCCCodigo > tt-param.c-custo-fim THEN NEXT.

    if mab-movto-event.dat-final <> ?
        and (mab-movto-event.dat-final  <  tt-param.d-dat-final-ini
        OR   mab-movto-event.dat-final  >  tt-param.d-dat-final-fim ) then next. 
    
    for first mab-model fields (cod-model des-model) no-lock
        where mab-model.cod-model = mab-eqpto.cod-model:
    end. 
    
    for first mab-sub-sist fields (cod-sub-sist des-sub-sist)
        where mab-sub-sist.cod-sub-sist = mab-movto-event.cod-sub-sist no-lock:
        assign cSubSist  =    mab-sub-sist.des-sub-sist.
    end.
        
    if cControle <>  mab-eqpto.cod-model then do:
        if cControle <> "" and  tt-param.l-insere = yes then do:
            page.
        end.
        else do:
            put skip (1).
        end.
            
        display c-modelo
                mab-model.cod-model       
                mab-model.des-model with stream-io frame f-modelo.
    end.

    assign iEmp      =  mab-movto-event.ep-codigo
           cEqpto    =  mab-movto-event.cod-eqpto      
           cEvento   =  mab-event.des-evento           
           iDoc      =  mab-movto-event.num-docto      
           dInicial  =  mab-movto-event.dat-inicial    
           dFinal    =  mab-movto-event.dat-final     
           iValor    =  mab-movto-event.val-evento
           cControle =  mab-eqpto.cod-model.
    
    /* display para impress∆o do relat¢rio */   
    display  iEmp
             cEqpto  
             cEvento 
             cSubSist
             iDoc  at 82   
             dInicial
             dFinal  
             iValor  
             with stream-io frame f-resumido1.
             down with stream-io frame f-resumido1.

END.
put skip(1).

return 'OK'.

end procedure.
/* FIM */
