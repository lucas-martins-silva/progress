/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN530A 2.00.00.022 } /*** "010022" 17/06/2025 16:40:50 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i boin530a MUT}
&ENDIF

   
/****************************************************************************
**
**  Programa: boin530a.p - Assign (write) de rep-parada-ctrab
**
**  Parametros: rw-rep-parada-ctrab: rowid de rep-parada-ctrab.
**
*****************************************************************************/

def input param rw-rep-parada-ctrab as rowid no-undo.

def var da-inic-mod            as date                                   no-undo.
def var da-fim-mod             as date                                   no-undo.
def var de-val-fator           as dec                                    no-undo.
def var de-qtd-segs-inic-mod   as dec                                    no-undo.
def var de-qtd-segs-fim-mod    as dec                                    no-undo.
def var de-val-refer-inic    like rep-parada-ctrab.val-refer-inic-parada no-undo.
DEF VAR de-val-refer-aux     LIKE rep-parada-ctrab.val-refer-inic-parada NO-UNDO.
DEF VAR i-num-oper             AS INT                                    NO-UNDO.
def var i-nr-reporte           as integer                                no-undo.

DEFINE VARIABLE l-aux AS LOGICAL NO-UNDO.
DEF BUFFER bf-rep-parada-mod FOR rep-parada-mod.

DEFINE VARIABLE l-atu-ggf AS LOGICAL NO-UNDO.
DEFINE VARIABLE l-atu-mob AS LOGICAL NO-UNDO.
/*GUARARAPES*/
{cdp/cdcfgmat.i}
{cdp/cdcfgman.i}
&IF DEFINED (bf_man_204) &THEN
    DEF VAR da-data-medio LIKE param-estoq.mensal-ate NO-UNDO.
    DEF VAR var-ini-intervalo LIKE rep-oper-ctrab.val-refer-inic-rep NO-UNDO.
    DEF VAR var-fim-intervalo LIKE rep-oper-ctrab.val-refer-inic-rep NO-UNDO.
    DEF VAR var-data-ini      AS DATE NO-UNDO.
    DEF VAR var-data-fim      AS DATE NO-UNDO.
    DEF VAR var-hora-ini      AS DEC format "->>>>,>>9.9999" decimals 4 no-undo.
    DEF VAR var-hora-fim      AS DEC format "->>>>,>>9.9999" decimals 4 no-undo.
    DEFINE VARIABLE i-num-dias AS INTEGER    NO-UNDO.
    DEF VAR var-hora-aux      AS DEC format "->>>>,>>9.9999" decimals 4 no-undo.
    DEF VAR var-hora-auxa      AS DEC format "->>>>,>>9.9999" decimals 4 no-undo.
    DEF VAR var-hora-auxb      AS DEC format "->>>>,>>9.9999" decimals 4 no-undo.
&endif
/*GUARARAPES*/

define buffer b-rep-parada-ctrab for rep-parada-ctrab.

find rep-parada-ctrab
    where rowid(rep-parada-ctrab) = rw-rep-parada-ctrab EXCLUSIVE-LOCK no-error.

/*** Verifica‡Æo e acerto de data de in¡cio de parada ***/
find first area-produc-ctrab
     where area-produc-ctrab.cod-ctrab       = rep-parada-ctrab.cod-ctrab
       and area-produc-ctrab.dat-inic-valid <= rep-parada-ctrab.dat-inic-parada
       and area-produc-ctrab.dat-fim-valid  >  rep-parada-ctrab.dat-inic-parada no-lock no-error.
find ctrab 
     where ctrab.cod-ctrab = rep-parada-ctrab.cod-ctrab no-lock no-error.
find grup-maquina 
     where grup-maquina.gm-codigo = ctrab.gm-codigo no-lock no-error.

