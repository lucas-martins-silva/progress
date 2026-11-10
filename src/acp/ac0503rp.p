/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AC0503RP 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ac0503rp MAC}
&ENDIF

/*******************************************************************************
**
** Ac0503RP.P : Gera‡Æo de Gr fico de Cotas
**
********************************************************************************/

{cdp/cdcfgdis.i} /*include para pr‚-processadores*/

/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/

&if defined (bf_dis_adm_cotas) &then
    def var de-qt-ped-reprov     like cotas.qt-ped-reprov         no-undo.
&endif

def var h-acomp            as handle                      no-undo.
def var de-qt-prevista     like cotas.qt-prevista         no-undo.
def var de-qt-pedida       like cotas.qt-pedida           no-undo.
def var de-qt-faturada     like cotas.qt-faturada         no-undo. 
def var de-qt-ped-canc     like cotas.qt-ped-canc         no-undo.
def var de-qt-fat-canc     like cotas.qt-fat-canc         no-undo.
def var de-qt-ped-susp     like cotas.qt-ped-susp         no-undo.
def var c-tit-graf         as char format "x(18)"         no-undo.
def var c-tit-y            as char format "x(18)"         no-undo.
def var i-cont-aux         as int                         no-undo.
def var l-achou            as log init no                 no-undo.

/* defini‡äes de temp tables gr ficos */
{utp/utapi001.i}

/*defini‡Æo da temp table tt-param*/
{acp/ac0503.i}

def temp-table tt-raw-digita
   field raw-digita      as raw.

def input parameter raw-param as raw no-undo.

create tt-param.
raw-transfer raw-param to tt-param no-error.

find first par-cota no-lock no-error.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i "Aguarde..."}
run pi-inicializar in h-acomp (input RETURN-VALUE).

/************************* Inicio Processo **************/

/************************************************************ 
*  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
************************************************************/

&if defined (bf_dis_adm_cotas) &then
    for each  cotas no-lock USE-INDEX Produto
        where cotas.dt-inicial      >= tt-param.dt-inicial
        and   cotas.dt-inicial      <= tt-param.dt-final
        and   cotas.cod-estabel     >= tt-param.cod-estab-ini
        and   cotas.cod-estabel     <= tt-param.cod-estab-fim
        and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
        and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
        or    cotas.cod-canal-venda  = ? )
        and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
        and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
        or    cotas.cod-gr-cli       = ? )
        and   ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
        and   cotas.nome-abrev      <= tt-param.nome-abrev-fim)
        or    cotas.nome-abrev       = ? )          
        and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
        and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
        or    cotas.nome-ab-reg      = ? ) 
        and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
        and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
        or    cotas.nome-mic-reg     = ? )
        and     cotas.cod-rep         >= tt-param.cod-rep-ini
        and   cotas.cod-rep         <= tt-param.cod-rep-fim
        and     cotas.cd-produto      >= tt-param.cd-produto-ini
        and   cotas.cd-produto      <= tt-param.cd-produto-fim:
&else
    for each cotas no-lock USE-INDEX Produto
        where cotas.dt-inicial  >= tt-param.dt-inicial
        and   cotas.dt-inicial      <= tt-param.dt-final
        and   cotas.cod-estabel     >= tt-param.cod-estab-ini
        and   cotas.cod-estabel     <= tt-param.cod-estab-fim
        and   ((cotas.cod-canal-venda >= tt-param.cod-canal-venda-ini
        and   cotas.cod-canal-venda <= tt-param.cod-canal-venda-fim)
        or    cotas.cod-canal-venda  = ? )
        and   ((cotas.cod-gr-cli      >= tt-param.cod-gr-cli-ini
        and   cotas.cod-gr-cli      <= tt-param.cod-gr-cli-fim)
        or    cotas.cod-gr-cli       = ? )
        and   ((cotas.nome-abrev      >= tt-param.nome-abrev-ini
        and   cotas.nome-abrev      <= tt-param.nome-abrev-fim)
        or    cotas.nome-abrev       = ? )          
        and   ((cotas.nome-ab-reg     >= tt-param.nome-ab-reg-ini
        and   cotas.nome-ab-reg     <= tt-param.nome-ab-reg-fim)
        or    cotas.nome-ab-reg      = ? ) 
        and   ((cotas.nome-mic-reg    >= tt-param.nome-mic-reg-ini
        and   cotas.nome-mic-reg    <= tt-param.nome-mic-reg-fim)
        or    cotas.nome-mic-reg     = ? )
        and   ((cotas.cod-rep         >= tt-param.cod-rep-ini
        and   cotas.cod-rep         <= tt-param.cod-rep-fim)
        or    cotas.cod-rep          = ? )
        and     cotas.cd-produto      >= tt-param.cd-produto-ini
        and   cotas.cd-produto      <= tt-param.cd-produto-fim:
