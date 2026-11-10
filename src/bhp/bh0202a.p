/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0202A 2.00.00.015 } /*** "010015" 14/07/2026 15:13:27  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bh0202a MBH}
&ENDIF

/*******************************************************************************
**
**  Programa: BH0202A.P - Transferˆncia de Banco Hist¢rico - Distribui‡Æo
**
*******************************************************************************/

/*Defini‡Æo include pr‚-processador release */
{cdp/cdcfgdis.i} 

/* ========================= Temp-Table Definitions ========================= */
define temp-table tt-raw-digita 
    field raw-digita as raw.

define temp-table tt-param no-undo
    field destino          as integer
    field arquivo          as char    format "x(35)"
    field usuario          as char    format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field da-per-corte     as date    format 99/99/9999
    field ano-of           as integer format 9999
    field l-pedfat         as logical
    field l-estat          as logical
    field l-of             as logical
    field l-cotacao        as logical.    

define temp-table tt-estat-modulo no-undo
    field i-sequencia      as integer  label "Seq"
    field c-modulo         as char     FORMAT "x(02)" label "M¢dulo"
    FIELD c-nom-tab        AS CHAR     FORMAT "x(25)" LABEL "Tabela"
    field c-tabela         as char     FORMAT "x(35)" label "Descri‡Æo"
    field i-modulo         as integer  label "Registros"
    index i-sequencia is unique i-sequencia ascending.    


/* ============================ Input Parameters ============================ */
define input parameter raw-param as raw no-undo.

create tt-param.
raw-transfer raw-param to tt-param.

/* Defini‡Æo da temp-table de erros 
   Valores poss¡veis para o campo tt-erro.i-tabela:
             1 - nota-fiscal
             2 - it-nota-fisc
             3 - it-nota-imp
             4 - nota-trans
             5 - fat-ser-lote
             6 - nar-it-nota
             7 - fat-repre
             8 - fat-duplic
             9 - nota-embal
            10 - item-embal
            11 - devol-cli
            12 - ped-venda
            13 - ped-item
            14 - ped-ent
            16 - ped-repre
            18 - cond-ped
            19 - fat-estat
            20 - doc-fiscal
            21 - it-doc-fisc
            22 - apur-imposto
            23 - imp-valor
            24 - imposto-guia
            25 - ext-doc-fiscal 
            26 - item-nfs-st 
            27 - sit-nf-eletro 
            28 - ret-nf-eletro 
            29 - nota-fisc-social
            30 - item-nota-social */   

DEFINE TEMP-TABLE tt-erro-bh NO-UNDO
    FIELD i-tabela AS INTEGER FORMAT "9"
    FIELD r-rowid  AS ROWID
    INDEX ch-tabela IS PRIMARY
              i-tabela.

/* ========================== Variable Definitions ========================== */
define new shared variable h-acomp as handle no-undo.

define variable de-total         as integer   no-undo.
define variable i-cont           as integer   no-undo.
define variable i-cont-aux1      as integer   no-undo.
define variable i-cont-aux2      as integer   no-undo.
define variable i-cont-aux3      as integer   no-undo.
define variable i-cont-aux4      as integer   no-undo.
define variable i-cont-aux5      as integer   no-undo.
define variable c-acompanha      as character no-undo.
define variable c-acompanha-aux1 as character no-undo.
define variable c-acompanha-aux2 as character no-undo.
define variable c-acompanha-aux3 as character no-undo.
define variable c-acompanha-aux4 as character no-undo.
define variable c-acompanha-aux5 as character no-undo.
define variable c-destino        as character no-undo.
define variable c-parametros     as character no-undo.
define variable c-impressao      as character no-undo.
define variable c-pedfat         as character no-undo.
define variable c-estat          as character no-undo.
define variable c-of             as character no-undo. 
define variable c-cotacao        as character no-undo.

{include/i-rpvar.i}


/* =========================== Frames Definitions =========================== */

form skip(01)
     "Total de Registros"    AT 34
     de-total                at 70 no-label
     with no-box width 132 64 down frame f-total stream-io.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-total:HANDLE).


form 
                                                           skip(3)
     c-parametros            at 60 no-label format "x(20)" skip(1)
     tt-param.da-per-corte   at 49
     tt-param.ano-of         at 55
     c-pedfat                at 53
     c-estat                 at 54
     c-of                    at 57
     c-cotacao               at 52
     skip(3)
     c-impressao             at 60 no-label format "x(20)" skip(1)
     c-destino               at 52 " - "
     tt-param.arquivo              no-label format "x(40)"
     tt-param.usuario        at 54             
     with no-box width 132 64 down side-labels frame f-parametros stream-io. 
/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-parametros:HANDLE).
 

{utp/ut-liter.i Per¡odo_de_Corte          * C} tt-param.da-per-corte:label in frame f-parametros = trim(return-value).
{utp/ut-liter.i Importa_OF_desde_o_ano_de * C} tt-param.ano-of:label       in frame f-parametros = trim(return-value).        
{utp/ut-liter.i Pedido/Faturamento        * C} c-pedfat:label              in frame f-parametros = trim(return-value).    
{utp/ut-liter.i Estat¡sticas              * C} c-estat:label               in frame f-parametros = trim(return-value).    
{utp/ut-liter.i Obriga‡äes_Fiscais        * C} c-of:label                  in frame f-parametros = trim(return-value).    
{utp/ut-liter.i Cota‡Æo                   * C} c-cotacao:label             in frame f-parametros = trim(return-value).
{utp/ut-liter.i Destino                   * C} c-destino:label             in frame f-parametros = trim(return-value).
{utp/ut-liter.i Usu rio                   * C} tt-param.usuario:label      in frame f-parametros = trim(return-value).

{utp/ut-liter.i PAR¶METROS * C} c-parametros = trim(return-value).
{utp/ut-liter.i IMPRESSÇO  * C} c-impressao  = trim(return-value).

{include/i-rpcab.i}


/* =============================== Main Block =============================== */
for first param-global fields (grupo empresa-prin) no-lock: end.


/* ------------------------ Inicializa Acompanhamento ----------------------- */
run utp/ut-acomp.p persistent set h-acomp.

{utp/ut-liter.i Bancos_Hist¢ricos *}
run pi-inicializar in h-acomp (input Return-value).
run pi-seta-tipo in h-acomp (input 1).


/* ------------------ Importa Dados do HisDis para o MovDis ----------------- */
run Pi-Gera-tt-estat-modulo.

if  tt-param.l-pedfat then
    run Pi-Importa-Pedidos-Faturamento.

if  tt-param.l-estat then
    run Pi-Importa-Estatistica.

if  tt-param.l-of then
    run Pi-Importa-OF.

if  tt-param.l-cotacao then
    run Pi-Importa-Cotacao.


/* ------------------------ Relat¢rio de Estat¡stica ------------------------ */
{include/i-rpout.i}
run Pi-Imprime-Estat¡stica.
{include/i-rpclo.i}


/* ------------------------ Finaliza Acompanhamento ------------------------- */
run pi-finalizar in h-acomp.