if  not available area-produc-ctrab then do:
    find first area-produc-ctrab no-lock
         where area-produc-ctrab.cod-ctrab      = rep-parada-ctrab.cod-ctrab
           and area-produc-ctrab.dat-inic-valid > rep-parada-ctrab.dat-inic-parada
           and area-produc-ctrab.dat-inic-valid < rep-parada-ctrab.dat-fim-parada no-error.
    if  not available area-produc-ctrab then
        return error.
    else
        assign rep-parada-ctrab.dat-inic-parada = area-produc-ctrab.dat-inic-valid
               rep-parada-ctrab.qtd-segs-inic   = 0.
end.

run pi-converte-data-segs-valor (Input rep-parada-ctrab.dat-inic-parada,
                                 Input rep-parada-ctrab.qtd-segs-inic,
                                 output de-val-refer-inic).

/*** Ajuste de chave para postos manuais ***/
if grup-maquina.ind-tip-ctrab = 4 then
    blk-repeat:
    repeat:
       IF CAN-FIND (FIRST b-rep-parada-ctrab 
                     WHERE b-rep-parada-ctrab.cod-ctrab             = rep-parada-ctrab.cod-ctrab 
                       AND b-rep-parada-ctrab.val-refer-inic-parada = de-val-refer-inic 
                       AND rowid(b-rep-parada-ctrab)                <> rowid(rep-parada-ctrab)) THEN 
           assign de-val-refer-inic = de-val-refer-inic + 1.
     
       ELSE 
           leave blk-repeat.                     
    end.                                     

assign rep-parada-ctrab.val-refer-inic-parada = de-val-refer-inic.


/*** Verifica‡Æo e acerto de data fim de parada ***/
if  area-produc-ctrab.dat-fim-valid <= rep-parada-ctrab.dat-fim-parada then do:
    assign rep-parada-ctrab.dat-fim-parada      = area-produc-ctrab.dat-fim-valid
           rep-parada-ctrab.qtd-segs-fim = 0.
end.

run pi-converte-data-segs-valor (Input rep-parada-ctrab.dat-fim-parada,
                                 Input rep-parada-ctrab.qtd-segs-fim,
                                 output rep-parada-ctrab.val-refer-fim-parada).

/* Atualiza a manuten‡Æo programada como 'reportada'. */
if  rep-parada-ctrab.num-om-progda <> 0 then do:

    find man-progda-ctrab
        where man-progda-ctrab.cod-ctrab     = rep-parada-ctrab.cod-ctrab
          and man-progda-ctrab.num-om-progda = rep-parada-ctrab.num-om-progda
        EXCLUSIVE-LOCK no-error.
    assign man-progda-ctrab.log-man-ativa = no.
end.


run pi-sfc-reporte-tempo (input rep-parada-ctrab.cod-ctrab, 
                          input rep-parada-ctrab.dat-fim-parada,
                          input rep-parada-ctrab.qtd-segs-fim,
                          input rep-parada-ctrab.dat-inic-parada,
                          input rep-parada-ctrab.qtd-segs-inic,
                          output rep-parada-ctrab.qtd-tempo-parada,
                          output rep-parada-ctrab.qtd-tempo-ext,
                          output rep-parada-ctrab.cod-model-turno,
                          output rep-parada-ctrab.num-turno).

