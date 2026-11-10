/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN534A 2.00.00.000}  /*** 010000 ***/
/*****************************************************************************
** Copyright DATASUL S.A. (1994)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so' podera ser feita mediante
** autorizacao expressa.
**
**  Programa: BOIN534A
**  Objetivo: Gera‡Æo do diagrama de carga do centro de trabalho
**
*****************************************************************************/

{inbo/boin534a.i} /* Defini‡Æo da temp-table */

def var v-cod-calend as character no-undo.
def var v-dat-calcul as date      no-undo.

PROCEDURE GerarDiagramaCargaCtrab:
      
    def input param p-cod-ctrab   as char  format "x(16)"       no-undo.
    def input param p-dat-refer-1 as date  format "99/99/9999"  no-undo.
    def input param p-dat-refer-2 as date  format "99/99/9999"  no-undo.
    def input-output param table for tt-carga-ctrab.
    
    /* Limpeza de registros */
    for each tt-carga-ctrab
        where tt-carga-ctrab.cod-ctrab = p-cod-ctrab
          and tt-carga-ctrab.data     >= p-dat-refer-1
          and tt-carga-ctrab.data     <= p-dat-refer-2 exclusive-lock:
    
        delete tt-carga-ctrab.
    end.         
    
    find ctrab
        where ctrab.cod-ctrab = p-cod-ctrab no-lock no-error.
    
    /* procura calendario do grupo de maquina */
    find grup-maquina
        where grup-maquina.gm-codigo = ctrab.gm-codigo no-lock no-error.
    
    if  not can-find (first calen-gener
                      where calen-gener.cd-calen = grup-maquina.cd-calen) then do:
    
        find last param-crp no-lock no-error.
        assign v-cod-calend = param-crp.cod-calend-crp.
    end.     
    else
        assign v-cod-calend = grup-maquina.cd-calen.
        
    /*  Preparacao do grafico de carga ctrab */
    
    block1:
    do  v-dat-calcul = p-dat-refer-1 to p-dat-refer-2:
    
        find calen-data
            where calen-data.cd-calen = v-cod-calend
              and calen-data.data     = v-dat-calcul no-lock no-error.
    
        /* se a data nao ‚ encontrada ou nÆo existe a data £til - ser  gerado o
           gr fico de carga */
        
        if  not avail calen-data
        or (calen-data.tipo-dia <> 2
        and calen-data.tipo-dia <> 3) then do:
    
            run pi-gerar-graf-carg-grp-maq (Input v-dat-calcul,
                                            input-output table tt-carga-ctrab).
        end.
    end.
END PROCEDURE.

/*****************************************************************************
** Procedure Interna.....: pi-gerar-graf-carg-grp-maq
** Objetivo..............: Gera registro de carga para o grupo de maquina numa
                           determinada data
** Parametros............: data de carga
*****************************************************************************/

PROCEDURE pi-gerar-graf-carg-grp-maq:

    def input param p-dat-carg as date format "99/99/9999" no-undo.
    def input-output param table for tt-carga-ctrab.

    def buffer b-perf-capac-ctrab for perf-capac-ctrab.

    def var v-qtd-hora-interv as decimal no-undo.
    def var v-qtd-hora-inic   as decimal no-undo.
    def var v-qtd-hora-fim    as decimal no-undo.
    def var v-num-ponto-ini   like perf-capac-ctrab.val-refer-perf no-undo.
    def var v-num-ponto-fim   like perf-capac-ctrab.val-refer-perf no-undo.
    def var de-val-refer-perf like perf-capac-ctrab.val-refer-perf no-undo.
    def var de-hora           as int  no-undo.
    def var c-cod-area        as char no-undo.
    def var c-gm-codigo       as char no-undo.
    def var h-boin469b        as handle no-undo. /* Ao testar o programa, verificar que a inicializa‡Æo da BO
                                                    dever  ser feita numa procedure separada, bem como a 
                                                    finaliza‡Æo, pois ocorre erro se a inicializa‡Æo for feita
                                                    aqui dentro da procedure - Solange */

    run inbo/boin469b.p persistent set h-boin469b.

    assign de-hora = time.
    run pi-converte-data-segs-valor (input p-dat-carg,
                                     input de-hora,
                                     output v-num-ponto-ini).

    run pi-converte-data-segs-valor (input p-dat-carg,
                                     input de-hora + 1,
                                     output v-num-ponto-fim).