&endif

    run pi-acompanhar in h-acomp ( input cotas.cod-rep). 

    assign l-achou = yes.

    if par-cota.tipo-controle = 2 then do:
       assign de-qt-prevista  = de-qt-prevista + cotas.vl-previsto
              de-qt-pedida    = de-qt-pedida   + cotas.vl-pedido
              de-qt-faturada  = de-qt-faturada + cotas.vl-faturado
              de-qt-ped-canc  = de-qt-ped-canc + cotas.vl-ped-canc
              de-qt-fat-canc  = de-qt-fat-canc + cotas.vl-fat-canc
              de-qt-ped-susp  = de-qt-ped-susp + cotas.vl-ped-susp.
       /************************************************************ 
       *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
       ************************************************************/

       &if defined (bf_dis_adm_cotas) &then
           assign de-qt-ped-reprov = de-qt-ped-reprov + cotas.vl-ped-reprov.
       &endif
    end.
    else do:
       assign de-qt-prevista  = de-qt-prevista + cotas.qt-prevista
              de-qt-pedida    = de-qt-pedida   + cotas.qt-pedida
              de-qt-faturada  = de-qt-faturada + cotas.qt-faturada
              de-qt-ped-canc  = de-qt-ped-canc + cotas.qt-ped-canc
              de-qt-fat-canc  = de-qt-fat-canc + cotas.qt-fat-canc
              de-qt-ped-susp  = de-qt-ped-susp + cotas.qt-ped-susp.
       /************************************************************ 
       *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
       ************************************************************/

       &if defined (bf_dis_adm_cotas) &then
           assign de-qt-ped-reprov = de-qt-ped-reprov + cotas.qt-ped-reprov.
       &endif
    end.
end.

/*************************** Inicio Gera‡Æo do gr fico ***********************/

if l-achou = no then do:
   run pi-finalizar in h-acomp.
   return.
end.

for each tt-sets:
  delete tt-sets.
end.
for each tt-ylabels:
  delete tt-ylabels.
end.                              
for each tt-points:
  delete tt-points.
end.
for each tt-dados:
  delete tt-dados.
end.
for each tt-atributos:
  delete tt-atributos.
end.

do on error undo, return error
   on stop  undo, return error:  

   {utp/ut-liter.i Cotas_Realizadas MAC R}
   assign c-tit-graf = return-value .

   /* Descri‡Æo : quantidade, valor ,pontos. */
   assign c-tit-y  = {diinc/i04di257.i 04 par-cota.tipo-controle}.

/*
   Foi retirado alguns tipos de grÿficos, porque estavam com problema. 
   (O fonte da API de gr˜ficos foi perdida.)

Antiga  - Atual
01      - 01 - Pizza 2D
02      - 02 - Pizza 3D
03      - 03 - Barra 2D
04      - 04 - Barra 3D
05 - Gantt
06      - 05 - Linha 
07 - Log/Lin
08      - 06 - Area 2D 
09      - 07 - Scatter 2D 
10      - 08 - Polar 
11 - High Low Close 	 
12 - Bolha 
13      - 09 - Tape 
14      - 10 - Area 3D
15 - Log/Log 	
16      - 11 - Lin / Log 
17      - 12 - Box whisker 
18 - Open High Low Close 
19 - Clandertick 	
20 - True 3D Surface 
21      - 13 True 3D Scatter 
22 - Time Series 
*/

   /* Ô necessÿrio manter a numera»’o antiga dos grÿficos */
   IF i-grafico = 5 THEN 
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 1.
   ELSE
   IF tt-param.i-grafico = 6 OR 
      tt-param.i-grafico = 7 OR
      tt-param.i-grafico = 8 THEN
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 2.
   ELSE
   IF tt-param.i-grafico = 9 OR 
      tt-param.i-grafico = 10 THEN 
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 4.
   ELSE
   IF tt-param.i-grafico = 11 OR 
      tt-param.i-grafico = 12 THEN 
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 5.
   ELSE
   IF tt-param.i-grafico = 13 THEN 
       ASSIGN tt-param.i-grafico = tt-param.i-grafico + 8.

   create tt-atributos.         
   assign tt-atributos.numgraph              = 1    
          tt-atributos.cod-versao-integracao = 3
          tt-atributos.graphtype             = i-grafico
          tt-atributos.graphtitle            = c-tit-graf 
          tt-atributos.lefttitle             = c-tit-y
          tt-atributos.lefttitlestyle        = 1