if  ctrab.ind-reporte-mod        = 2 /* Informa operador */
and rep-parada-ctrab.cod-equipe <> ""
and can-find (first operador
              where operador.cod-operador = rep-parada-ctrab.cod-equipe) then do on error undo, leave:

    /* Begin-Include: i-sfc-rep-parada-ctrab-mod */

    /* ** Consistencia para evitar overlap de reportes para operador ***/
    assign da-inic-mod          = rep-parada-ctrab.dat-inic-parada
           de-qtd-segs-inic-mod = rep-parada-ctrab.qtd-segs-inic
           da-fim-mod           = rep-parada-ctrab.dat-fim-parada
           de-qtd-segs-fim-mod  = rep-parada-ctrab.qtd-segs-fim.

    find last rep-parada-mod
        where rep-parada-mod.cod-operador           = rep-parada-ctrab.cod-equipe
          and rep-parada-mod.val-refer-inic-parada <= rep-parada-ctrab.val-refer-inic-parada 
        no-lock no-error.

    if  available rep-parada-mod
    and (rep-parada-mod.dat-fim-parada > da-inic-mod
    or  (rep-parada-mod.dat-fim-parada = da-inic-mod
    and  rep-parada-mod.qtd-segs-fim   > de-qtd-segs-inic-mod)) then 

        assign da-inic-mod          = rep-parada-mod.dat-fim-parada
               de-qtd-segs-inic-mod = rep-parada-mod.qtd-segs-fim.

    find first rep-parada-mod
        where rep-parada-mod.cod-operador          = rep-parada-ctrab.cod-equipe
          and rep-parada-mod.val-refer-inic-parada > rep-parada-ctrab.val-refer-inic-parada
        no-lock no-error.

    if  available rep-parada-mod
    and (rep-parada-mod.dat-inic-parada < da-fim-mod
    or  (rep-parada-mod.dat-inic-parada = da-fim-mod
    and  rep-parada-mod.qtd-segs-inic   < de-qtd-segs-fim-mod)) then 
        assign da-fim-mod          = rep-parada-mod.dat-inic-parada
               de-qtd-segs-fim-mod = rep-parada-mod.qtd-segs-inic.

    if  da-inic-mod          < da-fim-mod
    or (da-inic-mod          = da-fim-mod
    and de-qtd-segs-inic-mod < de-qtd-segs-fim-mod) then do:            

        create rep-parada-mod.
        assign de-val-fator                   = ((da-fim-mod - da-inic-mod) * 86400 + 
                                                  de-qtd-segs-fim-mod - de-qtd-segs-inic-mod) /
                                                ((rep-parada-ctrab.dat-fim-parada - 
                                                  rep-parada-ctrab.dat-inic-parada) * 86400 +
                                                  rep-parada-ctrab.qtd-segs-fim - 
                                                  rep-parada-ctrab.qtd-segs-inic)
               rep-parada-mod.cod-operador    = rep-parada-ctrab.cod-equipe
               rep-parada-mod.cod-equipe      = rep-parada-ctrab.cod-equipe
               rep-parada-mod.cod-parada      = rep-parada-ctrab.cod-parada
               rep-parada-mod.dat-inic-parada = da-inic-mod
               rep-parada-mod.qtd-segs-inic   = de-qtd-segs-inic-mod
               rep-parada-mod.dat-fim-parada  = da-fim-mod
               rep-parada-mod.qtd-segs-fim    = de-qtd-segs-fim-mod
               rep-parada-mod.qtd-tempo-mod   = rep-parada-ctrab.qtd-tempo-parada * de-val-fator        
               rep-parada-mod.cod-model-turno = rep-parada-ctrab.cod-model-turno
               rep-parada-mod.num-turno       = rep-parada-ctrab.num-turno
               rep-parada-mod.cod-ctrab       = rep-parada-ctrab.cod-ctrab
               rep-parada-mod.qtd-tempo-mod   = 24 * (rep-parada-mod.dat-fim-parada - rep-parada-mod.dat-inic-parada) +
                                                (rep-parada-mod.qtd-segs-fim - rep-parada-mod.qtd-segs-inic) / 3600.

        run pi-converte-data-segs-valor (Input rep-parada-mod.dat-inic-parada,
                                         Input rep-parada-mod.qtd-segs-inic,
                                         output de-val-refer-aux /*rep-parada-mod.val-refer-inic-parada*/ ).

        /*Tratamento para as situa‡äes nas quais h  mais de um reporte usando o operador com o mesmo val-refer.*/
        ASSIGN l-aux = YES.
        DO WHILE l-aux:
            IF CAN-FIND(FIRST bf-rep-parada-mod NO-LOCK
                        WHERE bf-rep-parada-mod.cod-operador          = rep-parada-ctrab.cod-equipe
                          AND bf-rep-parada-mod.val-refer-inic-parada = de-val-refer-aux) THEN
                ASSIGN de-val-refer-aux = de-val-refer-aux + 1.
            ELSE
                ASSIGN l-aux = NO.
        END.

        ASSIGN rep-parada-mod.val-refer-inic-parada = de-val-refer-aux.

        run pi-converte-data-segs-valor (Input rep-parada-mod.dat-fim-parada,
                                         Input rep-parada-mod.qtd-segs-fim,
                                         output rep-parada-mod.val-refer-fim-parada).

    end.