/* ========================== Procedure Definitions ========================== */
Procedure Pi-Importa-Pedidos-Faturamento:


    /* ----------------------------------------------------------------------- */
    /* ------------------------- Importa Faturamento ------------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Faturamento}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.

    Blk_NotaFiscal:
    for each hisdis.nota-fiscal where 
             hisdis.nota-fiscal.dt-emis-nota >= tt-param.da-per-corte exclusive-lock transaction:

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             /* ------- Importa hisdis.it-nota-fisc/hisdis.fat-ser-lote/hisdis.nar-it-nota/hisdis.it-nota-imp ------ */
             {utp/ut-liter.i Itens}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.
             for each hisdis.it-nota-fisc of hisdis.nota-fiscal exclusive-lock:

                      assign i-cont-aux1 = i-cont-aux1 + 1.
                      run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                      {utp/ut-liter.i Lotes}.
                      assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                             i-cont-aux2      = 0.                      

                      for each hisdis.fat-ser-lote where 
                               hisdis.fat-ser-lote.cod-estabel = hisdis.nota-fiscal.cod-estabel and
                               hisdis.fat-ser-lote.serie       = hisdis.nota-fiscal.serie       and
                               hisdis.fat-ser-lote.nr-nota-fis = hisdis.nota-fiscal.nr-nota-fis and                               
                               hisdis.fat-ser-lote.nr-seq-fat  = hisdis.it-nota-fisc.nr-seq-fat exclusive-lock:

                          assign i-cont-aux2 = i-cont-aux2 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                          run bhp/bh0202b.p ("fat-ser-lote", rowid(hisdis.fat-ser-lote)).
                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 5
                                     tt-erro-bh.r-rowid  = ROWID(hisdis.fat-ser-lote).
                              UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                          END.

                          on delete of hisdis.fat-ser-lote override do: end.
                          delete hisdis.fat-ser-lote validate(true,"").

                          find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-ser-lote" no-error.
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                      end.

                      {utp/ut-liter.i Narrativas}.
                      assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                             i-cont-aux2      = 0.

                      for each hisdis.nar-it-nota where 
                               hisdis.nar-it-nota.cod-estabel  = hisdis.nota-fiscal.cod-estabel and
                               hisdis.nar-it-nota.serie        = hisdis.nota-fiscal.serie       and
                               hisdis.nar-it-nota.nr-nota-fis  = hisdis.nota-fiscal.nr-nota-fis and
                               hisdis.nar-it-nota.nr-sequencia = hisdis.it-nota-fisc.nr-seq-fat exclusive-lock:

                          assign i-cont-aux2 = i-cont-aux2 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                          run bhp/bh0202b.p ("nar-it-nota", rowid(hisdis.nar-it-nota)).

                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 6
                                     tt-erro-bh.r-rowid  = ROWID(hisdis.nar-it-nota).
                              UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                          END.

                          on delete of hisdis.nar-it-nota override do: end.
                          delete hisdis.nar-it-nota validate (true, "").

                          find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nar-it-nota" no-error.                             
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

                      end.

                      {utp/ut-liter.i Imposto}.
                      assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                             i-cont-aux2      = 0.

                      for each hisdis.it-nota-imp of hisdis.it-nota-fisc exclusive-lock:

                          assign i-cont-aux2 = i-cont-aux2 + 1.
                          run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                          run bhp/bh0202b.p ("it-nota-imp", rowid(hisdis.it-nota-imp)).

                          IF  RETURN-VALUE = "NOK":U THEN DO:
                              CREATE tt-erro-bh.
                              ASSIGN tt-erro-bh.i-tabela = 3
                                     tt-erro-bh.r-rowid  = ROWID(hisdis.it-nota-imp).
                              UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                          END.

                          on delete of hisdis.it-nota-imp override do: end.
                          delete hisdis.it-nota-imp validate (true, "").

                          find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "it-nota-imp" no-error.
                          assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

                      end.                      

                      run bhp/bh0202b.p ("it-nota-fisc", rowid(hisdis.it-nota-fisc)).

                      IF  RETURN-VALUE = "NOK":U THEN DO:
                          CREATE tt-erro-bh.
                          ASSIGN tt-erro-bh.i-tabela = 2
                                 tt-erro-bh.r-rowid  = ROWID(hisdis.it-nota-fisc).
                          UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                      END.

                      on delete of hisdis.it-nota-fisc override do: end.
                      delete hisdis.it-nota-fisc validate(true, "").

                      find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "it-nota-fisc" no-error.
                      assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             /* -------------------------- Importa hisdis.fat-repre --------------------------- */
             {utp/ut-liter.i Representantes}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each hisdis.fat-repre where 
                      hisdis.fat-repre.cod-estabel = hisdis.nota-fiscal.cod-estabel and
                      hisdis.fat-repre.serie       = hisdis.nota-fiscal.serie       and
                      hisdis.fat-repre.nr-fatura   = hisdis.nota-fiscal.nr-fatura exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("fat-repre", rowid(hisdis.fat-repre)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 7
                            tt-erro-bh.r-rowid  = ROWID(hisdis.fat-repre).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 on delete of hisdis.fat-repre override do: end.
                 delete hisdis.fat-repre validate(true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-repre" no-error.                        
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

             end.

             /* -------------------------- Importa hisdis.fat-duplic -------------------------- */
             {utp/ut-liter.i Faturas}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each hisdis.fat-duplic where 
                      hisdis.fat-duplic.cod-estabel = hisdis.nota-fiscal.cod-estabel and
                      hisdis.fat-duplic.serie       = hisdis.nota-fiscal.serie       and
                      hisdis.fat-duplic.nr-fatura   = hisdis.nota-fiscal.nr-fatura exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("fat-duplic", rowid(hisdis.fat-duplic)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 8
                            tt-erro-bh.r-rowid  = ROWID(hisdis.fat-duplic).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 /* ---------------------- Elimina‡Æo Tabela de Locks ---------------------- */
                    find first his-fat-duplic where 
                               his-fat-duplic.cod-estabel  = hisdis.fat-duplic.cod-estabel   and
                               his-fat-duplic.serie        = hisdis.fat-duplic.serie        and  
                               his-fat-duplic.nr-fatura    = hisdis.fat-duplic.nr-fatura    and
                               his-fat-duplic.ind-fat-nota = hisdis.fat-duplic.ind-fat-nota and
                               his-fat-duplic.flag-atualiz = hisdis.fat-duplic.flag-atualiz and
                               his-fat-duplic.parcela      = hisdis.fat-duplic.parcela Exclusive-lock no-error.
                    if avail his-fat-duplic then delete his-fat-duplic validate(true,"").
                 /* ------------------------------------------------------------------------ */

                 on delete of hisdis.fat-duplic override do: end.
                 delete hisdis.fat-duplic validate(true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-duplic" no-error.                        
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.                      

             end.

             /* --------------------- Importa hisdis.nota-embal/hisdis.item-embal -------------------- */
             {utp/ut-liter.i Embalagens}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.
             for each hisdis.nota-embal of hisdis.nota-fiscal exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).             

                 {utp/ut-liter.i Itens_Embal}.
                 assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                        i-cont-aux2      = 0.

                 for each hisdis.item-embal where 
                          hisdis.item-embal.sigla-emb   = hisdis.nota-embal.sigla-emb   and
                          hisdis.item-embal.cod-estabel = hisdis.nota-embal.cod-estabel and
                          hisdis.item-embal.serie       = hisdis.nota-embal.serie       and
                          hisdis.item-embal.nr-nota-fis = hisdis.nota-embal.nr-nota-fis exclusive-lock:

                     assign i-cont-aux2 = i-cont-aux2 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).                                                                      

                     run bhp/bh0202b.p ("item-embal", rowid(hisdis.item-embal)).

                     IF  RETURN-VALUE = "NOK":U THEN DO:
                         CREATE tt-erro-bh.
                         ASSIGN tt-erro-bh.i-tabela = 10
                                tt-erro-bh.r-rowid  = ROWID(hisdis.item-embal).
                         UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                     END.

                     on delete of hisdis.item-embal override do: end.
                     delete hisdis.item-embal validate (true, "").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "item-embal" no-error.                    
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

                 end.

                 run bhp/bh0202b.p ("nota-embal", rowid(hisdis.nota-embal)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 9
                            tt-erro-bh.r-rowid  = ROWID(hisdis.nota-embal).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 on delete of hisdis.nota-embal override do: end.
                 delete hisdis.nota-embal validate (true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nota-embal" no-error.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             /* --------------------------- Importa hisdis.devol-cli -------------------------- */
             {utp/ut-liter.i Devolu‡äes}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.                                        

             for each hisdis.devol-cli of hisdis.nota-fiscal exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("devol-cli", rowid(hisdis.devol-cli)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 11
                            tt-erro-bh.r-rowid  = ROWID(hisdis.devol-cli).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 on delete of hisdis.devol-cli override do: end.
                 delete hisdis.devol-cli validate (true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "devol-cli" no-error.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

             end.                      

             /* -------------------------- Importa hisdis.nota-trans -------------------------- */
             {utp/ut-liter.i Transp_Aut}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.                                        

             for each hisdis.nota-trans of hisdis.nota-fiscal exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("nota-trans", rowid(hisdis.nota-trans)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 4
                            tt-erro-bh.r-rowid  = ROWID(hisdis.nota-trans).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 on delete of hisdis.nota-trans override do: end.
                 delete hisdis.nota-trans validate (true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nota-trans" no-error.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.                      

/***********************************************************************************************************************************/
             /* -------------------------- Importa hisdis.item-nfs-st -------------------------- */
             {utp/ut-liter.i ST_Antecip}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.                                        

             for each hisdis.item-nfs-st 
                WHERE hisdis.item-nfs-st.cod-docto-nfs = hisdis.nota-fiscal.nr-nota-fis
                  AND hisdis.item-nfs-st.cod-estab-nfs = hisdis.nota-fiscal.cod-estabel
                  AND hisdis.item-nfs-st.cod-ser-nfs   = hisdis.nota-fiscal.serie exclusive-lock:


                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("item-nfs-st", rowid(hisdis.item-nfs-st)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 26
                            tt-erro-bh.r-rowid  = ROWID(hisdis.item-nfs-st).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 on delete of hisdis.item-nfs-st override do: end.
                 delete hisdis.item-nfs-st validate (true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "item-nfs-st" no-error.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.   

/***********************************************************************************************************************************/
             
             /* -------------------------- Importa hisdis.sit-nf-eletro --------------------------- */
             {utp/ut-liter.i Situa‡Æo_Notas_Fiscais_Eletronicas}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each hisdis.sit-nf-eletro where 
                      hisdis.sit-nf-eletro.cod-estabel     = hisdis.nota-fiscal.cod-estabel and
                      hisdis.sit-nf-eletro.cod-serie       = hisdis.nota-fiscal.serie       and
                      hisdis.sit-nf-eletro.cod-nota-fisc   = hisdis.nota-fiscal.nr-nota-fis exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("sit-nf-eletro", rowid(hisdis.sit-nf-eletro)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 7
                            tt-erro-bh.r-rowid  = ROWID(hisdis.sit-nf-eletro).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 on delete of hisdis.sit-nf-eletro override do: end.
                 delete hisdis.sit-nf-eletro validate(true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "sit-nf-eletro" no-error.                        
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

             end.

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

             /* -------------------------- Importa hisdis.ret-nf-eletro --------------------------- */
             {utp/ut-liter.i Representantes}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each hisdis.ret-nf-eletro where 
                      hisdis.ret-nf-eletro.cod-estabel   = hisdis.nota-fiscal.cod-estabel and
                      hisdis.ret-nf-eletro.cod-serie     = hisdis.nota-fiscal.serie       and
                      hisdis.ret-nf-eletro.nr-nota-fis   = hisdis.nota-fiscal.nr-nota-fis exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("ret-nf-eletro", rowid(hisdis.ret-nf-eletro)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 7
                            tt-erro-bh.r-rowid  = ROWID(hisdis.ret-nf-eletro).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 on delete of hisdis.ret-nf-eletro override do: end.
                 delete hisdis.ret-nf-eletro validate(true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "ret-nf-eletro" no-error.                        
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

             end.

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*
             /* -------------------------- Importa hisdis.fat-repre --------------------------- */
             {utp/ut-liter.i Representantes}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.

             for each hisdis.fat-repre where 
                      hisdis.fat-repre.cod-estabel = hisdis.nota-fiscal.cod-estabel and
                      hisdis.fat-repre.serie       = hisdis.nota-fiscal.serie       and
                      hisdis.fat-repre.nr-fatura   = hisdis.nota-fiscal.nr-fatura exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("fat-repre", rowid(hisdis.fat-repre)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 7
                            tt-erro-bh.r-rowid  = ROWID(hisdis.fat-repre).
                     UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                 END.

                 on delete of hisdis.fat-repre override do: end.
                 delete hisdis.fat-repre validate(true, "").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-repre" no-error.                        
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

             end.*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
                                    
             /* ----------------------------------------------------------------------- */
            /* --------------------------- Importa eSocial --------------------------- */
            /* ----------------------------------------------------------------------- */

            {utp/ut-liter.i eSocial}
            assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": "
                   i-cont-aux1      = 0.

            for each hisadm.nota-fisc-social where 
                     hisadm.nota-fisc-social.cod-estabel   = hisdis.nota-fiscal.cod-estabel and
                     hisadm.nota-fisc-social.cod-serie     = hisdis.nota-fiscal.serie       and
                     hisadm.nota-fisc-social.cod-nota-fisc = hisdis.nota-fiscal.nr-nota-fis exclusive-lock :
        
                    assign i-cont-aux1 = i-cont-aux1 + 1.
                    run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).
                    
                    /*----- Importa item-nota-social -----*/
                    {utp/ut-liter.i eSocial}
                    assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value).

                    {utp/ut-liter.i Itens}
                    assign c-acompanha-aux2 = c-acompanha-aux1 + "/" + trim(return-value) + ": "
                           i-cont-aux2      = 0.
        
                    for each hisadm.item-nota-social of hisadm.nota-fisc-social exclusive-lock:

                        assign i-cont-aux2 = i-cont-aux2 + 1.
                        run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux1) + "/" + string(i-cont-aux2)).
                        
                        run bhp/bh0202b.p("item-nota-social", rowid(hisadm.item-nota-social)).
        
                        if return-value = "NOK":U then do:
                            create tt-erro-bh.
                            assign tt-erro-bh.i-tabela = 30
                                   tt-erro-bh.r-rowid  = rowid(hisadm.item-nota-social).
                            undo Blk_NotaFiscal, next Blk_NotaFiscal.
                        end.
        
                        on delete of hisadm.item-nota-social override do: end.
                        delete hisadm.item-nota-social validate (true,"").
        
                        find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "item-nota-social" no-error.
                        assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                    end.
        
                    run bhp/bh0202b.p ("nota-fisc-social", rowid(hisadm.nota-fisc-social)).
        
                    IF  RETURN-VALUE = "NOK":U THEN DO:
                        CREATE tt-erro-bh.
                        ASSIGN tt-erro-bh.i-tabela = 29
                               tt-erro-bh.r-rowid  = ROWID(hisadm.nota-fisc-social).
                        UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
                    END.
        
                    on delete of hisadm.nota-fisc-social override do: end.
                    delete hisadm.nota-fisc-social validate(true,"").
        
                    find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nota-fisc-social" no-error.
                    assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
            end.

/***********************************************************************************************************************************/

             run bhp/bh0202b.p ("nota-fiscal", rowid(hisdis.nota-fiscal)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 1
                        tt-erro-bh.r-rowid  = ROWID(hisdis.nota-fiscal).
                 UNDO Blk_NotaFiscal, NEXT Blk_NotaFiscal.
             END.

             /* ------------------------- Cria Tabela de Locks ------------------------- */
                find first his-nota-fiscal where 
                           his-nota-fiscal.cod-estabel = hisdis.nota-fiscal.cod-estabel and
                           his-nota-fiscal.serie       = hisdis.nota-fiscal.serie       and
                           his-nota-fiscal.nr-nota-fis = hisdis.nota-fiscal.nr-nota-fis Exclusive-lock no-error.
                if avail his-nota-fiscal then delete his-nota-fiscal validate(true,"").
             /* ------------------------------------------------------------------------ */

             on delete of hisdis.nota-fiscal override do: end.
             delete hisdis.nota-fiscal validate (true, "").

             find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "nota-fiscal" no-error.               
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.

    {bhp/bh0202a.i} /* Importa‡Æo de Pedidos */
    
End Procedure.


Procedure Pi-Importa-Estatistica:


    /* ----------------------------------------------------------------------- */
    /* ------------------------- Importa Estat¡stica ------------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Estat¡sticas}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.

    Blk_FatEstat:
    for each hisdis.fat-estat where 
             hisdis.fat-estat.data-estat >= tt-param.da-per-corte exclusive-lock transaction:

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             run bhp/bh0202b.p ("fat-estat", rowid(hisdis.fat-estat)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 19
                        tt-erro-bh.r-rowid  = ROWID(hisdis.fat-estat).
                 UNDO Blk_FatEstat, NEXT Blk_FatEstat.
             END.

             on delete of hisdis.fat-estat override do: end.
             delete hisdis.fat-estat validate(true,"").

             find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "fat-estat" no-error.
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.

End Procedure.


Procedure Pi-Importa-OF:


    /* ----------------------------------------------------------------------- */
    /* --------------------- Importa Obriga‡äes Fiscais ---------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Obriga‡äes_Fiscais}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.

    Blk_DocFiscal:
    for each hisdis.doc-fiscal where
        year(hisdis.doc-fiscal.dt-docto) >= tt-param.ano-of exclusive-lock transaction:

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             /* ------------------------- Importa hisdis.it-doc-fisc -------------------------- */
             {utp/ut-liter.i Itens}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.  

             for each hisdis.it-doc-fisc of hisdis.doc-fiscal exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).                          

                 run bhp/bh0202b.p ("it-doc-fisc", rowid(hisdis.it-doc-fisc)).

                 IF  return-value = "NOK":U  THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 21
                            tt-erro-bh.r-rowid  = ROWID(hisdis.it-doc-fisc).
                     UNDO Blk_DocFiscal, NEXT Blk_DocFiscal.
                 END.

                 on delete of hisdis.it-doc-fisc override do: end.
                 delete hisdis.it-doc-fisc validate(true,"").

                 find first tt-estat-modulo where c-nom-tab = "it-doc-fisc" no-error.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             /* Convenio 15 */
             for first hisdis.ext-doc-fiscal 
                 where hisdis.ext-doc-fiscal.cod-estabel  = hisdis.doc-fiscal.cod-estabel 
                 and   hisdis.ext-doc-fiscal.serie        = hisdis.doc-fiscal.serie       
                 and   hisdis.ext-doc-fiscal.nr-doc-fis   = hisdis.doc-fiscal.nr-doc-fis  
                 and   hisdis.ext-doc-fiscal.cod-emitente = hisdis.doc-fiscal.cod-emitente
                 and   hisdis.ext-doc-fiscal.nat-operacao = hisdis.doc-fiscal.nat-operacao exclusive-lock:

                 run bhp/bh0202b.p ("ext-doc-fiscal", rowid(hisdis.ext-doc-fiscal)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 25
                            tt-erro-bh.r-rowid  = ROWID(hisdis.ext-doc-fiscal).
                     UNDO Blk_DocFiscal, NEXT Blk_DocFiscal.
                 END.

                 on delete of hisdis.ext-doc-fiscal override do: end.
                 delete hisdis.ext-doc-fiscal validate(true,"").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "ext-doc-fiscal" no-error.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             run bhp/bh0202b.p ("doc-fiscal", rowid(hisdis.doc-fiscal)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 20
                        tt-erro-bh.r-rowid  = ROWID(hisdis.doc-fiscal).
                 UNDO Blk_DocFiscal, NEXT Blk_DocFiscal.
             END.

             /* ------------------------- Cria Tabela de Locks ------------------------- */
                find first his-doc-fiscal where 
                           his-doc-fiscal.cod-estabel  = hisdis.doc-fiscal.cod-estabel  and
                           his-doc-fiscal.serie        = hisdis.doc-fiscal.serie        and
                           his-doc-fiscal.nr-doc-fis   = hisdis.doc-fiscal.nr-doc-fis   and
                           his-doc-fiscal.cod-emitente = hisdis.doc-fiscal.cod-emitente and
                           his-doc-fiscal.nat-operacao = hisdis.doc-fiscal.nat-operacao Exclusive-lock no-error.
                if avail his-doc-fiscal then delete his-doc-fiscal validate(true,"").
             /* ------------------------------------------------------------------------ */ 

             on delete of hisdis.doc-fiscal override do: end.
             delete hisdis.doc-fiscal.

             find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "doc-fiscal" no-error.
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.                          

    /* ----------------------------------------------------------------------- */
    /* ---------------------- Importa Apura‡Æo Imposto ----------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Apura‡Æo_Imposto}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.         

    Blk_ApurImposto:
    for each hisdis.apur-imposto where
             hisdis.apur-imposto.dt-apur-fim >= tt-param.da-per-corte exclusive-lock transaction:

             assign i-cont = i-cont + 1.
             run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

             /* -------------------------- Importa hisdis.imp-valor --------------------------- */
             {utp/ut-liter.i Imposto}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.      

             for each hisdis.imp-valor of hisdis.apur-imposto exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("imp-valor", rowid(hisdis.imp-valor)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 23
                            tt-erro-bh.r-rowid  = ROWID(hisdis.imp-valor).
                     UNDO Blk_ApurImposto, NEXT Blk_ApurImposto.
                 END.

                 on delete of hisdis.imp-valor override do: end.
                 delete hisdis.imp-valor validate(true,"").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "imp-valor" no-error.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             /* ------------------------- Importa hisdis.imposto-guia ------------------------- */
             {utp/ut-liter.i Guia}.
             assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                    i-cont-aux1      = 0.        

             for each hisdis.imposto-guia of hisdis.apur-imposto exclusive-lock:

                 assign i-cont-aux1 = i-cont-aux1 + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                 run bhp/bh0202b.p ("imposto-guia", rowid(hisdis.imposto-guia)).

                 IF  RETURN-VALUE = "NOK":U THEN DO:
                     CREATE tt-erro-bh.
                     ASSIGN tt-erro-bh.i-tabela = 24
                            tt-erro-bh.r-rowid  = ROWID(hisdis.imposto-guia).
                     UNDO Blk_ApurImposto, NEXT Blk_ApurImposto.
                 END.

                 on delete of hisdis.imposto-guia override do: end.
                 delete hisdis.imposto-guia validate(true,"").

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "imposto-guia" no-error.
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
             end.

             run bhp/bh0202b.p ("apur-imposto", rowid(hisdis.apur-imposto)).

             IF  RETURN-VALUE = "NOK":U THEN DO:
                 CREATE tt-erro-bh.
                 ASSIGN tt-erro-bh.i-tabela = 22
                        tt-erro-bh.r-rowid  = ROWID(hisdis.apur-imposto).
                 UNDO Blk_ApurImposto, NEXT Blk_ApurImposto.
             END.

             /* ------------------------- Cria Tabela de Locks ------------------------- 
                find first his-apur-imposto where 
                           his-apur-imposto.cod-estabel = hisdis.apur-imposto.cod-estabel and
                           his-apur-imposto.tp-imposto  = hisdis.apur-imposto.tp-imposto  and
                           his-apur-imposto.dt-apur-ini = hisdis.apur-imposto.dt-apur-ini and
                           his-apur-imposto.dt-apur-fim = hisdis.apur-imposto.dt-apur-fim no-error.
                if avail his-apur-imposto then delete his-apur-imposto validate(true,"").
                ------------------------------------------------------------------------ */ 

             on delete of hisdis.apur-imposto override do: end.
             delete hisdis.apur-imposto.

             find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "apur-imposto" no-error.
             assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
    end.         
End Procedure.


Procedure Pi-Importa-Cotacao:


    /* ----------------------------------------------------------------------- */
    /* --------------------------- Importa Cota‡äes -------------------------- */
    /* ----------------------------------------------------------------------- */

    {utp/ut-liter.i Exportando_Cota‡äes}.
    assign c-acompanha = trim(return-value)
           i-cont      = 0.
    &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
        for each hisdis.cot-ped-v where
                 hisdis.cot-ped-v.dt-implant >= tt-param.da-per-corte exclusive-lock transaction:

                 assign i-cont = i-cont + 1.
                 run pi-acompanhar in h-acomp (input c-acompanha + ": " + string(i-cont)).

                 /* ---------- Importa hisdis.cot-ped-i/hisdis.cot-nar-it/hisdis.cot-ent/hisdis.cot-desconto ----------- */
                 {utp/ut-liter.i Itens}.
                 assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                        i-cont-aux1      = 0.                    
                 for each hisdis.cot-ped-i of hisdis.cot-ped-v exclusive-lock:

                     assign i-cont-aux1 = i-cont-aux1 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).

                     {utp/ut-liter.i Narrativa}
                     assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                            i-cont-aux2      = 0.

                     for each hisdis.cot-nar-it of hisdis.cot-ped-i exclusive-lock:

                         assign i-cont-aux2 = i-cont-aux2 + 1.
                         run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                         run bhp/bh0202c.p ("cot-nar-it", rowid(hisdis.cot-nar-it)).
                         on delete of hisdis.cot-nar-it override do: end.
                         delete hisdis.cot-nar-it validate(true,"").

                         find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cot-nar-it" no-error.
                         assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.

                     end.                        

                     {utp/ut-liter.i Desconto}.
                     assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                            i-cont-aux2      = 0.

                     for each hisdis.cot-desconto where 
                              hisdis.cot-desconto.nome-abrev   = hisdis.cot-ped-v.nome-abrev   and
                              hisdis.cot-desconto.nr-pedcli    = hisdis.cot-ped-v.nr-pedcli    and
                              hisdis.cot-desconto.nr-sequencia = hisdis.cot-ped-i.nr-sequencia exclusive-lock:

                         assign i-cont-aux2 = i-cont-aux2 + 1.
                         run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                         run bhp/bh0202c.p ("cot-desconto", rowid(hisdis.cot-desconto)).
                         on delete of hisdis.cot-desconto override do: end.
                         delete hisdis.cot-desconto validate(true,"").

                         find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cot-desconto" no-error.
                         assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                     end.                                  

                     {utp/ut-liter.i Entregas}.
                     assign c-acompanha-aux2 = c-acompanha + "/" + trim(return-value) + ": ".
                            i-cont-aux2      = 0.

                     for each hisdis.cot-ent where 
                              hisdis.cot-ent.nome-abrev   = hisdis.cot-ped-v.nome-abrev   and
                              hisdis.cot-ent.nr-pedcot    = hisdis.cot-ped-v.nr-pedcli    and
                              hisdis.cot-ent.nr-sequencia = hisdis.cot-ped-i.nr-sequencia and
                              hisdis.cot-ent.it-codigo    = hisdis.cot-ped-i.item-cotacao exclusive-lock:

                         assign i-cont-aux2 = i-cont-aux2 + 1.
                         run pi-acompanhar in h-acomp (input c-acompanha-aux2 + string(i-cont) + "/" + string(i-cont-aux2)).

                         run bhp/bh0202c.p ("cot-ent", rowid(hisdis.cot-ent)).
                         on delete of hisdis.cot-ent override do: end.
                         delete hisdis.cot-ent validate(true,"").

                         find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cot-ent" no-error.
                         assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                     end.                 

                     run bhp/bh0202c.p ("cot-ped-i", rowid(hisdis.cot-ped-i)).
                     on delete of hisdis.cot-ped-i override do: end.
                     delete hisdis.cot-ped-i validate(true,"").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cot-ped-i" no-error.                 
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 end.

                 /* --------------------------- Importa hisdis.con-pges --------------------------- */
                 {utp/ut-liter.i Condi‡Æo_Pagamento_Especial}.
                 assign c-acompanha-aux1 = c-acompanha + "/" + trim(return-value) + ": ".
                        i-cont-aux1      = 0.

                 for each hisdis.con-pges where hisdis.con-pges.nr-pedido = hisdis.cot-ped-v.nr-pedido EXCLUSIVE-LOCK:

                     assign i-cont-aux1 = i-cont-aux1 + 1.
                     run pi-acompanhar in h-acomp (input c-acompanha-aux1 + string(i-cont) + "/" + string(i-cont-aux1)).                          

                     run bhp/bh0202c.p ("con-pges", rowid(hisdis.con-pges)).
                     on delete of hisdis.con-pges override do: end.
                     delete hisdis.con-pges validate(true,"").

                     find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "con-pges" no-error.
                     assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
                 end.             

                 run bhp/bh0202c.p ("cot-ped-v", rowid(hisdis.cot-ped-v)).

                 /* ------------------------- Cria Tabela de Locks ------------------------- */
                    find first his-cot-ped-v where 
                               his-cot-ped-v.nr-pedido = hisdis.cot-ped-v.nr-pedido no-error.
                    if avail his-cot-ped-v then delete his-cot-ped-v validate(true,"").
                 /* ------------------------------------------------------------------------ */ 

                 on delete of hisdis.cot-ped-v override do: end.
                 delete hisdis.cot-ped-v.

                 find first tt-estat-modulo where tt-estat-modulo.c-nom-tab = "cot-ped-v" no-error.             
                 assign tt-estat-modulo.i-modulo = tt-estat-modulo.i-modulo + 1.
        end.                      
    &ENDIF
End Procedure.


Procedure Pi-Imprime-Estat¡stica:


    define variable c-modulo-ant as character no-undo.

    assign c-programa = "BH0202"
           c-versao   = "2.00.00"
           c-revisao  = "000"
           c-empresa  = param-global.grupo.

    {utp/ut-liter.i Bancos_Hist¢ricos * C}                                c-sistema      = trim(return-value).
    {utp/ut-liter.i Estat¡sticas_Import._p/_Banco_de_Movimentos * C} c-titulo-relat = trim(return-value).

    view frame f-cabec.
    view frame f-rodape.

    /* ---------------------- Imprime Relat¢rio de Erros ---------------------- */
    IF  CAN-FIND (FIRST tt-erro-bh) THEN DO:
        {utp/ut-liter.i REGISTROS_QUE_APRESENTARAM_PROBLEMAS_NA_IMPORTA€ÇO_PARA_OS_BANCOS_DE_MOVIMENTOS}
        PUT UNFORMATTED FILL("-",(132 - (INT((132 - LENGTH(TRIM(RETURN-VALUE))) / 2)) - LENGTH(TRIM(RETURN-VALUE))))
                    TRIM(RETURN-VALUE)  FILL("-",(INT((132 - LENGTH(TRIM(RETURN-VALUE))) / 2))) SKIP(1).                        

        /* 1 - nota-fiscal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 1) THEN DO:

            {utp/ut-liter.i Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 1,
                FIRST hisdis.nota-fiscal FIELDS(cod-estabel serie nr-nota-fis)
                WHERE ROWID(hisdis.nota-fiscal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.nota-fiscal.cod-estabel  
                     hisdis.nota-fiscal.serie        
                     hisdis.nota-fiscal.nr-nota-fis WITH FRAME f-nota-fiscal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 2 - it-nota-fisc */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 2) THEN DO:

            {utp/ut-liter.i Itens_Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 2,
                FIRST hisdis.it-nota-fisc FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat it-codigo)
                WHERE ROWID(hisdis.it-nota-fisc) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.it-nota-fisc.cod-estabel  
                     hisdis.it-nota-fisc.serie        
                     hisdis.it-nota-fisc.nr-nota-fis 
                     hisdis.it-nota-fisc.nr-seq-fat
                     hisdis.it-nota-fisc.it-codigo
                     WITH FRAME f-it-nota-fisc DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 3 - it-nota-imp */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 3) THEN DO:

            {utp/ut-liter.i Impostos_Itens}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 3,
                FIRST hisdis.it-nota-imp FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat it-codigo nr-seq-imp)
                WHERE ROWID(hisdis.it-nota-imp) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.it-nota-imp.cod-estabel  
                     hisdis.it-nota-imp.serie        
                     hisdis.it-nota-imp.nr-nota-fis 
                     hisdis.it-nota-imp.nr-seq-fat
                     hisdis.it-nota-imp.it-codigo
                     hisdis.it-nota-imp.nr-seq-imp
                     WITH FRAME f-it-nota-imp DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 4 - nota-trans */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 4) THEN DO:

            {utp/ut-liter.i Notas_Transportes}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 4,
                FIRST hisdis.nota-trans FIELDS(cod-estabel serie nr-nota-fis)
                WHERE ROWID(hisdis.nota-trans) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.nota-trans.cod-estabel  
                     hisdis.nota-trans.serie        
                     hisdis.nota-trans.nr-nota-fis 
                     WITH FRAME f-nota-trans DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 5 - fat-ser-lote */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 5) THEN DO:

            {utp/ut-liter.i Aloca‡Æo_Itens_Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 5,
                FIRST hisdis.fat-ser-lote FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat cod-depos 
                                          cod-localiz nr-serlote it-codigo 
                                          &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                                          cod-refer
                                          &endif )
                WHERE ROWID(hisdis.fat-ser-lote) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.fat-ser-lote.cod-estabel  
                     hisdis.fat-ser-lote.serie        
                     hisdis.fat-ser-lote.nr-nota-fis 
                     hisdis.fat-ser-lote.nr-seq-fat
                     hisdis.fat-ser-lote.cod-depos
                     hisdis.fat-ser-lote.cod-localiz
                     hisdis.fat-ser-lote.nr-serlote
                     hisdis.fat-ser-lote.it-codigo
                     &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                     hisdis.fat-ser-lote.cod-refer
                     &ENDIF
                     WITH FRAME f-fat-ser-lote DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 6 - nar-it-nota */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 6) THEN DO:

            {utp/ut-liter.i Narrativa_Itens_Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 6,
                FIRST hisdis.nar-it-nota FIELDS(cod-estabel serie nr-nota-fis nr-sequencia)
                WHERE ROWID(hisdis.nar-it-nota) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.nar-it-nota.cod-estabel  
                     hisdis.nar-it-nota.serie        
                     hisdis.nar-it-nota.nr-nota-fis 
                     hisdis.nar-it-nota.nr-sequencia
                     WITH FRAME f-nar-it-nota DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 7 - fat-repre */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 7) THEN DO:

            {utp/ut-liter.i Representante_Fatura}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 7,
                FIRST hisdis.fat-repre FIELDS(cod-estabel serie nr-fatura nome-ab-rep &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN cod-classificador &endif )
                WHERE ROWID(hisdis.fat-repre) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.fat-repre.cod-estabel  
                     hisdis.fat-repre.serie        
                     hisdis.fat-repre.nr-fatura
                     hisdis.fat-repre.nome-ab-rep
                     &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                     hisdis.fat-repre.cod-classificador
                     &ENDIF
                     WITH FRAME f-fat-repre DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 8 - fat-duplic */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 8) THEN DO:

            {utp/ut-liter.i Faturas_Nota_Fiscal}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 8,
                FIRST hisdis.fat-duplic FIELDS(cod-estabel serie nr-fatura parcela)
                WHERE ROWID(hisdis.fat-duplic) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.fat-duplic.cod-estabel  
                     hisdis.fat-duplic.serie        
                     hisdis.fat-duplic.nr-fatura
                     hisdis.fat-duplic.parcela
                     WITH FRAME f-fat-duplic DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 9 - nota-embal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 9) THEN DO:

            {utp/ut-liter.i Embalagens_Nota_Fiscal}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 9,
                FIRST hisdis.nota-embal FIELDS(cod-estabel serie nr-nota-fis sigla-emb)
                WHERE ROWID(hisdis.nota-embal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.nota-embal.cod-estabel  
                     hisdis.nota-embal.serie        
                     hisdis.nota-embal.nr-nota-fis 
                     hisdis.nota-embal.sigla-emb
                     WITH FRAME f-nota-embal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 10 - item-embal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 10) THEN DO:

            {utp/ut-liter.i Embalagens_Itens_Notas_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 10,
                FIRST hisdis.item-embal FIELDS(cod-estabel serie nr-nota-fis nr-seq-fat it-codigo sigla-emb)
                WHERE ROWID(hisdis.item-embal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.item-embal.cod-estabel  
                     hisdis.item-embal.serie        
                     hisdis.item-embal.nr-nota-fis 
                     hisdis.item-embal.nr-seq-fat
                     hisdis.item-embal.it-codigo
                     hisdis.item-embal.sigla-emb
                     WITH FRAME f-item-embal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 11 - devol-cli */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 11) THEN DO:

            {utp/ut-liter.i Devolu‡Æo_Clientes}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 11,
                FIRST hisdis.devol-cli FIELDS(dt-devol nome-ab-emi it-codigo cod-estabel)
                WHERE ROWID(hisdis.devol-cli) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.devol-cli.serie-docto 
                     hisdis.devol-cli.nro-docto   
                     hisdis.devol-cli.cod-emitente
                     hisdis.devol-cli.nat-operacao
                     hisdis.devol-cli.sequencia   
                     hisdis.devol-cli.cod-estabel 
                     hisdis.devol-cli.serie       
                     hisdis.devol-cli.nr-nota-fis 
                     hisdis.devol-cli.nr-sequencia
                     hisdis.devol-cli.it-codigo   
                     WITH FRAME f-devol-cli DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 12 - ped-venda */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 12) THEN DO:

            {utp/ut-liter.i Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 12,
                FIRST hisdis.ped-venda FIELDS(nome-abrev nr-pedcli)
                WHERE ROWID(hisdis.ped-venda) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.ped-venda.nome-abrev
                     hisdis.ped-venda.nr-pedcli
                     WITH FRAME f-ped-venda DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 13 - ped-item */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 13) THEN DO:

            {utp/ut-liter.i Itens_Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 13,
                FIRST hisdis.ped-item FIELDS(nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer)
                WHERE ROWID(hisdis.ped-item) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.ped-item.nome-abrev
                     hisdis.ped-item.nr-pedcli
                     hisdis.ped-item.nr-sequencia
                     hisdis.ped-item.it-codigo
                     hisdis.ped-item.cod-refer
                     WITH FRAME f-ped-item DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 14 - ped-ent */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 14) THEN DO:

            {utp/ut-liter.i Entregas_Itens_Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 14,
                FIRST hisdis.ped-ent FIELDS(nome-abrev nr-pedcli nr-sequencia it-codigo cod-refer nr-entrega)
                WHERE ROWID(hisdis.ped-ent) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.ped-ent.nome-abrev
                     hisdis.ped-ent.nr-pedcli
                     hisdis.ped-ent.nr-sequencia
                     hisdis.ped-ent.it-codigo
                     hisdis.ped-ent.cod-refer
                     hisdis.ped-ent.nr-entrega
                     WITH FRAME f-ped-ent DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 16 - ped-repre */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 16) THEN DO:

            {utp/ut-liter.i Representantes_Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 16,
                FIRST hisdis.ped-repre FIELDS(nr-pedido nome-ab-rep &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN cod-classificador &endif )
                WHERE ROWID(hisdis.ped-repre) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.ped-repre.nr-pedido
                     hisdis.ped-repre.nome-ab-rep
                     &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                     hisdis.ped-repre.cod-classificador
                     &ENDIF
                     WITH FRAME f-ped-repre DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 18 - cond-ped */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 18) THEN DO:

            {utp/ut-liter.i Condi‡äes_Pagtos_Especiais_Pedidos_Vendas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 18,
                FIRST hisdis.cond-ped FIELDS(nr-pedido nr-sequencia)
                WHERE ROWID(hisdis.cond-ped) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.cond-ped.nr-pedido
                     hisdis.cond-ped.nr-sequencia
                     WITH FRAME f-cond-ped DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 19 - fat-estat */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 19) THEN DO:

            {utp/ut-liter.i Estat¡sticas_Faturamento}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 19,
                FIRST hisdis.fat-estat FIELDS(data-estat cod-estabel nome-ab-cli)
                WHERE ROWID(hisdis.fat-estat) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.fat-estat.data-estat
                     hisdis.fat-estat.cod-estabel
                     hisdis.fat-estat.nome-ab-cli
                     WITH FRAME f-fat-estat DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 20 - doc-fiscal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 20) THEN DO:

            {utp/ut-liter.i Documentos_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 20,
                FIRST hisdis.doc-fiscal FIELDS(cod-estabel serie nr-doc-fis cod-emitente nat-operacao)
                WHERE ROWID(hisdis.doc-fiscal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.doc-fiscal.cod-estabel  
                     hisdis.doc-fiscal.serie        
                     hisdis.doc-fiscal.nr-doc-fis   
                     hisdis.doc-fiscal.cod-emitente 
                     hisdis.doc-fiscal.nat-operacao 
                     WITH FRAME f-doc-fiscal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 21 - it-doc-fisc */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 21) THEN DO:

            {utp/ut-liter.i Itens_do_Documento_Fiscal}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).       

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 21,
                FIRST hisdis.it-doc-fisc FIELDS(cod-estabel serie nr-doc-fis cod-emitente nat-operacao nr-seq-doc it-codigo)
                WHERE ROWID(hisdis.it-doc-fisc) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.it-doc-fisc.cod-estabel  
                     hisdis.it-doc-fisc.serie        
                     hisdis.it-doc-fisc.nr-doc-fis   
                     hisdis.it-doc-fisc.cod-emitente 
                     hisdis.it-doc-fisc.nat-operacao 
                     hisdis.it-doc-fisc.nr-seq-doc   
                     hisdis.it-doc-fisc.it-codigo 
                     WITH FRAME f-it-doc-fisc DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 22 - apur-imposto */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 22) THEN DO:

            {utp/ut-liter.i Apura‡Æo_Impostos}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).       

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 22,
                FIRST hisdis.apur-imposto FIELDS(cod-estabel tp-imposto dt-apur-ini dt-apur-fim)
                WHERE ROWID(hisdis.apur-imposto) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.apur-imposto.cod-estabel
                     {diinc/i01di220.i 04 hisdis.apur-imposto.tp-imposto} 
                     hisdis.apur-imposto.dt-apur-ini
                     hisdis.apur-imposto.dt-apur-fim
                     WITH FRAME f-apur-imposto DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 23 - imp-valor */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 23) THEN DO:

            {utp/ut-liter.i Valor_Impostos}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).       

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 23,
                FIRST hisdis.imp-valor FIELDS(cod-estabel tp-imposto dt-apur-ini dt-apur-fim cod-lanc nr-sequencia)
                WHERE ROWID(hisdis.imp-valor) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.imp-valor.cod-estabel
                     {diinc/i01di220.i 04 hisdis.imp-valor.tp-imposto} 
                     hisdis.imp-valor.dt-apur-ini
                     hisdis.imp-valor.dt-apur-fim
                     hisdis.imp-valor.cod-lanc
                     hisdis.imp-valor.nr-sequencia
                     WITH FRAME f-imp-valor DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 24 - imposto-guia */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 24) THEN DO:

            {utp/ut-liter.i Guia_Impostos}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).       

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 24,
                FIRST hisdis.imposto-guia FIELDS(cod-estabel tp-imposto dt-apur-ini dt-apur-fim nr-guia nr-sequencia)
                WHERE ROWID(hisdis.imposto-guia) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.imposto-guia.cod-estabel
                     {diinc/i01di220.i 04 hisdis.imposto-guia.tp-imposto} 
                     hisdis.imposto-guia.dt-apur-ini
                     hisdis.imposto-guia.dt-apur-fim
                     hisdis.imposto-guia.nr-guia
                     hisdis.imposto-guia.nr-sequencia
                     WITH FRAME f-imposto-guia DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 25 - ext-doc-fiscal */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 25) THEN DO:

            {utp/ut-liter.i ExtensÆo_Documentos_Fiscais}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).
      
            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 25,
                FIRST hisdis.ext-doc-fiscal FIELDS(cod-estabel serie nr-doc-fis cod-emitente nat-operacao)
                WHERE ROWID(hisdis.ext-doc-fiscal) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.ext-doc-fiscal.cod-estabel  
                     hisdis.ext-doc-fiscal.serie        
                     hisdis.ext-doc-fiscal.nr-doc-fis   
                     hisdis.ext-doc-fiscal.cod-emitente 
                     hisdis.ext-doc-fiscal.nat-operacao 
                     WITH FRAME f-ext-doc-fiscal DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).

        END.

        /* 26 - item-nfs-st */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 26) THEN DO:

            {utp/ut-liter.i ST_Antecip}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 26,
                FIRST hisdis.item-nfs-st FIELDS(cod-docto-nfs cod-estab-nfs cod-ser-nfs)
                WHERE ROWID(hisdis.nota-trans) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.item-nfs-st.cod-docto-nfs
                     hisdis.item-nfs-st.cod-estab-nfs
                     hisdis.item-nfs-st.cod-ser-nfs  
                     WITH FRAME f-item-nfs-st DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.


        /* 27 - sit-nf-eletro */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 26) THEN DO:

            {utp/ut-liter.i Situa‡Æo_Notas_Fiscais_Eletronicas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).
      
            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 26,
                FIRST hisdis.sit-nf-eletro FIELDS(cod-nota-fisc cod-serie idi-sit-nf-eletro dt-emis-nota cod-estabel)
                WHERE ROWID(hisdis.sit-nf-eletro) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.sit-nf-eletro.cod-nota-fisc    
                     hisdis.sit-nf-eletro.cod-serie
                     hisdis.sit-nf-eletro.idi-sit-nf-eletro
                     hisdis.sit-nf-eletro.dt-emis-nota
                     hisdis.sit-nf-eletro.cod-estabel
                     WITH FRAME f-sit-nf-eletro DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).

        END.

        /* 28 - ret-nf-eletro */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 27) THEN DO:

            {utp/ut-liter.i Retorno_Notas_Fiscais_Eletronicas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).
      
            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 27,
                FIRST hisdis.ret-nf-eletro FIELDS(cod-estabel cod-serie nr-nota-fis cod-msg dat-ret hra-ret)
                WHERE ROWID(hisdis.ret-nf-eletro) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.ret-nf-eletro.cod-estabel
                     hisdis.ret-nf-eletro.cod-serie
                     hisdis.ret-nf-eletro.nr-nota-fis
                     hisdis.ret-nf-eletro.cod-msg
                     hisdis.ret-nf-eletro.dat-ret
                     hisdis.ret-nf-eletro.hra-ret
                     WITH FRAME f-ret-nf-eletro DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).

        END.
        /* 29 - nota-fisc-social */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 29) THEN DO:

            {utp/ut-liter.i eSocial}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 29,
                FIRST hisadm.nota-fisc-social FIELDS(cod-estabel cod-serie cod-nota-fisc)
                WHERE ROWID(hisadm.nota-fisc-social) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisadm.nota-fisc-social.cod-estabel  
                     hisadm.nota-fisc-social.cod-serie        
                     hisadm.nota-fisc-social.cod-nota-fis WITH FRAME f-nota-fisc-social DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

        /* 30 - item-nota-social */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 30) THEN DO:

            {utp/ut-liter.i Itens_eSocial}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).

            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 30,
                FIRST hisadm.item-nota-social FIELDS(cod-estabel cod-serie cod-nota-fisc cdn-serv-inss)
                WHERE ROWID(hisadm.item-nota-social) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisadm.item-nota-social.cod-estabel  
                     hisadm.item-nota-social.cod-serie        
                     hisadm.item-nota-social.cod-nota-fis 
                     hisadm.item-nota-social.cdn-serv-inss
                     WITH FRAME f-item-nota-social DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).
        END.

       
      /*  /* 29 - msg-ret-nf-e */
        IF  CAN-FIND (FIRST tt-erro-bh
                      WHERE tt-erro-bh.i-tabela = 25) THEN DO:

            {utp/ut-liter.i Mensagens_Retorno_Notas_Fiscais_Eletronicas}
            PUT UNFORMATTED TRIM(RETURN-VALUE) SKIP FILL("-",LENGTH(TRIM(RETURN-VALUE))).
      
            FOR EACH tt-erro-bh 
                WHERE tt-erro-bh.i-tabela = 25,
                FIRST hisdis.msg-ret-nf-e FIELDS()
                WHERE ROWID(hisdis.msg-ret-nfe) = tt-erro-bh.r-rowid NO-LOCK:
                DISP hisdis.msg-ret-nfe
                     hisdis.msg-ret-nfe
                     hisdis.msg-ret-nfe
                     hisdis.msg-ret-nfe
                     hisdis.msg-ret-nfe
                     
                     WITH FRAME f-msg-ret-nf-e DOWN STREAM-IO WIDTH 132.
            END.
            PUT SKIP(1).

        END.*/
        
    END.

    /* ------------------- Imprime Relat¢rio de Estat¡sticas ------------------ */
    {utp/ut-liter.i Imprimindo_Estat¡sticas}.    
    run pi-acompanhar in h-acomp (input trim(return-value)).    

    IF  CAN-FIND(FIRST tt-erro-bh) THEN
        PAGE.

    for each tt-estat-modulo WHERE 
        tt-estat-modulo.c-nom-tab <> "" break by tt-estat-modulo.c-nom-tab:

        disp tt-estat-modulo.c-modulo  
             tt-estat-modulo.c-nom-tab 
             tt-estat-modulo.c-tabela  
             tt-estat-modulo.i-modulo  SKIP WITH STREAM-IO WIDTH 132.
        down.

        assign de-total = de-total + tt-estat-modulo.i-modulo.      
    end.

    display de-total with frame f-total.

    /* --------------------- Imprime P gina de Parƒmetros --------------------- */
    {utp/ut-liter.i Imprimindo_Parƒmetros}.    
    run pi-acompanhar in h-acomp (input trim(return-value)).    
    page.   

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {varinc/var00002.i 04 tt-param.destino}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN  c-destino = RETURN-VALUE.
    &else
        ASSIGN c-destino = {varinc/var00002.i 04 tt-param.destino}.
    &endif
    Run utp/ut-liter.p (input c-destino,"*","").
    Assign c-destino = Return-value.

    {utp/ut-liter.i Sim * C}
    if  tt-param.l-pedfat  then c-pedfat  = trim(return-value).
    if  tt-param.l-estat   then c-estat   = trim(return-value).
    if  tt-param.l-of      then c-of      = trim(return-value).
    if  tt-param.l-cotacao then c-cotacao = trim(return-value).
    {utp/ut-liter.i NÆo * C}
    if  not tt-param.l-pedfat  then c-pedfat  = trim(return-value).
    if  not tt-param.l-estat   then c-estat   = trim(return-value).
    if  not tt-param.l-of      then c-of      = trim(return-value).
    if  not tt-param.l-cotacao then c-cotacao = trim(return-value).

    disp c-parametros
         tt-param.da-per-corte
         c-pedfat
         c-estat
         c-of
         c-cotacao
         c-impressao
         c-destino
         tt-param.arquivo
         tt-param.usuario
         with frame f-parametros.  

    if tt-param.ano-of <> 0000 then disp tt-param.ano-of with frame f-parametros.  