/********    
    assign v-num-ponto-ini = year(p-dat-carg) * 10000 + month(p-dat-carg) * 100 + day(p-dat-carg)
           v-num-ponto-fim = v-num-ponto-ini + 1.  
***********/

    /* PROCEDIMENTO DE CRIACAO DE REGISTRO DE CARGA GRUPO MAQUINA */

    find tt-carga-ctrab
        where tt-carga-ctrab.cod-ctrab = ctrab.cod-ctrab
          and tt-carga-ctrab.data      = p-dat-carg exclusive no-error.

    if  not avail tt-carga-ctrab then do:
        create tt-carga-ctrab.
        assign tt-carga-ctrab.cod-ctrab = ctrab.cod-ctrab 
               tt-carga-ctrab.data      = p-dat-carg.
    end.

    assign tt-carga-ctrab.hrs-disp   = 0
           tt-carga-ctrab.hrs-prog   = 0
           tt-carga-ctrab.hrs-livres = 0.
   
    find last perf-capac-ctrab
        where perf-capac-ctrab.cod-ctrab       = ctrab.cod-ctrab
          and perf-capac-ctrab.val-refer-perf <= v-num-ponto-ini no-lock no-error.
    
    find first b-perf-capac-ctrab
         where b-perf-capac-ctrab.cod-ctrab      = ctrab.cod-ctrab
           and b-perf-capac-ctrab.val-refer-perf > v-num-ponto-ini no-lock no-error.
        
    if  not avail perf-capac-ctrab then do:
        run pi-converte-data-segs-valor (input today,
                                         input de-hora,
                                         output de-val-refer-perf).
        create perf-capac-ctrab.
        assign perf-capac-ctrab.cod-ctrab        = ctrab.cod-ctrab
               perf-capac-ctrab.val-refer-perf   = de-val-refer-perf
               perf-capac-ctrab.dat-ponto-perfil = today
               perf-capac-ctrab.hra-ponto-perfil = de-hora
               perf-capac-ctrab.val-capac-carg   = ctrab.qtd-capac-ctrab
               perf-capac-ctrab.val-capac-resid  = ctrab.qtd-capac-ctrab.

/***************
        create perf-capac-ctrab.
        assign perf-capac-ctrab.cod-ctrab        = ctrab.cod-ctrab
               perf-capac-ctrab.val-refer-perf   = 0
               perf-capac-ctrab.dat-ponto-perfil = today
               perf-capac-ctrab.hra-ponto-perfil = 0
               perf-capac-ctrab.val-capac-carg   = 0
               perf-capac-ctrab.val-capac-resid  = 0.
****************/

    end.
        
    blk-integra:
    repeat:
        if  avail b-perf-capac-ctrab
        and b-perf-capac-ctrab.val-refer-perf < v-num-ponto-fim then 
            assign v-qtd-hora-fim = b-perf-capac-ctrab.hra-ponto-perfil. 
        else     
            assign v-qtd-hora-fim  = 86400.
        
        if  perf-capac-ctrab.val-refer-perf < v-num-ponto-ini then 
            assign v-qtd-hora-inic = 0.
        else
            assign v-qtd-hora-inic = perf-capac-ctrab.hra-ponto-perfil.
    
        assign c-cod-area   = ?
               c-gm-codigo  = ?.
        run CalcularTemposCtrab in h-boin469b (input-output c-cod-area,
                                               input-output c-gm-codigo,
                                               input        perf-capac-ctrab.cod-ctrab,
                                               input-output v-cod-calend,
                                               input-output p-dat-carg,
                                               input-output v-qtd-hora-fim,
                                               input-output p-dat-carg,
                                               input-output v-qtd-hora-inic,
                                               input-output v-qtd-hora-interv).
    
/****   run inbo/boin469a.p (Input perf-capac-ctrab.cod-ctrab,
                             Input v-cod-calend,
                             input-output p-dat-carg,
                             input-output v-qtd-hora-fim,
                             input-output p-dat-carg,
                             input-output v-qtd-hora-inic,
                             input-output v-qtd-hora-interv).
****/
        assign tt-carga-ctrab.hrs-prog   = tt-carga-ctrab.hrs-prog +
                                           v-qtd-hora-interv * (perf-capac-ctrab.val-carg-manut +
                                                                perf-capac-ctrab.val-carg-op-plan)
               tt-carga-ctrab.hrs-disp   = tt-carga-ctrab.hrs-disp + 
                                           v-qtd-hora-interv * perf-capac-ctrab.val-capac-carg
               tt-carga-ctrab.hrs-livres = tt-carga-ctrab.hrs-disp - tt-carga-ctrab.hrs-prog.
        
       if  not available b-perf-capac-ctrab
       or  b-perf-capac-ctrab.val-refer-perf > v-num-ponto-fim then
           leave blk-integra.
        
       find perf-capac-ctrab
           where rowid(perf-capac-ctrab) = rowid(b-perf-capac-ctrab) no-lock no-error.
                
       find next b-perf-capac-ctrab
           where b-perf-capac-ctrab.cod-ctrab = ctrab.cod-ctrab no-lock no-error.
    end.
    
    /* Elimina pontos de carga zerada */
    
    if  tt-carga-ctrab.hrs-prog   = 0
    and tt-carga-ctrab.hrs-disp   = 0
    and tt-carga-ctrab.hrs-livres = 0 then
        delete tt-carga-ctrab.
        
    delete procedure h-boin469b.

END PROCEDURE.

{sfc/sf9002.i} 