end.

if  ctrab.ind-reporte-mod = 3 /* Informa equipe */
and rep-parada-ctrab.cod-equipe <> ""
and can-find (first equipe-prod
              where equipe-prod.cod-equipe = rep-parada-ctrab.cod-equipe) then do:

    for each equipe-operador
        where equipe-operador.cod-equipe      = rep-parada-ctrab.cod-equipe
          and equipe-operador.dat-inic-valid <= rep-parada-ctrab.dat-inic-parada
          and equipe-operador.dat-fim-valid  >  rep-parada-ctrab.dat-fim-parada no-lock
        on error undo, next:

        /* Begin-Include: i-sfc-rep-parada-ctrab-mod */

        /*** Consistencia para evitar overlap de reportes para operador ***/
        assign da-inic-mod          = rep-parada-ctrab.dat-inic-parada
               de-qtd-segs-inic-mod = rep-parada-ctrab.qtd-segs-inic
               da-fim-mod           = rep-parada-ctrab.dat-fim-parada
               de-qtd-segs-fim-mod  = rep-parada-ctrab.qtd-segs-fim.

        find last rep-parada-mod
            where rep-parada-mod.cod-operador           = rep-parada-ctrab.cod-equipe
              and rep-parada-mod.val-refer-inic-parada <= rep-parada-ctrab.val-refer-inic-parada 
            no-lock no-error.

        if  available rep-parada-mod
        and (rep-parada-mod.dat-fim-parada > da-inic-mod
        or  (rep-parada-mod.dat-fim-parada = da-inic-mod
        and  rep-parada-mod.qtd-segs-fim   > de-qtd-segs-inic-mod)) then 

            assign da-inic-mod          = rep-parada-mod.dat-fim-parada
                   de-qtd-segs-inic-mod = rep-parada-mod.qtd-segs-fim.

        find first rep-parada-mod
            where rep-parada-mod.cod-operador          = rep-parada-ctrab.cod-equipe
              and rep-parada-mod.val-refer-inic-parada > rep-parada-ctrab.val-refer-inic-parada
            no-lock no-error.

        if  available rep-parada-mod
        and (rep-parada-mod.dat-inic-parada < da-fim-mod
        or  (rep-parada-mod.dat-inic-parada = da-fim-mod
        and  rep-parada-mod.qtd-segs-inic   < de-qtd-segs-fim-mod)) then 
            assign da-fim-mod          = rep-parada-mod.dat-inic-parada
                   de-qtd-segs-fim-mod = rep-parada-mod.qtd-segs-inic.

        if  da-inic-mod          < da-fim-mod
        or (da-inic-mod          = da-fim-mod
        and de-qtd-segs-inic-mod < de-qtd-segs-fim-mod) then do:            

            create rep-parada-mod.
            assign de-val-fator                   = ((da-fim-mod - da-inic-mod) * 86400 + 
                                                      de-qtd-segs-fim-mod - de-qtd-segs-inic-mod) /
                                                    ((rep-parada-ctrab.dat-fim-parada - 
                                                      rep-parada-ctrab.dat-inic-parada) * 86400 +
                                                      rep-parada-ctrab.qtd-segs-fim - 
                                                      rep-parada-ctrab.qtd-segs-inic)
                   rep-parada-mod.cod-operador    = equipe-operador.cod-operador
                   rep-parada-mod.cod-equipe      = rep-parada-ctrab.cod-equipe
                   rep-parada-mod.cod-parada      = rep-parada-ctrab.cod-parada
                   rep-parada-mod.dat-inic-parada = da-inic-mod
                   rep-parada-mod.qtd-segs-inic   = de-qtd-segs-inic-mod
                   rep-parada-mod.dat-fim-parada  = da-fim-mod
                   rep-parada-mod.qtd-segs-fim    = de-qtd-segs-fim-mod
                   rep-parada-mod.qtd-tempo-mod   = rep-parada-ctrab.qtd-tempo-parada * de-val-fator        
                   rep-parada-mod.cod-model-turno = rep-parada-ctrab.cod-model-turno
                   rep-parada-mod.num-turno       = rep-parada-ctrab.num-turno
                   rep-parada-mod.cod-ctrab       = rep-parada-ctrab.cod-ctrab
                   rep-parada-mod.qtd-tempo-mod   = 24 * (rep-parada-mod.dat-fim-parada - rep-parada-mod.dat-inic-parada) +
                                                    (rep-parada-mod.qtd-segs-fim - rep-parada-mod.qtd-segs-inic) / 3600.

            run pi-converte-data-segs-valor (Input rep-parada-mod.dat-inic-parada,
                                             Input rep-parada-mod.qtd-segs-inic,
                                             OUTPUT de-val-refer-aux /*rep-parada-mod.val-refer-inic-parada*/ ).

            /*Tratamento para as situa‡äes nas quais h  mais de um reporte usando o operador com o mesmo val-refer.*/
            ASSIGN l-aux = YES.
            DO WHILE l-aux:
                IF CAN-FIND(FIRST bf-rep-parada-mod NO-LOCK
                            WHERE bf-rep-parada-mod.cod-operador          = equipe-operador.cod-operador
                              AND bf-rep-parada-mod.val-refer-inic-parada = de-val-refer-aux) THEN
                    ASSIGN de-val-refer-aux = de-val-refer-aux + 1.
                ELSE
                    ASSIGN l-aux = NO.
            END.
    
            ASSIGN rep-parada-mod.val-refer-inic-parada = de-val-refer-aux.

            run pi-converte-data-segs-valor (Input rep-parada-mod.dat-fim-parada,
                                             Input rep-parada-mod.qtd-segs-fim,
                                             output rep-parada-mod.val-refer-fim-parada).
        end.
    end.