End Procedure.


Procedure Pi-Gera-tt-estat-modulo:

    define variable i-nr-tab      as integer initial 33 no-undo. /* Tabelas que fazem parte dos Bancos Hist¢ricos */
    define variable c-faturamento as character          no-undo.
    define variable c-pedido      as character          no-undo.
    define variable c-estatistica as character          no-undo.
    define variable c-obrigfisc   as character          no-undo.
    define variable c-cotacoes    as character          no-undo.

    for each tt-estat-modulo: delete tt-estat-modulo. end.

    do i-cont = 1 to i-nr-tab:
       create tt-estat-modulo.
       assign tt-estat-modulo.i-sequencia = i-cont.
    end.

    ASSIGN c-faturamento = "FT"
           c-pedido      = "PD"
           c-estatistica = "FT"
           c-obrigfisc   = "OF"
           c-cotacoes    = "QO".

    for each tt-estat-modulo:
        case tt-estat-modulo.i-sequencia:
             when 01 then do:
                 {utp/ut-table.i movdis nota-fiscal 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "nota-fiscal"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 02 then do:
                 {utp/ut-table.i movdis it-nota-fisc 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "it-nota-fisc"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 03 then do:
                 {utp/ut-table.i movdis it-nota-imp 1}	
                 assign tt-estat-modulo.c-tabela = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "it-nota-imp"
                        tt-estat-modulo.c-modulo = c-faturamento.
             end.
             when 04 then do:
                 {utp/ut-table.i movdis nota-trans 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "nota-trans"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 05 then do:
                 {utp/ut-table.i movdis fat-ser-lote 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "fat-ser-lote"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 06 then do:
                 {utp/ut-table.i movdis nar-it-nota 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "nar-it-nota"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 07 then do:
                 {utp/ut-table.i movdis fat-repre 1}
                 assign tt-estat-modulo.c-tabela = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "fat-repre"
                        tt-estat-modulo.c-modulo = c-faturamento.
             end.
             when 08 then do:
                 {utp/ut-table.i movdis fat-duplic 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "fat-duplic"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 09 then do:
                 {utp/ut-table.i movdis nota-embal 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "nota-embal"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 10 then do:
                 {utp/ut-table.i movdis item-embal 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "item-embal"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 11 then do:
                 {utp/ut-table.i movdis devol-cli 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "devol-cli"
                        tt-estat-modulo.c-modulo  = c-faturamento.
             end.
             when 12 then do:
                 {utp/ut-table.i movdis ped-venda 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "ped-venda"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 13 then do:
                 {utp/ut-table.i movdis ped-item 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "ped-item"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 14 then do:
                 {utp/ut-table.i movdis ped-ent 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "ped-ent"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 15 then do:
                 {utp/ut-table.i movdis his-ped-ent 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "his-ped-ent"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 16 then do:
                 {utp/ut-table.i movdis ped-repre 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "ped-repre"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 18 then do:
                 {utp/ut-table.i movdis cond-ped 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "cond-ped"
                        tt-estat-modulo.c-modulo  = c-pedido.
             end.
             when 19 then do:
                 {utp/ut-table.i movdis fat-estat 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "fat-estat"
                        tt-estat-modulo.c-modulo  = c-estatistica.
             end.
             when 20 then do:
                 {utp/ut-table.i movdis doc-fiscal 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "doc-fiscal"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 21 then do:
                 {utp/ut-table.i movdis it-doc-fisc 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "it-doc-fisc"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 22 then do:
                 {utp/ut-table.i movdis apur-imposto 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "apur-imposto"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 23 then do:
                 {utp/ut-table.i movdis imp-valor 1}	
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "imp-valor"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 24 then do:
                 {utp/ut-table.i movdis imposto-guia 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "imposto-guia"
                        tt-estat-modulo.c-modulo  = c-obrigfisc.
             end.
             when 25 then do:
                &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-ped-v 1}	
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-ped-v"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                &ENDIF           
             end.
             when 26 then do:
                &IF '{&bf_dis_versao_ems}' < "2.04" &THEN             
                    {utp/ut-table.i movdis cot-ped-i 1}	
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-ped-i"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                &ENDIF           
             end.
             when 27 then do:
                &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-nar-it 1}
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-nar-it"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                &ENDIF           
             end.
             when 28 then do:
                &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-ent	1}
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-ent"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                &ENDIF           
             end.
             when 29 then do:
                &IF '{&bf_dis_versao_ems}' < "2.04" &THEN
                    {utp/ut-table.i movdis cot-desconto	1}
                    assign tt-estat-modulo.c-tabela  = trim(return-value)
                           tt-estat-modulo.c-nom-tab = "cot-desconto"
                           tt-estat-modulo.c-modulo  = c-cotacoes.
                &ENDIF           
             end.
             when 30 then do:	
                 {utp/ut-table.i movdis con-pges 1}
                 assign tt-estat-modulo.c-tabela  = trim(return-value)
                        tt-estat-modulo.c-nom-tab = "con-pges"
                        tt-estat-modulo.c-modulo  = c-cotacoes.
             end.
            when 31 then do:	
                {utp/ut-table.i movdis ext-doc-fiscal 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "ext-doc-fiscal"
                       tt-estat-modulo.c-modulo  = c-obrigfisc.
            end.
            when 32 then do:
                {utp/ut-table.i movadm nota-fisc-social 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "nota-fisc-social"
                       tt-estat-modulo.c-modulo  = c-faturamento.
            end.
            when 33 then do:
                {utp/ut-table.i movadm item-nota-social 1}
                assign tt-estat-modulo.c-tabela  = trim(return-value)
                       tt-estat-modulo.c-nom-tab = "item-nota-social"
                       tt-estat-modulo.c-modulo  = c-faturamento.
            end.
        end.
    end.    
End Procedure.
