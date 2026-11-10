/*****************************************************************************
** Procedure Interna.....: pi-determina-fim-evento
** Objetivo..............: Determinar a data e hora final de um evento definido
**                         que possui um tempo t, inicia num momento determinado
**                         dat1 e hra1, e considera padroes de turno e
**                         calendario definidos.
** Parametros ...........: 
*****************************************************************************/
PROCEDURE pi-determina-fim-evento:

    def input        param p-cod-area         as char    format "x(12)"          no-undo.
    def input        param p-cod-grp-maq      as char    format "x(9)"           no-undo.
    def input        param p-cod-ctrab        as char    format "x(16)"          no-undo.
    def input        param p-cod-calend-sfc   as char    format "x(8)"           no-undo.
    def output       param p-dat-fim          as date    format "99/99/9999"     no-undo.
    def output       param p-qtd-segs-fim     as decimal format ">>,>>9"         no-undo.
    def input        param p-dat-inic         as date    format "99/99/9999"     no-undo.
    def input        param p-qtd-segs-inic    as decimal format ">>,>>9"         no-undo.
    def input        param p-qtd-tempo-util   as decimal format ">>,>>9.9999"    decimals 4 no-undo.
    
    def var i-turno                   as integer no-undo.
    def var i-aux-qtd-segs-inic-turno as integer no-undo.
    def var d-dat-aux                 as date    no-undo.
    
    if  p-qtd-tempo-util <= 0 then do:
        assign p-dat-fim      = p-dat-inic
               p-qtd-segs-fim = p-qtd-segs-inic.
        return.
    end.

    /* inicializa paraƒmetros a serem calculados */
    assign v-dat-calcul       = p-dat-inic
           v-qtd-segs-calcul  = p-qtd-segs-inic
           p-qtd-tempo-util   = p-qtd-tempo-util * 3600.
           
    /*Inicia validade do turno para buscar o novo turno*/
    assign v-dat-fim-valid = 01/01/1800.
                              
    /* inicia loop para calculo da data */
    calculo-data:
    repeat:
        if  v-dat-fim-valid <= v-dat-calcul then do:
            run pi-gera-tt-turno (input p-cod-area,
                                  input p-cod-grp-maq,
                                  input p-cod-ctrab,
                                  input v-dat-calcul,
                                  output v-dat-inic-valid,
                                  output v-dat-fim-valid).
        end.

        assign v-num-dia-sema   = weekday(v-dat-calcul).
        
        /***********************************************************************
               Troca de Turno e Inicio de turno no dia anterior
        Este tratamento abaixo se faz necessario devido a mudan‡Æo de turno, quando temos 
        um turno terminado no outro dia justamente no dia final de sua validade (grp x modelo), 
        desta forma:
        Modelo 1                 Modelo 2                  
        Turno 1 - 08:00 - 16:00  Turno 1 - 22:00 - 06:00   
                                 Turno 2 - 06:00 - 14:00   
                                 Turno 3 - 14:00 - 20:00   
        Validades do Turno
        Modelo 1 01/01/2000 at‚ 20/02/2008
        Modelo 2 20/02/2008 at‚ 31/12/9999
        Calculando Datas e Hora de Fim a partir de 18/02/2008 …s 08:00 dura‡Æo de 20 horas
        
        Montagem corretas dos turnos
        dia 18
        08:00 - 16:00                                                 = 8 horas
        dia 19                                                        
        08:00 - 16:00 / 22:00 - 00:00                                 = 10 horas
        dia 20
        00:00 - 06:00 / 06:00 - 14:00 / 14:00 - 20:00 / 22:00 - 00:00 = 2 horas
        Nesta situa‡Æo a data de fim correta ‚ dia 20/02/2008 …s 02:00
        **************************************************************************
        Antes ele tratava o dia 19 da seguinte maneira
        dia 19
        08:00 - 16:00                                                 = 8 horas
        dia 20
        00:00 - 06:00 / 06:00 - 14:00 / 14:00 - 20:00 / 22:00 - 00:00 = 4 horas
        Nesta situa‡Æo a data de fim gerada era dia 20/02/2008 …s 04:00
        **************************************************************************/
        if v-dat-calcul = v-dat-inic-valid then do:
        
            run pi-gera-tt-turno (input p-cod-area,
                                  input p-cod-grp-maq,
                                  input p-cod-ctrab,
                                  input v-dat-calcul - 1,
                                  output v-dat-inic-valid,
                                  output v-dat-fim-valid).

           for each tt-turno-semana
               where tt-turno-semana.num-dia-sema = weekday(v-dat-calcul):
               
               /*Filtra registros desnecessarios*/
               if v-dat-calcul = p-dat-inic and tt-turno-semana.qtd-segs-fim-turno < p-qtd-segs-inic then next.
               
               /*Determina dia real para descobrir se ‚ util ou nÆo*/
               if tt-turno-semana.num-dia-turno <> 0 then
                   assign i-turno   = (tt-turno-semana.num-dia-turno - tt-turno-semana.num-dia-sema)
                          d-dat-aux = v-dat-calcul + i-turno.
               else
                   assign d-dat-aux = v-dat-calcul.
                   
               if d-dat-aux >= v-dat-calcul then next.
                       
               /*Caso o dia real do turno seja posterior a data de validade do turno o
               mesmo deve ser desconsiderado.
               Ex: Turno 3 22:00 - 06:00  | Numa situa‡Æo em que 20/02 seja a data de termino do modelo de turno
                   Turno 1 06:00 - 14:00  | o intervalo das 22:00 - 00:00 que pertence ao turno 3 do dia 21 nÆo 
                   Turno 2 14:00 - 22:00  | deve ser considerado
               */
               if d-dat-aux >= v-dat-fim-valid then next.
               if d-dat-aux <  v-dat-inic-valid then next.

               find calen-data no-lock
                    where calen-data.cd-calen = p-cod-calend-sfc
                      and calen-data.data     = d-dat-aux no-error.
               
               /*‚ dia util se nÆo o registro e desconsiderado*/
               if avail calen-data         and 
                  calen-data.tipo-dia <> 1 then next.   
               
               /*Calculo para determinar data*/   
               if v-dat-calcul = p-dat-inic then
                  assign i-aux-qtd-segs-inic-turno = max(tt-turno-semana.qtd-segs-inic-turno,p-qtd-segs-inic).
               else
                  assign i-aux-qtd-segs-inic-turno = tt-turno-semana.qtd-segs-inic-turno.
        
               assign p-qtd-tempo-util = p-qtd-tempo-util - (tt-turno-semana.qtd-segs-fim-turno - i-aux-qtd-segs-inic-turno).
               if p-qtd-tempo-util <= 0 then do:
                  assign p-dat-fim      = v-dat-calcul
                         p-qtd-segs-fim = tt-turno-semana.qtd-segs-fim-turno - abs(p-qtd-tempo-util).
                  leave calculo-data.       
               end.
           end.
        end.
        /*******************************************************************
                        Tratamento para o dia normal
        ********************************************************************/
        if  v-dat-fim-valid <= v-dat-calcul then do:
            run pi-gera-tt-turno (input p-cod-area,
                                  input p-cod-grp-maq,
                                  input p-cod-ctrab,
                                  input v-dat-calcul,
                                  output v-dat-inic-valid,
                                  output v-dat-fim-valid).
        end.
        
        for each tt-turno-semana
            where tt-turno-semana.num-dia-sema = v-num-dia-sema:
            
            /*Filtra registros desnecessarios*/
            if v-dat-calcul = p-dat-inic and tt-turno-semana.qtd-segs-fim-turno < p-qtd-segs-inic then next.
            
            /*Determina dia real para descobrir se ‚ util ou nÆo*/
            if tt-turno-semana.num-dia-turno <> 0 then
                assign i-turno   = (tt-turno-semana.num-dia-turno - tt-turno-semana.num-dia-sema)
                       d-dat-aux = v-dat-calcul + i-turno.
            else
                assign d-dat-aux = v-dat-calcul.
            
            /*Caso o dia real do turno seja posterior a data de validade do turno o
            mesmo deve ser desconsiderado.
            Ex: Turno 3 22:00 - 06:00  | Numa situa‡Æo em que 20/02 seja a data de termino do modelo de turno
                Turno 1 06:00 - 14:00  | o intervalo das 22:00 - 00:00 que pertence ao turno 3 do dia 21 nÆo 
                Turno 2 14:00 - 22:00  | deve ser considerado
            */
            if d-dat-aux >= v-dat-fim-valid then next.
            if d-dat-aux <  v-dat-inic-valid then next.
                       
            find calen-data no-lock
                 where calen-data.cd-calen = p-cod-calend-sfc
                   and calen-data.data     = d-dat-aux no-error.
            /*‚ dia util se nÆo o registro e desconsiderado*/
            if avail calen-data         and 
               calen-data.tipo-dia <> 1 then next.   
            
            /*Calculo para determinar data*/
            if v-dat-calcul = p-dat-inic then
               assign i-aux-qtd-segs-inic-turno = max(tt-turno-semana.qtd-segs-inic-turno,p-qtd-segs-inic).
            else
               assign i-aux-qtd-segs-inic-turno = tt-turno-semana.qtd-segs-inic-turno.

            assign p-qtd-tempo-util = p-qtd-tempo-util - (tt-turno-semana.qtd-segs-fim-turno - i-aux-qtd-segs-inic-turno).
            
            if p-qtd-tempo-util <= 0 then do:
               assign p-dat-fim      = v-dat-calcul      
                      p-qtd-segs-fim = tt-turno-semana.qtd-segs-fim-turno - abs(p-qtd-tempo-util).
               leave calculo-data.       
            end.
        end.
        
        /***********************************************************************
                  Troca de Turno e Termino do turno no dia posterior
        Este tratamento abaixo se faz necessario devido a mudan‡Æo de turno, quando temos 
        um turno terminado no outro dia justamente no dia final de sua validade (grp x modelo), 
        desta forma:
        Modelo 1                  Modelo 2
        Turno 1 - 06:00 - 14:00   Turno 1 - 08:00 - 16:00
        Turno 2 - 14:00 - 22:00
        Turno 3 - 22:00 - 05:00
        Validades do Turno
        Modelo 1 01/01/2000 at‚ 20/02/2008
        Modelo 2 20/02/2008 at‚ 31/12/9999
        Calculando Datas e Hora de Fim a partir de 18/02/2008 …s 06:00 dura‡Æo de 44 horas
        
        Montagem corretas dos turnos
        dia 18
                        06:00 - 14:00 / 14:00 - 22:00 / 22:00 - 00:00 = 18 horas
        dia 19
        00:00 - 05:00 / 06:00 - 14:00 / 14:00 - 22:00 / 22:00 - 00:00 = 23 horas
        dia 20
        00:00 - 05:00 / 08:00 - 16:00                                 = 3 horas
        Nesta situa‡Æo a data de fim correta ‚ dia 20/02/2008 …s 03:00
        **************************************************************************
        Antes ele tratava o dia 20 da seguinte maneira
        dia 20
        08:00 - 16:00                                                 = 3 horas
        Nesta situa‡Æo a data de fim gerada era dia 20/02/2008 …s 11:00
        **************************************************************************/
        if v-dat-calcul + 1 = v-dat-fim-valid then do:
            run pi-gera-tt-turno (input p-cod-area,
                                  input p-cod-grp-maq,
                                  input p-cod-ctrab,
                                  input v-dat-calcul + 1,
                                  output v-dat-inic-valid,
                                  output v-dat-fim-valid).
        
           for each tt-turno-semana
               where tt-turno-semana.num-dia-sema = weekday(v-dat-calcul):
               
               /*Filtra registros desnecessarios*/
               if v-dat-calcul = p-dat-inic and tt-turno-semana.qtd-segs-fim-turno < p-qtd-segs-inic then next.
               
               /*Determina dia real para descobrir se ‚ util ou nÆo*/
               if tt-turno-semana.num-dia-turno <> 0 then
                   assign i-turno   = (tt-turno-semana.num-dia-turno - tt-turno-semana.num-dia-sema)
                          d-dat-aux = v-dat-calcul + i-turno.
               else
                   assign d-dat-aux = v-dat-calcul.
               if d-dat-aux <= v-dat-calcul then next.
                   
               /*Caso o dia real do turno seja posterior a data de validade do turno o
               mesmo deve ser desconsiderado.
               Ex: Turno 3 22:00 - 06:00  | Numa situa‡Æo em que 20/02 seja a data de termino do modelo de turno
                   Turno 1 06:00 - 14:00  | o intervalo das 22:00 - 00:00 que pertence ao turno 3 do dia 21 nÆo 
                   Turno 2 14:00 - 22:00  | deve ser considerado
               */
               if d-dat-aux >= v-dat-fim-valid then next.
               if d-dat-aux <  v-dat-inic-valid then next.

               find calen-data no-lock
                    where calen-data.cd-calen = p-cod-calend-sfc
                      and calen-data.data     = d-dat-aux no-error.
               /*‚ dia util se nÆo o registro e desconsiderado*/
               if avail calen-data         and 
                  calen-data.tipo-dia <> 1 then next.   
               
               /*Calculo para determinar data*/
               if v-dat-calcul = p-dat-inic then
                  assign i-aux-qtd-segs-inic-turno = max(tt-turno-semana.qtd-segs-inic-turno,p-qtd-segs-inic).
               else
                  assign i-aux-qtd-segs-inic-turno = tt-turno-semana.qtd-segs-inic-turno.
               
               assign p-qtd-tempo-util = p-qtd-tempo-util - (tt-turno-semana.qtd-segs-fim-turno - i-aux-qtd-segs-inic-turno).
               if p-qtd-tempo-util <= 0 then do:
                  assign p-dat-fim      = v-dat-calcul
                         p-qtd-segs-fim = tt-turno-semana.qtd-segs-fim-turno - abs(p-qtd-tempo-util).
                  leave calculo-data.       
               end.
           end.
        end.
            
        assign  v-dat-calcul  = v-dat-calcul + 1.
        
        if v-dat-calcul > p-dat-inic + 3000 then do:
            assign p-dat-fim = v-dat-calcul
                   p-qtd-segs-fim = 86399.
            leave calculo-data.
        end.

    end.

    if p-qtd-segs-fim = 86400 then
       assign p-dat-fim      = p-dat-fim + 1
              p-qtd-segs-fim = 0.
              
END PROCEDURE.