end.

/*** O reporte dever  diminuir os tempos de reportes de opera‡Æo que 
     sÆo intersectados pelo reporte de parada ***/

/* Begin-Include: i-sfc-rep-parada-ctrab-operac */
if  ctrab.ind-tip-ctrab <> 4 /* Manual */  then do:

    find last rep-oper-ctrab NO-LOCK
        where rep-oper-ctrab.cod-ctrab          = ctrab.cod-ctrab
          and rep-oper-ctrab.val-refer-inic-rep < rep-parada-ctrab.val-refer-fim-parada no-error.

    repeat:

        if  not avail rep-oper-ctrab
        or  rep-oper-ctrab.val-refer-fim-rep < rep-parada-ctrab.val-refer-inic-parada then
            leave.


        run AtualizarTempoRepOper (buffer rep-oper-ctrab).
        find prev rep-oper-ctrab use-index ctrab-i
            where rep-oper-ctrab.cod-ctrab = ctrab.cod-ctrab NO-LOCK no-error.
    end.
end.    
else do:

    find last rep-oper-ctrab NO-LOCK
        where rep-oper-ctrab.cod-equipe           = rep-parada-ctrab.cod-equipe 
          and rep-oper-ctrab.val-refer-inic-rep  < rep-parada-ctrab.val-refer-fim-parada
          and rep-oper-ctrab.cod-ctrab            = ctrab.cod-ctrab no-error.

    repeat:

        if  not avail rep-oper-ctrab
        or  rep-oper-ctrab.val-refer-fim-rep < rep-parada-ctrab.val-refer-inic-parada
        then leave.

        run AtualizarTempoRepOper (buffer rep-oper-ctrab). 

        find prev rep-oper-ctrab use-index ctrab-i
            where rep-oper-ctrab.cod-ctrab  = ctrab.cod-ctrab 
              and rep-oper-ctrab.cod-equipe = rep-parada-ctrab.cod-equipe NO-LOCK no-error.
    end.