/*          tt-atributos.bottomtitle           = c-tit-x */
          tt-atributos.legendpos             = 0
          tt-atributos.gridstyle             = 1
          tt-atributos.gridlinestyle         = 1.                   

   create tt-sets.
   assign tt-sets.numset        = 1
          tt-sets.numgraph      = 1.

   {utp/ut-liter.i "Criando tabelas ..."}
   run pi-acompanhar in h-acomp ( input RETURN-VALUE). 

    /* Quantidade/Valor Prevista */ 
    i-cont-aux = 1.       
    create tt-dados.
    assign tt-dados.numpoint  = i-cont-aux
           tt-dados.numset    = 1
           tt-dados.numgraph  = 1
           tt-dados.graphdata = de-qt-prevista. 
    {utp/ut-field.i mgdis cotas qt-prevista 1}
    create tt-points.
    assign tt-points.numpoint  = i-cont-aux
           tt-points.numgraph  = 1
           tt-points.labeltext = trim(return-value)
           i-cont-aux          = i-cont-aux + 1.       

    /* Quantidade/Valor Pedida */
    create tt-dados.
    assign tt-dados.numpoint  = i-cont-aux
           tt-dados.numset    = 1
           tt-dados.numgraph  = 1
           tt-dados.graphdata = de-qt-pedida.
    {utp/ut-field.i mgdis cotas qt-pedida 1}
    create tt-points.
    assign tt-points.numpoint  = i-cont-aux
           tt-points.numgraph  = 1
           tt-points.labeltext = trim(return-value)
           i-cont-aux          = i-cont-aux + 1.       

    /* Quantidade/Valor Faturada */
    create tt-dados.
    assign tt-dados.numpoint  = i-cont-aux
           tt-dados.numset    = 1
           tt-dados.numgraph  = 1
           tt-dados.graphdata = de-qt-faturada.
    {utp/ut-field.i mgdis cotas qt-faturada 1}
    create tt-points.
    assign tt-points.numpoint  = i-cont-aux
           tt-points.numgraph  = 1
           tt-points.labeltext = trim(return-value)
           i-cont-aux          = i-cont-aux + 1.       

    /* Quantidade/Valor Pedida Cancelada */
    create tt-dados.
    assign tt-dados.numpoint  = i-cont-aux
           tt-dados.numset    = 1
           tt-dados.numgraph  = 1
           tt-dados.graphdata = de-qt-ped-canc.
    {utp/ut-field.i mgdis cotas qt-ped-canc 1}
    create tt-points.
    assign tt-points.numpoint  = i-cont-aux
           tt-points.numgraph  = 1
           tt-points.labeltext = trim(return-value)
           i-cont-aux          = i-cont-aux + 1.       

    /* Quantidade/Valor Faturada Cancelada */
    create tt-dados.
    assign tt-dados.numpoint  = i-cont-aux
           tt-dados.numset    = 1
           tt-dados.numgraph  = 1
           tt-dados.graphdata = de-qt-fat-canc.
    {utp/ut-field.i mgdis cotas qt-fat-canc 1}
    create tt-points.
    assign tt-points.numpoint  = i-cont-aux
           tt-points.numgraph  = 1
           tt-points.labeltext = trim(return-value)
           i-cont-aux          = i-cont-aux + 1.       

    /* Quantidade/Valor Pedida Suspensa */
    create tt-dados.
    assign tt-dados.numpoint  = i-cont-aux
           tt-dados.numset    = 1
           tt-dados.numgraph  = 1
           tt-dados.graphdata = de-qt-ped-susp.
    {utp/ut-field.i mgdis cotas qt-ped-susp 1}
    create tt-points.
    assign tt-points.numpoint  = i-cont-aux
           tt-points.numgraph  = 1
           tt-points.labeltext = trim(return-value)
           i-cont-aux          = i-cont-aux + 1.

    /************************************************************ 
    *  Pr‚-Processador para o m¢dulo de Administra‡Æo de Cotas
    ************************************************************/

    &if defined (bf_dis_adm_cotas) &then
        /* Quantidade/Valor Pedida Reprovada */
        create tt-dados.
        assign tt-dados.numpoint  = i-cont-aux
               tt-dados.numset    = 1
               tt-dados.numgraph  = 1
               tt-dados.graphdata = de-qt-ped-reprov.
        {utp/ut-field.i mgdis cotas qt-ped-reprov 1}
        create tt-points.
        assign tt-points.numpoint  = i-cont-aux
               tt-points.numgraph  = 1
               tt-points.labeltext = trim(return-value)
               i-cont-aux          = i-cont-aux + 1.
    &endif

end. 


  /*******************/           
  /** Monta gr fico **/
  /*******************/

   {utp/ut-liter.i "Gerando Gr fico ..."}
   run pi-acompanhar in h-acomp ( input RETURN-VALUE). 

   run utp/utapi001.p (input table tt-atributos, 
                       input        table tt-points,
                       input        table tt-sets,
                       input        table tt-dados, 
                       input        table tt-ylabels,
                       output       table tt-erros).      

  run pi-finalizar in h-acomp.


   for each tt-erros:
       run utp/ut-msgs.p (input 'show', input tt-erros.cod-erro, '').
   end.


RETURN "OK".


/* Fim do Programa */