end.


/*GUARARAPES*/
&IF DEFINED (bf_man_204) &THEN

    FIND FIRST param-sfc NO-LOCK NO-ERROR.

    
    ASSIGN l-atu-ggf = param-sfc.log-parada-atualiza-ggf AND param-sfc.log-gera-ggf-autom = YES 
           l-atu-mob = substring(param-sfc.CHAR-1, 34, 1) = "S" AND param-sfc.log-gera-mod-autom = YES.
    
    IF l-atu-ggf OR l-atu-mob THEN DO:
        FOR EACH rep-oper-ctrab
           WHERE rep-oper-ctrab.cod-ctrab           = rep-parada-ctrab.cod-ctrab
            AND  rep-oper-ctrab.val-refer-fim-rep  >= rep-parada-ctrab.val-refer-inic-parada
            AND  rep-oper-ctrab.val-refer-inic-rep <= rep-parada-ctrab.val-refer-fim-parada NO-LOCK:

           run pi-retorna-equipe(buffer rep-oper-ctrab,output i-num-oper).  

           if rep-oper-ctrab.qtd-operac-reptda = 0 then 
              assign i-nr-reporte = 0.
           else
              assign i-nr-reporte = rep-oper-ctrab.nr-reporte.
    
           IF l-atu-ggf THEN DO:
           FOR EACH movto-ggf USE-INDEX ordem
              WHERE movto-ggf.nr-ord-produ = rep-oper-ctrab.nr-ord-produ
               AND  movto-ggf.nr-reporte  = i-nr-reporte EXCLUSIVE-LOCK:


               &IF DEFINED(bf_man_207a) &THEN
               if (i-nr-reporte = 0 and movto-ggf.num-seq-rep <> rep-oper-ctrab.num-seq-rep) or 
                  (i-nr-reporte = 0 and movto-ggf.log-estorno <> no)                       then next.
               &ELSE
               if (i-nr-reporte = 0 and movto-ggf.int-1 <> rep-oper-ctrab.num-seq-rep) or 
                  (i-nr-reporte = 0 and substring(movto-ggf.char-1,1,1) <> "")         then next.
               &endif

               for first ord-prod fields(nr-ord-produ reporte-ggf estado rep-prod)
                    where ord-prod.nr-ord-produ = movto-ggf.nr-ord-produ NO-LOCK:
               end.    
               IF AVAIL ord-prod /*AND ord-prod.reporte-ggf = 1*/ AND ord-prod.estado < 8 AND ord-prod.rep-prod < 4 THEN DO:
                   for first estabelec fields(cod-estabel usa-on-line usa-padrao)
                       where estabelec.cod-estabel = movto-ggf.cod-estabel NO-LOCK:
                   end.
                   IF AVAIL estabelec AND estabelec.usa-on-line = NO AND estabelec.usa-padrao = NO THEN DO:
                   find first param-estoq no-lock no-error.
                    &IF DEFINED (bf_mat_versao_ems) &THEN /*2.04*/
                        IF param-estoq.tp-fech = 2 THEN DO:
                           for first estab-mat fields(cod-estabel mensal-ate) 
                               where estab-mat.cod-estabel = movto-ggf.cod-estabel no-lock:
                           end.
                           IF AVAIL estab-mat  THEN     
                               ASSIGN da-data-medio = estab-mat.mensal-ate.
                        END.
                        ELSE ASSIGN da-data-medio = param-estoq.mensal-ate.
                    &ELSE
                        ASSIGN da-data-medio = param-estoq.mensal-ate.
                    &ENDIF
                        IF movto-ggf.dt-trans > da-data-medio THEN DO:
                           /*Calcula o tempo da intersec‡Æo entre a parada e o reporte*/

                            ASSIGN var-ini-intervalo = MAX(rep-oper-ctrab.val-refer-inic-rep,rep-parada-ctrab.val-refer-inic-parada)
                                   var-fim-intervalo = MIN(rep-oper-ctrab.val-refer-fim-rep,rep-parada-ctrab.val-refer-fim-parada).

                            IF var-ini-intervalo < var-fim-intervalo THEN DO:
                                RUN pi-converte-valor-data-segs(INPUT var-ini-intervalo,
                                                                OUTPUT var-data-ini,
                                                                OUTPUT var-hora-ini).

                                RUN pi-converte-valor-data-segs(INPUT var-fim-intervalo,
                                                                OUTPUT var-data-fim,
                                                                OUTPUT var-hora-fim).

                                IF var-data-ini = var-data-fim THEN 
                                    ASSIGN var-hora-ini = var-hora-fim - var-hora-ini
                                           var-hora-ini  = var-hora-ini * i-num-oper. /*Quando ‚ reporte por equipe*/
                                ELSE
                                    /*tratamento caso nao seja a mesma data*/
                                    ASSIGN i-num-dias = INTEGER(var-data-fim - var-data-ini) /*pega o numero de dias de diferen‡a entre o inicial e final.*/
                                           var-hora-aux = (24 * 60 * 60) - var-hora-ini /*numero de segundos entre o final do 1o dia e a hora inicial*/
                                           var-hora-auxa = (24 * 60 * 60) * (i-num-dias - 1) /*numero de segundos nos dias entre o 1o e o ultimo*/
                                           var-hora-auxb = var-hora-fim
                                           var-hora-ini  = var-hora-aux + var-hora-auxa + var-hora-auxb
                                           var-hora-ini  = var-hora-ini * i-num-oper. /*Quando ‚ reporte por equipe*/
                                
                                /*neste ponto, o var-hora-ini tem q qtd de segundos da parada. Tenho que transformar isso em hora decimal*/
                                                                                         /*transforma em decimal o tempo em segundos*/
                                ASSIGN movto-ggf.horas-report = IF (movto-ggf.horas-report - (var-hora-ini / 60 / 60)) < 0 THEN 0 ELSE movto-ggf.horas-report - (var-hora-ini / 60 / 60).

/*                                 ASSIGN movto-ggf.horas-report = rep-oper-ctrab.qtd-tempo-reporte. */
                                END.
                            END.
                        END.
                   END.
               END.
           END.
           IF l-atu-mob THEN DO:
               FOR EACH movto-dir USE-INDEX ordem
                  WHERE movto-dir.nr-ord-produ = rep-oper-ctrab.nr-ord-produ
                   AND  movto-dir.nr-reporte  = i-nr-reporte EXCLUSIVE-LOCK:
                   if (i-nr-reporte = 0 and movto-dir.num-seq-rep <> rep-oper-ctrab.num-seq-rep) or 
                      (i-nr-reporte = 0 and movto-dir.log-estorno <> no)                       then next.
                   for first ord-prod fields(nr-ord-produ reporte-mob  estado rep-prod)
                        where ord-prod.nr-ord-produ = movto-dir.nr-ord-produ NO-LOCK:
                   end.    
                   IF AVAIL ord-prod /*AND ord-prod.reporte-mob = 1*/ AND ord-prod.estado < 8 AND ord-prod.rep-prod < 4 THEN DO:
                       for first estabelec fields(cod-estabel usa-on-line usa-padrao)
                           where estabelec.cod-estabel = movto-dir.cod-estabel NO-LOCK:
                       end.
                       IF AVAIL estabelec AND estabelec.usa-on-line = NO AND estabelec.usa-padrao = NO THEN DO:
                       find first param-estoq no-lock no-error.
                            IF param-estoq.tp-fech = 2 THEN DO:
                               for first estab-mat fields(cod-estabel mensal-ate) 
                                   where estab-mat.cod-estabel = movto-dir.cod-estabel no-lock:
                               end.
                               IF AVAIL estab-mat  THEN     
                                   ASSIGN da-data-medio = estab-mat.mensal-ate.
                            END.
                            ELSE ASSIGN da-data-medio = param-estoq.mensal-ate.
                            IF movto-dir.dt-trans > da-data-medio THEN DO:
                               /*Calcula o tempo da intersec‡Æo entre a parada e o reporte*/
                                ASSIGN var-ini-intervalo = MAX(rep-oper-ctrab.val-refer-inic-rep,rep-parada-ctrab.val-refer-inic-parada)
                                       var-fim-intervalo = MIN(rep-oper-ctrab.val-refer-fim-rep,rep-parada-ctrab.val-refer-fim-parada).
                                IF var-ini-intervalo < var-fim-intervalo THEN DO:
                                    RUN pi-converte-valor-data-segs(INPUT var-ini-intervalo,
                                                                    OUTPUT var-data-ini,
                                                                    OUTPUT var-hora-ini).
    
                                    RUN pi-converte-valor-data-segs(INPUT var-fim-intervalo,
                                                                    OUTPUT var-data-fim,
                                                                    OUTPUT var-hora-fim).
    
                                    IF var-data-ini = var-data-fim THEN 
                                        ASSIGN var-hora-ini = var-hora-fim - var-hora-ini
                                               var-hora-ini  = var-hora-ini * i-num-oper. /*Quando ‚ reporte por equipe*/
                                    ELSE
                                        /*tratamento caso nao seja a mesma data*/
                                        ASSIGN i-num-dias = INTEGER(var-data-fim - var-data-ini) /*pega o numero de dias de diferen‡a entre o inicial e final.*/
                                               var-hora-aux = (24 * 60 * 60) - var-hora-ini /*numero de segundos entre o final do 1o dia e a hora inicial*/
                                               var-hora-auxa = (24 * 60 * 60) * (i-num-dias - 1) /*numero de segundos nos dias entre o 1o e o ultimo*/
                                               var-hora-auxb = var-hora-fim
                                               var-hora-ini  = var-hora-aux + var-hora-auxa + var-hora-auxb
                                               var-hora-ini  = var-hora-ini * i-num-oper. /*Quando ‚ reporte por equipe*/
                                    /*neste ponto, o var-hora-ini tem q qtd de segundos da parada. Tenho que transformar isso em hora decimal*/
                                                                                             /*transforma em decimal o tempo em segundos*/
                                    ASSIGN movto-dir.tempo-homem = IF (movto-dir.tempo-homem - (var-hora-ini / 60 / 60)) < 0 THEN 0 ELSE movto-dir.tempo-homem - (var-hora-ini / 60 / 60)
                                           movto-dir.horas-report = movto-dir.tempo-homem .
                                END.
                            END.
                       END.
                   END.
               END.
           END.
        END.
    END.
&endif
/*GUARARAPES*/

procedure pi-retorna-equipe:
   def parameter buffer b-rep-oper-ctrab for rep-oper-ctrab.
   def output parameter i-num-oper as integer init 1 no-undo.

   def var l-req-eq-ggf-dir  as log init yes no-undo.
   
   find equipe-prod no-lock
        where equipe-prod.cod-equipe = b-rep-oper-ctrab.cod-equipe no-error.

   assign i-num-oper = 1.
   if avail equipe-prod and l-req-eq-ggf-dir then do:
        ASSIGN i-num-oper = 0.
        for each equipe-operador 
            where equipe-operador.cod-equipe     =  b-rep-oper-ctrab.cod-equipe
              AND equipe-operador.dat-inic-valid <= b-rep-oper-ctrab.dat-inic-reporte
              AND equipe-operador.dat-fim-valid  >  b-rep-oper-ctrab.dat-fim-reporte no-lock:
            ASSIGN i-num-oper = i-num-oper + 1.
        END.
        IF i-num-oper = 0 THEN ASSIGN i-num-oper = 1.
   end.

   return "OK":U.
end.

/********************************************************************************/

{sfc/sf9002.i} /*** pi-converte-data-segs-valor ***/

{inbo/boin536.i5} /* AtualizarTempoRepOper */
{inbo/boin536.i6} /* pi-sfc-tempo-paradas-maq e pi-sfc-tempo-paradas-mod */

